// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#ifndef CARBON_TOOLCHAIN_DRIVER_DRIVER_FILE_TEST_BASE_H_
#define CARBON_TOOLCHAIN_DRIVER_DRIVER_FILE_TEST_BASE_H_

#include <string>

#include "common/error.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/FormatVariadic.h"
#include "llvm/Support/VirtualFileSystem.h"
#include "testing/file_test/file_test_base.h"
#include "toolchain/driver/driver.h"

namespace Carbon::Testing {
namespace {

// Provides common test support for the driver. This is used by file tests in
// phase subdirectories.
class ToolchainFileTest : public FileTestBase {
 public:
  explicit ToolchainFileTest(llvm::StringRef test_name)
      : FileTestBase(test_name), component_(GetComponent(test_name)) {}

  auto Run(const llvm::SmallVector<llvm::StringRef>& test_args,
           llvm::vfs::InMemoryFileSystem& fs, llvm::raw_pwrite_stream& stdout,
           llvm::raw_pwrite_stream& stderr) -> ErrorOr<RunResult> override {
    CARBON_RETURN_IF_ERROR(AddFile(fs, "core/prelude.carbon"));

    Driver driver(fs, "", stdout, stderr);
    auto driver_result = driver.RunCommand(test_args);

    RunResult result{
        .success = driver_result.success,
        .per_file_success = std::move(driver_result.per_file_success)};
    // Drop entries that don't look like a file. Note this can empty out the
    // list.
    llvm::erase_if(result.per_file_success,
                   [](std::pair<llvm::StringRef, bool> entry) {
                     return entry.first == "." || entry.first == "-" ||
                            entry.first.starts_with("not_file") ||
                            entry.first.starts_with("core/");
                   });
    return result;
  }

  auto GetDefaultArgs() -> llvm::SmallVector<std::string> override {
    llvm::SmallVector<std::string> args = {"compile",
                                           "--phase=" + component_.str()};

    // For `lex` and `parse`, we don't need to import the prelude. Suppress it
    // to improve the dump output for the tests.
    if (component_ == "lex") {
      args.insert(args.end(), {"--no-prelude-import", "--dump-tokens", "%s"});
      return args;
    } else if (component_ == "parse") {
      args.insert(args.end(),
                  {"--no-prelude-import", "--dump-parse-tree", "%s"});
      return args;
    }

    if (component_ == "check") {
      args.push_back("--dump-sem-ir");
    } else if (component_ == "lower") {
      args.push_back("--dump-llvm-ir");
    } else {
      CARBON_FATAL() << "Unexpected test component " << component_ << ": "
                     << test_name();
    }

    args.insert(args.end(), {"--exclude-dump-file-prefix=core/", "%s"});
    return args;
  }

  auto GetDefaultFileRE(llvm::ArrayRef<llvm::StringRef> filenames)
      -> std::optional<RE2> override {
    if (component_ == "lex") {
      return std::make_optional<RE2>(
          llvm::formatv(R"(^- filename: ({0})$)", llvm::join(filenames, "|")));
    }
    return FileTestBase::GetDefaultFileRE(filenames);
  }

  auto GetLineNumberReplacements(llvm::ArrayRef<llvm::StringRef> filenames)
      -> llvm::SmallVector<LineNumberReplacement> override {
    auto replacements = FileTestBase::GetLineNumberReplacements(filenames);
    if (component_ == "lex") {
      replacements.push_back({.has_file = false,
                              .re = std::make_shared<RE2>(R"(line: (\s*\d+))"),
                              // The `{{{{` becomes `{{`.
                              .line_formatv = "{{{{ *}}{0}"});
    }
    return replacements;
  }

  auto DoExtraCheckReplacements(std::string& check_line) -> void override {
    if (component_ == "driver") {
      // TODO: Disable token output, it's not interesting for these tests.
      if (llvm::StringRef(check_line).starts_with("// CHECK:STDOUT: {")) {
        check_line = "// CHECK:STDOUT: {{.*}}";
      }
    } else if (component_ == "lex") {
      // Both FileStart and FileEnd regularly have locations on CHECK
      // comment lines that don't work correctly. The line happens to be correct
      // for the FileEnd, but we need to avoid checking the column.
      // The column happens to be right for FileStart, but the line is wrong.
      static RE2 file_token_re(
          R"((FileEnd.*column: |FileStart.*line: )( *\d+))");
      RE2::Replace(&check_line, file_token_re, R"(\1{{ *\\d+}})");
    } else {
      return FileTestBase::DoExtraCheckReplacements(check_line);
    }
  }

 private:
  // Adds a file to the fs.
  auto AddFile(llvm::vfs::InMemoryFileSystem& fs, llvm::StringRef path)
      -> ErrorOr<Success> {
    llvm::ErrorOr<std::unique_ptr<llvm::MemoryBuffer>> file =
        llvm::MemoryBuffer::getFile(path);
    if (file.getError()) {
      return ErrorBuilder() << file.getError().message();
    }
    if (!fs.addFile(path, /*ModificationTime=*/0, std::move(*file))) {
      return ErrorBuilder() << "Duplicate file: " << path;
    }
    return Success();
  }

  // Returns the toolchain subdirectory being tested.
  static auto GetComponent(llvm::StringRef test_name) -> llvm::StringRef {
    // This handles cases where the toolchain directory may be copied into a
    // repository that doesn't put it at the root.
    auto pos = test_name.find("toolchain/");
    CARBON_CHECK(pos != llvm::StringRef::npos) << test_name;
    test_name = test_name.drop_front(pos + strlen("toolchain/"));
    test_name = test_name.take_front(test_name.find("/"));
    return test_name;
  }

  const llvm::StringRef component_;
};

}  // namespace

CARBON_FILE_TEST_FACTORY(ToolchainFileTest);

}  // namespace Carbon::Testing

#endif  // CARBON_TOOLCHAIN_DRIVER_DRIVER_FILE_TEST_BASE_H_

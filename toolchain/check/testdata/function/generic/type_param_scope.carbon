// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE

fn F(T:! type, n: T) -> T {
  let m: T = n;
  return m;
}

// CHECK:STDOUT: --- type_param_scope.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = %Core
// CHECK:STDOUT:     .F = %F
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core: <namespace> = namespace [template] {}
// CHECK:STDOUT:   %F: <function> = fn_decl @F [template] {
// CHECK:STDOUT:     %T.loc7_6.1: type = param T
// CHECK:STDOUT:     @F.%T: type = bind_symbolic_name T, %T.loc7_6.1 [symbolic]
// CHECK:STDOUT:     %T.ref.loc7_19: type = name_ref T, @F.%T [symbolic = @F.%T]
// CHECK:STDOUT:     %n.loc7_16.1: T = param n
// CHECK:STDOUT:     @F.%n: T = bind_name n, %n.loc7_16.1
// CHECK:STDOUT:     %T.ref.loc7_25: type = name_ref T, @F.%T [symbolic = @F.%T]
// CHECK:STDOUT:     @F.%return: ref T = var <return slot>
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F(%T: type, %n: T) -> T {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %T.ref: type = name_ref T, %T [symbolic = %T]
// CHECK:STDOUT:   %n.ref: T = name_ref n, %n
// CHECK:STDOUT:   %m: T = bind_name m, %n.ref
// CHECK:STDOUT:   %m.ref: T = name_ref m, %m
// CHECK:STDOUT:   return %m.ref
// CHECK:STDOUT: }
// CHECK:STDOUT:

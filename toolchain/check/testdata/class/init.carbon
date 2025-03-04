// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE

class Class {
  var n: i32;
  var next: Class*;
}

fn Make(n: i32, next: Class*) -> Class {
  return {.n = n, .next = next};
}

fn MakeReorder(n: i32, next: Class*) -> Class {
  return {.next = next, .n = n};
}

// CHECK:STDOUT: --- init.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %Class: type = class_type @Class [template]
// CHECK:STDOUT:   %.1: type = unbound_element_type Class, i32 [template]
// CHECK:STDOUT:   %.2: type = ptr_type Class [template]
// CHECK:STDOUT:   %.3: type = unbound_element_type Class, Class* [template]
// CHECK:STDOUT:   %.4: type = struct_type {.n: i32, .next: Class*} [template]
// CHECK:STDOUT:   %.5: type = ptr_type {.n: i32, .next: Class*} [template]
// CHECK:STDOUT:   %.6: type = struct_type {.next: Class*, .n: i32} [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = %Core
// CHECK:STDOUT:     .Class = %Class.decl
// CHECK:STDOUT:     .Make = %Make
// CHECK:STDOUT:     .MakeReorder = %MakeReorder
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core: <namespace> = namespace [template] {}
// CHECK:STDOUT:   %Class.decl: type = class_decl @Class [template = constants.%Class] {}
// CHECK:STDOUT:   %Make: <function> = fn_decl @Make [template] {
// CHECK:STDOUT:     %n.loc12_9.1: i32 = param n
// CHECK:STDOUT:     @Make.%n: i32 = bind_name n, %n.loc12_9.1
// CHECK:STDOUT:     %Class.ref.loc12_23: type = name_ref Class, %Class.decl [template = constants.%Class]
// CHECK:STDOUT:     %.loc12: type = ptr_type Class [template = constants.%.2]
// CHECK:STDOUT:     %next.loc12_17.1: Class* = param next
// CHECK:STDOUT:     @Make.%next: Class* = bind_name next, %next.loc12_17.1
// CHECK:STDOUT:     %Class.ref.loc12_34: type = name_ref Class, %Class.decl [template = constants.%Class]
// CHECK:STDOUT:     @Make.%return: ref Class = var <return slot>
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %MakeReorder: <function> = fn_decl @MakeReorder [template] {
// CHECK:STDOUT:     %n.loc16_16.1: i32 = param n
// CHECK:STDOUT:     @MakeReorder.%n: i32 = bind_name n, %n.loc16_16.1
// CHECK:STDOUT:     %Class.ref.loc16_30: type = name_ref Class, %Class.decl [template = constants.%Class]
// CHECK:STDOUT:     %.loc16: type = ptr_type Class [template = constants.%.2]
// CHECK:STDOUT:     %next.loc16_24.1: Class* = param next
// CHECK:STDOUT:     @MakeReorder.%next: Class* = bind_name next, %next.loc16_24.1
// CHECK:STDOUT:     %Class.ref.loc16_41: type = name_ref Class, %Class.decl [template = constants.%Class]
// CHECK:STDOUT:     @MakeReorder.%return: ref Class = var <return slot>
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @Class {
// CHECK:STDOUT:   %.loc8: <unbound element of class Class> = field_decl n, element0 [template]
// CHECK:STDOUT:   %Class.ref: type = name_ref Class, file.%Class.decl [template = constants.%Class]
// CHECK:STDOUT:   %.loc9_18: type = ptr_type Class [template = constants.%.2]
// CHECK:STDOUT:   %.loc9_11: <unbound element of class Class> = field_decl next, element1 [template]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%Class
// CHECK:STDOUT:   .n = %.loc8
// CHECK:STDOUT:   .next = %.loc9_11
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Make(%n: i32, %next: Class*) -> %return: Class {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %n.ref: i32 = name_ref n, %n
// CHECK:STDOUT:   %next.ref: Class* = name_ref next, %next
// CHECK:STDOUT:   %.loc13_31.1: {.n: i32, .next: Class*} = struct_literal (%n.ref, %next.ref)
// CHECK:STDOUT:   %.loc13_31.2: ref i32 = class_element_access %return, element0
// CHECK:STDOUT:   %.loc13_31.3: init i32 = initialize_from %n.ref to %.loc13_31.2
// CHECK:STDOUT:   %.loc13_31.4: ref Class* = class_element_access %return, element1
// CHECK:STDOUT:   %.loc13_31.5: init Class* = initialize_from %next.ref to %.loc13_31.4
// CHECK:STDOUT:   %.loc13_31.6: init Class = class_init (%.loc13_31.3, %.loc13_31.5), %return
// CHECK:STDOUT:   %.loc13_32: init Class = converted %.loc13_31.1, %.loc13_31.6
// CHECK:STDOUT:   return %.loc13_32
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @MakeReorder(%n: i32, %next: Class*) -> %return: Class {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %next.ref: Class* = name_ref next, %next
// CHECK:STDOUT:   %n.ref: i32 = name_ref n, %n
// CHECK:STDOUT:   %.loc17_31.1: {.next: Class*, .n: i32} = struct_literal (%next.ref, %n.ref)
// CHECK:STDOUT:   %.loc17_31.2: ref i32 = class_element_access %return, element1
// CHECK:STDOUT:   %.loc17_31.3: init i32 = initialize_from %n.ref to %.loc17_31.2
// CHECK:STDOUT:   %.loc17_31.4: ref Class* = class_element_access %return, element0
// CHECK:STDOUT:   %.loc17_31.5: init Class* = initialize_from %next.ref to %.loc17_31.4
// CHECK:STDOUT:   %.loc17_31.6: init Class = class_init (%.loc17_31.3, %.loc17_31.5), %return
// CHECK:STDOUT:   %.loc17_32: init Class = converted %.loc17_31.1, %.loc17_31.6
// CHECK:STDOUT:   return %.loc17_32
// CHECK:STDOUT: }
// CHECK:STDOUT:

// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE

// --- int_sub.carbon

fn Sub(a: i32, b: i32) -> i32 = "int.ssub";

var arr: [i32; Sub(3, 2)];
let arr_p: [i32; 1]* = &arr;

fn RuntimeCall(a: i32, b: i32) -> i32 {
  return Sub(a, b);
}

// --- fail_overflow.carbon

package FailOverflow api;

fn Sub(a: i32, b: i32) -> i32 = "int.ssub";

let a: i32 = Sub(0, 0x7FFFFFFF);
let b: i32 = Sub(Sub(0, 0x7FFFFFFF), 1);
// CHECK:STDERR: fail_overflow.carbon:[[@LINE+3]]:14: ERROR: Integer overflow in calculation -2147483647 - 2.
// CHECK:STDERR: let c: i32 = Sub(Sub(0, 0x7FFFFFFF), 2);
// CHECK:STDERR:              ^~~~
let c: i32 = Sub(Sub(0, 0x7FFFFFFF), 2);

// CHECK:STDOUT: --- int_sub.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %.1: i32 = int_literal 3 [template]
// CHECK:STDOUT:   %.2: i32 = int_literal 2 [template]
// CHECK:STDOUT:   %.3: i32 = int_literal 1 [template]
// CHECK:STDOUT:   %.4: type = array_type %.3, i32 [template]
// CHECK:STDOUT:   %.5: type = ptr_type [i32; 1] [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = %Core
// CHECK:STDOUT:     .Sub = %Sub
// CHECK:STDOUT:     .arr = %arr
// CHECK:STDOUT:     .RuntimeCall = %RuntimeCall
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core: <namespace> = namespace [template] {}
// CHECK:STDOUT:   %Sub: <function> = fn_decl @Sub [template] {
// CHECK:STDOUT:     %a.loc2_8.1: i32 = param a
// CHECK:STDOUT:     @Sub.%a: i32 = bind_name a, %a.loc2_8.1
// CHECK:STDOUT:     %b.loc2_16.1: i32 = param b
// CHECK:STDOUT:     @Sub.%b: i32 = bind_name b, %b.loc2_16.1
// CHECK:STDOUT:     @Sub.%return: ref i32 = var <return slot>
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Sub.ref: <function> = name_ref Sub, %Sub [template = %Sub]
// CHECK:STDOUT:   %.loc4_20: i32 = int_literal 3 [template = constants.%.1]
// CHECK:STDOUT:   %.loc4_23: i32 = int_literal 2 [template = constants.%.2]
// CHECK:STDOUT:   %int.ssub: init i32 = call %Sub.ref(%.loc4_20, %.loc4_23) [template = constants.%.3]
// CHECK:STDOUT:   %.loc4_25: type = array_type %int.ssub, i32 [template = constants.%.4]
// CHECK:STDOUT:   %arr.var: ref [i32; 1] = var arr
// CHECK:STDOUT:   %arr: ref [i32; 1] = bind_name arr, %arr.var
// CHECK:STDOUT:   %.loc5_18: i32 = int_literal 1 [template = constants.%.3]
// CHECK:STDOUT:   %.loc5_19: type = array_type %.loc5_18, i32 [template = constants.%.4]
// CHECK:STDOUT:   %.loc5_20: type = ptr_type [i32; 1] [template = constants.%.5]
// CHECK:STDOUT:   %arr.ref: ref [i32; 1] = name_ref arr, %arr
// CHECK:STDOUT:   %.loc5_24: [i32; 1]* = addr_of %arr.ref
// CHECK:STDOUT:   %arr_p: [i32; 1]* = bind_name arr_p, %.loc5_24
// CHECK:STDOUT:   %RuntimeCall: <function> = fn_decl @RuntimeCall [template] {
// CHECK:STDOUT:     %a.loc7_16.1: i32 = param a
// CHECK:STDOUT:     @RuntimeCall.%a: i32 = bind_name a, %a.loc7_16.1
// CHECK:STDOUT:     %b.loc7_24.1: i32 = param b
// CHECK:STDOUT:     @RuntimeCall.%b: i32 = bind_name b, %b.loc7_24.1
// CHECK:STDOUT:     @RuntimeCall.%return: ref i32 = var <return slot>
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Sub(%a: i32, %b: i32) -> i32 = "int.ssub";
// CHECK:STDOUT:
// CHECK:STDOUT: fn @RuntimeCall(%a: i32, %b: i32) -> i32 {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %Sub.ref: <function> = name_ref Sub, file.%Sub [template = file.%Sub]
// CHECK:STDOUT:   %a.ref: i32 = name_ref a, %a
// CHECK:STDOUT:   %b.ref: i32 = name_ref b, %b
// CHECK:STDOUT:   %int.ssub: init i32 = call %Sub.ref(%a.ref, %b.ref)
// CHECK:STDOUT:   %.loc8_19.1: i32 = value_of_initializer %int.ssub
// CHECK:STDOUT:   %.loc8_19.2: i32 = converted %int.ssub, %.loc8_19.1
// CHECK:STDOUT:   return %.loc8_19.2
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- fail_overflow.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %.1: i32 = int_literal 0 [template]
// CHECK:STDOUT:   %.2: i32 = int_literal 2147483647 [template]
// CHECK:STDOUT:   %.3: i32 = int_literal -2147483647 [template]
// CHECK:STDOUT:   %.4: i32 = int_literal 1 [template]
// CHECK:STDOUT:   %.5: i32 = int_literal -2147483648 [template]
// CHECK:STDOUT:   %.6: i32 = int_literal 2 [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = %Core
// CHECK:STDOUT:     .Sub = %Sub
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core: <namespace> = namespace [template] {}
// CHECK:STDOUT:   %Sub: <function> = fn_decl @Sub [template] {
// CHECK:STDOUT:     %a.loc4_8.1: i32 = param a
// CHECK:STDOUT:     @Sub.%a: i32 = bind_name a, %a.loc4_8.1
// CHECK:STDOUT:     %b.loc4_16.1: i32 = param b
// CHECK:STDOUT:     @Sub.%b: i32 = bind_name b, %b.loc4_16.1
// CHECK:STDOUT:     @Sub.%return: ref i32 = var <return slot>
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Sub.ref.loc6: <function> = name_ref Sub, %Sub [template = %Sub]
// CHECK:STDOUT:   %.loc6_18: i32 = int_literal 0 [template = constants.%.1]
// CHECK:STDOUT:   %.loc6_21: i32 = int_literal 2147483647 [template = constants.%.2]
// CHECK:STDOUT:   %int.ssub.loc6: init i32 = call %Sub.ref.loc6(%.loc6_18, %.loc6_21) [template = constants.%.3]
// CHECK:STDOUT:   %.loc6_32.1: i32 = value_of_initializer %int.ssub.loc6 [template = constants.%.3]
// CHECK:STDOUT:   %.loc6_32.2: i32 = converted %int.ssub.loc6, %.loc6_32.1 [template = constants.%.3]
// CHECK:STDOUT:   %a.loc6: i32 = bind_name a, %.loc6_32.2
// CHECK:STDOUT:   %Sub.ref.loc7_14: <function> = name_ref Sub, %Sub [template = %Sub]
// CHECK:STDOUT:   %Sub.ref.loc7_18: <function> = name_ref Sub, %Sub [template = %Sub]
// CHECK:STDOUT:   %.loc7_22: i32 = int_literal 0 [template = constants.%.1]
// CHECK:STDOUT:   %.loc7_25: i32 = int_literal 2147483647 [template = constants.%.2]
// CHECK:STDOUT:   %int.ssub.loc7_21: init i32 = call %Sub.ref.loc7_18(%.loc7_22, %.loc7_25) [template = constants.%.3]
// CHECK:STDOUT:   %.loc7_38: i32 = int_literal 1 [template = constants.%.4]
// CHECK:STDOUT:   %.loc7_17.1: i32 = value_of_initializer %int.ssub.loc7_21 [template = constants.%.3]
// CHECK:STDOUT:   %.loc7_17.2: i32 = converted %int.ssub.loc7_21, %.loc7_17.1 [template = constants.%.3]
// CHECK:STDOUT:   %int.ssub.loc7_17: init i32 = call %Sub.ref.loc7_14(%.loc7_17.2, %.loc7_38) [template = constants.%.5]
// CHECK:STDOUT:   %.loc7_40.1: i32 = value_of_initializer %int.ssub.loc7_17 [template = constants.%.5]
// CHECK:STDOUT:   %.loc7_40.2: i32 = converted %int.ssub.loc7_17, %.loc7_40.1 [template = constants.%.5]
// CHECK:STDOUT:   %b.loc7: i32 = bind_name b, %.loc7_40.2
// CHECK:STDOUT:   %Sub.ref.loc11_14: <function> = name_ref Sub, %Sub [template = %Sub]
// CHECK:STDOUT:   %Sub.ref.loc11_18: <function> = name_ref Sub, %Sub [template = %Sub]
// CHECK:STDOUT:   %.loc11_22: i32 = int_literal 0 [template = constants.%.1]
// CHECK:STDOUT:   %.loc11_25: i32 = int_literal 2147483647 [template = constants.%.2]
// CHECK:STDOUT:   %int.ssub.loc11_21: init i32 = call %Sub.ref.loc11_18(%.loc11_22, %.loc11_25) [template = constants.%.3]
// CHECK:STDOUT:   %.loc11_38: i32 = int_literal 2 [template = constants.%.6]
// CHECK:STDOUT:   %.loc11_17.1: i32 = value_of_initializer %int.ssub.loc11_21 [template = constants.%.3]
// CHECK:STDOUT:   %.loc11_17.2: i32 = converted %int.ssub.loc11_21, %.loc11_17.1 [template = constants.%.3]
// CHECK:STDOUT:   %int.ssub.loc11_17: init i32 = call %Sub.ref.loc11_14(%.loc11_17.2, %.loc11_38) [template = constants.%.2]
// CHECK:STDOUT:   %.loc11_40.1: i32 = value_of_initializer %int.ssub.loc11_17 [template = constants.%.2]
// CHECK:STDOUT:   %.loc11_40.2: i32 = converted %int.ssub.loc11_17, %.loc11_40.1 [template = constants.%.2]
// CHECK:STDOUT:   %c: i32 = bind_name c, %.loc11_40.2
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Sub(%a: i32, %b: i32) -> i32 = "int.ssub";
// CHECK:STDOUT:

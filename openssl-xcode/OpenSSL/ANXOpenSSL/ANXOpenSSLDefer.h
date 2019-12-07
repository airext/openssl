//
//  ANXOpenSSLDefer.h
//  OpenSSL
//
//  Created by Max Rozdobudko on 05.12.2019.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// Copied from https://github.com/xezun/XZKit

/// defer The execution function of the closure, please do not call this function directly.
///
/// @param operation Pending cleanup operation.
FOUNDATION_EXPORT void __xz_defer__(void (^ _Nonnull * _Nonnull operation)(void)) NS_SWIFT_UNAVAILABLE("Use Swift.defer instead.");
/// The macro defer can define a block to be executed at the end of the current scope.
FOUNDATION_EXPORT void defer(void (^ _Nonnull operation)(void)) NS_SWIFT_UNAVAILABLE("Use Swift.defer instead.");
#undef defer
/// Connect two macro parameters.
#define __xz_defer_var_v__(X, Y) X##Y
/// In transit, replace the macro parameter with the value represented by the macro.
#define __xz_defer_var_m__(X, Y) __xz_defer_var_v__(X, Y)
/// Define that a cleanup operation needs to be performed at the end of the current scope.
#define defer(statements) void(^__xz_defer_var_m__(__xz_defer_var_, __COUNTER__))(void) __attribute__((cleanup(__xz_defer__), unused)) = statements

NS_ASSUME_NONNULL_END

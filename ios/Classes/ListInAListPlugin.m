#import "ListInAListPlugin.h"
#if __has_include(<list_in_a_list/list_in_a_list-Swift.h>)
#import <list_in_a_list/list_in_a_list-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "list_in_a_list-Swift.h"
#endif

@implementation ListInAListPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftListInAListPlugin registerWithRegistrar:registrar];
}
@end

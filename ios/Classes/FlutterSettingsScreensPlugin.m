#import "FlutterSettingsScreensPlugin.h"
#if __has_include(<flutter_settings_screens/flutter_settings_screens-Swift.h>)
#import <flutter_settings_screens/flutter_settings_screens-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_settings_screens-Swift.h"
#endif

@implementation FlutterSettingsScreensPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterSettingsScreensPlugin registerWithRegistrar:registrar];
}
@end

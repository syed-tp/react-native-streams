#import "SDKModule.h"
#import <Streams/Streams-Swift.h>

@implementation SDKModule
RCT_EXPORT_MODULE(); //export module to obj-c runtime.

- (void)initialize:(NSString *)organizationId
{
    if (organizationId.length == 0) { return; }
    [SDKModuleImpl.shared initialize:organizationId];
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeSDKModuleSpecJSI>(params);
}

@end

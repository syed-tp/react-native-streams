/*
 Imports for the Streams Fabric component: descriptors, props, events, helpers,
 and registration utilities to expose the component to React Native.
*/
#import "StreamsView.h"
#import <Streams/Streams-Swift.h>

#import <react/renderer/components/StreamsSpec/ComponentDescriptors.h>
#import <react/renderer/components/StreamsSpec/EventEmitters.h>
#import <react/renderer/components/StreamsSpec/Props.h>
#import <react/renderer/components/StreamsSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"

using namespace facebook::react;

@interface StreamsView () <RCTStreamsViewViewProtocol>

@end

/*
 StreamsView: Fabric component view that mounts a Swift-backed UIView and
 bridges React props to the native view for rendering.
*/
@implementation StreamsView {
    StreamsSwiftView * _swiftView;
}

/*
 Returns the ComponentDescriptor used by the React renderer for this view type.
*/
+ (ComponentDescriptorProvider)componentDescriptorProvider
{
    return concreteComponentDescriptorProvider<StreamsViewComponentDescriptor>();
}

/*
 Designated initializer called by Fabric to create the component view and mount
 the Swift-backed content view with default props.
*/
- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const StreamsViewProps>();
    _props = defaultProps;

    _swiftView = [[StreamsSwiftView alloc] init];
    self.contentView = _swiftView;
  }

  return self;
}

/*
 Fabric lifecycle hook: called when React props change. Converts C++ props to
 Objective-C types and forwards them to the Swift view, then completes the
 superclass update.
*/
- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    const auto &newViewProps = *std::static_pointer_cast<StreamsViewProps const>(props);

    NSMutableDictionary *propsDict = [NSMutableDictionary dictionary];
    propsDict[@"assetId"] = [NSString stringWithUTF8String:newViewProps.assetId.c_str()];
    propsDict[@"accessToken"] = [NSString stringWithUTF8String:newViewProps.accessToken.c_str()];
    [_swiftView updateProps:propsDict];
    
    [super updateProps:props oldProps:oldProps];
}

/*
 Factory function used during registration to return the component view class.
*/
Class<RCTComponentViewProtocol> StreamsViewCls(void)
{
    return StreamsView.class;
}

@end

/*
 Public header for the Streams Fabric component view.
 Exposes an Objective-C++ view class used by React Native's Fabric renderer.
*/
#import <React/RCTViewComponentView.h>
#import <UIKit/UIKit.h>

#ifndef StreamsViewNativeComponent_h
#define StreamsViewNativeComponent_h

NS_ASSUME_NONNULL_BEGIN

/*
 StreamsView
 A Fabric-compatible component view that mounts a Swift-backed content view
 and receives props from React. The concrete props/events are defined in the
 generated StreamsSpec. Business logic lives in the Swift/ObjC implementation.
*/
@interface StreamsView : RCTViewComponentView
@end

NS_ASSUME_NONNULL_END

#endif /* StreamsViewNativeComponent_h */

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "ZegoUIKitZIMKitPlugin.h"

FOUNDATION_EXPORT double zego_zimkitVersionNumber;
FOUNDATION_EXPORT const unsigned char zego_zimkitVersionString[];


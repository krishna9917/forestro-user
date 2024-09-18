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

#import "ZIMAudioEventHandler.h"
#import "ZIMAudioMethodHandler.h"
#import "ZIMAudioPluginConverter.h"
#import "ZegoZimAudioPlugin.h"

FOUNDATION_EXPORT double zego_zim_audioVersionNumber;
FOUNDATION_EXPORT const unsigned char zego_zim_audioVersionString[];


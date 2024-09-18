//
//  ZIMAudioEventHandler.h
//  ZIMAudioEventHandler
//
//  Copyright © 2023 Zego. All rights reserved.
//

#import "ZIMAudioDefines.h"
#import "ZIMAudioErrorCode.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Z I M Audio Event Handler

@protocol ZIMAudioEventHandler <NSObject>

@optional

/// SDK exception error notification.
///
/// Available since: 1.0.0
/// Description: When an exception is detected internally in the SDK, a
/// notification will be thrown through this callback. Use case: It is used to
/// facilitate developers to collect SDK problems and troubleshoot them. It is
/// recommended to monitor the callback and do appropriate log printing or event
/// reporting. Caution: It is not recommended that developers perform logic
/// after listening to this callback. It is only recommended for collecting and
/// troubleshooting problems.
- (void)onError:(ZIMAudioError *)errorInfo;

/// Recording start notification.
///
/// Available since: 1.0.0
/// Description: When the developer calls [startRecord] and the SDK has
/// internally prepared the audio device and is about to start recording, the
/// notification will be called back. Use case: Used by developers to update the
/// UI. Related APIs: The notification will be called back after [startRecord]
/// is called. Caution: None.
- (void)onRecorderStarted;

/// Recording completion notification.
///
/// Available since: 1.0.0
/// Description: When the developer calls [completeRecord] and the SDK completes
/// the recording and saves the recording file, the notification will be called
/// back. Use case: Used by developers to update the UI and send subsequent
/// voice messages. Related APIs: The notification will be called back after
/// [completeRecord] is called. Caution: Developers must receive this callback
/// notification before sending voice messages.
///
/// @param totalDuration Total recording duration in milliseconds
- (void)onRecorderCompleted:(int)totalDuration;

/// Recording cancellation notification.
///
/// Available since: 1.0.0
/// Description: When the developer calls [cancelRecord] and the SDK stops
/// recording and deletes the recording file, this notification will be called
/// back. Use case: Used by developers to update the UI. Related APIs: The
/// notification will be called back after [cancelRecord] is called. Caution:
/// None.
- (void)onRecorderCancelled;

/// Recording progress notification.
///
/// Available since: 1.0.0
/// Description: When recording has started, the SDK will call back progress
/// notifications every 500ms. Use case: Used by developers to update the UI.
/// Caution: None.
///
/// @param currentDuration Current recording duration in milliseconds
- (void)onRecorderProgress:(int)currentDuration;

/// Recording failure notification.
///
/// Available since: 1.0.0
/// Description: When recording starts or an exception occurs during recording
/// and the recording fails, this callback will be used to notify you. Use case:
/// Used by developers to update the UI. It is recommended that developers
/// listen to this callback and provide necessary prompts to users. Caution:
/// None.
///
/// @param errorCode Error code
- (void)onRecorderFailed:(ZIMAudioErrorCode)errorCode;

/// Play start notification.
///
/// Available since: 1.0.0
/// Description: When the developer calls [startPlay] and the SDK has internally
/// prepared the audio device and is about to start playing, the notification
/// will be called back. Use case: Used by developers to update the UI. Related
/// APIs: The notification will be called back after [startPlay] is called.
/// Caution: None.
///
/// @param totalDuration Total playing duration in milliseconds
- (void)onPlayerStarted:(int)totalDuration;

/// Playback end notification.
///
/// Available since: 1.0.0
/// Description: When the user has finished playing the audio file, the
/// notification will be called back. Use case: Used by developers to update the
/// UI. Caution: None.
- (void)onPlayerEnded;

/// Play stop notification.
///
/// Available since: 1.0.0
/// Description: When the developer calls [stopPlay], the SDK will immediately
/// stop the currently playing audio and call back this notification. Use case:
/// Used by developers to update the UI. Related APIs: The notification will be
/// called back after [stopPlay] is called. Caution: None.
- (void)onPlayerStopped;

/// Playback progress callback.
///
/// Available since: 1.0.0
/// Description: When playback has started, the SDK will call back progress
/// notifications every 500ms. Use case: Used by developers to update the UI.
/// Caution: None.
///
/// @param currentDuration Current playing duration in milliseconds
- (void)onPlayerProgress:(int)currentDuration;

/// Notification that playback has been interrupted.
///
/// Available since: 1.0.0
/// Description: When playback is interrupted by other actions, the SDK will
/// call back this notification. For example, recording is started during
/// playback, an incoming call event from the system is received during
/// playback, the audio device is preempted by other apps during playback, etc.
/// Use case: Used by developers to update the UI.
/// Caution: None.
- (void)onPlayerInterrupted;

/// Playback failure notification.
///
/// Available since: 1.0.0
/// Description: When playback starts or an exception occurs during playback and
/// the playback fails, this callback will be used to notify you. Use case: Used
/// by developers to update the UI. It is recommended that developers listen to
/// this callback and provide necessary prompts to users. Caution: None.
///
/// @param errorCode Error code
- (void)onPlayerFailed:(ZIMAudioErrorCode)errorCode;

@end

NS_ASSUME_NONNULL_END

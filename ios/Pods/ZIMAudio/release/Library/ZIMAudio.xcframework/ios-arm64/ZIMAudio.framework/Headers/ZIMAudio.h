//
//  ZIMAudio.h
//  ZIMAudio
//
//  Copyright © 2023 Zego. All rights reserved.
//

#import "ZIMAudioEventHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZIMAudio : NSObject

/// Gets the SDK's version number.
///
/// Available since: 1.0.0
/// Description: If you encounter an abnormality during the running of the SDK,
/// you can submit the problem, log and other information to the ZEGO technical
/// staff to locate and troubleshoot. Developers can also collect current SDK
/// version information through this API, which is convenient for App operation
/// statistics and related issues. When to call: Any time. Restrictions: None.
/// Caution: None.
///
/// @return SDK version.
+ (NSString *)getVersion;

/// Set up SDK advanced configuration, please contact ZEGO technical support
/// before use.
///
/// Available since: 1.0.0
/// Description: When the default behavior of the SDK cannot meet the
/// developer's usage scenario, this API can be called to implement
/// developer-defined advanced configuration. When to call: Must be called
/// before [init], otherwise it will only take effect after the next [init].
/// Restrictions: None.
/// Caution: Please contact ZEGO technical support before use.
///
/// @param key Key for advanced configuration
/// @param value Value for advanced configuration
+ (void)setAdvancedConfigWithKey:(NSString *)key value:(NSString *)value;

/// Get SDK singleton object.
///
/// Available since: 1.0.0
/// Description: When using ZIMAudio SDK, developers should directly call this
/// API to obtain the internal singleton object without creating and maintaining
/// the object themselves. When to call: Any time. Restrictions: None. Caution:
/// None.
///
/// @return SDK singleton object for subsequent API calls
+ (ZIMAudio *)sharedInstance;

/// Init ZIMAudio SDK
///
/// Available since: 1.0.0
/// Description: When using other functional interfaces of ZIMAudio SDK, this
/// API must be called first for initialization. When to call: Call before
/// calling other APIs. Restrictions: When no authentication information is
/// passed in or the authentication information is incorrect, the initialization
/// of the SDK can proceed normally, but subsequent use of some functions that
/// require authentication will be restricted. Caution: None.
///
/// @param license License info. If developers do not obtain it through the
/// server API, they can pass in an empty string, but subsequent use of some
/// functions that require authentication will be restricted.
- (void)initWithLicense:(NSString *)license;

/// Uninit ZIMAudio SDK
///
/// Available since: 1.0.0
/// Description: When you no longer need to use ZIMAudio SDK, you can call this
/// API to deinitialize and release memory resources. When to call: Any time.
/// Restrictions: None.
/// Caution: None.
- (void)uninit;

/// Sets up the event notification callbacks that need to be handled.
///
/// Available since: 1.0.0
/// Description: Set event notification callbacks to monitor callbacks such as
/// recorder and player life cycle events. When to call: After [init].
/// Restrictions: None.
/// Caution: When the API is called multiple times and different eventHandler
/// objects are passed in, the last object will overwrite the previously set
/// object; when the eventHandler object passed in by the API is empty, the
/// event callback notification is cancelled.
///
/// @param eventHandler Event notification callback. If the eventHandler is set
/// to [nil], all the callbacks set previously will be cleared. Developers
/// should monitor the corresponding callbacks according to their own business
/// scenarios. The main callback functions of the SDK are here.
- (void)setEventHandler:(nullable id<ZIMAudioEventHandler>)eventHandler;

/// Enables or disables active noise suppression (ANS, aka ANC).
///
/// Available since: 1.0.0
/// Description: After turning on this function, the human voice can be made
/// clearer. This function is better at suppressing continuous noise (such as
/// the sound of rain and other white noise). Use case: This feature can be
/// turned on when noise suppression is needed to improve the vocal quality and
/// user experience of recorded audio. When to call: Called at any time after
/// [init]. Caution: This API can only be called normally after the
/// authentication is within the legal usage period, or the use is allowed in
/// the authentication information; otherwise, an error message will be reported
/// that the authentication has expired or this feature is not supported.
/// Restrictions: None.
///
/// @param enable Whether to enable noise suppression, YES: enable, NO: disable
- (void)enableANS:(BOOL)enable;

/// Enables or disables automatic gain control (AGC).
///
/// Available since: 1.0.0
/// Description: After turning on this function, the SDK can automatically
/// adjust the microphone volume to adapt to far and near pickup and keep the
/// volume stable. Use case: This feature can be turned on when volume stability
/// needs to be ensured to improve the vocal quality and user experience of
/// recorded audio. When to call: Called at any time after [init]. Caution: This
/// API can only be called normally after the authentication is within the legal
/// usage period, or the use is allowed in the authentication information;
/// otherwise, an error message will be reported that the authentication has
/// expired or this feature is not supported. Restrictions: None.
///
/// @param enable Whether to enable automatic gain control, YES: enable, NO:
/// disable
- (void)enableAGC:(BOOL)enable;

/// Set noise suppression parameters, currently only includes noise suppression
/// mode.
///
/// Available since: 1.0.0
/// Description: When noise suppression is turned on using [enableANS], you can
/// use this function to switch between different noise suppression modes to
/// control the degree of noise suppression. Use case: When the default noise
/// suppression effect does not meet expectations, you can use this function to
/// adjust the noise suppression mode. Default value: When this function is not
/// called, the default noise suppression mode is [Medium]. When to call: Called
/// at any time after [init]. Caution: This API can only be called normally
/// after the authentication is within the legal usage period, or the use is
/// allowed in the authentication information; otherwise, an error message will
/// be reported that the authentication has expired or this feature is not
/// supported. Restrictions: None.
///
/// @param param ANS parameters, including ANS mode
- (void)setANSParam:(ZIMAudioANSParam *)param;

/// Start record audio file.
///
/// Available since: 1.0.0
/// Description: Start recording audio files. The SDK will apply to the system
/// to use the microphone device to collect audio and write it to a local file.
/// Use case: Before the user need to send voice messages, they can call this
/// API to collect and generate the voice files required for sending. The
/// recording files will eventually be saved to the path set locally. When to
/// call: After [init]. Related APIs: When this API is called to start
/// recording, the SDK will throw the [onRecorderStarted] notification. Only
/// after receiving this callback notification can the developer consider that
/// recording has officially started and updated the UI display; after that, the
/// SDK will call back the recording progress through [onRecorderProgress];
/// under abnormal circumstances, the SDK may also throw an [onRecorderFailed]
/// notification, please Developers may monitor and alert users when exceptions
/// occur as appropriate. Caution: Developers are requested to ensure that they
/// have obtained the audio collection permission of the app before using this
/// API; when the SDK starts recording, it will exclusively have the right to
/// use the audio device, so it will interrupt the playback and other behaviors
/// of other third-party apps. Restrictions: Recording-related APIs cannot be
/// used at the same time as playback-related APIs. At the same time, only
/// recording or playback can be performed inside the SDK. Therefore, before you
/// need to start recording, developers are required to actively stop the
/// playback function, otherwise the playback-related functions will also be
/// stopped before the SDK starts recording.
///
/// @param config Record config
- (void)startRecordWithConfig:(ZIMAudioRecordConfig *)config;

/// Complete record audio file.
///
/// Available since: 1.0.0
/// Description: Finish recording the audio file. After calling this API, the
/// recording file will be generated in the file path passed in [startRecord]
/// and saved. Use case: After completing the recording, the developer can send
/// the recording file as an IM message. For example, it is passed to ZIM's
/// AudioMessage to send voice messages. When to call: [startRecord] Recording
/// is taking effect. Related APIs: When this API is called and recording is
/// successfully completed, the SDK throws the [onRecorderCompleted]
/// notification. Developers must receive this callback notification before
/// sending voice messages. Caution: If the developer does not call this API to
/// end the recording while [startRecord] is in effect, the recording will still
/// be completed and the file will be saved when the maximum recording duration
/// of [startRecord] is reached. After completing the recording, the SDK will
/// release the occupation of the audio device. Restrictions: Recording-related
/// APIs cannot be used at the same time as playback-related APIs. At the same
/// time, only recording or playback can be performed inside the SDK.
- (void)completeRecord;

/// Cancel record audio file.
///
/// Available since: 1.0.0
/// Description: Interrupt recording audio file. After calling this API,
/// recording will be stopped, and the local file will be deleted internally by
/// the SDK. Use case: When you need to stop recording early during the
/// recording process and do not need to send a voice message, you can call this
/// API to cancel the recording. When to call: [startRecord] Recording is taking
/// effect. Related APIs: When this API is called to cancel recording, the SDK
/// will throw the [onRecorderCancelled] notification. Developers can clean up
/// related resources and update UI display based on this notification. Caution:
/// After canceling the recording, the SDK will release the occupation of the
/// audio device. Restrictions: Recording-related APIs cannot be used at the
/// same time as playback-related APIs. At the same time, only recording or
/// playback can be performed inside the SDK.
- (void)cancelRecord;

/// Get whether recording is taking place.
///
/// Available since: 1.0.0
/// Description: Get whether the SDK is recording at the current moment.
/// Use case: When developers need to obtain and detect the recording status at
/// a certain moment, they can call this API to obtain the recording status.
/// When to call: Called at any time after [init].
/// Caution: None.
/// Restrictions: None.
///
/// @return The return value whether is recording
- (BOOL)isRecording;

/// Set audio routing type.
///
/// Available since: 1.0.0
/// Description: Set the audio routing type to choose whether to use speakers or
/// earpieces to play audio. Use case: When developers need to have the option
/// for users to choose where the sound is played from, they can call this API
/// to change the audio routing type currently being played. When to call:
/// Called at any time after [init]. Caution: When the user is currently using
/// headphones for audio playback, the settings of this API will not take
/// effect. Restrictions: None.
///
/// @param routeType Audio routing type, the default is that the sound is played
/// from the speaker.
- (void)setAudioRouteType:(ZIMAudioRouteType)routeType;

/// Start playing audio file.
///
/// Available since: 1.0.0
/// Description: Start playing the audio file. The SDK will read the audio file
/// in the specified path and play it. Use case: After the user receives the
/// voice message, the API can be called to play the audio file that has been
/// downloaded and saved locally. When to call: After [init]. Related APIs: When
/// this API is called to start playback, the SDK will throw the
/// [onPlayerStarted] notification. Only after receiving this callback
/// notification can the developer consider that playback has officially started
/// and update the UI display; after that, the SDK will call back the playback
/// progress through [onPlayerProgress]; under abnormal circumstances, the SDK
/// may also throw an [onPlayerFailed] notification, please Developers may
/// monitor and alert users when exceptions occur as appropriate. Caution: When
/// the SDK starts playing, it will exclusively use the audio device, so it will
/// interrupt the playback of other third-party apps and will not mix with the
/// audio output of other apps. Restrictions: Playback-related APIs cannot be
/// used at the same time as recording-related APIs. At the same time, only
/// recording or playback can be performed inside the SDK. Therefore, before you
/// need to enable playback, developers must first ensure that the recording
/// function is not being used at this time, otherwise playback will fail.
///
/// @param config Play config
- (void)startPlayWithConfig:(ZIMAudioPlayConfig *)config;

/// Stop playing audio file.
///
/// Available since: 1.0.0
/// Description: Stops the audio currently being played by the SDK.
/// Use case: When you need to stop audio playback in advance during playback,
/// you can call this API to stop playback. If the user needs to immediately
/// play the next piece of audio, he needs to stop the playback of the previous
/// piece of audio; or when he is about to leave the playback page, he should
/// also stop the current playback. When to call: [startPlay] During playback.
/// Related APIs: When this API is called to stop playback, the SDK will throw
/// the [onPlayerStopped] notification. Developers can update the UI display
/// based on this callback notification. Caution: After stopping playback or
/// completing playback, the SDK will release the occupation of the audio
/// device. Restrictions: Playback-related APIs cannot be used at the same time
/// as recording-related APIs. At the same time, only recording or playback can
/// be performed inside the SDK. Therefore, before you need to enable playback,
/// developers must first ensure that the recording function is not being used
/// at this time, otherwise playback will fail.
- (void)stopPlay;

/// Get whether it is playing.
///
/// Available since: 1.0.0
/// Description: Get whether the SDK is playing at the current moment.
/// Use case: When developers need to obtain and detect the playback status at a
/// certain moment, they can call this API to obtain the playback status. When
/// to call: Called at any time after [init]. Related APIs: Caution: None.
/// Restrictions: None.
///
/// @return The return value whether is playing
- (BOOL)isPlaying;

/// This function is unavailable.
///
/// Please use [initWithLicense:] instead
- (instancetype)init NS_UNAVAILABLE;

/// This function is unavailable.
///
/// Please use [initWithLicense:] instead
- (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

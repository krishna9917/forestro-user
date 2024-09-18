#ifndef __ZIM_AUDIO_DEFINES_H__
#define __ZIM_AUDIO_DEFINES_H__

//
//  zim_audio_defines.h
//  ZIMAudio
//
//  Copyright © 2023 Zego. All rights reserved.
//

/* Macros which declare an exportable function */
#define ZIM_AUDIO_API

/* Macros which declare an exportable variable */
#define ZIM_AUDIO_VAR extern

/* Macros which declare the called convention for exported functions */
#define ZIM_AUDIO_CALL

#if defined(_WIN32) /* For MSVC */
#undef ZIM_AUDIO_API
#undef ZIM_AUDIO_VAR
#undef ZIM_AUDIO_CALL
#if defined(ZIM_AUDIO_EXPORTS)
#define ZIM_AUDIO_API __declspec(dllexport)
#define ZIM_AUDIO_VAR __declspec(dllexport)
#elif defined(ZIM_AUDIO_STATIC)
#define ZIM_AUDIO_API // Nothing
#define ZIM_AUDIO_VAR // Nothing
#else
#define ZIM_AUDIO_API __declspec(dllimport)
#define ZIM_AUDIO_VAR __declspec(dllimport) extern
#endif
#define ZIM_AUDIO_CALL __cdecl
#define ZIM_AUDIO_DISABLE_DEPRECATION_WARNINGS                                                     \
    __pragma(warning(push)) __pragma(warning(disable : 4996))
#define ZIM_AUDIO_ENABLE_DEPRECATION_WARNINGS __pragma(warning(pop))
#pragma warning(disable : 4068) /* Ignore 'unknown pragma mark' warning */
#else                           /* For GCC or clang */
#undef ZIM_AUDIO_API
#define ZIM_AUDIO_API __attribute__((visibility("default")))
#define ZIM_AUDIO_DISABLE_DEPRECATION_WARNINGS                                                     \
    _Pragma("GCC diagnostic push") _Pragma("GCC diagnostic ignored \"-Wdeprecated-declarations\"")
#define ZIM_AUDIO_ENABLE_DEPRECATION_WARNINGS _Pragma("GCC diagnostic pop")
#endif

#ifdef __cplusplus
#define ZIM_AUDIO_EXTERN_BEGIN extern "C" {
#define ZIM_AUDIO_EXTERN_END }
#else
#define ZIM_AUDIO_EXTERN_BEGIN
#define ZIM_AUDIO_EXTERN_END
#endif

/* Compatibility for C */
#ifndef __cplusplus
#include <stdbool.h>
#endif

#if defined(__APPLE_OS__) || defined(__APPLE__)
#include "TargetConditionals.h"
#endif

/// Definition of the error code
#include "zim_audio_error_code.h"

#define ZIM_AUDIO_MAX_COMMON_LEN (512)

/**
 * Active Noise Suppression mode.
 */
enum zim_audio_ans_mode {

    /**
   * Aggressive ANS. It may significantly impair the sound quality,
   * but it has a good noise reduction effect.
   */
    zim_audio_ans_mode_aggressive = 0,

    /**
   * Medium ANS. It may damage some sound quality,
   * but it has a good noise reduction effect.
   */
    zim_audio_ans_mode_medium = 1,

    /**
   * Soft ANS. In most instances, the sound quality will not be damaged,
   * but some noise will remain.
   */
    zim_audio_ans_mode_soft = 2,

    /**
   * AI mode ANS. It will cause great damage to music, so it can not be used for
   * noise suppression of sound sources that need to collect background sound.
   * Please contact ZEGO technical support before use.
   */
    zim_audio_ans_mode_ai = 3,

    /**
   * Balanced AI ANS. It will cause great damage to music, so it can not be used
   * for noise suppression of sound sources that need to collect background
   * sound. Please contact ZEGO technical support before use.
   */
    zim_audio_ans_mode_balanced_ai = 4

};

/**
 * Audio route type
 *
 * Available since: 1.3.0
 */
enum zim_audio_route_type {

    /**
   * Speaker type, typically the loudly playback sound will be
   * captured back to the microphone.
   */
    zim_audio_route_type_speaker = 0,

    /**
   * Headphone type, typically the playback sound is routed to the headphone
   * (headset, receiver, ...) and will not be captured back to the microphone.
   */
    zim_audio_route_type_receiver = 1,

};

// MARK: - Model

/**
 * Error information.
 *
 * Description: Error infomation.
 *
 */
struct zim_audio_error {

    /**
   * Detailed description: Error code enumeration value.
   */
    enum zim_audio_error_code code;

    /**
   * Description: Error information description.
   */
    const char *message;
};

/**
 * ANS parameters
 */
struct zim_audio_ans_param {

    /**
   * Active noise suppression mode
   *
   * Available since: 1.3.0
   */
    enum zim_audio_ans_mode mode;
};

/**
 * Parameter object for audio frame.
 *
 * Including the sampling rate and channel of the audio frame.
 *
 */
struct zim_audio_frame_param {

    /**
   * Sampling Rate
   */
    int sample_rate;

    /**
   * Audio channel number
   */
    int channels;
};

struct zim_audio_record_config {
    /**
   * The recorded file path
   */
    char *file_path;
    /**
   * The max duration need to record
   */
    int max_duration;
};

struct zim_audio_play_config {
    /**
   * The recorded file path
   */
    char *file_path;
    /**
   * Audio playing type
   */
    zim_audio_route_type route_type;
};

struct zim_audio_decode_config {
    /**
   * The recorded file path
   */
    char *file_path;

    int duration_interval;
};

#endif //__ZSE_DEFINES_H__

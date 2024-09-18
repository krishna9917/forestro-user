#ifndef __ZIM_AUDIO_ERROR_CODE_H__
#define __ZIM_AUDIO_ERROR_CODE_H__

//
//  zim_audio_error_code.h
//  ZIMAudio
//
//  Copyright © 2023 Zego. All rights reserved.
//

/**
 * The define of error code.
 *
 * Description: Developers can find the details of the error code in the
 * developer documentation website according to the error code. Use cases: It
 * can be used to collect and record errors in the process of using the SDK.
 *
 */
enum zim_audio_error_code {

    /**
   * Description: Success without exception.
   * Use cases: Used to indicate that the operation is executed correctly.
   */
    zim_audio_error_code_success = 0,

    /**
   * Description: Failed due to internal system exceptions.
   * Solutions: Contact ZEGO technical support to deal with it.
   */
    zim_audio_error_code_unknown_failed = 1,

    /**
   * Description: The engine is not initialized and cannot call non-static
   * functions. Cause: Engine not created. Solutions: Please call the [create]
   * function to create the engine first, and then call the current function.
   */
    zim_audio_error_code_not_init = 2,

    zim_audio_error_code_invalid_path = 3,

    zim_audio_error_code_invalid_input_param = 4,

    zim_audio_error_code_file_open_error = 5,

    zim_audio_error_code_no_space_left = 6,

    zim_audio_error_code_no_permission = 7,

    zim_audio_error_code_io_error = 8,

    zim_audio_error_code_encode_error = 11,

    zim_audio_error_code_decode_error = 12,

    zim_audio_error_code_api_call_error = 13,

    zim_audio_error_code_internal_logic_error = 14,

    zim_audio_error_code_logger_internal_error = 15,

    zim_audio_error_code_recorder_generic_error = 31,

    zim_audio_error_code_recorder_time_too_short = 32,

    zim_audio_error_code_player_generic_error = 51,

    /**
   * Description: The license format is invalid.
   * Cause: The incoming license string is wrong, maybe some characters are
   * missing from the copy. Solutions: Please check whether the license string
   * is copied correctly and completely.
   */
    zim_audio_error_code_license_format_invalid = 81,

    /**
   * Description: The license is expired.
   * Solutions: Contact ZEGO technical support.
   */
    zim_audio_error_code_license_expired = 82,

    /**
   * Description: The license does not contain authorization for current
   * feature. Solutions: Contact ZEGO technical support.
   */
    zim_audio_error_code_license_feature_invalid = 83,

};

#endif //__ZIM_AUDIO_ERROR_CODE_H__

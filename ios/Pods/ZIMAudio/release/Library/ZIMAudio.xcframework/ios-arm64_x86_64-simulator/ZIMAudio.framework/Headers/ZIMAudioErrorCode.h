

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZIMAudioErrorCode) {

    /// Success without exception.
    ZIMAudioErrorCodeSuccess = 0,

    /// Description: Unknown error, please contact ZEGO technical support for
    /// troubleshooting and resolution.
    ZIMAudioErrorCodeUnknownFailed = 1,

    /// Description: The SDK called other APIs without initialization. Please
    /// initialize the SDK first.
    ZIMAudioErrorCodeNotInit = 2,

    /// Description: The SDK has identified an illegal path. Developers are asked
    /// to check the legality of the parameters.
    ZIMAudioErrorCodeInvalidPath = 3,

    /// Description: The developer passed in illegal parameters, causing an error.
    /// Please check the legality of the parameters.
    ZIMAudioErrorCodeInvalidInputParam = 4,

    /// Description: The target file cannot be opened. The file format or content
    /// may be incorrect.
    ZIMAudioErrorCodeFileOpenError = 5,

    /// Description: Insufficient space when writing the file, please check
    /// whether the disk space is sufficient to use the SDK functions normally.
    ZIMAudioErrorCodeNoSpaceLeft = 6,

    /// Description: The SDK does not have read and write permissions for this
    /// path. Developers are asked to check the configuration of permissions.
    ZIMAudioErrorCodeNoPermission = 7,

    /// Description: There is an error in IO, please contact ZEGO technical
    /// support for troubleshooting and resolution.
    ZIMAudioErrorCodeIoError = 8,

    /// Description: There is an error in encoding, please contact ZEGO technical
    /// support for troubleshooting and resolution.
    ZIMAudioErrorCodeEncodeError = 11,

    /// Description: There is an error in decoding, please contact ZEGO technical
    /// support for troubleshooting and resolution.
    ZIMAudioErrorCodeDecodeError = 12,

    /// Description: API call error, please contact ZEGO technical support for
    /// troubleshooting and resolution.
    ZIMAudioErrorCodeApiCallError = 13,

    /// Description: An internal logic anomaly causes an error. Please contact
    /// ZEGO technical support for troubleshooting and resolution.
    ZIMAudioErrorCodeInternalLogicError = 14,

    /// Description: An exception occurs in the internal log module. Please
    /// contact ZEGO technical support for troubleshooting and resolution.
    ZIMAudioErrorCodeLoggerInternalError = 15,

    /// Description: A general error occurs in the recorder. Please contact ZEGO
    /// technical support for troubleshooting and resolution.
    ZIMAudioErrorCodeRecorderGenericError = 31,

    /// Description: The recording time is too short. Developers are asked to
    /// control the frequency of calls to complete recording.
    ZIMAudioErrorCodeRecorderTimeTooShort = 32,

    /// Description: A general error occurs in the player. Please contact ZEGO
    /// technical support for troubleshooting and resolution.
    ZIMAudioErrorCodePlayerGenericError = 51,

    /// Description: The format of the authentication file is incorrect. Please
    /// check whether the authentication content is correct.
    ZIMAudioErrorCodeLicenseFormatInvalid = 81,

    /// Description: The content of the authentication file has expired. Please
    /// reapply for the authentication file and initialize the SDK again.
    ZIMAudioErrorCodeLicenseExpired = 82,

    /// Description: A feature that is not supported in the authentication file is
    /// turned on. Please contact ZEGO technical support to activate the
    /// corresponding feature.
    ZIMAudioErrorCodeLicenseFeatureInvalid = 83,

};

NS_ASSUME_NONNULL_END

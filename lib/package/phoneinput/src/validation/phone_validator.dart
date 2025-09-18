import 'package:foreastro/package/phoneinput/src/number_parser/models/iso_code.dart';
import 'package:foreastro/package/phoneinput/src/number_parser/models/phone_number.dart';
import 'package:foreastro/package/phoneinput/src/number_parser/models/phone_number_type.dart';

typedef PhoneNumberInputValidator = String? Function(PhoneNumber? phoneNumber);

class PhoneValidator {
  /// allow to compose several validators
  /// Note that validator list order is important as first
  /// validator failing will return according message.
  static PhoneNumberInputValidator compose(
    List<PhoneNumberInputValidator> validators,
  ) {
    return (valueCandidate) {
      for (var validator in validators) {
        final validatorResult = validator.call(valueCandidate);
        if (validatorResult != null) {
          return validatorResult;
        }
      }
      return null;
    };
  }

  static PhoneNumberInputValidator required({
    /// custom error message
    String? errorText,
  }) {
    return (PhoneNumber? valueCandidate) {
      if (valueCandidate == null || (valueCandidate.nsn.trim().isEmpty)) {
        return errorText ?? 'requiredPhoneNumber';
      }
      return null;
    };
  }

  static PhoneNumberInputValidator valid({
    /// custom error message
    String? errorText,

    /// determine whether a missing value should be reported as invalid
    bool allowEmpty = true,
  }) {
    
    return (PhoneNumber? valueCandidate) {
      if (valueCandidate == null && !allowEmpty) {
        return errorText ?? 'invalidPhoneNumber';
      }
      if (valueCandidate != null &&
          (!allowEmpty || valueCandidate.nsn.isNotEmpty) &&
          !valueCandidate.isValid()) {
        return errorText ?? 'invalidPhoneNumber';
      }
      return null;
    };
  }

  static PhoneNumberInputValidator validType(
    /// expected phonetype
    PhoneNumberType expectedType, {
    /// custom error message
    String? errorText,

    /// determine whether a missing value should be reported as invalid
    bool allowEmpty = true,
  }) {
    final defaultMessage = expectedType == PhoneNumberType.mobile
        ? 'invalidMobilePhoneNumber'
        : 'invalidFixedLinePhoneNumber';
    return (PhoneNumber? valueCandidate) {
      if (valueCandidate != null &&
          (!allowEmpty || valueCandidate.nsn.isNotEmpty) &&
          !valueCandidate.isValid(type: expectedType)) {
        return errorText ?? defaultMessage;
      }
      return null;
    };
  }

  /// convenience shortcut method for
  /// invalidType(context, PhoneNumberType.fixedLine, ...)
  static PhoneNumberInputValidator validFixedLine({
    /// custom error message
    String? errorText,

    /// determine whether a missing value should be reported as invalid
    bool allowEmpty = true,
  }) =>
      validType(
        PhoneNumberType.fixedLine,
        errorText: errorText,
        allowEmpty: allowEmpty,
      );

  /// convenience shortcut method for
  /// invalidType(context, PhoneNumberType.mobile, ...)
  static PhoneNumberInputValidator validMobile({
    /// custom error message
    String? errorText,

    /// determine whether a missing value should be reported as invalid
    bool allowEmpty = true,
  }) =>
      validType(
        PhoneNumberType.mobile,
        errorText: errorText,
        allowEmpty: allowEmpty,
      );

  static PhoneNumberInputValidator validCountry(
    /// list of valid country isocode
    List<IsoCode> expectedCountries, {
    /// custom error message
    String? errorText,

    /// determine whether a missing value should be reported as invalid
    bool allowEmpty = true,
  }) {
    return (PhoneNumber? valueCandidate) {
      if (valueCandidate != null &&
          (!allowEmpty || valueCandidate.nsn.isNotEmpty) &&
          !expectedCountries.contains(valueCandidate.isoCode)) {
        return errorText ?? 'invalidCountry';
      }
      return null;
    };
  }

  static PhoneNumberInputValidator get none => (PhoneNumber? valueCandidate) {
        return null;
      };
}

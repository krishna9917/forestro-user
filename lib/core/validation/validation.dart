class Validator {
  /// Full Name
  static String? fullName(String fullName) {
    final regex = RegExp(r'^[a-zA-Z]+(?:[ -][a-zA-Z]+)*$');

    if (fullName.isEmpty) {
      return 'Name cannot be empty';
    }

    if (!regex.hasMatch(fullName)) {
      return 'Enter a valid full name';
    }

    return null;
  }

  /// Email
  static String? email(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (email.isEmpty) {
      return 'Email cannot be empty';
    }

    if (!regex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Email
  static String? aadhar(String aadhar) {
    final regex = RegExp(r'^\d{12}$');

    if (aadhar.isEmpty) {
      return 'Adhaar ID cannot be empty';
    }

    if (!regex.hasMatch(aadhar)) {
      return 'Please enter a valid Adhaar ID number';
    }

    return null;
  }

  /// Pan
  static String? pan(String pan) {
    final regex = RegExp(r'^[A-Za-z0-9]{10}$');

    if (pan.isEmpty) {
      return 'PAN No. cannot be empty';
    }

    if (!regex.hasMatch(pan)) {
      return 'Please enter a valid PAN No.';
    }

    return null;
  }

  static String? ifsc(String pan) {
    final regex = RegExp(r'^[A-Za-z0-9]{10}$');

    if (pan.isEmpty) {
      return 'IFSC Code. cannot be empty';
    }

    if (!regex.hasMatch(pan)) {
      return 'Please enter a valid Bank Ifsc Code';
    }

    return null;
  }

  /// Phone Num
  static String? phoneNum(String pan) {
    final regex = RegExp(r'^\d{10}$');

    if (pan.isEmpty) {
      return 'Phone No. cannot be empty';
    }

    if (!regex.hasMatch(pan)) {
      return 'Please enter a valid Phone No.';
    }

    return null;
  }

  static String? onlyText(String text, String type) {
    final regex = RegExp(r'^[A-Za-z ]+$');

    if (text.isEmpty) {
      return '$type cannot be empty';
    }

    if (!regex.hasMatch(text)) {
      return 'Please enter a valid $type';
    }

    return null;
  }

  static String? onlyNum(String text, String type) {
    final regex = RegExp(r'^\d+$');

    if (text.isEmpty) {
      return '$type cannot be empty';
    }

    if (!regex.hasMatch(text)) {
      return 'Please enter a valid $type';
    }

    return null;
  }

  static String? text(String text, String type) {
    if (text.isEmpty) {
      return '$type cannot be empty';
    }

    return null;
  }
}

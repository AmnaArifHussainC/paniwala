class ValidationUtils {
  // Validate Full Name
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    return null;
  }

  // Validate Email
  static String? validateEmail(String? value) {
    print("Validating Email: '$value'"); // Debugging Print Statement

    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email';
    }

    return null;
  }


  // Validate Password
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    if (value.trim().length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  // Validate Confirm Password
  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.trim().isEmpty) {
      return 'Confirm password is required';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Validate CNIC
  static String? validateCNIC(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'CNIC is required';
    }
    final cnicRegex = RegExp(r'^\d{13}$'); // Validates 13 numeric characters
    if (!cnicRegex.hasMatch(value.trim())) {
      return 'Enter a valid CNIC (13 digits)';
    }
    return null;
  }

  // Validate Phone Number
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^\d{10,11}$'); // Validates 10-11 numeric characters
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Enter a valid phone number (10-11 digits)';
    }
    return null;
  }

  // Validate PDF Upload
  static String? validatePDFUpload(String? fileName) {
    if (fileName == null || fileName.trim().isEmpty) {
      return 'Water filter certificate is required';
    }
    if (!fileName.endsWith('.pdf')) {
      return 'Only PDF files are allowed';
    }
    return null;
  }

  // Validate Delivery Area
  static String? validateDeliveryArea(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Delivery area is required';
    }
    return null;
  }

  }

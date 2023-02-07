final emailValidatorReg = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

final nameValidatorReg = RegExp(r"^[a-z A-Z]+$");

final phoneValidatorReg = RegExp(r"^[+][9][6][6][0-9]{9}$");

String? emailValidator(value) {
  if (value!.trim().isEmpty || !emailValidatorReg.hasMatch(value)) {
    return 'Please enter a valid email';
  }
  return null;
}

String? passwordValidator(value) {
  if (value!.trim().isEmpty || value.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}

String? nameValidator(value) {
  if (value!.trim().isEmpty || !nameValidatorReg.hasMatch(value)) {
    return 'Please enter a valid name';
  }
  return null;
}

String? phoneNumberValidator(value) {
  if (value!.trim().isEmpty || !phoneValidatorReg.hasMatch(value)) {
    return 'Please enter a valid phone number';
  }
  return null;
}

String? workshopNameValidator(value) {
  if (value!.trim().isEmpty ) {
    return 'Please enter your workshop name';
  }
  return null;
}

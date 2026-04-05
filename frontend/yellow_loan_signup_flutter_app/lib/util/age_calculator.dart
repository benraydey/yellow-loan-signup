import 'package:flutter/material.dart';
import 'package:form_utils/form_utils.dart';
import 'package:formy/formy.dart';
import 'package:yellow_loan_signup_flutter_app/config/app_form_field.dart';

/// Calculate age from ID number stored in Formy context.
/// Returns the age if valid, or null if the ID number is invalid or not set.
int? calculateAgeFromIdNumber(BuildContext context) {
  final id = Formy.of(context).getValue<String>(AppFormField.idNumber.name);
  if (id == null) return null;

  final ageMaybe = FormUtils.ageFromIdNumber(id);
  if (ageMaybe > -1) {
    return ageMaybe;
  }
  return null;
}

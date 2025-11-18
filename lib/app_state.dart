import 'package:flutter/material.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  String _nameField = '';
  String get nameField => _nameField;
  set nameField(String value) {
    _nameField = value;
  }

  String _emailField = '';
  String get emailField => _emailField;
  set emailField(String value) {
    _emailField = value;
  }

  String _confirmEmailField = '';
  String get confirmEmailField => _confirmEmailField;
  set confirmEmailField(String value) {
    _confirmEmailField = value;
  }

  String _passwordField = '';
  String get passwordField => _passwordField;
  set passwordField(String value) {
    _passwordField = value;
  }

  String _confirmPassword = '';
  String get confirmPassword => _confirmPassword;
  set confirmPassword(String value) {
    _confirmPassword = value;
  }

  /// store the food preferences of a user
  List<String> _userTags = [];
  List<String> get userTags => _userTags;
  set userTags(List<String> value) {
    _userTags = value;
  }

  void addToUserTags(String value) {
    userTags.add(value);
  }

  void removeFromUserTags(String value) {
    userTags.remove(value);
  }

  void removeAtIndexFromUserTags(int index) {
    userTags.removeAt(index);
  }

  void updateUserTagsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    userTags[index] = updateFn(_userTags[index]);
  }

  void insertAtIndexInUserTags(int index, String value) {
    userTags.insert(index, value);
  }

  bool _editMode = false;
  bool get editMode => _editMode;
  set editMode(bool value) {
    _editMode = value;
  }

  /// tags for users diet & allergies
  List<String> _dietaryTags = [];
  List<String> get dietaryTags => _dietaryTags;
  set dietaryTags(List<String> value) {
    _dietaryTags = value;
  }

  void addToDietaryTags(String value) {
    dietaryTags.add(value);
  }

  void removeFromDietaryTags(String value) {
    dietaryTags.remove(value);
  }

  void removeAtIndexFromDietaryTags(int index) {
    dietaryTags.removeAt(index);
  }

  void updateDietaryTagsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    dietaryTags[index] = updateFn(_dietaryTags[index]);
  }

  void insertAtIndexInDietaryTags(int index, String value) {
    dietaryTags.insert(index, value);
  }
}

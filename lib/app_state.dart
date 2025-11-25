import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _isUserFirstRecipe =
          prefs.getBool('ff_isUserFirstRecipe') ?? _isUserFirstRecipe;
    });
    _safeInit(() {
      _userCohortDate = prefs.containsKey('ff_userCohortDate')
          ? DateTime.fromMillisecondsSinceEpoch(
              prefs.getInt('ff_userCohortDate')!)
          : _userCohortDate;
    });
    _safeInit(() {
      _userTimezone = prefs.getString('ff_userTimezone') ?? _userTimezone;
    });
    _safeInit(() {
      _SearchPageVisitCount =
          prefs.getInt('ff_SearchPageVisitCount') ?? _SearchPageVisitCount;
    });
    _safeInit(() {
      _surveyCompleted =
          prefs.getBool('ff_surveyCompleted') ?? _surveyCompleted;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

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

  int _sliderValue = 0;
  int get sliderValue => _sliderValue;
  set sliderValue(int value) {
    _sliderValue = value;
  }

  /// Current recipe being viewed/cooked
  String _currentRecipeId = '';
  String get currentRecipeId => _currentRecipeId;
  set currentRecipeId(String value) {
    _currentRecipeId = value;
  }

  /// Name of current recipe
  String _currentRecipeName = '';
  String get currentRecipeName => _currentRecipeName;
  set currentRecipeName(String value) {
    _currentRecipeName = value;
  }

  /// Cuisine type of current recipe
  String _currentRecipeCuisine = '';
  String get currentRecipeCuisine => _currentRecipeCuisine;
  set currentRecipeCuisine(String value) {
    _currentRecipeCuisine = value;
  }

  /// Prep time of current recipe (minutes)
  int _currentRecipePrepTime = 0;
  int get currentRecipePrepTime => _currentRecipePrepTime;
  set currentRecipePrepTime(int value) {
    _currentRecipePrepTime = value;
  }

  /// Unique ID for current app session
  String _currentSessionId = '';
  String get currentSessionId => _currentSessionId;
  set currentSessionId(String value) {
    _currentSessionId = value;
  }

  /// When current session started
  DateTime? _sessionStartTime =
      DateTime.fromMillisecondsSinceEpoch(1735715700000);
  DateTime? get sessionStartTime => _sessionStartTime;
  set sessionStartTime(DateTime? value) {
    _sessionStartTime = value;
  }

  /// Track if user has completed first recipe
  bool _isUserFirstRecipe = false;
  bool get isUserFirstRecipe => _isUserFirstRecipe;
  set isUserFirstRecipe(bool value) {
    _isUserFirstRecipe = value;
    prefs.setBool('ff_isUserFirstRecipe', value);
  }

  /// Date when user first signed up (for cohort analysis)
  DateTime? _userCohortDate =
      DateTime.fromMillisecondsSinceEpoch(1735715700000);
  DateTime? get userCohortDate => _userCohortDate;
  set userCohortDate(DateTime? value) {
    _userCohortDate = value;
    value != null
        ? prefs.setInt('ff_userCohortDate', value.millisecondsSinceEpoch)
        : prefs.remove('ff_userCohortDate');
  }

  /// User timezone for time-based analytics
  String _userTimezone = '';
  String get userTimezone => _userTimezone;
  set userTimezone(String value) {
    _userTimezone = value;
    prefs.setString('ff_userTimezone', value);
  }

  String _localPhoto = '';
  String get localPhoto => _localPhoto;
  set localPhoto(String value) {
    _localPhoto = value;
  }

  int _SearchPageVisitCount = 0;
  int get SearchPageVisitCount => _SearchPageVisitCount;
  set SearchPageVisitCount(int value) {
    _SearchPageVisitCount = value;
    prefs.setInt('ff_SearchPageVisitCount', value);
  }

  bool _surveyCompleted = false;
  bool get surveyCompleted => _surveyCompleted;
  set surveyCompleted(bool value) {
    _surveyCompleted = value;
    prefs.setBool('ff_surveyCompleted', value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

// Generated, do not edit
import "package:easy_localization/easy_localization.dart";

class AppLocalizations {
  _Onboarding onboarding = _Onboarding();

  _Group group = _Group();

  /// Source => "{} are written in the {} language"
  String msg(
    String args0,
    String args1,
  ) {
    return tr("msg", args: [args0, args1]);
  }

  /// Source => "Easy localization are written in the {lang} language"
  String msgNamed({required String lang}) {
    return tr("msgNamed", namedArgs: {"lang": lang});
  }

  /// Source => "{} are written in the {lang} language"
  String msgMixed(
    String args0, {
    required String lang,
  }) {
    return tr("msgMixed", args: [args0], namedArgs: {"lang": lang});
  }

  /// Source => "{} are written in the {} language. @:msgMixed"
  String msgLinked(
    String args0,
    String args1,
    String args2, {
    required String lang,
  }) {
    return tr("msgLinked",
        args: [args0, args1, args2], namedArgs: {"lang": lang});
  }
}

class _Group {
  _Money money = _Money();

  _MoneyArgs moneyArgs = _MoneyArgs();

  _InnerGroup innerGroup = _InnerGroup();
}

class _InnerGroup {
  /// Source => "{} are written in the {} language"
  String msg(
    String args0,
    String args1,
  ) {
    return tr("msg", args: [args0, args1]);
  }

  /// Source => "Easy localization are written in the {lang} language"
  String msgNamed({required String lang}) {
    return tr("msgNamed", namedArgs: {"lang": lang});
  }

  /// Source => "{} are written in the {lang} language"
  String msgMixed(
    String args0, {
    required String lang,
  }) {
    return tr("msgMixed", args: [args0], namedArgs: {"lang": lang});
  }

  /// Source => "{} are written in the {} language. @:msgMixed"
  String msgLinked(
    String args0,
    String args1,
    String args2, {
    required String lang,
  }) {
    return tr("msgLinked",
        args: [args0, args1, args2], namedArgs: {"lang": lang});
  }
}

class _MoneyArgs {
  /// Source => "{} has no money"
  String zero(String args0) {
    return tr("zero", args: [args0]);
  }

  /// Source => "{} has {} dollar"
  String one(
    String args0,
    String args1,
  ) {
    return tr("one", args: [args0, args1]);
  }

  /// Source => "{} has {} dollars"
  String many(
    String args0,
    String args1,
  ) {
    return tr("many", args: [args0, args1]);
  }

  /// Source => "{} has {} dollars"
  String other(
    String args0,
    String args1,
  ) {
    return tr("other", args: [args0, args1]);
  }
}

class _Money {
  /// Source => "You not have money"
  String zero() {
    return tr("zero");
  }

  /// Source => "You have {} dollar"
  String one(String args0) {
    return tr("one", args: [args0]);
  }

  /// Source => "You have {} dollars"
  String many(String args0) {
    return tr("many", args: [args0]);
  }

  /// Source => "You have {} dollars"
  String other(String args0) {
    return tr("other", args: [args0]);
  }
}

class _Onboarding {
  _Greet greet = _Greet();

  _GreetGenderNamedLinked greetGenderNamedLinked = _GreetGenderNamedLinked();

  /// Source => "FullName"
  String fullName() {
    return tr("fullName");
  }

  /// Source => "Welcome {fullName}"
  String welcome({required String fullName}) {
    return tr("welcome", namedArgs: {"fullName": fullName});
  }

  /// Source => "Welcome @.lower:onboarding.fullName"
  String welcomeLower() {
    return tr("welcomeLower");
  }

  /// Source => "Welcome @.upper:onboarding.fullName"
  String welcomeUpper() {
    return tr("welcomeUpper");
  }

  /// Source => "Welcome @.capitalize:onboarding.fullName"
  String welcomeCapitalize() {
    return tr("welcomeCapitalize");
  }

  /// Source => "Bye {firstName}"
  String bye({required String firstName}) {
    return tr("bye", namedArgs: {"firstName": firstName});
  }

  /// Source => "@:onboarding.greet, @:onboarding.greetGenderNamedLinked"
  String greetCombination() {
    return tr("greetCombination");
  }
}

class _GreetGenderNamedLinked {
  /// Source => "Hello Mr {lastName} and @:onboarding.welcome"
  String male({
    required String fullName,
    required String lastName,
  }) {
    return tr("male", namedArgs: {"fullName": fullName, "lastName": lastName});
  }

  /// Source => "Hello Ms {lastName} and @:onboarding.bye"
  String female({
    required String firstName,
    required String lastName,
  }) {
    return tr("female",
        namedArgs: {"firstName": firstName, "lastName": lastName});
  }
}

class _Greet {
  /// Source => "Hi man ;) {}"
  String male(String args0) {
    return tr("male", args: [args0]);
  }

  /// Source => "Hello girl :) {}"
  String female(String args0) {
    return tr("female", args: [args0]);
  }

  /// Source => "Hello {}"
  String other(String args0) {
    return tr("other", args: [args0]);
  }
}


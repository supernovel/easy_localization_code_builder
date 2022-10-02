import 'package:easy_localization/easy_localization.dart';

final localizations = AppLocalizations();

class AppLocalizations {
  final onboarding = _Onboarding();
  final group = _Group();

  String msg(String arg1, String arg2) {
    return "msg".tr(
      args: [arg1, arg2],
    );
  }

  String msgNamed({required String lang}) {
    return "msgNamed".tr(namedArgs: {"lang": lang});
  }

  String msgMixed(String arg1, {required String lang}) {
    return "msgMixed".tr(args: [arg1], namedArgs: {"lang": lang});
  }

  String msgLinked(
    String arg1,
    String arg2,
    String arg3, {
    required String lang,
  }) {
    return "msgMixed".tr(args: [
      arg1,
      arg2,
      arg3,
    ], namedArgs: {
      "lang": lang
    });
  }
}

class _Onboarding {
  String get fullName => "onboarding.fullName";

  String welcome({required String fullName}) {
    return "onboarding.welcome".tr(namedArgs: {"fullName": fullName});
  }

  String get welcomeLower => "onboarding.welcomeLower".tr();

  String get welcomeUpper => "onboarding.welcomeUpper".tr();

  String get welcomeCapitalize => "onboarding.welcomeCapitalize".tr();

  String bye({
    required String firstName,
  }) {
    return "onboarding.bye".tr(
      namedArgs: {
        "firstName": firstName,
      },
    );
  }

  String greetGender(String value, {required String gender}) {
    return "onboarding.greetGender".tr(
      gender: gender,
      args: [value],
    );
  }

  String greetGenderNamedLinked({
    required String gender,
    required String lastName,
    required String firstName,
    required String fullName,
  }) {
    return "onboarding.greetGenderNamedLinked".tr(
      gender: gender,
      namedArgs: {
        "lastName": lastName,
        "firstName": firstName,
        "fullName": fullName,
      },
    );
  }

  String greetCombination(
    String arg1, {
    required String gender,
    required String lastName,
    required String firstName,
    required String fullName,
  }) {
    return "onboarding.greetCombination".tr(
      gender: gender,
      args: [arg1],
      namedArgs: {
        "lastName": lastName,
        "firstName": firstName,
        "fullName": fullName,
      },
    );
  }
}

class _Group {
  _InnerGroup innerGroup = _InnerGroup();

  String money(num value, [NumberFormat? format]) {
    return "group.money".plural(
      value,
      format: format,
    );
  }

  String moneyArgs(num value, String arg1, [NumberFormat? format]) {
    return "group.moneyArgs".plural(
      value,
      format: format,
      args: [arg1],
    );
  }
}

class _InnerGroup {
  String msg(String arg1, String arg2) {
    return "msg".tr(
      args: [arg1, arg2],
    );
  }

  String msgNamed({required String lang}) {
    return "msgNamed".tr(namedArgs: {"lang": lang});
  }

  String msgMixed(String arg1, {required String lang}) {
    return "msgMixed".tr(args: [arg1], namedArgs: {"lang": lang});
  }

  String msgLinked(
    String arg1,
    String arg2,
    String arg3, {
    required String lang,
  }) {
    return "msgMixed".tr(args: [
      arg1,
      arg2,
      arg3,
    ], namedArgs: {
      "lang": lang
    });
  }
}

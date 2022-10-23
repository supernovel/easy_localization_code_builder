import 'package:easy_localization_keys_generator/src/model/translation_node.dart';
import 'package:easy_localization_keys_generator/src/translation_model_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("build text node", () {
    // "Welcome"
    test('default', () {
      final textNode = buildNode("message", "Welcome");

      expect(textNode is TranslationNode, true);

      if (textNode is! TranslationNode) {
        return;
      }

      expect(textNode.key, "message");
      expect(textNode.unnamedArgCount, 0);
      expect(textNode.namedArgNameSet.isEmpty, true);
      expect(textNode.linkKeySet.isEmpty, true);
    });

    // "{} are written in the {} language"
    test('with Args', () {
      final textNode =
          buildNode("message", "{} are written in the {} language");

      expect(textNode is TranslationNode, true);

      if (textNode is! TranslationNode) {
        return;
      }

      expect(textNode.key, "message");
      expect(textNode.unnamedArgCount, 2);
      expect(textNode.namedArgNameSet.isEmpty, true);
      expect(textNode.linkKeySet.isEmpty, true);
    });

    // "Easy localization are written in the {lang} language"
    test('with Named Arg', () {
      final textNode = buildNode(
          "message", "Easy localization are written in the {lang} language");

      expect(textNode is TranslationNode, true);

      if (textNode is! TranslationNode) {
        return;
      }

      expect(textNode.key, "message");
      expect(textNode.unnamedArgCount, 0);
      expect(textNode.namedArgNameSet.isNotEmpty, true);
      expect(textNode.namedArgNameSet.length, 1);
      expect(textNode.namedArgNameSet.contains("lang"), true);
      expect(textNode.linkKeySet.isEmpty, true);
    });

    test('with Named Args', () {
      final textNode =
          buildNode("message", "{target} are written in the {lang} language");

      expect(textNode is TranslationNode, true);

      if (textNode is! TranslationNode) {
        return;
      }

      expect(textNode.key, "message");
      expect(textNode.unnamedArgCount, 0);
      expect(textNode.namedArgNameSet.isNotEmpty, true);
      expect(textNode.namedArgNameSet.length, 2);
      expect(textNode.namedArgNameSet.contains("target"), true);
      expect(textNode.namedArgNameSet.contains("lang"), true);
      expect(textNode.linkKeySet.isEmpty, true);
    });

    test('with Link key', () {
      final textNode = buildNode("message",
          "Easy localization are written in the en language. @:msgMixed");

      expect(textNode is TranslationNode, true);

      if (textNode is! TranslationNode) {
        return;
      }

      expect(textNode.key, "message");
      expect(textNode.unnamedArgCount, 0);
      expect(textNode.namedArgNameSet.isEmpty, true);
      expect(textNode.linkKeySet.isNotEmpty, true);
      expect(textNode.linkKeySet.length, 1);
      expect(textNode.linkKeySet.contains("msgMixed"), true);
    });

    // "Welcome @.lower:onboarding.fullName"
    test('with Link key, modifier', () {
      final textNode =
          buildNode("message", "Welcome @.lower:onboarding.fullName");

      expect(textNode is TranslationNode, true);

      if (textNode is! TranslationNode) {
        return;
      }

      expect(textNode.key, "message");
      expect(textNode.unnamedArgCount, 0);
      expect(textNode.namedArgNameSet.isEmpty, true);
      expect(textNode.linkKeySet.isNotEmpty, true);
      expect(textNode.linkKeySet.length, 1);
      expect(textNode.linkKeySet.contains("onboarding.fullName"), true);
    });

    // "{} are written in the {lang} language. @:msgMixed"
    test('with Mixed feature', () {
      final textNode = buildNode(
          "message", "{} are written in the {lang} language. @:msgMixed");

      expect(textNode is TranslationNode, true);

      if (textNode is! TranslationNode) {
        return;
      }

      expect(textNode.key, "message");
      expect(textNode.unnamedArgCount, 1);
      expect(textNode.namedArgNameSet.isNotEmpty, true);
      expect(textNode.namedArgNameSet.length, 1);
      expect(textNode.namedArgNameSet.contains("lang"), true);
      expect(textNode.linkKeySet.isNotEmpty, true);
      expect(textNode.linkKeySet.length, 1);
      expect(textNode.linkKeySet.contains("msgMixed"), true);
    });
  });

  group("gender node", () {
    test('default', () {
      final genderNode = buildNode("message", {
        "male": "Hi man ;)",
        "female": "Hello girl :)",
        "other": "Hello",
      });

      expect(genderNode is TranslationNode, true);

      if (genderNode is! TranslationNode) {
        return;
      }

      expect(genderNode.key, "message");
      expect(genderNode.unnamedArgCount, 0);
      expect(genderNode.namedArgNameSet.isEmpty, true);
      expect(genderNode.linkKeySet.isEmpty, true);
    });

    test('with unnamed args', () {
      final genderNode1 = buildNode("message", {
        "male": "Hi man ;) {}",
        "female": "Hello girl :) {}",
        "other": "Hello {}"
      });

      expect(genderNode1 is TranslationNode, true);

      if (genderNode1 is! TranslationNode) {
        return;
      }

      expect(genderNode1.key, "message");
      expect(genderNode1.unnamedArgCount, 1);
      expect(genderNode1.namedArgNameSet.isEmpty, true);
      expect(genderNode1.linkKeySet.isEmpty, true);

      final genderNode2 = buildNode("message", {
        "male": "Hi man ;)",
        "female": "Hello girl :)",
        "other": "Hello {}"
      });

      expect(genderNode2 is TranslationNode, true);

      if (genderNode2 is! TranslationNode) {
        return;
      }

      expect(genderNode2.key, "message");
      expect(genderNode2.unnamedArgCount, 1);
      expect(genderNode2.namedArgNameSet.isEmpty, true);
      expect(genderNode2.linkKeySet.isEmpty, true);
    });

    test('with named args', () {
      final genderNode1 = buildNode("message", {
        "male": "Hi man ;) {name}",
        "female": "Hello girl :) {name}",
        "other": "Hello {name}"
      });

      expect(genderNode1 is TranslationNode, true);

      if (genderNode1 is! TranslationNode) {
        return;
      }

      expect(genderNode1.key, "message");
      expect(genderNode1.unnamedArgCount, 0);
      expect(genderNode1.namedArgNameSet.isNotEmpty, true);
      expect(genderNode1.namedArgNameSet.length, 1);
      expect(genderNode1.namedArgNameSet.contains("name"), true);
      expect(genderNode1.linkKeySet.isEmpty, true);

      final genderNode2 = buildNode("message", {
        "male": "Hi man ;)",
        "female": "Hello girl :)",
        "other": "Hello {name}"
      });

      expect(genderNode2 is TranslationNode, true);

      if (genderNode2 is! TranslationNode) {
        return;
      }

      expect(genderNode2.key, "message");
      expect(genderNode2.unnamedArgCount, 0);
      expect(genderNode2.namedArgNameSet.isNotEmpty, true);
      expect(genderNode2.namedArgNameSet.length, 1);
      expect(genderNode2.namedArgNameSet.contains("name"), true);
      expect(genderNode2.linkKeySet.isEmpty, true);
    });

    test('with link keys', () {
      final genderNode1 = buildNode("message", {
        "male": "Hi man ;) @:user.fullName",
        "female": "Hello girl :) @:user.fullName",
        "other": "Hello @:user.fullName"
      });

      expect(genderNode1 is TranslationNode, true);

      if (genderNode1 is! TranslationNode) {
        return;
      }

      expect(genderNode1.key, "message");
      expect(genderNode1.unnamedArgCount, 0);
      expect(genderNode1.namedArgNameSet.isEmpty, true);
      expect(genderNode1.linkKeySet.isNotEmpty, true);
      expect(genderNode1.linkKeySet.length, 1);
      expect(genderNode1.linkKeySet.contains("user.fullName"), true);

      final genderNode2 = buildNode("message", {
        "male": "Hi man ;)",
        "female": "Hello girl :)",
        "other": "Hello @:user.fullName"
      });

      expect(genderNode2 is TranslationNode, true);

      if (genderNode2 is! TranslationNode) {
        return;
      }

      expect(genderNode2.key, "message");
      expect(genderNode2.unnamedArgCount, 0);
      expect(genderNode2.namedArgNameSet.isEmpty, true);
      expect(genderNode2.linkKeySet.isNotEmpty, true);
      expect(genderNode2.linkKeySet.length, 1);
      expect(genderNode2.linkKeySet.contains("user.fullName"), true);
    });

    test('with mixed feature', () {
      final genderNode1 = buildNode("message", {
        "male": "Hi man ;) {} {name} @:user.fullName",
        "female": "Hello girl :) {} {name} @:user.fullName",
        "other": "Hello {} {name} @:user.fullName"
      });

      expect(genderNode1 is TranslationNode, true);

      if (genderNode1 is! TranslationNode) {
        return;
      }

      expect(genderNode1.key, "message");
      expect(genderNode1.unnamedArgCount, 1);
      expect(genderNode1.namedArgNameSet.isNotEmpty, true);
      expect(genderNode1.namedArgNameSet.length, 1);
      expect(genderNode1.namedArgNameSet.contains("name"), true);
      expect(genderNode1.linkKeySet.isNotEmpty, true);
      expect(genderNode1.linkKeySet.length, 1);
      expect(genderNode1.linkKeySet.contains("user.fullName"), true);

      final genderNode2 = buildNode("message", {
        "male": "Hi man ;) {}",
        "female": "Hello girl :) {name}",
        "other": "Hello @:user.fullName"
      });

      expect(genderNode2 is TranslationNode, true);

      if (genderNode2 is! TranslationNode) {
        return;
      }

      expect(genderNode2.key, "message");
      expect(genderNode2.unnamedArgCount, 1);
      expect(genderNode2.namedArgNameSet.isNotEmpty, true);
      expect(genderNode2.namedArgNameSet.length, 1);
      expect(genderNode2.namedArgNameSet.contains("name"), true);
      expect(genderNode2.linkKeySet.isNotEmpty, true);
      expect(genderNode2.linkKeySet.length, 1);
      expect(genderNode2.linkKeySet.contains("user.fullName"), true);
    });
  });

  test('build tree', () {
    final tree = buildTree({
      "user": {"fullName": "myName"},
      "unnamedArgsMessage": "{} are written in the {} language",
      "namedArgsMessage": "{name} are written in the {language} language",
      "linkMessage": "{} are written in the {lang} language. @:msgMixed",
      "genderMessage": {
        "male": "Hi man ;) {} {name} @:user.fullName",
        "female": "Hello girl :) {} {name} @:user.fullName",
        "other": "Hello {} {name} @:user.fullName"
      }
    });

    expect(tree.children.length, 5);

    final userNode =
        tree.children.where((element) => element.key == "user").first;

    expect(userNode.children.length, 1);

    final fullNameNode = userNode.children.first;

    expect(fullNameNode is TextNode, true);

    expect(fullNameNode.key, "fullName");
    expect((fullNameNode as TextNode).value, "myName");
  });
}

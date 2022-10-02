import 'dart:convert';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:change_case/change_case.dart';

import 'translation_model.dart';

class TranslationCodeGenerator {
  static final methodNameRegExp =
      RegExp(r"^[_$a-zA-Z\xA0-\uFFFF][_$a-zA-Z0-9\xA0-\uFFFF]*$");

  static String build(Node translationModel) {
    final groupQueue = <GroupNode>[];

    final library = Library((builder) {
      builder.body.add(
        const Code(
            "import \"package:easy_localization/easy_localization.dart\";"),
      );

      final rootClass = Class((classBuilder) {
        classBuilder.name = "AppLocalizations";

        for (final node in translationModel.children) {
          if (node is GroupNode) {
            classBuilder.fields.add(buildGroupNodeField(node));

            groupQueue.add(node);
          } else {
            classBuilder.methods.add(buildTextNodeMethod(node));
          }
        }
      });

      builder.body.add(rootClass);

      while (groupQueue.isNotEmpty) {
        final groupNode = groupQueue.removeLast();

        final groupClass = Class((classBuilder) {
          classBuilder.name = '_${groupNode.path.toPascalCase()}';

          for (final node in groupNode.children) {
            if (node is GroupNode) {
              classBuilder.fields.add(buildGroupNodeField(node));

              groupQueue.add(node);
            } else {
              classBuilder.methods.add(buildTextNodeMethod(node));
            }
          }
        });

        builder.body.add(groupClass);
      }
    });

    final emitter = DartEmitter();

    return DartFormatter().format('${library.accept(emitter)}');
  }

  static Field buildGroupNodeField(Node node) {
    return Field((fieldBuilder) {
      fieldBuilder
        ..name = node.key.toCamelCase()
        ..type = Reference('_${node.path.toPascalCase()}')
        ..assignment = Code('_${node.path.toPascalCase()}()');
    });
  }

  static Method buildTextNodeMethod(Node node) {
    return Method((methodBuilder) {
      String name = node.key;

      if (!isValidMethodName(name)) {
        name = node.path;
      }

      methodBuilder
        ..name = name.toCamelCase()
        ..returns = const Reference('String');

      if (node is! TranslationNode) {
        return;
      }

      methodBuilder.docs.add("/// Source => ${jsonEncode(node.value)}");

      UnnamedParameterBuilder unnamedParameters =
          UnnamedParameterBuilder(node.unnamedArgCount);
      NamedParameterBuilder namedParameters =
          NamedParameterBuilder(node.namedArgNameSet);

      methodBuilder.requiredParameters
          .addAll(unnamedParameters.buildParameters());
      methodBuilder.optionalParameters
          .addAll(namedParameters.buildParameters());

      final bodyCode = [
        "\"${node.path}\"",
        unnamedParameters.buildCode(),
        namedParameters.buildCode(),
      ].where((element) => element.isNotEmpty).join(",");

      methodBuilder.body = Code("return tr($bodyCode);");
    });
  }

  static bool isValidMethodName(String name) {
    if (name == "default") {
      return false;
    }

    return methodNameRegExp.hasMatch(name);
  }
}

class UnnamedParameterBuilder {
  final int count;
  late final List<String> argNames;

  UnnamedParameterBuilder(this.count) {
    argNames = List.generate(count, (index) {
      return _buildParameterName(index);
    });
  }

  String buildCode() {
    if (argNames.isEmpty) {
      return "";
    }

    return """args: [
      ${argNames.join(",")}
    ]""";
  }

  List<Parameter> buildParameters() {
    if (argNames.isEmpty) {
      return [];
    }

    return argNames.map((name) {
      return Parameter((parameterBuilder) {
        parameterBuilder
          ..name = name
          ..type = const Reference('String');
      });
    }).toList();
  }

  String _buildParameterName(int index) {
    return "args$index";
  }
}

class NamedParameterBuilder {
  final Set<String> keys;

  NamedParameterBuilder(this.keys);

  String buildCode() {
    if (keys.isEmpty) {
      return "";
    }

    return """namedArgs: {
                ${keys.map((key) {
      return "\"$key\": $key";
    }).join(",")}
              }""";
  }

  List<Parameter> buildParameters() {
    if (keys.isEmpty) {
      return [];
    }

    return keys.map((key) {
      return Parameter((parameterBuilder) {
        parameterBuilder
          ..name = key
          ..type = const Reference('String')
          ..named = true
          ..required = true;
      });
    }).toList();
  }
}

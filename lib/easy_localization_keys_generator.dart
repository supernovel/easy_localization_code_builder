library easy_localization_keys_generator;

import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:easy_localization_keys_generator/translation_code_generator.dart';
import 'package:easy_localization_keys_generator/translation_model_builder.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

/// A Calculator.
class EasyLocalizationKeysGenerator extends Builder {
  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final inputPath = inputId.path;
    final inputExtension = path.extension(inputPath);
    final outputPath = inputId.path
        .replaceFirst('assets/', 'lib/generated/')
        .replaceFirst(inputExtension, '.dart');

    final outputId = AssetId(
      inputId.package,
      outputPath,
    );

    final Map<String, dynamic> messages;

    switch (inputExtension.toLowerCase()) {
      case ".yaml":
      case ".yml":
        final documet = loadYaml(await buildStep.readAsString(inputId));
        messages = _convertYamlMapToMap(documet);
        break;
      case ".json":
        messages = (json.decode(await buildStep.readAsString(inputId)) as Map)
            .cast<String, dynamic>();
        break;
      default:
        messages = {};
        break;
    }

    final outputBuffer = StringBuffer('// Generated, do not edit\n');

    final model = TranslationModelBuilder.build(messages);
    final code = TranslationCodeGenerator.build(model);

    outputBuffer.writeln(code);

    await buildStep.writeAsString(outputId, outputBuffer.toString());
  }

  Map<String, dynamic> _convertYamlMapToMap(YamlMap yamlMap) {
    final map = <String, dynamic>{};

    for (final entry in yamlMap.entries) {
      if (entry.value is YamlMap || entry.value is Map) {
        map[entry.key.toString()] = _convertYamlMapToMap(entry.value);
      } else {
        map[entry.key.toString()] = entry.value.toString();
      }
    }

    return map;
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        '^assets/{{}}.json': ['lib/generated/{{}}.dart'],
        '^assets/{{}}.yaml': ['lib/generated/{{}}.dart'],
      };
}

Builder easyLocalizationKeysGenerator(BuilderOptions options) =>
    EasyLocalizationKeysGenerator();

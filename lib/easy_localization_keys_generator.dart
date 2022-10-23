library easy_localization_keys_generator;

import 'dart:async';

import 'package:build/build.dart';
import 'package:easy_localization_keys_generator/src/model/build_config.dart';
import 'package:easy_localization_keys_generator/src/translation_code_generator.dart';
import 'package:easy_localization_keys_generator/src/translation_model_builder.dart';
import 'package:path/path.dart' as path;

import 'src/utils.dart';

/// A Calculator.
class EasyLocalizationKeysGenerator extends Builder {
  final BuildConfig config;

  EasyLocalizationKeysGenerator(this.config);

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final inputPath = inputId.path;
    final inputExtension = path.extension(inputPath);
    final inputFileName = path.basename(inputPath);
    final outputFileName =
        inputFileName.replaceFirst(inputExtension, '.g.dart');
    final outputFilePath =
        path.canonicalize(path.join(config.outputPath, outputFileName));

    // Parse content
    final String content = await buildStep.readAsString(inputId);
    final Map<String, dynamic> messages =
        parseDocument(content, inputExtension);

    // Build code
    final outputBuffer = StringBuffer('// Generated, do not edit\n');

    final model = buildTranslationTree(messages);
    final code = buildCode(model);

    outputBuffer.writeln(code);

    // Write code
    writeFile(outputFilePath, outputBuffer.toString());
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        '.json': ['.g.dart'],
        '.yaml': ['.g.dart'],
      };
}

/// Static entry point for build_runner
Builder easyLocalizationKeysGenerator(BuilderOptions options) {
  return EasyLocalizationKeysGenerator(BuildConfig.fromJson(options.config));
}

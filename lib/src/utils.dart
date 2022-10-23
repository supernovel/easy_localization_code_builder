import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

Future<void> writeFile(String path, String content) async {
  final file = File(path);

  if (await file.exists()) {
    await file.delete();
  }

  await file.create(recursive: true);
  await file.writeAsString(content);
}

Map<String, dynamic> parseDocument(String content, String extension) {
  switch (extension.toLowerCase()) {
    case ".yaml":
    case ".yml":
      final document = loadYaml(content);
      return convertYamlMapToMap(document);

    case ".json":
      return (json.decode(content) as Map).cast<String, dynamic>();

    default:
      return {};
  }
}

Map<String, dynamic> convertYamlMapToMap(YamlMap yamlMap) {
  final map = <String, dynamic>{};

  for (final entry in yamlMap.entries) {
    if (entry.value is YamlMap || entry.value is Map) {
      map[entry.key.toString()] = convertYamlMapToMap(entry.value);
    } else {
      map[entry.key.toString()] = entry.value.toString();
    }
  }

  return map;
}

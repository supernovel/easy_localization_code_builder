import 'dart:collection';

import 'translation_node.dart';

final unnamedArgRegExp = RegExp(r"{}");
final namedArgRegExp = RegExp(r"{([a-zA-Z0-9_]+)}");
final linkKeysRegExp =
    RegExp(r"@(?:\.lower|\.upper|\.capitalize)?:([a-zA-Z0-9_\.]+)");

int getUnnamedArgCount(String value) {
  return unnamedArgRegExp.allMatches(value).length;
}

Set<String> getNamedArgNameSet(String value) {
  final matches = namedArgRegExp.allMatches(value);
  final Set<String> result = HashSet<String>();

  for (final match in matches) {
    if (match.groupCount != 1) {
      break;
    }

    final groupValue = match.group(1);

    if (groupValue == null) {
      break;
    }

    result.add(groupValue);
  }

  return result;
}

Set<String> getLinkKeySet(String value) {
  final matches = linkKeysRegExp.allMatches(value);
  final Set<String> result = HashSet<String>();

  for (final match in matches) {
    if (match.groupCount != 1) {
      break;
    }

    final groupValue = match.group(1);

    if (groupValue == null) {
      break;
    }

    result.add(groupValue);
  }

  return result;
}

Set<String> foldHashSet(
  Iterable<String> values,
  Set<String> Function(String value) toElement,
) {
  return values.fold<HashSet<String>>(HashSet<String>(),
      (HashSet<String> result, item) {
    final generatedSet = toElement(item);

    result.addAll(generatedSet);

    return result;
  });
}

Node mapLeapNode(Node startNode, Node Function(Node node) toElement) {
  if (startNode is LeafNode) {
    return toElement(startNode);
  }

  if (startNode.children.isEmpty) {
    return startNode;
  }

  return startNode.copyWith(
    children: startNode.children.map((child) {
      return mapLeapNode(child, toElement);
    }).toList(),
  );
}

TranslationNode<T> linkFromNodeMap<T>(
    TranslationNode<T> target, Map<String, Node> nodeMap) {
  int unnamedArgCount = target.unnamedArgCount;
  Set<String> namedArgNameSet = target.namedArgNameSet;

  for (final linkKey in target.linkKeySet) {
    final existTarget = nodeMap.containsKey(linkKey);

    if (!existTarget) {
      continue;
    }

    final target = nodeMap[linkKey]!;

    if (target is! TranslationNode) {
      continue;
    }

    unnamedArgCount += target.unnamedArgCount;
    namedArgNameSet.addAll(target.namedArgNameSet);
  }

  return target.copyWith(
    unnamedArgCount: unnamedArgCount,
    namedArgNameSet: namedArgNameSet,
    linkKeySet: {},
  );
}

bool isPluralValue(Map<String, dynamic> value) {
  return hasOnlyThatKey(value, PluralNode.preservedKeywords);
}

bool isGenderValue(Map<String, dynamic> value) {
  return hasOnlyThatKey(value, GenderNode.preservedKeywords);
}

bool hasOnlyThatKey(Map<String, dynamic> value, List<String> expectedKeys) {
  final keys = [...value.keys];

  keys.removeWhere((key) => expectedKeys.contains(key));

  return keys.isEmpty;
}

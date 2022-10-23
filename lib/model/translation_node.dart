import 'dart:math' as math;
import 'translation_node_utils.dart';

abstract class Node {
  final String key;
  final List<Node> children;

  const Node({
    required this.key,
    this.children = const [],
  });

  Node copyWith({String? key, List<Node>? children});
}

abstract class LeafNode extends Node {
  LeafNode({
    required String key,
  }) : super(key: key);
}

class TranslationGroupNode extends Node {
  TranslationGroupNode({
    required String key,
    required List<Node> children,
  }) : super(key: key, children: children);

  @override
  TranslationGroupNode copyWith({String? key, List<Node>? children}) {
    return TranslationGroupNode(
      key: key ?? this.key,
      children: children ?? this.children,
    );
  }
}

class TranslationNode<T> extends LeafNode {
  final T value;
  final int unnamedArgCount;
  final Set<String> namedArgNameSet;
  final Set<String> linkKeySet;

  TranslationNode({
    required String key,
    required this.value,
    this.unnamedArgCount = 0,
    this.namedArgNameSet = const {},
    this.linkKeySet = const {},
  }) : super(key: key);

  @override
  TranslationNode<T> copyWith({
    String? key,
    List<Node>? children,
    int? unnamedArgCount,
    Set<String>? namedArgNameSet,
    Set<String>? linkKeySet,
  }) {
    return TranslationNode<T>(
      key: key ?? this.key,
      value: value,
      unnamedArgCount: unnamedArgCount ?? this.unnamedArgCount,
      namedArgNameSet: namedArgNameSet ?? this.namedArgNameSet,
      linkKeySet: linkKeySet ?? this.linkKeySet,
    );
  }

  @override
  String toString() {
    return """$runtimeType { 
      key: $key, 
      value: $value, 
      unnamedArgCount: $unnamedArgCount, 
      namedArgNameSet: $namedArgNameSet, 
      linkKeySet: $linkKeySet, }
    """;
  }
}

class TextNode extends TranslationNode<String> {
  TextNode({
    required String key,
    required String value,
  }) : super(
          key: key,
          unnamedArgCount: getUnnamedArgCount(value),
          namedArgNameSet: getNamedArgNameSet(value),
          linkKeySet: getLinkKeySet(value),
          value: value,
        );
}

class PluralNode extends TranslationNode<Map<String, dynamic>> {
  static const preservedKeywords = [
    'few',
    'many',
    'one',
    'other',
    'two',
    'zero',
  ];

  PluralNode({
    required String key,
    required Map<String, String> plural,
  }) : super(
          key: key,
          unnamedArgCount: plural.values.fold(0, (previousValue, item) {
            return math.max(previousValue, getUnnamedArgCount(item));
          }),
          namedArgNameSet: foldHashSet(plural.values, getNamedArgNameSet),
          linkKeySet: foldHashSet(plural.values, getLinkKeySet),
          value: plural,
        );
}

class GenderNode extends TranslationNode<Map<String, dynamic>> {
  static const preservedKeywords = ['male', 'female', 'other'];

  GenderNode({
    required String key,
    required Map<String, String> gender,
  }) : super(
          key: key,
          unnamedArgCount: gender.values.fold(0, (previousValue, item) {
            return math.max(previousValue, getUnnamedArgCount(item));
          }),
          namedArgNameSet: foldHashSet(gender.values, getNamedArgNameSet),
          linkKeySet: foldHashSet(gender.values, getLinkKeySet),
          value: gender,
        );
}

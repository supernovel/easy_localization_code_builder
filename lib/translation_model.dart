import 'dart:collection';
import 'dart:math' as math;

abstract class Node {
  static const String keyDelimiter = ".";

  final String path;
  final List<Node> children;
  final Node? parent;

  String get key {
    final splited = path.split(keyDelimiter);

    if (splited.isEmpty) {
      return path;
    }

    return splited.last;
  }

  const Node({
    this.path = "",
    this.children = const [],
    this.parent,
  });

  Node mapLeafNode(Node Function(Node value) toElement) {
    if (this is LeafNode) {
      return this;
    }

    final queue = [...children];

    while (queue.isNotEmpty) {
      final node = queue.removeLast();

      if (node is LeafNode) {
        toElement(node);
      } else {
        queue.addAll(node.children);
      }
    }

    return this;
  }
}

abstract class LeafNode {}

abstract class TranslationNode<T> extends Node {
  static final unnamedArgRegExp = RegExp(r"{}");
  static final namedArgRegExp = RegExp(r"{([a-zA-Z0-9_]+)}");
  static final linkKeysRegExp =
      RegExp(r"@(?:\.lower|\.upper|\.capitalize)?:([a-zA-Z0-9_\.]+)");

  final T value;

  int _unnamedArgCount;
  int get unnamedArgCount => _unnamedArgCount;

  final Set<String> _namedArgNameSet;
  Set<String> get namedArgNameSet => _namedArgNameSet;

  Set<String> _linkKeySet;

  Set<String> get linkKeySet => _linkKeySet;
  bool get requireLink => _linkKeySet.isNotEmpty;

  TranslationNode({
    String path = "",
    int unnamedArgCount = 0,
    Set<String>? namedArgNameSet,
    Set<String>? linkKeySet,
    Node? parent,
    required this.value,
  })  : _unnamedArgCount = unnamedArgCount,
        _namedArgNameSet = namedArgNameSet ?? HashSet<String>(),
        _linkKeySet = linkKeySet ?? HashSet<String>(),
        super(
          path: path,
          parent: parent,
        );

  void link(Map<String, Node> nodes) {
    if (!requireLink) {
      return;
    }

    final linkKeySet = _linkKeySet;

    for (final linkKey in linkKeySet) {
      final existTarget = nodes.containsKey(linkKey);

      if (!existTarget) {
        continue;
      }

      final target = nodes[linkKey]!;

      if (target is! TranslationNode) {
        continue;
      }

      _unnamedArgCount += target.unnamedArgCount;
      _namedArgNameSet.addAll(target.namedArgNameSet);
    }

    _linkKeySet = HashSet<String>();
  }

  @override
  String toString() {
    return """$runtimeType { 
      path: $path, 
      value: $value, 
      unnamedArgCount: $unnamedArgCount, 
      namedArgNameSet: $namedArgNameSet, 
      linkKeySet: $_linkKeySet, }
    """;
  }

  static int getUnnamedArgCount(String value) {
    return unnamedArgRegExp.allMatches(value).length;
  }

  static Set<String> getNamedArgNameSet(String value) {
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

  static Set<String> getLinkKeySet(String value) {
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
}

class GroupNode extends Node {
  GroupNode({
    String path = "",
    List<Node> children = const [],
    Node? parent,
  }) : super(
          path: path,
          parent: parent,
          children: children,
        );

  static String buildChildPath(String path, String key) {
    if (path.isEmpty) {
      return key;
    }

    return "$path${Node.keyDelimiter}$key";
  }
}

class TextNode extends TranslationNode<String> implements LeafNode {
  TextNode({
    String path = "",
    String value = "",
    Node? parent,
  }) : super(
          path: path,
          unnamedArgCount: TranslationNode.getUnnamedArgCount(value),
          namedArgNameSet: TranslationNode.getNamedArgNameSet(value),
          linkKeySet: TranslationNode.getLinkKeySet(value),
          parent: parent,
          value: value,
        );
}

class PluralNode extends TranslationNode<Map<String, dynamic>>
    implements LeafNode {
  static const preservedKeywords = [
    'few',
    'many',
    'one',
    'other',
    'two',
    'zero',
  ];

  PluralNode(
      {String path = "",
      Map<String, dynamic> plural = const {},
      Node? parent,
      s})
      : super(
          path: path,
          unnamedArgCount: plural.values.fold(0, (previousValue, item) {
            return math.max(
              previousValue,
              TranslationNode.getUnnamedArgCount(item),
            );
          }),
          namedArgNameSet: plural.values.fold<HashSet<String>>(
              HashSet<String>(), (HashSet<String> result, item) {
            final namedArgSet = TranslationNode.getNamedArgNameSet(item);

            result.addAll(namedArgSet);

            return result;
          }),
          linkKeySet: plural.values.fold<HashSet<String>>(HashSet<String>(),
              (HashSet<String> result, item) {
            final linkKeySet = TranslationNode.getLinkKeySet(item);

            result.addAll(linkKeySet);

            return result;
          }),
          parent: parent,
          value: plural,
        );
}

class GenderNode extends TranslationNode<Map<String, dynamic>>
    implements LeafNode {
  static const preservedKeywords = ['male', 'female', 'other'];

  GenderNode({
    String path = "",
    Map<String, dynamic> gender = const {},
    Node? parent,
  }) : super(
          path: path,
          unnamedArgCount: gender.values.fold(0, (previousValue, item) {
            return math.max(
              previousValue,
              TranslationNode.getUnnamedArgCount(item),
            );
          }),
          namedArgNameSet: gender.values.fold<HashSet<String>>(
              HashSet<String>(), (HashSet<String> result, item) {
            final namedArgSet = TranslationNode.getNamedArgNameSet(item);

            result.addAll(namedArgSet);

            return result;
          }),
          linkKeySet: gender.values.fold<HashSet<String>>(HashSet<String>(),
              (HashSet<String> result, item) {
            final linkKeySet = TranslationNode.getLinkKeySet(item);

            result.addAll(linkKeySet);

            return result;
          }),
          parent: parent,
          value: gender,
        );
}

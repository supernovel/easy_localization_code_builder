import 'translation_model.dart';

class TranslationModelBuilder {
  static Node build(Map<String, dynamic> translationData) {
    final rootNode = buildTree(translationData);

    return replaceLink(rootNode);
  }

  static Node replaceLink(Node root) {
    final nodeMap = flattenTree(root);

    return root.mapLeafNode((node) {
      if (node is! TranslationNode) {
        return node;
      }

      if (node.requireLink) {
        node.link(nodeMap);
      }

      return node;
    });
  }

  static Map<String, Node> flattenTree(Node root) {
    return _flattenTree(root);
  }

  static Node buildTree(Map<String, dynamic> translationData) {
    return buildGroupNode("", translationData);
  }

  static Node buildNode(String path, dynamic value) {
    if (value is! Map<String, dynamic>) {
      return buildTextNode(path, value.toString());
    }

    if (isPluralValue(value)) {
      return buildPluralNode(path, value);
    }

    if (isGenderValue(value)) {
      return buildGenderNode(path, value);
    }

    return buildGroupNode(path, value);
  }

  static bool isPluralValue(Map<String, dynamic> value) {
    return _hasOnlyThatKey(value, PluralNode.preservedKeywords);
  }

  static bool isGenderValue(Map<String, dynamic> value) {
    return _hasOnlyThatKey(value, GenderNode.preservedKeywords);
  }

  static GroupNode buildGroupNode(String path, Map<String, dynamic> value) {
    return GroupNode(
      path: path,
      children: value
          .map((key, value) {
            return MapEntry(
              key,
              buildNode(GroupNode.buildChildPath(path, key), value),
            );
          })
          .values
          .toList(),
    );
  }

  static TextNode buildTextNode(String path, String value) {
    return TextNode(path: path, value: value);
  }

  static GenderNode buildGenderNode(String path, Map<String, dynamic> value) {
    return GenderNode(path: path, gender: value);
  }

  static PluralNode buildPluralNode(String path, Map<String, dynamic> value) {
    return PluralNode(path: path, plural: value);
  }
}

bool _hasOnlyThatKey(Map<String, dynamic> value, List<String> expectedKeys) {
  final keys = [...value.keys];

  keys.removeWhere((key) => expectedKeys.contains(key));

  return keys.isEmpty;
}

Map<String, Node> _flattenTree(Node rootNode) {
  final Map<String, Node> result = {};

  for (final node in rootNode.children) {
    if (node is LeafNode) {
      result.addAll({
        node.path: node,
      });
    } else {
      final flattenedSubTree = _flattenTree(node);

      result.addAll(flattenedSubTree.map((path, value) {
        return MapEntry(path, value);
      }));
    }
  }

  return result;
}

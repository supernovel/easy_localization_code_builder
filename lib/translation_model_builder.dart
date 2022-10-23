import 'model/translation_node.dart';
import 'model/translation_node_utils.dart';

Node buildTranslationTree(Map<String, dynamic> translationData) {
  final tree = buildTree(translationData);

  return processLink(tree);
}

// Process Tree
Node processLink(Node root) {
  final nodeMap = generateNodeMap(root);

  return mapLeapNode(root, (child) {
    if (child is! TranslationNode) {
      return child;
    }

    final requireLink = child.linkKeySet.isNotEmpty;

    if (requireLink) {
      return linkFromNodeMap(child, nodeMap);
    }

    return child;
  });
}

Map<String, Node> generateNodeMap(
  Node node, {
  String? parentPath,
}) {
  final currentPath = parentPath ?? node.key;

  String getChildPath(String childKey) {
    return currentPath.isNotEmpty ? "$currentPath.$childKey" : childKey;
  }

  return node.children.fold({}, (previousValue, child) {
    if (child is LeafNode) {
      final childPath = getChildPath(child.key);

      return {
        ...previousValue,
        childPath: child,
      };
    } else {
      return {
        ...previousValue,
        ...generateNodeMap(
          child,
          parentPath: getChildPath(child.key),
        )
      };
    }
  });
}

// Build tree
Node buildTree(Map<String, dynamic> translationData) {
  return buildGroupNode("", translationData);
}

Node buildNode(String key, dynamic value) {
  if (value is! Map<String, dynamic>) {
    return TextNode(key: key, value: value.toString());
  }

  if (value is Map<String, String>) {
    if (isPluralValue(value)) {
      return PluralNode(
        key: key,
        plural: value,
      );
    }

    if (isGenderValue(value)) {
      return GenderNode(key: key, gender: value);
    }
  }

  return buildGroupNode(key, value);
}

TranslationGroupNode buildGroupNode(String key, Map<String, dynamic> value) {
  return TranslationGroupNode(
    key: key,
    children: value
        .map((key, value) {
          return MapEntry(
            key,
            buildNode(key, value),
          );
        })
        .values
        .toList(),
  );
}

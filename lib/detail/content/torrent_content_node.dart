import 'package:qbpanel/api/entity/response/torrent_file_response.dart';
import 'package:qbpanel/l10n/app_localizations.dart';

/// 文件夹优先级不一致时的展示值。
const mixedFilePriority = -1;

class TorrentContentNode {
  TorrentContentNode({
    required this.name,
    required this.path,
    required this.isFolder,
    this.apiPath,
    this.fileIndex,
    this.size = 0,
    this.progress = 0,
    this.priority = 1,
    this.availability = 0,
    List<TorrentContentNode>? children,
  }) : children = children ?? [];

  /// 卡片上的短名称（路径最后一段），如 `ep1.mkv`。
  /// 不是 `/api/v2/torrents/files` 的 `name`。
  final String name;

  /// 展示用树路径，已去掉 `.unwanted`，如 `Season 1/ep1.mkv`。
  final String path;
  final bool isFolder;

  /// 文件在 `/api/v2/torrents/files` 里的原始 `name`（完整相对路径，
  /// 可能含 `.unwanted`）。文件夹没有对应 files 项，为 `null`。
  /// 重命名必须用这个，不能用 [name] 或 [path]。
  final String? apiPath;
  final int? fileIndex;
  final List<TorrentContentNode> children;

  int size;
  double progress;
  int priority;
  double availability;

  int get remaining {
    final left = size * (1 - progress.clamp(0.0, 1.0));
    return left.round().clamp(0, size);
  }

  bool get hasChildren => children.isNotEmpty;

  /// 重命名接口的 `oldPath`：文件用 [apiPath]，文件夹用 [path]。
  String get renameOldPath {
    final api = apiPath?.trim();
    if (api != null && api.isNotEmpty) return api;
    return path;
  }

  /// 该节点下所有文件的 `index`（文件夹会递归）。
  List<int> get fileIndexes {
    if (!isFolder) {
      return fileIndex == null ? const [] : [fileIndex!];
    }
    return [for (final child in children) ...child.fileIndexes];
  }

  void applyPriority(int priority) {
    if (!isFolder) {
      this.priority = priority;
      return;
    }
    for (final child in children) {
      child.applyPriority(priority);
    }
    this.priority = priority;
  }
}

class TorrentContentRow {
  const TorrentContentRow({required this.node, required this.depth});

  final TorrentContentNode node;
  final int depth;
}

/// 由 `files` 扁平列表建成树；跳过 `.unwanted` 目录段（与 Web 一致）。
List<TorrentContentNode> buildContentTree(List<TorrentFileResponse> files) {
  final root = TorrentContentNode(name: '', path: '', isFolder: true);
  for (final file in files) {
    final raw = file.name ?? '';
    final parts = raw
        .split(RegExp(r'[/\\]'))
        .where((part) => part.isNotEmpty && part != '.unwanted')
        .toList();
    if (parts.isEmpty) continue;
    _insertFile(root, parts, file);
  }
  recomputeContentFolders(root.children);
  return root.children;
}

void recomputeContentFolders(List<TorrentContentNode> roots) {
  for (final root in roots) {
    _finalizeFolder(root);
  }
}

void _insertFile(
  TorrentContentNode parent,
  List<String> parts,
  TorrentFileResponse file,
) {
  if (parts.length == 1) {
    parent.children.add(
      TorrentContentNode(
        name: parts.single,
        path: parent.path.isEmpty
            ? parts.single
            : '${parent.path}/${parts.single}',
        isFolder: false,
        apiPath: file.name,
        fileIndex: file.index,
        size: file.size ?? 0,
        progress: (file.progress ?? 0).clamp(0.0, 1.0),
        priority: _normalizePriority(file.priority),
        availability: file.availability ?? 0,
      ),
    );
    return;
  }

  final head = parts.first;
  final path = parent.path.isEmpty ? head : '${parent.path}/$head';
  TorrentContentNode? folder;
  for (final child in parent.children) {
    if (child.isFolder && child.name == head) {
      folder = child;
      break;
    }
  }
  if (folder == null) {
    folder = TorrentContentNode(name: head, path: path, isFolder: true);
    parent.children.add(folder);
  }
  _insertFile(folder, parts.sublist(1), file);
}

int _normalizePriority(int? priority) {
  switch (priority) {
    case 0:
    case 1:
    case 6:
    case 7:
      return priority!;
    default:
      return 1;
  }
}

void _finalizeFolder(TorrentContentNode node) {
  if (!node.isFolder) return;
  for (final child in node.children) {
    _finalizeFolder(child);
  }
  if (node.children.isEmpty) return;

  var size = 0;
  var completed = 0.0;
  var availWeighted = 0.0;
  int? sharedPriority;
  var mixed = false;
  for (final child in node.children) {
    size += child.size;
    completed += child.size * child.progress.clamp(0.0, 1.0);
    availWeighted += child.size * child.availability;
    if (sharedPriority == null) {
      sharedPriority = child.priority;
    } else if (sharedPriority != child.priority) {
      mixed = true;
    }
  }
  node.size = size;
  node.progress = size > 0 ? (completed / size).clamp(0.0, 1.0) : 0;
  node.availability = size > 0 ? availWeighted / size : 0;
  node.priority = mixed ? mixedFilePriority : (sharedPriority ?? 1);
}

List<TorrentContentRow> flattenContentTree(
  List<TorrentContentNode> roots,
  Set<String> collapsedPaths,
) {
  final rows = <TorrentContentRow>[];
  void walk(TorrentContentNode node, int depth) {
    rows.add(TorrentContentRow(node: node, depth: depth));
    if (node.isFolder && !collapsedPaths.contains(node.path)) {
      for (final child in node.children) {
        walk(child, depth + 1);
      }
    }
  }

  for (final root in roots) {
    walk(root, 0);
  }
  return rows;
}

String contentParentPath(String path) {
  final slash = path.lastIndexOf('/');
  final backslash = path.lastIndexOf('\\');
  final i = slash > backslash ? slash : backslash;
  if (i < 0) return '';
  return path.substring(0, i);
}

String contentJoinPath(String parent, String name) {
  if (parent.isEmpty) return name;
  final sep = parent.contains('\\') && !parent.contains('/') ? '\\' : '/';
  return '$parent$sep$name';
}

Set<String> remapCollapsedPaths(
  Set<String> paths,
  String oldPath,
  String newPath,
) {
  if (oldPath.isEmpty || oldPath == newPath) return paths;
  final prefix = '$oldPath/';
  return {
    for (final path in paths)
      if (path == oldPath)
        newPath
      else if (path.startsWith(prefix))
        '$newPath/${path.substring(prefix.length)}'
      else
        path,
  };
}

String filePriorityLabel(int priority, AppLocalizations l10n) {
  switch (priority) {
    case 0:
      return l10n.priorityDoNotDownload;
    case 6:
      return l10n.priorityHigh;
    case 7:
      return l10n.priorityMaximum;
    case mixedFilePriority:
      return l10n.priorityMixed;
    default:
      return l10n.priorityNormal;
  }
}

import 'package:flutter/material.dart';
import 'package:ouisync/ouisync.dart' show EntryType;
import 'package:ouisync_app/app/models/models.dart'
    show FileSystemEntry, Folder;

import '../cubits/cubits.dart' show RepoCubit;
import '../widgets/widgets.dart' show DisambiguationAction;
import 'repo_path.dart' as repo_path;
import 'utils.dart' show AppLogger, EntryOps;

class MoveEntry with EntryOps, AppLogger {
  MoveEntry(
    BuildContext context, {
    required RepoCubit originRepoCubit,
    required FileSystemEntry entry,
    required String destinationPath,
  })  : _context = context,
        _originRepoCubit = originRepoCubit,
        _entry = entry,
        _destinationPath = destinationPath;

  final BuildContext _context;
  final RepoCubit _originRepoCubit;
  final FileSystemEntry _entry;
  final String _destinationPath;

  Future<void> move({
    required RepoCubit? currentRepoCubit,
    required String fromPathSegment,
    required bool recursive,
  }) async {
    final path = _entry.path;
    final type = _entry is Folder ? EntryType.directory : EntryType.file;

    final destinationRepoCubit = (currentRepoCubit ?? _originRepoCubit);
    final newPath = repo_path.join(_destinationPath, fromPathSegment);

    final exist = await destinationRepoCubit.exists(newPath);
    if (!exist) {
      await _pickModeAndMoveEntry(
        currentRepoCubit,
        path,
        newPath,
        type,
        recursive,
      );
      return;
    }

    final disambiguationAction = await pickEntryDisambiguationAction(
      _context,
      newPath,
      type,
    );
    switch (disambiguationAction) {
      case DisambiguationAction.replace:
        await _moveAndReplaceFile(currentRepoCubit, path, newPath);
        break;
      case DisambiguationAction.keep:
        await _renameAndMove(currentRepoCubit, path, newPath, type, recursive);
        break;
      default:
        break;
    }
  }

  Future<void> _moveAndReplaceFile(
    RepoCubit? destinationRepoCubit,
    String sourcePath,
    String destinationPath,
  ) async {
    try {
      final file = await _originRepoCubit.openFile(sourcePath);
      final fileLength = await file.length;

      await (destinationRepoCubit ?? _originRepoCubit).replaceFile(
        filePath: destinationPath,
        length: fileLength,
        fileByteStream: file.read(0, fileLength).asStream(),
      );

      await _originRepoCubit.deleteFile(sourcePath);
    } catch (e, st) {
      loggy.debug(e, st);
    }
  }

  Future<void> _renameAndMove(
    RepoCubit? toRepoCubit,
    String srcPath,
    String dstPath,
    EntryType type,
    bool recursive,
  ) async {
    final newPath = await disambiguateEntryName(
      repoCubit: (toRepoCubit ?? _originRepoCubit),
      path: dstPath,
    );

    await _pickModeAndMoveEntry(toRepoCubit, srcPath, newPath, type, recursive);
  }

  Future<void> _pickModeAndMoveEntry(
    RepoCubit? destinationRepoCubit,
    String sourcePath,
    String destinationPath,
    EntryType type,
    bool recursive,
  ) async {
    if (destinationRepoCubit == null) {
      await _originRepoCubit.moveEntry(
        source: sourcePath,
        destination: destinationPath,
      );

      return;
    }

    await _originRepoCubit.moveEntryToRepo(
      destinationRepoCubit: destinationRepoCubit,
      type: type,
      source: sourcePath,
      destination: destinationPath,
      recursive: recursive,
    );
  }
}

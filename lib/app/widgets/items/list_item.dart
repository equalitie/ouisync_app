import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/cubits.dart'
    show EntrySelectionCubit, EntrySelectionState, Job, RepoCubit, RepoState;
import '../../models/models.dart' show DirectoryEntry, FileEntry, RepoLocation;
import '../../utils/utils.dart' show Constants, Dimensions, Fields, ThemeGetter;
import '../widgets.dart'
    show
        FileDescription,
        FileIconAnimated,
        MissingRepoDescription,
        RepoDescription,
        RepoStatus,
        ScrollableTextWidget,
        SelectionState;

class FileListItem extends StatelessWidget {
  FileListItem({
    super.key,
    required this.entry,
    required this.repoCubit,
    required this.mainAction,
    required this.verticalDotsAction,
  });

  final FileEntry entry;
  final RepoCubit repoCubit;
  final void Function() mainAction;
  final void Function() verticalDotsAction;

  final ValueNotifier<bool> _isSelecting = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _selected = ValueNotifier<bool>(false);
  final ValueNotifier<Color?> _backgroundColor = ValueNotifier<Color?>(null);

  @override
  Widget build(BuildContext context) {
    // TODO: should this be inside of a BlockBuilder of fileItem.repoCubit?
    final repoInfoHash = repoCubit.state.infoHash;
    final path = entry.path;

    final entrySelectionCubit = repoCubit.entrySelectionCubit;
    final entrySelectionState = entrySelectionCubit.state;

    final isSelecting =
        entrySelectionState.originRepoInfoHash == repoInfoHash &&
            entrySelectionState.selectionState == SelectionState.on;
    _isSelecting.value = isSelecting;

    final isSelected = entrySelectionState.isEntrySelected(
      repoInfoHash,
      path,
    );

    final onAddEntry = repoCubit.entrySelectionCubit.addEntry;
    final onRemoveEntry = repoCubit.entrySelectionCubit.removeEntry;

    _updateSelection(
      context,
      isSelected,
      repoInfoHash: repoInfoHash,
      path: path,
      isFolder: false,
      valueNotifier: _selected,
      colorNotifier: _backgroundColor,
      onAddEntry: onAddEntry,
      onRemoveEntry: onRemoveEntry,
    );

    final uploadJob = repoCubit.state.uploads[entry.path];
    final downloadJob = repoCubit.state.downloads[entry.path];

    return ValueListenableBuilder(
      valueListenable: _backgroundColor,
      builder: (context, stateColor, child) => _ListItemContainer(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FileIconAnimated(downloadJob),
            Expanded(
              child: Container(
                padding: Dimensions.paddingItem,
                child: FileDescription(repoCubit, entry, uploadJob),
              ),
            ),
            TrailAction(
              repoInfoHash,
              path,
              false,
              entrySelectionCubit: entrySelectionCubit,
              isSelectingNotifier: _isSelecting,
              selectedNotifier: _selected,
              backgroundColorNotifier: _backgroundColor,
              onAddEntry: onAddEntry,
              onRemoveEntry: onRemoveEntry,
              uploadJob: uploadJob,
              verticalDotsAction: verticalDotsAction,
            ),
          ],
        ),
        mainAction: mainAction,
        backgroundColor: stateColor,
      ),
    );
  }
}

class DirectoryListItem extends StatelessWidget {
  DirectoryListItem({
    super.key,
    required this.entry,
    required this.repoCubit,
    required this.mainAction,
    required this.verticalDotsAction,
  });

  final DirectoryEntry entry;
  final RepoCubit repoCubit;
  final void Function() mainAction;
  final void Function() verticalDotsAction;

  final ValueNotifier<bool> _isSelecting = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _selected = ValueNotifier<bool>(false);
  final ValueNotifier<Color?> _backgroundColor = ValueNotifier<Color?>(null);

  @override
  Widget build(BuildContext context) {
    final repoInfoHash = repoCubit.state.infoHash;
    final path = entry.path;

    final entrySelectionCubit = repoCubit.entrySelectionCubit;
    final entrySelectionState = entrySelectionCubit.state;

    final isSelecting =
        entrySelectionState.originRepoInfoHash == repoInfoHash &&
            entrySelectionState.selectionState == SelectionState.on;
    _isSelecting.value = isSelecting;

    final isSelected = entrySelectionState.isEntrySelected(
      repoInfoHash,
      entry.path,
    );

    final onAddEntry = repoCubit.entrySelectionCubit.addEntry;
    final onRemoveEntry = repoCubit.entrySelectionCubit.removeEntry;

    _updateSelection(
      context,
      isSelected,
      repoInfoHash: repoInfoHash,
      path: path,
      isFolder: true,
      valueNotifier: _selected,
      colorNotifier: _backgroundColor,
      onAddEntry: onAddEntry,
      onRemoveEntry: onRemoveEntry,
    );

    return ValueListenableBuilder(
      valueListenable: _backgroundColor,
      builder: (context, stateColor, child) => _ListItemContainer(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.folder_rounded,
              size: Dimensions.sizeIconAverage,
              color: Constants.folderIconColor,
            ),
            Expanded(
              child: Container(
                padding: Dimensions.paddingItem,
                child: ScrollableTextWidget(child: Text(entry.name)),
              ),
            ),
            TrailAction(
              repoInfoHash,
              path,
              true,
              entrySelectionCubit: entrySelectionCubit,
              isSelectingNotifier: _isSelecting,
              selectedNotifier: _selected,
              backgroundColorNotifier: _backgroundColor,
              onAddEntry: onAddEntry,
              onRemoveEntry: onRemoveEntry,
              uploadJob: null,
              verticalDotsAction: verticalDotsAction,
            ),
          ],
        ),
        mainAction: mainAction,
        backgroundColor: stateColor,
      ),
    );
  }
}

class RepoListItem extends StatelessWidget {
  RepoListItem({
    super.key,
    required this.repoCubit,
    required this.isDefault,
    required this.mainAction,
    required this.verticalDotsAction,
  });

  final RepoCubit repoCubit;
  final bool isDefault;
  final void Function() mainAction;
  final void Function() verticalDotsAction;

  @override
  Widget build(BuildContext context) => _ListItemContainer(
        child: BlocBuilder<RepoCubit, RepoState>(
          bloc: repoCubit,
          builder: (context, state) => Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Fields.accessModeIcon(state.accessMode),
                  size: Dimensions.sizeIconAverage,
                ),
                color: Constants.folderIconColor,
                padding: EdgeInsets.all(0.0),
                onPressed: () => repoCubit.lock(),
              ),
              Expanded(
                child: Container(
                  padding: Dimensions.paddingItem,
                  child: RepoDescription(
                    state,
                    isDefault: isDefault,
                  ),
                ),
              ),
              RepoStatus(repoCubit),
              _VerticalDotsButton(verticalDotsAction),
            ],
          ),
        ),
        mainAction: mainAction,
      );
}

class MissingRepoListItem extends StatelessWidget {
  MissingRepoListItem({
    super.key,
    required this.location,
    required this.mainAction,
    required this.verticalDotsAction,
  });

  final RepoLocation location;
  final void Function() mainAction;
  final void Function() verticalDotsAction;

  @override
  Widget build(BuildContext context) => _ListItemContainer(
        mainAction: mainAction,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Icon(
                Icons.error_outline_rounded,
                size: Dimensions.sizeIconAverage,
                color: Constants.folderIconColor,
              ),
            ),
            Expanded(
              flex: 9,
              child: Padding(
                padding: Dimensions.paddingItem,
                child: MissingRepoDescription(location.name),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                size: Dimensions.sizeIconMicro,
                color: Constants.dangerColor,
              ),
              onPressed: () => verticalDotsAction(),
            )
          ],
        ),
      );
}

class _ListItemContainer extends StatelessWidget {
  _ListItemContainer({
    required this.child,
    required this.mainAction,
    this.backgroundColor,
  });

  final Widget child;
  final Function mainAction;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => Material(
        color: backgroundColor,
        child: InkWell(
          onTap: () => mainAction.call(),
          splashColor: Colors.blue,
          child: Container(
            padding: Dimensions.paddingListItem,
            child: child,
          ),
        ),
      );
}

class TrailAction extends StatelessWidget {
  const TrailAction(
    this.repoInfoHash,
    this.path,
    this.isFolder, {
    required this.entrySelectionCubit,
    required ValueNotifier<bool> isSelectingNotifier,
    required ValueNotifier<bool> selectedNotifier,
    required ValueNotifier<Color?> backgroundColorNotifier,
    required this.onAddEntry,
    required this.onRemoveEntry,
    required this.uploadJob,
    required this.verticalDotsAction,
    super.key,
  })  : _isSelectingNotifier = isSelectingNotifier,
        _selectedNotifier = selectedNotifier,
        _backgroundColorNotifier = backgroundColorNotifier;

  final String repoInfoHash;
  final String path;
  final bool isFolder;

  final EntrySelectionCubit entrySelectionCubit;

  final ValueNotifier<bool> _isSelectingNotifier;
  final ValueNotifier<bool> _selectedNotifier;
  final ValueNotifier<Color?> _backgroundColorNotifier;

  final Future<void> Function(String, String, bool) onAddEntry;
  final Future<void> Function(String, String) onRemoveEntry;

  final Job? uploadJob;
  final void Function() verticalDotsAction;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EntrySelectionCubit, EntrySelectionState>(
      bloc: entrySelectionCubit,
      listener: (context, state) async {
        if (repoInfoHash != state.originRepoInfoHash) return;

        final selectionState = state.selectionState;
        _isSelectingNotifier.value = selectionState == SelectionState.on;

        if (selectionState == SelectionState.off) {
          await _updateSelection(
            context,
            false,
            repoInfoHash: repoInfoHash,
            path: path,
            isFolder: isFolder,
            valueNotifier: _selectedNotifier,
            colorNotifier: _backgroundColorNotifier,
            onAddEntry: onAddEntry,
            onRemoveEntry: onRemoveEntry,
          );
        }
      },
      child: ValueListenableBuilder(
        valueListenable: _isSelectingNotifier,
        builder: (context, isSelecting, child) {
          return isSelecting
              ? ValueListenableBuilder(
                  valueListenable: _selectedNotifier,
                  builder: (
                    BuildContext context,
                    dynamic value,
                    Widget? child,
                  ) =>
                      Checkbox.adaptive(
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    value: value,
                    onChanged: (value) async {
                      if (value == null) return;

                      await _updateSelection(
                        context,
                        value,
                        repoInfoHash: repoInfoHash,
                        path: path,
                        isFolder: isFolder,
                        valueNotifier: _selectedNotifier,
                        colorNotifier: _backgroundColorNotifier,
                        onAddEntry: onAddEntry,
                        onRemoveEntry: onRemoveEntry,
                      );
                    },
                  ),
                )
              : _VerticalDotsButton(
                  uploadJob == null ? verticalDotsAction : null,
                );
        },
      ),
    );
  }
}

Future<void> _updateSelection(
  BuildContext context,
  bool value, {
  required String repoInfoHash,
  required String path,
  required bool isFolder,
  required ValueNotifier<bool> valueNotifier,
  required ValueNotifier<Color?> colorNotifier,
  required Future<void> Function(String, String, bool) onAddEntry,
  required Future<void> Function(String, String) onRemoveEntry,
}) async {
  value
      ? await onAddEntry(repoInfoHash, path, isFolder)
      : await onRemoveEntry(repoInfoHash, path);

  valueNotifier.value = value;
  _getBackgroundColor(
    context,
    notifier: colorNotifier,
    value: value,
  );
}

void _getBackgroundColor(
  BuildContext context, {
  required ValueNotifier<Color?> notifier,
  required bool value,
}) =>
    notifier.value = switch (value) {
      true => context.theme.highlightColor,
      false => Colors.white,
    };

class _VerticalDotsButton extends StatelessWidget {
  _VerticalDotsButton(this.action);

  final void Function()? action;

  @override
  Widget build(BuildContext context) => IconButton(
        key: ValueKey('file_vert'),
        icon: const Icon(
          Icons.more_vert_rounded,
          size: Dimensions.sizeIconSmall,
        ),
        onPressed: action,
      );
}

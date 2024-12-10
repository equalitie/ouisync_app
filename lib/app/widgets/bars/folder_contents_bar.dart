import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ouisync_app/app/cubits/cubits.dart'
    show
        EntrySelectionCubit,
        EntrySelectionState,
        RepoCubit,
        ReposCubit,
        SortListCubit;
import 'package:ouisync_app/app/utils/utils.dart' show ThemeGetter;
import 'package:ouisync_app/app/widgets/widgets.dart'
    show SelectEntriesButton, SelectionState, SortContentsBar;

class FolderContentsBar extends StatefulWidget {
  const FolderContentsBar({
    required this.reposCubit,
    required this.repoCubit,
    required this.hasContents,
    required this.sortListCubit,
    required this.entrySelectionCubit,
    super.key,
  });

  final ReposCubit reposCubit;
  final RepoCubit repoCubit;
  final bool hasContents;
  final SortListCubit sortListCubit;
  final EntrySelectionCubit entrySelectionCubit;

  @override
  State<FolderContentsBar> createState() => _FolderContentsBarState();
}

class _FolderContentsBarState extends State<FolderContentsBar> {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<EntrySelectionCubit, EntrySelectionState>(
        bloc: widget.entrySelectionCubit,
        builder: (context, state) => Container(
          padding:
              EdgeInsetsDirectional.symmetric(vertical: 4.0, horizontal: 2.0),
          color: _getColorState(state.selectionState),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.hasContents)
                SortContentsBar(
                  sortListCubit: widget.sortListCubit,
                  reposCubit: widget.reposCubit,
                ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (widget.hasContents ||
                        state.selectionState == SelectionState.on)
                      SelectEntriesButton(
                        reposCubit: widget.reposCubit,
                        repoCubit: widget.repoCubit,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Color? _getColorState(SelectionState state) => switch (state) {
        SelectionState.off => Colors.transparent,
        SelectionState.on => context.theme.secondaryHeaderColor,
      };
}

import 'package:equatable/equatable.dart';
import 'package:ouisync_plugin/ouisync_plugin.dart' as oui;

import '../cubits/cubits.dart';
import '../models/models.dart';

sealed class RepoEntry extends Equatable {
  RepoLocation get location;
  RepoCubit? get cubit => null;
  PasswordMode? get passwordMode => null;

  String get name => location.name;
  String? get infoHash => cubit?.state.infoHash;
  oui.AccessMode get accessMode => cubit?.accessMode ?? oui.AccessMode.blind;

  Future<void> close();

  @override
  List<Object> get props => [name, runtimeType];
}

class LoadingRepoEntry extends RepoEntry {
  LoadingRepoEntry(this.location);

  @override
  final RepoLocation location;

  @override
  Future<void> close() async {}
}

class OpenRepoEntry extends RepoEntry {
  OpenRepoEntry(this.cubit);

  @override
  final RepoCubit cubit;

  @override
  Future<void> close() async {
    await cubit.close();
  }

  @override
  RepoLocation get location => cubit.location;

  @override
  PasswordMode get passwordMode => cubit.state.authMode.passwordMode;
}

class MissingRepoEntry extends RepoEntry {
  MissingRepoEntry(
    this.location,
    this.error,
    this.errorDescription,
  );

  @override
  final RepoLocation location;

  final String error;
  final String? errorDescription;

  @override
  Future<void> close() async {}
}

class ErrorRepoEntry extends RepoEntry {
  ErrorRepoEntry(
    this.location,
    this.error,
    this.errorDescription,
  );

  @override
  final RepoLocation location;

  final String error;
  final String? errorDescription;

  @override
  Future<void> close() async {}
}

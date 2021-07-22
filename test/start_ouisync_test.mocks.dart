// Mocks generated by Mockito 5.0.10 from annotations
// in ouisync_app/test/start_ouisync_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;

import 'package:bloc/src/bloc.dart' as _i8;
import 'package:bloc/src/transition.dart' as _i14;
import 'package:mockito/mockito.dart' as _i1;
import 'package:ouisync_app/app/bloc/directory/directorybloc.dart' as _i15;
import 'package:ouisync_app/app/bloc/directory/directoryevent.dart' as _i16;
import 'package:ouisync_app/app/bloc/directory/directorystate.dart' as _i7;
import 'package:ouisync_app/app/bloc/navigation/nav_bloc.dart' as _i12;
import 'package:ouisync_app/app/bloc/navigation/nav_event.dart' as _i13;
import 'package:ouisync_app/app/bloc/navigation/nav_state.dart' as _i4;
import 'package:ouisync_app/app/bloc/route/route_bloc.dart' as _i9;
import 'package:ouisync_app/app/data/repositories/directoryrepository.dart'
    as _i6;
import 'package:ouisync_app/app/models/item/baseitem.dart' as _i11;
import 'package:ouisync_app/app/utils/basic_result.dart' as _i3;
import 'package:ouisync_plugin/bindings.dart' as _i2;
import 'package:ouisync_plugin/ouisync_plugin.dart' as _i10;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeBindings extends _i1.Fake implements _i2.Bindings {}

class _FakeBasicResult<T> extends _i1.Fake implements _i3.BasicResult<T> {}

class _FakeNavigationState extends _i1.Fake implements _i4.NavigationState {}

class _FakeStreamSubscription<T> extends _i1.Fake
    implements _i5.StreamSubscription<T> {}

class _FakeDirectoryRepository extends _i1.Fake
    implements _i6.DirectoryRepository {}

class _FakeDirectoryState extends _i1.Fake implements _i7.DirectoryState {}

class _FakeBloc<Event, State> extends _i1.Fake
    implements _i8.Bloc<Event, State> {}

class _FakeRouteState extends _i1.Fake implements _i9.RouteState {}

/// A class which mocks [Session].
///
/// See the documentation for Mockito's code generation for more information.
class MockSession extends _i1.Mock implements _i10.Session {
  MockSession() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Bindings get bindings => (super.noSuchMethod(Invocation.getter(#bindings),
      returnValue: _FakeBindings()) as _i2.Bindings);
  @override
  void close() => super.noSuchMethod(Invocation.method(#close, []),
      returnValueForMissingStub: null);
}

/// A class which mocks [DirectoryRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockDirectoryRepository extends _i1.Mock
    implements _i6.DirectoryRepository {
  MockDirectoryRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<_i3.BasicResult<dynamic>> createFile(
          _i10.Session? session, String? newFilePath) =>
      (super.noSuchMethod(
              Invocation.method(#createFile, [session, newFilePath]),
              returnValue: Future<_i3.BasicResult<dynamic>>.value(
                  _FakeBasicResult<dynamic>()))
          as _i5.Future<_i3.BasicResult<dynamic>>);
  @override
  _i5.Future<_i3.BasicResult<dynamic>> writeFile(_i10.Session? session,
          String? filePath, _i5.Stream<List<int>>? fileStream) =>
      (super.noSuchMethod(
              Invocation.method(#writeFile, [session, filePath, fileStream]),
              returnValue: Future<_i3.BasicResult<dynamic>>.value(
                  _FakeBasicResult<dynamic>()))
          as _i5.Future<_i3.BasicResult<dynamic>>);
  @override
  _i5.Future<_i3.BasicResult<dynamic>> readFile(
          _i10.Session? session, String? filePath, {String? action = r''}) =>
      (super.noSuchMethod(
          Invocation.method(#readFile, [session, filePath], {#action: action}),
          returnValue: Future<_i3.BasicResult<dynamic>>.value(
              _FakeBasicResult<dynamic>())) as _i5
          .Future<_i3.BasicResult<dynamic>>);
  @override
  _i5.Future<_i3.BasicResult<dynamic>> deleteFile(
          _i10.Session? session, String? filePath) =>
      (super.noSuchMethod(Invocation.method(#deleteFile, [session, filePath]),
              returnValue: Future<_i3.BasicResult<dynamic>>.value(
                  _FakeBasicResult<dynamic>()))
          as _i5.Future<_i3.BasicResult<dynamic>>);
  @override
  _i5.Future<_i3.BasicResult<dynamic>> createFolder(
          _i10.Session? session, String? path) =>
      (super.noSuchMethod(Invocation.method(#createFolder, [session, path]),
              returnValue: Future<_i3.BasicResult<dynamic>>.value(
                  _FakeBasicResult<dynamic>()))
          as _i5.Future<_i3.BasicResult<dynamic>>);
  @override
  _i5.Future<_i3.BasicResult<dynamic>> getFolderContents(
          _i10.Session? session, String? path) =>
      (super.noSuchMethod(
              Invocation.method(#getFolderContents, [session, path]),
              returnValue: Future<_i3.BasicResult<dynamic>>.value(
                  _FakeBasicResult<dynamic>()))
          as _i5.Future<_i3.BasicResult<dynamic>>);
  @override
  _i5.Future<List<_i11.BaseItem>> getContentsRecursive(
          _i10.Session? session, String? path) =>
      (super.noSuchMethod(
              Invocation.method(#getContentsRecursive, [session, path]),
              returnValue: Future<List<_i11.BaseItem>>.value(<_i11.BaseItem>[]))
          as _i5.Future<List<_i11.BaseItem>>);
  @override
  _i5.Future<_i3.BasicResult<dynamic>> deleteFolder(
          _i10.Session? session, String? path) =>
      (super.noSuchMethod(Invocation.method(#deleteFolder, [session, path]),
              returnValue: Future<_i3.BasicResult<dynamic>>.value(
                  _FakeBasicResult<dynamic>()))
          as _i5.Future<_i3.BasicResult<dynamic>>);
}

/// A class which mocks [NavigationBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockNavigationBloc extends _i1.Mock implements _i12.NavigationBloc {
  MockNavigationBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get rootPath =>
      (super.noSuchMethod(Invocation.getter(#rootPath), returnValue: '')
          as String);
  @override
  _i4.NavigationState get state =>
      (super.noSuchMethod(Invocation.getter(#state),
          returnValue: _FakeNavigationState()) as _i4.NavigationState);
  @override
  _i5.Stream<_i4.NavigationState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<_i4.NavigationState>.empty())
          as _i5.Stream<_i4.NavigationState>);
  @override
  _i5.Stream<_i4.NavigationState> mapEventToState(
          _i13.NavigationEvent? event) =>
      (super.noSuchMethod(Invocation.method(#mapEventToState, [event]),
              returnValue: Stream<_i4.NavigationState>.empty())
          as _i5.Stream<_i4.NavigationState>);
  @override
  void add(_i13.NavigationEvent? event) =>
      super.noSuchMethod(Invocation.method(#add, [event]),
          returnValueForMissingStub: null);
  @override
  void onEvent(_i13.NavigationEvent? event) =>
      super.noSuchMethod(Invocation.method(#onEvent, [event]),
          returnValueForMissingStub: null);
  @override
  _i5.Stream<
      _i14.Transition<_i13.NavigationEvent, _i4.NavigationState>> transformEvents(
          _i5.Stream<_i13.NavigationEvent>? events,
          _i8.TransitionFunction<_i13.NavigationEvent, _i4.NavigationState>?
              transitionFn) =>
      (super.noSuchMethod(
              Invocation.method(#transformEvents, [events, transitionFn]),
              returnValue:
                  Stream<_i14.Transition<_i13.NavigationEvent, _i4.NavigationState>>.empty())
          as _i5.Stream<
              _i14.Transition<_i13.NavigationEvent, _i4.NavigationState>>);
  @override
  void emit(_i4.NavigationState? state) =>
      super.noSuchMethod(Invocation.method(#emit, [state]),
          returnValueForMissingStub: null);
  @override
  void onTransition(
          _i14.Transition<_i13.NavigationEvent, _i4.NavigationState>?
              transition) =>
      super.noSuchMethod(Invocation.method(#onTransition, [transition]),
          returnValueForMissingStub: null);
  @override
  _i5.Stream<
      _i14.Transition<_i13.NavigationEvent, _i4.NavigationState>> transformTransitions(
          _i5.Stream<_i14.Transition<_i13.NavigationEvent, _i4.NavigationState>>?
              transitions) =>
      (super.noSuchMethod(
              Invocation.method(#transformTransitions, [transitions]),
              returnValue:
                  Stream<_i14.Transition<_i13.NavigationEvent, _i4.NavigationState>>.empty())
          as _i5.Stream<
              _i14.Transition<_i13.NavigationEvent, _i4.NavigationState>>);
  @override
  _i5.Future<void> close() => (super.noSuchMethod(Invocation.method(#close, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future.value()) as _i5.Future<void>);
  @override
  _i5.StreamSubscription<_i4.NavigationState> listen(
          void Function(_i4.NavigationState)? onData,
          {Function? onError,
          void Function()? onDone,
          bool? cancelOnError}) =>
      (super.noSuchMethod(
              Invocation.method(#listen, [
                onData
              ], {
                #onError: onError,
                #onDone: onDone,
                #cancelOnError: cancelOnError
              }),
              returnValue: _FakeStreamSubscription<_i4.NavigationState>())
          as _i5.StreamSubscription<_i4.NavigationState>);
  @override
  void onChange(_i14.Change<_i4.NavigationState>? change) =>
      super.noSuchMethod(Invocation.method(#onChange, [change]),
          returnValueForMissingStub: null);
  @override
  void addError(Object? error, [StackTrace? stackTrace]) =>
      super.noSuchMethod(Invocation.method(#addError, [error, stackTrace]),
          returnValueForMissingStub: null);
  @override
  void onError(Object? error, StackTrace? stackTrace) =>
      super.noSuchMethod(Invocation.method(#onError, [error, stackTrace]),
          returnValueForMissingStub: null);
}

/// A class which mocks [DirectoryBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockDirectoryBloc extends _i1.Mock implements _i15.DirectoryBloc {
  MockDirectoryBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.DirectoryRepository get blocRepository =>
      (super.noSuchMethod(Invocation.getter(#blocRepository),
          returnValue: _FakeDirectoryRepository()) as _i6.DirectoryRepository);
  @override
  _i7.DirectoryState get state => (super.noSuchMethod(Invocation.getter(#state),
      returnValue: _FakeDirectoryState()) as _i7.DirectoryState);
  @override
  _i5.Stream<_i7.DirectoryState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<_i7.DirectoryState>.empty())
          as _i5.Stream<_i7.DirectoryState>);
  @override
  _i5.Stream<_i7.DirectoryState> mapEventToState(_i16.DirectoryEvent? event) =>
      (super.noSuchMethod(Invocation.method(#mapEventToState, [event]),
              returnValue: Stream<_i7.DirectoryState>.empty())
          as _i5.Stream<_i7.DirectoryState>);
  @override
  _i5.Future<_i7.DirectoryState> getFolderContents(
          _i10.Session? session, String? folderPath) =>
      (super.noSuchMethod(
              Invocation.method(#getFolderContents, [session, folderPath]),
              returnValue:
                  Future<_i7.DirectoryState>.value(_FakeDirectoryState()))
          as _i5.Future<_i7.DirectoryState>);
  @override
  void add(_i16.DirectoryEvent? event) =>
      super.noSuchMethod(Invocation.method(#add, [event]),
          returnValueForMissingStub: null);
  @override
  void onEvent(_i16.DirectoryEvent? event) =>
      super.noSuchMethod(Invocation.method(#onEvent, [event]),
          returnValueForMissingStub: null);
  @override
  _i5.Stream<
      _i14.Transition<_i16.DirectoryEvent, _i7.DirectoryState>> transformEvents(
          _i5.Stream<_i16.DirectoryEvent>? events,
          _i8.TransitionFunction<_i16.DirectoryEvent, _i7.DirectoryState>?
              transitionFn) =>
      (super.noSuchMethod(
              Invocation.method(#transformEvents, [events, transitionFn]),
              returnValue:
                  Stream<_i14.Transition<_i16.DirectoryEvent, _i7.DirectoryState>>.empty())
          as _i5.Stream<
              _i14.Transition<_i16.DirectoryEvent, _i7.DirectoryState>>);
  @override
  void emit(_i7.DirectoryState? state) =>
      super.noSuchMethod(Invocation.method(#emit, [state]),
          returnValueForMissingStub: null);
  @override
  void onTransition(
          _i14.Transition<_i16.DirectoryEvent, _i7.DirectoryState>?
              transition) =>
      super.noSuchMethod(Invocation.method(#onTransition, [transition]),
          returnValueForMissingStub: null);
  @override
  _i5.Stream<_i14.Transition<_i16.DirectoryEvent, _i7.DirectoryState>>
      transformTransitions(
              _i5.Stream<_i14.Transition<_i16.DirectoryEvent, _i7.DirectoryState>>?
                  transitions) =>
          (super.noSuchMethod(
              Invocation.method(#transformTransitions, [transitions]),
              returnValue: Stream<
                  _i14.Transition<_i16.DirectoryEvent, _i7.DirectoryState>>.empty()) as _i5
              .Stream<_i14.Transition<_i16.DirectoryEvent, _i7.DirectoryState>>);
  @override
  _i5.Future<void> close() => (super.noSuchMethod(Invocation.method(#close, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future.value()) as _i5.Future<void>);
  @override
  _i5.StreamSubscription<_i7.DirectoryState> listen(
          void Function(_i7.DirectoryState)? onData,
          {Function? onError,
          void Function()? onDone,
          bool? cancelOnError}) =>
      (super.noSuchMethod(
              Invocation.method(#listen, [
                onData
              ], {
                #onError: onError,
                #onDone: onDone,
                #cancelOnError: cancelOnError
              }),
              returnValue: _FakeStreamSubscription<_i7.DirectoryState>())
          as _i5.StreamSubscription<_i7.DirectoryState>);
  @override
  void onChange(_i14.Change<_i7.DirectoryState>? change) =>
      super.noSuchMethod(Invocation.method(#onChange, [change]),
          returnValueForMissingStub: null);
  @override
  void addError(Object? error, [StackTrace? stackTrace]) =>
      super.noSuchMethod(Invocation.method(#addError, [error, stackTrace]),
          returnValueForMissingStub: null);
  @override
  void onError(Object? error, StackTrace? stackTrace) =>
      super.noSuchMethod(Invocation.method(#onError, [error, stackTrace]),
          returnValueForMissingStub: null);
}

/// A class which mocks [RouteBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockRouteBloc extends _i1.Mock implements _i9.RouteBloc {
  MockRouteBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.Bloc<dynamic, dynamic> get bloc =>
      (super.noSuchMethod(Invocation.getter(#bloc),
              returnValue: _FakeBloc<dynamic, dynamic>())
          as _i8.Bloc<dynamic, dynamic>);
  @override
  _i9.RouteState get state => (super.noSuchMethod(Invocation.getter(#state),
      returnValue: _FakeRouteState()) as _i9.RouteState);
  @override
  _i5.Stream<_i9.RouteState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<_i9.RouteState>.empty())
          as _i5.Stream<_i9.RouteState>);
  @override
  _i5.Stream<_i9.RouteState> mapEventToState(_i9.RouteEvent? event) =>
      (super.noSuchMethod(Invocation.method(#mapEventToState, [event]),
              returnValue: Stream<_i9.RouteState>.empty())
          as _i5.Stream<_i9.RouteState>);
  @override
  void add(_i9.RouteEvent? event) =>
      super.noSuchMethod(Invocation.method(#add, [event]),
          returnValueForMissingStub: null);
  @override
  void onEvent(_i9.RouteEvent? event) =>
      super.noSuchMethod(Invocation.method(#onEvent, [event]),
          returnValueForMissingStub: null);
  @override
  _i5.Stream<_i14.Transition<_i9.RouteEvent, _i9.RouteState>> transformEvents(
          _i5.Stream<_i9.RouteEvent>? events,
          _i8.TransitionFunction<_i9.RouteEvent, _i9.RouteState>?
              transitionFn) =>
      (super.noSuchMethod(
              Invocation.method(#transformEvents, [events, transitionFn]),
              returnValue: Stream<
                  _i14.Transition<_i9.RouteEvent, _i9.RouteState>>.empty())
          as _i5.Stream<_i14.Transition<_i9.RouteEvent, _i9.RouteState>>);
  @override
  void emit(_i9.RouteState? state) =>
      super.noSuchMethod(Invocation.method(#emit, [state]),
          returnValueForMissingStub: null);
  @override
  void onTransition(
          _i14.Transition<_i9.RouteEvent, _i9.RouteState>? transition) =>
      super.noSuchMethod(Invocation.method(#onTransition, [transition]),
          returnValueForMissingStub: null);
  @override
  _i5.Stream<_i14.Transition<_i9.RouteEvent, _i9.RouteState>>
      transformTransitions(
              _i5.Stream<_i14.Transition<_i9.RouteEvent, _i9.RouteState>>?
                  transitions) =>
          (super.noSuchMethod(
                  Invocation.method(#transformTransitions, [transitions]),
                  returnValue: Stream<
                      _i14.Transition<_i9.RouteEvent, _i9.RouteState>>.empty())
              as _i5.Stream<_i14.Transition<_i9.RouteEvent, _i9.RouteState>>);
  @override
  _i5.Future<void> close() => (super.noSuchMethod(Invocation.method(#close, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future.value()) as _i5.Future<void>);
  @override
  _i5.StreamSubscription<_i9.RouteState> listen(
          void Function(_i9.RouteState)? onData,
          {Function? onError,
          void Function()? onDone,
          bool? cancelOnError}) =>
      (super.noSuchMethod(
              Invocation.method(#listen, [
                onData
              ], {
                #onError: onError,
                #onDone: onDone,
                #cancelOnError: cancelOnError
              }),
              returnValue: _FakeStreamSubscription<_i9.RouteState>())
          as _i5.StreamSubscription<_i9.RouteState>);
  @override
  void onChange(_i14.Change<_i9.RouteState>? change) =>
      super.noSuchMethod(Invocation.method(#onChange, [change]),
          returnValueForMissingStub: null);
  @override
  void addError(Object? error, [StackTrace? stackTrace]) =>
      super.noSuchMethod(Invocation.method(#addError, [error, stackTrace]),
          returnValueForMissingStub: null);
  @override
  void onError(Object? error, StackTrace? stackTrace) =>
      super.noSuchMethod(Invocation.method(#onError, [error, stackTrace]),
          returnValueForMissingStub: null);
}

/// A class which mocks [BasicResult].
///
/// See the documentation for Mockito's code generation for more information.
class MockBasicResult<T> extends _i1.Mock implements _i3.BasicResult<T> {
  MockBasicResult() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get functionName =>
      (super.noSuchMethod(Invocation.getter(#functionName), returnValue: '')
          as String);
  @override
  String get errorMessage =>
      (super.noSuchMethod(Invocation.getter(#errorMessage), returnValue: '')
          as String);
  @override
  set errorMessage(String? _errorMessage) =>
      super.noSuchMethod(Invocation.setter(#errorMessage, _errorMessage),
          returnValueForMissingStub: null);
}

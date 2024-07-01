import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ouisync_app/app/cubits/entry_bottom_sheet.dart';
import 'package:ouisync_app/app/cubits/power_control.dart';
import 'package:ouisync_app/app/cubits/repo.dart';
import 'package:ouisync_app/app/cubits/repos.dart';
import 'package:ouisync_app/app/models/auth_mode.dart';
import 'package:ouisync_app/app/models/repo_location.dart';
import 'package:ouisync_app/app/pages/main_page.dart';
import 'package:ouisync_app/app/utils/cache_servers.dart';
import 'package:ouisync_app/app/utils/master_key.dart';
import 'package:ouisync_app/app/utils/settings/settings.dart';
import 'package:ouisync_app/app/widgets/buttons/dialog_negative_button.dart';
import 'package:ouisync_app/app/widgets/buttons/dialog_positive_button.dart';
import 'package:ouisync_plugin/native_channels.dart';
import 'package:ouisync_plugin/ouisync_plugin.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import '../utils.dart';

void main() {
  late Session session;
  late Settings settings;
  late NativeChannels nativeChannels;
  late PowerControl powerControl;
  late ReposCubit reposCubit;
  late StreamController<List<SharedMediaFile>> mediaReceiverController;

  setUp(() async {
    final configPath = join(
      (await getApplicationSupportDirectory()).path,
      'config',
    );

    session = Session.create(
      kind: SessionKind.unique,
      configPath: configPath,
    );

    settings = await Settings.init(MasterKey.random());
    nativeChannels = NativeChannels(session);
    powerControl = PowerControl(
      session,
      settings,
      connectivity: FakeConnectivity(),
    );
    reposCubit = ReposCubit(
      cacheServers: CacheServers.disabled,
      nativeChannels: nativeChannels,
      session: session,
      settings: settings,
    );

    mediaReceiverController = StreamController();
  });

  tearDown(() async {
    await mediaReceiverController.close();
    await reposCubit.close();
    await powerControl.close();
    await session.close();
  });

  MainPage makeMainPage() => MainPage(
        nativeChannels: nativeChannels,
        packageInfo: fakePackageInfo,
        powerControl: powerControl,
        receivedMedia: mediaReceiverController.stream,
        reposCubit: reposCubit,
        session: session,
        settings: settings,
        windowManager: FakeWindowManager(),
      );

  Future<io.File> createFile({
    required String name,
    String content = '',
  }) async {
    final file = io.File(join((await getTemporaryDirectory()).path, name));
    await file.create(recursive: true);
    await file.writeAsString(content);

    return file;
  }

  Future<String> readRepoFileAsString(
    RepoCubit repoCubit,
    String path,
  ) async {
    final file = await repoCubit.openFile(path);

    try {
      return utf8.decode(await file.read(0, await file.length));
    } finally {
      await file.close();
    }
  }

  testWidgets(
    'receive file from repo list with no repos',
    (tester) => tester.runAsync(
      () async {
        final file = await createFile(name: 'file.txt');

        await tester.pumpWidget(testApp(makeMainPage()));
        await tester.pumpAndSettle();

        mediaReceiverController.add([
          SharedMediaFile(
            path: file.path,
            type: SharedMediaType.file,
          ),
        ]);

        await tester.pumpAndSettle();

        expect(find.text('Add file to Ouisync'), findsOne);

        // Verify the save button is disabled
        final saveButton = find.widgetWithText(PositiveButton, 'SAVE');
        expect(saveButton, findsOne);
        expect(tester.widget<PositiveButton>(saveButton).onPressed, isNull);

        // Cancel adding the file
        final cancelButton = find.widgetWithText(NegativeButton, 'CANCEL');
        expect(cancelButton, findsOne);
        await tester.tap(cancelButton);
        await tester.pumpAndSettle();
        expect(find.text('Add file to Ouisync'), findsNothing);
      },
    ),
  );

  testWidgets(
    'receive file from repo list with some repos',
    (tester) => tester.runAsync(
      () async {
        final fileName = 'file.txt';
        final fileContent = 'Hello world';
        final file = await createFile(name: fileName, content: fileContent);

        final repoName = 'my repo';
        final repoEntry = await reposCubit.createRepository(
          location: RepoLocation.fromParts(
            dir: await reposCubit.settings.getDefaultRepositoriesDir(),
            name: repoName,
          ),
          setLocalSecret: LocalSecretKeyAndSalt.random(),
          localSecretMode: LocalSecretMode.randomStored,
        );
        final repoCubit = repoEntry.cubit!;

        await tester.pumpWidget(testApp(makeMainPage()));
        await tester.pumpAndSettle();

        mediaReceiverController.add([
          SharedMediaFile(
            path: file.path,
            type: SharedMediaType.file,
          ),
        ]);
        await tester.pumpAndSettle();

        await tester.tap(find.text(repoName));
        await reposCubit.waitUntil((_) =>
            !reposCubit.isLoading && reposCubit.currentRepo == repoEntry);
        await tester.pump();

        expect(find.widgetWithText(AppBar, repoName), findsOne);

        final saveButton = find.widgetWithText(PositiveButton, 'SAVE');
        expect(saveButton, findsOne);

        await tester.tap(saveButton);
        await repoCubit.waitUntil((state) => state.uploads.isNotEmpty);
        await repoCubit.waitUntil((state) => state.uploads.isEmpty);

        expect(find.text(fileName), findsOne);

        final actualFileContent =
            await readRepoFileAsString(repoCubit, fileName);
        expect(actualFileContent, equals(fileContent));
      },
    ),
  );

  testWidgets(
    'receive file from repo screen',
    (tester) => tester.runAsync(
      () async {
        final fileName = 'file.txt';
        final fileContent = 'Hello world';
        final file = await createFile(name: fileName, content: fileContent);

        final repoName = 'my repo';
        final repoEntry = await reposCubit.createRepository(
          location: RepoLocation.fromParts(
            dir: await reposCubit.settings.getDefaultRepositoriesDir(),
            name: repoName,
          ),
          setLocalSecret: LocalSecretKeyAndSalt.random(),
          localSecretMode: LocalSecretMode.randomStored,
          // Set the repo as current so we start on the single repo screen, not on the repo list.
          setCurrent: true,
        );
        final repoCubit = repoEntry.cubit!;

        await tester.pumpWidget(testApp(makeMainPage()));
        await reposCubit.waitUntil((_) =>
            !reposCubit.isLoading && reposCubit.currentRepo == repoEntry);
        await tester.pump();

        // Verify we are in the single repo screen
        expect(find.widgetWithText(AppBar, repoName), findsOne);

        mediaReceiverController.add([
          SharedMediaFile(
            path: file.path,
            type: SharedMediaType.file,
          ),
        ]);
        await reposCubit.bottomSheet
            .waitUntil((state) => state is SaveMediaSheetState);
        await tester.pump();

        final saveButton = find.widgetWithText(PositiveButton, 'SAVE');
        await tester.tap(saveButton);
        await repoCubit.waitUntil((state) => state.uploads.isNotEmpty);
        await repoCubit.waitUntil((state) => state.uploads.isEmpty);

        expect(find.text(fileName), findsOne);

        final actualFileContent =
            await readRepoFileAsString(repoCubit, fileName);
        expect(actualFileContent, equals(fileContent));
      },
    ),
  );

  testWidgets(
    'receive repo',
    (tester) => tester.runAsync(
      () async {
        final repoName = 'new repo';
        final repoPath =
            join((await getTemporaryDirectory()).path, '$repoName.ouisyncdb');
        final repo = await Repository.create(
          session,
          store: repoPath,
          readSecret: null,
          writeSecret: null,
        );
        await repo.close();

        await tester.pumpWidget(testApp(makeMainPage()));
        await tester.pumpAndSettle();

        expect(find.text(repoName), findsNothing);

        mediaReceiverController.add([
          SharedMediaFile(
            path: repoPath,
            type: SharedMediaType.file,
          ),
        ]);
        await reposCubit.waitUntil((_) => reposCubit.repos.isNotEmpty);
        await tester.pumpAndSettle();

        expect(find.text(repoName), findsOne);
      },
    ),
  );
}

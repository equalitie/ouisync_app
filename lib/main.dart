import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ouisync_app/lifecycle.dart';
import 'package:ouisync_plugin/ouisync_plugin.dart';
import 'package:path_provider/path_provider.dart';

import 'app/app.dart';
import 'app/bloc/blocs.dart';
import 'app/utils/utils.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = SimpleBlocObserver();

  final appDir = (await getApplicationSupportDirectory()).path;
  final repositoriesDir = '$appDir/${Strings.folderRepositoriesName}';
  final configDir = '$appDir/${Strings.configuratiosDirName}';

  await Settings.initSettings(
    appDir,
    repositoriesDir,
  );

  final localRepositoriesList = RepositoryHelper
  .localRepositoriesFiles(repositoriesDir) as List<String>;
  
  final latestRepositoryOrDefaultName = await RepositoryHelper
  .latestRepositoryOrDefault(localRepositoriesList);
  
  await Settings.saveSetting(Constants.currentRepositoryKey, latestRepositoryOrDefaultName);

  final session = await Session.open(configDir);
  
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LifeCycle(
      session:  session,
      child: OuiSyncApp(
        session: session,
        appStorageLocation: appDir,
        repositoriesLocation: repositoriesDir,
        defaultRepositoryName: latestRepositoryOrDefaultName,
      )
   )
  ));
}

import 'dart:async';
import 'dart:io';

import 'package:ouisync/ouisync.dart' show Session, initLog;
import 'package:ouisync_app/app/utils/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';

import 'utils/platform/platform_window_manager.dart';

const _defaultPeerPort = 20209;

final _sessionLoggy = appLogger('Session');
final _serviceLoggy = appLogger('');

Future<Session> createSession({
  required PackageInfo packageInfo,
  PlatformWindowManager? windowManager,
  void Function()? onConnectionReset,
}) async {
  final configPath = join(
    await Native.getBaseDir().then((dir) => dir.path),
    Constants.configDirName,
  );

  initLog(
    callback: (level, message) => _serviceLoggy.log(level.toLoggy(), message),
  );

  final session = await Session.create(
    configPath: configPath,
    // On darwin, the server is started by a background process
    startServer: !Platform.isMacOS && !Platform.isIOS,
  );

  try {
    windowManager?.onClose(session.close);

    if (await session.storeDir == null) {
      final dir = await defaultStoreDir;
      await session.setStoreDir(dir.path);
    }

    await session.initNetwork(
      defaultBindAddrs: ['quic/0.0.0.0:0', 'quic/[::]:0'],
      defaultPortForwardingEnabled: true,
      defaultLocalDiscoveryEnabled: true,
    );

    // Add cache servers as user defined peers so we immediately connect to them.
    for (final host in Constants.cacheServers) {
      unawaited(addCacheServerAsPeer(session, host));
    }
  } catch (e) {
    await session.close();
    rethrow;
  }

  return session;
}

Future<void> addCacheServerAsPeer(Session session, String host) async {
  try {
    for (final addr in await InternetAddress.lookup(_stripPort(host))) {
      await session.addUserProvidedPeers([
        'quic/${addr.address}:$_defaultPeerPort',
        'tcp/${addr.address}:$_defaultPeerPort',
      ]);
    }

    _sessionLoggy.debug('cache server $host added');
  } catch (e, st) {
    _sessionLoggy.error('failed to add cache server $host:', e, st);
  }
}

String _stripPort(String addr) {
  final index = addr.lastIndexOf(':');

  if (index >= 0) {
    return addr.substring(0, index);
  } else {
    return addr;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

import '../../generated/l10n.dart';

//------------------------------------------------------------------------------
// Keep track of what snackbar messages we're showing so as to not show them
// redundantly. The _SnackBarWrap class is used to remove the message from
// _snackbars.

List<String> _snackbars = [];

class _SnackBarWrap extends StatefulWidget {
  final String _message;
  const _SnackBarWrap(this._message);

  @override
  State<_SnackBarWrap> createState() => _SnackBarWrapState(_message);
}

class _SnackBarWrapState extends State<_SnackBarWrap> {
  final String _message;
  _SnackBarWrapState(this._message);

  @override
  Widget build(BuildContext context) {
    return Text(_message);
  }

  @override
  void dispose() {
    super.dispose();
    _snackbars.retainWhere((item) => item != _message);
  }
}

//------------------------------------------------------------------------------

showSnackBar(BuildContext context,
    {required String message, SnackBarAction? action}) {
  final messenger = ScaffoldMessenger.of(context);

  if (_snackbars.contains(message)) {
    return;
  }

  _snackbars.add(message);

  messenger.showSnackBar(
    SnackBar(
      content: _SnackBarWrap(message),
      action: action,
    ),
  );
}

hideSnackBar(context) => SnackBarAction(
    label: S.current.actionHideCapital,
    onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar());

String getBasename(String path) => p.basename(path);

String getBasenameWhithoutExtension(String path) =>
    p.basenameWithoutExtension(path);

String getDirname(String path) => p.dirname(path);

String getFileExtension(String fileName) => p.extension(fileName);

Future<void> copyStringToClipboard(String data) async {
  await Clipboard.setData(ClipboardData(text: data));
}

String? Function(String?) validateNoEmpty(String error) => (String? value) {
      if (value == null || value.isEmpty) {
        return error;
      }

      return null;
    };

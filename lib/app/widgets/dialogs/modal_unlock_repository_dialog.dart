import 'package:flutter/material.dart';
import 'package:ouisync/ouisync.dart';

import '../../../generated/l10n.dart';
import '../../pages/repo_reset_access.dart';
import '../../utils/utils.dart'
    show
        AccessModeLocalizedExtension,
        AppLogger,
        Constants,
        Dialogs,
        Dimensions,
        Fields,
        MasterKey,
        Settings,
        validateNoEmptyMaybeRegExpr;
import '../../models/models.dart'
    show AuthModeKeyStoredOnDevice, RepoLocation, SecretKeyOrigin;
import '../../cubits/cubits.dart' show RepoCubit;
import '../widgets.dart' show NegativeButton, PositiveButton;

class UnlockRepository extends StatefulWidget {
  UnlockRepository({
    required this.repoCubit,
    required this.settings,
  });

  final RepoCubit repoCubit;
  final Settings settings;

  @override
  State<UnlockRepository> createState() => _State();
}

class _State extends State<UnlockRepository> with AppLogger {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool secureWithBiometrics = false;
  bool passwordInvalid = false;

  @override
  Widget build(BuildContext context) => Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildPasswordField(context),
            _buildIDontHaveLocalPasswordButton(context),
            Fields.dialogActions(buttons: buildActions(context)),
          ],
        ),
      );

  Widget _buildIDontHaveLocalPasswordButton(BuildContext context) {
    return InkWell(
        child: RichText(
            text: TextSpan(
                // TODO(inetic): locales
                text: "\nI don't have a local password for this repository\n",
                style: TextStyle(color: Colors.blue))),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RepoResetAccessPage(
                      settings: widget.settings, repo: widget.repoCubit)));
        });
  }

  Widget buildPasswordField(BuildContext context) => Fields.formTextField(
        context: context,
        controller: passwordController,
        obscureText: obscurePassword,
        labelText: S.current.labelTypePassword,
        hintText: S.current.messageRepositoryPassword,
        errorText: passwordInvalid ? S.current.messageUnlockRepoFailed : null,
        suffixIcon: Fields.actionIcon(
          Icon(
            obscurePassword
                ? Constants.iconVisibilityOn
                : Constants.iconVisibilityOff,
            size: Dimensions.sizeIconSmall,
          ),
          color: Colors.black,
          onPressed: () => setState(() {
            obscurePassword = !obscurePassword;
          }),
        ),
        validator: validateNoEmptyMaybeRegExpr(
          emptyError: S.current.messageErrorRepositoryPasswordValidation,
        ),
        autofocus: true,
      );

  List<Widget> buildActions(context) => [
        NegativeButton(
          text: S.current.actionCancel,
          onPressed: () async => await Navigator.of(context).maybePop(null),
          buttonsAspectRatio: Dimensions.aspectRatioModalDialogButton,
        ),
        PositiveButton(
          text: S.current.actionUnlock,
          onPressed: () => onSubmit(context),
          buttonsAspectRatio: Dimensions.aspectRatioModalDialogButton,
        )
      ];

  Future<void> onSubmit(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (passwordController.text.isEmpty) {
      return;
    }

    final password = LocalPassword(passwordController.text);

    await Dialogs.executeFutureWithLoadingDialog(
      context,
      widget.repoCubit.unlock(password),
    );

    final accessMode = widget.repoCubit.accessMode;

    if (accessMode == AccessMode.blind) {
      setState(() {
        passwordInvalid = true;
      });
      return;
    } else {
      setState(() {
        passwordInvalid = false;
      });
    }

    //Navigator.of(context).pop(UnlockRepositoryResult(
    //  message: S.current.messageUnlockRepoOk(accessMode.localized),
    //));
    Navigator.of(context).pop(UnlockRepositoryResult(
      accessMode: accessMode,
      localSecret: password,
    ));
  }
}

class UnlockRepositoryResult {
  //UnlockRepositoryResult({required this.message});

  //final String message;
  UnlockRepositoryResult({required this.accessMode, required this.localSecret});
  final AccessMode accessMode;
  final LocalSecret localSecret;
}

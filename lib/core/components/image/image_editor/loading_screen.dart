import 'package:flutter/material.dart';

@protected

/// The loading screen.
class LoadingScreen {
  /// Creates a new loading screen.
  LoadingScreen(this.globalKey);

  /// The global key of the scaffold.
  final GlobalKey globalKey;

  /// Shows the loading screen.
  void show([String? text]) {
    if (globalKey.currentContext == null) return;

    showDialog<String>(
      context: globalKey.currentContext!,
      builder: (BuildContext context) => const Scaffold(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0),
        body: PopScope(
          canPop: false,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  semanticsLabel: 'Linear progress indicator',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Hides the loading screen.
  void hide() {
    if (globalKey.currentContext == null) return;

    Navigator.pop(globalKey.currentContext!);
  }
}

@protected

/// The global key of the scaffold.
final scaffoldGlobalKey = GlobalKey<ScaffoldState>();

@protected

/// The loading screen.
LoadingScreen loadingScreen = LoadingScreen(scaffoldGlobalKey);

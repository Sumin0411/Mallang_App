import 'package:flutter/material.dart';

final class MallangButtonStyle {
 static ButtonStyle noSplash = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(Colors.transparent),
  elevation: MaterialStateProperty.all(0.0),
  splashFactory: NoSplash.splashFactory,
  overlayColor: MaterialStateProperty.all(Colors.transparent),
  );
}

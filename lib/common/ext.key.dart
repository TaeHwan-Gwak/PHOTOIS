import 'package:flutter/widgets.dart';

extension GlobalKeyExtension on GlobalKey {
  RenderBox? get renderBox {
    try {
      return currentContext?.findRenderObject() as RenderBox;
    } catch (e) {}
    return null;
  }

  Rect? get localPaintBounds {
    try {
      final renderbox = currentContext?.findRenderObject() as RenderBox;
      return renderbox.paintBounds;
    } catch (e) {}
    return null;
  }

  Rect? get globalPaintBounds {
    try {
      final renderObject = currentContext?.findRenderObject();
      var translation = renderObject?.getTransformTo(null).getTranslation();
      if (translation != null) {
        return renderObject!.paintBounds
            .shift(Offset(translation.x, translation.y));
      } else {
        return null;
      }
    } catch (e) {}
    return null;
  }
}

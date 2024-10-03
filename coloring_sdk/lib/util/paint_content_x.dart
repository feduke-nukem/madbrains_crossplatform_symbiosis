import 'dart:convert';

import 'package:flutter_drawing_board/paint_contents.dart';

extension PaintContentX on PaintContent {
  static Iterable<PaintContent> fromJson(String json) sync* {
    final list = jsonDecode(json) as List;

    for (final json in list) {
      final map = json as Map<String, dynamic>;

      switch (map) {
        case {'type': 'SimpleLine'}:
          yield SimpleLine.fromJson(json);
        case {'type': 'SmoothLine'}:
          yield SmoothLine.fromJson(json);
        case {'type': 'StraightLine'}:
          yield StraightLine.fromJson(json);
        case {'type': 'Rectangle'}:
          yield Rectangle.fromJson(json);
        case {'type': 'Circle'}:
          yield Circle.fromJson(json);
        case {'type': 'EmptyContent'}:
          yield EmptyContent.fromJson(json);
        case {'type': 'Eraser'}:
          yield Eraser.fromJson(json);
      }
    }
  }
}

import 'dart:async';

import 'package:meta/meta.dart';

class Artwork {
  final String thumbnailUrl;
  final String fullUrl;
  final String name;

  void focus() => _onFocus.add(null);

  Stream<void> get onFocus => _onFocus.stream;
  final _onFocus = StreamController<void>.broadcast();

  Artwork(
      {@required this.name,
      @required this.thumbnailUrl,
      @required this.fullUrl});
}

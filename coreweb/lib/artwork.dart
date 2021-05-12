import 'package:meta/meta.dart';

abstract class Artwork {
  final String thumbnailUrl;
  final String fullUrl;
  final String name;

  void focus();

  Artwork get prev;
  Artwork get next;

  Artwork(
      {@required this.name,
      @required this.thumbnailUrl,
      @required this.fullUrl});
}

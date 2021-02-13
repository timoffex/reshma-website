import 'package:meta/meta.dart';

class Artwork {
  final String thumbnailUrl;
  final String fullUrl;
  final String name;

  Artwork(
      {@required this.name,
      @required this.thumbnailUrl,
      @required this.fullUrl});
}

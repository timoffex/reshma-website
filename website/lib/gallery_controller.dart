import 'dart:async';

import 'package:angular/angular.dart';

import 'artwork.dart';

const galleryControllerModule =
    Module(provide: [ClassProvider(GalleryController)]);

class GalleryController {
  // Implementation note: when accessing this from GalleryModel, pretend its
  // interface only includes the command methods; when accessing from
  // components, imagine that the interface is just the streams.

  /// Stream that fires whenever the overlay should be hidden.
  Stream get overlayDismissed => _overlayDismissed.stream;
  final _overlayDismissed = StreamController.broadcast();

  /// Stream that fires whenever the overlay should show a new artwork.
  Stream<Artwork> get overlayOpened => _overlayOpened.stream;
  final _overlayOpened = StreamController<Artwork>.broadcast();

  /// Commands the overlay to show a new artwork.
  void showOverlay(Artwork artwork) {
    _overlayOpened.add(artwork);
  }

  /// Commands the overlay to be hidden.
  void dismissOverlay() {
    _overlayDismissed.add(null);
  }
}

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

  /// Stream that fires whenever browser focus should switch to the given
  /// artwork.
  Stream<Artwork> get galleryFocusChange => _galleryFocusChange.stream;
  final _galleryFocusChange = StreamController<Artwork>.broadcast();

  /// Commands the overlay to show a new artwork.
  ///
  /// If the overlay was not opened before, this will open it. This will then
  /// show the new artwork in the overlay.
  void showOverlay(Artwork artwork) {
    _overlayOpened.add(artwork);
  }

  /// Commands the overlay to close.
  void dismissOverlay() {
    _overlayDismissed.add(null);
  }

  /// Commands the browser to set focus to the specified artwork.
  void focusArtwork(Artwork artwork) {
    _galleryFocusChange.add(artwork);
  }
}

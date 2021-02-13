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

  /// Stream that fires whenever browser focus should switch to the given index
  /// in the gallery.
  Stream<int> get galleryFocusIndexChange => _galleryFocusIndexChange.stream;
  final _galleryFocusIndexChange = StreamController<int>.broadcast();

  /// Stream that fires when components should ensure browser focus is in the
  /// gallery.
  Stream get galleryFocused => _galleryFocused.stream;
  final _galleryFocused = StreamController.broadcast();

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

  /// Ensures browser focus is in the gallery.
  void focusGallery() {
    _galleryFocused.add(null);
  }

  /// Commands the browser to set focus to the artwork at the given index in the
  /// gallery.
  void focusIndexInGallery(int index) {
    _galleryFocusIndexChange.add(index);
  }
}

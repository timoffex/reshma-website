import 'package:angular/angular.dart';
import 'package:built_collection/built_collection.dart';

import 'artwork.dart';
import 'gallery_controller.dart';

const galleryModule = Module(provide: [ClassProvider(GalleryModelFactory)]);

class GalleryModelFactory {
  GalleryModelFactory(this._gallery);

  GalleryModel create(BuiltList<Artwork> artworks) =>
      GalleryModel._(artworks, _gallery);

  final GalleryController _gallery;
}

/// Model for the "gallery page" of Reshma's website.
class GalleryModel {
  final BuiltList<Artwork> artworks;

  final GalleryController _gallery;

  /// The currently focused artwork if the overlay is opened, or null otherwise.
  Artwork get focusedArtwork =>
      _shownIndex != null ? artworks[_shownIndex] : null;

  /// Whether there is another artwork to the left of the currently focused one,
  /// assuming that [focusedArtwork] is non-null.
  bool get hasPrevArtwork => _shownIndex > 0;

  /// Whether there is another artwork to the right of the currently focused
  /// one, assuming that [focusedArtwork] is non-null.
  bool get hasNextArtwork => _shownIndex < artworks.length - 1;

  bool _overlayOpen = false;
  int _shownIndex;

  GalleryModel._(this.artworks, this._gallery);

  void focusArtworkAtIndex(int index) {
    if (index < 0 || index >= artworks.length) {
      _shownIndex = null;
      return;
    }

    _shownIndex = index;
    _overlayOpen = true;
    _gallery.showOverlay(artworks[_shownIndex]);
  }

  void dismissOverlay() {
    final lastShownIndex = _shownIndex;
    _shownIndex = null;
    _overlayOpen = false;
    _gallery.dismissOverlay();
    _gallery.focusIndexInGallery(lastShownIndex);
  }

  void focusGallery() {
    _gallery.focusGallery();
  }

  void focusNextArtwork() {
    if (!_overlayOpen) return;
    if (_shownIndex < artworks.length - 1) {
      _shownIndex++;
      _gallery.showOverlay(artworks[_shownIndex]);
    }
  }

  void focusPrevArtwork() {
    if (!_overlayOpen) return;
    if (_shownIndex > 0) {
      _shownIndex--;
      _gallery.showOverlay(artworks[_shownIndex]);
    }
  }
}

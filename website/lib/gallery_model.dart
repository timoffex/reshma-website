import 'dart:async';

import 'package:angular/angular.dart';
import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';

import 'artwork.dart';
import 'gallery_controller.dart';

const galleryModule = Module(provide: [ClassProvider(GalleryModelFactory)]);

class GalleryModelFactory {
  GalleryModelFactory(this._gallery);

  GalleryModel create(BuiltList<GalleryArtwork> artworks,
          BuiltList<GalleryArtwork> merch) =>
      GalleryModel._(artworks, merch, _gallery);

  final GalleryController _gallery;
}

/// Model for the "gallery page" of Reshma's website.
class GalleryModel {
  final BuiltList<Artwork> artworks;
  final BuiltList<Artwork> merch;

  final GalleryController _gallery;

  /// The currently focused artwork if the overlay is opened, or null otherwise.
  Artwork get focusedArtwork {
    if (_shown == null) return null;

    return focusedSection[_shown.index];
  }

  BuiltList<Artwork> get focusedSection {
    if (_shown == null) return null;

    return _artworksIn(_shown.section);
  }

  BuiltList<Artwork> _artworksIn(_GallerySection section) {
    switch (section) {
      case _GallerySection.artworks:
        return artworks;
      case _GallerySection.merch:
        return merch;
      default:
        return null;
    }
  }

  /// Whether there is another artwork to the left of the currently focused one,
  /// assuming that [focusedArtwork] is non-null.
  bool get hasPrevArtwork => _shown.index > 0;

  /// Whether there is another artwork to the right of the currently focused
  /// one, assuming that [focusedArtwork] is non-null.
  bool get hasNextArtwork => _shown.index < focusedSection.length - 1;

  bool _overlayOpen = false;

  _GallerySelection _shown;

  GalleryModel._(BuiltList<GalleryArtwork> artworks,
      BuiltList<GalleryArtwork> merch, this._gallery)
      : artworks = artworks,
        merch = merch {
    for (var i = 0; i < artworks.length; ++i) {
      artworks[i]
          ._onFocus
          .stream
          .listen((_) => _focusSectionAtIndex(_GallerySection.artworks, i));
    }

    for (var i = 0; i < merch.length; ++i) {
      merch[i]
          ._onFocus
          .stream
          .listen((_) => _focusSectionAtIndex(_GallerySection.merch, i));
    }
  }

  void _focusSectionAtIndex(_GallerySection section, int index) {
    if (index < 0 || index >= _artworksIn(section).length) {
      _shown = null;
      return;
    }

    _shown = _GallerySelection(section, index);
    _overlayOpen = true;
    _gallery.showOverlay(focusedArtwork);
  }

  void dismissOverlay() {
    final lastShown = focusedArtwork;
    _shown = null;
    _overlayOpen = false;
    _gallery.dismissOverlay();
    _gallery.focusArtwork(lastShown);
  }

  void focusArtworks() {
    _gallery.focusArtworks();
  }

  void focusNextArtwork() {
    if (!_overlayOpen) return;
    if (_shown.index < focusedSection.length - 1) {
      _shown = _shown.next;
      _gallery.showOverlay(focusedArtwork);
    }
  }

  void focusPrevArtwork() {
    if (!_overlayOpen) return;
    if (_shown.index > 0) {
      _shown = _shown.prev;
      _gallery.showOverlay(focusedArtwork);
    }
  }
}

class _GallerySelection {
  final _GallerySection section;
  final int index;

  _GallerySelection get next => _GallerySelection(section, index + 1);
  _GallerySelection get prev => _GallerySelection(section, index - 1);

  _GallerySelection(this.section, this.index);
}

enum _GallerySection {
  artworks,
  merch,
}

class GalleryArtwork extends Artwork {
  @override
  void focus() => _onFocus.add(null);

  final _onFocus = StreamController<void>.broadcast(sync: true);

  GalleryArtwork(
      {@required String name,
      @required String thumbnailUrl,
      @required String fullUrl})
      : super(name: name, thumbnailUrl: thumbnailUrl, fullUrl: fullUrl);
}

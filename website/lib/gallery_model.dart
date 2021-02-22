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

  Artwork _artworkAt(_GalleryPosition position) {
    final section = _artworksIn(position.section);
    if (section == null) return null;

    if (position.index < 0) return null;
    if (position.index > section.length - 1) return null;
    return section[position.index];
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

  _GalleryPosition _shown;

  GalleryModel._(BuiltList<GalleryArtwork> artworks,
      BuiltList<GalleryArtwork> merch, this._gallery)
      : artworks = artworks,
        merch = merch {
    for (var i = 0; i < artworks.length; ++i) {
      artworks[i]._model = this;
      artworks[i]._position = _GalleryPosition(_GallerySection.artworks, i);
    }

    for (var i = 0; i < merch.length; ++i) {
      merch[i]._model = this;
      merch[i]._position = _GalleryPosition(_GallerySection.merch, i);
    }
  }

  void _focus(_GalleryPosition position) {
    if (position.index < 0 ||
        position.index >= _artworksIn(position.section).length) {
      _shown = null;
      return;
    }

    _shown = position;
    _gallery.showOverlay(_artworkAt(_shown));
  }

  void dismissOverlay() {
    final lastShown = _artworkAt(_shown);
    _shown = null;
    _gallery.dismissOverlay();
    _gallery.focusArtwork(lastShown);
  }

  void focusArtworks() {
    _gallery.focusArtworks();
  }
}

class _GalleryPosition {
  final _GallerySection section;
  final int index;

  _GalleryPosition get next => _GalleryPosition(section, index + 1);
  _GalleryPosition get prev => _GalleryPosition(section, index - 1);

  _GalleryPosition(this.section, this.index);
}

enum _GallerySection {
  artworks,
  merch,
}

class GalleryArtwork extends Artwork {
  @override
  void focus() => _model._focus(_position);

  @override
  Artwork get prev => _model._artworkAt(_position.prev);

  @override
  Artwork get next => _model._artworkAt(_position.next);

  GalleryModel _model; // late-bound
  _GalleryPosition _position; // late-bound

  GalleryArtwork(
      {@required String name,
      @required String thumbnailUrl,
      @required String fullUrl})
      : super(name: name, thumbnailUrl: thumbnailUrl, fullUrl: fullUrl);
}

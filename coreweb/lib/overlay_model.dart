import 'dart:async';

import 'package:angular/core.dart';
import 'package:built_collection/built_collection.dart';
import 'package:observable/observable.dart';
import 'package:rz.coreweb/artwork.dart';

const overlayModule = Module(provide: [ClassProvider(OverlayModel)]);

class OverlayModel extends ChangeNotifier {
  bool get overlayShown => _overlayShown;
  bool _overlayShown = false;
  set overlayShown(bool overlayShown) {
    if (overlayShown == _overlayShown) return;

    if (overlayShown == false) {
      overlayArtworks?._notifyClosed();
    }

    _overlayShown = overlayShown;
    notifyChange();
  }

  OverlayArtworkList get overlayArtworks => _overlayArtworks;
  OverlayArtworkList _overlayArtworks;

  OverlayArtworkList showArtworkList(BuiltList<Artwork> artworks, int index) {
    if (artworks.isEmpty) {
      _overlayArtworks = null;
      overlayShown = false;
    } else {
      _overlayArtworks = OverlayArtworkList._(this, artworks, index);
      overlayShown = true;
    }

    return _overlayArtworks;
  }
}

class OverlayArtworkList {
  Artwork get currentArtwork => _artworks[_index];

  bool get hasNext => _index < _artworks.length - 1;
  bool get hasPrev => _index > 0;

  void showNext() {
    if (hasNext) {
      _index += 1;
      _model.notifyChange();
    }
  }

  void showPrev() {
    if (hasPrev) {
      _index -= 1;
      _model.notifyChange();
    }
  }

  int _index;
  final BuiltList<Artwork> _artworks;

  /// Stream that fires when the overlay is closed while displaying an
  /// artwork in this list.
  ///
  /// The stream outputs the index of the artwork at which the overlay was
  /// closed.
  Stream<int> get onClose => _onClose.stream;
  final _onClose = StreamController<int>.broadcast();

  void _notifyClosed() {
    _onClose.add(_index);
  }

  final OverlayModel _model;

  OverlayArtworkList._(this._model, this._artworks, this._index);
}

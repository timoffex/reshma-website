import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/focus/focus_item.dart';
import 'package:angular_components/focus/focus_list.dart';
import 'package:built_collection/built_collection.dart';

import 'package:rz.coreweb/artwork.dart';
import 'package:rz.coreweb/overlay_model.dart';

@Component(
    selector: 'rz-gallery',
    templateUrl: 'rz_gallery.html',
    styleUrls: ['rz_gallery.css'],
    directives: [NgFor, FocusItemDirective, FocusListDirective],
    changeDetection: ChangeDetectionStrategy.OnPush)
class RzGalleryComponent {
  @Input()
  BuiltList<Artwork> artworks;

  void focus(int index) {
    container.focus(index);
  }

  @visibleForTemplate
  void handleClickArtwork(int index) {
    final artworkList = _overlay.showArtworkList(artworks, index);

    _overlayCloseSubscription?.cancel();
    _overlayCloseSubscription = artworkList.onClose.listen(focus);
  }

  @ViewChild('container', read: FocusListDirective)
  FocusListDirective container;

  RzGalleryComponent(this._overlay);

  StreamSubscription _overlayCloseSubscription;
  final OverlayModel _overlay;
}

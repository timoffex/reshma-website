import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/focus/focus_item.dart';
import 'package:angular_components/focus/focus_list.dart';
import 'package:built_collection/built_collection.dart';

import 'package:rz.coreweb/artwork.dart';
import 'package:rz.coreweb/gallery_controller.dart';

@Component(
    selector: 'rz-gallery',
    templateUrl: 'rz_gallery.html',
    styleUrls: ['rz_gallery.css'],
    directives: [NgFor, FocusItemDirective, FocusListDirective],
    changeDetection: ChangeDetectionStrategy.OnPush)
class RzGalleryComponent implements OnInit, OnDestroy {
  @Input()
  BuiltList<Artwork> artworks;

  @visibleForTemplate
  void handleClickArtwork(Artwork artwork) {
    artwork.focus();
  }

  @ViewChild('container', read: FocusListDirective)
  FocusListDirective container;

  @override
  void ngOnInit() {
    _subscriptions = [
      _controller.galleryFocusChange.listen(_setFocus),
    ];
  }

  @override
  void ngOnDestroy() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
  }

  void _setFocus(Artwork artwork) {
    final index = artworks.indexOf(artwork);

    if (index >= 0) {
      container.focus(index);
    }
  }

  RzGalleryComponent(this._controller);

  List<StreamSubscription> _subscriptions;
  final GalleryController _controller;
}

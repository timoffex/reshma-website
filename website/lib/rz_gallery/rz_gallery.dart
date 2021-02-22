import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/focus/focus_item.dart';
import 'package:angular_components/focus/focus_list.dart';
import 'package:built_collection/built_collection.dart';

import 'package:reshmawebsite/artwork.dart';
import 'package:reshmawebsite/gallery_controller.dart';

@Component(
    selector: 'rz-gallery',
    templateUrl: 'rz_gallery.html',
    styleUrls: ['rz_gallery.css'],
    directives: [NgFor, FocusItemDirective, FocusListDirective],
    changeDetection: ChangeDetectionStrategy.OnPush)
class RzGalleryComponent implements OnInit, OnDestroy {
  @Input()
  BuiltList<Artwork> artworks;

  @Input()
  bool isArtworkSection = false;

  @visibleForTemplate
  void handleClickArtwork(Artwork artwork) {
    artwork.focus();
  }

  @HostListener('focusin')
  void onFocusIn() {
    _hasFocus = true;
  }

  @HostListener('focusout')
  void onFocusOut() {
    _hasFocus = false;
  }

  @ViewChild('container', read: FocusListDirective)
  FocusListDirective container;

  @override
  void ngOnInit() {
    _subscriptions = [
      _controller.galleryFocusChange.listen(_setFocus),
      if (isArtworkSection)
        _controller.artworksFocused.listen((_) => _ensureFocus())
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

  void _ensureFocus() {
    if (!_hasFocus) {
      container.focus(0);
    }
  }

  RzGalleryComponent(this._controller);

  bool _hasFocus = false;

  List<StreamSubscription> _subscriptions;
  final GalleryController _controller;
}

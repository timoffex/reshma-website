import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/material_button/material_fab.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:reshmawebsite/artwork.dart';
import 'package:reshmawebsite/gallery_controller.dart';
import 'package:reshmawebsite/gallery_model.dart';

@Component(
  selector: 'rz-overlay',
  templateUrl: 'rz_overlay.html',
  styleUrls: ['rz_overlay.css'],
  directives: [
    AutoDismissDirective,
    AutoFocusDirective,
    MaterialFabComponent,
    MaterialIconComponent,
    NgIf,
  ],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class RzOverlayComponent implements OnInit, OnDestroy {
  @Input()
  GalleryModel galleryModel;

  @visibleForTemplate
  Artwork artwork;

  @visibleForTemplate
  bool get hasLeft => galleryModel.hasPrevArtwork;

  @visibleForTemplate
  bool get hasRight => galleryModel.hasNextArtwork;

  @visibleForTemplate
  void handleDismiss() => galleryModel.dismissOverlay();

  @visibleForTemplate
  void handleGoLeft() => galleryModel.focusPrevArtwork();

  @visibleForTemplate
  void handleGoRight() => galleryModel.focusNextArtwork();

  @override
  void ngOnInit() {
    artwork = galleryModel.focusedArtwork;
    _subscriptions = [
      _controller.overlayOpened.listen((art) {
        artwork = art;
        _changeDetector.markForCheck();
      }),
    ];
  }

  @override
  void ngOnDestroy() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
  }

  RzOverlayComponent(this._controller, this._changeDetector);

  List<StreamSubscription> _subscriptions;
  final GalleryController _controller;
  final ChangeDetectorRef _changeDetector;
}

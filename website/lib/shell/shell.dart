import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular/core.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/angular_components.dart';
import 'package:reshmawebsite/artwork.dart';
import 'package:reshmawebsite/gallery_controller.dart';
import 'package:reshmawebsite/gallery_model.dart';
import 'package:reshmawebsite/rz_gallery/rz_gallery.dart';
import 'package:reshmawebsite/rz_overlay/rz_overlay.dart';
import 'package:reshmawebsite/rz_resume/rz_resume.dart';
import 'package:reshmawebsite/rz_video/rz_video.dart';

/// The root component for the website.
///
/// This has two ng-content slots: artwork and merch. The main website and the
/// editor application can use different components in these places.
@Component(
    selector: 'rz-shell',
    templateUrl: 'shell.html',
    styleUrls: ['shell.css'],
    directives: [
      FocusTrapComponent,
      MaterialButtonComponent,
      NgFor,
      NgIf,
      RzGalleryComponent,
      RzOverlayComponent,
      RzResumeComponent,
      RzVideoComponent,
    ],
    changeDetection: ChangeDetectionStrategy.OnPush)
class ShellComponent implements OnInit, OnDestroy {
  @Input()
  GalleryModel galleryModel;

  @visibleForTemplate
  bool get overlayVisible => overlayArtwork != null;

  @visibleForTemplate
  Artwork overlayArtwork;

  @visibleForTemplate
  void handleDismissOverlay() {
    galleryModel.dismissOverlay();
  }

  @override
  void ngOnInit() {
    _subscriptions = [
      _controller.overlayDismissed.listen((_) => _dismissOverlay()),
      _controller.overlayOpened.listen(_showOverlay),
    ];
  }

  @override
  void ngOnDestroy() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
  }

  void _dismissOverlay() {
    overlayArtwork = null;
  }

  void _showOverlay(Artwork artwork) {
    overlayArtwork = artwork;
  }

  ShellComponent(this._controller);

  List<StreamSubscription> _subscriptions;

  final GalleryController _controller;
}

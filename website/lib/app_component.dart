import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/angular_components.dart';
import 'package:built_collection/built_collection.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rz.proto/rz_schema.pb.dart' as pb;

import 'artwork.dart';
import 'gallery_controller.dart';
import 'gallery_model.dart';
import 'rz_gallery/rz_gallery.dart';
import 'rz_overlay/rz_overlay.dart';
import 'rz_resume/rz_resume.dart';
import 'rz_video/rz_video.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    styleUrls: ['app_component.css'],
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
    providers: [
      materialProviders,
      galleryModule,
      galleryControllerModule,
    ],
    changeDetection: ChangeDetectionStrategy.OnPush)
class AppComponent implements OnInit, OnDestroy {
  @visibleForTemplate
  bool get overlayVisible => overlayArtwork != null;

  @visibleForTemplate
  Artwork overlayArtwork;

  @visibleForTemplate
  GalleryModel galleryModel;

  @visibleForTemplate
  BuiltList<GalleryArtwork> artworks;

  @visibleForTemplate
  BuiltList<GalleryArtwork> merch;

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

    unawaited(_fetchSchema());
  }

  @override
  void ngOnDestroy() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
  }

  Future<void> _fetchSchema() async {
    final schema =
        pb.RzWebsiteSchema.fromJson(await HttpRequest.getString('/schema'));

    artworks = schema.galleryArtworks
        .map((artwork) => GalleryArtwork(
            name: artwork.name,
            thumbnailUrl: artwork.thumbnailUri,
            fullUrl: artwork.previewUri))
        .toBuiltList();

    merch = schema.merch
        .map((artwork) => GalleryArtwork(
            name: artwork.name,
            thumbnailUrl: artwork.thumbnailUri,
            fullUrl: artwork.previewUri))
        .toBuiltList();

    galleryModel = _galleryModelFactory.create(artworks, merch);
    _changeDetector.markForCheck();
  }

  void _dismissOverlay() {
    overlayArtwork = null;
  }

  void _showOverlay(Artwork artwork) {
    overlayArtwork = artwork;
  }

  AppComponent(
      this._controller, this._galleryModelFactory, this._changeDetector);

  List<StreamSubscription> _subscriptions;

  final GalleryController _controller;
  final GalleryModelFactory _galleryModelFactory;
  final ChangeDetectorRef _changeDetector;
}

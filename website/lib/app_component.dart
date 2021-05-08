import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/angular_components.dart';
import 'package:built_collection/built_collection.dart';
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
  final GalleryModel galleryModel;

  @visibleForTemplate
  final artworks = _artworks;

  @visibleForTemplate
  final merch = _merch;

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

  AppComponent(this._controller, GalleryModelFactory galleryModelFactory)
      : galleryModel = galleryModelFactory.create(_artworks, _merch);

  List<StreamSubscription> _subscriptions;

  final GalleryController _controller;
}

final _schema = pb.RzWebsiteSchema()
  ..galleryArtworks.addAll([
    pb.GalleryArtwork()
      ..name = 'Potions'
      ..thumbnailUri = 'assets/potion_gallery.jpg'
      ..previewUri = 'assets/potion.jpg',
    pb.GalleryArtwork()
      ..name = 'Mushroom'
      ..thumbnailUri = 'assets/mushroom_gallery.jpg'
      ..previewUri = 'assets/mushroom.jpg',
    pb.GalleryArtwork()
      ..name = 'Stump'
      ..thumbnailUri = 'assets/stump_gallery.jpg'
      ..previewUri = 'assets/stump.jpg',
    pb.GalleryArtwork()
      ..name = 'Kirby Pancakes'
      ..thumbnailUri = 'assets/kirby_pancakes_gallery.jpg'
      ..previewUri = 'assets/kirby_pancakes.jpg',
    pb.GalleryArtwork()
      ..name = 'Pika Fruit'
      ..thumbnailUri = 'assets/pika_fruit_gallery.jpg'
      ..previewUri = 'assets/pika_fruit.jpg',
    pb.GalleryArtwork()
      ..name = 'Girl'
      ..thumbnailUri = 'assets/tennis_player_gallery.jpg'
      ..previewUri = 'assets/tennis_player.jpg',
    pb.GalleryArtwork()
      ..name = 'Chuck'
      ..thumbnailUri = 'assets/chuck_gallery.jpg'
      ..previewUri = 'assets/chuck.jpg',
  ])
  ..merch.addAll([
    pb.Merch()
      ..name = 'Link Charm'
      ..thumbnailUri = 'assets/link_charm_gallery.jpg'
      ..previewUri = 'assets/link_charm.jpg',
    pb.Merch()
      ..name = 'Wooden Charm'
      ..thumbnailUri = 'assets/milk_coffee_charm_gallery.jpg'
      ..previewUri = 'assets/milk_coffee_charm.jpg',
    pb.Merch()
      ..name = 'Froggy Shirt'
      ..thumbnailUri = 'assets/froggy_shirt_gallery.jpg'
      ..previewUri = 'assets/froggy_shirt.jpg',
    pb.Merch()
      ..name = 'Froggy Sweater'
      ..thumbnailUri = 'assets/froggy_sweater_gallery.jpg'
      ..previewUri = 'assets/froggy_sweater.jpg',
  ])
  ..freeze();

final _artworks = _schema.galleryArtworks
    .map((artwork) => GalleryArtwork(
        name: artwork.name,
        thumbnailUrl: artwork.thumbnailUri,
        fullUrl: artwork.previewUri))
    .toBuiltList();

final _merch = _schema.merch
    .map((artwork) => GalleryArtwork(
        name: artwork.name,
        thumbnailUrl: artwork.thumbnailUri,
        fullUrl: artwork.previewUri))
    .toBuiltList();

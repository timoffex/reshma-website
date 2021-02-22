import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/angular_components.dart';
import 'package:built_collection/built_collection.dart';

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
  BuiltList<Artwork> get artworks => _artworks;

  @visibleForTemplate
  BuiltList<Artwork> get merch => _merch;

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

final _artworks = [
  GalleryArtwork(
      name: 'Potions',
      thumbnailUrl: 'assets/potion_gallery.jpg',
      fullUrl: 'assets/potion.jpg'),
  GalleryArtwork(
      name: 'Mushroom',
      thumbnailUrl: 'assets/mushroom_gallery.jpg',
      fullUrl: 'assets/mushroom.jpg'),
  GalleryArtwork(
      name: 'Stump',
      thumbnailUrl: 'assets/stump_gallery.jpg',
      fullUrl: 'assets/stump.jpg'),
  GalleryArtwork(
      name: 'Kirby Pancakes',
      thumbnailUrl: 'assets/kirby_pancakes_gallery.jpg',
      fullUrl: 'assets/kirby_pancakes.jpg'),
  GalleryArtwork(
      name: 'Pika Fruit',
      thumbnailUrl: 'assets/pika_fruit_gallery.jpg',
      fullUrl: 'assets/pika_fruit.jpg'),
  GalleryArtwork(
      name: 'Girl',
      thumbnailUrl: 'assets/tennis_player_gallery.jpg',
      fullUrl: 'assets/tennis_player.jpg'),
  GalleryArtwork(
      name: 'Chuck',
      thumbnailUrl: 'assets/chuck_gallery.jpg',
      fullUrl: 'assets/chuck.jpg'),
].build();

final _merch = [
  GalleryArtwork(
      name: 'Link Charm',
      thumbnailUrl: 'assets/link_charm_gallery.jpg',
      fullUrl: 'assets/link_charm.jpg'),
  GalleryArtwork(
      name: 'Wooden Charm',
      thumbnailUrl: 'assets/milk_coffee_charm_gallery.jpg',
      fullUrl: 'assets/milk_coffee_charm.jpg'),
  GalleryArtwork(
      name: 'Froggy Shirt',
      thumbnailUrl: 'assets/froggy_shirt_gallery.jpg',
      fullUrl: 'assets/froggy_shirt.jpg'),
  GalleryArtwork(
      name: 'Froggy Sweater',
      thumbnailUrl: 'assets/froggy_sweater_gallery.jpg',
      fullUrl: 'assets/froggy_sweater.jpg'),
].build();

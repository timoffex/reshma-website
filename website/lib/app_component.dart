import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/angular_components.dart';
import 'package:built_collection/built_collection.dart';

import 'artwork.dart';
import 'gallery_controller.dart';
import 'gallery_model.dart';
import 'rz_gallery/rz_gallery.dart';
import 'rz_initials/rz_initials.dart';
import 'rz_logo_animation.dart';
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
      RzInitialsComponent,
      RzLogoAnimationDirective,
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
  bool hasTopBar = false;

  @visibleForTemplate
  bool hasLandingSpace = false;

  @visibleForTemplate
  bool topBarVisible;

  @visibleForTemplate
  bool scrollButtonVisible;

  @visibleForTemplate
  bool shouldLogoBeVisible = true;

  @visibleForTemplate
  bool overlayVisible = false;

  @visibleForTemplate
  final GalleryModel galleryModel;

  @visibleForTemplate
  void doScroll() {
    _updateLogo();
  }

  @visibleForTemplate
  void scrollPastLandingArea() {
    galleryModel.focusGallery();
    if (content.scrollTop < _galleryScrollPosition) {
      content.scrollTo(0, _galleryScrollPosition);
    }
  }

  @visibleForTemplate
  void scrollToTop() {
    content.scrollTo(0, 0);
  }

  @visibleForTemplate
  void handleLogoBeginAnimation(bool appearing) {
    if (appearing) {
      // If appearing, remove the top bar but don't make scroll button
      // immediately visible.
      topBarVisible = false;
    } else {
      // If disappearing, remove the scorll button but don't immediately show
      // the top bar.
      scrollButtonVisible = false;
    }
  }

  @visibleForTemplate
  void handleLogoFinishAnimation(bool appeared) {
    topBarVisible = !appeared;
    scrollButtonVisible = appeared;
  }

  @override
  void ngOnInit() {
    if (hasLandingSpace) {
      topBarVisible = false;
      scrollButtonVisible = true;
    } else {
      topBarVisible = true;
      scrollButtonVisible = false;
    }

    _subscriptions = [
      _controller.overlayDismissed.listen((_) => _dismissOverlay()),
      _controller.overlayOpened.listen((_) => _showOverlay()),
    ];
  }

  @override
  void ngOnDestroy() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
  }

  void _dismissOverlay() {
    overlayVisible = false;
  }

  void _showOverlay() {
    overlayVisible = true;
  }

  void _updateLogo() {
    if (!hasLandingSpace) return;

    shouldLogoBeVisible = content.scrollTop < 100;
    _changeDetector.markForCheck();
  }

  AppComponent(this._changeDetector, this._controller,
      GalleryModelFactory galleryModelFactory)
      : galleryModel = galleryModelFactory.create(_artworks);

  int get _galleryScrollPosition =>
      reshmaName.offsetTop - (topBar?.scrollHeight ?? 0) - 16;

  List<StreamSubscription> _subscriptions;

  @ViewChild('topBar')
  Element topBar;

  @ViewChild('content')
  Element content;

  @ViewChild('reshmaName', read: Element)
  Element reshmaName;

  final GalleryController _controller;
  final ChangeDetectorRef _changeDetector;
}

final _artworks = [
  Artwork(
      name: 'Potions',
      thumbnailUrl: 'assets/potion_gallery.jpg',
      fullUrl: 'assets/potion.jpg'),
  Artwork(
      name: 'Mushroom',
      thumbnailUrl: 'assets/mushroom_gallery.jpg',
      fullUrl: 'assets/mushroom.jpg'),
  Artwork(
      name: 'Stump',
      thumbnailUrl: 'assets/stump_gallery.jpg',
      fullUrl: 'assets/stump.jpg'),
  Artwork(
      name: 'Link Charm',
      thumbnailUrl: 'assets/link_charm_gallery.jpg',
      fullUrl: 'assets/link_charm.jpg'),
  Artwork(
      name: 'Kirby Pancakes',
      thumbnailUrl: 'assets/kirby_pancakes_gallery.jpg',
      fullUrl: 'assets/kirby_pancakes.jpg'),
  Artwork(
      name: 'Pika Fruit',
      thumbnailUrl: 'assets/pika_fruit_gallery.jpg',
      fullUrl: 'assets/pika_fruit.jpg'),
  Artwork(
      name: 'Girl',
      thumbnailUrl: 'assets/tennis_player_gallery.jpg',
      fullUrl: 'assets/tennis_player.jpg'),
  Artwork(
      name: 'Chuck',
      thumbnailUrl: 'assets/chuck_gallery.jpg',
      fullUrl: 'assets/chuck.jpg'),
  Artwork(
      name: 'Wooden Charm',
      thumbnailUrl: 'assets/milk_coffee_charm_gallery.jpg',
      fullUrl: 'assets/milk_coffee_charm.jpg'),
].build();

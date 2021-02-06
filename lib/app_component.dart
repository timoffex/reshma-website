import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/angular_components.dart';
import 'package:stream_transform/stream_transform.dart';

import 'artwork.dart';
import 'rz_gallery/rz_gallery.dart';
import 'rz_initials/rz_initials.dart';
import 'rz_overlay/rz_overlay.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    styleUrls: ['app_component.css'],
    directives: [
      FocusTrapComponent,
      MaterialButtonComponent,
      NgFor,
      NgIf,
      RzGallery,
      RzInitials,
      RzOverlay,
    ],
    providers: [materialProviders],
    changeDetection: ChangeDetectionStrategy.OnPush)
class AppComponent implements OnInit, OnDestroy {
  @visibleForTemplate
  final images = [
    Artwork(name: 'Potions', thumbnailUrl: 'assets/potion_gallery.jpg'),
    Artwork(name: 'Mushroom', thumbnailUrl: 'assets/mushroom_gallery.jpg'),
    Artwork(name: 'Stump', thumbnailUrl: 'assets/stump_gallery.jpg'),
    Artwork(name: 'Link Charm', thumbnailUrl: 'assets/link_charm_gallery.jpg'),
    Artwork(
        name: 'Kirby Pancakes',
        thumbnailUrl: 'assets/kirby_pancakes_gallery.jpg'),
    Artwork(name: 'Pika Fruit', thumbnailUrl: 'assets/pika_fruit_gallery.jpg'),
    Artwork(name: 'Girl', thumbnailUrl: 'assets/tennis_player_gallery.jpg'),
    Artwork(name: 'Chuck', thumbnailUrl: 'assets/chuck_gallery.jpg'),
    Artwork(
        name: 'Wooden Charm',
        thumbnailUrl: 'assets/milk_coffee_charm_gallery.jpg'),
  ];

  @visibleForTemplate
  bool topBarVisible = false;

  @visibleForTemplate
  bool scrollButtonVisible = true;

  @visibleForTemplate
  bool overlayVisible = true;

  @visibleForTemplate
  Artwork detailArtwork;

  @visibleForTemplate
  void dismissOverlay() {
    overlayVisible = false;
  }

  @visibleForTemplate
  void handleShowArtworkDetail(Artwork artwork) {
    detailArtwork = artwork;
    overlayVisible = true;
  }

  @visibleForTemplate
  void doScroll() {
    _updateLogo();
  }

  @visibleForTemplate
  void scrollPastLandingArea() {
    gallery.focus();
    if (content.scrollTop < _galleryScrollPosition) {
      content.scrollTo(0, _galleryScrollPosition);
    }
  }

  @visibleForTemplate
  void scrollToTop() {
    content.scrollTo(0, 0);
  }

  @override
  void ngOnInit() {
    _updateLogo();

    _resizeSubscription = window.onResize
        .audit(Duration(milliseconds: 100))
        .listen((_) => _updateLogo());
  }

  @override
  void ngOnDestroy() {
    _resizeSubscription?.cancel();
  }

  void _updateLogo() {
    final offset1 = landingLogoAnchorStart.documentOffset;
    final offset2 = landingLogoAnchorEnd.documentOffset;

    // Starts at 1, goes down to 0.
    final t = min(
        1,
        max(
            0,
            (_galleryScrollPosition - content.scrollTop) /
                _galleryScrollPosition));
    final preblend = (3 - 2 * t) * t * t;

    topBarVisible = preblend < 0.04;
    scrollButtonVisible = preblend > 0.96;
    final blend = topBarVisible ? 0 : preblend;

    final size = 300 * blend + 60 * (1 - blend);
    final targetOffset = offset1 * blend + offset2 * (1 - blend);
    final adjustedOffset = targetOffset - Point(size / 2, size / 2);

    landingLogoElement.style.width = '${size}px';
    landingLogoElement.style.height = '${size}px';
    landingLogoElement.style.top = '${adjustedOffset.y}px';
    landingLogoElement.style.left = '${adjustedOffset.x}px';
  }

  int get _galleryScrollPosition =>
      galleryElement.offsetTop - topBar.scrollHeight;

  StreamSubscription<void> _resizeSubscription;

  @ViewChild('topBar')
  Element topBar;

  @ViewChild('content')
  Element content;

  @ViewChild('rzGallery', read: Element)
  Element galleryElement;

  @ViewChild('rzGallery')
  RzGallery gallery;

  @ViewChild('landingLogoElement')
  Element landingLogoElement;

  @ViewChild('landingLogoAnchorStart')
  Element landingLogoAnchorStart;

  @ViewChild('landingLogoAnchorEnd')
  Element landingLogoAnchorEnd;
}

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/angular_components.dart';
import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:stream_transform/stream_transform.dart';

import 'artwork.dart';
import 'gallery_controller.dart';
import 'gallery_model.dart';
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
      RzGalleryComponent,
      RzInitialsComponent,
      RzOverlayComponent,
    ],
    providers: [
      materialProviders,
      galleryModule,
      galleryControllerModule,
    ],
    changeDetection: ChangeDetectionStrategy.OnPush)
class AppComponent implements OnInit, OnDestroy {
  @visibleForTemplate
  bool topBarVisible = false;

  @visibleForTemplate
  bool scrollButtonVisible = true;

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
    // gallery.focus();
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

    _subscriptions = [
      window.onResize
          .audit(Duration(milliseconds: 100))
          .listen((_) => _updateLogo()),
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
    // gallery.focus();
  }

  void _showOverlay() {
    overlayVisible = true;
  }

  void _updateLogo() {
    final shouldLogoBeVisible = content.scrollTop < 100;

    if (shouldLogoBeVisible != _logoIsVisible) {
      _animateLogo(appearing: shouldLogoBeVisible);
    }
  }

  /// Begins animating the landing logo in the given direction.
  Future<void> _animateLogo({@required bool appearing}) async {
    if (_currentLogoAnimationToken != null &&
        _currentLogoAnimationDisappearing == !appearing) {
      return;
    }

    _currentLogoAnimationToken?.cancel();

    final token = CancellationToken();
    _currentLogoAnimationToken = token;
    _currentLogoAnimationDisappearing = !appearing;

    final startTime = DateTime.now();
    const animDuration = Duration(milliseconds: 300);

    // Hide top bar or landing hint button immediately depending on whether the
    // logo is appearing or disappearing.
    if (appearing) topBarVisible = false;
    if (!appearing) scrollButtonVisible = false;
    _changeDetector.markForCheck();

    const waitDuration = Duration(milliseconds: 20);
    var durationSoFar = Duration();
    while (durationSoFar < animDuration) {
      if (token.cancelled) return;

      final t = min(1,
          max(0, durationSoFar.inMilliseconds / animDuration.inMilliseconds));
      final eased = (3 - 2 * t) * t * t;
      _setLogoBlend(appearing ? eased : 1 - eased);
      _changeDetector.markForCheck();

      await Future.delayed(waitDuration);
      durationSoFar = DateTime.now().difference(startTime);
    }

    if (token.cancelled) return;

    if (appearing) scrollButtonVisible = true;
    if (!appearing) topBarVisible = true;
    _changeDetector.markForCheck();

    _logoIsVisible = appearing;
  }

  void _setLogoBlend(double blend) {
    // Keep in sync with initial values in .scss file!
    final size = 300 * blend + 60 * (1 - blend);

    landingLogoElement.style.width = '${size}px';
    landingLogoElement.style.height = '${size}px';
    landingLogoElement.style.top = '${blend * 33}vh';
    landingLogoElement.style.left = '${blend * 50}vw';
  }

  AppComponent(this._changeDetector, this._controller,
      GalleryModelFactory galleryModelFactory)
      : galleryModel = galleryModelFactory.create(_artworks);

  int get _galleryScrollPosition =>
      reshmaName.offsetTop - topBar.scrollHeight - 16;

  List<StreamSubscription> _subscriptions;

  CancellationToken _currentLogoAnimationToken;
  bool _currentLogoAnimationDisappearing = false;
  bool _logoIsVisible = true;

  @ViewChild('topBar')
  Element topBar;

  @ViewChild('content')
  Element content;

  @ViewChild('reshmaName', read: Element)
  Element reshmaName;

  @ViewChild('landingLogoElement')
  Element landingLogoElement;

  final GalleryController _controller;
  final ChangeDetectorRef _changeDetector;
}

class CancellationToken {
  bool get cancelled => _cancelled;
  bool _cancelled = false;
  void cancel() => _cancelled = true;
}

final _artworks = [
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
].build();

import 'dart:html';
import 'dart:math';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/material_button/material_button.dart';

import 'rz_gallery/rz_gallery.dart';
import 'rz_initials/rz_initials.dart';

@Component(selector: 'my-app', templateUrl: 'app_component.html', styleUrls: [
  'app_component.css'
], directives: [
  MaterialButtonComponent,
  NgFor,
  RzGallery,
  RzInitials,
])
class AppComponent implements OnInit {
  @visibleForTemplate
  final images = [
    'assets/potion.jpg',
    'assets/mushroom.jpg',
    'assets/stump.jpg',
  ];

  @visibleForTemplate
  bool topBarVisible = false;

  @visibleForTemplate
  bool scrollButtonVisible = true;

  @visibleForTemplate
  void doScroll() {
    _updateLogo();
  }

  @visibleForTemplate
  void scrollPastLandingArea() {
    content.scrollTo(0, 700);
  }

  @override
  void ngOnInit() {
    _updateLogo();

    // TODO: Unsubscribe
    window.onResize.listen((_) => _updateLogo());
  }

  void _updateLogo() {
    final offset1 = landingLogoAnchorStart.documentOffset;
    final offset2 = landingLogoAnchorEnd.documentOffset;

    // Starts at 1, goes down to 0.
    final t = min(1, max(0, (500 - content.scrollTop) / 500));
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

  @ViewChild('content')
  Element content;

  @ViewChild('landingLogoElement')
  Element landingLogoElement;

  @ViewChild('landingLogoAnchorStart')
  Element landingLogoAnchorStart;

  @ViewChild('landingLogoAnchorEnd')
  Element landingLogoAnchorEnd;
}

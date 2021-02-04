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
    'https://cdna.artstation.com/p/assets/images/images/026/717/380/large/reshma-zachariah-untitled-artwork-53.jpg?1589529271',
    'https://cdna.artstation.com/p/assets/images/images/026/717/464/large/reshma-zachariah-untitled-artwork-54.jpg?1589529554',
    'https://cdna.artstation.com/p/assets/images/images/024/250/592/large/reshma-zachariah-stump.jpg?1581803144'
  ];

  @visibleForTemplate
  void doScroll() {
    _updateLogo();
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
    final blend = topBarVisible ? 0 : preblend;

    final size = 300 * blend + 60 * (1 - blend);
    final targetOffset = offset1 * blend + offset2 * (1 - blend);
    final adjustedOffset = targetOffset - Point(size / 2, size / 2);

    landingLogoElement.style.width = '${size}px';
    landingLogoElement.style.height = '${size}px';
    landingLogoElement.style.top = '${adjustedOffset.y}px';
    landingLogoElement.style.left = '${adjustedOffset.x}px';
  }

  @visibleForTemplate
  bool topBarVisible = false;

  @ViewChild('content')
  Element content;

  @ViewChild('landingLogoElement')
  Element landingLogoElement;

  @ViewChild('landingLogoAnchorStart')
  Element landingLogoAnchorStart;

  @ViewChild('landingLogoAnchorEnd')
  Element landingLogoAnchorEnd;
}

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:angular/angular.dart';
import 'package:meta/meta.dart';

/// Animation for a logo to be shown on the landing page.
///
/// The logo is always either "visible" or "invisible", as controlled by
/// [shouldLogoBeVisible]. The transition between these states is animated. When
/// the logo is visible, its width and height is at [maxSize] and it's
/// positioned at [topVh] and [leftVw]. When it becomes invisible, its width and
/// height go to [minSize] and the top and left values go to 0.
///
/// The [beginAnimation] and [finishAnimation] events can be used to control
/// other elements on the page based on the state of the logo.
@Directive(selector: '[rzLogoAnimation]')
class RzLogoAnimationDirective implements OnInit {
  @Input()
  set initiallyVisible(bool value) => _isVisible = value;

  @Input()
  set shouldLogoBeVisible(bool value) {
    _shouldLogoBeVisible = value;

    if (_isInitialized) {
      _updateLogo();
    }
  }

  bool _shouldLogoBeVisible;

  @Input()
  double maxSize = 300;

  @Input()
  double minSize = 60;

  @Input()
  double topVh = 33;

  @Input()
  double leftVw = 50;

  /// Triggers whenever the logo animation restarts, with the value set to
  /// whether the logo is appearing (true) or disappearing (false).
  @Output()
  Stream<bool> get beginAnimation => _beginAnimation.stream;
  final _beginAnimation = StreamController<bool>.broadcast();

  /// Triggers whenever the logo animation completes, with the value set to
  /// whether the logo appeared (true) or disappeared (false).
  ///
  /// Note that this does not fire if the animation is interrupted.
  @Output()
  Stream<bool> get finishAnimation => _finishAnimation.stream;
  final _finishAnimation = StreamController<bool>.broadcast();

  @override
  void ngOnInit() {
    _isInitialized = true;
    _updateLogo();
  }

  void _updateLogo() {
    if (_isVisible != _shouldLogoBeVisible) {
      _animateLogo(appearing: _shouldLogoBeVisible);
    }
  }

  Future<void> _animateLogo({@required bool appearing}) async {
    if (_currentAnimationToken != null &&
        _currentAnimationAppearing == appearing) {
      return;
    }

    _currentAnimationToken?.cancel();

    final token = CancellationToken();
    _currentAnimationToken = token;
    _currentAnimationAppearing = !appearing;

    final startTime = DateTime.now();
    const animDuration = Duration(milliseconds: 300);

    _beginAnimation.add(appearing);

    var durationSoFar = Duration();
    while (durationSoFar < animDuration) {
      if (token.cancelled) return;

      final t = min(1,
          max(0, durationSoFar.inMilliseconds / animDuration.inMilliseconds));
      final eased = (3 - 2 * t) * t * t;
      _setLogoBlend(appearing ? eased : 1 - eased);

      await window.animationFrame;
      durationSoFar = DateTime.now().difference(startTime);
    }

    if (token.cancelled) return;

    _currentAnimationToken = null;
    _currentAnimationAppearing = null;

    _finishAnimation.add(appearing);
    _isVisible = appearing;
  }

  void _setLogoBlend(double blend) {
    final size = maxSize * blend + minSize * (1 - blend);

    _element.style.width = '${size}px';
    _element.style.height = '${size}px';
    _element.style.top = '${blend * topVh}vh';
    _element.style.left = '${blend * leftVw}vw';
  }

  RzLogoAnimationDirective(this._element);
  final Element _element;
  bool _isInitialized = false;
  bool _isVisible;
  CancellationToken _currentAnimationToken;
  bool _currentAnimationAppearing;
}

class CancellationToken {
  bool get cancelled => _cancelled;
  bool _cancelled = false;
  void cancel() => _cancelled = true;
}

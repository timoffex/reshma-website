import 'dart:async';
import 'dart:html';

import 'package:angular/core.dart';
import 'package:angular/meta.dart';

/// An alternative to the <img> element that makes it clear when the image
/// is loading.
///
/// This is intended to be used when the [src] attribute is supposed to change
/// in response to user events but the new image might load slowly which could
/// confuse a user.
@Component(
    selector: 'slow-load-image',
    templateUrl: 'slow_load_image.html',
    styleUrls: ['slow_load_image.css'],
    changeDetection: ChangeDetectionStrategy.OnPush)
class SlowLoadImageComponent {
  @Input()
  String alt;

  @Input()
  set src(String newSrc) {
    _src = newSrc;

    isLoading = true;

    _imageOnLoadSubscription?.cancel();
    _imageOnLoadSubscription = _image.onLoad.listen((_) {
      isLoading = false;
      _changeDetector.markForCheck();
    });
  }

  String get src => _src;
  String _src;

  @visibleForTemplate
  bool isLoading = false;

  @ViewChild('image')
  set imageElement(Element element) {
    _image = element as ImageElement;
  }

  SlowLoadImageComponent(this._changeDetector);

  ImageElement _image;
  StreamSubscription _imageOnLoadSubscription;
  final ChangeDetectorRef _changeDetector;
}

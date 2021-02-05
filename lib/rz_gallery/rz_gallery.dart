import 'package:angular/angular.dart';
import 'package:angular_components/focus/focus_item.dart';
import 'package:angular_components/focus/focus_list.dart';

import 'package:reshmawebsite/artwork.dart';

@Component(
    selector: 'rz-gallery',
    templateUrl: 'rz_gallery.html',
    styleUrls: ['rz_gallery.css'],
    directives: [NgFor, FocusItemDirective, FocusListDirective],
    changeDetection: ChangeDetectionStrategy.OnPush)
class RzGallery {
  @Input()
  List<Artwork> artworks;

  void focus() {
    if (!_hasFocus) {
      container.focus(0);
    }
  }

  @HostListener('focusin')
  void onFocusIn() {
    _hasFocus = true;
  }

  @HostListener('focusout')
  void onFocusOut() {
    _hasFocus = false;
  }

  @ViewChild('container', read: FocusListDirective)
  FocusListDirective container;

  bool _hasFocus = false;
}

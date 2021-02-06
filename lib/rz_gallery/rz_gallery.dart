import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
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

  @Output()
  Stream<Artwork> get showArtworkDetail => _showArtworkDetail.stream;
  final _showArtworkDetail = StreamController<Artwork>.broadcast();

  void focus() {
    if (!_hasFocus) {
      container.focus(0);
    }
  }

  @visibleForTemplate
  void handleClickArtwork(Artwork artwork) {
    _showArtworkDetail.add(artwork);
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

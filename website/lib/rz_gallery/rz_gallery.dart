import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/focus/focus_item.dart';
import 'package:angular_components/focus/focus_list.dart';
import 'package:built_collection/built_collection.dart';

import 'package:reshmawebsite/artwork.dart';
import 'package:reshmawebsite/gallery_model.dart';

@Component(
    selector: 'rz-gallery',
    templateUrl: 'rz_gallery.html',
    styleUrls: ['rz_gallery.css'],
    directives: [NgFor, FocusItemDirective, FocusListDirective],
    changeDetection: ChangeDetectionStrategy.OnPush)
class RzGalleryComponent {
  @Input()
  GalleryModel galleryModel;

  @visibleForTemplate
  BuiltList<Artwork> get artworks => galleryModel.artworks;

  @visibleForTemplate
  void handleClickArtwork(int index) {
    galleryModel.focusArtworkAtIndex(index);
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

  // TODO: Use this again
  bool _hasFocus = false;
}

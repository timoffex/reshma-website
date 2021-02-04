import 'package:angular/angular.dart';
import 'package:angular_components/focus/focus_item.dart';
import 'package:angular_components/focus/focus_list.dart';

import 'package:reshmawebsite/artwork.dart';

@Component(
    selector: 'rz-gallery',
    templateUrl: 'rz_gallery.html',
    styleUrls: ['rz_gallery.css'],
    directives: [NgFor, FocusItemDirective, FocusListDirective])
class RzGallery {
  @Input()
  List<Artwork> artworks;

  void focus() {
    container.focus(0);
  }

  @ViewChild('container', read: FocusListDirective)
  FocusListDirective container;
}

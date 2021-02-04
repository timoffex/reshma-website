import 'package:angular/angular.dart';

@Component(
    selector: 'rz-gallery',
    templateUrl: 'rz_gallery.html',
    styleUrls: ['rz_gallery.css'],
    directives: [NgFor])
class RzGallery {
  @Input()
  List<String> artworks;
}

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/angular_components.dart';
import 'package:built_collection/built_collection.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rz.coreweb/gallery_controller.dart';
import 'package:rz.coreweb/gallery_model.dart';
import 'package:rz.coreweb/rz_gallery/rz_gallery.dart';
import 'package:rz.coreweb/shell/shell.dart';
import 'package:rz.proto/rz_schema.pb.dart' as pb;

@Component(
    selector: 'app-component',
    templateUrl: 'app_component.html',
    directives: [
      NgIf,
      RzGalleryComponent,
      ShellComponent,
    ],
    providers: [
      materialProviders,
      galleryModule,
      galleryControllerModule,
    ],
    changeDetection: ChangeDetectionStrategy.OnPush)
class AppComponent implements OnInit {
  @visibleForTemplate
  GalleryModel galleryModel;

  @visibleForTemplate
  BuiltList<GalleryArtwork> artworks;

  @visibleForTemplate
  BuiltList<GalleryArtwork> merch;

  @override
  void ngOnInit() {
    unawaited(_fetchSchema());
  }

  Future<void> _fetchSchema() async {
    final schema =
        pb.RzWebsiteSchema.fromJson(await HttpRequest.getString('/schema'));

    artworks = schema.galleryArtworks
        .map((artwork) => GalleryArtwork(
            name: artwork.name,
            thumbnailUrl: artwork.thumbnailUri,
            fullUrl: artwork.previewUri))
        .toBuiltList();

    merch = schema.merch
        .map((artwork) => GalleryArtwork(
            name: artwork.name,
            thumbnailUrl: artwork.thumbnailUri,
            fullUrl: artwork.previewUri))
        .toBuiltList();

    galleryModel = _galleryModelFactory.create(artworks, merch);
    _changeDetector.markForCheck();
  }

  AppComponent(this._galleryModelFactory, this._changeDetector);

  final GalleryModelFactory _galleryModelFactory;
  final ChangeDetectorRef _changeDetector;
}

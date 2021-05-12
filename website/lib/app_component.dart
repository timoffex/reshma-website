import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/angular_components.dart';
import 'package:built_collection/built_collection.dart';
import 'package:pedantic/pedantic.dart';
import 'package:reshmawebsite/shell/shell.dart';
import 'package:rz.proto/rz_schema.pb.dart' as pb;

import 'gallery_controller.dart';
import 'gallery_model.dart';
import 'rz_gallery/rz_gallery.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    styleUrls: ['app_component.css'],
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

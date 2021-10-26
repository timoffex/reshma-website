import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/angular_components.dart';
import 'package:built_collection/built_collection.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rz.coreweb/artwork.dart';
import 'package:rz.coreweb/shell/shell.dart';
import 'package:rz.editor/rz_gallery_editor/rz_gallery_editor.dart';
import 'package:rz.proto/rz_schema.pb.dart' as pb;

@Component(
    selector: 'app-component',
    templateUrl: 'app_component.html',
    directives: [
      NgIf,
      RzGalleryEditorComponent,
      ShellComponent,
    ],
    providers: [materialProviders],
    changeDetection: ChangeDetectionStrategy.OnPush)
class AppComponent implements OnInit {
  @visibleForTemplate
  bool get hasArtworks => artworks != null && merch != null;

  @visibleForTemplate
  BuiltList<Artwork> artworks;

  @visibleForTemplate
  BuiltList<Artwork> merch;

  @override
  void ngOnInit() {
    unawaited(_fetchSchema());
  }

  Future<void> _fetchSchema() async {
    final schema =
        pb.RzWebsiteSchema.fromJson(await HttpRequest.getString('/schema'));

    artworks = schema.galleryArtworks
        .map((artwork) => Artwork(
            name: artwork.name,
            thumbnailUrl: artwork.thumbnailUri,
            fullUrl: artwork.previewUri))
        .toBuiltList();

    merch = schema.merch
        .map((artwork) => Artwork(
            name: artwork.name,
            thumbnailUrl: artwork.thumbnailUri,
            fullUrl: artwork.previewUri))
        .toBuiltList();

    _changeDetector.markForCheck();
  }

  AppComponent(this._changeDetector);

  final ChangeDetectorRef _changeDetector;
}

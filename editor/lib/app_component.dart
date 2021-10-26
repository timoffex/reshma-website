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
import 'package:stream_transform/stream_transform.dart';

@Component(
    selector: 'app-component',
    templateUrl: 'app_component.html',
    styleUrls: ['app_component.css'],
    directives: [
      MaterialButtonComponent,
      MaterialSpinnerComponent,
      NgIf,
      RzGalleryEditorComponent,
      ShellComponent,
    ],
    providers: [materialProviders],
    changeDetection: ChangeDetectionStrategy.OnPush)
class AppComponent implements OnInit {
  @visibleForTemplate
  bool get isSaving => _isSaving;

  @visibleForTemplate
  bool get needsSaving => _needsSave;

  @visibleForTemplate
  bool get hasArtworks => artworks != null && merch != null;

  @visibleForTemplate
  BuiltList<Artwork> get artworks => _artworks;
  BuiltList<Artwork> _artworks;
  @visibleForTemplate
  set artworks(BuiltList<Artwork> artworks) {
    _artworks = artworks;
    _handleModelUpdated();
  }

  @visibleForTemplate
  BuiltList<Artwork> get merch => _merch;
  BuiltList<Artwork> _merch;
  @visibleForTemplate
  set merch(BuiltList<Artwork> merch) {
    _merch = merch;
    _handleModelUpdated();
  }

  @override
  void ngOnInit() {
    unawaited(_fetchSchema());
  }

  Future<void> _fetchSchema() async {
    final schema =
        pb.RzWebsiteSchema.fromJson(await HttpRequest.getString('/schema'));

    _artworks = schema.galleryArtworks
        .map((artwork) => Artwork(
            name: artwork.name,
            thumbnailUrl: artwork.thumbnailUri,
            fullUrl: artwork.previewUri))
        .toBuiltList();

    _merch = schema.merch
        .map((artwork) => Artwork(
            name: artwork.name,
            thumbnailUrl: artwork.thumbnailUri,
            fullUrl: artwork.previewUri))
        .toBuiltList();

    _changeDetector.markForCheck();
  }

  void _handleModelUpdated() {
    _needsSave = true;
    _modelUpdated.add(null);
    _changeDetector.markForCheck();
  }

  @visibleForTemplate
  Future<void> saveModel() async {
    _isSaving = true;
    _changeDetector.markForCheck();

    try {
      await Future.delayed(Duration(seconds: 3));
      _needsSave = false;
    } finally {
      _isSaving = false;
      _changeDetector.markForCheck();
    }
  }

  AppComponent(this._changeDetector) {
    _modelUpdated.stream.audit(Duration(seconds: 5)).listen((_) {
      saveModel();
    });
  }

  final ChangeDetectorRef _changeDetector;
  final _modelUpdated = StreamController<void>.broadcast();
  bool _needsSave = false;
  bool _isSaving = false;
}

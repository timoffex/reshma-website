import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/angular_components.dart' hide overlayModule;
import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rz.coreweb/artwork.dart';
import 'package:rz.coreweb/model_listener_mixin.dart';
import 'package:rz.coreweb/overlay_model.dart';
import 'package:rz.coreweb/rz_gallery/rz_gallery.dart';
import 'package:rz.coreweb/rz_overlay/rz_overlay.dart';
import 'package:rz.coreweb/shell/shell.dart';
import 'package:rz.proto/rz_schema.pb.dart' as pb;

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    styleUrls: ['app_component.css'],
    directives: [
      FocusTrapComponent,
      NgIf,
      RzGalleryComponent,
      RzOverlayComponent,
      ShellComponent,
    ],
    providers: [materialProviders, overlayModule],
    changeDetection: ChangeDetectionStrategy.OnPush)
class AppComponent with ModelListenerMixin implements OnInit {
  @visibleForTemplate
  bool get overlayVisible => _overlay.overlayShown;

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

    changeDetector.markForCheck();
  }

  AppComponent(this._overlay, this.changeDetector) {
    observeModel(_overlay);
  }

  final OverlayModel _overlay;

  @override
  @protected
  final ChangeDetectorRef changeDetector;
}

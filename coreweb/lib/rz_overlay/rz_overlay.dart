import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/material_button/material_fab.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:meta/meta.dart';
import 'package:rz.coreweb/artwork.dart';
import 'package:rz.coreweb/model_listener_mixin.dart';
import 'package:rz.coreweb/slow_load_image/slow_load_image.dart';
import 'package:rz.coreweb/overlay_model.dart';

@Component(
  selector: 'rz-overlay',
  templateUrl: 'rz_overlay.html',
  styleUrls: ['rz_overlay.css'],
  directives: [
    AutoDismissDirective,
    AutoFocusDirective,
    MaterialFabComponent,
    MaterialIconComponent,
    NgIf,
    SlowLoadImageComponent,
  ],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class RzOverlayComponent with ModelListenerMixin {
  @visibleForTemplate
  bool get hasArtwork => _model.overlayArtworks != null;

  @visibleForTemplate
  bool get hasLeft => hasArtwork && _model.overlayArtworks.hasPrev;

  @visibleForTemplate
  bool get hasRight => hasArtwork && _model.overlayArtworks.hasNext;

  @visibleForTemplate
  Artwork get artwork => _model.overlayArtworks.currentArtwork;

  @HostListener('keyup.escape')
  @visibleForTemplate
  void handleDismiss() {
    _model.overlayShown = false;
  }

  @HostListener('keyup.arrowLeft')
  @visibleForTemplate
  void handleGoLeft() {
    if (hasLeft) {
      _model.overlayArtworks.showPrev();
    }
  }

  @HostListener('keyup.arrowRight')
  @visibleForTemplate
  void handleGoRight() {
    if (hasRight) {
      _model.overlayArtworks.showNext();
    }
  }

  RzOverlayComponent(this.changeDetector, this._model) {
    observeModel(_model);
  }

  @override
  @protected
  final ChangeDetectorRef changeDetector;
  final OverlayModel _model;
}

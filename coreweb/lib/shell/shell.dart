import 'package:angular/angular.dart';
import 'package:angular/core.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/angular_components.dart' hide overlayModule;
import 'package:angular_components/utils/disposer/disposer.dart';
import 'package:rz.coreweb/overlay_model.dart';
import 'package:rz.coreweb/rz_gallery/rz_gallery.dart';
import 'package:rz.coreweb/rz_overlay/rz_overlay.dart';
import 'package:rz.coreweb/rz_resume/rz_resume.dart';
import 'package:rz.coreweb/rz_video/rz_video.dart';

/// The root component for the website.
///
/// This has two ng-content slots: artwork and merch. The main website and the
/// editor application can use different components in these places.
@Component(
    selector: 'rz-shell',
    templateUrl: 'shell.html',
    styleUrls: ['shell.css'],
    directives: [
      FocusTrapComponent,
      MaterialButtonComponent,
      NgFor,
      NgIf,
      RzGalleryComponent,
      RzOverlayComponent,
      RzResumeComponent,
      RzVideoComponent,
    ],
    providers: [overlayModule],
    changeDetection: ChangeDetectionStrategy.OnPush)
class ShellComponent implements OnDestroy {
  @visibleForTemplate
  bool get overlayVisible => _overlayModel.overlayShown;

  ShellComponent(this._changeDetector, this._overlayModel) {
    _disposer.addStreamSubscription(
        _overlayModel.changes.listen((_) => _changeDetector.markForCheck()));
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
  }

  final _disposer = Disposer.oneShot();
  final ChangeDetectorRef _changeDetector;
  final OverlayModel _overlayModel;
}

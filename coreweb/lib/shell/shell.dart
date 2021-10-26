import 'package:angular/angular.dart';
import 'package:angular/core.dart';
import 'package:angular_components/angular_components.dart';
import 'package:rz.coreweb/rz_gallery/rz_gallery.dart';
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
      MaterialButtonComponent,
      NgFor,
      NgIf,
      RzGalleryComponent,
      RzResumeComponent,
      RzVideoComponent,
    ],
    changeDetection: ChangeDetectionStrategy.OnPush)
class ShellComponent {}

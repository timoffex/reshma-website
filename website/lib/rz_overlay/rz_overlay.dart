import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/material_button/material_fab.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:reshmawebsite/artwork.dart';

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
  ],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class RzOverlayComponent {
  @Input()
  Artwork artwork;

  @Output()
  Stream<void> get onDismiss => _onDismiss.stream;
  final _onDismiss = StreamController<void>.broadcast();

  @visibleForTemplate
  bool get hasLeft => artwork.prev != null;

  @visibleForTemplate
  bool get hasRight => artwork.next != null;

  @HostListener('keyup.escape')
  @visibleForTemplate
  void handleDismiss() => _onDismiss.add(null);

  @HostListener('keyup.arrowLeft')
  @visibleForTemplate
  void handleGoLeft() {
    if (hasLeft) {
      artwork = artwork.prev;
    }
  }

  @HostListener('keyup.arrowRight')
  @visibleForTemplate
  void handleGoRight() {
    if (hasRight) {
      artwork = artwork.next;
    }
  }
}

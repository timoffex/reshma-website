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
    MaterialIconComponent
  ],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class RzOverlay {
  @Input()
  Artwork artwork;

  @Output()
  Stream get dismiss => _dismiss.stream;
  final _dismiss = StreamController.broadcast();

  @visibleForTemplate
  void handleDismiss() => _dismiss.add(null);
}

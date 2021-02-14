import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/material_button/material_fab.dart';
import 'package:angular_components/material_icon/material_icon.dart';

@Component(
    selector: 'rz-video',
    templateUrl: 'rz_video.html',
    styleUrls: ['rz_video.css'],
    directives: [MaterialFabComponent, MaterialIconComponent, NgIf],
    changeDetection: ChangeDetectionStrategy.OnPush)
class RzVideoComponent implements OnInit {
  @visibleForTemplate
  bool videoPlaying = false;

  @visibleForTemplate
  void playVideo() {
    _video.play();
    videoPlaying = true;
  }

  @visibleForTemplate
  void pauseVideo() {
    _video.pause();
    videoPlaying = false;
  }

  @ViewChild('video')
  set videoElement(Element element) {
    _video = element as VideoElement;
  }

  @override
  void ngOnInit() {
    _video.onPlay.listen((_) {
      videoPlaying = true;
    });

    _video.onPause.listen((_) {
      videoPlaying = false;
    });
  }

  VideoElement _video;
}

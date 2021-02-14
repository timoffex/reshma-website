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
    // A terrible hack to make it possible to pause the video by pressing space.
    // Without this, pressing space to pause the video immediately activates the
    // play button.
    if (DateTime.now().compareTo(_timeCanPlayVideo) < 0) return;

    _video.play();
    _video.focus();
    videoPlaying = true;
  }

  @visibleForTemplate
  void pauseVideo(Event event) {
    // event.stopImmediatePropagation();
    _video.pause();
    videoPlaying = false;
    _timeCanPlayVideo = DateTime.now().add(Duration(milliseconds: 500));

    // Run after changes to give Angular time to create the element.
    _ngZone.runAfterChangesObserved(() {
      playButton.focus();
    });
  }

  @ViewChild('video')
  set videoElement(Element element) {
    _video = element as VideoElement;
  }

  @ViewChild('playButton', read: Element)
  Element playButton;

  @override
  void ngOnInit() {
    _video.onPlay.listen((_) {
      videoPlaying = true;
    });

    _video.onPause.listen((_) {
      videoPlaying = false;
    });
  }

  RzVideoComponent(this._ngZone);

  DateTime _timeCanPlayVideo = DateTime.fromMicrosecondsSinceEpoch(0);
  VideoElement _video;
  final NgZone _ngZone;
}

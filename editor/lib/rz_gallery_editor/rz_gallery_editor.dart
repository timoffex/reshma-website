import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/core.dart';
import 'package:angular/meta.dart';
import 'package:built_collection/built_collection.dart';
import 'package:rz.coreweb/artwork.dart';

@Component(
    selector: 'rz-gallery-editor',
    templateUrl: 'rz_gallery_editor.html',
    styleUrls: ['rz_gallery_editor.css'],
    directives: [NgFor],
    changeDetection: ChangeDetectionStrategy.OnPush)
class RzGalleryEditorComponent {
  @Input()
  BuiltList<Artwork> artworks;

  @Output()
  Stream<BuiltList<Artwork>> get artworksChange => _artworksChange.stream;
  final _artworksChange = StreamController<BuiltList<Artwork>>.broadcast();

  @visibleForTemplate
  void startDrag(int index, MouseEvent event) {
    event.dataTransfer.setData('__artwork_index', '$index');
  }

  @visibleForTemplate
  void onDragOver(int index, MouseEvent event) {
    event.preventDefault();
    event.dataTransfer.dropEffect = 'move';
  }

  @visibleForTemplate
  void onDrop(int index, MouseEvent event) {
    event.preventDefault();
    final originalIndex =
        int.tryParse(event.dataTransfer.getData('__artwork_index'));
    if (originalIndex == null) return;
    print('Drop $originalIndex at $index');
    _artworksChange.add(artworks.rebuild((b) {
      b[originalIndex] = artworks[index];
      b[index] = artworks[originalIndex];
    }));
  }
}

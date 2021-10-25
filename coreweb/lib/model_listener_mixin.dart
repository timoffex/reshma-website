import 'package:angular/angular.dart';
import 'package:angular_components/utils/disposer/disposer.dart';
import 'package:observable/observable.dart';
import 'package:meta/meta.dart';

/// Mixin for component classes that depend on a model class.
///
/// Components that use properties from a "model" class can add this mixin and
/// call [observeModel] in their constructor to automatically update themselves
/// when the model changes and to dispose that stream subscription in
/// [ngOnDestroy].
mixin ModelListenerMixin implements OnDestroy {
  @protected
  final disposer = Disposer.oneShot();

  @protected
  ChangeDetectorRef get changeDetector;

  @override
  @mustCallSuper
  void ngOnDestroy() {
    disposer.dispose();
  }

  /// Marks the component's [changeDetector] for checking whenever the
  /// observable has changes.
  @protected
  void observeModel(Observable observable) {
    disposer.addStreamSubscription(
        observable.changes.listen((_) => changeDetector.markForCheck()));
  }
}

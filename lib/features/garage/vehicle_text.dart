import '../../data/db/database.dart';

extension VehicleText on Vehicle {
  /// `Toyota Corolla`
  String get displayName => '$brand $model';

  /// `2018 · AB 1234-7`, empty when neither is set.
  String get details => [if (year != null) '$year', ?plate].join(' · ');
}

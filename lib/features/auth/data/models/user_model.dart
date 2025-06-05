import 'package:json_annotation/json_annotation.dart';
import 'package:opsmate/features/auth/domain/entities/user.dart';

part 'user_model.g.dart';

/// A data model that extends the [User] entity and includes
/// JSON serialization support for API integration.
@JsonSerializable()
class UserModel extends User {
  /// Creates a [UserModel] instance.
  ///
  /// Inherits all properties from [User].
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.token,
  });

  /// Creates a [UserModel] instance from a JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Converts the [UserModel] instance into a JSON map.
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

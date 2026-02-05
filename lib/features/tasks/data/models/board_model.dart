import 'package:taskflow/features/tasks/domain/entities/board_entity.dart';

/// Board model - represents a board in the data layer
/// Handles JSON serialization/deserialization
class BoardModel {
  final String id;
  final String name;
  final String? description;
  final String createdAt;
  final String updatedAt;
  final String? ownerId;
  final bool isSynced;

  const BoardModel({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.ownerId,
    this.isSynced = true,
  });

  /// Create BoardModel from JSON
  factory BoardModel.fromJson(Map<String, dynamic> json) {
    return BoardModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      ownerId: json['owner_id'] as String?,
      isSynced:
          (json['is_synced'] as int?) == 1 ||
          (json['is_synced'] as bool?) == true,
    );
  }

  /// Convert BoardModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'owner_id': ownerId,
    };
  }

  /// Convert BoardModel to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'owner_id': ownerId,
      'is_synced': isSynced ? 1 : 0,
    };
  }

  /// Create BoardModel from SQLite Map
  factory BoardModel.fromMap(Map<String, dynamic> map) {
    return BoardModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
      ownerId: map['owner_id'] as String?,
      isSynced: map['is_synced'] as int == 1,
    );
  }

  /// Convert BoardModel to Board entity
  Board toEntity() {
    return Board(
      id: id,
      name: name,
      description: description,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      ownerId: ownerId,
    );
  }

  /// Create BoardModel from Board entity
  factory BoardModel.fromEntity(Board entity) {
    return BoardModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
      ownerId: entity.ownerId,
    );
  }

  /// Create a copy of this model with modified fields
  BoardModel copyWith({
    String? id,
    String? name,
    String? description,
    String? createdAt,
    String? updatedAt,
    String? ownerId,
    bool? isSynced,
  }) {
    return BoardModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ownerId: ownerId ?? this.ownerId,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}

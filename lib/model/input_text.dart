import 'package:flutter/foundation.dart';

class InputText {
  const InputText({
    @required this.id,
    @required this.body,
    @required this.createdAt,
    @required this.updatedAt,
  })  : assert(id != null),
        assert(body != null),
        assert(createdAt != null),
        assert(updatedAt != null);

  final int id;
  final String body;
  final DateTime createdAt;
  final DateTime updatedAt;

  int get getId => id;
  String get getBody => '$body';
  DateTime get getUpdatedAt => updatedAt;

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": body,
        "created_at": createdAt.toUtc().toIso8601String(),
        "updated_at": updatedAt.toUtc().toIso8601String(),
      };

  factory InputText.fromMap(Map<String, dynamic> json) => InputText(
        id: json["id"],
        body: json["body"],
        createdAt: DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
      );
}

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
  final String createdAt;
  final String updatedAt;

  int get getId => id;
  String get getBody => '$body';
  String get getUpdatedAt => '$updatedAt';

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": body,
        "created_at": createdAt,
      };

  factory InputText.fromMap(Map<String, dynamic> json) => InputText(
        id: json["id"],
        body: json["body"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );
}

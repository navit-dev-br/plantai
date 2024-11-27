// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Plant {
  final String name;
  final String cientificName;
  final String description;
  final List<Info> items;
  final Uint8List? imageBytes;
  Plant({
    required this.name,
    required this.cientificName,
    required this.description,
    required this.items,
    required this.imageBytes,
  });

  Plant copyWith({
    String? name,
    String? cientificName,
    String? description,
    List<Info>? items,
    Uint8List? imageBytes,
  }) {
    return Plant(
      name: name ?? this.name,
      cientificName: cientificName ?? this.cientificName,
      description: description ?? this.description,
      items: items ?? this.items,
      imageBytes: imageBytes ?? this.imageBytes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'cientificName': cientificName,
      'description': description,
      'items': items.map((x) => x.toMap()).toList(),
      'imageBytes': base64Encode(imageBytes!),
    };
  }

  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      name: map['name'] as String,
      cientificName: map['cientificName'] as String,
      description: map['description'] as String,
      items: List<Info>.from(
        (map['items'] as List).map<Info>(
          (x) => Info.fromMap(x as Map<String, dynamic>),
        ),
      ),
      imageBytes:
          map['imageBytes'] != null ? base64Decode(map['imageBytes']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Plant.fromJson(String source) =>
      Plant.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Plant(name: $name, cientificName: $cientificName, description: $description, items: $items, imageBytes: $imageBytes)';
  }

  @override
  bool operator ==(covariant Plant other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.cientificName == cientificName &&
        other.description == description &&
        listEquals(other.items, items) &&
        other.imageBytes == imageBytes;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        cientificName.hashCode ^
        description.hashCode ^
        items.hashCode ^
        imageBytes.hashCode;
  }
}

class Info {
  final String title;
  final String description;
  Info({
    required this.title,
    required this.description,
  });

  Info copyWith({
    String? title,
    String? description,
  }) {
    return Info(
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
    };
  }

  factory Info.fromMap(Map<String, dynamic> map) {
    return Info(
      title: map['title'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Info.fromJson(String source) =>
      Info.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Info(title: $title, description: $description)';

  @override
  bool operator ==(covariant Info other) {
    if (identical(this, other)) return true;

    return other.title == title && other.description == description;
  }

  @override
  int get hashCode => title.hashCode ^ description.hashCode;
}

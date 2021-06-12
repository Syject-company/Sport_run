class ErrorModel {
  ErrorModel({
    required this.type,
    required this.title,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> map) {
    return ErrorModel(
      type: map['type'] as String?,
      title: map['title'] as String?,
    );
  }

  String? type;
  String? title;

  ErrorModel copyWith({
    String? type,
    String? title,
  }) {
    return ErrorModel(
      type: type ?? this.type,
      title: title ?? this.title,
    );
  }

  @override
  String toString() {
    return 'ErrorModel{type: $type, title: $title}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ErrorModel &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          title == other.title);

  @override
  int get hashCode => type.hashCode ^ title.hashCode;

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
    return {
      'type': type,
      'title': title,
    } as Map<String, dynamic>;
  }
}

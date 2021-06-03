class RegisterResponseModel {
  RegisterResponseModel({
    required this.token,
    required this.id,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> map) {
    return RegisterResponseModel(
      token: map['token'] as String,
      id: map['id'] as String,
    );
  }

  String token;
  String id;

  RegisterResponseModel copyWith({
    String? token,
    String? id,
  }) {
    return RegisterResponseModel(
      token: token ?? this.token,
      id: id ?? this.id,
    );
  }

  @override
  String toString() {
    return 'RegisterResponseModel{token: $token, id: $id}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegisterResponseModel &&
          runtimeType == other.runtimeType &&
          token == other.token &&
          id == other.id);

  @override
  int get hashCode => token.hashCode ^ id.hashCode;

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
    return {
      'token': token,
      'id': id,
    } as Map<String, dynamic>;
  }
}

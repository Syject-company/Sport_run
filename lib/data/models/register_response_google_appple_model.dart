class RegisterResponseGoogleAppleModel {
  RegisterResponseGoogleAppleModel({
    required this.token,
    required this.id,
    required this.isRegistration,
  });

  factory RegisterResponseGoogleAppleModel.fromJson(Map<String, dynamic> map) {
    return RegisterResponseGoogleAppleModel(
      token: map['token'] as String,
      id: map['id'] as String,
      isRegistration: map['isRegistration'] as bool,
    );
  }

  String token;
  String id;
  bool isRegistration;

  RegisterResponseGoogleAppleModel copyWith({
    String? token,
    String? id,
    bool? isRegistration,
  }) {
    return RegisterResponseGoogleAppleModel(
      token: token ?? this.token,
      id: id ?? this.id,
      isRegistration: isRegistration ?? this.isRegistration,
    );
  }

  @override
  String toString() {
    return 'RegisterResponseGoogleAppleModel{token: $token, id: $id, isRegistration: $isRegistration}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegisterResponseGoogleAppleModel &&
          runtimeType == other.runtimeType &&
          token == other.token &&
          id == other.id &&
          isRegistration == other.isRegistration);

  @override
  int get hashCode => token.hashCode ^ id.hashCode ^ isRegistration.hashCode;

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
    return {
      'token': token,
      'id': id,
      'isRegistration': isRegistration,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

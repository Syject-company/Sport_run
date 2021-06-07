class RegisterGoogleAppleModel {
  RegisterGoogleAppleModel({
    required this.accessToken,
  });

  factory RegisterGoogleAppleModel.fromJson(Map<String, dynamic> map) {
    return RegisterGoogleAppleModel(
      accessToken: map['accessToken'] as String,
    );
  }

  String accessToken;

  RegisterGoogleAppleModel copyWith({
    String? accessToken,
  }) {
    return RegisterGoogleAppleModel(
      accessToken: accessToken ?? this.accessToken,
    );
  }

  @override
  String toString() {
    return 'RegisterGoogleAppleModel{accessToken: $accessToken}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegisterGoogleAppleModel &&
          runtimeType == other.runtimeType &&
          accessToken == other.accessToken);

  @override
  int get hashCode => accessToken.hashCode;

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
    return {
      'accessToken': accessToken,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

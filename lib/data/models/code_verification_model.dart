class CodeVerificationModel {
  CodeVerificationModel({
    required this.email,
    required this.confirmationCode,
  });

  factory CodeVerificationModel.fromJson(Map<String, dynamic> map) {
    return CodeVerificationModel(
      email: map['email'] as String,
      confirmationCode: map['confirmationCode'] as String,
    );
  }

  String email;
  String confirmationCode;

  CodeVerificationModel copyWith({
    String? email,
    String? confirmationCode,
  }) {
    return CodeVerificationModel(
      email: email ?? this.email,
      confirmationCode: confirmationCode ?? this.confirmationCode,
    );
  }

  @override
  String toString() {
    return 'CodeVerificationModel{email: $email, confirmationCode: $confirmationCode}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CodeVerificationModel &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          confirmationCode == other.confirmationCode);

  @override
  int get hashCode => email.hashCode ^ confirmationCode.hashCode;

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
    return {
      'email': email,
      'confirmationCode': confirmationCode,
    } as Map<String, dynamic>;
  }
}

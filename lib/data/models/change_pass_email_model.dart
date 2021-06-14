class ChangePassEmailModel {
  ChangePassEmailModel({
    required this.email,
  });

  factory ChangePassEmailModel.fromJson(Map<String, dynamic> map) {
    return ChangePassEmailModel(
      email: map['email'] as String,
    );
  }

  String email;

  ChangePassEmailModel copyWith({
    String? email,
  }) {
    return ChangePassEmailModel(
      email: email ?? this.email,
    );
  }

  @override
  String toString() {
    return 'ChangePassEmailModel{email: $email}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChangePassEmailModel &&
          runtimeType == other.runtimeType &&
          email == other.email);

  @override
  int get hashCode => email.hashCode;

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
    return {
      'email': email,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

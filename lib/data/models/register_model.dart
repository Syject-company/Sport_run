class RegisterModel {
  RegisterModel({
    required this.email,
    required this.password,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  String email;
  String password;

  RegisterModel copyWith({
    String? email,
    String? password,
  }) {
    return RegisterModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'RegisterModel{email: $email, password: $password}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegisterModel &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          password == other.password);

  @override
  int get hashCode => email.hashCode ^ password.hashCode;

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
    return {
      'email': email,
      'password': password,
    } as Map<String, dynamic>;
  }
}

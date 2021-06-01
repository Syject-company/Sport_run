class RegisterModel {
  RegisterModel({
    required this.email,
    required this.password,
    required this.password_confirmation,
  });

  String email;
  String password;
  String password_confirmation;

  RegisterModel copyWith({
    String? email,
    String? password,
    String? password_confirmation,
  }) {
    return RegisterModel(
      email: email ?? this.email,
      password: password ?? this.password,
      password_confirmation:
          password_confirmation ?? this.password_confirmation,
    );
  }

  @override
  String toString() {
    return 'RegisterModel{email: $email, password: $password, password_confirmation: $password_confirmation}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegisterModel &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          password == other.password &&
          password_confirmation == other.password_confirmation);

  @override
  int get hashCode =>
      email.hashCode ^ password.hashCode ^ password_confirmation.hashCode;

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return  RegisterModel(
      email: json['email'] as String,
      password: json['password'] as String,
      password_confirmation: json['password_confirmation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
    return {
      'email': email,
      'password': password,
      'password_confirmation': password_confirmation,
    } as Map<String, dynamic>;
  }
}

class SignUpRequest {
  final String username;
  final String name;
  final String password;
  final String confirmPassword;

  SignUpRequest({
    required this.username,
    required this.name,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'name': name,
    'password': password,
    'confirmPassword': confirmPassword,
  };
}
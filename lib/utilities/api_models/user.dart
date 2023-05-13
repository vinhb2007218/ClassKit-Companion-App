class User {
  final String? userId;
  final String? name;
  final String? account;
  final String? password;
  final String? cfPassword;

  User({
    this.userId,
    this.name,
    this.account,
    this.password,
    this.cfPassword,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['_id'],
      account: json['account'],
    );
  }
}

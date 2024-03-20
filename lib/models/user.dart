class UserDetail{
  final num number;
  final String username;
  final String password;
  final String email;


  UserDetail(this.number, this.username, this.password, this.email);

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'username': username,
      'password': password,
      'email': email,
    };
  }

  static UserDetail fromJson(Map<String, dynamic> json) => UserDetail(
    json['number'] ,
    json['username'],
    json['password'],
    json['email'],
  );

}

class User {
  String token;
  String name;
  int color;

  User(this.token, this.name, this.color);

  User.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    name = json['name'];
    color = json['color'];
  }

}
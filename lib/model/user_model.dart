class User {
  String name;
  String email;
  String imageUrl;
  User({
    required this.name,
    required this.email,
    required this.imageUrl,
  });
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map["name"]["first"] + " " + map["name"]["last"],
      email: map["email"],
      imageUrl: map["picture"]["large"],
    );
  }
}

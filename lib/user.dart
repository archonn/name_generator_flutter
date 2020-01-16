class User {
  final String name;
  final String gender;
  final String nat;
  final String photo;

  User({this.name, this.gender, this.nat, this.photo});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: "${json['name']['title']} ${json['name']['first']} ${json['name']['last']}",
      gender: json['gender'],
      nat: json['nat'],
      photo: json['picture']['large']
    );
  }
}
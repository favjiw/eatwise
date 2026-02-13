class UserModel {
  int? id;
  String? name;
  String? email;
  int? age;
  String? gender;
  double? height;
  double? weight;
  List<String>? allergies;
  bool isOnboarded;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.age,
    this.gender,
    this.height,
    this.weight,
    this.allergies,
    this.isOnboarded = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    age: json['age'],
    gender: json['gender'],
    height: json['height'] != null ? double.parse(json['height'].toString()) : null,
    weight: json['weight'] != null ? double.parse(json['weight'].toString()) : null,
    allergies: json['allergies'] != null ? List<String>.from(json['allergies']) : [],
    isOnboarded: json['is_onboarded'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "age": age,
    "gender": gender,
    "height": height,
    "weight": weight,
    "allergies": allergies,
    "is_onboarded": isOnboarded,
  };
}
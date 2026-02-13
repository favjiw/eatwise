class FoodModel {
  int? id;
  String? name;
  String? barcode;
  String? ingredients;
  double? servingSize;
  double? calories;
  double? carbs;
  double? protein;
  double? fat;

  FoodModel({
    this.id,
    this.name,
    this.barcode,
    this.ingredients,
    this.servingSize,
    this.calories,
    this.carbs,
    this.protein,
    this.fat,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel(
    id: json['id'],
    name: json['name'],
    barcode: json['barcode'],
    ingredients: json['ingredients'],
    servingSize: json['serving_size'] != null ? double.parse(json['serving_size'].toString()) : 0.0,
    calories: json['calories'] != null ? double.parse(json['calories'].toString()) : 0.0,
    carbs: json['carbs'] != null ? double.parse(json['carbs'].toString()) : 0.0,
    protein: json['protein'] != null ? double.parse(json['protein'].toString()) : 0.0,
    fat: json['fat'] != null ? double.parse(json['fat'].toString()) : 0.0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "barcode": barcode,
    "ingredients": ingredients,
    "serving_size": servingSize,
    "calories": calories,
    "carbs": carbs,
    "protein": protein,
    "fat": fat,
  };
}
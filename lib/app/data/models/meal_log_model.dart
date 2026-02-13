import 'package:eatwise/app/data/models/food_model.dart';

class MealLogModel {
  int? id;
  int? userId;
  int? foodId;
  String? mealType;
  double? portion;
  String? date;
  FoodModel? food;

  MealLogModel({
    this.id,
    this.userId,
    this.foodId,
    this.mealType,
    this.portion,
    this.date,
    this.food,
  });

  factory MealLogModel.fromJson(Map<String, dynamic> json) => MealLogModel(
    id: json['id'],
    userId: json['user_id'],
    foodId: json['food_id'],
    mealType: json['meal_type'],
    portion: json['portion'] != null ? double.parse(json['portion'].toString()) : 1.0,
    date: json['date'],
    food: json['food'] != null ? FoodModel.fromJson(json['food']) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "food_id": foodId,
    "meal_type": mealType,
    "portion": portion,
    "date": date,
  };
}
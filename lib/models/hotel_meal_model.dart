class hotel_meal {
  int id;
  String hotel_reservation_id;
  String insert_time;
  String meal_id;
  String meal_name;
  String amount;
  
  hotel_meal({required this.id, required this.hotel_reservation_id, required this.insert_time, required this.meal_id,required this.meal_name, required this.amount});

  factory hotel_meal.fromJson(Map<String, dynamic> json) {
    return hotel_meal(
      id: json['id'],
      hotel_reservation_id: json['hotel_reservation_id'],
      insert_time: json['insert_time'],
      meal_id: json['meal_id'],
      meal_name: json['meal_name'],
      amount: json['amount'],
    );
  }
}




class Ui_hotel_meal {

  List<Map> hotel_meal_names;


  Ui_hotel_meal({required this.hotel_meal_names});

  factory Ui_hotel_meal.fromJson(Map json) {
  
    var listMeal = json['hotel_meal_names'] as List ?? [];
    List<Map> mealList = listMeal.map((i) => i as Map).toList();

    return Ui_hotel_meal(
      hotel_meal_names: mealList,
    );
  }

  
  
}








class hotel_roomType {
  int id;
  String hotel_reservation_id;
  String insert_time;
  String roomType_id;
  String roomType_name;
  String amount;
  
  hotel_roomType({required this.id, required this.hotel_reservation_id, required this.insert_time, required this.roomType_id,required this.roomType_name, required this.amount});

  factory hotel_roomType.fromJson(Map<String, dynamic> json) {
    return hotel_roomType(
      id: json['id'],
      hotel_reservation_id: json['hotel_reservation_id'],
      insert_time: json['insert_time'],
      roomType_id: json['roomType_id'],
      roomType_name: json['roomType_name'],
      amount: json['amount'],
    );
  }
}




class Ui_hotel_roomType {

  List<Map> hotel_roomType_names;


  Ui_hotel_roomType({required this.hotel_roomType_names});

  factory Ui_hotel_roomType.fromJson(Map json) {
  
    var listroomType = json['hotel_roomType_names'] as List ?? [];
    List<Map> roomTypeList = listroomType.map((i) => i as Map).toList();

    return Ui_hotel_roomType(
      hotel_roomType_names: roomTypeList,
    );
  }

  
  
}








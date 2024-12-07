class hotel_reservation {
  int id;
  String capacity;
  String insert_time;
  String booking_date;
  String reply_msg;
  String status;
  String hotel_name;
  
  hotel_reservation({required this.id, required this.capacity, required this.insert_time, required this.booking_date, required this.reply_msg, required this.hotel_name, required this.status});

  factory hotel_reservation.fromJson(Map<String, dynamic> json) {
    return hotel_reservation(
      id: json['id'],
      capacity: json['capacity'],
      insert_time: json['insert_time'],
      booking_date: json['booking_date'],
      reply_msg: json['reply_msg'],
      hotel_name: json['hotel_name'],
      status: json['status'],
    );
  }
}




class Ui_hotel_reservation {

  List<Map> hotel_names;


  Ui_hotel_reservation({required this.hotel_names});

  factory Ui_hotel_reservation.fromJson(Map json) {
  
    var listFacility = json['hotel_names'] as List ?? [];
    List<Map> hotelList = listFacility.map((i) => i as Map).toList();

    return Ui_hotel_reservation(
      hotel_names: hotelList,
    );
  }

  
  
}








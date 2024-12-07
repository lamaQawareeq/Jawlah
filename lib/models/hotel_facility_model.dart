class hotel_facility {
  int id;
  String hotel_reservation_id;
  String insert_time;
  String facility_id;
  String facility_name;
  String amount;
  
  hotel_facility({required this.id, required this.hotel_reservation_id, required this.insert_time, required this.facility_id,required this.facility_name, required this.amount});

  factory hotel_facility.fromJson(Map<String, dynamic> json) {
    return hotel_facility(
      id: json['id'],
      hotel_reservation_id: json['hotel_reservation_id'],
      insert_time: json['insert_time'],
      facility_id: json['facility_id'],
      facility_name: json['facility_name'],
      amount: json['amount'],
    );
  }
}




class Ui_hotel_facility {

  List<Map> hotel_facility_names;


  Ui_hotel_facility({required this.hotel_facility_names});

  factory Ui_hotel_facility.fromJson(Map json) {
  
    var listfacility = json['hotel_facility_names'] as List ?? [];
    List<Map> facilityList = listfacility.map((i) => i as Map).toList();

    return Ui_hotel_facility(
      hotel_facility_names: facilityList,
    );
  }

  
  
}








class TaxiOfficeDriver {
  int id;
  String name;
  String phone;
  String img;

    
  TaxiOfficeDriver({required this.id, required this.name, required this.phone, required this.img});

  factory TaxiOfficeDriver.fromJson(Map<String, dynamic> json) {
    return TaxiOfficeDriver(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      img: json['img']
    );
  }

}

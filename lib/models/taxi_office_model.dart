class TaxiOffice {
  int id;
  String name;
  
  TaxiOffice({required this.id, required this.name});

  factory TaxiOffice.fromJson(Map<String, dynamic> json) {
    return TaxiOffice(
      id: json['id'],
      name: json['name'],
    );
  }
}



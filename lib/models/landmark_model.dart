class Landmark {
  int id;
  String name;
  String img;
  double latitude;
  double longitude;
  
  Landmark({required this.id, required this.name, required this.img, required this.latitude, required this.longitude});

  factory Landmark.fromJson(Map<String, dynamic> json) {
    return Landmark(
      id: json['id'],
      name: json['name'],
      img: json['img'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }
}



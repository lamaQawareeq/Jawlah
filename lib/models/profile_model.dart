class ProfileModel {
  String fname;
  String lname;
  String surname;
  String phone;
  String birthdate;
  String loginname;
  String img;
  int country_id;

  int gender_id;
  List<Map> country;

  ProfileModel(
      {required this.fname,
      required this.lname,
      required this.surname,
      required this.phone,
      required this.birthdate,
      required this.loginname,
      required this.img,
      required this.country_id,
      required this.gender_id,
      required this.country});

  factory ProfileModel.fromJson(Map json) {
    var listresidenceRegion = json['country'] as List ?? [];
    List<Map> countryList = listresidenceRegion.map((i) => i as Map).toList();

    return ProfileModel(
      fname: json['fname'],
      lname: json['lname'],
      surname: json['surname'],
      phone: json['phone'],
      birthdate: json['birthdate'],
      loginname: json['loginname'],
      img: json['img'],
      country_id: json['country_id'],
      gender_id: json['gender_id'],
      country: countryList,
    );
  }

  set set_gender_id(int? gender) {
    gender_id = gender!;
  }
}

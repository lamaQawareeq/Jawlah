class TaxiOfficeEvaluation {
  int id;
  String name;
  int votes_count;
  bool is_checked;

  TaxiOfficeEvaluation(
      {required this.id,
      required this.name,
      required this.votes_count,
      required this.is_checked});

  factory TaxiOfficeEvaluation.fromJson(Map<String, dynamic> json) {
    return TaxiOfficeEvaluation(
      id: json['id'],
      name: json['name'],
      votes_count: json['votes_count'],
      is_checked: json['is_checked'],
    );
  }

  set set_is_checked(bool isCheck) {
    is_checked = isCheck;
  }
}

class taxi_request {
  int id;
  String passengers_num;
  String insert_time;
  String datetime_desired;
  String reply_msg;
  String status;
  
  taxi_request({required this.id, required this.passengers_num, required this.insert_time, required this.datetime_desired, required this.reply_msg, required this.status});

  factory taxi_request.fromJson(Map<String, dynamic> json) {
    return taxi_request(
      id: json['id'],
      passengers_num: json['passengers_num'],
      insert_time: json['insert_time'],
      datetime_desired: json['datetime_desired'],
      reply_msg: json['reply_msg'],
      status: json['status'],
    );
  }
}



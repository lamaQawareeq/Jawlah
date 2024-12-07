class SosHelp {
  int id;
  String title;
  String insert_time;
  String content;
  String reply_msg;
  String status;
  
  SosHelp({required this.id, required this.title, required this.insert_time, required this.content, required this.reply_msg, required this.status});

  factory SosHelp.fromJson(Map<String, dynamic> json) {
    return SosHelp(
      id: json['id'],
      title: json['title'],
      insert_time: json['insert_time'],
      content: json['content'],
      reply_msg: json['reply_msg'],
      status: json['status'],
    );
  }
}



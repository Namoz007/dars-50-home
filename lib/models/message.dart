class Message {
  String sendUser;
  String message;
  DateTime date;

  Message({
    required this.sendUser,
    required this.message,
    required this.date,
  });

  factory Message.fromJson(Map<String,dynamic> mp){
    return Message(
      sendUser: mp['sendUser'],
      message: mp['message'],
      date: DateTime.parse(mp['date']),
    );
  }

}

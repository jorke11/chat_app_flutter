class Message {
    Message({
        this.from,
        this.to,
        this.message,
        this.createdAt,
        this.updateAt,
    });

    String from;
    String to;
    String message;
    String createdAt;
    String updateAt;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        from: json["from"],
        to: json["to"],
        message: json["message"],
        createdAt: json["createdAt"],
        updateAt: json["updateAt"],
    );

    Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
        "message": message,
        "createdAt": createdAt,
        "updateAt": updateAt,
    };
}
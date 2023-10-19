import 'dart:convert';

Sakura sakuraFromJson(String str) => Sakura.fromJson(json.decode(str));

String sakuraToJson(Sakura data) => json.encode(data.toJson());

class Sakura {
  Sakura({
    this.messageId,
    this.senderId,
    this.category,
    this.collapseKey,
    this.contentAvailable,
    required this.data,
    this.from,
    this.sentTime,
    this.threadId,
    this.ttl,
    required this.notificatioon,
  });

  String? messageId;
  String? senderId;
  String? category;
  String? collapseKey;
  bool? contentAvailable;
  Data data;
  String? from;
  DateTime? sentTime;
  String? threadId;
  int? ttl;
  Notificatioon notificatioon;

  factory Sakura.fromJson(Map<String, dynamic> json) => Sakura(
        messageId: json["messageId"],
        senderId: json["senderId"],
        category: json["category"],
        collapseKey: json["collapseKey"],
        contentAvailable: json["contentAvailable"],
        data: Data.fromJson(json["data"]),
        from: json["from"],
        // sentTime: json["sentTime"],
        sentTime: DateTime.parse(json["sentTime"]),
        threadId: json["threadId"],
        ttl: json["ttl"],
        notificatioon: Notificatioon.fromJson(json["notificatioon"]),
      );

  Map<String, dynamic> toJson() => {
        "messageId": messageId,
        "senderId": senderId,
        "category": category,
        "collapseKey": collapseKey,
        "contentAvailable": contentAvailable,
        "data": data.toJson(),
        "from": from,
        // "sentTime": sentTime,
        "sentTime":
            "${sentTime?.year.toString().padLeft(4, '0')}-${sentTime?.month.toString().padLeft(2, '0')}-${sentTime?.day.toString().padLeft(2, '0')}",
        "threadId": threadId,
        "ttl": ttl,
        "notificatioon": notificatioon.toJson(),
      };
}

class Data {
  Data({
    this.via,
    this.count,
    this.route,
  });

  String? via;
  String? count;
  String? route;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        via: json["via"],
        count: json["count"],
        route: json["route"],
      );

  Map<String, dynamic> toJson() => {
        "via": via,
        "count": count,
        "route": route,
      };
}

class Notificatioon {
  Notificatioon({
    this.title,
    this.body,
  });

  String? title;
  String? body;

  factory Notificatioon.fromJson(Map<String, dynamic> json) => Notificatioon(
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
      };
}

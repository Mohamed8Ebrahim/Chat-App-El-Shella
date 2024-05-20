class ChatUsers {
  String? about;
  String? createdAt;
  String? email;
  String? id;
  String? image;
  bool? isOnline;
  String? lastActive;
  String? name;
  String? pushToken;

  ChatUsers({
    this.about,
    this.createdAt,
    this.email,
    this.id,
    this.image,
    this.isOnline,
    this.lastActive,
    this.name,
    this.pushToken,
  });

  factory ChatUsers.fromJson(Map<String, dynamic> json) => ChatUsers(
        about: json['about'] as String?,
        createdAt: json['created At'] as String?,
        email: json['email'] as String?,
        id: json['id'] as String?,
        image: json['image'] as String?,
        isOnline: json['is_online'] as bool?,
        lastActive: json['last_active'] as String?,
        name: json['name'] as String?,
        pushToken: json['push_token'] as String?,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['about'] = about;
    data['created At'] = createdAt;
    data['email'] = email;
    data['id'] = id;
    data['image'] = image;
    data['is_online'] = isOnline;
    data['last_active'] = lastActive;
    data['name'] = name;
    data['push_token'] = pushToken;
    return data;
  }
}

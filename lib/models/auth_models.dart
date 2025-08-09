class OAuthResponse {
  final String message;
  final UserInfo user;
  final String token;
  final int exp;

  OAuthResponse({
    required this.message,
    required this.user,
    required this.token,
    required this.exp,
  });

  factory OAuthResponse.fromJson(Map<String, dynamic> json) {
    return OAuthResponse(
      message: (json['message'] ?? '').toString(),
      user: UserInfo.fromJson(json['user'] ?? {}),
      token: (json['token'] ?? '').toString(),
      exp: json['exp'] is int
          ? json['exp'] as int
          : int.tryParse(json['exp']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user.toJson(),
      'token': token,
      'exp': exp,
    };
  }
}

class UserInfo {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String role;
  final String? googleId;
  final bool isVerify;
  final String createdAt;
  final String updatedAt;

  UserInfo({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.role,
    this.googleId,
    required this.isVerify,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      role: json['role'] ?? 'user',
      googleId: json['googleId'],
      isVerify: json['isVerify'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'role': role,
      'googleId': googleId,
      'isVerify': isVerify,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class OAuthRequest {
  final String tokenId;
  final String provider;

  OAuthRequest({required this.tokenId, required this.provider});

  Map<String, dynamic> toJson() {
    return {'tokenId': tokenId, 'provider': provider};
  }
}

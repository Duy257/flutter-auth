class OAuthResponse {
  final bool success;
  final UserInfo user;
  final String accessToken;
  final String refreshToken;

  OAuthResponse({
    required this.success,
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory OAuthResponse.fromJson(Map<String, dynamic> json) {
    return OAuthResponse(
      success: json['success'] ?? false,
      user: UserInfo.fromJson(json['user']),
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'user': user.toJson(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}

class UserInfo {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String role;

  UserInfo({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.role,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'role': role,
    };
  }
}

class OAuthRequest {
  final String tokenId;
  final String provider;

  OAuthRequest({
    required this.tokenId,
    required this.provider,
  });

  Map<String, dynamic> toJson() {
    return {
      'tokenId': tokenId,
      'provider': provider,
    };
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  int? id;
  String? email;
  String? password;
  String? registerType;
  String? iosToken;
  String? androidToken;
  String? refreshToken;
  String? socialKey;
  String? imageAvatar;
  int? supplierID;

  User({
      this.id,
      this.email,
      this.password,
      this.registerType,
      this.iosToken,
      this.androidToken,
      this.refreshToken,
      this.socialKey,
      this.imageAvatar,
      this.supplierID});

  User copyWith({
    int? id,
    String? email,
    String? password,
    String? registerType,
    String? iosToken,
    String? androidToken,
    String? refreshToken,
    String? socialKey,
    String? imageAvatar,
    int? supplierID,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      registerType: registerType ?? this.registerType,
      iosToken: iosToken ?? this.iosToken,
      androidToken: androidToken ?? this.androidToken,
      refreshToken: refreshToken ?? this.refreshToken,
      socialKey: socialKey ?? this.socialKey,
      imageAvatar: imageAvatar ?? this.imageAvatar,
      supplierID: supplierID ?? this.supplierID,
    );
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.email == email &&
      other.password == password &&
      other.registerType == registerType &&
      other.iosToken == iosToken &&
      other.androidToken == androidToken &&
      other.refreshToken == refreshToken &&
      other.socialKey == socialKey &&
      other.imageAvatar == imageAvatar &&
      other.supplierID == supplierID;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      email.hashCode ^
      password.hashCode ^
      registerType.hashCode ^
      iosToken.hashCode ^
      androidToken.hashCode ^
      refreshToken.hashCode ^
      socialKey.hashCode ^
      imageAvatar.hashCode ^
      supplierID.hashCode;
  }
}

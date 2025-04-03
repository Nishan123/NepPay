import 'dart:convert';

class UserModel {
  String uid;
  String userName;
  String gmail;
  double availableBalance;
  UserModel({
    required this.uid,
    required this.userName,
    required this.gmail,
    required this.availableBalance,
  });

  UserModel copyWith({
    String? uid,
    String? userName,
    String? gmail,
    double? availableBalance,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      userName: userName ?? this.userName,
      gmail: gmail ?? this.gmail,
      availableBalance: availableBalance ?? this.availableBalance,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'userName': userName,
      'gmail': gmail,
      'availableBalance': availableBalance,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid']?.toString() ?? '',
      userName: map['userName']?.toString() ?? '',
      gmail: map['gmail']?.toString() ?? '',
      availableBalance: (map['availableBalance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(uid: $uid, userName: $userName, gmail: $gmail, availableBalance: $availableBalance)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.userName == userName &&
        other.gmail == gmail &&
        other.availableBalance == availableBalance;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        userName.hashCode ^
        gmail.hashCode ^
        availableBalance.hashCode;
  }
}

import 'dart:convert';

class User {
  String uid;
  String userName;
  String gmail;
  double availableBalance;
  User({
    required this.uid,
    required this.userName,
    required this.gmail,
    required this.availableBalance,
  });

  User copyWith({
    String? uid,
    String? userName,
    String? gmail,
    double? availableBalance,
  }) {
    return User(
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

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid']?.toString() ?? '',
      userName: map['userName']?.toString() ?? '',
      gmail: map['gmail']?.toString() ?? '',
      availableBalance: (map['availableBalance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(uid: $uid, userName: $userName, gmail: $gmail, availableBalance: $availableBalance)';
  }

  @override
  bool operator ==(covariant User other) {
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

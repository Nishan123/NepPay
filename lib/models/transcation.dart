import 'dart:convert';

class Transcation {
  String transactionId;
  String senderUid;
  String reciverUid;
  double amount;
  Transcation({
    required this.transactionId,
    required this.senderUid,
    required this.reciverUid,
    required this.amount,
  });

  Transcation copyWith({
    String? transactionId,
    String? senderUid,
    String? reciverUid,
    double? amount,
  }) {
    return Transcation(
      transactionId: transactionId ?? this.transactionId,
      senderUid: senderUid ?? this.senderUid,
      reciverUid: reciverUid ?? this.reciverUid,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transactionId': transactionId,
      'senderUid': senderUid,
      'reciverUid': reciverUid,
      'amount': amount,
    };
  }

  factory Transcation.fromMap(Map<String, dynamic> map) {
    return Transcation(
      transactionId: map['transactionId'] as String,
      senderUid: map['senderUid'] as String,
      reciverUid: map['reciverUid'] as String,
      amount: map['amount'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Transcation.fromJson(String source) =>
      Transcation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Transcation(transactionId: $transactionId, senderUid: $senderUid, reciverUid: $reciverUid, amount: $amount)';
  }

  @override
  bool operator ==(covariant Transcation other) {
    if (identical(this, other)) return true;

    return other.transactionId == transactionId &&
        other.senderUid == senderUid &&
        other.reciverUid == reciverUid &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    return transactionId.hashCode ^
        senderUid.hashCode ^
        reciverUid.hashCode ^
        amount.hashCode;
  }
}

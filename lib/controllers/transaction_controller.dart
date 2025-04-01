import 'package:flutter/rendering.dart';
import 'package:nep_pay/models/transcation.dart';
import 'package:random_string/random_string.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionController {
  Future<void> makeTranscation(Transcation transaction) async {
    try {
      await Supabase.instance.client
          .from("transactions")
          .insert(transaction.toMap());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> sendMoney(double amount, String reciverUid) async {
    try {
      final senderData =
          await Supabase.instance.client
              .from("users")
              .select('availableBalance')
              .eq("uid", Supabase.instance.client.auth.currentUser!.id)
              .single();

      final receiverData =
          await Supabase.instance.client
              .from("users")
              .select('availableBalance')
              .eq("uid", reciverUid)
              .single();

      final double avalibleAmountOfSender =
          (senderData['availableBalance'] as num).toDouble();
      final double avalibleAmountOfReceiver =
          (receiverData['availableBalance'] as num).toDouble();

      if (avalibleAmountOfSender < amount) {
        debugPrint("Not enough balance");
      } else {
        await Supabase.instance.client
            .from("users")
            .update({"availableBalance": avalibleAmountOfSender - amount})
            .eq("uid", Supabase.instance.client.auth.currentUser!.id);

        await Supabase.instance.client
            .from("users")
            .update({"availableBalance": avalibleAmountOfReceiver + amount})
            .eq("uid", reciverUid);

        String id = randomAlphaNumeric(6);
        final transaction = Transcation(
          transactionId: id,
          reciverUid: reciverUid,
          amount: amount,
          senderUid: Supabase.instance.client.auth.currentUser!.id,
        );
        makeTranscation(transaction);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

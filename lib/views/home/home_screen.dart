import 'package:flutter/material.dart';
import 'package:nep_pay/controllers/auth_controller.dart';
import 'package:nep_pay/controllers/transaction_controller.dart';
import 'package:nep_pay/controllers/user_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Move controllers outside build method
  static final TextEditingController uidController = TextEditingController();
  static final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    final String? username = user?.userMetadata?['full_name'];
    final String? email = user?.email;
    final String? profilePicUrl = user?.userMetadata?['avatar_url'];
    final String uid = user!.id.toString();

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  // Wrap with SingleChildScrollView
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Divider(
                          color: Colors.black26,
                          thickness: 4,
                          endIndent: 80,
                          indent: 80,
                        ),
                        SizedBox(height: 16),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: uidController,
                              decoration: InputDecoration(hintText: "UID"),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: amountController,
                              decoration: InputDecoration(hintText: "Amount"),
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                // String id = randomAlphaNumeric(6);
                                // final transaction = Transcation(
                                //   transactionId: id,
                                //   reciverUid: uidController.text.toString(),
                                //   senderUid: uid,
                                //   amount: double.parse(amountController.text),
                                // );
                                // TransactionController().makeTranscation(
                                //   transaction,
                                // );

                                TransactionController().sendMoney(
                                  double.parse(amountController.text),
                                  uidController.text,
                                );
                                Navigator.pop(context);
                              },
                              child: Text("Send money"),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        label: Text("Make a Transaction."),
      ),
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  profilePicUrl != null
                      ? NetworkImage(profilePicUrl)
                      : NetworkImage(
                            "https://as1.ftcdn.net/v2/jpg/07/95/95/14/1000_f_795951406_h17eywwio36du2l8jxtsucexqpescbuq.jpg",
                          )
                          as ImageProvider,
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username ?? "Not Available",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  email ?? "Not Available",
                  style: TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              AuthController().logOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder(
                stream: UserController().streamUserInfo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.hasData) {
                    final userData = snapshot.data!;
                    return Text(
                      "Available balance: ${userData.availableBalance}",
                      style: Theme.of(context).textTheme.titleLarge,
                    );
                  }

                  return Text('No data available');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nep_pay/controllers/auth_controller.dart';
import 'package:nep_pay/controllers/transaction_controller.dart';
import 'package:nep_pay/controllers/user_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  // Move controllers outside build method
  static final TextEditingController uidController = TextEditingController();
  static final TextEditingController amountController = TextEditingController();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    final String? username = user?.userMetadata?['full_name'];
    final String? email = user?.email;
    final String? profilePicUrl = user?.userMetadata?['avatar_url'];
    String reciverUid = "";

    // final String uid = user!.id.toString();

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
              return DefaultTabController(
                length: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TabBar(tabs: [Tab(text: "Scan QR"), Tab(text: "Share QR")]),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 600,
                      child: TabBarView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 300,
                                    child: MobileScanner(
                                      onDetect: (capture) {
                                        final List<Barcode> barcodes =
                                            capture.barcodes;
                                        for (final barcode in barcodes) {
                                          setState(() {
                                            reciverUid = barcode.rawValue ?? '';
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 20),

                                  reciverUid.isEmpty
                                      ? SizedBox()
                                      : Text("user id: ${reciverUid}"),
                                  SizedBox(height: 20),
                                  TextField(
                                    controller: HomeScreen.amountController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Amount',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.money),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      TransactionController().sendMoney(
                                        double.parse(
                                          HomeScreen.amountController.text
                                              .toString(),
                                        ),
                                        reciverUid,
                                      );
                                    },
                                    child: Text('Send Payment'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Text("My QR"),
                              SizedBox(height: 40),
                              QrImageView(
                                data:
                                    Supabase
                                        .instance
                                        .client
                                        .auth
                                        .currentUser!
                                        .id
                                        .toString(),
                                version: QrVersions.auto,
                                size: 200.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
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

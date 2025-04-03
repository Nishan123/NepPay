import 'package:supabase_flutter/supabase_flutter.dart' as spb;
import 'package:nep_pay/models/user_model.dart';

class UserController {
  Stream<UserModel> streamUserInfo() {
    final supabase = spb.Supabase.instance.client;
    final currentUser = supabase.auth.currentUser;

    if (currentUser != null) {
      return supabase
          .from('users')
          .stream(primaryKey: ['id'])
          .eq('uid', currentUser.id)
          .map((event) => UserModel.fromMap(event.first));
    } else {
      throw Exception('No user logged in');
    }
  }
}

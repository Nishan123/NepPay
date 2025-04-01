import 'package:supabase_flutter/supabase_flutter.dart' as spb;
import 'package:nep_pay/models/user.dart';

class UserController {

  Stream<User> streamUserInfo() {
    final supabase = spb.Supabase.instance.client;
    final currentUser = supabase.auth.currentUser;

    if (currentUser != null) {
      return supabase
          .from('users')
          .stream(primaryKey: ['id'])
          .eq('uid', currentUser.id)
          .map((event) => User.fromMap(event.first));
    } else {
      throw Exception('No user logged in');
    }
  }
}

import 'package:chess_app_flutter/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class UserService {
  Future<UserModel?> createUser(String name);
  Future<UserModel?> getUser(String name);
}

class UserServiceImplement extends UserService {
  Supabase _supabase = Supabase.instance;
  @override
  Future<UserModel?> createUser(String name) async {
    try {
      List<dynamic> result =
          await _supabase.client.from("user").insert({"name": name}).select();
      if (result.isEmpty) {
        return null;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', UserModel.fromJson(result[0]).name);
      return UserModel.fromJson(result[0]);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserModel?> getUser(String name) async {
    try {
      List<dynamic> result =
          await _supabase.client.from("user").select().eq('name', name);
      if (result.isEmpty) {
        return null;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', UserModel.fromJson(result[0]).name);
      return UserModel.fromJson(result[0]);
    } catch (e) {
      return null;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:the_dream_notice_board/data/storage/token_storage.dart';

class ProfileViewModel extends ChangeNotifier {
  String? username;
  String? name;
  bool isLoading = true;

  ProfileViewModel() {
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final token = await TokenStorage.getAccessToken();
    if (token != null) {
      final decoded = JwtDecoder.decode(token);
      username = decoded['username'];
      name = decoded['name'];
    }
    isLoading = false;
    notifyListeners();
  }
}
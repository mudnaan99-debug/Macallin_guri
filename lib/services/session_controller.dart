import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/api_config.dart';
import '../models/user_model.dart';

const _kAccess = 'jwt_access';
const _kRefresh = 'jwt_refresh';

/// Authentication via Django JWT + `/api/me/`. Replaces Firebase for login flow.
class SessionController extends ChangeNotifier {
  SessionController() : _dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  UserModel? _user;
  bool _bootstrapping = true;

  UserModel? get currentUser => _user;
  bool get isLoggedIn => _user != null;
  bool get isBootstrapping => _bootstrapping;

  /// Legacy helper — returns cached profile when id matches.
  Future<UserModel?> getUserData(String uid) async {
    if (_user != null && _user!.id == uid) return _user;
    return _user;
  }

  Future<void> init() async {
    _bootstrapping = true;
    notifyListeners();
    try {
      final access = await _storage.read(key: _kAccess);
      if (access != null) {
        _dio.options.headers['Authorization'] = 'Bearer $access';
        final res = await _dio.get<Map<String, dynamic>>('/api/me/');
        _user = UserModel.fromApiJson(res.data!);
      }
    } catch (e, st) {
      debugPrint('Session init: $e\n$st');
      await _clearTokens();
      _user = null;
    }
    _bootstrapping = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/auth/token/',
        data: {
          'username': email.trim(),
          'password': password,
        },
      );
      final data = res.data!;
      await _storage.write(key: _kAccess, value: data['access'] as String);
      await _storage.write(key: _kRefresh, value: data['refresh'] as String);
      _dio.options.headers['Authorization'] = 'Bearer ${data['access']}';
      final me = await _dio.get<Map<String, dynamic>>('/api/me/');
      _user = UserModel.fromApiJson(me.data!);
      notifyListeners();
      return true;
    } on DioException catch (e) {
      debugPrint('Login error: ${e.response?.data ?? e.message}');
      return false;
    }
  }

  Future<void> signOut() async {
    await _clearTokens();
    _user = null;
    _dio.options.headers.remove('Authorization');
    notifyListeners();
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
  }
}

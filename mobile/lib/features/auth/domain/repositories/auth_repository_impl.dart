import 'package:uts_apps_market_1123150112/core/constants/api_constants.dart';
import 'package:uts_apps_market_1123150112/core/services/dio_client.dart';
import 'package:uts_apps_market_1123150112/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<String> verifyFirebaseToken(String firebaseToken) async {
    final response = await DioClient.instance.post(
      ApiConstants.verifyToken,
      data: {'firebase_token': firebaseToken},
    );

    final data = response.data['data'] as Map<String, dynamic>;
    return data['access_token'] as String;
  }
}

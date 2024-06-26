import '../../../application/helpers/request_mapping.dart';

class UserConfirmInputModel extends RequestMapping{
  int userId;
  String accessToken;
  late String iosDeviceToken;
  late String androidDeviceToken;

  UserConfirmInputModel({
    required this.userId,
    required this.accessToken,
    required String data,
  }) : super(data);

  @override
  void map() {
    iosDeviceToken = data['ios_token'];
    androidDeviceToken = data['android_token'];
  }
}

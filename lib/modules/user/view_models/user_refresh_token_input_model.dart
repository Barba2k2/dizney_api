import '../../../application/helpers/request_mapping.dart';

class UserRefreshTokenInputModel extends RequestMapping {
  int user;
  int? supplier;
  String accessToken;
  late String refreshToken;

  UserRefreshTokenInputModel({
    required this.user,
    required this.accessToken,
    this.supplier,
    required String dataRequest,
  }) : super(dataRequest);

  @override
  void map() {
    refreshToken = data['refresh_token'];
  }
}

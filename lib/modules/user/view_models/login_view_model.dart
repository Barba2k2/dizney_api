import '../../../application/helpers/request_mapping.dart';

class LoginViewModel extends RequestMapping {
  late String login;
  late String password;

  LoginViewModel(String dataRequest) : super(dataRequest);

  @override
  void map() {
    login = data['login'];
    password = data['password'];
  }
}

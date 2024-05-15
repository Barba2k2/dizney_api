import '../../../application/helpers/request_mapping.dart';

class LoginViewModel extends RequestMapping {
  late String username; 
  late String email; 
  late String password;
  late String avatar; 

  LoginViewModel(String dataRequest) : super(dataRequest);

  @override
  void map() {
    username = data['username'] ?? ''; 
    email = data['email'] ?? ''; 
    password = data['password'];
    avatar = data['avatar'];
  }
}

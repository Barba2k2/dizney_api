import '../../../application/helpers/request_mapping.dart';

class UserSaveInputModel extends RequestMapping {
  late String firstname;
  late String lastname;
  late String username;
  late String email;
  late String password;
  String? countryCode;
  String? phoneCode;
  String? phone;
  String? address;
  String? timezone;
  String? image;
  int? referralId;
  int? languageId;
  String? provider;
  String? providerId;
  int? status;
  int? identityVerify;
  int? addressVerify;
  int? twoFa;
  int? twoFaVerify;
  String? twoFaCode;
  int? emailVerification;
  int? smsVerification;
  String? verifyCode;

  UserSaveInputModel(String dataRequest) : super(dataRequest);

  @override
  void map() {
    firstname = data['firstname'] ?? '';
    lastname = data['lastname'] ?? '';
    username = data['username'] ?? '';
    email = data['email'];
    password = data['password'];
    countryCode = data['country_code'];
    phoneCode = data['phone_code'];
    phone = data['phone'];
    address = data['address'];
    timezone = data['timezone'];
    image = data['image'];
    referralId =
        data['referral_id'] != null ? int.tryParse(data['referral_id']) : null;
    languageId =
        data['language_id'] != null ? int.tryParse(data['language_id']) : null;
    provider = data['provider'];
    providerId = data['provider_id'];
    status = data['status'] != null ? int.tryParse(data['status']) : null;
    identityVerify = data['identity_verify'] != null
        ? int.tryParse(data['identity_verify'])
        : null;
    addressVerify = data['address_verify'] != null
        ? int.tryParse(data['address_verify'])
        : null;
    twoFa = data['two_fa'] != null ? int.tryParse(data['two_fa']) : null;
    twoFaVerify = data['two_fa_verify'] != null
        ? int.tryParse(data['two_fa_verify'])
        : null;
    twoFaCode = data['two_fa_code'];
    emailVerification = data['email_verification'] != null
        ? int.tryParse(data['email_verification'])
        : null;
    smsVerification = data['sms_verification'] != null
        ? int.tryParse(data['sms_verification'])
        : null;
    verifyCode = data['verify_code'];
  }
}

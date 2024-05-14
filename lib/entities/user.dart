class User {
  final int? id;
  final String? firstname;
  final String? lastname;
  final String? username;
  final int? referralId;
  final int? languageId;
  final String? email;
  final String? countryCode;
  final String? phoneCode;
  final String? phone;
  final String? timezone;
  final double? balance;
  final double? coinBalance;
  final String? image;
  final String? address;
  final String? provider;
  final String? providerId;
  final int? status;
  final int? identityVerify;
  final int? addressVerify;
  final int? twoFa;
  final int? twoFaVerify;
  final String? twoFaCode;
  final int? emailVerification;
  final int? smsVerification;
  final String? verifyCode;
  final DateTime? sentAt;
  final DateTime? lastLogin;
  final DateTime? lastSeen;
  final String? password;
  final DateTime? emailVerifiedAt;
  final String? rememberToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.referralId,
    this.languageId,
    this.email,
    this.countryCode,
    this.phoneCode,
    this.phone,
    this.timezone,
    this.balance,
    this.coinBalance,
    this.image,
    this.address,
    this.provider,
    this.providerId,
    this.status,
    this.identityVerify,
    this.addressVerify,
    this.twoFa,
    this.twoFaVerify,
    this.twoFaCode,
    this.emailVerification,
    this.smsVerification,
    this.verifyCode,
    this.sentAt,
    this.lastLogin,
    this.lastSeen,
    this.password,
    this.emailVerifiedAt,
    this.rememberToken,
    this.createdAt,
    this.updatedAt,
  });

  User copyWith({
    int? id,
    String? firstname,
    String? lastname,
    String? username,
    int? referralId,
    int? languageId,
    String? email,
    String? countryCode,
    String? phoneCode,
    String? phone,
    String? timezone,
    double? balance,
    double? coinBalance,
    String? image,
    String? address,
    String? provider,
    String? providerId,
    int? status,
    int? identityVerify,
    int? addressVerify,
    int? twoFa,
    int? twoFaVerify,
    String? twoFaCode,
    int? emailVerification,
    int? smsVerification,
    String? verifyCode,
    DateTime? sentAt,
    DateTime? lastLogin,
    DateTime? lastSeen,
    String? password,
    DateTime? emailVerifiedAt,
    String? rememberToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      username: username ?? this.username,
      referralId: referralId ?? this.referralId,
      languageId: languageId ?? this.languageId,
      email: email ?? this.email,
      countryCode: countryCode ?? this.countryCode,
      phoneCode: phoneCode ?? this.phoneCode,
      phone: phone ?? this.phone,
      timezone: timezone ?? this.timezone,
      balance: balance ?? this.balance,
      coinBalance: coinBalance ?? this.coinBalance,
      image: image ?? this.image,
      address: address ?? this.address,
      provider: provider ?? this.provider,
      providerId: providerId ?? this.providerId,
      status: status ?? this.status,
      identityVerify: identityVerify ?? this.identityVerify,
      addressVerify: addressVerify ?? this.addressVerify,
      twoFa: twoFa ?? this.twoFa,
      twoFaVerify: twoFaVerify ?? this.twoFaVerify,
      twoFaCode: twoFaCode ?? this.twoFaCode,
      emailVerification: emailVerification ?? this.emailVerification,
      smsVerification: smsVerification ?? this.smsVerification,
      verifyCode: verifyCode ?? this.verifyCode,
      sentAt: sentAt ?? this.sentAt,
      lastLogin: lastLogin ?? this.lastLogin,
      lastSeen: lastSeen ?? this.lastSeen,
      password: password ?? this.password,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      rememberToken: rememberToken ?? this.rememberToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class LoginJson {
  LoginJson({
    required this.token,
    required this.userData,
  });

  final String token;
  static const String tokenKey = "token";

  final UserData? userData;
  static const String userDataKey = "user_data";

  LoginJson copyWith({
    String? token,
    UserData? userData,
  }) {
    return LoginJson(
      token: token ?? this.token,
      userData: userData ?? this.userData,
    );
  }

  factory LoginJson.fromJson(Map<String, dynamic> json) {
    return LoginJson(
      token: json["token"] ?? "",
      userData: json["user_data"] == null
          ? null
          : UserData.fromJson(json["user_data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "token": token,
        "user_data": userData?.toJson(),
      };

  @override
  String toString() {
    return "$token, $userData, ";
  }
}

class UserData {
  UserData({
    required this.id,
    required this.isAgent,
    required this.isOnboarded,
    required this.picture,
    required this.isAdmin,
    required this.isSuperAdmin,
    required this.isCompany,
    required this.companyName,
    required this.companyWebsite,
    required this.industry,
    required this.inviteCode,
    required this.location,
    required this.sub,
    required this.email,
    required this.stripeCustomerId,
    required this.name,
    required this.title,
    required this.age,
    required this.gender,
    required this.category,
    required this.purpose,
    required this.stage,
    required this.revenue,
    required this.mode,
  });

  final int id;
  static const String idKey = "id";

  final bool isAgent;
  static const String isAgentKey = "is_agent";

  final bool isOnboarded;
  static const String isOnboardedKey = "is_onboarded";

  final String picture;
  static const String pictureKey = "picture";

  final bool isAdmin;
  static const String isAdminKey = "is_admin";

  final bool isSuperAdmin;
  static const String isSuperAdminKey = "is_super_admin";

  final bool isCompany;
  static const String isCompanyKey = "is_company";

  final String companyName;
  static const String companyNameKey = "company_name";

  final String companyWebsite;
  static const String companyWebsiteKey = "company_website";

  final String industry;
  static const String industryKey = "industry";

  final String inviteCode;
  static const String inviteCodeKey = "invite_code";

  final String location;
  static const String locationKey = "location";

  final String sub;
  static const String subKey = "sub";

  final String email;
  static const String emailKey = "email";

  final dynamic stripeCustomerId;
  static const String stripeCustomerIdKey = "stripe_customer_id";

  final String name;
  static const String nameKey = "name";

  final String title;
  static const String titleKey = "title";

  final String age;
  static const String ageKey = "age";

  final String gender;
  static const String genderKey = "gender";

  final String category;
  static const String categoryKey = "category";

  final String purpose;
  static const String purposeKey = "purpose";

  final String stage;
  static const String stageKey = "stage";

  final String revenue;
  static const String revenueKey = "revenue";

  final String mode;
  static const String modeKey = "mode";

  UserData copyWith({
    int? id,
    bool? isAgent,
    bool? isOnboarded,
    String? picture,
    bool? isAdmin,
    bool? isSuperAdmin,
    bool? isCompany,
    String? companyName,
    String? companyWebsite,
    String? industry,
    String? inviteCode,
    String? location,
    String? sub,
    String? email,
    dynamic stripeCustomerId,
    String? name,
    String? title,
    String? age,
    String? gender,
    String? category,
    String? purpose,
    String? stage,
    String? revenue,
    String? mode,
  }) {
    return UserData(
      id: id ?? this.id,
      isAgent: isAgent ?? this.isAgent,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      picture: picture ?? this.picture,
      isAdmin: isAdmin ?? this.isAdmin,
      isSuperAdmin: isSuperAdmin ?? this.isSuperAdmin,
      isCompany: isCompany ?? this.isCompany,
      companyName: companyName ?? this.companyName,
      companyWebsite: companyWebsite ?? this.companyWebsite,
      industry: industry ?? this.industry,
      inviteCode: inviteCode ?? this.inviteCode,
      location: location ?? this.location,
      sub: sub ?? this.sub,
      email: email ?? this.email,
      stripeCustomerId: stripeCustomerId ?? this.stripeCustomerId,
      name: name ?? this.name,
      title: title ?? this.title,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      category: category ?? this.category,
      purpose: purpose ?? this.purpose,
      stage: stage ?? this.stage,
      revenue: revenue ?? this.revenue,
      mode: mode ?? this.mode,
    );
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json["id"] ?? 0,
      isAgent: json["is_agent"] ?? false,
      isOnboarded: json["is_onboarded"] ?? false,
      picture: json["picture"] ?? "",
      isAdmin: json["is_admin"] ?? false,
      isSuperAdmin: json["is_super_admin"] ?? false,
      isCompany: json["is_company"] ?? false,
      companyName: json["company_name"] ?? "",
      companyWebsite: json["company_website"] ?? "",
      industry: json["industry"] ?? "",
      inviteCode: json["invite_code"] ?? "",
      location: json["location"] ?? "",
      sub: json["sub"] ?? "",
      email: json["email"] ?? "",
      stripeCustomerId: json["stripe_customer_id"],
      name: json["name"] ?? "",
      title: json["title"] ?? "",
      age: json["age"] ?? "",
      gender: json["gender"] ?? "",
      category: json["category"] ?? "",
      purpose: json["purpose"] ?? "",
      stage: json["stage"] ?? "",
      revenue: json["revenue"] ?? "",
      mode: json["mode"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_agent": isAgent,
        "is_onboarded": isOnboarded,
        "picture": picture,
        "is_admin": isAdmin,
        "is_super_admin": isSuperAdmin,
        "is_company": isCompany,
        "company_name": companyName,
        "company_website": companyWebsite,
        "industry": industry,
        "invite_code": inviteCode,
        "location": location,
        "sub": sub,
        "email": email,
        "stripe_customer_id": stripeCustomerId,
        "name": name,
        "title": title,
        "age": age,
        "gender": gender,
        "category": category,
        "purpose": purpose,
        "stage": stage,
        "revenue": revenue,
        "mode": mode,
      };

  @override
  String toString() {
    return "$id, $isAgent, $isOnboarded, $picture, $isAdmin, $isSuperAdmin, $isCompany, $companyName, $companyWebsite, $industry, $inviteCode, $location, $sub, $email, $stripeCustomerId, $name, $title, $age, $gender, $category, $purpose, $stage, $revenue, $mode, ";
  }
}

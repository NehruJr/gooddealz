import 'package:goodealz/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocalData {
  static final LocalData _instance = LocalData._internal();

  factory LocalData() => _instance;

  LocalData._internal() {
    init();
  }

 static init() async {
    sharedPref = await SharedPreferences.getInstance();
  }

  static late SharedPreferences sharedPref;

  //! Setter Functions
  static Future<bool> setString(String key, String value) async {
    return await sharedPref.setString(key, value);
  }

  static Future<bool> setBool(String key, bool value) async {
    return await sharedPref.setBool(key, value);
  }

  static setUserData(User user){
    if(user.id != null) setString(LocalKeys.id, user.id.toString());
    setString(LocalKeys.fullName, user.fullName?? '');
    // setString(LocalKeys.lastName, user.lastName?? '');
    setString(LocalKeys.name, user.name?? '');
    setString(LocalKeys.email, user.email?? '');
    setString(LocalKeys.phone, user.phone?? '');
    setString(LocalKeys.avatar, user.avatar?? '');
    setString(LocalKeys.nationality, user.nationality?? '');
    setString(LocalKeys.birthDate, user.birthDate?? '');
    if(user.verified != null) setString(LocalKeys.verified, user.verified.toString());
  }

  static setToken(String token){
    setString(LocalKeys.token, token);
  }

  static setRememberedEmail(String email){
    setString(LocalKeys.rememberedEmail, email);
  }

  static removeRememberedEmail(String email){
    setString(LocalKeys.rememberedEmail, email);
  }

  static changeIsLogin(bool isLogin){
    setBool(LocalKeys.isLogin, isLogin);
  }
  static changeOpenedOnBoarding(bool openedOnBoarding){
    setBool(LocalKeys.openedOnBoarding, openedOnBoarding);
  }


  static Future<bool> remove(String key) async {
    return await sharedPref.remove(key);
  }

  static removeUserData(){
    remove(LocalKeys.id);
    remove(LocalKeys.fullName);
    // remove(LocalKeys.lastName);
    remove(LocalKeys.name);
    remove(LocalKeys.email);
    remove(LocalKeys.phone);
    remove(LocalKeys.avatar);
    remove(LocalKeys.nationality);
    remove(LocalKeys.birthDate);
    remove(LocalKeys.verified);
  }

  //! Getter Functions

  static String? getString(String key) {
    return sharedPref.getString(key);
  }

  static bool? getBool(String key) {
    return sharedPref.getBool(key);
  }

  static User getUserData(){
    User user = User(
      id: getString(LocalKeys.id) != null ? int.parse(getString(LocalKeys.id)!): null,
      fullName: getString(LocalKeys.fullName),
      // lastName: getString(LocalKeys.lastName),
      name: getString(LocalKeys.name),
      email: getString(LocalKeys.email),
      phone: getString(LocalKeys.phone),
      avatar: getString(LocalKeys.avatar),
      nationality: getString(LocalKeys.nationality),
      birthDate: getString(LocalKeys.birthDate),
      verified: getString(LocalKeys.verified) != null ? int.parse(getString(LocalKeys.verified)!): null,
    );

    return user;
  }

  static bool get isLogin {
    return getBool(LocalKeys.isLogin) ?? false;
  }

  static bool get openedOnBoarding {
    return getBool(LocalKeys.openedOnBoarding) ?? false;
  }

  static String? get token {
    return getString(LocalKeys.token);
  }

  static String? get rememberedEmail {
    return getString(LocalKeys.rememberedEmail);
  }
}

class LocalKeys {
  static const String isRememberMe = 'IS_REMEMBER_ME';
  static String id = 'id';
  static String fullName = 'full_name';
  // static String lastName = 'last_name';
  static String name = 'name';
  static String email = 'email';
  static String phone = 'phone';
  static String avatar = 'avatar';
  static String birthDate = 'birth_date';
  static String nationality = 'nationality';
  static String verified = 'verified';
  static String token = 'token';
  static String rememberedEmail = 'remember_email';
  static String isLogin = 'isLogin';
  static String openedOnBoarding = 'openedOnBoarding';
}

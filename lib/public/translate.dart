library jawlah.translate;

String selected_language = "ar";
String set_alignment = "right";

final Map<String, Map<String, String>> localizedStrings = {
  "show_all_taxi_offices__title": {
    "ar": "مكاتب التكاسي",
    "en": "Taxi Offices",
  },
  "show_all_landmarks__title": {
    "ar": "المعالم السياحية",
    "en": "Landmarks",
  },
  "loginPage__title": {
    "ar": "الدليل السياحي لفلسطين",
    "en": "Palestine Travel Guide",
  },
  "loginPage__btn": {
    "ar": "تسجيل دخول",
    "en": "Login",
  },
  "loginPage__username": {
    "ar": "اسم المستخدم",
    "en": "user name",
  },
  "loginPage__password": {
    "ar": "كلمة المرور",
    "en": "password",
  },
  "loginPage__forgetPassword": {
    "ar": "هل نسيت كلمة المرور؟",
    "en": "Forget Your Password?",
  },
  "loginPage__newAccount": {
    "ar": "هل تريد انشاء حساب؟",
    "en": "Create New Account?",
  },
  "bottomBar__home": {
    "ar": "الرئيسية",
    "en": "Home",
  },
  "bottomBar__myAccount": {
    "ar": "حسابي",
    "en": "My Account",
  },
  "bottomBar__logout": {
    "ar": "خروج",
    "en": "Logout",
  },
  "bottomBar__notifications": {
    "ar": "اشعارات",
    "en": "Notifications",
  },
  // Add more strings as needed
};

// Function to retrieve a string based on the selected language
String? getTxt(String key) {
  set_alignment = selected_language == "ar" ? "right" : "left";
  return localizedStrings[key]?[selected_language];
}

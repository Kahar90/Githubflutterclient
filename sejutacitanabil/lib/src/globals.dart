class Globals {
  static final Globals _globals = Globals._internal();
  //Globals();
  factory Globals() {
    return _globals;
  }
  Globals._internal();
  String? queryUsers;
  String? Pilihan;
}

// class Singleton {
//   static final Singleton _singleton = Singleton._internal();

//   factory Singleton() {
//     return _singleton;
//   }

//   Singleton._internal();
// }

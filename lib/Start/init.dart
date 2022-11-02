class Init {
  static Future initialize() async {
    await _registerServices();
    await _loadSettings();
  }
  static _registerServices() async {
    print("starting registering services");
    await Future.delayed(Duration(seconds: 3));
    print("finished registering services");
  }

  static _loadSettings() async {
    print("starting loading settings");
    await Future.delayed(Duration(seconds: 3));
    print("finished loading settings");
  }
}
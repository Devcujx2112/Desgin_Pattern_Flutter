class Country{
  String _uid;
  String _name;
  double _latitude;
  double _longtitude;
  String _createAt;

  Country(this._uid, this._name, this._latitude, this._longtitude,
      this._createAt);

  String get createAt => _createAt;

  set createAt(String value) {
    _createAt = value;
  }

  double get longtitude => _longtitude;

  set longtitude(double value) {
    _longtitude = value;
  }

  double get latitude => _latitude;

  set latitude(double value) {
    _latitude = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }


}
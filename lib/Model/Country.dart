class Country{
  String _name;
  double _latitude;
  double _longtitude;
  int _quantity;
  String _createAt;

  Country(this._name, this._latitude, this._longtitude, this._quantity,
      this._createAt);

  String get createAt => _createAt;

  set createAt(String value) {
    _createAt = value;
  }

  int get quantity => _quantity;

  set quantity(int value) {
    _quantity = value;
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


}
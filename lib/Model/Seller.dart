import 'package:design_pattern_login/Model/Account.dart';

class Seller extends Account{
  late String _storeName;
  late String _address;
  late String _ownerName;

  Seller(super.email, super.role, super.status, super.uid, this._storeName,this._ownerName,this._address);

  String get ownerName => _ownerName;

  set ownerName(String value) {
    _ownerName = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get storeName => _storeName;

  set storeName(String value) {
    _storeName = value;
  }

  @override
  String toString() {
    return 'Seller{_storeName: $_storeName, _address: $_address, _ownerName: $_ownerName}';
  }
}
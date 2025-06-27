import 'package:design_pattern_login/Model/Account.dart';

class User extends Account{
  late String _fullName;
  late String _age;
  late String _phoneNumber;

  User(super.email, super.role, super.status, super.uid, this._fullName,this._age,this._phoneNumber);

  String get phoneNumber => _phoneNumber;

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  String get age => _age;

  set age(String value) {
    _age = value;
  }

  String get fullName => _fullName;

  set fullName(String value) {
    _fullName = value;
  }

  @override
  String toString() {
    return 'User{_fullName: $_fullName, _age: $_age, _phoneNumber: $_phoneNumber}';
  }
}
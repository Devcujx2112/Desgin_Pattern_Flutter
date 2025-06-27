class Account{
  late String _email;
  late String _role;
  late String _status;
  late String _uid;

  Account(this._email, this._role, this._status, this._uid);

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  String get role => _role;

  set role(String value) {
    _role = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  @override
  String toString() {
    return 'Account{_email: $_email, _role: $_role, _status: $_status, _uid: $_uid}';
  }
}
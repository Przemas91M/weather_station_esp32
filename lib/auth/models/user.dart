class UserModel {
  final String? name;
  final String? uid;
  final String? email;
  String? avatar;

  UserModel({required this.name, required this.uid, required this.email});
  UserModel.empty({this.name = '', this.uid = '', this.email = ''});

  @override
  String toString() {
    return 'Current user name: {$name}, email:{$email}';
  }
}

class Userdata {
  const Userdata(this.username, this.password);
  final String username;
  final String password;
}

var users = [const Userdata('Dragmon', 'CrackJee@22')];
bool loggedIn = false;
String loginUsername = '';

class Userdata{
  const Userdata(this.username, this.password);
  final String username;
  final String password;
}

bool loggedIn=false;
String loginUsername='';

var users=[Userdata('Dragmon', 'CrackJee@22')];
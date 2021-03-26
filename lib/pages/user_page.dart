import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:pull_to_refresh/pull_to_refresh.dart';


class UserPage extends StatefulWidget {
  const UserPage({Key key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {


  final userService = new UserService();


  List<User> users = [];


  //RefreshController _refreshController = RefreshController(initialRefresh: false);


  @override
    void initState() {
      // TODO: implement initState
      this._cargarUsuarios();
      super.initState();
    }

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(authService.user.name,style: TextStyle(color:Colors.black),),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black,),
          onPressed: (){
            socketService.disconnect();
            Navigator.pushReplacementNamed(context,'login');
            authService.autenticando = false;
            AuthService.deleteToken();
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child:  
            socketService.serverStatus ==ServerStatus.Online ?
            Icon(Icons.check_circle,color:Colors.blue)
            :Icon(Icons.offline_bolt,color:Colors.red),
          )
        ],
      ),
      body: _listViewUser()
      ,
    );
  }

  ListView _listViewUser() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_,i)=>userListTile(users[i]),
      separatorBuilder: (_,i)=>Divider(),
      itemCount: users.length,
    );
  }

  ListTile userListTile(User user) {
    return ListTile(
        title: Text(user.name),
        subtitle: Text(user.email),
        leading: CircleAvatar(
          child: Text(user.name.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: user.online?Colors.green[300]:Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
        onTap: (){
          final chatService = Provider.of<ChatService>(context,listen: false);
          chatService.userTo = user;
          Navigator.pushNamed(context,"chat");
          print(user.name);
        },
      );
  }

  _cargarUsuarios()async{
    
    this.users = await userService.getUsers();

    setState(() {});
  }
}
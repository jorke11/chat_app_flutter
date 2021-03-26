import 'dart:io';

import 'package:chat_app/Widgets/chat_message.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  List<ChatMessage> _messages = [];

  bool _estaEscribiendo = false;

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      this.chatService = Provider.of<ChatService>(context,listen: false);
      this.socketService = Provider.of<SocketService>(context,listen: false);
      this.authService = Provider.of<AuthService>(context,listen: false);

      this.socketService.socket.on("send-message-personal",_listenMessages);

      _loadHistory(this.chatService.userTo.uid);
    }

    void _loadHistory(dynamic uid)async {
      List<Message> chats = await this.chatService.getChat(uid);
      final _history = chats.map((m)=>ChatMessage(
          texto:m.message,uid: m.from,
          animationController: new AnimationController(vsync: this,duration: Duration(milliseconds: 0))..forward()
          )
        );

      setState(() {
              _messages.insertAll(0,_history);
            });
      
    }




    void _listenMessages(dynamic data){
      ChatMessage message = new ChatMessage(
        texto: data["message"],
        uid:data["from"],
        animationController: new AnimationController(vsync: this, duration: Duration(milliseconds: 300)),
      );

      setState(() {
              _messages.insert(0,message);
            });

            message.animationController.forward();
    }

  @override
  Widget build(BuildContext context) {

    final userTo = chatService.userTo;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      title: Column(
        children: [
          CircleAvatar(
            child: Text(userTo.name.substring(0,2),style: TextStyle(fontSize: 12),),
            backgroundColor: Colors.blue[100],
            maxRadius: 14,
          ),
          SizedBox(height: 3,),
          Text(userTo.name, style: TextStyle(color:Colors.black87, fontSize: 12),)
          
        ],
      ),  
      centerTitle: true,
      elevation: 1,
      ),

      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder:(_,i)=> _messages[i],
                reverse: true,
              ),
            ),
            Divider(height: 1,),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    )
    
    ;
  }

  Widget _inputChat(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String texto){
                  //TODO: cuando hay un valor para posterar

                  setState(() {
                    if(texto.trim().length>0){
                        _estaEscribiendo = true;
                    }else{
                        _estaEscribiendo = false;
                    }
                  });

                },

                decoration: InputDecoration.collapsed(hintText: 'Enviar Mensaje'),
                focusNode: _focusNode,
              ),
            )

            //Boton de enviar
            ,
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS 
              ? CupertinoButton(
                child: Text("Enviar"),
                onPressed: _estaEscribiendo
                      ?()=>_handleSubmit(_textController.text.trim())
                      :null,
                ):Container(
                  margin:EdgeInsets.symmetric(horizontal: 4),
                  child:IconTheme(
                    data:IconThemeData(color:Colors.blue[400]),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(Icons.send, color: Colors.blue[400]),
                      onPressed: _estaEscribiendo
                      ?()=>_handleSubmit(_textController.text.trim())
                      :null,
                      ),
                  )
                ),
            )
          ],
        ),
      ));
  }

  _handleSubmit(String message){
    print(message);
    if(message.length==0) return;

    _textController.clear();
    _focusNode.requestFocus();

    final newMesssage = new ChatMessage(
      uid:authService.user.uid,
      texto:message,
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 300)),
      );

    _messages.insert(0,newMesssage);

    newMesssage.animationController.forward();

    setState(() {
      _estaEscribiendo = false;
    });

    socketService.emit("send-message-personal",{
      'from':this.authService.user.uid,
      'to':this.chatService.userTo.uid,
      'message':message
    });


  }

  @override
    void dispose() {
      // TODO: off del socket
      
      for(ChatMessage message in _messages){
        message.animationController.dispose();
      }

      this.socketService.socket.off('send-message-personal');
      super.dispose();
    }
}
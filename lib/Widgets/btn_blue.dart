import 'package:flutter/material.dart';

class BtnBlue extends StatelessWidget {
  
  final String text;
  final Function onPress;

  const BtnBlue({Key key,@required this.onPress, @required this.text}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
            elevation: 2,
            highlightElevation: 5,
            color: Colors.blue,
            shape: StadiumBorder(),

            onPressed: onPress,
            child: Container(
              width: double.infinity,
              height: 55,
              child: Center(child: Text(this.text, style: TextStyle(color: Colors.white),)),
            )
          ,),
    );
  }
}
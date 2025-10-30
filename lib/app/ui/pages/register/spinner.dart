import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 30,),
          Text('Enviando...'),
          Text('Por favor, aguarde isso pode levar alguns minutos...'),
        ],
      ),
    );
  }

}
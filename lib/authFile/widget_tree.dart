import 'package:eat_better/authFile/auth.dart';
import 'package:eat_better/authFile/login_register.dart';
import 'package:eat_better/navigation_menu.dart';
import 'package:eat_better/pages/home_page.dart';
import 'package:flutter/material.dart';


class WidgetTree extends StatefulWidget{
  const WidgetTree({ Key ? key}) :super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
  
}

class _WidgetTreeState extends State<WidgetTree>{
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges, 
      builder: (context , snapshot){
        if(snapshot.hasData){
          return NavigationMenu();
        }else{
          return  const LoginPage();
        }
      }
      );
  }
  
}
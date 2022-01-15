import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejutacitanabil/src/bloc/repo_bloc.dart';
import 'package:sejutacitanabil/src/functions.dart';
import 'package:sejutacitanabil/src/ui/RepoLogicMain.dart';

/* 
Hello there!, you can find UI related files in the "ui" folder, "functions.dart" file stores the network functions for API calls,
"models" folder stores  models classes to store the said calls, and finally, "bloc" folder stores our bloc related files. 
to make changes to the app, go to "RepoLogicMain.dart" inside the "ui" folder which stores all the main codes and branch off from there to specific UI in other files. 
*/

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Lato'),
      home: BlocProvider(
        create: (context) => RepoBloc(Functions())..add(DeleteList()),
        child: const RepoLogic(),
      ),
    );
  }
}

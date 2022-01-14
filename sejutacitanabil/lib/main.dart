import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejutacitanabil/src/bloc/repo_bloc.dart';
import 'package:sejutacitanabil/src/functions.dart';
import 'package:sejutacitanabil/src/ui/RepoLogicMain.dart';

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
        create: (context) => RepoBloc(Functions()),
        child: const RepoLogic(),
      ),
    );
  }
}

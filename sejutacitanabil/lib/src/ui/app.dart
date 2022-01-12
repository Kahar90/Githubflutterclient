import 'dart:async';
import 'dart:convert';
//import 'globals.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:sejutacitanabil/src/bloc/repo_bloc.dart';
import 'package:sejutacitanabil/src/bloc/repo_bloc.dart';
import 'package:sejutacitanabil/src/functions.dart';
import 'package:sejutacitanabil/src/globals.dart';
import 'package:sejutacitanabil/src/models/repoUser.dart';
import 'package:sejutacitanabil/src/ui/Users.dart';
import 'package:transparent_image/transparent_image.dart';
import '../bloc/repo_bloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData.light(),
      home: BlocProvider(
        create: (context) => RepoBloc(Functions()),
        child: RepoLogic(),
      ),
    );
  }
}

class RepoLogic extends StatefulWidget {
  @override
  State<RepoLogic> createState() => _RepoLogicState();
}

class _RepoLogicState extends State<RepoLogic> {
  Timer? _debounce;
  TextEditingController textEditingController = TextEditingController();
  StreamController<String> streamController = StreamController();
  bool loadingstate = false;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  ScrollController _scrollController = ScrollController(keepScrollOffset: true);
  bool isloading = false;
  int pagenum = 1;
  var globals = Globals();
  String? pilihan;
  String? tempcheck;
  bool lazyloading = true;
  bool index = false;
  //USERS
  List<dynamic>? data = [];
  List<dynamic>? imagelink = [];
  //ISSUES
  List<dynamic>? issuesTitle = [];
  //REPOS
  List<dynamic>? repodata = [];
  List<dynamic>? repodataowner = [];

  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
              _scrollController.offset &&
          !isloading) {
        if (pilihan == "USERS") {
          print("GET MORE USERS CALLED FROM SCROLL");
          pagenum++;
          isloading = true;
          setState(() {});
          final repoBloc = context.read<RepoBloc>();
          repoBloc.add(GetMoreUsers(globals.queryUsers.toString(), pagenum));
        }
        if (pilihan == "ISSUES") {
          print("GET MORE ISSUES CALLED FROM SCROLL");
          pagenum++;
          isloading = true;
          //setState(() {});
          final repoBloc = context.read<RepoBloc>();
          repoBloc.add(GetMoreIssues(globals.queryUsers.toString(), pagenum));
        }

        if (pilihan == "REPOSITORIES") {
          print("GET MORE REPOSITORIES CALLED FROM SCROLL");
          pagenum++;
          isloading = true;
          //setState(() {});
          final repoBloc = context.read<RepoBloc>();
          repoBloc
              .add(GetMoreRepositories(globals.queryUsers.toString(), pagenum));
        }
        print("pagenum: $pagenum");
      }
    });
    textEditingController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        if (textEditingController.text.isNotEmpty) {
          final repoBloc = context.read<RepoBloc>();
          repoBloc.add(DeleteList());
          if (pilihan == "USERS") {
            GetdataUser(context, textEditingController.text);
            print("di users bos");
          } else if (pilihan == "ISSUES") {
            GetdataIssues(context, textEditingController.text);
          } else if (pilihan == "REPOSITORIES") {
            Getdatarepos(context, textEditingController.text);
          }
        }
      });

      if (textEditingController.text == "") {
        final repoBloc = context.read<RepoBloc>();
        repoBloc.add(DeleteList());
        print("delete list called");
      }
    });
    return SafeArea(
      child: BlocConsumer<RepoBloc, RepoState>(
        listener: (context, state) {
          if (state is EmptyDataUsers ||
              state is EmptyDataIssues ||
              state is EmptyDataRepos) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    "data from API call is empty, you have either reach the max api calls, inputted a wrong search query, or at the end of the list")));
          }
          if (state is HTTPError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("HTTP Error")));
          }
          //USERS STATE CONTROL
          if (state is MoreRepoUserLoaded) {
            if (state.Userdata.items?.length != 0) {
              print(pagenum);
              int? count = state.Userdata.items?.length;

              for (var i = 0; i < count!; i++) {
                data?.add(state.Userdata.items?[i]);
                imagelink?.add(state.Userdata.items?[i]);
              }
              print("After data added: " + "${data?.length}");

              //setState(() {});
              isloading = false;
            } else {
              final repoBloc = context.read<RepoBloc>();
              repoBloc.add(EmptyDataEventUsers());
              isloading = false;
            }
          }
          if (state is RepoUserLoaded) {
            if (state.Userdata.items?.length != 0) {
              data?.clear();
              pagenum = 0;
              int? count = state.Userdata.items?.length;
              for (var i = 0; i < count!; i++) {
                data?.add(state.Userdata.items?[i]);
                imagelink?.add(state.Userdata.items?[i]);
              }
            } else {
              final repoBloc = context.read<RepoBloc>();
              repoBloc.add(EmptyDataEventUsers());
              isloading = false;
            }
          }
          //ISSUES STATE CONTROL
          if (state is RepoIssuesLoaded) {
            if (state.issuesData.items?.length != 0) {
              issuesTitle?.clear();
              pagenum = 0;
              int? count = state.issuesData.items?.length ?? 0;
              for (var i = 0; i < count; i++) {
                issuesTitle?.add(state.issuesData.items?[i]);
              }
            } else {
              final repoBloc = context.read<RepoBloc>();
              repoBloc.add(EmptyDataEventIssues());
              isloading = false;
            }
          }
          if (state is MoreRepoIssuesLoaded) {
            if (state.issuesData.items?.length != 0) {
              print(pagenum);
              int? count = state.issuesData.items?.length;

              for (var i = 0; i < count!; i++) {
                issuesTitle?.add(state.issuesData.items?[i]);
                //imagelink?.add(state.Userdata.items?[i]);
              }
              print("After data added: " + "${data?.length}");

              //setState(() {});
              isloading = false;
            } else {
              final repoBloc = context.read<RepoBloc>();
              repoBloc.add(EmptyDataEventIssues());
              isloading = false;
            }
          }
          //REPOS STATE CONTROL
          if (state is RepoReposLoaded) {
            if (state.reposData.items?.length != 0) {
              repodata?.clear();
              repodataowner?.clear();
              pagenum = 0;
              int? count = state.reposData.items?.length ?? 0;
              for (var i = 0; i < count; i++) {
                repodata?.add(state.reposData.items?[i]);
                //repodataowner?.add(state.reposData.items?[i].owner?.avatarUrl);
                //print(repodataowner?[i].avatarUrl);
              }
              print("After data added: " + "${repodata?.length}");
            } else {
              final repoBloc = context.read<RepoBloc>();
              repoBloc.add(EmptyDataEventIssues());
              isloading = false;
            }
          }
          if (state is MoreRepoReposLoaded) {
            if (state.reposData.items?.length != 0) {
              print(pagenum);
              int? count = state.reposData.items?.length;

              for (var i = 0; i < count!; i++) {
                repodata?.add(state.reposData.items?[i]);
                // repodataowner?.add(state.reposData.items?[i].owner?.avatarUrl);
                print(repodataowner?[i].avatarUrl);
              }
              print("After data added: " + "${repodata?.length}");

              //setState(() {});
              isloading = false;
            } else {
              final repoBloc = context.read<RepoBloc>();
              repoBloc.add(EmptyDataEventIssues());
              isloading = false;
            }
          }
          if (state is InitiateChange) {
            print("state.whattodo : ${state.whattodo}");
            if (state.whattodo == "USERS") {
              GetdataUser(context, textEditingController.text);
            }
            if (state.whattodo == "ISSUES") {
              GetdataIssues(context, textEditingController.text);
            }
            if (state.whattodo == "REPOSITORIES") {
              Getdatarepos(context, textEditingController.text);
            }
          }
          if (state is ClearList) {
            data?.clear();
            imagelink?.clear();
            repodata?.clear();
            pagenum = 0;
          }
          if (state is Error) {
            print("Error REceived!");
            pagenum--;
            isloading = false;
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                // SliverAppBar(
                //   //pinned: true,
                //   title: CustomRadioButton(
                //     radioButtonValue: (value) {
                //       print(value);
                //       pilihan = value.toString();
                //     },
                //     defaultSelected: "USERS",
                //     selectedColor: Colors.red,
                //     elevation: 0,
                //     absoluteZeroSpacing: true,
                //     unSelectedColor: Theme.of(context).canvasColor,
                //     buttonLables: ['Users', 'Issues', 'Repositories'],
                //     buttonValues: ['USERS', 'ISSUES', 'REPOSITORIES'],
                //     buttonTextStyle: ButtonTextStyle(
                //         selectedColor: Colors.blue,
                //         unSelectedColor: Colors.lightBlue),
                //   ),
                // ),
                // SliverAppBar(
                //   floating: true,
                //   title:
                // ),
                SliverPersistentHeader(
                    floating: true,
                    delegate: _SliverAppBarDelegate(
                        child: PreferredSize(
                      preferredSize: Size.fromHeight(40),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.lightBlue[100]),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 30,
                            ),
                            Flexible(
                              child: Container(
                                height: 25,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: TextField(
                                  // onChanged: _onSearchChanged(
                                  //     context, textEditingController.text),
                                  controller: textEditingController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      focusColor: Colors.white,
                                      fillColor: Colors.white),
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.blue,
                                ))
                          ],
                        ),
                      ),
                    ))),
                SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                        child: PreferredSize(
                      preferredSize: Size.fromHeight(70),
                      child: Container(
                        //color: Colors.green,
                        //margin: const EdgeInsets.all(15.0),
                        //padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            color: Colors.lightBlue[100],
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(40),
                                bottomLeft: Radius.circular(40))),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            CustomRadioButton(
                              enableShape: true,
                              //spacing: 100,
                              width: 110,
                              height: 26,

                              radioButtonValue: (value) {
                                print(value);

                                pilihan = value.toString();
                                if (tempcheck != value.toString()) {
                                  tempcheck = value.toString();
                                  if (tempcheck == "USERS") {
                                    final repobloc = context.read<RepoBloc>();
                                    repobloc.add(ChangeCategoriesEvent(
                                        value.toString()));
                                  }
                                  if (tempcheck == "ISSUES") {
                                    final repobloc = context.read<RepoBloc>();
                                    repobloc.add(ChangeCategoriesEvent(
                                        value.toString()));
                                  }
                                  if (tempcheck == "REPOSITORIES") {
                                    final repobloc = context.read<RepoBloc>();
                                    repobloc.add(ChangeCategoriesEvent(
                                        value.toString()));
                                  }
                                }
                              },
                              defaultSelected: "USERS",
                              selectedColor:
                                  Theme.of(context).colorScheme.secondary,
                              elevation: 0,
                              absoluteZeroSpacing: true,
                              unSelectedColor: Theme.of(context).canvasColor,
                              buttonLables: ['Users', 'Issues', 'Repositories'],
                              buttonValues: ['USERS', 'ISSUES', 'REPOSITORIES'],
                              buttonTextStyle: ButtonTextStyle(
                                  textStyle: TextStyle(fontSize: 12),
                                  selectedColor: Colors.white,
                                  unSelectedColor: Colors.lightBlue),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 26,
                                  width: 96,
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      child: Text(
                                        "Lazy Loading",
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(fontSize: 10),
                                      )),
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Container(
                                  height: 26,
                                  width: 96,
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      child: Text("Index",
                                          style: TextStyle(fontSize: 10))),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ))),

                BlocConsumer<RepoBloc, RepoState>(
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  builder: (context, state) {
                    if (state is RepoUserLoaded ||
                        state is MoreRepoUserLoaded ||
                        state is EmptyDataUsers ||
                        state is HTTPError) {
                      print("RepoUserLoaded BOSSSSSSSSS");
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            // if (state is RepoUserLoaded) {
                            //   print("${data?.length} - Issues title length");
                            //   print("RepoUserLoaded");
                            return dataCardUser(data, imagelink, index);
                            // } else if (state is RepoIssuesLoaded) {
                            //   print(
                            //       "${issuesTitle?.length} - Issues title length");
                            //   print("RepoIssuesLoaded");
                            //   //return dataCardIssues(issuesTitle, index);
                            //   return Text(issuesTitle?[index].title);
                            // }
                          },
                          childCount: data?.length ?? issuesTitle?.length,
                        ),
                      );
                    } else if (state is RepoReposLoaded ||
                        state is MoreRepoReposLoaded ||
                        state is EmptyDataRepos ||
                        state is HTTPError) {
                      print("RepoReposLoaded BOSSSSSSSSS");
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return dataCardRepositories(
                                context, repodata, repodataowner, index);
                            //return Container();
                          },
                          childCount: repodata?.length,
                        ),
                      );
                    } else if (state is RepoIssuesLoaded ||
                        state is MoreRepoIssuesLoaded ||
                        state is EmptyDataIssues ||
                        state is HTTPError) {
                      print("RepoIssuesLoaded BOSSSSSSSSS");
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return dataCardIssues(context, issuesTitle, index);
                          },
                          childCount: issuesTitle?.length,
                        ),
                      );
                    }
                    return SliverToBoxAdapter(
                      child: Container(),
                    );
                  },
                ),
                // isloading ? Loading() : Container(),
                isloading
                    ? SliverToBoxAdapter(
                        child: Loading(),
                      )
                    : SliverToBoxAdapter(
                        child: Container(),
                      )
              ],
            ),
          );
        },
      ),
    );
  }

  GetdataUser(BuildContext context, String username) {
    print("getdatausercalled $username");
    globals.queryUsers = username;
    final repoBloc = context.read<RepoBloc>();
    repoBloc.add(GetUsers(username, 1));
  }

  GetdataIssues(BuildContext context, String username) {
    print("getissuescalled $username");
    globals.queryUsers = username;
    final repoBloc = context.read<RepoBloc>();
    repoBloc.add(GetIssues(username, 1));
  }

  Getdatarepos(BuildContext context, String username) {
    print("getreposcalled $username");
    globals.queryUsers = username;
    final repoBloc = context.read<RepoBloc>();
    repoBloc.add(GetRepositories(username, 1));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  late PreferredSize child;

  _SliverAppBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return child;
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => child.preferredSize.height;

  @override
  // TODO: implement minExtent
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return false;
  }
}

Widget dataCardUser(List<dynamic>? data, List<dynamic>? imagelink, index) {
  return Card(
    child: Row(
      children: [
        Container(
          height: 70,
          width: 70,
          child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: "${imagelink?[index].avatarUrl}"),
        ),
        Text(data?[index].login ?? ""),
      ],
    ),
  );
}

Widget dataCardIssues(BuildContext context, List<dynamic>? data, index) {
  return Container(
    child: Card(
      color: Colors.white70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.65,
                child: Text(
                  data?[index].title ?? "data kosong",
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                //width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  data?[index].updatedAt ?? "data kosong",
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                child: Text(
                  data?[index].state ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              data?[index].state == "closed"
                  ? Container(height: 40, width: 40, child: Icon(Icons.close))
                  : Container(height: 40, width: 40, child: Icon(Icons.check))
            ],
          )
        ],
      ),
    ),
  );
}

Widget dataCardRepositories(BuildContext context, List<dynamic>? repodata,
    List<dynamic>? repodataowner, index) {
  return Card(
    child: Row(
      children: [
        Container(
          width: 70,
          height: 70,
          child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: "${repodata?[index].owner.avatarUrl}"),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            repodata?[index].name ?? "data kosong",
          ),
        ),
      ],
    ),
  );
}

Widget Loading() {
  return Center(widthFactor: 20, child: CircularProgressIndicator());
}

class Buttons extends StatelessWidget {
  const Buttons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Getdata(context, "test"),
                child: Text("Lazy Loading"),
              ),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(onPressed: () {}, child: Text("Index")),
            ],
          ),
        ],
      ),
    );
  }

  void Getdata(BuildContext context, String username) {
    final repoBloc = context.read<RepoBloc>();
    repoBloc.add(GetUsers("Kahar", 0));
  }
}

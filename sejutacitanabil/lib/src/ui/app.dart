// ignore_for_file: sized_box_for_whitespace

import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejutacitanabil/src/bloc/repo_bloc.dart';
import 'package:sejutacitanabil/src/functions.dart';
import 'package:sejutacitanabil/src/globals.dart';
import 'package:sejutacitanabil/src/ui/PersistentHeaders.dart';
import 'package:sejutacitanabil/src/ui/ProfileCard.dart';
import 'package:sejutacitanabil/src/ui/Widgets.dart';
import 'package:sejutacitanabil/src/ui/sliverFillRemaining.dart';
import '../bloc/repo_bloc.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: GoogleFonts.lato().fontFamily),
      home: BlocProvider(
        create: (context) => RepoBloc(Functions()),
        child: const RepoLogic(),
      ),
    );
  }
}

class RepoLogic extends StatefulWidget {
  const RepoLogic({Key? key}) : super(key: key);
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

  final ScrollController _scrollController =
      ScrollController(keepScrollOffset: true);
  bool isloading = false;
  int pagenum = 1;
  var globals = Globals();
  String? pilihan = "USERS";
  String? tempcheck;
  bool lazyloading = true;
  bool index = false;
  RegExp reg = RegExp("^([^T])+");

  //USERS
  List<dynamic>? data = [];
  //ISSUES
  List<dynamic>? issuesTitle = [];
  List<dynamic>? issuesDate = [];
  //REPOS
  List<dynamic>? repodata = [];

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (lazyloading) {
        if (_scrollController.position.maxScrollExtent ==
                _scrollController.offset &&
            !isloading) {
          getMoreDataAccordingToCategories();
        }
      }
    });

    return SafeArea(
      child: BlocConsumer<RepoBloc, RepoState>(
        listener: (context, state) {
          if (state is EmptyDataUsers ||
              state is EmptyDataIssues ||
              state is EmptyDataRepos) {
            if (pagenum != 1) {
              pagenum--;
            }
            isloading = false;
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(
                    duration: Duration(milliseconds: 1200),
                    backgroundColor: Colors.black54,
                    content: Text(
                        "Data from API call is empty, you are at the end of the list")))
                .closed
                .then(
                    (value) => ScaffoldMessenger.of(context).clearSnackBars());
          }
          if (state is HTTPErrorUsers ||
              state is HTTPErrorIssues ||
              state is HTTPErrorRepos) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.black54,
                content: Text("HTTP Error, you have hit the max API calls")));
            isloading = false;
          }
          if (state is RepoLoadingUsers ||
              state is RepoLoadingIssues ||
              state is RepoLoadingRepos) {
            data?.clear();

            issuesTitle?.clear();
            issuesDate?.clear();

            repodata?.clear();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.black54,
                duration: const Duration(milliseconds: 600),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Fetching your data hold on..."),
                    const SizedBox(
                      width: 4,
                    ),
                    Container(
                        height: 20,
                        width: 20,
                        child: const CircularProgressIndicator())
                  ],
                )));
          }
          if (state is RepoProfileLoaded) {
            showDialog(
                context: context,
                builder: (context) => alertDialog(context, data, state));
          }
          //USERS STATE CONTROL
          if (state is RepoUserLoaded) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            if (state.userdata.items!.isNotEmpty) {
              data?.clear();
              pagenum = 1;
              int? count = state.userdata.items?.length;
              for (var i = 0; i < count!; i++) {
                data?.add(state.userdata.items?[i]);
              }
              isloading = false;
            } else {
              final repoBloc = context.read<RepoBloc>();
              repoBloc.add(EmptyDataEventUsers());
              isloading = false;
            }
            isloading = false;
          }
          if (state is MoreRepoUserLoaded) {
            if (state.userdata.items!.isNotEmpty) {
              int? count = state.userdata.items?.length;

              for (var i = 0; i < count!; i++) {
                data?.add(state.userdata.items?[i]);
                //imagelink?.add(state.Userdata.items?[i]);
              }

              isloading = false;
            } else {
              final repoBloc = context.read<RepoBloc>();
              repoBloc.add(EmptyDataEventUsers());
              isloading = false;
            }
            isloading = false;
          }

          //ISSUES STATE CONTROL
          if (state is RepoIssuesLoaded) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            if (state.issuesData.items!.isNotEmpty) {
              issuesTitle?.clear();
              issuesDate?.clear();

              RegExp reg = RegExp("^([^T])+");
              pagenum = 1;
              int? count = state.issuesData.items?.length ?? 0;
              for (var i = 0; i < count; i++) {
                issuesTitle?.add(state.issuesData.items?[i]);
                String? temp;
                temp = state.issuesData.items?[i].updatedAt.toString();
                issuesDate?.add(reg.stringMatch(temp.toString()).toString());
              }
              isloading = false;
            } else {
              final repoBloc = context.read<RepoBloc>();
              repoBloc.add(EmptyDataEventIssues());
              isloading = false;
            }
            isloading = false;
          }
          if (state is MoreRepoIssuesLoaded) {
            if (state.issuesData.items!.isNotEmpty) {
              int? count = state.issuesData.items?.length;
              RegExp reg = RegExp("^([^T])+");

              for (var i = 0; i < count!; i++) {
                issuesTitle?.add(state.issuesData.items?[i]);
                String? temp;
                temp = state.issuesData.items?[i].updatedAt.toString();
                issuesDate?.add(reg.stringMatch(temp.toString()).toString());
              }

              isloading = false;
            } else {
              final repoBloc = context.read<RepoBloc>();
              repoBloc.add(EmptyDataEventIssues());
              isloading = false;
            }
            isloading = false;
          }

          //REPOS STATE CONTROL
          if (state is RepoReposLoaded) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            if (state.reposData.items!.isNotEmpty) {
              repodata?.clear();
              pagenum = 1;
              int? count = state.reposData.items?.length ?? 0;
              for (var i = 0; i < count; i++) {
                repodata?.add(state.reposData.items?[i]);
                //repodataowner?.add(state.reposData.items?[i].owner?.avatarUrl);
                //print(repodataowner?[i].avatarUrl);
              }

              isloading = false;
            } else {
              final repoBloc = context.read<RepoBloc>();
              repoBloc.add(EmptyDataEventRepos());
              isloading = false;
            }
            isloading = false;
          }
          if (state is MoreRepoReposLoaded) {
            if (state.reposData.items!.isNotEmpty) {
              int? count = state.reposData.items?.length;

              for (var i = 0; i < count!; i++) {
                repodata?.add(state.reposData.items?[i]);

                //print(repodataowner?[i].avatarUrl);
              }

              isloading = false;
            } else {
              final repoBloc = context.read<RepoBloc>();
              repoBloc.add(EmptyDataEventRepos());
              isloading = false;
            }
            isloading = false;
          }
          if (state is InitiateChangeViewUsersLoading ||
              state is InitiateChangeViewIssuesLoading ||
              state is InitiateChangeViewReposLoading) {
            lazyloading = true;
            index = false;
          }
          if (state is InitiateChangeViewUsersIndex ||
              state is InitiateChangeViewIssuesIndex ||
              state is InitiateChangeViewReposIndex) {
            lazyloading = false;
            index = true;
          }
          if (state is InitiateChange) {
            pilihan = state.whattodo;
            if (textEditingController.text.isNotEmpty) {
              if (state.whattodo == "USERS") {
                getdataUser(context, textEditingController.text);
              }
              if (state.whattodo == "ISSUES") {
                getdataIssues(context, textEditingController.text);
              }
              if (state.whattodo == "REPOSITORIES") {
                getdatarepos(context, textEditingController.text);
              }
            }
          }
          if (state is ClearList) {
            data?.clear();
            repodata?.clear();
            pagenum = 1;
            isloading = false;
          }
          if (state is Error) {
            pagenum--;
            isloading = false;
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              FocusNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Scaffold(
              backgroundColor: Colors.grey[200],
              body: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverPersistentHeader(
                      floating: true,
                      delegate: SliverAppBarDelegate(
                          child: firstHeader(
                              context,
                              textEditingController,
                              searchQuery,
                              getDataAccordingToCategories,
                              clearTextController))),
                  SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverAppBarDelegate(
                          child: secondHeader(
                        context,
                        pilihan,
                        tempcheck,
                        changeViewStateLoading,
                        changeViewStateIndex,
                      ))),
                  BlocConsumer<RepoBloc, RepoState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is RepoLoadingUsers ||
                          state is RepoUserLoaded ||
                          state is MoreRepoUserLoaded ||
                          state is EmptyDataUsers ||
                          state is HTTPErrorUsers ||
                          state is RepoProfileLoaded ||
                          state is InitiateChangeViewUsersLoading ||
                          state is InitiateChangeViewUsersIndex) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return GestureDetector(
                                  onTap: () {
                                    FocusNode currentFocus =
                                        FocusScope.of(context);
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                    getDataProfil(
                                        context, data?[index].url, index);
                                  },
                                  child: dataCardUser(data, index));
                            },
                            childCount: data?.length ?? issuesTitle?.length,
                          ),
                        );
                      } else if (state is RepoLoadingIssues ||
                          state is RepoIssuesLoaded ||
                          state is MoreRepoIssuesLoaded ||
                          state is EmptyDataIssues ||
                          state is HTTPErrorIssues ||
                          state is InitiateChangeViewIssuesLoading ||
                          state is InitiateChangeViewIssuesIndex) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return dataCardIssues(
                                  context, issuesTitle, issuesDate, index, reg);
                            },
                            childCount: issuesTitle?.length,
                          ),
                        );
                      } else if (state is RepoLoadingRepos ||
                          state is RepoReposLoaded ||
                          state is MoreRepoReposLoaded ||
                          state is EmptyDataRepos ||
                          state is HTTPErrorRepos ||
                          state is InitiateChangeViewReposLoading ||
                          state is InitiateChangeViewReposIndex) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return dataCardRepositories(
                                  context, repodata, index);
                              //return Container();
                            },
                            childCount: repodata?.length,
                          ),
                        );
                      }
                      return SliverToBoxAdapter(child: Container());
                    },
                  ),
                  if (isloading && lazyloading == true)
                    SliverToBoxAdapter(
                      child: loading(),
                    )
                  else if (index)
                    sliverFillRemaining(isloading, index, pagenum,
                        getMoreDataAccordingToCategories)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  changeCategories(String value) {
    pilihan = value;
  }

  changeViewStateLoading() {
    print("change to lazty loading called");

    lazyloading = true;
    index = false;
  }

  changeViewStateIndex() {
    print("change to index called");

    index = true;
    lazyloading = false;
  }

  clearTextController() {
    textEditingController.clear();
    final repoBloc = context.read<RepoBloc>();
    repoBloc.add(DeleteList());
  }

  searchQuery() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1500), () {
      if (textEditingController.text.isNotEmpty) {
        final repoBloc = context.read<RepoBloc>();
        repoBloc.add(DeleteList());
        getDataAccordingToCategories();
      }
    });

    if (textEditingController.text.isEmpty) {
      //clear list when query box is empty
      final repoBloc = context.read<RepoBloc>();
      repoBloc.add(DeleteList());
    }
  }

  getDataProfil(BuildContext context, String urlprofile, int index) {
    final repoBloc = context.read<RepoBloc>();
    repoBloc.add(GetProfileInfo(urlprofile, index));
  }

  getdataUser(BuildContext context, String username) {
    globals.queryUsers = username;
    final repoBloc = context.read<RepoBloc>();
    repoBloc.add(GetUsers(username, 1));
  }

  getdataIssues(BuildContext context, String username) {
    globals.queryUsers = username;
    final repoBloc = context.read<RepoBloc>();
    repoBloc.add(GetIssues(username, 1));
  }

  getdatarepos(BuildContext context, String username) {
    globals.queryUsers = username;
    final repoBloc = context.read<RepoBloc>();
    repoBloc.add(GetRepositories(username, 1));
  }

  getMoreDataAccordingToCategories() {
    if (pilihan == "USERS") {
      //print("GET MORE USERS CALLED FROM SCROLL");
      pagenum++;
      isloading = true;
      //setState(() {});
      final repoBloc = context.read<RepoBloc>();
      repoBloc.add(GetMoreUsers(globals.queryUsers.toString(), pagenum));
    }
    if (pilihan == "ISSUES") {
      // print("GET MORE ISSUES CALLED FROM SCROLL");
      pagenum++;
      isloading = true;
      //setState(() {});
      final repoBloc = context.read<RepoBloc>();
      repoBloc.add(GetMoreIssues(globals.queryUsers.toString(), pagenum));
    }

    if (pilihan == "REPOSITORIES") {
      // print(
      //     "GET MORE REPOSITORIES CALLED FROM SCROLL");
      pagenum++;
      isloading = true;
      //setState(() {});
      final repoBloc = context.read<RepoBloc>();
      repoBloc.add(GetMoreRepositories(globals.queryUsers.toString(), pagenum));
    }
  }

  getDataAccordingToCategories() {
    FocusNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    isloading = true;
    if (pilihan == "USERS") {
      getdataUser(context, textEditingController.text);
    } else if (pilihan == "ISSUES") {
      getdataIssues(context, textEditingController.text);
    } else if (pilihan == "REPOSITORIES") {
      getdatarepos(context, textEditingController.text);
    }
  }
}

// ignore_for_file: sized_box_for_whitespace

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejutacitanabil/src/bloc/repo_bloc.dart';
import 'package:sejutacitanabil/src/ui/PersistentHeaders.dart';
import 'package:sejutacitanabil/src/ui/ProfileCard.dart';
import 'package:sejutacitanabil/src/ui/Widgets.dart';
import 'package:sejutacitanabil/src/ui/sliverFillRemaining.dart';
import '../bloc/repo_bloc.dart';

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
  int pageCountControl = 0;

  String? pilihan = "USERS";
  String? tempcheck;
  bool lazyloading = true;
  bool indexstate = false;
  RegExp reg = RegExp("^([^T])+");
  var scrollposition;

  //USERS
  List<dynamic> data = [];
  List<List<dynamic>>? dataforIndex = [[]];

  //ISSUES
  List<dynamic>? issuesTitle = [];
  List<dynamic>? issuesDate = [];
  List<List<dynamic>?>? issuesTitleforIndex = [[]];
  List<List<dynamic>?>? issuesDateforIndex = [[]];
  int? pageCountIssues;
  //REPOS

  List<dynamic>? repodata = [];
  List<List<dynamic>?>? repodataforIndex = [[]];
  int? pageCountRepos;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    _scrollController.addListener(() {
      if (lazyloading) {
        if (_scrollController.position.maxScrollExtent ==
                _scrollController.offset &&
            !isloading) {
          getMoreDataAccordingToCategories();
        }
        if (_scrollController.offset < 2400) {
          pageCountControl = 0;
        } else {
          pageCountControl = (_scrollController.offset / 2400).floor();
        }
      }
    });

    return BlocConsumer<RepoBloc, RepoState>(
      listener: (context, state) {
        if (state is EmptyDataUsers ||
            state is EmptyDataIssues ||
            state is EmptyDataRepos) {
          emptyData();
        }
        if (state is HTTPErrorUsers ||
            state is HTTPErrorIssues ||
            state is HTTPErrorRepos) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.black54,
              content: Text(
                  "HTTP Error, you have either hit the max API calls, or query inputted is invalid")));
          isloading = false;
        }
        if (state is RepoLoadingUsers ||
            state is RepoLoadingIssues ||
            state is RepoLoadingRepos) {
          repoLoading();
        }
        if (state is RepoProfileLoaded) {
          repoProfileLoaded(state);
        }
        //USERS STATE CONTROL
        if (state is RepoUserLoaded) {
          List<dynamic> temp = [];
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          repoUserLoaded(state, temp);
        }
        if (state is MoreRepoUserLoaded) {
          List<dynamic> temp = [];

          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          moreRepoUserLoaded(state, temp);
        }

        //ISSUES STATE CONTROL
        if (state is RepoIssuesLoaded) {
          List<dynamic> temp = [];
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          repoIssuesLoaded(state, temp);
        }
        if (state is MoreRepoIssuesLoaded) {
          List<dynamic> temp = [];
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          moreRepoIssuesLoaded(state, temp);
        }

        //REPOS STATE CONTROL
        if (state is RepoReposLoaded) {
          List<dynamic> temp = [];
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          repoReposLoaded(state, temp);
        }

        if (state is MoreRepoReposLoaded) {
          List<dynamic> temp = [];
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          moreRepoReposLoaded(state, temp);
        }

        if (state is InitiateChangeViewUsersLoading ||
            state is InitiateChangeViewIssuesLoading ||
            state is InitiateChangeViewReposLoading) {
          _scrollController.jumpTo(scrollposition);
        }

        if (state is InitiateChangeViewUsersIndex ||
            state is InitiateChangeViewIssuesIndex ||
            state is InitiateChangeViewReposIndex) {
          scrollposition = _scrollController.offset;
          _scrollController.jumpTo(1);
        }

        if (state is InitiateChange) {
          pilihan = state.whattodo;
          initiateChange(state);
        }
        if (state is ClearList) {
          clearList();
        }
        if (state is Error) {}
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
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
              ),
            ),
            backgroundColor: Colors.grey[200],
            body: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverPersistentHeader(
                    floating: true,
                    delegate: SliverAppBarDelegate(
                        child: PreferredSize(
                      preferredSize: const Size.fromHeight(40),
                      child: Center(
                        child: FirstHeader(
                            context,
                            textEditingController,
                            searchQuery,
                            getDataAccordingToCategories,
                            clearTextController),
                      ),
                    ))),
                SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverAppBarDelegate(
                        child: PreferredSize(
                      preferredSize: const Size.fromHeight(80),
                      child: Center(
                        child: SecondHeader(
                          context,
                          pilihan,
                          tempcheck,
                          changeViewStateLoading,
                          changeViewStateIndex,
                        ),
                      ),
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
                                FocusNode currentFocus = FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                !indexstate
                                    ? getDataProfil(
                                        context, data[index].url, index)
                                    : getDataProfil(
                                        context,
                                        dataforIndex?[pageCountControl][index]
                                            .url,
                                        index);
                              },
                              child: !indexstate
                                  ? dataCardUser(
                                      data, index, pageCountControl, indexstate)
                                  : dataCardUser(dataforIndex, index,
                                      pageCountControl, indexstate));
                        },
                            childCount: !indexstate
                                ? data.length
                                : (pagenum == 1 && data.length > 30
                                    ? 30
                                    : dataforIndex?[pageCountControl].length ??
                                        data.length)),
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
                          return !indexstate
                              ? dataCardIssues(context, issuesTitle, issuesDate,
                                  index, pageCountControl, reg, indexstate)
                              : dataCardIssues(
                                  context,
                                  issuesTitleforIndex,
                                  issuesDate,
                                  index,
                                  pageCountControl,
                                  reg,
                                  indexstate);
                        },
                            // childCount: !indexstate
                            //     ? issuesTitle?.length ?? 0
                            //     : issuesTitleforIndex?[pageCountControl]
                            //             ?.length ??
                            //         0,
                            childCount: !indexstate
                                ? issuesTitle?.length
                                : (pagenum == 1 && issuesTitle!.length > 30
                                    ? 30
                                    : issuesTitleforIndex?[pageCountControl]
                                            ?.length ??
                                        issuesTitle?.length)),
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
                          return !indexstate
                              ? dataCardRepositories(context, pageCountControl,
                                  repodata, index, indexstate)
                              : dataCardRepositories(context, pageCountControl,
                                  repodataforIndex, index, indexstate);
                        },
                            childCount: !indexstate
                                ? repodata?.length
                                : (pagenum == 1 && repodata!.length > 30
                                    ? 30
                                    : repodataforIndex?[pageCountControl]
                                            ?.length ??
                                        repodata?.length)),
                      );
                    }
                    return SliverToBoxAdapter(child: Container());
                  },
                ),
                if (indexstate)
                  sliverFillRemaining(
                      isloading,
                      indexstate,
                      pagenum,
                      getMoreDataAccordingToCategories,
                      goBackOnePage,
                      goNextOnePageChangeScrollPos)
              ],
            ),
          ),
        );
      },
    );
  }

  goBackOnePage() {
    if (pagenum > 1) {
      pagenum--;
    }
    if (pageCountControl != 0) {
      pageCountControl--;
    }
    _scrollController.jumpTo(1);
    setState(() {});
  }

  goNextOnePageChangeScrollPos() {
    _scrollController.jumpTo(1);
  }

  changeCategories(String value) {
    pilihan = value;
  }

  changeViewStateLoading() {
    setState(() {
      lazyloading = true;
      indexstate = false;
    });
  }

  changeViewStateIndex() {
    setState(() {
      indexstate = true;
      lazyloading = false;
    });
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
      final repoBloc = context.read<RepoBloc>();
      repoBloc.add(DeleteList());
    }
  }

  repoLoading() {
    data.clear();

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
                height: 20, width: 20, child: const CircularProgressIndicator())
          ],
        )));
  }

  fetchingDataSnackbar() {
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
                height: 20, width: 20, child: const CircularProgressIndicator())
          ],
        )));
  }

  repoProfileLoaded(state) {
    showDialog(
        context: context,
        builder: (context) => !indexstate
            ? alertDialog(context, data, state, indexstate, pageCountControl)
            : alertDialog(
                context, dataforIndex, state, indexstate, pageCountControl));
  }

  repoUserLoaded(state, temp) {
    if (state.userdata.items!.isNotEmpty) {
      data.clear();
      dataforIndex = [];
      pageCountControl = 0;
      pagenum = 1;
      int? count = state.userdata.items?.length ?? 0;

      for (var i = 0; i < count!; i++) {
        data.add(state.userdata.items?[i]);
        temp?.add(state.userdata.items?[i]);
      }

      dataforIndex?.add(data);
      temp.clear();
      isloading = false;
    } else {
      final repoBloc = context.read<RepoBloc>();
      repoBloc.add(EmptyDataEventUsers());
      isloading = false;
    }
    isloading = false;
  }

  moreRepoUserLoaded(state, temp) {
    temp.clear();

    if (state.userdata.items!.isNotEmpty) {
      int? count = state.userdata.items?.length;
      pageCountControl++;

      for (var i = 0; i < count!; i++) {
        data.add(state.userdata.items?[i]);
        temp?.add(state.userdata.items?[i]);
      }

      dataforIndex?.add(temp);

      isloading = false;
    } else {
      final repoBloc = context.read<RepoBloc>();
      repoBloc.add(EmptyDataEventUsers());
      isloading = false;
    }
    isloading = false;
  }

  repoIssuesLoaded(state, tempData) {
    if (state.issuesData.items!.isNotEmpty) {
      issuesTitle?.clear();
      issuesDate?.clear();
      issuesTitleforIndex?.clear();
      pageCountControl = 0;
      pagenum = 1;

      RegExp reg = RegExp("^([^T])+");
      pagenum = 1;
      int? count = state.issuesData.items?.length ?? 0;
      for (var i = 0; i < count!; i++) {
        issuesTitle?.add(state.issuesData.items?[i]);
        tempData?.add(state.issuesData.items?[i]);
        String? temp;
        temp = state.issuesData.items?[i].updatedAt.toString();
        issuesDate?.add(reg.stringMatch(temp.toString()).toString());
      }
      issuesTitleforIndex?.add(issuesTitle);
      tempData.clear();

      isloading = false;
    } else {
      final repoBloc = context.read<RepoBloc>();
      repoBloc.add(EmptyDataEventIssues());
      isloading = false;
    }
    isloading = false;
  }

  moreRepoIssuesLoaded(state, tempData) {
    tempData.clear();

    if (state.issuesData.items!.isNotEmpty) {
      int? count = state.issuesData.items?.length;
      RegExp reg = RegExp("^([^T])+");
      pageCountControl++;

      for (var i = 0; i < count!; i++) {
        issuesTitle?.add(state.issuesData.items?[i]);
        tempData?.add(state.issuesData.items?[i]);
        String? temp;
        temp = state.issuesData.items?[i].updatedAt.toString();
        issuesDate?.add(reg.stringMatch(temp.toString()).toString());
      }
      issuesTitleforIndex?.add(tempData);

      isloading = false;
    } else {
      final repoBloc = context.read<RepoBloc>();
      repoBloc.add(EmptyDataEventIssues());
      isloading = false;
    }
    isloading = false;
  }

  repoReposLoaded(state, temp) {
    if (state.reposData.items!.isNotEmpty) {
      repodata?.clear();
      repodataforIndex?.clear();
      pageCountControl = 0;
      pagenum = 1;
      int? count = state.reposData.items?.length ?? 0;
      for (var i = 0; i < count!; i++) {
        repodata?.add(state.reposData.items?[i]);
        temp?.add(state.reposData.items?[i]);
      }
      repodataforIndex?.add(repodata);
      temp.clear();

      isloading = false;
    } else {
      final repoBloc = context.read<RepoBloc>();
      repoBloc.add(EmptyDataEventRepos());
      isloading = false;
    }
    isloading = false;
  }

  moreRepoReposLoaded(state, temp) {
    temp.clear();
    if (state.reposData.items!.isNotEmpty) {
      int? count = state.reposData.items?.length;
      pageCountControl++;
      for (var i = 0; i < count!; i++) {
        repodata?.add(state.reposData.items?[i]);
        temp?.add(state.reposData.items?[i]);
      }
      repodataforIndex?.add(temp);

      isloading = false;
    } else {
      final repoBloc = context.read<RepoBloc>();
      repoBloc.add(EmptyDataEventRepos());
      isloading = false;
    }
    isloading = false;
  }

  initiateChange(state) {
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

  emptyData() {
    pagenum--;
    isloading = false;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(
            duration: Duration(milliseconds: 1200),
            backgroundColor: Colors.black54,
            content: Text(
                "Data from API call is empty, you are at the end of the list")))
        .closed
        .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
  }

  clearList() {
    data.clear();
    issuesTitle?.clear();
    issuesDate?.clear();
    repodata?.clear();
    pageCountControl = 0;
    pagenum = 1;
    isloading = false;
  }

  error() {
    if (pageCountControl != 0) {
      pageCountControl--;
    }
    if (pagenum != 0) {
      pagenum--;
    }
    isloading = false;
  }

  getDataProfil(BuildContext context, String urlprofile, int index) {
    final repoBloc = context.read<RepoBloc>();
    repoBloc.add(GetProfileInfo(urlprofile, index));
  }

  getdataUser(BuildContext context, String username) {
    final repoBloc = context.read<RepoBloc>();
    repoBloc.add(GetUsers(username, 1));
  }

  getdataIssues(BuildContext context, String username) {
    final repoBloc = context.read<RepoBloc>();
    repoBloc.add(GetIssues(username, 1));
  }

  getdatarepos(BuildContext context, String username) {
    final repoBloc = context.read<RepoBloc>();
    repoBloc.add(GetRepositories(username, 1));
  }

  getMoreDataAccordingToCategories() {
    if (textEditingController.text.isNotEmpty && !isloading) {
      if (pilihan == "USERS") {
        fetchingDataSnackbar();
        pagenum++;
        isloading = true;

        final repoBloc = context.read<RepoBloc>();
        repoBloc.add(GetMoreUsers(textEditingController.text, pagenum));
      }
      if (pilihan == "ISSUES") {
        fetchingDataSnackbar();
        pagenum++;
        isloading = true;

        final repoBloc = context.read<RepoBloc>();
        repoBloc.add(GetMoreIssues(textEditingController.text, pagenum));
      }

      if (pilihan == "REPOSITORIES") {
        fetchingDataSnackbar();
        pagenum++;
        isloading = true;

        final repoBloc = context.read<RepoBloc>();
        repoBloc.add(GetMoreRepositories(textEditingController.text, pagenum));
      }
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

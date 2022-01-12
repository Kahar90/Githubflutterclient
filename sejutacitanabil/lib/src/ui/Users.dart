import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/src/provider.dart';
import 'package:sejutacitanabil/src/bloc/repo_bloc.dart';
import 'package:sejutacitanabil/src/globals.dart';
import 'package:sejutacitanabil/src/models/repoUser.dart';
import 'package:sejutacitanabil/src/ui/app.dart';
import 'package:transparent_image/transparent_image.dart';

class RepoList extends StatefulWidget {
  RepoList(this.query);
  String query = "";
  @override
  State<RepoList> createState() => _RepoListState();
}

class _RepoListState extends State<RepoList> {
  //late repoUser Userdata = repoUser();

  int pagenum = 1;
  var globals = Globals();
  bool isloading = false;
  List<dynamic>? data = [];
  List<dynamic>? imagelink = [];
  ScrollController _scrollController = ScrollController(keepScrollOffset: true);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RepoBloc, RepoState>(
      listener: (context, state) {
        _scrollController.addListener(() {
          if (_scrollController.position.maxScrollExtent ==
                  _scrollController.offset &&
              !isloading) {
            pagenum++;
            isloading = true;
            // final repoBloc = context.read<RepoBloc>();
            setState(() {});
            // print(widget.query);
            // repoBloc.add(GetMoreUsers(widget.query, pagenum));
            final repoBloc = context.read<RepoBloc>();
            repoBloc.add(GetMoreUsers(globals.queryUsers.toString(), pagenum));

            print("pagenum: $pagenum");
          }
        });

        // if (state is Requestmoreusers) {
        //   final repoBloc = context.read<RepoBloc>();
        //   repoBloc.add(GetMoreUsers(globals.));
        // }
        if (state is MoreRepoUserLoaded) {
          //print(state.Userdata.items);
          //data?.add(state.Userdata.items);
          //isloading = true;
          print(pagenum);
          int? count = state.Userdata.items?.length;

          for (var i = 0; i < count!; i++) {
            data?.add(state.Userdata.items?[i]);
            imagelink?.add(state.Userdata.items?[i]);
          }
          print("After data added: " + "${data?.length}");

          setState(() {});
          isloading = false;
        }
        if (state is RepoUserLoaded) {
          data?.clear();
          pagenum = 0;
          int? count = state.Userdata.items?.length;
          for (var i = 0; i < count!; i++) {
            data?.add(state.Userdata.items?[i]);
            imagelink?.add(state.Userdata.items?[i]);
          }
        }
        if (state is ClearList) {
          data?.clear();
          pagenum = 0;
        }
        if (state is Error) {
          print("Error REceived!");
          pagenum--;
          isloading = false;
        }
      },
      builder: (context, state) {
        return ListView.builder(
          controller: _scrollController,
          itemCount: data?.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 60,
              child: Card(
                child: Row(
                  children: [
                    FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: "${imagelink?[index].avatarUrl}"),
                    Text(data?[index].login ?? ""),
                  ],
                ),
              ),
            );
          },
        );
        // return Column(
        //   children: [
        //     ListView.builder(
        //       controller: _scrollController,
        //       itemCount: data?.length,
        //       itemBuilder: (BuildContext context, int index) {
        //         return ListTile(
        //           title: Text(data?[index].login ?? ""),
        //         );
        //       },
        //     ),
        //     // isloading
        //     //     ? Container(height: 50, child: CircularProgressIndicator())
        //     //     : Container(
        //     //         height: 10,
        //     //       )
        //   ],
        // );

        // return CustomScrollView(
        //   controller: _scrollController, slivers: [
        //   SliverGrid(
        //       delegate: SliverChildBuilderDelegate(
        //         (c, i) => ListTile(
        //             title: Text(data?[i].login ?? ""),
        //           )),
        //       gridDelegate:
        //           SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2)),
        //   SliverToBoxAdapter(
        //     child: CircularProgressIndicator(),
        //   )
        // ]);
      },
    );
  }
}

// class RepoList extends StatelessWidget {
//   RepoList(this.Userdata);
//   repoUser Userdata;
//   ScrollController _scrollController = ScrollController();

//   Widget build(BuildContext context) {
//     int pagenum = 0;
//     int itemcount = 30;
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         print("add data");
//         final repoBloc = context.read<RepoBloc>();
//         repoBloc.add(GetUsers("Kahar", pagenum++));
//         print("counter: " + pagenum.toString());
//         itemcount += 30;
//       }
//     });
//     return BlocConsumer<RepoBloc, RepoState>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         if (state is RepoUserLoaded) {
//           return ListView.builder(
//             scrollDirection: Axis.vertical,
//             shrinkWrap: true,
//             controller: _scrollController,
//             itemCount: itemcount,
//             itemBuilder: (BuildContext context, int index) {
//               return Card(
//                 child: Container(
//                   height: 40,
//                   child: Row(
//                     children: [
//                       Text(Userdata.items?[index].login ?? "-"),
//                       SizedBox(
//                         width: 20,
//                       ),
//                       Text(Userdata.totalCount.toString())
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         }
//         return CircularProgressIndicator();
//       },
//     );
//   }
// }

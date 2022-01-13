// ignore_for_file: sized_box_for_whitespace

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:sejutacitanabil/src/bloc/repo_bloc.dart';
import 'package:sejutacitanabil/src/globals.dart';

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  late PreferredSize child;

  SliverAppBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

PreferredSize firstHeader(
    BuildContext context,
    TextEditingController textEditingController,
    VoidCallback searchQuery,
    VoidCallback getDataAccordingToCategories,
    VoidCallback clearTextController) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(40),
    child: Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          IconButton(
              onPressed: () {
                clearTextController();
              },
              icon: const Icon(
                Icons.clear,
                color: Colors.lightBlue,
              )),
          Flexible(
            child: Container(
              height: 28,
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextField(
                onChanged: (value) {
                  searchQuery();
                },
                controller: textEditingController,
                decoration: const InputDecoration(
                    iconColor: Colors.white,
                    hoverColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    focusColor: Colors.white,
                    fillColor: Colors.white),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                getDataAccordingToCategories();
              },
              icon: const Icon(
                Icons.search,
                color: Colors.lightBlue,
              ))
        ],
      ),
    ),
  );
}

PreferredSize secondHeader(
  BuildContext context,
  String? pilihan,
  String? tempcheck,
  VoidCallback changeViewStateLoading,
  VoidCallback changeViewStateIndex,
) {
  var globals = Globals();
  return PreferredSize(
    preferredSize: const Size.fromHeight(80),
    child: Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20))),
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          CustomRadioButton(
            enableShape: true,
            //spacing: 100,
            width: 110,
            height: 26,
            defaultSelected: "USERS",
            selectedColor: Theme.of(context).colorScheme.secondary,
            elevation: 0,
            absoluteZeroSpacing: true,
            unSelectedColor: Theme.of(context).canvasColor,
            buttonLables: const ['Users', 'Issues', 'Repositories'],
            buttonValues: const ['USERS', 'ISSUES', 'REPOSITORIES'],
            buttonTextStyle: const ButtonTextStyle(
                textStyle: TextStyle(fontSize: 12),
                selectedColor: Colors.white,
                unSelectedColor: Colors.lightBlue),
            radioButtonValue: (value) {
              // pilihan = value.toString();
              // globals.Pilihan = value.toString();
              print(value);
              if (value == "USERS") {
                final repobloc = context.read<RepoBloc>();
                repobloc.add(ChangeCategoriesEvent(value.toString()));
              }
              if (value == "ISSUES") {
                final repobloc = context.read<RepoBloc>();
                repobloc.add(ChangeCategoriesEvent(value.toString()));
              }
              if (value == "REPOSITORIES") {
                final repobloc = context.read<RepoBloc>();
                repobloc.add(ChangeCategoriesEvent(value.toString()));
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          CustomRadioButton(
            defaultSelected: "LAZY",
            enableShape: true,
            width: 120,
            height: 25,
            elevation: 0,
            buttonLables: const ["Lazy Loading", "Index"],
            buttonValues: const ["LAZY", "INDEX"],
            unSelectedColor: Colors.white,
            selectedColor: Colors.lightBlue,
            buttonTextStyle: const ButtonTextStyle(
                unSelectedColor: Colors.lightBlue,
                textStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                )),
            radioButtonValue: (value) {
              final repobloc = context.read<RepoBloc>();
              print(pilihan);
              if (value == "LAZY") {
                final repobloc = context.read<RepoBloc>();
                repobloc.add(ChangetoLazyLoading(pilihan.toString()));
              }
              if (value == "INDEX") {
                final repobloc = context.read<RepoBloc>();
                repobloc.add(ChangeToIndex(pilihan.toString()));
              }
            },
          )
        ],
      ),
    ),
  );
}

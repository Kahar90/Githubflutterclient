import 'dart:core';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:sejutacitanabil/src/bloc/repo_bloc.dart';

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

//First Header refers to the first persistent header you see, the one that stores the searchbox
class FirstHeader extends StatelessWidget {
  const FirstHeader(
    this.context,
    this.textEditingController,
    this.searchQuery,
    this.getDataAccordingToCategories,
    this.clearTextController,
  );
  final BuildContext context;
  final TextEditingController textEditingController;
  final VoidCallback searchQuery;
  final VoidCallback getDataAccordingToCategories;
  final VoidCallback clearTextController;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: Colors.white),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
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
            SizedBox(
              height: 28,
              width: MediaQuery.of(context).size.width * 0.65,
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
}

//Second Header is right below it, storing the radiobuttons that controls the state of the program
class SecondHeader extends StatelessWidget {
  const SecondHeader(this.context, this.pilihan, this.tempcheck,
      this.changeViewStateLoading, this.changeViewStateIndex);
  final BuildContext context;
  final String? pilihan;
  final String? tempcheck;
  final VoidCallback changeViewStateLoading;
  final VoidCallback changeViewStateIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
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

              if (value == "LAZY") {
                changeViewStateLoading();
                repobloc.add(ChangetoLazyLoading(pilihan.toString()));
              }
              if (value == "INDEX") {
                changeViewStateIndex();
                repobloc.add(ChangeToIndex(pilihan.toString()));
              }
            },
          )
        ],
      ),
    );
  }
}

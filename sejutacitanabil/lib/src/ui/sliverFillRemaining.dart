import 'package:flutter/material.dart';

Widget sliverFillRemaining(
  bool isloading,
  bool index,
  int pagenum,
  VoidCallback getMoreDataAccordingToCategories,
  VoidCallback goBackOnePage,
  VoidCallback goNextOnePageChangeScrollPos,
) {
  return SliverFillRemaining(
    hasScrollBody: false,
    child: Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  if (!isloading) {
                    goBackOnePage();
                  }
                },
                icon: const Icon(Icons.arrow_back_ios),
                color: Colors.lightBlue,
              ),
              Text(pagenum.toString()),
              IconButton(
                onPressed: () {
                  if (!isloading) {
                    getMoreDataAccordingToCategories();
                    goNextOnePageChangeScrollPos();
                  }
                },
                icon: const Icon(Icons.arrow_forward_ios),
                color: Colors.lightBlue,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

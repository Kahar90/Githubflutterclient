import 'package:flutter/material.dart';

import 'package:sejutacitanabil/src/ui/Widgets.dart';

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
          isloading && index
              ? Column(
                  children: [
                    loading(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () {
                              if (!isloading) {
                                //goBackOnePage();
                              }
                            },
                            icon: const Icon(Icons.arrow_back_ios)),
                        //Text(pagenum.toString()),
                        IconButton(
                            onPressed: () {
                              if (!isloading) {
                                // getMoreDataAccordingToCategories();
                                //goNextOnePage();
                              }
                            },
                            icon: const Icon(Icons.arrow_forward_ios)),
                      ],
                    )
                  ],
                )
              : Row(
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
                    //Text(pagenum.toString()),
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

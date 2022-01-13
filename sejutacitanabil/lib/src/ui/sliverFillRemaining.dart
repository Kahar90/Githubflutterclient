import 'package:flutter/material.dart';

import 'package:sejutacitanabil/src/ui/Widgets.dart';

Widget sliverFillRemaining(bool isloading, bool index, int pagenum,
    VoidCallback getMoreDataAccordingToCategories) {
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
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_back_ios)),
                        Text(pagenum.toString()),
                        IconButton(
                            onPressed: () {
                              getMoreDataAccordingToCategories();
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
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_back_ios)),
                    Text(pagenum.toString()),
                    IconButton(
                        onPressed: () {
                          getMoreDataAccordingToCategories();
                        },
                        icon: const Icon(Icons.arrow_forward_ios)),
                  ],
                ),
        ],
      ),
    ),
  );
}

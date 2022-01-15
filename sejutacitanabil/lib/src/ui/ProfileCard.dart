// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

/* Widget for profile card */
Widget alertDialog(BuildContext context, dynamic data, dynamic state,
    bool indexstate, int page) {
  return AlertDialog(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
    title: Container(
      height: 150,
      width: 150,
      child: !indexstate
          ? FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: "${data?[state.index].avatarUrl}")
          : FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: "${data?[page][state.index].avatarUrl}"),
    ),
    content: Container(
      height: MediaQuery.of(context).size.height * 0.26,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              state.repoProfileInfo.login ?? "",
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 7,
            ),
            Text(state.repoProfileInfo.name ?? ""),
            const SizedBox(
              height: 2,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: state.repoProfileInfo.bio != "null"
                  ? Text(
                      state.repoProfileInfo.bio ?? "",
                      textAlign: TextAlign.center,
                    )
                  : Container(),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: state.repoProfileInfo.email != "null"
                  ? Text(state.repoProfileInfo.email ?? "")
                  : Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_pin,
                  color: Colors.grey,
                  size: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(state.repoProfileInfo.location ?? "-"),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Card(
                elevation: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.people_alt,
                      color: Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${state.repoProfileInfo.followers.toString()} followers",
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.circle,
                      size: 5,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      " ${state.repoProfileInfo.following.toString()} following",
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

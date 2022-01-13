// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

Widget dataCardUser(List<dynamic>? data, index) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Container(
      height: 70,
      child: Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          Container(
            height: 65,
            width: 65,
            child: ClipOval(
              child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: "${data?[index].avatarUrl}"),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(data?[index].login ?? ""),
        ],
      ),
    ),
  );
}

Widget dataCardIssues(BuildContext context, List<dynamic>? data,
    List<dynamic>? dataDate, index, RegExp expreg) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Row(
              children: [
                data?[index].state == "closed"
                    ? Container(
                        height: 30,
                        width: 30,
                        child: Icon(Icons.check_circle_outlined,
                            size: 25, color: Colors.purple[900]))
                    : Container(
                        height: 30,
                        width: 30,
                        child: const Icon(Icons.build_circle_outlined,
                            size: 25, color: Colors.green),
                      ),
                Text(
                  data?[index].state,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(
                    Icons.insert_comment_outlined,
                    size: 19,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(data?[index].comments.toString() ?? ""),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            )
          ],
        ),
        Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width * 0.72,
              child: Text(
                data?[index].title ?? "",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              //width: MediaQuery.of(context).size.width * 0.5,
              child: Text(
                "Updated at ${expreg.stringMatch(data?[index].updatedAt)}",
                textAlign: TextAlign.left,
                //data?[index].updatedAt ?? "",
                // data?[index].updatedAt.

                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ],
    ),
  );
}

Widget dataCardRepositories(
    BuildContext context, List<dynamic>? repodata, index) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Container(
      height: 70,
      child: Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          Container(
            width: 50,
            height: 50,
            child: ClipOval(
              child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: "${repodata?[index].owner.avatarUrl}"),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: Text(
              repodata?[index].name ?? "data kosong",
            ),
          ),
        ],
      ),
    ),
  );
}

Widget loading() {
  return const Center(widthFactor: 20, child: CircularProgressIndicator());
}

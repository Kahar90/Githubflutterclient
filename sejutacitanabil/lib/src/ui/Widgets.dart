// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

Widget dataCardUser(
    dynamic data, int index, int pagecountusers, bool indexstate) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Container(
      height: 85,
      child: Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          Container(
            padding: const EdgeInsets.only(left: 1),
            height: 70,
            width: 70,
            child: ClipOval(
              child: !indexstate
                  ? FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: "${data?[index].avatarUrl}")
                  : FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: "${data?[pagecountusers]?[index].avatarUrl}"),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          !indexstate
              ? Text(data?[index].login ?? "")
              : Text(data?[pagecountusers][index].login ?? ""),
        ],
      ),
    ),
  );
}

Widget dataCardIssues(
    BuildContext context,
    dynamic data,
    List<dynamic>? dataDate,
    index,
    int pageCountControl,
    RegExp expreg,
    bool indexstate) {
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
                !indexstate
                    ? (data?[index].state == "closed")
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
                          )
                    : (data?[pageCountControl][index].state == "closed")
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
                !indexstate
                    ? Text(
                        data?[index].state,
                        style: const TextStyle(fontSize: 13),
                      )
                    : Text(
                        data?[pageCountControl][index].state,
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
                  !indexstate
                      ? Text(data?[index].comments.toString() ?? "")
                      : Text(
                          data?[pageCountControl][index].comments.toString() ??
                              ""),
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
              child: !indexstate
                  ? Text(
                      data?[index].title ?? "",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    )
                  : Text(
                      data?[pageCountControl][index].title ?? "",
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
              child: !indexstate
                  ? Text(
                      "Updated at ${expreg.stringMatch(data?[index].updatedAt)}",
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 12),
                    )
                  : Text(
                      "Updated at ${expreg.stringMatch(data?[pageCountControl][index].updatedAt)}",
                      textAlign: TextAlign.left,
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

Widget dataCardRepositories(BuildContext context, int pagecountcontrol,
    dynamic repodata, int index, bool indexstate) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Container(
      height: 85,
      child: Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          Container(
            width: 70,
            height: 70,
            child: ClipOval(
              child: !indexstate
                  ? FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: "${repodata?[index].owner.avatarUrl}")
                  : FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image:
                          "${repodata?[pagecountcontrol][index].owner.avatarUrl}"),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            child: !indexstate
                ? Text(
                    repodata?[index].name ?? "",
                  )
                : Text(
                    repodata?[pagecountcontrol][index].name ?? "",
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

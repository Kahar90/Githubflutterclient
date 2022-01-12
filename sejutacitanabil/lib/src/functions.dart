import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sejutacitanabil/src/models/repoIssues.dart';
import 'package:sejutacitanabil/src/models/repoRepos.dart';

import 'models/repoUser.dart';

class Functions {
  Future<repoUser> getUser(String query, int pagenum) async {
    String link =
        "https://api.github.com/search/users?q=" + query + "&page=$pagenum";
    // var response = await Dio().get(
    //     "https://api.github.com/search/users?q=" + "$query" + "&page=$pagenum");
    var response = await Dio().get(Uri.parse(link).toString());
    var UserData = repoUser.fromJson(jsonDecode(response.toString()));
    print(
        "https://api.github.com/search/users?q=" + "$query" + "&page=$pagenum");
    print("Function called with $query and $pagenum");
    print("data dari function :" + "${UserData.items?.length}");
    return UserData;
  }

  Future<RepoIssues> getIssues(String query, int pagenum) async {
    String link =
        "https://api.github.com/search/issues?q=" + query + "&page=$pagenum";

    var response = await Dio().get(Uri.parse(link).toString());
    print(Uri.parse(link).toString());

    var IssuesData = RepoIssues.fromJson(jsonDecode(response.toString()));

    print("https://api.github.com/search/issues?q=" +
        "$query" +
        "&page=$pagenum");
    print("Function called with $query and $pagenum");

    print(
        "data dari function issues total count :" + "${IssuesData.totalCount}");

    return IssuesData;
  }

  Future<repoRepos> getRepos(String query, int pagenum) async {
    String link = "https://api.github.com/search/repositories?q=" +
        query +
        "&page=$pagenum";

    try {
      var response = await Dio().get(Uri.parse(link).toString());
      print(Uri.parse(link).toString());

      var ReposData = repoRepos.fromJson(jsonDecode(response.toString()));

      var testdata = Owner.fromJson(jsonDecode(response.toString()));

      print("https://api.github.com/search/repositories?q=" +
          "$query" +
          "&page=$pagenum");
      print("Function getRepos called with $query and $pagenum");
      print(
          "data dari function Repos total count :" + "${ReposData.totalCount}");
      print("data dari function Repos avatarurl :" +
          "${ReposData.items?.length}");
      //print({ReposData.owner});
      return ReposData;
    } catch (e) {
      print(e);
      repoRepos Reposdata = repoRepos();
      return Reposdata;
    }
  }
}

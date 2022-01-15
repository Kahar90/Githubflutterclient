// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sejutacitanabil/src/models/repo_issues.dart';
import 'package:sejutacitanabil/src/models/repoProfileInfo.dart';
import 'package:sejutacitanabil/src/models/repoRepos.dart';
import 'models/repoUser.dart';

/* Stores functions for API calls, HTTP calls are done by using dio package */

class Functions {
  Future<RepoUser> getUser(String query, int pagenum) async {
    /* Get Data User */
    String link =
        "https://api.github.com/search/users?q=" + query + "&page=$pagenum";

    var response = await Dio().get(Uri.parse(link).toString());
    var userData = RepoUser.fromJson(jsonDecode(response.toString()));

    print("function get user called with query $query and pagenum $pagenum");

    return userData;
  }

  Future<RepoIssues> getIssues(String query, int pagenum) async {
    /* Get Data Issues */
    String link =
        "https://api.github.com/search/issues?q=" + query + "&page=$pagenum";

    var response = await Dio().get(Uri.parse(link).toString());

    var issuesData = RepoIssues.fromJson(jsonDecode(response.toString()));

    print("function get issues called with query $query and pagenum $pagenum");

    return issuesData;
  }

  Future<RepoRepos> getRepos(String query, int pagenum) async {
    /* Get Data Repositories */
    String link = "https://api.github.com/search/repositories?q=" +
        query +
        "&page=$pagenum";
    var response = await Dio().get(Uri.parse(link).toString());

    var reposData = RepoRepos.fromJson(jsonDecode(response.toString()));

    print("function get repos called with query $query and pagenum $pagenum");

    return reposData;
  }

  Future<RepoProfileInfo> getProfileInfo(String? query) async {
    /* Get Data for Specific Profile */
    var response = await Dio().get(Uri.parse(query.toString()).toString());

    var profileData = RepoProfileInfo.fromJson(jsonDecode(response.toString()));

    print("function get profile called with query $query");

    return profileData;
  }
}

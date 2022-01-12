import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:sejutacitanabil/src/functions.dart';
import 'package:sejutacitanabil/src/models/repoIssues.dart';
import 'package:sejutacitanabil/src/models/repoRepos.dart';
import 'package:sejutacitanabil/src/models/repoUser.dart';

part 'repo_event.dart';
part 'repo_state.dart';

class RepoBloc extends Bloc<RepoEvent, RepoState> {
  final Functions _functions;
  RepoBloc(this._functions) : super(RepoInitial()) {
    on<GetUsers>(
      (event, emit) async {
        emit(RepoLoading());
        final Userdata =
            await _functions.getUser(event.UserName, event.pagenumber);
        emit(RepoUserLoaded(Userdata));
      },
    );
    on<GetMoreUsers>((event, emit) async {
      try {
        final Userdata =
            await _functions.getUser(event.UserName, event.pagenumber);
        emit(MoreRepoUserLoaded(Userdata, event.UserName));
      } catch (e) {
        emit(HTTPError());
      }
      //String query = event.UserName;
    });
    on<GetIssues>((event, emit) async {
      final issuesData =
          await _functions.getIssues(event.query, event.pagenumber);
      emit(RepoIssuesLoaded(issuesData));
    });
    on<GetMoreIssues>((event, emit) async {
      try {
        final issuesData =
            await _functions.getIssues(event.query, event.pagenumber);
        emit(MoreRepoIssuesLoaded(issuesData, event.query));
      } catch (e) {
        emit(HTTPError());
      }
      //String query = event.UserName;
    });
    on<GetRepositories>((event, emit) async {
      try {
        final reposData =
            await _functions.getRepos(event.query, event.pagenumber);
        emit(RepoReposLoaded(reposData));
      } catch (e) {
        print("dugaan?");
        print(e);
        emit(HTTPError());
      }
    });
    on<GetMoreRepositories>((event, emit) async {
      try {
        final reposData =
            await _functions.getRepos(event.query, event.pagenumber);
        emit(MoreRepoReposLoaded(reposData, event.query));
      } catch (e) {
        emit(HTTPError());
      }
    });
    on<ChangeCategoriesEvent>((event, emit) {
      emit(ClearList());
      emit(InitiateChange(event.categories));
    });
    on<DeleteList>((event, emit) {
      emit(ClearList());
    });
    on<EmptyDataEventUsers>((event, emit) {
      emit(EmptyDataUsers());
    });
    on<EmptyDataEventIssues>((event, emit) {
      emit(EmptyDataIssues());
    });
    on<EmptyDataEventRepos>((event, emit) {
      emit(EmptyDataRepos());
    });
  }
}

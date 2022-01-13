import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sejutacitanabil/src/functions.dart';
import 'package:sejutacitanabil/src/models/repo_issues.dart';
import 'package:sejutacitanabil/src/models/repoProfileInfo.dart';
import 'package:sejutacitanabil/src/models/repoRepos.dart';
import 'package:sejutacitanabil/src/models/repoUser.dart';

part 'repo_event.dart';
part 'repo_state.dart';

class RepoBloc extends Bloc<RepoEvent, RepoState> {
  final Functions _functions;
  RepoBloc(this._functions) : super(const RepoInitial()) {
    //USERS
    on<GetUsers>(
      (event, emit) async {
        try {
          emit(const RepoLoadingUsers());
          final userdata =
              await _functions.getUser(event.userName, event.pagenumber);
          emit(RepoUserLoaded(userdata));
        } catch (e) {
          emit(const HTTPErrorUsers());
        }
      },
    );
    on<GetMoreUsers>((event, emit) async {
      try {
        final userdata =
            await _functions.getUser(event.userName, event.pagenumber);
        emit(MoreRepoUserLoaded(userdata, event.userName));
      } catch (e) {
        emit(const HTTPErrorUsers());
      }
    });
    on<GetProfileInfo>((event, emit) async {
      try {
        final profileInfoData = await _functions.getProfileInfo(event.query);
        emit(RepoProfileLoaded(event.index, profileInfoData));
      } catch (e) {
        emit(const HTTPErrorUsers());
      }
    });
    //ISSUES
    on<GetIssues>((event, emit) async {
      emit(const RepoLoadingIssues());
      try {
        final issuesData =
            await _functions.getIssues(event.query, event.pagenumber);
        emit(RepoIssuesLoaded(issuesData));
      } catch (e) {
        emit(const HTTPErrorIssues());
      }
    });
    on<GetMoreIssues>((event, emit) async {
      try {
        final issuesData =
            await _functions.getIssues(event.query, event.pagenumber);
        emit(MoreRepoIssuesLoaded(issuesData, event.query));
      } catch (e) {
        emit(const HTTPErrorIssues());
      }
    });
    //REPOS
    on<GetRepositories>((event, emit) async {
      emit(const RepoLoadingRepos());
      try {
        final reposData =
            await _functions.getRepos(event.query, event.pagenumber);
        emit(RepoReposLoaded(reposData));
      } catch (e) {
        emit(const HTTPErrorRepos());
      }
    });
    on<GetMoreRepositories>((event, emit) async {
      try {
        final reposData =
            await _functions.getRepos(event.query, event.pagenumber);
        emit(MoreRepoReposLoaded(reposData, event.query));
      } catch (e) {
        emit(const HTTPErrorRepos());
      }
    });
    //MISC
    on<ChangeCategoriesEvent>((event, emit) {
      emit(const ClearList());
      emit(InitiateChange(event.categories));
    });
    on<ChangetoLazyLoading>((event, emit) {
      //emit(const LazyLoadingState());
      if (event.categories == "USERS") {
        emit(InitiateChangeViewUsersLoading(event.categories));
        print("InitiateChangeViewUsersLoading");
      }
      if (event.categories == "ISSUES") {
        emit(InitiateChangeViewIssuesLoading(event.categories));
        print("InitiateChangeViewIssuesLoading");
      }
      if (event.categories == "REPOSITORIES") {
        emit(InitiateChangeViewReposLoading(event.categories));
        print("InitiateChangeViewReposLoading");
      }
    });
    on<ChangeToIndex>((event, emit) {
      // emit(const IndexState());
      if (event.categories == "USERS") {
        emit(InitiateChangeViewUsersIndex(event.categories));
        print("InitiateChangeViewUsersIndex");
      }
      if (event.categories == "ISSUES") {
        emit(InitiateChangeViewIssuesIndex(event.categories));
        print("InitiateChangeViewIssuesIndex");
      }
      if (event.categories == "REPOSITORIES") {
        emit(InitiateChangeViewReposIndex(event.categories));
        print("InitiateChangeViewReposIndex");
      }
    });
    on<DeleteList>((event, emit) {
      emit(const ClearList());
    });
    on<EmptyDataEventUsers>((event, emit) {
      emit(const EmptyDataUsers());
    });
    on<EmptyDataEventIssues>((event, emit) {
      emit(const EmptyDataIssues());
    });
    on<EmptyDataEventRepos>((event, emit) {
      emit(const EmptyDataRepos());
    });
  }
}

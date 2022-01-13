part of 'repo_bloc.dart';

@immutable
abstract class RepoState {
  const RepoState();
}

class RepoInitial extends RepoState {
  const RepoInitial();
}

class RepoLoading extends RepoState {
  const RepoLoading();
}

class RepoLoadingUsers extends RepoState {
  const RepoLoadingUsers();
}

class RepoLoadingIssues extends RepoState {
  const RepoLoadingIssues();
}

class RepoLoadingRepos extends RepoState {
  const RepoLoadingRepos();
}

class RepoUserLoaded extends RepoState {
  final RepoUser userdata;
  const RepoUserLoaded(this.userdata);
}

class RepoProfileLoaded extends RepoState {
  final int index;
  final RepoProfileInfo repoProfileInfo;
  const RepoProfileLoaded(this.index, this.repoProfileInfo);
}

class MoreRepoUserLoaded extends RepoState {
  final RepoUser userdata;
  final String query;
  const MoreRepoUserLoaded(this.userdata, this.query);
}

class RepoIssuesLoaded extends RepoState {
  final RepoIssues issuesData;
  const RepoIssuesLoaded(this.issuesData);
}

class MoreRepoIssuesLoaded extends RepoState {
  final RepoIssues issuesData;
  final String query;
  const MoreRepoIssuesLoaded(this.issuesData, this.query);
}

class RepoReposLoaded extends RepoState {
  final RepoRepos reposData;
  const RepoReposLoaded(this.reposData);
}

class MoreRepoReposLoaded extends RepoState {
  final RepoRepos reposData;
  final String query;
  const MoreRepoReposLoaded(this.reposData, this.query);
}

class EmptyDataIssues extends RepoState {
  const EmptyDataIssues();
}

class EmptyDataUsers extends RepoState {
  const EmptyDataUsers();
}

class EmptyDataRepos extends RepoState {
  const EmptyDataRepos();
}

class ClearList extends RepoState {
  const ClearList();
}

class HTTPError extends RepoState {
  const HTTPError();
}

class HTTPErrorUsers extends RepoState {
  const HTTPErrorUsers();
}

class HTTPErrorIssues extends RepoState {
  const HTTPErrorIssues();
}

class HTTPErrorRepos extends RepoState {
  const HTTPErrorRepos();
}

class Error extends RepoState {
  const Error();
}

class ChangeCategories extends RepoState {
  const ChangeCategories();
}

class InitiateChange extends RepoState {
  final String whattodo;
  const InitiateChange(this.whattodo);
}

class InitiateChangeViewUsersLoading extends RepoState {
  final String whattodo;
  const InitiateChangeViewUsersLoading(this.whattodo);
}

class InitiateChangeViewIssuesLoading extends RepoState {
  final String whattodo;
  const InitiateChangeViewIssuesLoading(this.whattodo);
}

class InitiateChangeViewReposLoading extends RepoState {
  final String whattodo;
  const InitiateChangeViewReposLoading(this.whattodo);
}

class InitiateChangeViewUsersIndex extends RepoState {
  final String whattodo;
  const InitiateChangeViewUsersIndex(this.whattodo);
}

class InitiateChangeViewIssuesIndex extends RepoState {
  final String whattodo;
  const InitiateChangeViewIssuesIndex(this.whattodo);
}

class InitiateChangeViewReposIndex extends RepoState {
  final String whattodo;
  const InitiateChangeViewReposIndex(this.whattodo);
}

class LazyLoadingState extends RepoState {
  const LazyLoadingState();
}

class IndexState extends RepoState {
  const IndexState();
}

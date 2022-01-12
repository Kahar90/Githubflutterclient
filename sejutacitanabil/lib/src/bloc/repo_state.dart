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

class RepoUserLoaded extends RepoState {
  final repoUser Userdata;
  const RepoUserLoaded(this.Userdata);
}

class MoreRepoUserLoaded extends RepoState {
  final repoUser Userdata;
  final String query;
  const MoreRepoUserLoaded(this.Userdata, this.query);
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
  final repoRepos reposData;
  const RepoReposLoaded(this.reposData);
}

class MoreRepoReposLoaded extends RepoState {
  final repoRepos reposData;
  final String query;
  const MoreRepoReposLoaded(this.reposData, this.query);
}

class EmptyDataIssues extends RepoState {
  EmptyDataIssues();
}

class EmptyDataUsers extends RepoState {
  EmptyDataUsers();
}

class EmptyDataRepos extends RepoState {
  EmptyDataRepos();
}

class ClearList extends RepoState {
  ClearList();
}

class HTTPError extends RepoState {
  HTTPError();
}

class Error extends RepoState {
  Error();
}

class ChangeCategories extends RepoState {
  ChangeCategories();
}

class InitiateChange extends RepoState {
  final String whattodo;
  InitiateChange(this.whattodo);
}

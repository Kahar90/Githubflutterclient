part of 'repo_bloc.dart';

@immutable
abstract class RepoEvent {}

class GetUsers extends RepoEvent {
  final String userName;
  final int pagenumber;

  GetUsers(this.userName, this.pagenumber);
}

class GetProfileInfo extends RepoEvent {
  final String? query;
  final int index;

  GetProfileInfo(this.query, this.index);
}

class GetMoreUsers extends RepoEvent {
  final String userName;
  final int pagenumber;

  GetMoreUsers(this.userName, this.pagenumber);
}

class GetIssues extends RepoEvent {
  final String query;
  final int pagenumber;

  GetIssues(this.query, this.pagenumber);
}

class GetMoreIssues extends RepoEvent {
  final String query;
  final int pagenumber;

  GetMoreIssues(this.query, this.pagenumber);
}

class GetRepositories extends RepoEvent {
  final String query;
  final int pagenumber;
  GetRepositories(this.query, this.pagenumber);
}

class GetMoreRepositories extends RepoEvent {
  final String query;
  final int pagenumber;
  GetMoreRepositories(this.query, this.pagenumber);
}

class EmptyDataEventIssues extends RepoEvent {
  EmptyDataEventIssues();
}

class EmptyDataEventUsers extends RepoEvent {
  EmptyDataEventUsers();
}

class EmptyDataEventRepos extends RepoEvent {
  EmptyDataEventRepos();
}

class DeleteList extends RepoEvent {
  DeleteList();
}

class ChangeCategoriesEvent extends RepoEvent {
  final String categories;
  ChangeCategoriesEvent(this.categories);
}

class ChangetoLazyLoading extends RepoEvent {
  final String categories;
  ChangetoLazyLoading(this.categories);
}

class ChangeToIndex extends RepoEvent {
  final String categories;
  ChangeToIndex(this.categories);
}

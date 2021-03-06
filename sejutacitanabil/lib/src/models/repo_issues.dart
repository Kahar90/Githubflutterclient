class RepoIssues {
  /* Models for ISSUES API Calls */
  int? totalCount;
  bool? incompleteResults;
  List<Items>? items;

  RepoIssues({this.totalCount, this.incompleteResults, this.items});

  RepoIssues.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    incompleteResults = json['incomplete_results'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_count'] = totalCount;
    data['incomplete_results'] = incompleteResults;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? url;
  String? repositoryUrl;
  String? labelsUrl;
  String? commentsUrl;
  String? eventsUrl;
  String? htmlUrl;
  int? id;
  String? nodeId;
  int? number;
  String? title;
  String? state;
  bool? locked;
  int? comments;
  String? createdAt;
  String? updatedAt;
  String? closedAt;
  String? authorAssociation;
  String? body;
  String? timelineUrl;
  double? score;

  Items(
      {this.url,
      this.repositoryUrl,
      this.labelsUrl,
      this.commentsUrl,
      this.eventsUrl,
      this.htmlUrl,
      this.id,
      this.nodeId,
      this.number,
      this.title,
      this.state,
      this.locked,
      this.comments,
      this.createdAt,
      this.updatedAt,
      this.closedAt,
      this.authorAssociation,
      this.body,
      this.timelineUrl,
      this.score});

  Items.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    repositoryUrl = json['repository_url'];
    labelsUrl = json['labels_url'];
    commentsUrl = json['comments_url'];
    eventsUrl = json['events_url'];
    htmlUrl = json['html_url'];
    id = json['id'];
    nodeId = json['node_id'];
    number = json['number'];
    title = json['title'];
    state = json['state'];
    locked = json['locked'];
    comments = json['comments'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    closedAt = json['closed_at'];
    authorAssociation = json['author_association'];
    body = json['body'];
    timelineUrl = json['timeline_url'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['repository_url'] = repositoryUrl;
    data['labels_url'] = labelsUrl;
    data['comments_url'] = commentsUrl;
    data['events_url'] = eventsUrl;
    data['html_url'] = htmlUrl;
    data['id'] = id;
    data['node_id'] = nodeId;
    data['number'] = number;
    data['title'] = title;
    data['state'] = state;
    data['locked'] = locked;
    data['comments'] = comments;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['closed_at'] = closedAt;
    data['author_association'] = authorAssociation;
    data['body'] = body;
    data['timeline_url'] = timelineUrl;
    data['score'] = score;
    return data;
  }
}

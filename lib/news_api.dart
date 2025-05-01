class NewsApi {
  String? status;
  int? totalResults;
  List<Results>? results;
  String? nextPage;

  NewsApi({this.status, this.totalResults, this.results, this.nextPage});

  NewsApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResults = json['totalResults'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
    nextPage = json['nextPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['totalResults'] = this.totalResults;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    data['nextPage'] = this.nextPage;
    return data;
  }
}

class Results {
  String? articleId;
  String? title;
  String? link;
  List<String>? keywords;
  List<String>? creator;
  String? description;
  String? content;
  String? pubDate;
  String? pubDateTZ;
  String? imageUrl;
  Null? videoUrl;
  String? sourceId;
  String? sourceName;
  int? sourcePriority;
  String? sourceUrl;
  String? sourceIcon;
  String? language;
  List<String>? country;
  List<String>? category;
  String? sentiment;
  String? sentimentStats;
  String? aiTag;
  String? aiRegion;
  String? aiOrg;
  bool? duplicate;

  Results(
      {this.articleId,
      this.title,
      this.link,
      this.keywords,
      this.creator,
      this.description,
      this.content,
      this.pubDate,
      this.pubDateTZ,
      this.imageUrl,
      this.videoUrl,
      this.sourceId,
      this.sourceName,
      this.sourcePriority,
      this.sourceUrl,
      this.sourceIcon,
      this.language,
      this.country,
      this.category,
      this.sentiment,
      this.sentimentStats,
      this.aiTag,
      this.aiRegion,
      this.aiOrg,
      this.duplicate});

Results.fromJson(Map<String, dynamic> json) {
  articleId = json['article_id'];
  title = json['title'];
  link = json['link'];
  keywords = (json['keywords'] as List?)?.map((e) => e.toString()).toList();
  creator = (json['creator'] as List?)?.map((e) => e.toString()).toList();
  description = json['description'];
  content = json['content'];
  pubDate = json['pubDate'];
  pubDateTZ = json['pubDateTZ'];
  imageUrl = json['image_url'];
  videoUrl = json['video_url'];
  sourceId = json['source_id'];
  sourceName = json['source_name'];
  sourcePriority = json['source_priority'];
  sourceUrl = json['source_url'];
  sourceIcon = json['source_icon'];
  language = json['language'];
  country = (json['country'] as List?)?.map((e) => e.toString()).toList();
  category = (json['category'] as List?)?.map((e) => e.toString()).toList();
  sentiment = json['sentiment'];
  sentimentStats = json['sentiment_stats'];
  aiTag = json['ai_tag'];
  aiRegion = json['ai_region'];
  aiOrg = json['ai_org'];
  duplicate = json['duplicate'];
}


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['article_id'] = this.articleId;
    data['title'] = this.title;
    data['link'] = this.link;
    data['keywords'] = this.keywords;
    data['creator'] = this.creator;
    data['description'] = this.description;
    data['content'] = this.content;
    data['pubDate'] = this.pubDate;
    data['pubDateTZ'] = this.pubDateTZ;
    data['image_url'] = this.imageUrl;
    data['video_url'] = this.videoUrl;
    data['source_id'] = this.sourceId;
    data['source_name'] = this.sourceName;
    data['source_priority'] = this.sourcePriority;
    data['source_url'] = this.sourceUrl;
    data['source_icon'] = this.sourceIcon;
    data['language'] = this.language;
    data['country'] = this.country;
    data['category'] = this.category;
    data['sentiment'] = this.sentiment;
    data['sentiment_stats'] = this.sentimentStats;
    data['ai_tag'] = this.aiTag;
    data['ai_region'] = this.aiRegion;
    data['ai_org'] = this.aiOrg;
    data['duplicate'] = this.duplicate;
    return data;
  }
}

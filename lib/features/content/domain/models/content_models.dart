/// Quote model
class Quote {
  final String id;
  final String text;
  final String author;
  final String category; // 'motivation', 'fitness', 'productivity'
  final int displayCount;
  final bool isActive;
  final List<String> tags;

  Quote({
    required this.id,
    required this.text,
    required this.author,
    required this.category,
    this.displayCount = 0,
    this.isActive = true,
    this.tags = const [],
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['_id'] as String? ?? json['id'] as String,
      text: json['text'] as String,
      author: json['author'] as String,
      category: json['category'] as String,
      displayCount: json['displayCount'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      tags: List<String>.from(json['tags'] as List<dynamic>? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'author': author,
      'category': category,
      'displayCount': displayCount,
      'isActive': isActive,
      'tags': tags,
    };
  }

  Quote copyWith({
    String? text,
    String? author,
    String? category,
  }) {
    return Quote(
      id: id,
      text: text ?? this.text,
      author: author ?? this.author,
      category: category ?? this.category,
      displayCount: displayCount,
      isActive: isActive,
      tags: tags,
    );
  }

  @override
  String toString() => 'Quote(author: $author, category: $category)';
}

/// Video model
class Video {
  final String id;
  final String title;
  final String description;
  final String videoId; // YouTube video ID
  final String embedUrl; // YouTube embed URL
  final String category; // 'motivation', 'fitness-training', 'productivity'
  final int views;
  final bool isActive;
  final List<String> tags;

  Video({
    required this.id,
    required this.title,
    required this.description,
    required this.videoId,
    required this.embedUrl,
    required this.category,
    this.views = 0,
    this.isActive = true,
    this.tags = const [],
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['_id'] as String? ?? json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      videoId: json['videoId'] as String,
      embedUrl: json['embedUrl'] as String,
      category: json['category'] as String,
      views: json['views'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      tags: List<String>.from(json['tags'] as List<dynamic>? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'videoId': videoId,
      'embedUrl': embedUrl,
      'category': category,
      'views': views,
      'isActive': isActive,
      'tags': tags,
    };
  }

  Video copyWith({
    String? title,
    String? description,
    String? category,
  }) {
    return Video(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      videoId: videoId,
      embedUrl: embedUrl,
      category: category ?? this.category,
      views: views,
      isActive: isActive,
      tags: tags,
    );
  }

  @override
  String toString() => 'Video(title: $title, views: $views)';
}

/// Content report model
class ContentReport {
  final String id;
  final String reportedBy;
  final String targetId;
  final String targetType; // 'post', 'message', 'user', 'comment'
  final String reason; // 'harassment', 'spam', 'inappropriate-content'
  final String description;
  final String status; // 'pending', 'resolved'
  final String? action; // 'content-removed', 'user-warned', 'dismissed'
  final String? notes;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  ContentReport({
    required this.id,
    required this.reportedBy,
    required this.targetId,
    required this.targetType,
    required this.reason,
    required this.description,
    required this.status,
    this.action,
    this.notes,
    required this.createdAt,
    this.resolvedAt,
  });

  bool get isPending => status == 'pending';
  bool get isResolved => status == 'resolved';

  String get reasonLabel {
    switch (reason) {
      case 'harassment':
        return 'Harassment/Bullying';
      case 'spam':
        return 'Spam';
      case 'inappropriate-content':
        return 'Inappropriate Content';
      default:
        return reason;
    }
  }

  factory ContentReport.fromJson(Map<String, dynamic> json) {
    return ContentReport(
      id: json['_id'] as String? ?? json['id'] as String,
      reportedBy: json['reportedBy'] as String,
      targetId: json['targetId'] as String,
      targetType: json['targetType'] as String,
      reason: json['reason'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      action: json['action'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.parse(json['resolvedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reportedBy': reportedBy,
      'targetId': targetId,
      'targetType': targetType,
      'reason': reason,
      'description': description,
      'status': status,
      'action': action,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
    };
  }

  @override
  String toString() =>
      'Report(status: $status, reason: $reason, targetType: $targetType)';
}

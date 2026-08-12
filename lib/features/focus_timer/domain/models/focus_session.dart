/// Focus session domain model
/// Represents a single focus/Pomodoro session
class FocusSession {

  FocusSession({
    required this.id,
    required this.userId,
    required this.sessionType,
    required this.durationSeconds,
    required this.completedSeconds,
    required this.startedAt,
    this.endedAt,
    required this.status,
    this.missionTitle,
    this.xpReward = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert from JSON
  factory FocusSession.fromJson(Map<String, dynamic> json) {
    return FocusSession(
      id: json['_id'] as String? ?? json['id'] as String,
      userId: json['userId'] as String? ?? '',
      sessionType: json['sessionType'] as String,
      durationSeconds: json['durationSeconds'] as int? ?? json['duration'] as int? ?? 0,
      completedSeconds: json['completedSeconds'] as int? ?? 0,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: json['endedAt'] != null
          ? DateTime.parse(json['endedAt'] as String)
          : (json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null),
      status: json['status'] as String,
      missionTitle: json['missionTitle'] as String?,
      xpReward: json['xpReward'] as int? ?? json['xpEarned'] as int? ?? 0,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : DateTime.now(),
    );
  }
  final String id;
  final String userId;
  final String sessionType;
  final int durationSeconds;
  final int completedSeconds;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String status;
  final String? missionTitle;
  final int xpReward;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Check if session is currently active
  bool get isActive => status == 'active';

  /// Check if session is completed
  bool get isCompleted => status == 'completed';

  /// Check if session was abandoned
  bool get isAbandoned => status == 'abandoned';

  /// Get elapsed time in seconds
  int get elapsedSeconds {
    final now = DateTime.now();
    return now.difference(startedAt).inSeconds;
  }

  /// Get time remaining in seconds (never negative)
  int get remainingSeconds {
    final remaining = durationSeconds - elapsedSeconds;
    return remaining > 0 ? remaining : 0; // ✅ Never return negative values
  }

  /// Get progress as percentage (0.0 - 1.0)
  double get progress {
    if (durationSeconds == 0) return 1;
    return (elapsedSeconds / durationSeconds).clamp(0.0, 1.0);
  }

  /// Create a copy with modified fields
  FocusSession copyWith({
    String? id,
    String? userId,
    String? sessionType,
    int? durationSeconds,
    int? completedSeconds,
    DateTime? startedAt,
    DateTime? endedAt,
    String? status,
    String? missionTitle,
    int? xpReward,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FocusSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sessionType: sessionType ?? this.sessionType,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      completedSeconds: completedSeconds ?? this.completedSeconds,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      status: status ?? this.status,
      missionTitle: missionTitle ?? this.missionTitle,
      xpReward: xpReward ?? this.xpReward,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'sessionType': sessionType,
      'durationSeconds': durationSeconds,
      'completedSeconds': completedSeconds,
      'startedAt': startedAt.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
      'status': status,
      'missionTitle': missionTitle,
      'xpReward': xpReward,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FocusSession &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          status == other.status;

  @override
  int get hashCode => id.hashCode ^ status.hashCode;

  @override
  String toString() =>
      'FocusSession(id: $id, type: $sessionType, duration: $durationSeconds s, status: $status, xp: $xpReward)';
}

enum InviteStatus {
  pending,
  accepted,
  declined,
  cancelled,
}

InviteStatus inviteStatusFromString(String value) {
  return InviteStatus.values.firstWhere(
    (s) => s.toString().split('.').last.toUpperCase() == value.toUpperCase(),
    orElse: () => InviteStatus.pending,
  );
}

String inviteStatusToString(InviteStatus status) {
  return status.toString().split('.').last.toUpperCase();
}

class Invite {
  final String id;
  final String ideaId;
  final String invitedUserId;
  final String invitedByUserId;
  final InviteStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Invite({
    required this.id,
    required this.ideaId,
    required this.invitedUserId,
    required this.invitedByUserId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create Invite from JSON response from backend API
  factory Invite.fromJson(Map<String, dynamic> json) {
    return Invite(
      id: json['id'] ?? '',
      ideaId: json['ideaId'] ?? '',
      invitedUserId: json['invitedUserId'] ?? '',
      invitedByUserId: json['invitedByUserId'] ?? '',
      status: inviteStatusFromString(json['status'] ?? 'PENDING'),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// Convert Invite to JSON for sending to backend API
  Map<String, dynamic> toJson() => {
    'id': id,
    'ideaId': ideaId,
    'invitedUserId': invitedUserId,
    'invitedByUserId': invitedByUserId,
    'status': inviteStatusToString(status),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  /// Return a copy with updated status
  Invite copyWithStatus(InviteStatus newStatus) {
    return Invite(
      id: id,
      ideaId: ideaId,
      invitedUserId: invitedUserId,
      invitedByUserId: invitedByUserId,
      status: newStatus,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() => 'Invite(ideaId: $ideaId, status: $status)';
}

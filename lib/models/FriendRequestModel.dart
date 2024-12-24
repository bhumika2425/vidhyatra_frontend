class FriendRequest {
  final int friendRequestId;
  final int senderId;
  final int receiverId;
  final String status;
  final DateTime createdAt;

  FriendRequest({
    required this.friendRequestId,
    required this.senderId,
    required this.receiverId,
    required this.status,
    required this.createdAt,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      friendRequestId: json['friend_request_id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'friend_request_id': friendRequestId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

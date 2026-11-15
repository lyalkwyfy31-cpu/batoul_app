class StudentModel {
  final String id;
  final String fullName;
  final int grade;
  final String motherPhone;
  final String deviceId;
  final bool isSubscribed;
  final String? activeCode;

  const StudentModel({
    required this.id,
    required this.fullName,
    required this.grade,
    required this.motherPhone,
    required this.deviceId,
    required this.isSubscribed,
    this.activeCode,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      grade: (json['grade'] is int)
          ? json['grade'] as int
          : int.tryParse(json['grade']?.toString() ?? '6') ?? 6,
      motherPhone: json['mother_phone']?.toString() ?? '',
      deviceId: json['device_id']?.toString() ?? '',
      isSubscribed: json['is_subscribed'] == true,
      activeCode: json['active_code']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'grade': grade,
      'mother_phone': motherPhone,
      'device_id': deviceId,
      'is_subscribed': isSubscribed,
      'active_code': activeCode,
    };
  }

  StudentModel copyWith({
    String? id,
    String? fullName,
    int? grade,
    String? motherPhone,
    String? deviceId,
    bool? isSubscribed,
    String? activeCode,
  }) {
    return StudentModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      grade: grade ?? this.grade,
      motherPhone: motherPhone ?? this.motherPhone,
      deviceId: deviceId ?? this.deviceId,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      activeCode: activeCode ?? this.activeCode,
    );
  }
}

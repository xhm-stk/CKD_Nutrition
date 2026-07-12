class CustomReminder {
  final int id;
  final String type; // 'meal' or 'water'
  final String time; // 'HH:mm'
  final String itemName; // Food menu or fluid volume
  final bool isEnabled;

  CustomReminder({
    required this.id,
    required this.type,
    required this.time,
    required this.itemName,
    this.isEnabled = true,
  });

  CustomReminder copyWith({
    int? id,
    String? type,
    String? time,
    String? itemName,
    bool? isEnabled,
  }) {
    return CustomReminder(
      id: id ?? this.id,
      type: type ?? this.type,
      time: time ?? this.time,
      itemName: itemName ?? this.itemName,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'time': time,
    'item_name': itemName,
    'is_enabled': isEnabled,
  };

  factory CustomReminder.fromJson(Map<String, dynamic> json) => CustomReminder(
    id: json['id'] as int,
    type: json['type'] as String,
    time: json['time'] as String,
    itemName: json['item_name'] as String,
    isEnabled: json['is_enabled'] as bool? ?? true,
  );
}

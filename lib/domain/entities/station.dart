class Station {
  final String id;
  final String name;
  final String code;
  final String? lineId;
  final String? lineName;
  final String? lineColor;
  final bool isInterchange;
  final List<String>? interchangeLines;
  final int mainGateNumber;
  final int totalGates;
  final double? latitude;
  final double? longitude;
  final bool hasParking;
  final bool hasLift;
  final bool hasEscalator;
  
  Station({
    required this.id,
    required this.name,
    required this.code,
    this.lineId,
    this.lineName,
    this.lineColor,
    this.isInterchange = false,
    this.interchangeLines,
    this.mainGateNumber = 1,
    this.totalGates = 2,
    this.latitude,
    this.longitude,
    this.hasParking = true,
    this.hasLift = true,
    this.hasEscalator = true,
  });
  
  /// Create from JSON
  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      lineId: json['line_id'] as String?,
      lineName: json['lines']?['name'] as String?,
      lineColor: json['lines']?['color'] as String?,
      isInterchange: json['is_interchange'] as bool? ?? false,
      interchangeLines: json['interchange_lines'] != null 
          ? List<String>.from(json['interchange_lines'])
          : null,
      mainGateNumber: json['main_gate_number'] as int? ?? 1,
      totalGates: json['total_gates'] as int? ?? 2,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      hasParking: json['has_parking'] as bool? ?? true,
      hasLift: json['has_lift'] as bool? ?? true,
      hasEscalator: json['has_escalator'] as bool? ?? true,
    );
  }
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'line_id': lineId,
      'is_interchange': isInterchange,
      'interchange_lines': interchangeLines,
      'main_gate_number': mainGateNumber,
      'total_gates': totalGates,
      'latitude': latitude,
      'longitude': longitude,
      'has_parking': hasParking,
      'has_lift': hasLift,
      'has_escalator': hasEscalator,
    };
  }
  
  @override
  String toString() => '$name ($code)';
}
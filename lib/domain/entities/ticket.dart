class Ticket {
  final String id;
  final StationInfo from;
  final StationInfo to;
  final int fare;
  final String status;
  final DateTime purchaseTime;
  final DateTime expiryTime;
  final DateTime? usedAt;
  final String? qrCode;
  final String? paymentMethod;
  final String? transactionId;
  
  Ticket({
    required this.id,
    required this.from,
    required this.to,
    required this.fare,
    required this.status,
    required this.purchaseTime,
    required this.expiryTime,
    this.usedAt,
    this.qrCode,
    this.paymentMethod,
    this.transactionId,
  });
  
  /// Check if ticket is valid
  bool get isValid {
    return status == 'active' && DateTime.now().isBefore(expiryTime);
  }
  
  /// Check if ticket is expired
  bool get isExpired {
    return DateTime.now().isAfter(expiryTime);
  }
  
  /// Get time remaining until expiry
  Duration get timeRemaining {
    return expiryTime.difference(DateTime.now());
  }
  
  /// Create from JSON
  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] as String,
      from: StationInfo.fromJson(json['from']),
      to: StationInfo.fromJson(json['to']),
      fare: json['fare'] as int,
      status: json['status'] as String,
      purchaseTime: DateTime.parse(json['purchaseTime'] as String),
      expiryTime: DateTime.parse(json['expiryTime'] as String),
      usedAt: json['usedAt'] != null 
          ? DateTime.parse(json['usedAt'] as String)
          : null,
      qrCode: json['qrCode'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      transactionId: json['transactionId'] as String?,
    );
  }
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from': from.toJson(),
      'to': to.toJson(),
      'fare': fare,
      'status': status,
      'purchaseTime': purchaseTime.toIso8601String(),
      'expiryTime': expiryTime.toIso8601String(),
      'usedAt': usedAt?.toIso8601String(),
      'qrCode': qrCode,
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
    };
  }
}

/// Station information for tickets
class StationInfo {
  final String id;
  final String name;
  final String code;
  final String? line;
  final String? color;
  
  StationInfo({
    required this.id,
    required this.name,
    required this.code,
    this.line,
    this.color,
  });
  
  factory StationInfo.fromJson(Map<String, dynamic> json) {
    return StationInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      line: json['line'] as String?,
      color: json['color'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'line': line,
      'color': color,
    };
  }
}
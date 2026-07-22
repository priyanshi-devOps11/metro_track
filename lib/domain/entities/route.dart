class MetroRoute {
  final int totalTime;
  final int totalStations;
  final int interchanges;
  final String startStation;
  final String endStation;
  final List<RouteStation> stations;
  final RouteSummary summary;
  final Fare? fare;
  
  MetroRoute({
    required this.totalTime,
    required this.totalStations,
    required this.interchanges,
    required this.startStation,
    required this.endStation,
    required this.stations,
    required this.summary,
    this.fare,
  });
  
  /// Create from JSON
  factory MetroRoute.fromJson(Map<String, dynamic> json) {
    return MetroRoute(
      totalTime: json['totalTime'] as int,
      totalStations: json['totalStations'] as int,
      interchanges: json['interchanges'] as int,
      startStation: json['startStation'] as String,
      endStation: json['endStation'] as String,
      stations: (json['stations'] as List)
          .map((s) => RouteStation.fromJson(s))
          .toList(),
      summary: RouteSummary.fromJson(json['summary']),
      fare: json['fare'] != null ? Fare.fromJson(json['fare']) : null,
    );
  }
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalTime': totalTime,
      'totalStations': totalStations,
      'interchanges': interchanges,
      'startStation': startStation,
      'endStation': endStation,
      'stations': stations.map((s) => s.toJson()).toList(),
      'summary': summary.toJson(),
      'fare': fare?.toJson(),
    };
  }
}

/// Station in a route with navigation instructions
class RouteStation {
  final String stationId;
  final String stationName;
  final String stationCode;
  final String? lineId;
  final String? lineName;
  final String? lineColor;
  final bool isInterchange;
  final int gateNumber;
  final int sequence;
  final String instruction;
  
  RouteStation({
    required this.stationId,
    required this.stationName,
    required this.stationCode,
    this.lineId,
    this.lineName,
    this.lineColor,
    required this.isInterchange,
    required this.gateNumber,
    required this.sequence,
    required this.instruction,
  });
  
  factory RouteStation.fromJson(Map<String, dynamic> json) {
    return RouteStation(
      stationId: json['stationId'] as String,
      stationName: json['stationName'] as String,
      stationCode: json['stationCode'] as String,
      lineId: json['lineId'] as String?,
      lineName: json['lineName'] as String?,
      lineColor: json['lineColor'] as String?,
      isInterchange: json['isInterchange'] as bool,
      gateNumber: json['gateNumber'] as int,
      sequence: json['sequence'] as int,
      instruction: json['instruction'] as String,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'stationId': stationId,
      'stationName': stationName,
      'stationCode': stationCode,
      'lineId': lineId,
      'lineName': lineName,
      'lineColor': lineColor,
      'isInterchange': isInterchange,
      'gateNumber': gateNumber,
      'sequence': sequence,
      'instruction': instruction,
    };
  }
}

/// Route summary with human-readable info
class RouteSummary {
  final String text;
  final String estimatedTime;
  final List<String> linesUsed;
  final int interchangeCount;
  
  RouteSummary({
    required this.text,
    required this.estimatedTime,
    required this.linesUsed,
    required this.interchangeCount,
  });
  
  factory RouteSummary.fromJson(Map<String, dynamic> json) {
    return RouteSummary(
      text: json['text'] as String,
      estimatedTime: json['estimatedTime'] as String,
      linesUsed: List<String>.from(json['linesUsed']),
      interchangeCount: json['interchangeCount'] as int,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'estimatedTime': estimatedTime,
      'linesUsed': linesUsed,
      'interchangeCount': interchangeCount,
    };
  }
}

/// Fare information
class Fare {
  final int adult;
  final int child;
  final int senior;
  final String distance;
  final String currency;
  
  Fare({
    required this.adult,
    required this.child,
    required this.senior,
    required this.distance,
    this.currency = 'INR',
  });
  
  factory Fare.fromJson(Map<String, dynamic> json) {
    return Fare(
      adult: json['adult'] as int,
      child: json['child'] as int,
      senior: json['senior'] as int,
      distance: json['distance']?.toString() ?? '0',
      currency: json['currency'] as String? ?? 'INR',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'adult': adult,
      'child': child,
      'senior': senior,
      'distance': distance,
      'currency': currency,
    };
  }
}


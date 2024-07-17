import 'dart:convert';

import 'package:flutter/widgets.dart';

class BayarPiutangModel {
  String? bayarPiutangId;
  final String piutangId;
  final String nominalBayar;
  final String tanggalBayar;
  BayarPiutangModel({
    this.bayarPiutangId,
    required this.piutangId,
    required this.nominalBayar,
    required this.tanggalBayar,
  });

  BayarPiutangModel copyWith({
    ValueGetter<String?>? bayarPiutangId,
    String? piutangId,
    String? nominalBayar,
    String? tanggalBayar,
  }) {
    return BayarPiutangModel(
      bayarPiutangId:
          bayarPiutangId != null ? bayarPiutangId() : this.bayarPiutangId,
      piutangId: piutangId ?? this.piutangId,
      nominalBayar: nominalBayar ?? this.nominalBayar,
      tanggalBayar: tanggalBayar ?? this.tanggalBayar,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bayarPiutangId': bayarPiutangId,
      'piutangId': piutangId,
      'nominalBayar': nominalBayar,
      'tanggalBayar': tanggalBayar,
    };
  }

  factory BayarPiutangModel.fromMap(Map<String, dynamic> map) {
    return BayarPiutangModel(
      bayarPiutangId: map['bayarPiutangId'],
      piutangId: map['piutangId'] ?? '',
      nominalBayar: map['nominalBayar'] ?? '',
      tanggalBayar: map['tanggalBayar'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BayarPiutangModel.fromJson(String source) =>
      BayarPiutangModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BayarPiutangModel(bayarPiutangId: $bayarPiutangId, piutangId: $piutangId, nominalBayar: $nominalBayar, tanggalBayar: $tanggalBayar)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BayarPiutangModel &&
        other.bayarPiutangId == bayarPiutangId &&
        other.piutangId == piutangId &&
        other.nominalBayar == nominalBayar &&
        other.tanggalBayar == tanggalBayar;
  }

  @override
  int get hashCode {
    return bayarPiutangId.hashCode ^
        piutangId.hashCode ^
        nominalBayar.hashCode ^
        tanggalBayar.hashCode;
  }
}

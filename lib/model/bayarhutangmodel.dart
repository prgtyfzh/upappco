import 'dart:convert';

import 'package:flutter/widgets.dart';

class BayarHutangModel {
  String? bayarHutangId;
  final String hutangId;
  final String nominalBayar;
  final String tanggalBayar;

  BayarHutangModel({
    this.bayarHutangId,
    required this.hutangId,
    required this.nominalBayar,
    required this.tanggalBayar,
  });

  BayarHutangModel copyWith({
    ValueGetter<String?>? bayarHutangId,
    String? hutangId,
    String? nominalBayar,
    String? tanggalBayar,
    String? sisaHutang,
  }) {
    return BayarHutangModel(
      bayarHutangId:
          bayarHutangId != null ? bayarHutangId() : this.bayarHutangId,
      hutangId: hutangId ?? this.hutangId,
      nominalBayar: nominalBayar ?? this.nominalBayar,
      tanggalBayar: tanggalBayar ?? this.tanggalBayar,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bayarHutangId': bayarHutangId,
      'hutangId': hutangId,
      'nominalBayar': nominalBayar,
      'tanggalBayar': tanggalBayar,
    };
  }

  factory BayarHutangModel.fromMap(Map<String, dynamic> map) {
    return BayarHutangModel(
      bayarHutangId: map['bayarHutangId'],
      hutangId: map['hutangId'] ?? '',
      nominalBayar: map['nominalBayar'] ?? '',
      tanggalBayar: map['tanggalBayar'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BayarHutangModel.fromJson(String source) =>
      BayarHutangModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BayarHutangModel(bayarHutangId: $bayarHutangId, hutangId: $hutangId, nominalBayar: $nominalBayar, tanggalBayar: $tanggalBayar)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BayarHutangModel &&
        other.bayarHutangId == bayarHutangId &&
        other.hutangId == hutangId &&
        other.nominalBayar == nominalBayar &&
        other.tanggalBayar == tanggalBayar;
  }

  @override
  int get hashCode {
    return bayarHutangId.hashCode ^
        hutangId.hashCode ^
        nominalBayar.hashCode ^
        tanggalBayar.hashCode;
  }
}

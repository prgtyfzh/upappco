import 'dart:convert';

import 'package:flutter/widgets.dart';

class PembayaranModel {
  String? pembayaranId;
  String? hutangId;
  String? piutangId;
  final String nominalBayar;
  final String tanggalBayar;
  PembayaranModel({
    this.pembayaranId,
    this.hutangId,
    this.piutangId,
    required this.nominalBayar,
    required this.tanggalBayar,
  });

  PembayaranModel copyWith({
    ValueGetter<String?>? pembayaranId,
    ValueGetter<String?>? hutangId,
    ValueGetter<String?>? piutangId,
    String? nominalBayar,
    String? tanggalBayar,
  }) {
    return PembayaranModel(
      pembayaranId: pembayaranId != null ? pembayaranId() : this.pembayaranId,
      hutangId: hutangId != null ? hutangId() : this.hutangId,
      piutangId: piutangId != null ? piutangId() : this.piutangId,
      nominalBayar: nominalBayar ?? this.nominalBayar,
      tanggalBayar: tanggalBayar ?? this.tanggalBayar,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pembayaranId': pembayaranId,
      'hutangId': hutangId,
      'piutangId': piutangId,
      'nominalBayar': nominalBayar,
      'tanggalBayar': tanggalBayar,
    };
  }

  factory PembayaranModel.fromMap(Map<String, dynamic> map) {
    return PembayaranModel(
      pembayaranId: map['pembayaranId'],
      hutangId: map['hutangId'],
      piutangId: map['piutangId'],
      nominalBayar: map['nominalBayar'] ?? '',
      tanggalBayar: map['tanggalBayar'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PembayaranModel.fromJson(String source) =>
      PembayaranModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PembayaranModel(pembayaranId: $pembayaranId, hutangId: $hutangId, piutangId: $piutangId, nominalBayar: $nominalBayar, tanggalBayar: $tanggalBayar)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PembayaranModel &&
        other.pembayaranId == pembayaranId &&
        other.hutangId == hutangId &&
        other.piutangId == piutangId &&
        other.nominalBayar == nominalBayar &&
        other.tanggalBayar == tanggalBayar;
  }

  @override
  int get hashCode {
    return pembayaranId.hashCode ^
        hutangId.hashCode ^
        piutangId.hashCode ^
        nominalBayar.hashCode ^
        tanggalBayar.hashCode;
  }
}

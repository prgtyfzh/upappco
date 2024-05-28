import 'dart:convert';

import 'package:flutter/widgets.dart';

class PiutangModel {
  String? piutangId;
  final String namaPeminjam;
  final String noteleponPeminjam;
  final String nominalDiPinjam;
  final String tanggalDiPinjam;
  final String tanggalJatuhTempo;
  final String deskripsi;
  PiutangModel({
    this.piutangId,
    required this.namaPeminjam,
    required this.noteleponPeminjam,
    required this.nominalDiPinjam,
    required this.tanggalDiPinjam,
    required this.tanggalJatuhTempo,
    required this.deskripsi,
  });

  PiutangModel copyWith({
    ValueGetter<String?>? piutangId,
    String? namaPeminjam,
    String? noteleponPeminjam,
    String? nominalDiPinjam,
    String? tanggalDiPinjam,
    String? tanggalJatuhTempo,
    String? deskripsi,
  }) {
    return PiutangModel(
      piutangId: piutangId != null ? piutangId() : this.piutangId,
      namaPeminjam: namaPeminjam ?? this.namaPeminjam,
      noteleponPeminjam: noteleponPeminjam ?? this.noteleponPeminjam,
      nominalDiPinjam: nominalDiPinjam ?? this.nominalDiPinjam,
      tanggalDiPinjam: tanggalDiPinjam ?? this.tanggalDiPinjam,
      tanggalJatuhTempo: tanggalJatuhTempo ?? this.tanggalJatuhTempo,
      deskripsi: deskripsi ?? this.deskripsi,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'piutangId': piutangId,
      'namaPeminjam': namaPeminjam,
      'noteleponPeminjam': noteleponPeminjam,
      'nominalDiPinjam': nominalDiPinjam,
      'tanggalDiPinjam': tanggalDiPinjam,
      'tanggalJatuhTempo': tanggalJatuhTempo,
      'deskripsi': deskripsi,
    };
  }

  factory PiutangModel.fromMap(Map<String, dynamic> map) {
    return PiutangModel(
      piutangId: map['piutangId'],
      namaPeminjam: map['namaPeminjam'] ?? '',
      noteleponPeminjam: map['noteleponPeminjam'] ?? '',
      nominalDiPinjam: map['nominalDiPinjam'] ?? '',
      tanggalDiPinjam: map['tanggalDiPinjam'] ?? '',
      tanggalJatuhTempo: map['tanggalJatuhTempo'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PiutangModel.fromJson(String source) => PiutangModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PiutangModel(piutangId: $piutangId, namaPeminjam: $namaPeminjam, noteleponPeminjam: $noteleponPeminjam, nominalDiPinjam: $nominalDiPinjam, tanggalDiPinjam: $tanggalDiPinjam, tanggalJatuhTempo: $tanggalJatuhTempo, deskripsi: $deskripsi)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PiutangModel &&
      other.piutangId == piutangId &&
      other.namaPeminjam == namaPeminjam &&
      other.noteleponPeminjam == noteleponPeminjam &&
      other.nominalDiPinjam == nominalDiPinjam &&
      other.tanggalDiPinjam == tanggalDiPinjam &&
      other.tanggalJatuhTempo == tanggalJatuhTempo &&
      other.deskripsi == deskripsi;
  }

  @override
  int get hashCode {
    return piutangId.hashCode ^
      namaPeminjam.hashCode ^
      noteleponPeminjam.hashCode ^
      nominalDiPinjam.hashCode ^
      tanggalDiPinjam.hashCode ^
      tanggalJatuhTempo.hashCode ^
      deskripsi.hashCode;
  }
}

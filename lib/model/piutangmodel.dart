import 'dart:convert';

import 'package:flutter/widgets.dart';

class PiutangModel {
  String? piutangId;
  String? namaPeminjam;
  String? nominalDiPinjam;
  String? tanggalDiPinjam;
  String? tanggalJatuhTempo;
  String? deskripsi;
  String? totalBayar;
  String? sisaHutang;
  String? status;
  PiutangModel({
    this.piutangId,
    this.namaPeminjam,
    this.nominalDiPinjam,
    this.tanggalDiPinjam,
    this.tanggalJatuhTempo,
    this.deskripsi,
    this.totalBayar,
    this.sisaHutang,
    this.status,
  });

  PiutangModel copyWith({
    ValueGetter<String?>? piutangId,
    ValueGetter<String?>? namaPeminjam,
    ValueGetter<String?>? nominalDiPinjam,
    ValueGetter<String?>? tanggalDiPinjam,
    ValueGetter<String?>? tanggalJatuhTempo,
    ValueGetter<String?>? deskripsi,
    ValueGetter<String?>? totalBayar,
    ValueGetter<String?>? sisaHutang,
    ValueGetter<String?>? status,
  }) {
    return PiutangModel(
      piutangId: piutangId != null ? piutangId() : this.piutangId,
      namaPeminjam: namaPeminjam != null ? namaPeminjam() : this.namaPeminjam,
      nominalDiPinjam:
          nominalDiPinjam != null ? nominalDiPinjam() : this.nominalDiPinjam,
      tanggalDiPinjam:
          tanggalDiPinjam != null ? tanggalDiPinjam() : this.tanggalDiPinjam,
      tanggalJatuhTempo: tanggalJatuhTempo != null
          ? tanggalJatuhTempo()
          : this.tanggalJatuhTempo,
      deskripsi: deskripsi != null ? deskripsi() : this.deskripsi,
      totalBayar: totalBayar != null ? totalBayar() : this.totalBayar,
      sisaHutang: sisaHutang != null ? sisaHutang() : this.sisaHutang,
      status: status != null ? status() : this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'piutangId': piutangId,
      'namaPeminjam': namaPeminjam,
      'nominalDiPinjam': nominalDiPinjam,
      'tanggalDiPinjam': tanggalDiPinjam,
      'tanggalJatuhTempo': tanggalJatuhTempo,
      'deskripsi': deskripsi,
      'totalBayar': totalBayar,
      'sisaHutang': sisaHutang,
      'status': status,
    };
  }

  factory PiutangModel.fromMap(Map<String, dynamic> map) {
    return PiutangModel(
      piutangId: map['piutangId'],
      namaPeminjam: map['namaPeminjam'],
      nominalDiPinjam: map['nominalDiPinjam'],
      tanggalDiPinjam: map['tanggalDiPinjam'],
      tanggalJatuhTempo: map['tanggalJatuhTempo'],
      deskripsi: map['deskripsi'],
      totalBayar: map['totalBayar'],
      sisaHutang: map['sisaHutang'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PiutangModel.fromJson(String source) =>
      PiutangModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PiutangModel(piutangId: $piutangId, namaPeminjam: $namaPeminjam, nominalDiPinjam: $nominalDiPinjam, tanggalDiPinjam: $tanggalDiPinjam, tanggalJatuhTempo: $tanggalJatuhTempo, deskripsi: $deskripsi, totalBayar: $totalBayar, sisaHutang: $sisaHutang, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PiutangModel &&
        other.piutangId == piutangId &&
        other.namaPeminjam == namaPeminjam &&
        other.nominalDiPinjam == nominalDiPinjam &&
        other.tanggalDiPinjam == tanggalDiPinjam &&
        other.tanggalJatuhTempo == tanggalJatuhTempo &&
        other.deskripsi == deskripsi &&
        other.totalBayar == totalBayar &&
        other.sisaHutang == sisaHutang &&
        other.status == status;
  }

  @override
  int get hashCode {
    return piutangId.hashCode ^
        namaPeminjam.hashCode ^
        nominalDiPinjam.hashCode ^
        tanggalDiPinjam.hashCode ^
        tanggalJatuhTempo.hashCode ^
        deskripsi.hashCode ^
        totalBayar.hashCode ^
        sisaHutang.hashCode ^
        status.hashCode;
  }
}

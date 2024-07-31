import 'dart:convert';

import 'package:flutter/widgets.dart';

class PiutangModel {
  String? piutangId;
  String? namaPeminjam;
  String? noteleponPeminjam;
  String? nominalDiPinjam;
  String? tanggalDiPinjam;
  String? tanggalJatuhTempo;
  String? deskripsi;
  String? totalBayar;
  String? sisaHutang;
  PiutangModel({
    this.piutangId,
    this.namaPeminjam,
    this.noteleponPeminjam,
    this.nominalDiPinjam,
    this.tanggalDiPinjam,
    this.tanggalJatuhTempo,
    this.deskripsi,
    this.totalBayar,
    this.sisaHutang,
  });

  PiutangModel copyWith({
    ValueGetter<String?>? piutangId,
    ValueGetter<String?>? namaPeminjam,
    ValueGetter<String?>? noteleponPeminjam,
    ValueGetter<String?>? nominalDiPinjam,
    ValueGetter<String?>? tanggalDiPinjam,
    ValueGetter<String?>? tanggalJatuhTempo,
    ValueGetter<String?>? deskripsi,
    ValueGetter<String?>? totalBayar,
    ValueGetter<String?>? sisaHutang,
  }) {
    return PiutangModel(
      piutangId: piutangId != null ? piutangId() : this.piutangId,
      namaPeminjam: namaPeminjam != null ? namaPeminjam() : this.namaPeminjam,
      noteleponPeminjam: noteleponPeminjam != null
          ? noteleponPeminjam()
          : this.noteleponPeminjam,
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
      'totalBayar': totalBayar,
      'sisaHutang': sisaHutang,
    };
  }

  factory PiutangModel.fromMap(Map<String, dynamic> map) {
    return PiutangModel(
      piutangId: map['piutangId'],
      namaPeminjam: map['namaPeminjam'],
      noteleponPeminjam: map['noteleponPeminjam'],
      nominalDiPinjam: map['nominalDiPinjam'],
      tanggalDiPinjam: map['tanggalDiPinjam'],
      tanggalJatuhTempo: map['tanggalJatuhTempo'],
      deskripsi: map['deskripsi'],
      totalBayar: map['totalBayar'],
      sisaHutang: map['sisaHutang'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PiutangModel.fromJson(String source) =>
      PiutangModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PiutangModel(piutangId: $piutangId, namaPeminjam: $namaPeminjam, noteleponPeminjam: $noteleponPeminjam, nominalDiPinjam: $nominalDiPinjam, tanggalDiPinjam: $tanggalDiPinjam, tanggalJatuhTempo: $tanggalJatuhTempo, deskripsi: $deskripsi, totalBayar: $totalBayar, sisaHutang: $sisaHutang)';
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
        other.deskripsi == deskripsi &&
        other.totalBayar == totalBayar &&
        other.sisaHutang == sisaHutang;
  }

  @override
  int get hashCode {
    return piutangId.hashCode ^
        namaPeminjam.hashCode ^
        noteleponPeminjam.hashCode ^
        nominalDiPinjam.hashCode ^
        tanggalDiPinjam.hashCode ^
        tanggalJatuhTempo.hashCode ^
        deskripsi.hashCode ^
        totalBayar.hashCode ^
        sisaHutang.hashCode;
  }
}

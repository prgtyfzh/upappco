import 'dart:convert';

import 'package:flutter/widgets.dart';

class HutangModel {
  String? hutangId;
  String? namaPemberiPinjam;
  String? nominalPinjam;
  String? tanggalPinjam;
  String? tanggalJatuhTempo;
  String? deskripsi;
  String? totalBayar;
  String? sisaHutang;
  String? status;
  HutangModel({
    this.hutangId,
    this.namaPemberiPinjam,
    this.nominalPinjam,
    this.tanggalPinjam,
    this.tanggalJatuhTempo,
    this.deskripsi,
    this.totalBayar,
    this.sisaHutang,
    this.status,
  });

  HutangModel copyWith({
    ValueGetter<String?>? hutangId,
    ValueGetter<String?>? namaPemberiPinjam,
    ValueGetter<String?>? nominalPinjam,
    ValueGetter<String?>? tanggalPinjam,
    ValueGetter<String?>? tanggalJatuhTempo,
    ValueGetter<String?>? deskripsi,
    ValueGetter<String?>? totalBayar,
    ValueGetter<String?>? sisaHutang,
    ValueGetter<String?>? status,
  }) {
    return HutangModel(
      hutangId: hutangId != null ? hutangId() : this.hutangId,
      namaPemberiPinjam: namaPemberiPinjam != null
          ? namaPemberiPinjam()
          : this.namaPemberiPinjam,
      nominalPinjam:
          nominalPinjam != null ? nominalPinjam() : this.nominalPinjam,
      tanggalPinjam:
          tanggalPinjam != null ? tanggalPinjam() : this.tanggalPinjam,
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
      'hutangId': hutangId,
      'namaPemberiPinjam': namaPemberiPinjam,
      'nominalPinjam': nominalPinjam,
      'tanggalPinjam': tanggalPinjam,
      'tanggalJatuhTempo': tanggalJatuhTempo,
      'deskripsi': deskripsi,
      'totalBayar': totalBayar,
      'sisaHutang': sisaHutang,
      'status': status,
    };
  }

  factory HutangModel.fromMap(Map<String, dynamic> map) {
    return HutangModel(
      hutangId: map['hutangId'],
      namaPemberiPinjam: map['namaPemberiPinjam'],
      nominalPinjam: map['nominalPinjam'],
      tanggalPinjam: map['tanggalPinjam'],
      tanggalJatuhTempo: map['tanggalJatuhTempo'],
      deskripsi: map['deskripsi'],
      totalBayar: map['totalBayar'],
      sisaHutang: map['sisaHutang'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory HutangModel.fromJson(String source) =>
      HutangModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HutangModel(hutangId: $hutangId, namaPemberiPinjam: $namaPemberiPinjam, nominalPinjam: $nominalPinjam, tanggalPinjam: $tanggalPinjam, tanggalJatuhTempo: $tanggalJatuhTempo, deskripsi: $deskripsi, totalBayar: $totalBayar, sisaHutang: $sisaHutang, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HutangModel &&
        other.hutangId == hutangId &&
        other.namaPemberiPinjam == namaPemberiPinjam &&
        other.nominalPinjam == nominalPinjam &&
        other.tanggalPinjam == tanggalPinjam &&
        other.tanggalJatuhTempo == tanggalJatuhTempo &&
        other.deskripsi == deskripsi &&
        other.totalBayar == totalBayar &&
        other.sisaHutang == sisaHutang &&
        other.status == status;
  }

  @override
  int get hashCode {
    return hutangId.hashCode ^
        namaPemberiPinjam.hashCode ^
        nominalPinjam.hashCode ^
        tanggalPinjam.hashCode ^
        tanggalJatuhTempo.hashCode ^
        deskripsi.hashCode ^
        totalBayar.hashCode ^
        sisaHutang.hashCode ^
        status.hashCode;
  }
}

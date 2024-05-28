import 'dart:convert';

import 'package:flutter/widgets.dart';

class HutangModel {
  String? hutangId;
  final String namaPemberiPinjam;
  final String noteleponPemberiPinjam;
  final String nominalPinjam;
  final String tanggalPinjam;
  final String tanggalJatuhTempo;
  final String deskripsi;
  // final String gambar;
  HutangModel({
    this.hutangId,
    required this.namaPemberiPinjam,
    required this.noteleponPemberiPinjam,
    required this.nominalPinjam,
    required this.tanggalPinjam,
    required this.tanggalJatuhTempo,
    required this.deskripsi,
    // required this.gambar,
  });

  HutangModel copyWith({
    ValueGetter<String?>? hutangId,
    String? namaPemberiPinjam,
    String? noteleponPemberiPinjam,
    String? nominalPinjam,
    String? tanggalPinjam,
    String? tanggalJatuhTempo,
    String? deskripsi,
    String? gambar,
  }) {
    return HutangModel(
      hutangId: hutangId != null ? hutangId() : this.hutangId,
      namaPemberiPinjam: namaPemberiPinjam ?? this.namaPemberiPinjam,
      noteleponPemberiPinjam:
          noteleponPemberiPinjam ?? this.noteleponPemberiPinjam,
      nominalPinjam: nominalPinjam ?? this.nominalPinjam,
      tanggalPinjam: tanggalPinjam ?? this.tanggalPinjam,
      tanggalJatuhTempo: tanggalJatuhTempo ?? this.tanggalJatuhTempo,
      deskripsi: deskripsi ?? this.deskripsi,
      // gambar: gambar ?? this.gambar,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hutangId': hutangId,
      'namaPemberiPinjam': namaPemberiPinjam,
      'noteleponPemberiPinjam': noteleponPemberiPinjam,
      'nominalPinjam': nominalPinjam,
      'tanggalPinjam': tanggalPinjam,
      'tanggalJatuhTempo': tanggalJatuhTempo,
      'deskripsi': deskripsi,
      // 'gambar': gambar,
    };
  }

  factory HutangModel.fromMap(Map<String, dynamic> map) {
    return HutangModel(
      hutangId: map['hutangId'],
      namaPemberiPinjam: map['namaPemberiPinjam'] ?? '',
      noteleponPemberiPinjam: map['noteleponPemberiPinjam'] ?? '',
      nominalPinjam: map['nominalPinjam'] ?? '',
      tanggalPinjam: map['tanggalPinjam'] ?? '',
      tanggalJatuhTempo: map['tanggalJatuhTempo'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      // gambar: map['gambar'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory HutangModel.fromJson(String source) =>
      HutangModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HutangModel(hutangId: $hutangId, namaPemberiPinjam: $namaPemberiPinjam, noteleponPemberiPinjam: $noteleponPemberiPinjam, nominalPinjam: $nominalPinjam, tanggalPinjam: $tanggalPinjam, tanggalJatuhTempo: $tanggalJatuhTempo, deskripsi: $deskripsi)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HutangModel &&
        other.hutangId == hutangId &&
        other.namaPemberiPinjam == namaPemberiPinjam &&
        other.noteleponPemberiPinjam == noteleponPemberiPinjam &&
        other.nominalPinjam == nominalPinjam &&
        other.tanggalPinjam == tanggalPinjam &&
        other.tanggalJatuhTempo == tanggalJatuhTempo &&
        other.deskripsi == deskripsi;
    // other.gambar == gambar;
  }

  @override
  int get hashCode {
    return hutangId.hashCode ^
        namaPemberiPinjam.hashCode ^
        noteleponPemberiPinjam.hashCode ^
        nominalPinjam.hashCode ^
        tanggalPinjam.hashCode ^
        tanggalJatuhTempo.hashCode ^
        deskripsi.hashCode;
    // gambar.hashCode;
  }
}

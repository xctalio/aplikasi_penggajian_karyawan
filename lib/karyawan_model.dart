class Karyawan {
  int? id;
  String idKaryawan;
  String nama;
  String jabatan;
  double gajiPokok;
  double tunjangan;
  double potongan;
  double totalGaji;

  Karyawan({
    this.id,
    required this.idKaryawan,
    required this.nama,
    required this.jabatan,
    required this.gajiPokok,
    required this.tunjangan,
    required this.potongan,
    required this.totalGaji,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idKaryawan': idKaryawan,
      'nama': nama,
      'jabatan': jabatan,
      'gajiPokok': gajiPokok,
      'tunjangan': tunjangan,
      'potongan': potongan,
      'totalGaji': totalGaji,
    };
  }

  factory Karyawan.fromMap(Map<String, dynamic> map) {
    return Karyawan(
      id: map['id'],
      idKaryawan: map['idKaryawan'],
      nama: map['nama'],
      jabatan: map['jabatan'],
      gajiPokok: map['gajiPokok'],
      tunjangan: map['tunjangan'],
      potongan: map['potongan'],
      totalGaji: map['totalGaji'],
    );
  }

  static double hitungTotalGaji(double gajiPokok, double tunjangan, double potongan) {
    return gajiPokok + tunjangan - potongan;
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'database_helper.dart';
import 'karyawan_model.dart';

class FormPage extends StatefulWidget {
  final Karyawan? karyawan;

  const FormPage({super.key, this.karyawan});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _jabatanController = TextEditingController();
  final _gajiPokokController = TextEditingController();
  final _tunjanganController = TextEditingController();
  final _potonganController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.karyawan != null) {
      isEdit = true;
      _namaController.text = widget.karyawan!.nama;
      _jabatanController.text = widget.karyawan!.jabatan;
      _gajiPokokController.text = widget.karyawan!.gajiPokok.toString();
      _tunjanganController.text = widget.karyawan!.tunjangan.toString();
      _potonganController.text = widget.karyawan!.potongan.toString();
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jabatanController.dispose();
    _gajiPokokController.dispose();
    _tunjanganController.dispose();
    _potonganController.dispose();
    super.dispose();
  }

  Future<void> simpanData() async {
    if (_formKey.currentState!.validate()) {
      final gajiPokok = double.parse(_gajiPokokController.text);
      final tunjangan = double.parse(_tunjanganController.text);
      final potongan = double.parse(_potonganController.text);
      final totalGaji = Karyawan.hitungTotalGaji(gajiPokok, tunjangan, potongan);

      final karyawan = Karyawan(
        id: isEdit ? widget.karyawan!.id : null,
        nama: _namaController.text,
        jabatan: _jabatanController.text,
        gajiPokok: gajiPokok,
        tunjangan: tunjangan,
        potongan: potongan,
        totalGaji: totalGaji,
      );

      if (isEdit) {
        await DatabaseHelper.instance.updateKaryawan(karyawan.toMap());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil diupdate')),
        );
      } else {
        await DatabaseHelper.instance.insertKaryawan(karyawan.toMap());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil disimpan')),
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Data Karyawan' : 'Tambah Data Karyawan'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Karyawan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jabatanController,
                decoration: const InputDecoration(
                  labelText: 'Jabatan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jabatan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _gajiPokokController,
                decoration: const InputDecoration(
                  labelText: 'Gaji Pokok',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Gaji Pokok tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tunjanganController,
                decoration: const InputDecoration(
                  labelText: 'Tunjangan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.add_circle),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tunjangan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _potonganController,
                decoration: const InputDecoration(
                  labelText: 'Potongan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.remove_circle),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Potongan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Perhitungan Total Gaji',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text('Total Gaji = Gaji Pokok + Tunjangan - Potongan'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: simpanData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isEdit ? 'Update Data' : 'Simpan Data',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
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
  final _idKaryawanController = TextEditingController();
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
      _idKaryawanController.text = widget.karyawan!.idKaryawan;
      _namaController.text = widget.karyawan!.nama;
      _jabatanController.text = widget.karyawan!.jabatan;
      _gajiPokokController.text = widget.karyawan!.gajiPokok.toStringAsFixed(0);
      _tunjanganController.text = widget.karyawan!.tunjangan.toStringAsFixed(0);
      _potonganController.text = widget.karyawan!.potongan.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _idKaryawanController.dispose();
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
        idKaryawan: _idKaryawanController.text,
        nama: _namaController.text,
        jabatan: _jabatanController.text,
        gajiPokok: gajiPokok,
        tunjangan: tunjangan,
        potongan: potongan,
        totalGaji: totalGaji,
      );

      try {
        if (isEdit) {
          await DatabaseHelper.instance.updateKaryawan(karyawan.toMap());
          print('✅ Data berhasil diupdate');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data berhasil diupdate'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          await DatabaseHelper.instance.insertKaryawan(karyawan.toMap());
          print('✅ Data berhasil disimpan');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data berhasil disimpan'),
              backgroundColor: Colors.green,
            ),
          );
        }
        Navigator.pop(context);
      } catch (e) {
        print('❌ Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? prefixText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20),
            prefixText: prefixText,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label tidak boleh kosong';
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Karyawan' : 'Tambah Karyawan'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    isEdit ? Icons.edit : Icons.person_add,
                    size: 50,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isEdit ? 'Ubah Data Karyawan' : 'Tambah Data Karyawan',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildTextField(
                      controller: _idKaryawanController,
                      label: 'ID Karyawan',
                      icon: Icons.badge,
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      controller: _namaController,
                      label: 'Nama Lengkap',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      controller: _jabatanController,
                      label: 'Jabatan',
                      icon: Icons.work,
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      controller: _gajiPokokController,
                      label: 'Gaji Pokok',
                      icon: Icons.payments,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      prefixText: 'Rp ',
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      controller: _tunjanganController,
                      label: 'Tunjangan',
                      icon: Icons.add_circle_outline,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      prefixText: 'Rp ',
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      controller: _potonganController,
                      label: 'Potongan',
                      icon: Icons.remove_circle_outline,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      prefixText: 'Rp ',
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calculate, color: Colors.blueAccent, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                'Rumus Perhitungan',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Total Gaji = Gaji Pokok + Tunjangan - Potongan',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: simpanData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(isEdit ? Icons.save : Icons.check_circle, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            isEdit ? 'Update Data' : 'Simpan Data',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
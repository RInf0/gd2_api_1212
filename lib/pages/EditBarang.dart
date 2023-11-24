import 'package:flutter/material.dart';
import 'package:gd_api_1212/client/BarangClient.dart';
import 'package:gd_api_1212/entity/barang.dart';
import 'package:gd_api_1212/pages/homepage.dart';

class EditBarang extends StatefulWidget {
  const EditBarang({super.key, this.id});
  final int? id;

  @override
  State<EditBarang> createState() => _EditBarangState();
}

class _EditBarangState extends State<EditBarang> {
  final _homePage = Homepage();
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final stockController = TextEditingController();
  bool isLoading = false;

  void loadData() async {
    try {
      setState(() {
        isLoading = true;
      });
      Barang res = await BarangClient.find(widget.id);
      setState(() {
        isLoading = false;
        nameController.value = TextEditingValue(text: res.nama);
        descController.value = TextEditingValue(text: res.deskripsi);
        stockController.value = TextEditingValue(text: res.stok.toString());
      });
    } catch (err) {
      _homePage.showSnackBar(context, err.toString(), Colors.red);
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    void onSubmit() async {
      if (!_formKey.currentState!.validate()) return;

      Barang input = Barang(
          id: widget.id ?? 0,
          nama: nameController.text,
          deskripsi: descController.text,
          stok: int.parse(stockController.text));
      try {
        if (widget.id == null) {
          await BarangClient.create(input);
        } else {
          await BarangClient.update(input);
        }
        _homePage.showSnackBar(context, 'Success', Colors.green);
        Navigator.pop(context);
      } catch (err) {
        _homePage.showSnackBar(context, err.toString(), Colors.red);
        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? "Tambah Barang" : "Edit Barang"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Masukan Nama'),
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Masukan Deskripsi'),
                        controller: descController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Masukan Stok'),
                        controller: stockController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 10),
                        child: ElevatedButton(
                            onPressed: onSubmit,
                            child:
                                Text(widget.id == null ? 'Tambah' : 'Edit'))),
                  ],
                ),
              ),
      ),
    );
  }
}

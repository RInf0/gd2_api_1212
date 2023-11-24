import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gd_api_1212/entity/barang.dart';
import 'package:gd_api_1212/client/BarangClient.dart';
import 'package:gd_api_1212/pages/EditBarang.dart';

class Homepage extends ConsumerWidget {
  Homepage({super.key});

  final listBarangProvider = FutureProvider<List<Barang>>((ref) async {
    return await BarangClient.fetchAll();
  });

  void onAdd(context, ref) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => const EditBarang()))
        .then((value) => ref.refresh(listBarangProvider));
  }

  void onDelete(id, context, ref) async {
    try {
      await BarangClient.destroy(id);
      ref.refresh(listBarangProvider);
      showSnackBar(context, "Delete Success", Colors.green);
    } catch (e) {
      showSnackBar(context, e.toString(), Colors.red);
    }
  }

  ListTile scrollViewItem(Barang b, context, ref) => ListTile(
        title: Text(b.nama),
        subtitle: Text(b.deskripsi),
        onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditBarang(id: b.id)))
            .then((value) => ref.refresh(listBarangProvider)),
        trailing: IconButton(
          onPressed: () => onDelete(b.id, context, ref),
          icon: const Icon(Icons.delete),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var listener = ref.watch(listBarangProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("GD API 1212"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onAdd(context, ref),
        child: const Icon(Icons.add),
      ),
      body: listener.when(
        data: (barangs) => SingleChildScrollView(
          child: Column(
            children: barangs
                .map((barang) => scrollViewItem(barang, context, ref))
                .toList(),
          ),
        ),
        error: (err, s) => Center(
          child: Text(
            err.toString(),
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String msg, Color bg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: bg,
      action: SnackBarAction(
          label: 'Hide',
          textColor: Colors.white,
          onPressed: scaffold.hideCurrentSnackBar),
    ));
  }
}

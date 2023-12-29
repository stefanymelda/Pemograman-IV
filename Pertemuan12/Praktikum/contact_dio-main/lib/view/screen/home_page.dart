import 'package:contact_dio/view/widget/contact_card.dart';
import 'package:flutter/material.dart';
import 'package:contact_dio/model/contacts_model.dart';
import 'package:contact_dio/services/api_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key); // Fix the key parameter

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiServices _dataService = ApiServices();
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _numberCtl = TextEditingController();
  String _result = '-';
  List<ContactsModel> _contactMdl = [];
  ContactResponse? ctRes;
  bool isEdit = false;
  String idContact = '';

  @override
  void dispose() {
    _nameCtl.dispose();
    _numberCtl.dispose();
    super.dispose();
  }

  Widget hasilCard(BuildContext context) {
    return Column(children: [
      if (ctRes != null)
        ContactCard(
          ctRes: ctRes!,
          onDismissed: () {
            setState(() {
              ctRes = null;
            });
          },
        )
      else
        const Text(''),
    ]);
  }

  Future<void> refreshContactList() async {
    try {
      final users = await _dataService.getAllContact();
      setState(() {
        _contactMdl
            .clear(); // Use clear() directly, no need for additional checks
        if (users != null) _contactMdl.addAll(users);
      });
    } catch (e) {
      print('Error refreshing contacts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts API'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                // Use TextFormField instead of TextField
                controller: _nameCtl,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Nama',
                  suffixIcon: IconButton(
                    onPressed: _nameCtl.clear,
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                // Use TextFormField instead of TextField
                controller: _numberCtl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Nomor HP',
                  suffixIcon: IconButton(
                    onPressed: _numberCtl.clear,
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_nameCtl.text.isEmpty || _numberCtl.text.isEmpty) {
                        displaySnackbar('Semua field harus diisi');
                        return;
                      }
                      final postModel = ContactInput(
                        namaKontak: _nameCtl.text,
                        nomorHp: _numberCtl.text,
                      );
                      ContactResponse? res;
                      if (isEdit) {
                        res =
                            await _dataService.putContact(idContact, postModel);
                      } else {
                        res = await _dataService.postContact(postModel);
                      }

                      setState(() {
                        ctRes = res;
                        isEdit = false;
                      });
                      _nameCtl.clear();
                      _numberCtl.clear();
                      await refreshContactList();
                    },
                    child: Text(isEdit ? 'UPDATE' : 'POST'),
                  ),
                  if (isEdit)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        _nameCtl.clear();
                        _numberCtl.clear();
                        setState(() {
                          isEdit = false;
                        });
                      },
                      child: const Text('Cancel Update'),
                    ),
                ],
              ),
              hasilCard(context),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await refreshContactList();
                      },
                      child: const Text('Refresh Data'),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _result = '-';
                        _contactMdl.clear();
                        ctRes = null;
                      });
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              const Text(
                'List Contact',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child:
                    _contactMdl.isEmpty ? Text(_result) : _buildListContact(),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListContact() {
    return ListView.separated(
      itemBuilder: (context, index) {
        final ctList = _contactMdl[index];
        return Card(
          child: ListTile(
            title: Text(ctList.namaKontak),
            subtitle: Text(ctList.nomorHp),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () async {
                    final contacts =
                        await _dataService.getSingleContact(ctList.id);
                    setState(() {
                      if (contacts != null) {
                        _nameCtl.text = contacts.namaKontak;
                        _numberCtl.text = contacts.nomorHp;
                        isEdit = true;
                        idContact = contacts.id;
                      }
                    });
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    _showDeleteConfirmationDialog(ctList.id, ctList.namaKontak);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10.0),
      itemCount: _contactMdl.length,
    );
  }

  void _showDeleteConfirmationDialog(String id, String nama) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus data $nama ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                ContactResponse? res = await _dataService.deleteContact(id);
                setState(() {
                  ctRes = res;
                });
                Navigator.of(context).pop();
                await refreshContactList();
              },
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );
  }

  void displaySnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

import 'package:flutter/material.dart';

class MyInputForm extends StatefulWidget {
  const MyInputForm({super.key});

  @override
  State<MyInputForm> createState() => _MyInputFormState();
}

class _MyInputFormState extends State<MyInputForm> {
  //property
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerNama = TextEditingController();
  final List<Map<String, dynamic>> _myDataList = [];
  Map<String, dynamic>? editedData;

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerNama.dispose();
    super.dispose();
  }

  void _addData() {
    final data = {
      'name': _controllerNama.text,
      'email': _controllerEmail.text,
    };
    setState(() {
      if (editedData != null) {
// Jika editedData ada, maka kita sedang dalam mode edit
// Sehingga kita perlu memperbarui data yang sedang diedit
        editedData!['name'] = data['name'];
        editedData!['email'] = data['email'];
// Kosongkan kembali editedData setelah proses edit selesai
        editedData = null;
      } else {
// Jika editedData kosong, maka kita sedang dalam mode insert
        _myDataList.add(data);
      }
      _controllerNama.clear();
      _controllerEmail.clear();
    });
  }

  void _editData(Map<String, dynamic> data) {
    setState(() {
      _controllerEmail.text = data['email'];
      _controllerNama.text = data['name'];
      editedData = data;
    });
  }

  void _deleteData(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Data'),
          content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _myDataList.remove(data);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  String? _validateEmail(String? value) {
    const String expression = "[a-zA-Z0-9+._%-+]{1,256}"
        "\\@"
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}"
        "("
        "\\."
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}"
        ")+";
    final RegExp regExp = RegExp(expression);

    if (value!.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    if (!regExp.hasMatch(value!)) {
      return 'Masukkan email yang valid';
    }

    return null;
  }

  String? _validateNama(String? value) {
    if (value!.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (value.length < 3) {
      return 'minimal 3 karakter';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Input'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _controllerEmail,
                validator: _validateEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Tulis email Anda disini ok',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  fillColor: Color.fromARGB(255, 208, 250, 236),
                  filled: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _controllerNama,
                validator: _validateNama,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  hintText: 'Monggo tulis namanya',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  fillColor: Color.fromARGB(255, 208, 250, 236),
                  filled: true,
                ),
              ),
            ),
            ElevatedButton(
              // onPressed: () {
              //   if (_formKey.currentState!.validate()) {
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(
              //         content: Text('Processing Data'),
              //         duration: const Duration(seconds: 1),
              //       ),
              //     );
              //     showDialog(
              //         context: context,
              //         builder: (context) {
              //           return AlertDialog(
              //             content: Column(
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 Text('Hello, ${_controllerNama.text}'),
              //                 Text('Email, ${_controllerEmail.text}'),
              //               ],
              //             ),
              //           );
              //         });
              //   } else {
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(
              //         content: Text('Please complete the form!!!'),
              //         duration: Duration(seconds: 1),
              //       ),
              //     );
              //   }
              // },
              child: Text(editedData != null ? "Update" : "Submit"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _addData();
                }
              },
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'List Data',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _myDataList.length,
              itemBuilder: (context, index) {
                final data = _myDataList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Text(
                          'ULBI',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['name'] ?? ''),
                            Text(data['email'] ?? ''),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _editData(data);
                          });
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _deleteData(data);
                          });
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'user.dart';
import 'user_card.dart';

import 'data_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DataService _dataService = DataService();

  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _jobCtl = TextEditingController();
  String _result = '-';
  List<User> _users = [];
  UserCreate? _userCreate;
  UserPut? _userPut;

  @override
  void dispose() {
    _nameCtl.dispose();
    _jobCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REST API (DIO)'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameCtl,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Name',
                  suffixIcon: IconButton(
                    onPressed: _nameCtl.clear,
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _jobCtl,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Job',
                  suffixIcon: IconButton(
                    onPressed: _jobCtl.clear,
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final res = await _dataService.getUsers();
                        if (res != null) {
                          setState(() {
                            _result = res.toString();
                            _users = [];
                          });
                        } else {
                          displaySnackbar('Error');
                        }
                      },
                      child: const Text('GET'),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_nameCtl.text.isEmpty || _jobCtl.text.isEmpty) {
                          displaySnackbar('Semua Field Harus Terisi');
                          return;
                        }
                        UserCreate? res = await _dataService.postUser(
                          UserCreate(
                            name: _nameCtl.text,
                            job: _jobCtl.text,
                          ),
                        );
                        if (res != null) {
                          setState(() {
                            _userCreate = res;
                            _result = res.toString();
                          });
                          _users = [];
                          _nameCtl.clear();
                          _jobCtl.clear();
                        } else {
                          displaySnackbar('Error');
                        }
                      },
                      child: const Text('POST'),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_nameCtl.text.isEmpty || _jobCtl.text.isEmpty) {
                          displaySnackbar('Semua Field Harus Terisi');
                          return;
                        }
                        UserPut? res = await _dataService.putUser('2',
                            UserPut(name: _nameCtl.text, job: _jobCtl.text));
                        if (res != null) {
                          setState(() {
                            _result = res.toString();
                            _userPut = res;
                          });
                          _users = [];
                          _nameCtl.clear();
                          _jobCtl.clear();
                          _userCreate = null;
                        } else {
                          displaySnackbar('Error');
                        }
                      },
                      child: const Text('PUT'),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final res = await _dataService.deleteUser('2');
                        if (res != null) {
                          setState(() {
                            _result = res.toString();
                          });
                        }
                      },
                      child: const Text('DELETE'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final users = await _dataService.getUserModel();
                        setState(() {
                          _users = users!.toList();
                        });
                      },
                      child: const Text('Model Class User Example'),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _users = [];
                        _result = '-';
                        _userCreate = null;
                        _userPut = null;
                      });
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Result',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: _users.isNotEmpty ? _buildUserList() : Text(_result),
              ),
              _buildCard(),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return ListView.separated(
        itemBuilder: (context, index) {
          final user = _users[index];
          return Card(
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image.network(_users[index].avatar),
              ),
              title: Text('${user.firstName} ${user.lastName}'),
              subtitle: Text(_users[index].email),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
              height: 10.0,
            ),
        itemCount: _users.length);
  }

  Widget _buildCard() {
    return Column(
      children: [
        SizedBox.fromSize(
          size: const Size(0, 10),
        ),
        if (_userCreate != null || _userPut != null)
          (_userCreate != null
              ? UserCard(userCreate: _userCreate!)
              : UserPutCard(userPut: _userPut!))
        else
          const Text("Data Tidak Ada"),
      ],
    );
  }

  dynamic displaySnackbar(String msg) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}

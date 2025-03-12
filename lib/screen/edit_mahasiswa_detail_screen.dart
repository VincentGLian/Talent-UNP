import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/mahasiswa.dart';

class EditMahasiswaScreen extends StatefulWidget {
  static const routeName = '/edit-mhs';

  const EditMahasiswaScreen({super.key});

  @override
  EditMahasiswaScreenState createState() => EditMahasiswaScreenState();
}

class EditMahasiswaScreenState extends State<EditMahasiswaScreen> {
  final _namaFocusnNode = FocusNode();
  final _emailFocusnNode = FocusNode();
  final _nimFocusNode = FocusNode();
  final _noteTlpFocusNode = FocusNode();
  final _deskripsi = FocusNode();
  final _talent = FocusNode();
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  var _isInit = true;
  late File imageFile;
  bool _load = false;

  String? selectedtalent;
  String dropdownvalue = 'Mahasiswa';
  var items = [
    'Mahasiswa',
    'Dosen',
  ];

  var _editedMahasiswa = Mahasiswa(
    id: '',
    nama: '',
    email: '',
    np: '',
    professi: '',
    noTelp: '',
    deskripsi: '',
    photo: '',
    skills: [],
  );
  var _initValues = {
    'nama': '',
    'email': '',
    'np': '',
    'professi': '',
    'nomor telpon': '',
    'deskripsi': '',
  };

  @override
  void initState() {
    super.initState();
  }

  void updateText(String? newTalent) {
    setState(() {
      selectedtalent = newTalent;
    });
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final mahasiswaID = ModalRoute.of(context)!.settings.arguments;
      if (mahasiswaID != null) {
        _editedMahasiswa = Provider.of<Mahasiswas>(context, listen: false)
            .findById(mahasiswaID.toString());
        _initValues = {
          'id': _editedMahasiswa.id,
          'nama': _editedMahasiswa.nama,
          'email': _editedMahasiswa.email,
          'np': _editedMahasiswa.np,
          'professi': _editedMahasiswa.professi,
          'nomor telpon': _editedMahasiswa.noTelp,
          'deskripsi': _editedMahasiswa.deskripsi,
        };
        if (_editedMahasiswa.professi != null) {
          dropdownvalue = _editedMahasiswa.professi;
        }
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _namaFocusnNode.dispose();
    _nimFocusNode.dispose();
    _noteTlpFocusNode.dispose();
    _emailFocusnNode.dispose();
    _deskripsi.dispose();
    _talent.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    setState(() {
      _isLoading = true;
    });
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    print(_editedMahasiswa.id);
    if (_editedMahasiswa.id != "") {
      await Provider.of<Mahasiswas>(context, listen: false)
          .editMahasiswa(_editedMahasiswa.id, _editedMahasiswa)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    } else {
      try {
        await Provider.of<Mahasiswas>(context, listen: false)
            .addMahasiswa(_editedMahasiswa)
            .catchError(
          (error) async {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('An error occured'),
                content: const Text('Something went wrong'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Okay"))
                ],
              ),
            );
          },
        ).then((_) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
        });
      } catch (error) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            _editedMahasiswa.id == ''
                ? "Tambah Mahasiswa"
                : _editedMahasiswa.nama,
            style: const TextStyle(
              fontFamily: 'PT Serif',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.purple),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _form,
                  autovalidateMode: AutovalidateMode.always,
                  child: ListView(
                    children: [
                      textForm(context, 'nama', _namaFocusnNode, _nimFocusNode,
                          TextInputType.name),
                      Card(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blueAccent.shade200,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'PROFESI:',
                                  style: TextStyle(
                                    color: Colors.blueAccent.shade200,
                                    fontSize: 16,
                                    fontFamily: 'PT Serif',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: DropdownButton(
                                    style: TextStyle(
                                      color: Colors.blueAccent.shade200,
                                      fontSize: 16,
                                      fontFamily: 'PT Serif',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    value: dropdownvalue == null
                                        ? "Mahasiswa"
                                        : dropdownvalue,
                                    items: items.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownvalue = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      textForm(context, 'np', _nimFocusNode, _emailFocusnNode,
                          TextInputType.text),
                      textForm(context, 'email', _emailFocusnNode,
                          _noteTlpFocusNode, TextInputType.emailAddress),
                      textForm(context, 'nomor telpon', _noteTlpFocusNode,
                          _deskripsi, TextInputType.number),
                      textForm(context, 'deskripsi', _deskripsi, _talent,
                          TextInputType.multiline),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Pick image'),
                          ElevatedButton(
                            onPressed: () {
                              _getFromGallery(ImageSource.gallery);
                            },
                            child: Text("GALLERY"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _getFromGallery(ImageSource.camera);
                            },
                            child: Text("CAMERA"),
                          ),
                        ],
                      ),
                      _load == true
                          ? Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(imageFile),
                                  ),
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.all(15.0),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.asset(
                                  'assets/images/komputer.png',
                                  height: 250.0,
                                  width: 300.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Colors.blueAccent.shade400,
                          ),
                        ),
                        onPressed: _saveForm,
                        child: const Text(
                          "Save",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }

  Widget textForm(BuildContext context, String type, FocusNode focus,
      FocusNode nextFocus, TextInputType keyboard) {
    return Card(
      child: Container(
        width: 170,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: TextFormField(
          initialValue: _initValues[type],
          style: const TextStyle(
            color: Colors.blue,
            letterSpacing: 0.5,
            fontFamily: 'PT Serif',
          ),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            labelText: type.toUpperCase(),
            labelStyle: TextStyle(
              color: Colors.blueAccent.shade200,
              fontFamily: 'PT Serif',
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent.shade400),
            ),
          ),
          keyboardType: keyboard,
          focusNode: focus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(nextFocus);
          },
          validator: (value) {
            if (type != 'email') {
              if (value!.isEmpty) {
                return "Enter $type";
              } else {
                return null;
              }
            }
            if (type == 'email') {
              if (value!.isEmpty) {
                return 'Enter Email';
              }
              if (value.contains('@') == false) {
                return "Enter Email yang valid";
              }
            } else {
              return null;
            }
          },
          onSaved: (value) {
            _editedMahasiswa = Mahasiswa(
              id: _editedMahasiswa.id,
              nama: type == 'nama' ? value.toString() : _editedMahasiswa.nama,
              email:
                  type == 'email' ? value.toString() : _editedMahasiswa.email,
              np: type == 'np' ? value.toString() : _editedMahasiswa.np,
              professi: dropdownvalue,
              noTelp: type == 'nomor telpon'
                  ? value.toString()
                  : _editedMahasiswa.noTelp,
              deskripsi: type == 'deskripsi'
                  ? value.toString()
                  : _editedMahasiswa.deskripsi,
              photo: _editedMahasiswa.photo,
              skills: [],
            );
          },
        ),
      ),
    );
  }

  Future _getFromGallery(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: source,
      maxWidth: 200,
      maxHeight: 200,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        _load = true;
      });
    }
  }
}

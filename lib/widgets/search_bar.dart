import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mahasiswa.dart';
import '../models/talent.dart';

class SearchBar extends StatelessWidget {
  final String type;
  const SearchBar({
    required this.type,
    super.key,
    required TextEditingController controller,
  }) : _controller = controller;

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
      onChanged: (value) {
        if (type == 'skill') {
          Provider.of<Talents>(context, listen: false)
              .changeSearchString(value);
        }
        if (type == 'mahasiswa') {
          Provider.of<Mahasiswas>(context, listen: false)
              .changeSearchString(value);
        }
      },
      autofocus: true,
      keyboardType: TextInputType.text,
    );
  }
}

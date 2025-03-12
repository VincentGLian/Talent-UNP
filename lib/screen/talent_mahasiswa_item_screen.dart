import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/mahasiswa.dart';
import '../models/talent.dart';
import '../widgets/mahasiswa_item.dart';

class TalentMahasiswaItemScreen extends StatelessWidget {
  static const routeNamed = '/talent_mhs_item_screen';
  const TalentMahasiswaItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments as String;
    String judul =
        Provider.of<Talents>(context, listen: false).findSkillTitle(data);
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text(
            judul.toUpperCase(),
          ),
        ),
        elevation: 5,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      body: Consumer<Mahasiswas>(
        builder: (context, value, _) => ListView.builder(
          itemBuilder: (ctx, index) {
            List<Mahasiswa> item = value.mahasiswaBySkill(data);
            return ChangeNotifierProvider.value(
              value: item[index],
              child: MahasiswaItem(),
            );
          },
          itemCount: value.mahasiswaBySkill(data).length,
        ),
      ),
    );
  }
}

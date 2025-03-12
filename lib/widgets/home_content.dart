import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu.dart';
import '../models/talent.dart';
import '../models/mahasiswa.dart';
import 'category_talent_item.dart';
import '../widgets/mahasiswa_item.dart';

class HomeContent extends StatelessWidget {
  final Menu menu;
  const HomeContent({required this.menu, super.key});

  @override
  Widget build(BuildContext context) {
    return menu == Menu.skill
        ? Consumer<Talents>(
            builder: (context, value, _) => ListView.builder(
              itemBuilder: (context, index) => CategoryTalentItem(
                data: value.talents[index],
                index: index,
              ),
              itemCount: value.talents.length,
            ),
          )
        : Consumer<Mahasiswas>(
            builder: (context, value, _) => ListView.builder(
              itemBuilder: (ctx, index) {
                return ChangeNotifierProvider.value(
                  value: value.mahasiswa[index],
                  child: MahasiswaItem(),
                );
              },
              itemCount: value.mahasiswa.length,
            ),
          );
  }
}

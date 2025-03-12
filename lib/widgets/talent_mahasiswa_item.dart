import 'package:flutter/material.dart';
import '../models/mahasiswa.dart';
import '../screen/detail_mahasiswa.dart';

class TalentMahasiswaItem extends StatelessWidget {
  Mahasiswa datamahasiswa;

  TalentMahasiswaItem({super.key, required this.datamahasiswa});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(DetailMahasiswa.routeName, arguments: datamahasiswa.id);
      },
      child: Container(
        height: 85,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1))],
        ),
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  datamahasiswa.nama,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 5),
                Text(
                  datamahasiswa.professi,
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'PT Serif',
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            leading: datamahasiswa.photo == 'assets/images/komputer.png' ||
                    datamahasiswa.photo == 'assets/images/kesehatan.png'
                ? Image.asset(
                    datamahasiswa.photo,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  )
                : Image.network(
                    datamahasiswa.photo,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
          ),
        ),
      ),
    );
  }
}

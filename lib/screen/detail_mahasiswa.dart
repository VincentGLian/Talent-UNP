import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth.dart';
import '../models/mahasiswa.dart';
import '../screen/edit_mahasiswa_detail_screen.dart';

class DetailMahasiswa extends StatelessWidget {
  static const routeName = '/detail-mhs';

  const DetailMahasiswa({super.key});

  @override
  Widget build(BuildContext context) {
    var dataAuth = Provider.of<Auth>(context);
    var width = MediaQuery.of(context).size.width * 0.40;
    var id = ModalRoute.of(context)!.settings.arguments;
    var mahasiswa = Provider.of<Mahasiswas>(context).findById(id.toString());
    var np = mahasiswa.professi == 'Mahasiswa' ? 'NIM' : 'NIP';

    List<Map<String, String>> info = [
      {'Nama': mahasiswa.nama},
      {np: mahasiswa.np},
      {'Profesi': mahasiswa.professi},
    ];
    List<Map<String, String>> contact = [
      {'Email': mahasiswa.email},
      {'No. HP': mahasiswa.noTelp},
    ];

    return Scaffold(
      backgroundColor: Colors.cyan[50],
      floatingActionButtonLocation: id == dataAuth.userId ||
              dataAuth.userId == "TckjM9pM3sR1xPk9TXLkpdAxFjQ2"
          ? FloatingActionButtonLocation.endTop
          : null,
      floatingActionButton: id == dataAuth.userId ||
              dataAuth.userId == "TckjM9pM3sR1xPk9TXLkpdAxFjQ2"
          ? FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditMahasiswaScreen.routeName,
                  arguments: mahasiswa.id,
                );
              },
              child: const Icon(Icons.edit, size: 20),
            )
          : null,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: mahasiswa.id,
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: mahasiswa.photo == 'assets/images/komputer.png'
                      ? Image.asset(
                          'assets/images/komputer.png',
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        )
                      : FadeInImage(
                          placeholder:
                              const AssetImage('assets/images/komputer.png'),
                          image: NetworkImage(mahasiswa.photo),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                margin: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Card(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Text(
                              'Personal Info',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Table(
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              columnWidths: const {
                                0: FlexColumnWidth(1),
                                1: FlexColumnWidth(2),
                              },
                              children: info.map((item) {
                                return TableRow(
                                  children: item.entries.map((entry) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${entry.key}:',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 8.0),
                                          Text(entry.value),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Card(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Text(
                              'About Me',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              mahasiswa.deskripsi,
                              style: Theme.of(context).textTheme.bodySmall,
                              softWrap: true,
                              textAlign: TextAlign.justify,
                              strutStyle: const StrutStyle(
                                height: 1.5,
                                leadingDistribution:
                                    TextLeadingDistribution.proportional,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Card(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Text(
                              'Skills',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Wrap(
                              spacing: 5.0,
                              runSpacing: 5.0,
                              children: List.generate(
                                mahasiswa.skills.length,
                                (index) {
                                  final item = mahasiswa.skills[index];
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        right: 5, left: 5, top: 5, bottom: 10),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    color: Colors.indigo[200],
                                    child: IntrinsicWidth(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            item.nama,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                          if (id == dataAuth.userId ||
                                              dataAuth.userId ==
                                                  "TckjM9pM3sR1xPk9TXLkpdAxFjQ2")
                                            IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.red.shade800,
                                                size: 15,
                                              ),
                                              onPressed: () {},
                                            )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // if (dataAuth.userId == id &&
                            //         dataAuth.userId != null ||
                            //     dataAuth.userId ==
                            //         'TckjM9pM3sR1xPk9TXLkpdAxFjQ2')
                            //   InkWell(
                            //     radius: 10,
                            //     onTap: () {
                            //       showModalBottomSheet(
                            //         context: context,
                            //         builder: (context) {
                            //           return Center(
                            //             child: Container(
                            //               child: ListView(),
                            //             ),
                            //           );
                            //         },
                            //       );
                            //     },
                            //     child: Icon(
                            //       Icons.add,
                            //       color: Colors.blue.shade800,
                            //       size: 15,
                            //     ),
                            //   )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Card(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Text(
                              'Contact Me',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Table(
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              columnWidths: const {
                                0: FlexColumnWidth(1),
                                1: FlexColumnWidth(2),
                              },
                              children: contact.map((item) {
                                return TableRow(
                                  children: item.entries.map((entry) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${entry.key}:',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 8.0),
                                          Text(entry.value),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talent_unp/screen/login_screen.dart';
import '../models/auth.dart';
import '../models/mahasiswa.dart';
import '../screen/detail_mahasiswa.dart';

class MahasiswaItem extends StatelessWidget {
  const MahasiswaItem({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 0.13;
    var width = MediaQuery.of(context).size.width;
    var mahasiswa = Provider.of<Mahasiswa>(context);
    var isLogin = Provider.of<Auth>(context);
    return Container(
      margin: const EdgeInsets.all(10),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.elliptical(10, 20)),
        color: Colors.blue[50],
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.5))],
      ),
      child: Dismissible(
        confirmDismiss: isLogin.userId == "TckjM9pM3sR1xPk9TXLkpdAxFjQ2" &&
                isLogin.userId != mahasiswa.id
            ? (direction) async {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: const Text("Serius Ingin Menghapus Data ini?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Provider.of<Mahasiswas>(context, listen: false)
                              .delMahasiswa(mahasiswa.id);
                          Navigator.of(context).pop(true);
                        },
                        child: const Text("Yaa"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text("Tidak"),
                      )
                    ],
                  ),
                );
              }
            : null,
        key: ValueKey(mahasiswa.id),
        background: Container(
          alignment: AlignmentDirectional.centerEnd,
          padding: const EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.elliptical(2, 1)),
            color: Theme.of(context).primaryColor,
          ),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        direction: isLogin.userId == "TckjM9pM3sR1xPk9TXLkpdAxFjQ2" &&
                isLogin.userId != mahasiswa.id
            ? DismissDirection.endToStart
            : DismissDirection.none,
        child: InkWell(
          onTap: () {
            isLogin.isAuth
                ? Navigator.of(context).pushNamed(
                    DetailMahasiswa.routeName,
                    arguments: mahasiswa.id,
                  )
                : showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: const Text(
                          "Anda perlu login sebelum bisa melihat data ini"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(LoginScreen.routeNamed)
                                .then((value) =>
                                    Navigator.of(context).pop(false));
                          },
                          child: const Text("Login"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text("Tutup"),
                        )
                      ],
                    ),
                  );
          },
          child: Container(
            height: height,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.elliptical(10, 20)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 0),
                )
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 0),
                        )
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Hero(
                      tag: mahasiswa.id,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: mahasiswa.photo == 'assets/images/komputer.png'
                            ? Image.asset(
                                'assets/images/komputer.png',
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high,
                              )
                            : FadeInImage(
                                placeholder:
                                    AssetImage('assets/images/komputer.png'),
                                image: NetworkImage(mahasiswa.photo),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          mahasiswa.nama,
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          mahasiswa.professi,
                          style: const TextStyle(color: Colors.black45),
                        ),
                        Container(
                          height: 25,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: mahasiswa.skills.length,
                            itemBuilder: (context, index) {
                              final skill = mahasiswa.skills[index];
                              return Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.indigo[300]),
                                  ),
                                  onPressed: null,
                                  child: Text(
                                    skill.nama,
                                    style:
                                        const TextStyle(color: Colors.black87),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(flex: 1, child: Container())
              ],
            ),
          ),
        ),
      ),
    );
  }
}

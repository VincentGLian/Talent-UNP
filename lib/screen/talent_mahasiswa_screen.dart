import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talent_unp/models/skill.dart';
import '../models/talent.dart';
import 'talent_mahasiswa_item_screen.dart';

class TalentMahasiswaScreen extends StatelessWidget {
  static const routeNamed = '/talent_mhs_screen';
  const TalentMahasiswaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 0.10;
    var data = ModalRoute.of(context)!.settings.arguments as String;
    String judul =
        Provider.of<Talents>(context, listen: false).findByTitle(data);
    List<Skill> skills =
        Provider.of<Talents>(context, listen: false).findById(data);
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Image.asset(
              'assets/images/komputer.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          TalentMahasiswaItemScreen.routeNamed,
                          arguments: skills[index].id);
                    },
                    child: Container(
                      height: height,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue.shade100),
                        borderRadius:
                            const BorderRadius.all(Radius.elliptical(40, 80)),
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
                      child: Center(
                        child: Text(
                          skills[index].nama,
                          style: const TextStyle(
                            color: Colors.indigo,
                            fontSize: 24,
                            fontFamily: 'PT Serif',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: skills.length,
              )),
        ],
      ),
    );
  }
}

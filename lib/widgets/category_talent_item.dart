import 'package:flutter/material.dart';
import '../models/talent.dart';
import '../screen/talent_mahasiswa_screen.dart';

class CategoryTalentItem extends StatelessWidget {
  final int index;
  final Talent data;

  const CategoryTalentItem({
    super.key,
    this.index = 0,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    Talent talent = data;
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(TalentMahasiswaScreen.routeNamed, arguments: talent.id);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        margin: const EdgeInsets.only(bottom: 30),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Container(
              height: 110,
              width: mediaQuery.width,
              decoration: BoxDecoration(
                color: index.isEven
                    ? Colors.indigo
                    : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Container(
              height: 110,
              width: mediaQuery.width * 0.91,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 10,
                    blurRadius: 10,
                    offset: const Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            talent.judul.toUpperCase(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 110,
                    width: 100,
                    child: Image(
                      image: AssetImage(talent.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Container(
              height: 25,
              alignment: Alignment.center,
              width: mediaQuery.width * 0.5,
              decoration: BoxDecoration(
                color: index.isEven
                    ? Theme.of(context).primaryColor
                    : Colors.indigo,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(40),
                    bottomLeft: Radius.circular(30)),
              ),
              child: const Text(
                "Click to See More",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu.dart';
import '../models/talent.dart';
import '../models/mahasiswa.dart';
import '../models/auth.dart';
import '../widgets/drawer.dart';
import '../widgets/home_content.dart';

class HomePage extends StatefulWidget {
  static const routeNamed = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isInit = true;
  bool _isloading = false;
  @override
  void didChangeDependencies() {
    if (_isInit == true) {
      setState(() {
        _isloading = true;
      });
      Provider.of<Auth>(context, listen: false).tryAutoLogin().then((_) {
        Provider.of<Talents>(context, listen: false).fetchTalent().then((_) {
          Provider.of<Mahasiswas>(context, listen: false).fetchMahasiswa();
        }).then((_) {
          setState(() {
            _isloading = false;
          });
        });
      });

      _isInit = false;
      super.didChangeDependencies();
    }
  }

  Menu _menu = Menu.skill;
  bool isLoading = false;

  void _selectMenu(Menu menu) {
    _menu = menu;
  }

  final GlobalKey<ScaffoldState> _sKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var isLogin = Provider.of<Auth>(context);
    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      endDrawer: const NavDrawer(),
      key: _sKey,
      body: _isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: mediaQuery.height,
                    width: mediaQuery.width,
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 30),
                    color: Theme.of(context).primaryColorDark,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FittedBox(
                              child: Text(
                                "Hii.. ${isLogin.userId == null ? "Guest" : isLogin.username}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'PT Serif',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.menu,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _sKey.currentState?.openEndDrawer();
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'PT Serif',
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              border: InputBorder.none,
                              hintText: "Search by ${_menu.name}",
                              hintStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              prefixIcon: const Icon(Icons.search),
                              prefixIconColor: Colors.white,
                            ),
                            onChanged: (value) {
                              if (_menu == Menu.skill) {
                                Provider.of<Talents>(context, listen: false)
                                    .changeSearchString(value);
                              }
                              if (_menu == Menu.mahasiswa) {
                                Provider.of<Mahasiswas>(context, listen: false)
                                    .changeSearchString(value);
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  backgroundColor: MaterialStateProperty.all(
                                      _menu == Menu.skill
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context)
                                              .primaryColorDark)),
                              onPressed: () {
                                setState(() {
                                  _selectMenu(Menu.skill);
                                });
                              },
                              child: const Text(
                                "Skill",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'PT Serif',
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  backgroundColor: MaterialStateProperty.all(
                                      _menu == Menu.mahasiswa
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context)
                                              .primaryColorDark)),
                              onPressed: () {
                                setState(() {
                                  _selectMenu(Menu.mahasiswa);
                                });
                              },
                              child: const Text(
                                "Mahasiswa",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'PT Serif',
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: mediaQuery.height * 0.65,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(50),
                      ),
                    ),
                  ),
                  Container(
                    height: mediaQuery.height * 0.7,
                    child: HomeContent(menu: _menu),
                  )
                ],
              ),
            ),
    );
  }
}

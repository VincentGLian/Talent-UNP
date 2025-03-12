import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talent_unp/screen/home_page.dart';
import '../models/auth.dart';
import '../screen/register_screen.dart';
import '../screen/detail_mahasiswa.dart';
import '../screen/edit_mahasiswa_detail_screen.dart';
import '../screen/login_screen.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final dataAuth = Provider.of<Auth>(context, listen: false);
    return Drawer(
      backgroundColor: Theme.of(context).primaryColorDark,
      elevation: 2,
      child: ListView(
        padding: const EdgeInsets.only(left: 20),
        children: [
          const SizedBox(height: 40),
          if (dataAuth.isAuth == false)
            ListTile(
              leading: const Icon(Icons.login),
              iconColor: Colors.white,
              title: Text(
                'Login',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              onTap: () => {
                Navigator.of(context)
                    .pushReplacementNamed(LoginScreen.routeNamed),
              },
            ),
          if (dataAuth.isAuth == false)
            ListTile(
              leading: const Icon(Icons.person_add),
              iconColor: Colors.white,
              title: Text(
                'Register',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              onTap: () => {
                Navigator.of(context)
                    .pushReplacementNamed(RegisterScreen.routeNamed),
              },
            ),
          if (dataAuth.isAuth == true)
            ListTile(
              leading: const Icon(Icons.verified_user),
              iconColor: Colors.white,
              title: Text(
                'Profile',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              onTap: () => {
                Navigator.of(context)
                    .pushNamed(DetailMahasiswa.routeName,
                        arguments: dataAuth.userId)
                    .then((_) => Navigator.of(context).pop())
              },
            ),
          const SizedBox(height: 10),
          if (dataAuth.userId == ("TckjM9pM3sR1xPk9TXLkpdAxFjQ2"))
            ListTile(
              leading: const Icon(Icons.add),
              iconColor: Colors.white,
              title: Text(
                'Tambah Mahasiswa',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              onTap: () => {
                Navigator.of(context)
                    .pushNamed(EditMahasiswaScreen.routeName)
                    .then((_) => Navigator.of(context).pop())
              },
            ),
          const SizedBox(height: 10),
          if (dataAuth.isAuth == true)
            ListTile(
              leading: const Icon(Icons.logout),
              iconColor: Colors.white,
              title: Text(
                'Logout',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              onTap: () {
                dataAuth.logout();
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }
}

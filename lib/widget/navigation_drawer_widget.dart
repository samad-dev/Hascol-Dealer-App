import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pandamart/Screens/Dashboard.dart';
import 'package:pandamart/Screens/complaint.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Home.dart';
import '../Screens/Dash.dart';
import '../model/drawer_item.dart';
import '../provider/navigator_provider.dart';

class Nav extends StatefulWidget {
  const Nav({Key? key}) : super(key: key);

  @override
  State<Nav> createState() => NavigationDrawerWidget();
}
class NavigationDrawerWidget extends State<Nav> {


  final padding = EdgeInsets.symmetric(horizontal: 20);

  final itemsFirst = [
    DrawerItem(title: 'Dashboard', icon: Icons.dashboard_customize),
  ];
  final itemsSecond = [
    DrawerItem(title: 'Orders', icon: Icons.shopping_cart_checkout_rounded),
  ];
  final itemsThird = [
    DrawerItem(title: 'Complaint', icon: Icons.message),
  ];
/*
  final itemsSecond = [
    DrawerItem(title: 'Vehicle List', icon: Icons.car_rental_outlined),
  ];
  final itemsThird = [
    DrawerItem(title: 'Alert', icon: Icons.car_crash),
  ];
  final itemsFourth = [
    DrawerItem(title: 'Settings', icon: Icons.settings),
  ];
  */
  final itemsFifth = [
    DrawerItem(title: 'Signout', icon: Icons.exit_to_app),
  ];
  late String name;
  late String email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // show();
  }
  @override
  Widget build(BuildContext context) {
    final safeArea =
        EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);

    final provider = Provider.of<NavigationProvider>(context);
    final isCollapsed = provider.isCollapsed;
    // show();
    return Container(
      width: isCollapsed ? MediaQuery.of(context).size.width * 0.2 : null,
      child: Drawer(
        child: Container(
          color: Color(0xff2b3993),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 14).add(safeArea),
                width: double.infinity,
                color: Color(0xff2b3993),
                child: buildHeader(isCollapsed),
              ),
              const SizedBox(height: 3),
              Divider(color: Colors.white70),
              const SizedBox(height: 3),
              buildList(items: itemsFirst, indexOffset: 0, isCollapsed: isCollapsed),
              const SizedBox(height: 3),

              Divider(color: Colors.white70),
              const SizedBox(height: 3),
              buildList(
                indexOffset: 1,
                items: itemsSecond,
                isCollapsed: isCollapsed,
              ),
              const SizedBox(height: 3),
              Divider(color: Colors.white70),
              const SizedBox(height: 3),
              buildList(items: itemsThird, indexOffset: 2, isCollapsed: isCollapsed),
              const SizedBox(height: 3),
              Divider(color: Colors.white70),
              /*buildList(
                indexOffset: 1,
                items: itemsSecond,
                isCollapsed: isCollapsed,
              ),
              const SizedBox(height: 3),
              Divider(color: Colors.white70),
              const SizedBox(height: 3),
              buildList(items: itemsThird, indexOffset: 2, isCollapsed: isCollapsed),
              const SizedBox(height: 3),
              Divider(color: Colors.white70),
              const SizedBox(height: 3),
              buildList(items: itemsFourth, indexOffset: 3, isCollapsed: isCollapsed),
              const SizedBox(height: 3),
              Divider(color: Colors.white70),
              const SizedBox(height: 3),*/
              buildList(items: itemsFifth, indexOffset: 4, isCollapsed: isCollapsed),
              const SizedBox(height: 3),
              Spacer(),
              buildCollapseIcon(context, isCollapsed),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList({
    required bool isCollapsed,
    required List<DrawerItem> items,
    int indexOffset = 0,
  }) =>
      ListView.separated(
        padding: isCollapsed ? EdgeInsets.zero : padding,
        shrinkWrap: true,
        primary: false,
        itemCount: items.length,
        separatorBuilder: (context, index) => SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = items[index];

          return buildMenuItem(
            isCollapsed: isCollapsed,
            text: item.title,
            icon: item.icon,
            onClicked: () => selectItem(context, indexOffset + index),
          );
        },
      );

  Future<void> selectItem(BuildContext context, int index) async {
    final navigateTo = (page) => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => page,
        ));

    Navigator.of(context).pop();

    switch (index) {

      case 0:
        print(index);
        navigateTo(MyHomePage());
        break;
      case 1:
        navigateTo(Home2());
        break;
      case 2:
        navigateTo(Create_Comp());
        break;
      // case 2:
      //   navigateTo(AlertList());
      //   break;
      // case 3:
      //   navigateTo(SettingPage());
      //   break;
      case 4:
        print('Samad'+index.toString());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('userId');
        prefs.remove('email');
        prefs.remove('user_name');
        prefs.remove('vehi_id');
        navigateTo(Home());
        break;
      // case 5:
      //   navigateTo(ResourcesPage());
      //   break;
    }
  }

  Widget buildMenuItem({
    required bool isCollapsed,
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final leading = Icon(icon, color: color);

    return Material(
      color: Colors.transparent,
      child: isCollapsed
          ? ListTile(
              title: leading,
              onTap: onClicked,
            )
          : ListTile(
              leading: leading,
              title: Text(text, style: TextStyle(color: color, fontSize: 16)),
              onTap: onClicked,
            ),
    );
  }

  Widget buildCollapseIcon(BuildContext context, bool isCollapsed) {
    final double size = 52;
    final icon = isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios;
    final alignment = isCollapsed ? Alignment.center : Alignment.centerRight;
    final margin = isCollapsed ? null : EdgeInsets.only(right: 16);
    final width = isCollapsed ? double.infinity : size;

    return Container(
      alignment: alignment,
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Container(
            width: width,
            height: size,
            child: Icon(icon, color: Colors.white),
          ),
          onTap: () {
            final provider =
                Provider.of<NavigationProvider>(context, listen: false);

            provider.toggleIsCollapsed();
          },
        ),
      ),
    );
  }

  Widget buildHeader(bool isCollapsed) => isCollapsed
      ? new Icon(Icons.account_circle , color: Colors.white,)
      :  Container(
    color: Color(0xff2b3993),
    height: 150,
    padding: EdgeInsets.only(top: 10.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage('https://www.pngall.com/wp-content/uploads/12/Avatar-Profile-Vector-PNG-File.png'),
            ),
          ),
        ),
        Text(
          "Hascol",
          style: TextStyle(color: Colors.amber, fontSize: 20),
        ),
        Text(
         "Dealer Application",
          style: TextStyle(color: Colors.amber, fontSize: 14),
        ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Divider(
                  color: Colors.white,
                  height: 1,
                ),
                InkWell(
                  onTap: () {},
                  child: ListTile(
                    dense: true,
                    leading: Icon(Icons.settings, color: Colors.white),
                    title: Text('Settings'),
                  ),
                ),
                Divider(
                  color: Colors.white,
                  height: 1,
                ),
                InkWell(
                  onTap: () {},
                  child: ListTile(
                    dense: true,
                    leading: Icon(Icons.settings, color: Colors.white),
                    title: Text('Settings'),
                  ),
                ),
                Divider(
                  color: Colors.white,
                  height: 1,
                ),
                InkWell(
                  onTap: () {},
                  child: ListTile(
                    dense: true,
                    leading: Icon(Icons.settings, color: Colors.white),
                    title: Text('Settings'),
                  ),
                ),
                Divider(
                  color: Colors.white,
                  height: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

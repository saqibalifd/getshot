import 'package:flutter/material.dart';
import 'package:getshotapp/constants/app_colors.dart';
import 'package:getshotapp/models/all_user_model.dart';
import 'package:getshotapp/models/screenshot_model.dart';
import 'package:getshotapp/widgets/all_users_tile.dart';
import 'package:getshotapp/widgets/sidebar_alluser.dart';
import 'package:getshotapp/widgets/topbar_alluser_widget.dart';
import 'package:getshotapp/view/screenshots/screenshots_view.dart';

class AllUsersView extends StatelessWidget {
  AllUsersView({super.key});

  final List<AllUserModel> allUsersList = <AllUserModel>[
    AllUserModel(
      name: 'Asif Ali',
      role: 'user',
      ipadress: '8dg34 43s908 34985fs',
      lastActive: DateTime.now(),
      activeStatus: true,
      screenshots: [
        ScreenshotModel(
          downloadUrl:
              'https://i.pinimg.com/736x/c9/c1/57/c9c1575be0bcb44bb372d1e5d6ed685d.jpg',
          id: '345:349058:40508',
        ),
        ScreenshotModel(
          downloadUrl:
              'https://forum-content.sourceruns.org/original/2X/5/50b9a2b38c9152ae700ec72c0c2916cf91024147.jpeg',
          id: '578329875923984758927',
        ),
        ScreenshotModel(
          downloadUrl:
              'https://cdn.lo4d.com/t/screenshot/800/whatsapp-windows.png',
          id: '209387208',
        ),
      ],
    ),
    AllUserModel(
      name: 'Naveed Aslam',
      role: 'user',
      ipadress: '73953dfn 09583fd 3095835732f ',
      lastActive: DateTime.now(),
      activeStatus: false,
      screenshots: [
        ScreenshotModel(
          downloadUrl:
              'https://static.beebom.com/wp-content/uploads/2016/05/WhatsApp-Desktop-App.jpg',
          id: '345:349058:40508',
        ),
      ],
    ),
    AllUserModel(
      name: 'Javed Ahmad',
      role: 'user',
      ipadress: '7dsfjsljfn 043kjhfd 3sdsdfg2f ',
      lastActive: DateTime.now(),
      activeStatus: true,
      screenshots: [
        ScreenshotModel(
          downloadUrl:
              'https://store-images.s-microsoft.com/image/apps.1500.14208673485779370.bb73a8cd-b201-4c17-bdb3-5c8edccb7dee.6f9b6ebc-6e40-4114-923c-fb05c208aa9c',
          id: '345:349058:40508',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroudColor,
      body: Row(
        children: [
          SidebarAlluser(),

          Expanded(
            child: Column(
              children: [
                TopbarAlluserWidget(
                  title: 'Connected Users',
                  onClearAll: () {
                    print('clear all');
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: allUsersList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScreenshotsView(
                                  name: allUsersList[index].name,
                                  activeStatus:
                                      allUsersList[index].activeStatus,
                                  ipadress: allUsersList[index].ipadress,
                                  lastActive: allUsersList[index].lastActive,
                                  screenShots: allUsersList[index].screenshots,
                                ),
                              ),
                            );
                          },
                          child: AllUsersTile(
                            name: allUsersList[index].name,
                            role: allUsersList[index].role,
                            ipAddress: allUsersList[index].ipadress,
                            isActive: allUsersList[index].activeStatus,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:getshotapp/constants/app_colors.dart';
import 'package:getshotapp/models/screenshot_model.dart';

import 'package:getshotapp/view/allUsers/all_users_view.dart';
import 'package:getshotapp/view/screenshots/full_screen_Image_view.dart';
import 'package:getshotapp/widgets/grid_card_widget.dart';
import 'package:getshotapp/widgets/sidebar_screenshotview_widght.dart';
import 'package:getshotapp/widgets/topbar_alluser_widget.dart';

class ScreenshotsView extends StatelessWidget {
  final String name;
  final bool activeStatus;
  final String ipadress;
  final String longitude;
  final String latitude;
  final DateTime lastActive;
  final List<ScreenshotModel> screenShots;

  const ScreenshotsView({
    super.key,
    required this.name,
    required this.activeStatus,
    required this.ipadress,
    required this.longitude,
    required this.latitude,
    required this.lastActive,
    required this.screenShots,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroudColor,
      body: Row(
        children: [
          SidebarScreenshotviewWidght(
            selectedUser: SidebarUser(
              name: name,
              ipAddress: ipadress,
              isActive: activeStatus,
              lastActive: lastActive,
              latitude: latitude,
              longitude: longitude,
              imageUrl: null, // or a URL string
            ),
            onScreenshotTap: () {},
            onAllUserTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AllUsersView()),
            ),
          ),

          Expanded(
            child: Column(
              children: [
                TopbarAlluserWidget(
                  title: "Screen Shots",
                  onClearAll: () {
                    print('clear all');
                  },
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: screenShots.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridCardWidget(
                          onView: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImageView(
                                  imageUrl: screenShots[index].downloadUrl,
                                  title: screenShots[index].id,
                                ),
                              ),
                            );
                          },
                          onDownload: () {
                            print('on download tap');
                          },
                          imageUrl: screenShots[index].downloadUrl,
                          title: screenShots[index].id,
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

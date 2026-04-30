import 'package:flutter/material.dart';
import 'package:getshotapp/provider/admin_provider.dart';
import 'package:getshotapp/widgets/empty_state_widget.dart';
import 'package:provider/provider.dart';

import 'package:getshotapp/constants/app_colors.dart';
import 'package:getshotapp/models/device_model.dart';
import 'package:getshotapp/util/location_util.dart';
import 'package:getshotapp/widgets/all_users_tile.dart';
import 'package:getshotapp/widgets/sidebar_alluser.dart';
import 'package:getshotapp/widgets/topbar_alluser_widget.dart';
import 'package:getshotapp/view/screenshots/screenshots_view.dart';

class AllUsersView extends StatefulWidget {
  const AllUsersView({super.key});

  @override
  State<AllUsersView> createState() => _AllUsersViewState();
}

class _AllUsersViewState extends State<AllUsersView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<AdminProvider>(context, listen: false).fetchDeviceData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);

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
                    Provider.of<AdminProvider>(
                      context,
                      listen: false,
                    ).clearAllData();
                  },
                ),

                if (provider.isLoading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (provider.devices.isEmpty)
                  const EmptyStateWidget()
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.devices.length,
                      itemBuilder: (context, index) {
                        final user = provider.devices[index];

                        double lat = double.tryParse(user.latitude) ?? 0;
                        double lng = double.tryParse(user.longitude) ?? 0;

                        return FutureBuilder<String>(
                          future: LocationUtils.getAddressFromLatLng(
                            latitude: lat,
                            longitude: lng,
                          ),
                          builder: (context, snapshot) {
                            String address = "Loading...";

                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              address = snapshot.data!;
                            }

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ScreenshotsView(
                                        name: user.name,
                                        activeStatus: user.activeStatus,
                                        ipadress: user.ipadress,
                                        longitude: user.longitude,
                                        latitude: user.latitude,
                                        lastActive: user.lastActive,
                                        screenShots: user.screenshots,
                                      ),
                                    ),
                                  );
                                },
                                child: AllUsersTile(
                                  name: user.name,
                                  role: user.role,
                                  location: address,
                                  ipAddress: user.ipadress,
                                  isActive: user.activeStatus,
                                ),
                              ),
                            );
                          },
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // PROFILE IDENTITY BLOCK
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                // Avatar
                const SizedBox(width: 15),

                // Name + Email
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 85,
                        height: 85,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 45,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Name
                      Text(
                        controller.userName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Email
                      // Text(
                      //   controller.email,
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     color: Colors.grey.shade600,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // ACCOUNT INFO SECTION
          _sectionTitle("Account Information"),

          const SizedBox(height: 10),

          _infoCard([
            _infoItem(Icons.phone_outlined, "Phone", controller.phone),
            const Divider(height: 25),
            _infoItem(Icons.email_outlined, "Email", controller.email),
          ]),

          const SizedBox(height: 25),

          // SETTINGS SECTION
          _sectionTitle("Settings"),

          const SizedBox(height: 10),

          _actionCard([
            _actionItem(
              icon: Icons.settings_outlined,
              title: "General Settings",
              onTap: () {},
            ),
            const Divider(height: 1),
            _actionItem(
              icon: Icons.security_outlined,
              title: "Privacy & Security",
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 25),

          // LOGOUT
          _actionCard([
            _actionItem(
              icon: Icons.logout,
              title: "Logout",
              isDestructive: true,
              onTap: () {
                Get.dialog(
                  Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// ICON
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.logout_rounded,
                              color: Colors.red,
                              size: 32,
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// TITLE
                          const Text(
                            "Confirm Logout",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          /// MESSAGE
                          const Text(
                            "You will need to login again to access your account.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),

                          const SizedBox(height: 20),

                          /// BUTTONS
                          Row(
                            children: [
                              /// CANCEL
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Get.back(),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text("Cancel"),
                                ),
                              ),

                              const SizedBox(width: 12),

                              /// LOGOUT
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                    controller.logout();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    "Logout",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ]),
        ],
      ),
    );
  }

  //SECTION TITLE

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
        letterSpacing: 0.5,
      ),
    );
  }

  // INFO CARD

  Widget _infoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  // ACTION CARD

  Widget _actionCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  // INFO ITEM

  Widget _infoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(value, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  //ACTION ITEM

  Widget _actionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(icon, color: isDestructive ? Colors.red : Colors.black87),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }
}

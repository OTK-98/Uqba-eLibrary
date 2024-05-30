import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uqba_elibrary/controller/login_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isDarkMode = false;
  bool _isNotificationsEnabled = false;

  LoginController authController = Get.put(LoginController());

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: _isDarkMode
              ? Color(0xFF1A2836)
              : Theme.of(context).colorScheme.primary,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: _isDarkMode
                        ? Color(0xFF15202B)
                        : Color(
                            0xFFFFF0EACF), // Change header color based on theme
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100.r),
                      bottomRight: Radius.circular(100.r),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 9,
                            child: Text(
                              "الملف الشخصي",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    _isDarkMode ? Colors.white : Colors.black,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(
                                Icons.logout,
                                color:
                                    _isDarkMode ? Colors.white : Colors.black,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: _isDarkMode
                                          ? Color(0xFF1F1F1F)
                                          : Colors.white,
                                      title: Text(
                                        "تنبيه!",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      content: Text(
                                        "هل تريد تسجيل الخروج؟",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: _isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor: Colors.red,
                                              ),
                                              onPressed: () {
                                                authController.signout();
                                              },
                                              child: Text("تأكيد"),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.black,
                                                backgroundColor:
                                                    Colors.grey[300],
                                              ),
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: Text("إلغاء"),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            width: 2,
                            color: _isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              "${authController.auth.currentUser!.photoURL}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "${authController.auth.currentUser!.displayName}",
                        // "User Name",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _isDarkMode ? Colors.white : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${authController.auth.currentUser!.email}",
                        // "example@gmail.com",
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              _isDarkMode ? Colors.white54 : Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SwitchListTile(
                        title: Text(
                          "الوضع الليلي",
                          style: TextStyle(
                            fontSize: 18,
                            color: _isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          "تفعيل / تعطيل الوضع الليلي",
                          style: TextStyle(
                            fontSize: 14,
                            color: _isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        value: _isDarkMode,
                        onChanged: (value) {
                          // _toggleTheme();
                        },
                        activeColor: Colors.white,
                        inactiveThumbColor: Color(0xFF573720),
                      ),
                      SwitchListTile(
                        title: Text(
                          "الإشعارات",
                          style: TextStyle(
                            fontSize: 18,
                            color: _isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          "تفعيل / تعطيل الإشعارات",
                          style: TextStyle(
                            fontSize: 14,
                            color: _isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        value: _isNotificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            _isNotificationsEnabled = value;
                          });
                        },
                        activeColor: Color(0xFF573720),
                        inactiveThumbColor: Color(0xFF573720),
                      ),
                      ListTile(
                        onTap: () {},
                        title: Text(
                          "سياسة الخصوصية",
                          style: TextStyle(
                            fontSize: 18,
                            color: _isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          "شروط وسياسات التطبيق",
                          style: TextStyle(
                            fontSize: 14,
                            color: _isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        title: Text(
                          "حول التطبيق",
                          style: TextStyle(
                            fontSize: 18,
                            color: _isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          "معلومات التطبيق وإصدار البناء",
                          style: TextStyle(
                            fontSize: 14,
                            color: _isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),

                      // Add other features like notifications, privacy policy, about, etc. here
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

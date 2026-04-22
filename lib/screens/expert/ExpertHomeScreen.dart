import 'package:flutter/material.dart';
import 'ExpertProfile.dart'; // استيراد صفحة ExpertProfile
import 'EpertSettings.dart'; // استيراد صفحة ExpertSettings

class ExpertHomeScreen extends StatefulWidget {
  const ExpertHomeScreen({super.key});

  static const Color lightPurple = Color(0xFFC4C8EA);

  @override
  State<ExpertHomeScreen> createState() => _ExpertHomeScreenState();
}

class _ExpertHomeScreenState extends State<ExpertHomeScreen> {

  int selectedTab = 0;

  List<String> requests = ["Request 1", "Request 2", "Request 3"];
  List<String> pending = ["Pending Request 1", "Pending Request 2"];
  List<String> approved = ["Approved Request 1", "Approved Request 2"];

  @override
  Widget build(BuildContext context) {

    List<String> currentList;

    if (selectedTab == 0) {
      currentList = requests;
    } else if (selectedTab == 1) {
      currentList = pending;
    } else {
      currentList = approved;
    }

    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [

          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: ExpertHomeScreen.lightPurple,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(90),
                bottomRight: Radius.circular(90),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // تغيير من هنا
                  GestureDetector(
                    onTap: () {
                      // عند الضغط على الأيقونة، سيتم التوجيه إلى صفحة ExpertProfile
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileExpertScreen(),
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // إضافة التوجيه إلى صفحة ExpertSettings عند الضغط على الأيقونة
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsProfileScreen(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.settings,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Column(
            children: [

              const SizedBox(height: 120),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: currentList.length,
                  itemBuilder: (context, index) {

                    return GestureDetector(
                      onTap: () {
                        if (selectedTab == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ExpertChatScreen(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 6,
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0,3)
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: selectedTab == 0
                                    ? Colors.red
                                    : selectedTab == 1
                                    ? Colors.orange
                                    : Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),const SizedBox(width: 12),

                            Text(
                              currentList[index],
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Container(
                height: 70,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black12,
                    )
                  ],
                ),
                child: Row(
                  children: [

                    tabButton("Requests", 0),
                    tabButton("Pending", 1),
                    tabButton("Approved", 2),

                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget tabButton(String title, int index) {

    bool active = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? ExpertHomeScreen.lightPurple : Colors.white,
            border: const Border(
              right: BorderSide(color: Colors.black12),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: active ? Colors.black : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}

class ExpertChatScreen extends StatelessWidget {
  const ExpertChatScreen({super.key});

  static const Color lightPurple = Color(0xFFC4C8EA);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [

          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: lightPurple,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(90),
                bottomRight: Radius.circular(90),
              ),
            ),
          ),SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    "Report",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),

          Column(
            children: [

              const SizedBox(height: 150),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "The report and the user comment will be displayed here",
                  textAlign: TextAlign.center,style: TextStyle(fontSize: 16),
                ),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                  vertical: 30,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightPurple,shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Accept",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
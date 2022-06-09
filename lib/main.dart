import 'dart:async';

import 'package:admin_app/models/promotion_code.dart';
import 'package:admin_app/screens/filebase_login_screen.dart';
import 'package:admin_app/screens/pin_plays_screen.dart';
import 'package:admin_app/screens/promotion_codes_screen.dart';
import 'package:admin_app/screens/promotion_users_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:admin_app/firebase_options.dart';
import 'package:provider/provider.dart';

import 'models/admin_info.dart';
Future<void> main() async {

  if(kDebugMode){
    await dotenv.load(
      fileName: '.env.development'
    );
  }else if(kProfileMode){
    await dotenv.load(
        fileName: '.env.staging'
    );
  }else {
    await dotenv.load(
        fileName: '.env.production'
    );
  }

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print(dotenv.env['MODE']);
  runApp(
       const MyApp(),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AdminInfo()),
        ],
        child: MaterialApp(
          title: 'SPEC ADMIN',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          onGenerateRoute: (settings){
            if(settings.name == PromotionUsersScreen.routeName){
              final PromotionCode code = settings.arguments as PromotionCode;

              return MaterialPageRoute(
                  builder: (context) {
                    return PromotionUsersScreen(promotionCode: code);
                  });
            }
          },
          home: const MyHomePage(title: "Spec Admin",),
          debugShowCheckedModeBanner: false,
        )
      );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController page = PageController();

  bool isLoggedIn = false;
  String token = '';

  late StreamSubscription<User?> user;

  @override
  void initState(){
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
        setState(() {
          isLoggedIn = false;
        });

      } else {
        print('User is signed in!');

        user.getIdToken().then((value){
          debugPrint("User Token: $value");
          setState(() {
            isLoggedIn = true;
            token = value;
          });
          context.read<AdminInfo>().token = value;
        });

      }
    });
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }
  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('${widget.title}-${dotenv.env["MODE"]}'),
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // _auth.signOut();
                // Navigator.pop(context);
                logout();
                //   getMessages();
                //Implement logout functionality
              }),
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(!isLoggedIn)
            Center(
              child: Container(
                  width: 300,
                  height: 600,
                  child:
                  LoginSignupScreen(),
              ),
            ),
          if(isLoggedIn)
            SideMenu(
              controller: page,
              onDisplayModeChanged: (mode) {
                print(mode);
              },
              style: SideMenuStyle(
                displayMode: SideMenuDisplayMode.auto,
                hoverColor: Colors.blue[100],
                selectedColor: Colors.lightBlue,
                selectedTitleTextStyle: const TextStyle(color: Colors.white),
                selectedIconColor: Colors.white,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.all(Radius.circular(10)),
                // ),
                // backgroundColor: Colors.blueGrey[700]
              ),
              footer: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'pridekk@gmail.com',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              items: [
                SideMenuItem(
                  priority: 0,
                  title: '핀플레이',
                  onTap: () {
                    page.jumpToPage(0);
                  },
                  icon: const Icon(Icons.pin_drop ),
                ),
                SideMenuItem(
                  priority: 1,
                  title: '프로모션',
                  onTap: () {
                    page.jumpToPage(1);
                  },
                  icon: const Icon(Icons.ads_click),

                ),
                SideMenuItem(
                  priority: 2,
                  title: 'Files',
                  onTap: () {
                    page.jumpToPage(2);
                  },
                  icon: const Icon(Icons.file_copy_rounded),
                ),
                SideMenuItem(
                  priority: 3,
                  title: 'Download',
                  onTap: () {
                    page.jumpToPage(3);
                  },
                  icon: const Icon(Icons.download),
                ),
                SideMenuItem(
                  priority: 4,
                  title: 'Settings',
                  onTap: () {
                    page.jumpToPage(4);
                  },
                  icon: const Icon(Icons.settings),
                ),
                SideMenuItem(
                  priority: 6,
                  title: 'Exit',
                  onTap: () async {},
                  icon: const Icon(Icons.exit_to_app),
                ),
              ],
            ),
          if(isLoggedIn)
            Expanded(
              child: SizedBox(
                child: PageView(

                  controller: page,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: const Center(
                            child: PinPlaysScreen()
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: PromotionCodes()

                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: const Center(
                        child: Text(
                          'Files',
                          style: TextStyle(fontSize: 35),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: const Center(
                        child: Text(
                          'Download',
                          style: TextStyle(fontSize: 35),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: const Center(
                        child: Text(
                          'Settings',
                          style: TextStyle(fontSize: 35),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),


        ],
      ),
    );
  }
}

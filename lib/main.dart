import 'dart:async';

import 'package:admin_app/color_schemes.g.dart';
import 'package:admin_app/models/promotion_code.dart';
import 'package:admin_app/screens/filebase_login_screen.dart';
import 'package:admin_app/screens/pinpaly_detail_screen.dart';
import 'package:admin_app/screens/pinplays_screen.dart';
import 'package:admin_app/screens/promotion_codes_screen.dart';
import 'package:admin_app/screens/promotion_users_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
            useMaterial3: true,
            colorScheme: lightColorScheme
          ),
          darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: darkColorScheme
          ),
          themeMode: ThemeMode.system,
          onGenerateRoute: (settings){
            if(settings.name == PromotionUsersScreen.routeName){
              final PromotionCode code = settings.arguments as PromotionCode;

              return MaterialPageRoute(
                  builder: (context) {
                    return PromotionUsersScreen(promotionCode: code);
                  });
            }else if(settings.name == PinPlayDetailScreen.routeName){
              final int playId = settings.arguments as int;

              return MaterialPageRoute(
                  builder: (context) {
                    return PinPlayDetailScreen(playId: playId);
                  });
            }
          },
          routes: {
            "/":  (context) => const MyHomePage(title: "Spec Admin",),
            "/promotion_code_detail": (context){
              var code = PromotionCode(id:34, code:"text", startedAt: "2022-05-30",
                  expiredAt: "2022-09-01", users: 30, enabled: true, userList: [], description: "");
              return PromotionUsersScreen(promotionCode: code);
            },
            "/pinplay_detail": (context){
              return PinPlayDetailScreen(playId: 337);
            },
          },
          initialRoute: "/pinplay_detail",

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
  int currentPageIndex = 0;
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

    Widget main;

    if(!isLoggedIn){
      main = Center(
        child: Container(
          width: 300,
          height: 600,
          child:
          LoginSignupScreen(),
        ),
      );
    } else {
      main =Center(
        child:
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
          )
      );
    }


    return Scaffold(

      appBar: AppBar(
        title: Text('${widget.title}'),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: logout,
              tooltip: "Logout",
              icon: const Icon(Icons.logout)
          )
        ],
      ),
      body:  main,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
            if(index < 2){
              page.jumpToPage(index);
            }

          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.ads_click),
            label: '프로모션',
          ),
          NavigationDestination(
            icon: Icon(Icons.pin_drop),
            label: '핀플레이',
          ),
          NavigationDestination(
            icon: Icon(Icons.visibility ),
            label: '테마관리',
          ),

        ],
      ),
    );
  }
}

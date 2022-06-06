import 'package:admin_app/screens/filebase_login_screen.dart';
import 'package:admin_app/screens/promotion_codes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
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
          home: const MyHomePage(
            title: 'SPEC ADMIN'
            ),
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

  late AdminInfo _adminInfoProvider;

  @override
  Widget build(BuildContext context) {
    _adminInfoProvider = Provider.of<AdminInfo>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}-${dotenv.env["MODE"]}'),
        centerTitle: true,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if(!_adminInfoProvider.isLoggedIn)
            Container(

                        width: MediaQuery.of(context).size.width,
                        height: 600,
                        child: LoginSignupScreen(),
                    ),
          if(_adminInfoProvider.isLoggedIn)
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
              title: Column(
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 150,
                      maxWidth: 150,
                    ),
                    child: Image.asset(
                      '/images/271.png',
                    ),
                  ),
                  const Divider(
                    indent: 8.0,
                    endIndent: 8.0,
                  ),
                ],
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
                  title: '프로모션',
                  onTap: () {
                    page.jumpToPage(0);
                  },
                  icon: const Icon(Icons.ads_click),

                ),
                SideMenuItem(
                  priority: 1,
                  title: 'Users',
                  onTap: () {
                    page.jumpToPage(1);
                  },
                  icon: const Icon(Icons.supervisor_account),
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
          if(_adminInfoProvider.isLoggedIn)
            Expanded(
              child: PageView(
                controller: page,
                children: [
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: const Center(
                          child: PromotionCodes()
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: const Center(
                        child: Text(
                          'Users',
                          style: TextStyle(fontSize: 35),
                        ),
                      ),
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


        ],
      ),
    );
  }
}

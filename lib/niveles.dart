import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'pvocales.dart';

class Niveles extends StatelessWidget {
  final String characterImagePath;
  final String username;

  Niveles({required this.characterImagePath, required this.username});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        characterImagePath: characterImagePath,
        username: username,
      ),
      builder:
          (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: double.infinity, name: DESKTOP),
            ],
          ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String characterImagePath;
  final String username;

  HomeScreen({required this.characterImagePath, required this.username});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    // ignore: unused_local_variable
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    // ignore: unused_local_variable
    final double scaleFactor = isMobile ? 0.8 : (isTablet ? 1.0 : 1.2);
    final double padding =
        size.width * (isMobile ? 0.05 : (isTablet ? 0.06 : 0.07));
    final double spacing =
        size.height * (isMobile ? 0.02 : (isTablet ? 0.03 : 0.04));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          ResponsiveValue<double>(
            context,
            defaultValue: size.height * 0.08,
            conditionalValues: const [
              Condition.equals(name: MOBILE, value: 50.0),
              Condition.equals(name: TABLET, value: 60.0),
              Condition.equals(name: DESKTOP, value: 70.0),
            ],
          ).value,
        ),
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 189, 162, 139),
          elevation: 0,
          title: Row(
            children: [
              CircleAvatar(
                radius:
                    ResponsiveValue<double>(
                      context,
                      defaultValue: size.width * 0.05,
                      conditionalValues: const [
                        Condition.equals(name: MOBILE, value: 20.0),
                        Condition.equals(name: TABLET, value: 25.0),
                        Condition.equals(name: DESKTOP, value: 30.0),
                      ],
                    ).value,
                backgroundImage: AssetImage(characterImagePath),
              ),
              SizedBox(
                width:
                    ResponsiveValue<double>(
                      context,
                      defaultValue: size.width * 0.03,
                      conditionalValues: const [
                        Condition.equals(name: MOBILE, value: 8.0),
                        Condition.equals(name: TABLET, value: 10.0),
                        Condition.equals(name: DESKTOP, value: 12.0),
                      ],
                    ).value,
              ),
              Text(
                username,
                style: TextStyle(
                  color: Colors.black,
                  fontSize:
                      ResponsiveValue<double>(
                        context,
                        defaultValue: size.width * 0.045,
                        conditionalValues: const [
                          Condition.equals(name: MOBILE, value: 15.0),
                          Condition.equals(name: TABLET, value: 16.0),
                          Condition.equals(name: DESKTOP, value: 18.0),
                        ],
                      ).value,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              buildGradeCard(
                context,
                "Primer Grado",
                "COMENZAR",
                "assets/grado1.png",
                false,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => VowelsScreen(
                            characterImagePath: characterImagePath,
                            username: username,
                          ),
                    ),
                  );
                },
              ),
              SizedBox(height: spacing),
              buildGradeCard(
                context,
                "Segundo Grado",
                "",
                "assets/grado2.png",
                true,
                null,
              ),
              SizedBox(height: spacing),
              buildGradeCard(
                context,
                "Tercer Grado",
                "",
                "assets/grado3.png",
                true,
                null,
              ),
              SizedBox(height: spacing),
              buildGradeCard(
                context,
                "Cuarto Grado",
                "",
                "assets/grado4.png",
                true,
                null,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: 2,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/boca.jpg',
              height:
                  ResponsiveValue<double>(
                    context,
                    defaultValue: size.height * 0.05,
                    conditionalValues: const [
                      Condition.equals(name: MOBILE, value: 30.0),
                      Condition.equals(name: TABLET, value: 30.0),
                      Condition.equals(name: DESKTOP, value: 35.0),
                    ],
                  ).value,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/micro.jpg',
              height:
                  ResponsiveValue<double>(
                    context,
                    defaultValue: size.height * 0.05,
                    conditionalValues: const [
                      Condition.equals(name: MOBILE, value: 30.0),
                      Condition.equals(name: TABLET, value: 30.0),
                      Condition.equals(name: DESKTOP, value: 35.0),
                    ],
                  ).value,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/home.jpg',
              height:
                  ResponsiveValue<double>(
                    context,
                    defaultValue: size.height * 0.05,
                    conditionalValues: const [
                      Condition.equals(name: MOBILE, value: 30.0),
                      Condition.equals(name: TABLET, value: 30.0),
                      Condition.equals(name: DESKTOP, value: 35.0),
                    ],
                  ).value,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/nota.jpg',
              height:
                  ResponsiveValue<double>(
                    context,
                    defaultValue: size.height * 0.05,
                    conditionalValues: const [
                      Condition.equals(name: MOBILE, value: 30.0),
                      Condition.equals(name: TABLET, value: 30.0),
                      Condition.equals(name: DESKTOP, value: 35.0),
                    ],
                  ).value,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/juego.png',
              height:
                  ResponsiveValue<double>(
                    context,
                    defaultValue: size.height * 0.05,
                    conditionalValues: const [
                      Condition.equals(name: MOBILE, value: 30.0),
                      Condition.equals(name: TABLET, value: 30.0),
                      Condition.equals(name: DESKTOP, value: 35.0),
                    ],
                  ).value,
            ),
            label: '',
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => Niveles(
                      characterImagePath: characterImagePath,
                      username: username,
                    ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildGradeCard(
    BuildContext context,
    String title,
    String actionText,
    String imagePath,
    bool isLocked,
    VoidCallback? onTap,
  ) {
    final size = MediaQuery.of(context).size;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    // ignore: unused_local_variable
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    // ignore: unused_local_variable
    final double scaleFactor = isMobile ? 0.8 : (isTablet ? 1.0 : 1.2);
    final double imageSize =
        size.width * (isMobile ? 0.35 : (isTablet ? 0.4 : 0.45));

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        height:
            ResponsiveValue<double>(
              context,
              defaultValue: size.height * 0.20,
              conditionalValues: const [
                Condition.equals(name: MOBILE, value: 160.0),
                Condition.equals(name: TABLET, value: 180.0),
                Condition.equals(name: DESKTOP, value: 200.0),
              ],
            ).value,
        decoration: BoxDecoration(
          color: Color(0xFFFFC107),
          borderRadius: BorderRadius.circular(
            ResponsiveValue<double>(
              context,
              defaultValue: size.width * 0.03,
              conditionalValues: const [
                Condition.equals(name: MOBILE, value: 10.0),
                Condition.equals(name: TABLET, value: 15.0),
                Condition.equals(name: DESKTOP, value: 20.0),
              ],
            ).value,
          ),
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.volume_up,
                color: Colors.black,
                size:
                    ResponsiveValue<double>(
                      context,
                      defaultValue: size.width * 0.08,
                      conditionalValues: const [
                        Condition.equals(name: MOBILE, value: 25.0),
                        Condition.equals(name: TABLET, value: 30.0),
                        Condition.equals(name: DESKTOP, value: 35.0),
                      ],
                    ).value,
              ),
              onPressed: () {},
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize:
                          ResponsiveValue<double>(
                            context,
                            defaultValue: size.width * 0.09,
                            conditionalValues: const [
                              Condition.equals(name: MOBILE, value: 20.0),
                              Condition.equals(name: TABLET, value: 24.0),
                              Condition.equals(name: DESKTOP, value: 28.0),
                            ],
                          ).value,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height:
                        ResponsiveValue<double>(
                          context,
                          defaultValue: size.height * 0.01,
                          conditionalValues: const [
                            Condition.equals(name: MOBILE, value: 5.0),
                            Condition.equals(name: TABLET, value: 8.0),
                            Condition.equals(name: DESKTOP, value: 10.0),
                          ],
                        ).value,
                  ),
                  Center(
                    child: Container(
                      width:
                          ResponsiveValue<double>(
                            context,
                            defaultValue: size.width * 0.35,
                            conditionalValues: const [
                              Condition.equals(name: MOBILE, value: 120.0),
                              Condition.equals(name: TABLET, value: 150.0),
                              Condition.equals(name: DESKTOP, value: 180.0),
                            ],
                          ).value,
                      height:
                          ResponsiveValue<double>(
                            context,
                            defaultValue: size.height * 0.06,
                            conditionalValues: const [
                              Condition.equals(name: MOBILE, value: 40.0),
                              Condition.equals(name: TABLET, value: 50.0),
                              Condition.equals(name: DESKTOP, value: 60.0),
                            ],
                          ).value,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          ResponsiveValue<double>(
                            context,
                            defaultValue: size.width * 0.5,
                            conditionalValues: const [
                              Condition.equals(name: MOBILE, value: 20.0),
                              Condition.equals(name: TABLET, value: 25.0),
                              Condition.equals(name: DESKTOP, value: 30.0),
                            ],
                          ).value,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child:
                            isLocked
                                ? Image.asset(
                                  'assets/candado.png',
                                  height:
                                      ResponsiveValue<double>(
                                        context,
                                        defaultValue: size.height * 0.06,
                                        conditionalValues: const [
                                          Condition.equals(
                                            name: MOBILE,
                                            value: 30.0,
                                          ),
                                          Condition.equals(
                                            name: TABLET,
                                            value: 35.0,
                                          ),
                                          Condition.equals(
                                            name: DESKTOP,
                                            value: 40.0,
                                          ),
                                        ],
                                      ).value,
                                  fit: BoxFit.contain,
                                )
                                : Text(
                                  actionText,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize:
                                        ResponsiveValue<double>(
                                          context,
                                          defaultValue: size.width * 0.04,
                                          conditionalValues: const [
                                            Condition.equals(
                                              name: MOBILE,
                                              value: 14.0,
                                            ),
                                            Condition.equals(
                                              name: TABLET,
                                              value: 16.0,
                                            ),
                                            Condition.equals(
                                              name: DESKTOP,
                                              value: 18.0,
                                            ),
                                          ],
                                        ).value,
                                  ),
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(
                ResponsiveValue<double>(
                  context,
                  defaultValue: size.width * 0.02,
                  conditionalValues: const [
                    Condition.equals(name: MOBILE, value: 5.0),
                    Condition.equals(name: TABLET, value: 8.0),
                    Condition.equals(name: DESKTOP, value: 10.0),
                  ],
                ).value,
              ),
              child: Image.asset(
                imagePath,
                height: imageSize,
                width: imageSize,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

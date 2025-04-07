import 'package:flutter/material.dart';

void main() {
  runApp(Niveles());
}

class Niveles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(223, 235, 197, 117),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('assets/ajaguar.jpg', width: 30, height: 30),
            const SizedBox(width: 8),
            const Text(
              '0II',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGradeButton(
              context,
              'PRIMER GRADO',
              'COMENZAR',
              'assets/grado1.jpg',
              isLocked: false,
            ),
            const SizedBox(height: 9),
            _buildGradeButton(
              context,
              'SEGUNDO GRADO',
              '',
              'assets/grado2.jpg',
              isLocked: true,
            ),
            const SizedBox(height: 8),
            _buildGradeButton(
              context,
              'TERCER GRADO',
              '',
              'assets/grado3.jpg',
              isLocked: false,
            ),
            const SizedBox(height: 8),
            _buildGradeButton(
              context,
              'CUARTO GRADO',
              '',
              'assets/grado4.jpg',
              isLocked: true,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/ajaguar.jpg'), size: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/ajaguar.jpg'), size: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/ajaguar.jpg'), size: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/ajaguar.jpg'), size: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/ajaguar.jpg'), size: 30),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildGradeButton(
    BuildContext context,
    String mainText,
    String subText,
    String tigerImage, {
    required bool isLocked,
  }) {
    return Container(
      width: double.infinity,
      height: 80,
      child: Stack(
        children: [
          Material(
            color: const Color(0xFFFFD700),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: isLocked ? null : () {},
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mainText,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        if (subText.isNotEmpty)
                          Text(
                            subText,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                      ],
                    ),
                    Image.asset(tigerImage, width: 50, height: 50),
                  ],
                ),
              ),
            ),
          ),
          if (isLocked)
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: Image.asset('assets/ajaguar.jpg', width: 24, height: 24),
              ),
            ),
        ],
      ),
    );
  }
}

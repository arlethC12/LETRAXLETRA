import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: SelectionScreen(),
    );
  }
}

class SelectionScreen extends StatefulWidget {
  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  final List<String> emojis = [
    '🧸', // Teddy bear
    '😊', // Smiling face
    '👸', // Princess
    '🦄', // Unicorn (selectable)
    '🍇', // Grapes (Uva, selectable)
    '✨', // Sparkles
    '1️⃣', // Number 1 (Número 1, selectable)
    '🙃', // Upside-down face (selectable)
    '💅', // Nails (Uñas, selectable)
  ];

  List<bool> selected = List.filled(9, false);
  final int totalSelectable = 5; // 🦄, 🙃, 🍇, 1️⃣, 💅

  bool isSelectable(String emoji) {
    return emoji == '🦄' ||
        emoji == '🙃' ||
        emoji == '🍇' ||
        emoji == '1️⃣' ||
        emoji == '💅';
  }

  int getSelectedCount() {
    return selected.where((s) => s).length;
  }

  bool allSelected() {
    return getSelectedCount() == totalSelectable;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with X and progress
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      // Handle close action
                    },
                  ),
                  Expanded(
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: getSelectedCount() / totalSelectable,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Selecciona las imágenes que empiecen con la letra U',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            // Large orange "U"
            Text(
              'U',
              style: TextStyle(
                fontSize: 100,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // Grid of emojis
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: emojis.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (isSelectable(emojis[index])) {
                        setState(() {
                          selected[index] = !selected[index];
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            selected[index]
                                ? Colors.green.withOpacity(0.3)
                                : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color:
                              isSelectable(emojis[index])
                                  ? Colors.black
                                  : Colors.grey,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          emojis[index],
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Right arrow button when all are selected
            if (allSelected())
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Button color
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(16),
                  ),
                  onPressed: () {
                    // Handle next action
                  },
                  child: Icon(
                    Icons.arrow_forward, // Right arrow
                    color: Colors.white, // Arrow color
                    size: 40,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

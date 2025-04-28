import 'package:flutter/material.dart';
import 'pintaE.dart'; // Asegúrate que esté en la misma carpeta o ajusta la ruta si es necesario

void main() {
  runApp(const RellenaEPantalla());
}

class RellenaEPantalla extends StatelessWidget {
  const RellenaEPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String?> circleIcons = List.filled(11, null);

  bool get isEFilled => !circleIcons.contains(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.close, color: Colors.brown, size: 30),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 0.5,
                        backgroundColor: Colors.grey[300],
                        color: Colors.orange,
                        minHeight: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              'Selecciona la imagen que empieza con la\nletra y ponlos en los círculos vacíos',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            LetterEWithCircles(
              circleIcons: circleIcons,
              onAccept: (index, emoji) {
                setState(() {
                  circleIcons[index] = emoji;
                });
              },
            ),
            BottomIcons(
              onDrag: (emoji) {
                setState(() {
                  for (int i = 0; i < circleIcons.length; i++) {
                    if (circleIcons[i] == emoji) {
                      circleIcons[i] = null;
                    }
                  }
                });
              },
            ),
            if (isEFilled)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Aquí navegamos a la pantalla de pintaE
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PintaEPantalla(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            if (!isEFilled) const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class LetterEWithCircles extends StatelessWidget {
  final List<String?> circleIcons;
  final Function(int, String) onAccept;

  const LetterEWithCircles({
    super.key,
    required this.circleIcons,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 260,
      child: Stack(
        children: [
          _buildCircle(10, 10, 0),
          _buildCircle(10, 50, 1),
          _buildCircle(10, 90, 2),
          _buildCircle(10, 130, 3),
          _buildCircle(10, 170, 4),
          _buildCircle(50, 10, 5),
          _buildCircle(90, 10, 6),
          _buildCircle(50, 90, 7),
          _buildCircle(90, 90, 8),
          _buildCircle(50, 170, 9),
          _buildCircle(90, 170, 10),
        ],
      ),
    );
  }

  Widget _buildCircle(double left, double top, int index) {
    return Positioned(
      left: left,
      top: top,
      child: DragTarget<String>(
        onWillAccept: (data) {
          return [
            '⭐',
            '🌽',
            '🪜',
            '🐘',
            '🪞',
            '🧹',
            '🏫',
            '🧽',
            '🥤',
            '🥗',
            '🩺',
            '🦂',
          ].contains(data);
        },
        onAccept: (data) => onAccept(index, data),
        builder: (context, candidateData, rejectedData) {
          return Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
              border: Border.all(color: Colors.black, width: 1),
            ),
            child:
                circleIcons[index] != null
                    ? Center(
                      child: Text(
                        circleIcons[index]!,
                        style: const TextStyle(fontSize: 24),
                      ),
                    )
                    : null,
          );
        },
      ),
    );
  }
}

class BottomIcons extends StatelessWidget {
  final Function(String) onDrag;

  const BottomIcons({super.key, required this.onDrag});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          _buildDraggableIcon('⭐', 'Estrella'),
          _buildDraggableIcon('🌽', 'Elote'),
          _buildDraggableIcon('🥚', 'Huevo'),
          _buildDraggableIcon('⚡', 'Rayo'),
          _buildDraggableIcon('🧩', 'Puzzle'),
          _buildDraggableIcon('👶', 'Bebé'),
          _buildDraggableIcon('🖌️', 'Pincel'),
          _buildDraggableIcon('❤️', 'Corazón'),
          _buildDraggableIcon('🪜', 'Escalera'),
          _buildDraggableIcon('🐘', 'Elefante'),
          _buildDraggableIcon('🪞', 'Espejo'),
          _buildDraggableIcon('🧹', 'Escoba'),
          _buildDraggableIcon('🏫', 'Escuela'),
          _buildDraggableIcon('🧽', 'Esponja'),
          _buildDraggableIcon('🥤', 'Envase'),
          _buildDraggableIcon('🥗', 'Ensalada'),
          _buildDraggableIcon('🩺', 'Estetoscopio'),
          _buildDraggableIcon('🦂', 'Escorpión'),
        ],
      ),
    );
  }

  Widget _buildDraggableIcon(String emoji, String label) {
    return Draggable<String>(
      data: emoji,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),
        ),
      ),
      childWhenDragging: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
      ),
      onDragStarted: () => onDrag(emoji),
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24))),
      ),
    );
  }
}

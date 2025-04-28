import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: PuzzleScreen());
  }
}

class PuzzleScreen extends StatefulWidget {
  @override
  _PuzzleScreenState createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  List<Map<String, dynamic>?> puzzleSlots = [null, null, null, null];
  bool isPuzzleComplete = false;

  void checkPuzzleCompletion() {
    if (puzzleSlots[0]?['piece'] == 'bear' &&
        puzzleSlots[1]?['piece'] == 'o' &&
        puzzleSlots[2]?['piece'] == '8' &&
        puzzleSlots[3]?['piece'] == 'ear') {
      setState(() {
        isPuzzleComplete = true;
      });
    }
  }

  Color getPieceColor(String piece) {
    switch (piece) {
      case 'bear':
        return Color(0xFFD2B48C); // Marrón claro
      case 'o':
        return Color(0xFFADD8E6); // Azul claro
      case '8':
        return Color(0xFF90EE90); // Verde claro
      case 'ear':
        return Color(0xFFFFB6C1); // Rosa claro
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () {},
                  ),
                  SizedBox(
                    width: 240, // Aumentado de 200 a 250 para alargar
                    height: 10, // Altura explícita para hacerla más gruesa
                    child: LinearProgressIndicator(
                      value: 0.5,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(width: 40),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Arma el siguiente rompecabezas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              width: 200,
              height: 200,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return DragTarget<Map<String, dynamic>>(
                    onAccept: (data) {
                      setState(() {
                        puzzleSlots[index] = data;
                      });
                      checkPuzzleCompletion();
                    },
                    builder: (context, candidateData, rejectedData) {
                      return CustomPaint(
                        painter: PuzzlePiecePainter(
                          index,
                          puzzleSlots[index] != null
                              ? getPieceColor(puzzleSlots[index]!['piece'])
                              : Colors.white,
                        ),
                        child: Container(
                          width: 100,
                          height: 100,
                          child: Center(
                            child:
                                puzzleSlots[index] == null
                                    ? SizedBox.shrink()
                                    : _getPuzzlePieceWidget(
                                      puzzleSlots[index]!['piece'],
                                    ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Draggable<Map<String, dynamic>>(
                      data: {'piece': 'bear', 'position': 0},
                      child: _getPuzzlePieceWithPainter(
                        'bear',
                        0,
                        getPieceColor('bear'),
                      ),
                      feedback: _getPuzzlePieceWithPainter(
                        'bear',
                        0,
                        getPieceColor('bear'),
                      ),
                    ),
                    Text('oso', style: TextStyle(fontSize: 14)),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    Draggable<Map<String, dynamic>>(
                      data: {'piece': 'o', 'position': 1},
                      child: _getPuzzlePieceWithPainter(
                        'o',
                        1,
                        getPieceColor('o'),
                      ),
                      feedback: _getPuzzlePieceWithPainter(
                        'o',
                        1,
                        getPieceColor('o'),
                      ),
                    ),
                    Text('letra O', style: TextStyle(fontSize: 14)),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    Draggable<Map<String, dynamic>>(
                      data: {'piece': '8', 'position': 2},
                      child: _getPuzzlePieceWithPainter(
                        '8',
                        2,
                        getPieceColor('8'),
                      ),
                      feedback: _getPuzzlePieceWithPainter(
                        '8',
                        2,
                        getPieceColor('8'),
                      ),
                    ),
                    Text('ocho', style: TextStyle(fontSize: 14)),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    Draggable<Map<String, dynamic>>(
                      data: {'piece': 'ear', 'position': 3},
                      child: _getPuzzlePieceWithPainter(
                        'ear',
                        3,
                        getPieceColor('ear'),
                      ),
                      feedback: _getPuzzlePieceWithPainter(
                        'ear',
                        3,
                        getPieceColor('ear'),
                      ),
                    ),
                    Text('oreja', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
            Spacer(),
            if (isPuzzleComplete)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _getPuzzlePieceWithPainter(String piece, int position, Color color) {
    return CustomPaint(
      painter: PuzzlePiecePainter(position, color),
      child: Container(
        width: 60,
        height: 60,
        child: Center(child: _getPuzzlePieceWidget(piece)),
      ),
    );
  }

  Widget _getPuzzlePieceWidget(String piece) {
    switch (piece) {
      case 'bear':
        return Text('🐻', style: TextStyle(fontSize: 30));
      case 'o':
        return Text(
          'O',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        );
      case '8':
        return Text(
          '8',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        );
      case 'ear':
        return Text('👂', style: TextStyle(fontSize: 30));
      default:
        return SizedBox.shrink();
    }
  }
}

class PuzzlePiecePainter extends CustomPainter {
  final int position;
  final Color fillColor;

  PuzzlePiecePainter(this.position, this.fillColor);

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint =
        Paint()
          ..color = fillColor
          ..style = PaintingStyle.fill;

    final borderPaint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    final path = Path();
    double tabSize = 15;

    switch (position) {
      case 0: // Top-left (bear)
        path.moveTo(0, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, size.height / 2 - tabSize);
        path.quadraticBezierTo(
          size.width + tabSize,
          size.height / 2,
          size.width,
          size.height / 2 + tabSize,
        );
        path.lineTo(size.width, size.height);
        path.lineTo(size.width / 2 + tabSize, size.height);
        path.quadraticBezierTo(
          size.width / 2,
          size.height + tabSize,
          size.width / 2 - tabSize,
          size.height,
        );
        path.lineTo(0, size.height);
        path.lineTo(0, 0);
        break;

      case 1: // Top-right (letter O)
        path.moveTo(0, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(size.width / 2 + tabSize, size.height);
        path.quadraticBezierTo(
          size.width / 2,
          size.height + tabSize,
          size.width / 2 - tabSize,
          size.height,
        );
        path.lineTo(0, size.height);
        path.lineTo(0, size.height / 2 + tabSize);
        path.quadraticBezierTo(
          -tabSize,
          size.height / 2,
          0,
          size.height / 2 - tabSize,
        );
        path.lineTo(0, 0);
        break;

      case 2: // Bottom-left (number 8)
        path.moveTo(0, 0);
        path.lineTo(size.width / 2 - tabSize, 0);
        path.quadraticBezierTo(
          size.width / 2,
          -tabSize,
          size.width / 2 + tabSize,
          0,
        );
        path.lineTo(size.width, 0);
        path.lineTo(size.width, size.height / 2 - tabSize);
        path.quadraticBezierTo(
          size.width + tabSize,
          size.height / 2,
          size.width,
          size.height / 2 + tabSize,
        );
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height);
        path.lineTo(0, 0);
        break;

      case 3: // Bottom-right (ear)
        path.moveTo(size.width / 2 - tabSize, 0);
        path.quadraticBezierTo(
          size.width / 2,
          -tabSize,
          size.width / 2 + tabSize,
          0,
        );
        path.lineTo(size.width, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height);
        path.lineTo(0, size.height / 2 + tabSize);
        path.quadraticBezierTo(
          -tabSize,
          size.height / 2,
          0,
          size.height / 2 - tabSize,
        );
        path.lineTo(0, 0);
        break;
    }

    path.close();
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

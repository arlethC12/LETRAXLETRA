import 'package:flutter/material.dart';
import 'rellenaE.dart'; // <<--- Aquí importamos la otra pantalla

void main() {
  runApp(DragLetterScreen());
}

class DragLetterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VocabularyScreen(),
    );
  }
}

class VocabularyScreen extends StatefulWidget {
  @override
  _VocabularyScreenState createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  List<bool> filledBoxes = [false, false, false, false];

  void updateFilledStatus(int index) {
    setState(() {
      filledBoxes[index] = true;
    });
  }

  bool get allBoxesFilled => filledBoxes.every((filled) => filled);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.close, color: Colors.black),
            SizedBox(width: 8.0),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 15,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Arrastra las vocales al pictograma correspondiente.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                VocabularyItem(
                  imagePath: 'assets/elefante.jpg',
                  label: 'e',
                  index: 0,
                  onFilled: updateFilledStatus,
                ),
                VocabularyItem(
                  imagePath: 'assets/elote.jpg',
                  label: 'e',
                  index: 1,
                  onFilled: updateFilledStatus,
                ),
                VocabularyItem(
                  imagePath: 'assets/escalera.jpg',
                  label: 'e',
                  index: 2,
                  onFilled: updateFilledStatus,
                ),
                VocabularyItem(
                  imagePath: 'assets/estrella.jpg',
                  label: 'e',
                  index: 3,
                  onFilled: updateFilledStatus,
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    VocalButton(vocal: 'a', color: Colors.orange),
                    VocalButton(vocal: 'e', color: Colors.blue),
                    VocalButton(vocal: 'i', color: Colors.green),
                    VocalButton(vocal: 'o', color: Colors.purple),
                    VocalButton(vocal: 'u', color: Colors.red),
                  ],
                ),
                SizedBox(height: 16.0),
                if (allBoxesFilled)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RellenaEPantalla(),
                        ),
                      );
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        size: 40,
                        color: Colors.white,
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

class VocabularyItem extends StatefulWidget {
  final String imagePath;
  final String label;
  final int index;
  final Function(int) onFilled;

  VocabularyItem({
    required this.imagePath,
    required this.label,
    required this.index,
    required this.onFilled,
  });

  @override
  _VocabularyItemState createState() => _VocabularyItemState();
}

class _VocabularyItemState extends State<VocabularyItem> {
  String? droppedVocal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(widget.imagePath, width: 80, height: 80),
          SizedBox(width: 32.0),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DragTarget<String>(
              onWillAccept: (data) {
                return data == 'e' && widget.label == 'e';
              },
              onAccept: (data) {
                if (data == widget.label) {
                  setState(() {
                    droppedVocal = data;
                  });
                  widget.onFilled(widget.index);
                  print('¡Correcto! La vocal $data es correcta.');
                }
              },
              builder: (context, candidateData, rejectedData) {
                return Center(
                  child: Text(
                    droppedVocal ?? '',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: droppedVocal == 'e' ? Colors.blue : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VocalButton extends StatelessWidget {
  final String vocal;
  final Color color;

  VocalButton({required this.vocal, required this.color});

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: vocal,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            vocal,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
      feedback: Material(
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(
              vocal,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
      ),
      childWhenDragging: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}

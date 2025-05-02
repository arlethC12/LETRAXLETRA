import 'package:flutter/material.dart';
import 'package:letra_x_letra/vocalI/rompecabesa.dart'; // Importa rompecabesa.dart (contiene RompecabesaScreen)
import 'package:letra_x_letra/vocalI/BurbujaI.dart'; // Importa BurbujaI.dart (contiene BurbujaIScreen)

void main() {
  runApp(PalabraScreen());
}

class PalabraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WordCompletionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WordCompletionScreen extends StatefulWidget {
  @override
  _WordCompletionScreenState createState() => _WordCompletionScreenState();
}

class _WordCompletionScreenState extends State<WordCompletionScreen> {
  String firstLetter = '';
  String secondLetter = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        // Navegar a la pantalla de rompecabesa.dart
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RompecabesaScreen(),
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: LinearProgressIndicator(
                        value:
                            (firstLetter.isNotEmpty && secondLetter.isNotEmpty)
                                ? 1.0
                                : 0.5,
                        minHeight: 10,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.orange,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Completa la palabra seleccionando las letras de los recuadros',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Transform.translate(
                  offset: Offset(0, 40),
                  child: Text('⛪', style: TextStyle(fontSize: 100)),
                ),
                SizedBox(height: 20),
                Transform.translate(
                  offset: Offset(0, 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLetterBox(firstLetter),
                      Text(
                        'gles',
                        style: TextStyle(
                          fontSize: 40,
                          color: const Color.fromARGB(157, 255, 153, 0),
                        ),
                      ),
                      _buildLetterBox(secondLetter),
                      Text(
                        'a',
                        style: TextStyle(fontSize: 40, color: Colors.purple),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 65,
                ), // Increased from 20 to 40 to lower the letter boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSelectableLetter('I', true),
                    SizedBox(width: 20),
                    _buildSelectableLetter('i', false),
                  ],
                ),
                SizedBox(height: 80),
                if (firstLetter == 'I' && secondLetter == 'i')
                  ElevatedButton(
                    onPressed: () {
                      // Navegar a la pantalla de BurbujaI.dart
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BurbujaIScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 233, 144, 42),
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLetterBox(String letter) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Center(child: Text(letter, style: TextStyle(fontSize: 40))),
    );
  }

  Widget _buildSelectableLetter(String letter, bool isFirstLetter) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isFirstLetter) {
            firstLetter = letter;
          } else {
            secondLetter = letter;
          }
        });
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color:
              ((isFirstLetter && firstLetter == letter) ||
                      (!isFirstLetter && secondLetter == letter))
                  ? Colors.grey[600] // Darker grey when selected
                  : const Color.fromARGB(
                    255,
                    241,
                    178,
                    178,
                  ), // Default grey color
        ),
        child: Center(child: Text(letter, style: TextStyle(fontSize: 40))),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'escriba.dart';

class VocalAPage extends StatelessWidget {
  const VocalAPage({
    super.key,
    required String characterImagePath,
    required String username,
  });

  @override
  Widget build(BuildContext context) {
    return const WriteScreen();
  }
}

class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isVideoCompleted = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _exerciseId; // Variable para almacenar el ID del ejercicio

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(
      'assets/videos/videoletraA.mp4',
    );
    _initializeVideoPlayerFuture = _videoController.initialize();
    _videoController.setLooping(false);
    _videoController.addListener(_videoListener);

    _fetchExerciseId(); // Llamar a la función para obtener el ID del ejercicio
  }

  // Función para obtener el ID del ejercicio desde el backend
  Future<void> _fetchExerciseId() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.69:3000/ejercicios/1'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Estado de la respuesta: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _exerciseId = data['cve_ejercicio']; // Asignar el ID del ejercicio
        });
        print('✅ ID del ejercicio obtenido: $_exerciseId');
      } else if (response.statusCode == 404) {
        print(
          '❌ Ejercicio no encontrado (404). Verifica que exista en la base de datos.',
        );
      } else {
        print('❌ Error al obtener el ID del ejercicio: ${response.body}');
      }
    } catch (error) {
      print('❌ Error de conexión al obtener el ID del ejercicio: $error');
    }
  }

  void _videoListener() async {
    if (_videoController.value.position >= _videoController.value.duration &&
        !_isVideoCompleted) {
      setState(() {
        _isVideoCompleted = true;
      });

      // Llamada al backend para guardar progreso
      try {
        final response = await http.post(
          Uri.parse('http://192.168.1.69:3000/progresos'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'cve_usuario': '1', // Reemplaza con el ID del usuario real
            'cve_leccion': _exerciseId, // Usar el ID del ejercicio obtenido
            'completado': true,
            'imagen_url': '', // Opcional
            'audio_url': '', // Opcional
            'metadata': {
              'pantalla': 'VocalAPage',
              'timestamp': DateTime.now().toIso8601String(),
            },
          }),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('✅ Progreso guardado o actualizado');
        } else {
          print('❌ Error al guardar el progreso: ${response.body}');
        }
      } catch (error) {
        print('❌ Error de conexión al guardar el progreso: $error');
      }
    }
  }

  @override
  void dispose() {
    _videoController.removeListener(_videoListener);
    _videoController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.black87, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: 0.1,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.orange,
                  ),
                  minHeight: 8,
                ),
              ),
            ),
          ],
        ),
        leadingWidth: 348,
        actions: const [SizedBox(width: 16)],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 15),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.volume_up,
                      color: Colors.black87,
                      size: 40,
                    ),
                    onPressed: () async {
                      await _audioPlayer.play(
                        AssetSource('audios/VocalA/Como se escribe la A.m4a'),
                      );
                    },
                  ),
                  const Text(
                    'Aprende como se escribe la letra A',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_exerciseId !=
                      null) // Mostrar el ID del ejercicio si está disponible
                    Text(
                      'ID del ejercicio: $_exerciseId',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 75),
              FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Error al cargar el video',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    return AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_videoController.value.isPlaying) {
                                  _videoController.pause();
                                } else {
                                  _videoController.play();
                                }
                              });
                            },
                            child: VideoPlayer(_videoController),
                          ),
                          if (!_videoController.value.isPlaying)
                            IconButton(
                              icon: Icon(
                                Icons.play_circle_filled,
                                color: Colors.white.withOpacity(0.8),
                                size: 70,
                              ),
                              onPressed: () {
                                setState(() {
                                  _videoController.play();
                                });
                              },
                            ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
      floatingActionButton:
          _isVideoCompleted
              ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Icon(Icons.arrow_forward, size: 24),
                ),
              )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart'; // Importa el paquete de audioplayers
import 'Eescribe.dart'; // Asegúrate de que esta importación sea correcta

class VocalEPage extends StatelessWidget {
  const VocalEPage({
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
  final AudioPlayer _audioPlayer =
      AudioPlayer(); // Instancia del reproductor de audio

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(
      'assets/videos/videoletraE.mp4',
    );
    _initializeVideoPlayerFuture = _videoController.initialize();
    _videoController.setLooping(false); // Disable looping to detect video end
    _videoController.addListener(_videoListener);
  }

  void _videoListener() {
    if (_videoController.value.position >= _videoController.value.duration &&
        !_isVideoCompleted) {
      setState(() {
        _isVideoCompleted = true;
      });
    }
  }

  void _playAudio() async {
    try {
      await _audioPlayer.play(
        AssetSource('audios/VocalE/Da play en el video .mp3'),
      ); // Ruta del archivo de audio
    } catch (e) {
      print('Error al reproducir el audio: $e');
    }
  }

  @override
  void dispose() {
    _videoController.removeListener(_videoListener);
    _videoController.dispose();
    _audioPlayer.dispose(); // Libera los recursos del reproductor de audio
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
                    onPressed:
                        _playAudio, // Llama a la función para reproducir el audio
                  ),
                  const Text(
                    'Aprende como se escribe la letra E',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
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
                                // ignore: deprecated_member_use
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
                    // Navega a EscribeEPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EscribeEPage(),
                      ),
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

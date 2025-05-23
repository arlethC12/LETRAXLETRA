import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart'; // Importar audioplayers
import 'Oescribe.dart';

class VocalOPage extends StatelessWidget {
  const VocalOPage({
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
  final AudioPlayer _audioPlayer = AudioPlayer(); // Instancia de AudioPlayer

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(
      'assets/videos/videoletraO.mp4',
    );
    _initializeVideoPlayerFuture = _videoController.initialize();
    _videoController.setLooping(false);
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

  @override
  void dispose() {
    _videoController.removeListener(_videoListener);
    _videoController.dispose();
    _audioPlayer.dispose(); // Liberar recursos del audio
    super.dispose();
  }

  // Función para reproducir el audio
  Future<void> _playAudio() async {
    try {
      await _audioPlayer.play(
        AssetSource('audios/VocalO/aprende como se escr.m4a'),
      );
    } catch (e) {
      print('Error al reproducir el audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87, size: 30),
          onPressed: () {
            print('Close button pressed');
            Navigator.pop(context);
          },
        ),
        title: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: 0.1,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
            minHeight: 8,
          ),
        ),
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
                    onPressed: _playAudio, // Llamar a la función de audio
                  ),
                  const Text(
                    'Aprende como se escribe la letra O',
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
                      MaterialPageRoute(
                        builder: (context) => const OescribePage(),
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

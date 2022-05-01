import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hive/hive.dart';
import 'ListViewWidget.dart';
import 'main.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({Key? key}) : super(key: key);

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> with WidgetsBindingObserver {
  //initialize variables here
  late Duration duration;
  late Duration position;
  bool isPlaying = false;
  IconData btnIcon = Icons.play_arrow;
  late BaTum instance;
  late AudioPlayer audioPlayer;
  Box box = Hive.box<String>('myBox');
  String currentSong ="";
  String currentCover ="";
  String currentTitle = "";
  String currentSinger="";
  String url ="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    instance = getIt<BaTum>();
    audioPlayer = instance.audio;
    duration = new Duration();
    position = new Duration();

    if(box.get('playedOnce') == "false") {
      setState(() {
        currentCover="https://i.pinimg.com/originals/25/0c/e1/250ce1e27b85c49afd1c745d8cb02ffa.png";
        currentTitle="Choose a song to play";
      });
    }
    else if(box.get('playedOnce') == "true"){
      currentCover=box.get('currentCover');
      currentSinger=box.get('currentSinger');
      currentTitle=box.get('currentTitle');
      url=box.get('url');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    super.didChangeAppLifecycleState(state);
    if(state==AppLifecycleState.inactive || state==AppLifecycleState.paused){
      audioPlayer.pause();
      setState(() {
        btnIcon= Icons.play_arrow;
      });
    }
    else if(state==AppLifecycleState.resumed) {
      if (isPlaying == true) {
        audioPlayer.resume();
        setState(() {
          btnIcon = Icons.pause;
        });
      }
    }
    else if(state==AppLifecycleState.detached) {
      audioPlayer.stop();
      audioPlayer.release();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  void playMusic(String url) async {
    if (isPlaying && currentSong != url) {
      audioPlayer.pause();
      int result = await audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          currentSong = url;
        });
      }
    } else if (!isPlaying) {
      int result = await audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          isPlaying = true;
          btnIcon = Icons.pause;
        });
      }
    }
  // Setting the state of duration(current/end points)
  audioPlayer.onDurationChanged.listen((event) {
  setState(() {
  duration = event;
  });
  });
  audioPlayer.onAudioPositionChanged.listen((event) {
  setState(() {
  position = event;
  });
  });
}

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    audioPlayer.seek(newDuration);
  }

  List music = [
{
"title": "_Bei Imepanda_",
"singer": "BREEDER LW X SSARU",
"url":
"https://davee.co.ke/android-repo/bei_imepanda.mp3",
"coverUrl":
"https://davee.co.ke/android-repo/bei.jpg"
},
{
"title": "_DENRI_ ",
"singer": "BREEDER LW ft G-Chess _Alma _ Collonizzo",
"url":
"https://davee.co.ke/android-repo/denri.mp3",
"coverUrl":
"https://davee.co.ke/android-repo/denri.jpg"
},
{
"title": "NI KUBAYA_",
"singer": "BREEDER LW X KHALIGRAPH JONES",
"url":
"https://davee.co.ke/android-repo/ni_kubaya.mp3",
"coverUrl":
"https://davee.co.ke/android-repo/kubaya.jpg"
}    ,
    {
      "title": "__DO RE MI__",
      "singer": "BREEDER LW - feat BENZEMA [Ochungulo Family] ",
      "url":
      "https://davee.co.ke/android-repo/doremi.mp3",
      "coverUrl":
      "https://davee.co.ke/android-repo/doremi.jpg"
    }
  ];
  // These is the songs and their details which we will be using in our app
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.library_music),
        shadowColor: Colors.grey,
        title: const Text('STREAM MUSIC (5* rated)', style: TextStyle(fontWeight: FontWeight.w900 ),),
        centerTitle: true,
        elevation: 10,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => listViewItems(
                  title: music[index]['title'],
                  singer: music[index]['singer'],
                  cover: music[index]['coverUrl'],
                  onTap: () async {
                    setState(() {
                      currentTitle = music[index]['title'];
                      currentSinger = music[index]['singer'];
                      currentCover = music[index]['coverUrl'];
                      url = music[index]['url'];
                    });
                     playMusic(url);
                    // we need to create the playMusic Function
                    // TODO:Playmusic function
                    box.put('playedOnce', 'true');
                    box.put('currentCover', currentCover);
                    box.put('currentSinger', currentSinger);
                    box.put('currentTitle', currentTitle);
                    box.put('url', url);
                  }
              ),
              itemCount: music.length,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(
                    0x55212121,
                  ),
                  blurRadius: 8,
                )
              ],
            ),
            child: Column(
              children: [
                Slider.adaptive(
                  value: position.inSeconds.toDouble(),
                  min: 0,
                  max: duration.inSeconds.toDouble(),
                  onChanged: (value) {
                    seekToSecond(value.toInt());
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        position.inSeconds.toDouble().toString(),
                      ),
                      Text(
                        duration.inSeconds.toDouble().toString(),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 75,
                      width: 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                            currentCover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(currentTitle,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              )),
                          SizedBox(
                            height: 14,
                          ),
                          Text(currentSinger,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              )),
                        ],
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          btnIcon,
                          size: 39,
                        ),
                        onPressed: () {
                          if (box.get('playedOnce') == "true" && isPlaying == false) {
                            playMusic(url);
                          }
                          else if (isPlaying) {
                            audioPlayer.pause();
                            setState(() {
                              btnIcon = Icons.play_arrow;
                              isPlaying = false;
                            });
                          }
                          else{
                            audioPlayer.resume();
                            setState(() {
                              btnIcon = Icons.pause;
                              isPlaying = true;
                            });
                          }
                        }
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

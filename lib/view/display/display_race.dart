// ignore_for_file: avoid_web_libraries_in_flutter

import "package:universal_html/html.dart" as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:queue_control_flutter/utilities.dart' as util;
import 'package:flutter/foundation.dart' show kIsWeb;

class DisplayRace extends StatefulWidget {
  const DisplayRace({Key key}) : super(key: key);

  @override
  State<DisplayRace> createState() => _DisplayRaceState();
}

class _DisplayRaceState extends State<DisplayRace> {
  bool fullScreen = false;
  TextToSpeech tts = TextToSpeech();
  List<DocumentSnapshot> _listDocument = [];

  initLanguages() async {
    List<String> code = await tts.getLanguages();
    int id = code.indexWhere((x) => x.contains('id') || x.contains('ind') || x.contains('indonesia'));
    if (id < 0) {
      String defLang = await tts.getDefaultLanguage();
      tts.setLanguage(defLang);
    } else {
      tts.setLanguage(code[id]);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      initLanguages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          util.backgroundWidget(context),
          (kIsWeb)
              ? Positioned(
                  child: IconButton(
                      onPressed: () {
                        (fullScreen)
                            ? html.document.exitFullscreen()
                            : html.document.documentElement.requestFullscreen();
                        setState(() {
                          fullScreen = !fullScreen;
                        });
                      },
                      icon: Icon((fullScreen) ? Icons.fullscreen_exit : Icons.fullscreen)),
                  left: 0,
                  top: 0,
                )
              : const SizedBox(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  logoWidget(context),
                  supportWidget(context),
                ],
              ),
              bodyWidget(),
            ],
          ),
          streamBodyWidget(),
        ],
      ),
    );
  }

  logoWidget(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 2,
      child: Image.asset('assets/tdp-logo.png'),
    );
  }

  supportWidget(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.height / 3,
      child: Image.asset('assets/tdp-support.png'),
    );
  }

  bodyWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('race').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          if (snapshot.data.docChanges[0].type == DocumentChangeType.added) {
            _listDocument = snapshot.data.docs;
          }
          if (snapshot.data.docChanges[0].type == DocumentChangeType.modified) {
            var xxx = _listDocument.indexWhere((x) => x.id == snapshot.data.docChanges[0].doc.id);

            if (_listDocument[xxx].get('current') != snapshot.data.docChanges[0].doc.get('current')) {
              String id = snapshot.data.docs[xxx].id.toString();
              String current = snapshot.data.docs[xxx].get('current').toString();
              if (id == 'men open amateur') {
                tts.speak('antrian nomor $current diharapkan ke meja men open amatir');
              } else {
                tts.speak('antrian nomor $current diharapkan ke meja $id');
              }
            }
            _listDocument.clear();
            _listDocument = snapshot.data.docs;
          }
          double cardWidth = MediaQuery.of(context).size.width / 4.5;
          double cardHeight = MediaQuery.of(context).size.height / 4.5;
          return GridView.count(
            childAspectRatio: cardWidth / cardHeight,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            shrinkWrap: true,
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return Container(
                height: 50,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: Text(
                        document.id.toString().toUpperCase(),
                        style: const TextStyle(fontSize: 36, color: Colors.blue, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    FittedBox(
                      child: Text(
                        document['current'].toString().toUpperCase(),
                        style: const TextStyle(fontSize: 64, color: Colors.black, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  streamBodyWidget() {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('repeat').doc('race').snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          String category = snapshot.data.get('category').toString();
          String number = snapshot.data.get('number').toString();
          if (category == 'men open amateur') {
            tts.speak('antrian nomor $number diharapkan ke meja men open amatir');
          } else {
            tts.speak('antrian nomor $number diharapkan ke meja $category');
          }
          return const SizedBox();
        });
  }
}

// ignore_for_file: avoid_web_libraries_in_flutter

import "package:universal_html/html.dart" as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:queue_control_flutter/utilities.dart' as util;
import 'package:flutter/foundation.dart' show kIsWeb;

class DisplayNonRace extends StatefulWidget {
  const DisplayNonRace({Key key}) : super(key: key);

  @override
  State<DisplayNonRace> createState() => _DisplayNonRaceState();
}

class _DisplayNonRaceState extends State<DisplayNonRace> {
  bool fullScreen = false;
  TextToSpeech tts = TextToSpeech();
  List<DocumentSnapshot> _listDocumentNonRace = [];
  List<DocumentSnapshot> _listDocumentEtc = [];

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
              Row(
                children: [
                  Flexible(child: nonRaceWidget()),
                  Flexible(child: etcWidget()),
                ],
              ),
            ],
          ),
          streamNonRaceWidget(),
          streamEtcWidget(),
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

  nonRaceWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('non race').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          if (snapshot.data.docChanges[0].type == DocumentChangeType.added) {
            _listDocumentNonRace = snapshot.data.docs;
          }
          if (snapshot.data.docChanges[0].type == DocumentChangeType.modified) {
            var xxx = _listDocumentNonRace.indexWhere((x) => x.id == snapshot.data.docChanges[0].doc.id);
            if (_listDocumentNonRace[xxx].get('current') != snapshot.data.docChanges[0].doc.get('current')) {
              String id = snapshot.data.docs[xxx].id.toString();
              String current = snapshot.data.docs[xxx].get('current').toString();
              tts.speak('antrian nomor $current diharapkan ke meja $id');
            }
            _listDocumentNonRace.clear();
            _listDocumentNonRace = snapshot.data.docs;
          }
          double cardWidth = MediaQuery.of(context).size.width / 4.5;
          double cardHeight = MediaQuery.of(context).size.height / 4.5;
          return GridView.count(
            childAspectRatio: cardWidth / cardHeight,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 1,
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

  etcWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('etc').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          if (snapshot.data.docChanges[0].type == DocumentChangeType.added) {
            _listDocumentEtc = snapshot.data.docs;
          }
          if (snapshot.data.docChanges[0].type == DocumentChangeType.modified) {
            var xxx = _listDocumentEtc.indexWhere((x) => x.id == snapshot.data.docChanges[0].doc.id);
            if (_listDocumentEtc[xxx].get('current') != snapshot.data.docChanges[0].doc.get('current')) {
              String id = snapshot.data.docs[xxx].id.toString();
              String current = snapshot.data.docs[xxx].get('current').toString();
              if (id == 'vip') {
                tts.speak('antrian nomor $current diharapkan ke meja fi ai pi');
              } else {
                tts.speak('antrian nomor $current diharapkan ke meja $id');
              }
            }
            _listDocumentEtc.clear();
            _listDocumentEtc = snapshot.data.docs;
          }
          double cardWidth = MediaQuery.of(context).size.width / 4.5;
          double cardHeight = MediaQuery.of(context).size.height / 9.3;
          return GridView.count(
            childAspectRatio: cardWidth / cardHeight,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 1,
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

  streamNonRaceWidget() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('repeat').doc('non race').snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          String category = snapshot.data.get('category').toString();
          String number = snapshot.data.get('number').toString();
          tts.speak('antrian nomor $number diharapkan ke meja $category');
          return const SizedBox();
        });
  }

  streamEtcWidget() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('repeat').doc('etc').snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          String category = snapshot.data.get('category').toString();
          String number = snapshot.data.get('number').toString();
          if (category == 'vip') {
            tts.speak('antrian nomor $number diharapkan ke meja fi ai pi');
          } else {
            tts.speak('antrian nomor $number diharapkan ke meja $category');
          }
          return const SizedBox();
        });
  }
}

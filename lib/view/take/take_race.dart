import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:queue_control_flutter/utilities.dart' as util;

class TakeRace extends StatefulWidget {
  const TakeRace({Key key}) : super(key: key);

  @override
  State<TakeRace> createState() => _TakeRaceState();
}

class _TakeRaceState extends State<TakeRace> {
  bool button = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          util.backgroundWidget(context),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              util.logoWidget(context),
              bodyWidget(),
              util.supportWidget(context),
            ],
          ),
        ],
      ),
    );
  }

  bodyWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('race').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          double cardWidth = MediaQuery.of(context).size.width / 4.5;
          double cardHeight = MediaQuery.of(context).size.height / 5;
          if (!snapshot.hasData) return const SizedBox();
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
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                    onTap: (button)
                        ? () {
                            int last = document['last'] + 1;
                            FirebaseFirestore.instance.collection('race').doc(document.id).update({'last': last});
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PRINT')));
                            util.printTicket(document.id.toString().toUpperCase(), last.toString().toUpperCase());
                            setState(() {
                              button = false;
                            });
                            Timer(const Duration(seconds: 5), (() {
                              setState(() {
                                button = true;
                              });
                              Navigator.pop(context);
                            }));
                          }
                        : null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FittedBox(
                          child: Text(
                            document.id.toString().toUpperCase(),
                            style: const TextStyle(fontSize: 28, color: Colors.blue, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FittedBox(
                          child: Text(
                            'ANTRIAN TERAKHIR: ${document['last'].toString().toUpperCase()}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:queue_control_flutter/view/operator/operator_race_single.dart';
import 'package:queue_control_flutter/utilities.dart' as util;

class OperatorRace extends StatefulWidget {
  const OperatorRace({Key key}) : super(key: key);

  @override
  State<OperatorRace> createState() => _OperatorRaceState();
}

class _OperatorRaceState extends State<OperatorRace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          util.backgroundWidget(context),
          Positioned(
            left: 16,
            top: 16,
            child: TextButton.icon(
              onPressed: (() => Navigator.pop(context)),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              label: const Text('Kembali', style: TextStyle(color: Colors.black, fontSize: 24)),
            ),
          ),
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
          double cardHeight = MediaQuery.of(context).size.height / 25;
          if (!snapshot.hasData) return const SizedBox();
          return GridView.count(
            childAspectRatio: cardWidth / cardHeight,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OperatorRaceSingle(category: 'race', documentId: document.id)),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FittedBox(
                          child: Text(
                            document.id.toString().toUpperCase(),
                            style: const TextStyle(fontSize: 24, color: Colors.blue, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:queue_control_flutter/view/operator/operator_non_race_single.dart';
import 'package:queue_control_flutter/utilities.dart' as util;

class OperatorNonRace extends StatefulWidget {
  const OperatorNonRace({Key key}) : super(key: key);

  @override
  State<OperatorNonRace> createState() => _OperatorNonRaceState();
}

class _OperatorNonRaceState extends State<OperatorNonRace> {
  List<String> tableNonRace = [
    'operator 1',
    'operator 2',
    'operator 3',
    'operator 4',
  ];

  List<String> tableEtc = [
    'operator 1',
    'operator 2',
  ];
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
              Column(
                children: [
                  nonRaceWidget(),
                  const SizedBox(height: 26),
                  etcWidget(),
                ],
              ),
              util.supportWidget(context),
            ],
          ),
        ],
      ),
    );
  }

  nonRaceWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('non race').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          double cardWidth = MediaQuery.of(context).size.width / 4.5;
          double cardHeight = MediaQuery.of(context).size.height / 20;
          if (!snapshot.hasData) return const SizedBox();
          DocumentSnapshot document = snapshot.data.docs.first;
          return GridView.count(
            childAspectRatio: cardWidth / cardHeight,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            shrinkWrap: true,
            children: List.generate(tableNonRace.length, (index) {
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
                            builder: (context) => OperatorNonRaceSingle(
                                category: 'non race', documentId: document.id, table: tableNonRace[index])),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FittedBox(
                          child: Text(
                            '${document.id.toString().toUpperCase()} ${tableNonRace[index].toString().toUpperCase()}',
                            style: const TextStyle(fontSize: 28, color: Colors.blue, fontWeight: FontWeight.bold),
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

  etcWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('etc').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          double cardWidth = MediaQuery.of(context).size.width / 4.5;
          double cardHeight = MediaQuery.of(context).size.height / 20;
          if (!snapshot.hasData) return const SizedBox();
          return GridView.count(
              childAspectRatio: cardWidth / cardHeight,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              shrinkWrap: true,
              children: [
                for (var document in snapshot.data.docs)
                  for (var table in tableEtc)
                    Container(
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
                                  builder: (context) =>
                                      OperatorNonRaceSingle(category: 'etc', documentId: document.id, table: table)),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: Text(
                                  '${document.id.toString().toUpperCase()} ${table.toString().toUpperCase()}',
                                  style: const TextStyle(fontSize: 28, color: Colors.blue, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          )),
                    )
              ]);
        },
      ),
    );
  }
}

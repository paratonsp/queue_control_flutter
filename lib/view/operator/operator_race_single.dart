import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:queue_control_flutter/utilities.dart' as util;

class OperatorRaceSingle extends StatefulWidget {
  const OperatorRaceSingle({Key key, this.category, this.documentId}) : super(key: key);
  final String category;
  final String documentId;

  @override
  State<OperatorRaceSingle> createState() => _OperatorRaceSingleState();
}

class _OperatorRaceSingleState extends State<OperatorRaceSingle> {
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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(widget.category).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        int index = snapshot.data.docs.indexWhere((element) => element.id == widget.documentId);
        DocumentSnapshot document = snapshot.data.docs[index];
        return Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white.withOpacity(0.8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                child: Text(
                  document.id.toUpperCase(),
                  style: const TextStyle(fontSize: 36),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const FittedBox(
                        child: Text(
                          'Antrian',
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ),
                      ),
                      FittedBox(
                        child: Text(
                          document['current'].toString(),
                          style: const TextStyle(fontSize: 64, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      const FittedBox(
                        child: Text(
                          'Total',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      FittedBox(
                        child: Text(
                          document['last'].toString(),
                          style: const TextStyle(fontSize: 64),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  (document['current'] < document['last'])
                      ? ElevatedButton(
                          child: const FittedBox(
                            child: Text(
                              'ANTRIAN SELANJUTNYA',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          onPressed: () {
                            int current = document['current'] + 1;
                            FirebaseFirestore.instance
                                .collection(widget.category)
                                .doc(document.id)
                                .update({'current': current});
                          },
                        )
                      : const SizedBox(),
                  (document['current'] < document['last']) ? const SizedBox(height: 16) : const SizedBox(),
                  ElevatedButton(
                    child: const FittedBox(
                      child: Text(
                        'ULANGI PANGGILAN',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('repeat')
                          .doc(widget.category)
                          .update({'category': widget.documentId, 'number': document['current']});
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:queue_control_flutter/view/operator/operator_non_race.dart';
import 'package:queue_control_flutter/view/operator/operator_race.dart';
import 'package:queue_control_flutter/utilities.dart' as util;

class Operator extends StatefulWidget {
  const Operator({Key key}) : super(key: key);

  @override
  State<Operator> createState() => _OperatorState();
}

class _OperatorState extends State<Operator> {
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          child: Container(
            width: MediaQuery.of(context).size.width / 3.5,
            height: MediaQuery.of(context).size.height / 3.5,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: FittedBox(
                child: Text(
                  'RACE',
                  style: TextStyle(fontSize: 48, color: Colors.blue, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OperatorRace()),
            );
          },
        ),
        InkWell(
          child: Container(
            width: MediaQuery.of(context).size.width / 3.5,
            height: MediaQuery.of(context).size.height / 3.5,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: FittedBox(
                child: Text(
                  'NON RACE',
                  style: TextStyle(fontSize: 48, color: Colors.blue, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OperatorNonRace()),
            );
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:queue_control_flutter/view/take/take_non_race.dart';
import 'package:queue_control_flutter/view/take/take_race.dart';
import 'package:queue_control_flutter/utilities.dart' as util;

class Take extends StatefulWidget {
  const Take({Key key}) : super(key: key);

  @override
  State<Take> createState() => _TakeState();
}

class _TakeState extends State<Take> {
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
              MaterialPageRoute(builder: (context) => const TakeRace()),
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
              MaterialPageRoute(builder: (context) => const TakeNonRace()),
            );
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_color/random_color.dart';

class Roulette extends StatefulWidget {
  final Map<int, String> labels;

  const Roulette(this.labels, {super.key});

  @override
  _RouletteState createState() => _RouletteState();
}

class _RouletteState extends State<Roulette> {
  ValueNotifier<int> selected = ValueNotifier<int>(0);
  ValueNotifier<bool> animating = ValueNotifier<bool>(false);
  StreamController<int> controller = StreamController<int>.broadcast();
  final List<Color> colors = [];
  @override
  dispose() {
    controller.close();
    super.dispose();
  }

  final RandomColor _randomColor = RandomColor();

  @override
  void initState() {
    for (int i = 0; i < widget.labels.keys.length; i++) {
      colors.add(getRandomColor());
    }
    // TODO: implement initState
    super.initState();
  }

  Color getRandomColor() {
    return _randomColor.randomColor(colorBrightness: ColorBrightness.random);
  }

  void handleRoll() {
    // Generate a random number from 0 to widget.labels.keys.length - 1
    int randomIndex = Random().nextInt(widget.labels.keys.length);
    // Add the random number to the stream
    controller.add(randomIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Test Your Luck',
          style: GoogleFonts.roboto(
            fontSize: 24,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: FortuneWheel(
                selected: controller.stream,
                animateFirst: false,
                items: [
                  for (var i in widget.labels.entries)
                    FortuneItem(
                        child: Text(
                          i.value,
                        ),
                        style: FortuneItemStyle(
                          color: colors[i.key - 1],
                        ))
                ],
                onFocusItemChanged: (value) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    selected.value = value;
                  });
                },
                onAnimationStart: () {
                  animating.value = true;
                },
                onAnimationEnd: () {
                  animating.value = false;
                },
                onFling: () => handleRoll(),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ValueListenableBuilder(
                valueListenable: selected,
                builder: (context, value, child) {
                  return RouletteScore(value, widget.labels);
                }),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ValueListenableBuilder(
              valueListenable: animating,
              builder: (context, value, child) {
                return Center(
                  child: ElevatedButton(
                    onPressed: value ? null : handleRoll,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Center(
                        child: const Text(
                          'Roll',
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class RouletteScore extends StatelessWidget {
  final int selected;
  final Map<int, String> labels;

  const RouletteScore(this.selected, this.labels, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text('${labels[selected + 1]}',
        style: const TextStyle(
          fontStyle: FontStyle.italic,
          fontSize: 24.0,
        ));
  }
}

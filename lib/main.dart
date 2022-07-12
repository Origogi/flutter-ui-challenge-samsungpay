import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_samsungpay/provider/position_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Samsung Pay'),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = usePageController();
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(currentPositionProvider.state).state = controller.page!;
      });

      controller.addListener(() {
        ref.read(currentPositionProvider.state).state = controller.page!;
      });

      return null;
    }, const []);

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Stack(
          children: [
            CardWidget(4, Colors.red),
            CardWidget(3, Colors.blue),
            CardWidget(2, Colors.amber),
            CardWidget(1, Colors.black),
            CardWidget(0, Colors.green),
            PageView.builder(
                controller: controller,
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: ((context, index) => Container())),
          ],
        ));
  }
}

const maxCardHeight = 200.0;
const maxCardWidth = 300.0;

class CardWidget extends HookConsumerWidget {
  final int cardIndex;
  final Color cardColor;



  CardWidget(this.cardIndex, this.cardColor, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPosition = ref.watch(currentPositionProvider);

    double dx = (MediaQuery.of(context).size.width / 2) - maxCardWidth / 2;
    double dy = (MediaQuery.of(context).size.height / 2) - maxCardHeight;
    double cardWidth = maxCardWidth;
    double cardHeight = maxCardHeight;

    final diff = cardIndex - currentPosition;

    if (diff >= -1.0 && diff < 0) {
      dx += (diff * 280);
      cardWidth += diff * 40;
      cardHeight += diff * 40;
      dy -= diff * 20;

    } else if (diff < -1.0) {
      dx -= 280.0;
      cardWidth -= 40;
      cardHeight -= 40;
      dy += 20;
    } else {
      dy -= 10 * diff;
    }

    return Positioned(
      top: dy,
      left: dx,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        color: cardColor,
      ),
    );
  }
}

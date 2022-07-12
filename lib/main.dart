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
            CardWidget(0, Colors.red),
            CardWidget(1, Colors.blue),

            PageView.builder(
                controller: controller,
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: ((context, index) => Container())),
          ],
        ));
  }
}

class CardWidget extends HookConsumerWidget {
  final int cardIndex;
  final Color cardColor;

  CardWidget(this.cardIndex, this.cardColor, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPosition = ref.watch(currentPositionProvider);

    double dx = (MediaQuery.of(context).size.width / 2) - 150;
    double dy = (MediaQuery.of(context).size.height / 2) - 200;

    final diff = cardIndex - currentPosition;

    if (diff >= -1.0 && diff < 0) {
      dx += (diff * 300);
    } else if (diff < - 1.0) {
      dx -= 300.0;
    }

    return Positioned(
      top: dy,
      left: dx,
      child: Container(
        width: 300,
        height: 200,
        color: cardColor.withOpacity(0.2),
      ),
    );
  }
}

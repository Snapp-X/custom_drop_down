import 'package:flex_dropdown/flex_dropdown.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ListenableOverlayPortalController _controller = ListenableOverlayPortalController();
  MenuPosition position = MenuPosition.bottomStart;
  bool dismissOnTapOutside = true;
  bool useButtonSize = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
      appBar: AppBar(
        title: const Text('Flex Drop Down'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 150),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 64.0),
              child: RawFlexDropDown(
                controller: _controller,
                menuPosition: position,
                dismissOnTapOutside: dismissOnTapOutside,
                buttonBuilder: (context, onTap) {
                  return ButtonWidget(
                    width: 400,
                    onTap: onTap,
                  );
                },
                menuBuilder: (context, width) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: MenuWidget(
                      width: useButtonSize ? width : 300,
                      onItemTap: () {
                        _controller.hide();
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 250),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Dismiss on tap outside'),
              const SizedBox(width: 8),
              Switch(
                value: dismissOnTapOutside,
                onChanged: (value) {
                  setState(() {
                    dismissOnTapOutside = value;
                  });
                },
              ),
              const SizedBox(width: 32),
              const Text('Use button size'),
              const SizedBox(width: 8),
              Switch(
                value: useButtonSize,
                onChanged: (value) {
                  setState(() {
                    useButtonSize = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          Wrap(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    position = MenuPosition.bottomStart;
                  });
                },
                child: const Text("Bottom Left"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    position = MenuPosition.bottomEnd;
                  });
                },
                child: const Text("Bottom Right"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    position = MenuPosition.bottomCenter;
                  });
                },
                child: const Text("Bottom Center"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    position = MenuPosition.topStart;
                  });
                },
                child: const Text("Top Left"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    position = MenuPosition.topEnd;
                  });
                },
                child: const Text("Top Right"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    position = MenuPosition.topCenter;
                  });
                },
                child: const Text("Top Center"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    this.height = 48,
    this.width,
    this.onTap,
    this.child,
  });

  final double? height;
  final double? width;

  final VoidCallback? onTap;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.black12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: const Center(child: Text('Button')),
        ),
      ),
    );
  }
}

class MenuWidget extends StatelessWidget {
  const MenuWidget({
    super.key,
    this.width,
    required this.onItemTap,
  });

  final double? width;
  final VoidCallback onItemTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1.5,
            color: Colors.black26,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 32,
            offset: Offset(0, 20),
            spreadRadius: -8,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _FakeItemHolder(
                  text: 'Item 1',
                  onTap: onItemTap,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _FakeItemHolder(
                  text: 'Item 2',
                  onTap: onItemTap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _FakeItemHolder(
                  text: 'Item 3',
                  onTap: onItemTap,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _FakeItemHolder(
                  text: 'Item 4',
                  onTap: onItemTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FakeItemHolder extends StatelessWidget {
  const _FakeItemHolder({
    required this.text,
    required this.onTap,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 80,
      child: Material(
        color: theme.colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Center(child: Text(text)),
        ),
      ),
    );
  }
}

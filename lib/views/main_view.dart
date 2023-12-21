import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _textController = TextEditingController();
  bool isTextEmpty = true;
  final items = [];

  @override
  void initState() {
    _textController.addListener(_updateButtonState);
    super.initState();
  }

  void _updateButtonState() {
    setState(() {
      isTextEmpty = _textController.text.isEmpty;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffe8e8e8),
        appBar: AppBar(
          backgroundColor: const Color(0xfff0f424),
          title: const Text(
            'TODO List',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 150,
                child: TextField(
                  controller: _textController,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Start writting your todo...',
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    onPressed: isTextEmpty
                        ? null
                        : () {
                            items.add(_textController.text);
                            _textController.clear();
                          },
                    backgroundColor: isTextEmpty
                        ? const Color(0xFFCECECE)
                        : const Color(0xFFF0F424),
                    child: const Icon(
                      Icons.add,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(items[index]),
                    direction: DismissDirection.endToStart,
                    onDismissed: (DismissDirection direction) {
                      setState(() {
                        items.removeAt(index);
                      });
                    },
                    background: Container(
                      color: Colors.red,
                    ),
                    child: ListTile(
                      title: Text(items[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}

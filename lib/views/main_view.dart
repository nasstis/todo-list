import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/views/tags_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool isTextEmpty = true;
  final itemsTest = [];
  final items = [];
  final List<Color> tileColors = const [
    Color(0xFFDAFDBB),
    Color(0xFFF0F424),
    Color(0xFF9BECFF),
  ];
  String selectedTag = '';
  Map<String, IconData> tagIcon = {
    'home': Icons.home,
    'work': Icons.work,
    'study': Icons.book,
    'sport': Icons.sports_football,
    'hobby': Icons.pets,
    'another': Icons.grade,
  };

  @override
  void initState() {
    _titleController.addListener(_updateButtonState);
    _descriptionController.addListener(_updateButtonState);
    _loadItems();
    super.initState();
  }

  void _updateButtonState() {
    setState(() {
      isTextEmpty =
          _titleController.text.isEmpty || _descriptionController.text.isEmpty;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _loadItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedItems = prefs.getStringList('items');

    if (savedItems != null) {
      setState(() {
        itemsTest.clear();

        for (String itemString in savedItems) {
          Map<String, dynamic> itemMap = jsonDecode(itemString);
          Todo loadedTodo = Todo(
              title: itemMap['title'],
              description: itemMap['description'],
              tag: itemMap['tag']);
          itemsTest.add(loadedTodo);
        }
      });
    }
  }

  void _saveItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todoStrings =
        itemsTest.map((todo) => jsonEncode(todo.toJson())).toList();
    await prefs.setStringList('items', todoStrings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
            Container(
              color: Colors.white,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      controller: _titleController,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Title',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 90,
                    child: TextField(
                      controller: _descriptionController,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Description',
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TagSelector(
                      onTagSelected: (tag) {
                        setState(() {
                          selectedTag = tag; // Отримання вибраного тегу
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: ElevatedButton(
                        onPressed: isTextEmpty || selectedTag == ''
                            ? null
                            : () {
                                Todo newTodo = Todo(
                                    title: _titleController.text,
                                    description: _descriptionController.text,
                                    tag: selectedTag);
                                setState(() {
                                  itemsTest.add(newTodo);
                                  _titleController.clear();
                                  _descriptionController.clear();
                                  _saveItems();
                                });
                              },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF0F424)),
                        child: const Icon(
                          Icons.add,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Text(
                    'Your todos',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 36,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: itemsTest.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(itemsTest[index].title),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          itemsTest.removeAt(index);
                          _saveItems();
                        });
                      },
                      background: Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20.0)),
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.0),
                                child: Text(
                                  'Delete todo',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ListTile(
                          leading: Icon(
                            tagIcon[itemsTest[index].tag],
                            size: 38,
                          ),
                          title: Text(
                            itemsTest[index].title,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            itemsTest[index].description,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          tileColor: tileColors[index % tileColors.length],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              color: Colors.white,
              height: 20,
            )
          ],
        ));
  }
}

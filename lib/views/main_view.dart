import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/constants/constants.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/widgets/input_widget.dart';
import 'package:todo_list/widgets/tags_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool isTextEmpty = true;
  final items = [];
  String selectedTag = '';

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
        items.clear();

        for (String itemString in savedItems) {
          Map<String, dynamic> itemMap = jsonDecode(itemString);
          Todo loadedTodo = Todo(
              title: itemMap['title'],
              description: itemMap['description'],
              tag: itemMap['tag']);
          items.add(loadedTodo);
        }
      });
    }
  }

  void _saveItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todoStrings =
        items.map((todo) => jsonEncode(todo.toJson())).toList();
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
                InputField(
                  controller: _titleController,
                  height: 40.0,
                  text: 'Title',
                ),
                InputField(
                  controller: _descriptionController,
                  height: 90.0,
                  text: 'Description',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TagSelector(
                      onTagSelected: (tag) {
                        setState(() {
                          selectedTag = tag;
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
                                  items.add(newTodo);
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
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(items[index].title),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          items.removeAt(index);
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
                            tagIcon[items[index].tag],
                            size: 38,
                          ),
                          title: Text(
                            items[index].title,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            items[index].description,
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

import 'package:flutter/material.dart';

class TagWidget extends StatefulWidget {
  final String text;
  final bool isSelected;
  final Function(bool) onSelect;

  const TagWidget({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  _TagWidgetState createState() => _TagWidgetState();
}

class _TagWidgetState extends State<TagWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        widget.onSelect(!widget.isSelected);
      },
      style: ElevatedButton.styleFrom(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        backgroundColor:
            widget.isSelected ? const Color(0xffdafdbb) : Colors.white,
      ),
      child: Text(
        widget.text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: 'Montserrat',
          fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class TagSelector extends StatefulWidget {
  final Function(String) onTagSelected;

  const TagSelector({super.key, required this.onTagSelected});
  @override
  _TagSelectorState createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  String selectedTag = '';
  final List<String> tags = [
    'home',
    'study',
    'work',
    'sport',
    'hobby',
    'another'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 8.0,
          children: tags.take(3).map((tag) {
            return TagWidget(
              text: tag,
              isSelected: selectedTag == tag,
              onSelect: (isSelected) {
                handleTagSelection(isSelected, tag);
              },
            );
          }).toList(),
        ),
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 8.0,
          children: tags.skip(3).map((tag) {
            return TagWidget(
              text: tag,
              isSelected: selectedTag == tag,
              onSelect: (isSelected) {
                handleTagSelection(isSelected, tag);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  void handleTagSelection(bool isSelected, String tag) {
    setState(() {
      selectedTag = isSelected ? tag : '';
      widget.onTagSelected(selectedTag);
    });
  }
}

import 'package:flutter/material.dart';
 

class SearchGridViewScreen extends StatefulWidget {
  const SearchGridViewScreen({
    super.key,
    required this.gridItems,
    required this.rows,
  });

  final int rows;
  final List<List<String>> gridItems;

  @override
  _SearchGridViewScreenState createState() => _SearchGridViewScreenState();
}

class _SearchGridViewScreenState extends State<SearchGridViewScreen> {
  
  String searchText = '';
  late List<List<bool>> highlightItems;

  @override
  void initState() {
    super.initState();
    highlightItems = List.generate(
      widget.gridItems.length,
      (_) => List<bool>.filled(widget.gridItems[0].length, false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search GridView'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                  updateHighlightItems();
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search Text',
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .9,
                  child: GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widget.gridItems[0].length,
                      // crossAxisCount: widget.rows,
                    ),
                    itemBuilder: (context, index) {
                      final row = index ~/ widget.gridItems[0].length;
                      final col = index % widget.gridItems[0].length;
                      final isHighlighted = highlightItems[row][col];

                      return Container(
                        margin: const EdgeInsets.all(3.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Text(
                            widget.gridItems[row][col],
                            style: TextStyle(
                              fontSize: 25.0,
                              color: isHighlighted ? Colors.redAccent : Colors.black,
                              fontWeight: isHighlighted
                                  ? FontWeight.w800
                                  : FontWeight.w100,
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount:
                        widget.gridItems.length * widget.gridItems[0].length,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateHighlightItems() {
    setState(() {
      highlightItems = List.generate(
        widget.gridItems.length,
        (row) => List<bool>.filled(widget.gridItems[row].length, false),
      );

      for (int row = 0; row < widget.gridItems.length; row++) {
        for (int col = 0; col < widget.gridItems[row].length; col++) {
          if (checkLeftToRight(row, col)) {
            for (int i = 0; i < searchText.length; i++) {
              if (col + i < widget.gridItems[row].length) {
                highlightItems[row][col + i] = true;
              }
            }
          }
          if (checkTopToBottom(row, col)) {
            for (int i = 0; i < searchText.length; i++) {
              if (row + i <= widget.gridItems.length) {
                highlightItems[row + i][col] = true;
              }
            }
          }
          if (checkSouthEastDiagonal(row, col)) {
            for (int i = 0; i < searchText.length; i++) {
              if (row + i < widget.gridItems.length &&
                  col + i < widget.gridItems[row + i].length) {
                highlightItems[row + i][col + i] = true;
              }
            }
          }
        }
      }
    });
  }

  bool checkLeftToRight(int row, int col) {
    if (col + searchText.length <= widget.gridItems[row].length) {
      final rowString =
          widget.gridItems[row].sublist(col, col + searchText.length);
      return rowString.join('') == searchText;
    }
    return false;
  }

  bool checkTopToBottom(int row, int col) {
    if (row + searchText.length <= widget.gridItems.length) {
      final columnString = List.generate(
        searchText.length,
        (index) => row + index < widget.gridItems.length &&
                col < widget.gridItems[row + index].length
            ? widget.gridItems[row + index][col]
            : '',
      );
      return columnString.join('') == searchText;
    }
    return false;
  }

  bool checkSouthEastDiagonal(int row, int col) {
    if (row + searchText.length <= widget.gridItems.length &&
        col + searchText.length <= widget.gridItems[row].length) {
      final diagonalString = List.generate(
        searchText.length,
        (index) => row + index < widget.gridItems.length &&
                col + index < widget.gridItems[row + index].length
            ? widget.gridItems[row + index][col + index]
            : '',
      );
      return diagonalString.join('') == searchText;
    }
    return false;
  }
}














// final List<List<String>> gridItems = [
  //   ['s', 'a', 'p'],
  //   ['w', 'a', 'p'],
  //   ['t', 'a', 'p'],
  // ];

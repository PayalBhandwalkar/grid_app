import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gridapp/screens/SearchGridViewScreen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {

int rows = 0;
  int columns = 0;

  int no_of_alphabets = 0;

  bool _validateRows = false;
  bool _validateColumns = false;

  String text = "";
  bool _isRowColInputVisible = true;

  final _rowController = TextEditingController();
  final _columnController = TextEditingController();

  List<List<String>> convertStringTo2DArray(
      String string, int rows, int columns) {
    if (rows * columns != string.length) {
      print("Invalid dimensions for conversion.");
      return [
        ["null"]
      ];
    }

    List<List<String>> array2D =
        List.generate(rows, (_) => List<String>.filled(columns, ""));

    int index = 0;

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        array2D[i][j] = string[index];
        index++;
      }
    }

    return array2D;
  }

  List<List<String>> gridData =
      List.generate(3, (_) => List.generate(3, (_) => ''));
  String enteredValues = '';

  void updateGridData() {
    final numRows = (rows * columns / 3).ceil();
    final currentRows = gridData.length;
    final currentCols = gridData.isNotEmpty ? gridData[0].length : 0;

    if (numRows > currentRows) {
      final rowsToAdd = numRows - currentRows;
      for (var i = 0; i < rowsToAdd; i++) {
        gridData.add(List.generate(currentCols, (_) => ''));
      }
    } else if (numRows < currentRows) {
      gridData.removeRange(numRows, currentRows);
    }

    final numCols = (rows * columns / numRows).ceil();
    if (numCols > currentCols) {
      for (var i = 0; i < gridData.length; i++) {
        final colsToAdd = numCols - currentCols;
        gridData[i].addAll(List.generate(colsToAdd, (_) => ''));
      }
    } else if (numCols < currentCols) {
      for (var i = 0; i < gridData.length; i++) {
        gridData[i].removeRange(numCols, currentCols);
      }
    }
  }

  bool hasEmptyCell() {
    for (var row in gridData) {
      for (var cell in row) {
        if (cell.isEmpty) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
       child: Scaffold(
       appBar: AppBar(
        title: const Text("Grid App"),
        backgroundColor: Colors.black,
       ),
       body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _isRowColInputVisible
          ? Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                  controller: _rowController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    label: const Text("Enter values of columns"),
                    errorText: 
                    _validateRows ? "Required columns" : null,
                  ),
                   ),
                  )),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _columnController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          label: const Text("Enter values of Rows"),
                          errorText: 
                             _validateColumns ? "Required rows" : null,
                        ),
                      ),
                      ),),
            ],
            )
            :Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.height,
                    height: MediaQuery.of(context).size.height * .5,
                    child: GridView.count(
                      crossAxisCount: rows,
                      children: List.generate(rows*columns, (index) {
                       final row = index ~/ gridData[0].length;
                       final col = index % gridData[0].length;
                       return Padding(
                        padding: EdgeInsets.all(100.0),
                        child: SizedBox(
                          child: GridCell(
                            value: gridData[row][col],
                            onChanged: (newValue) {
                              setState(() {
                                gridData[row][col] = newValue;
                                enteredValues = gridData
                                 .map((row) => row.join(''))
                                 .join('');
                              });
                            }
                          ),
                        )
                        );
                      }
                      )
                      ),
                  ),
                ),
              )),
              Container(
               width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .15,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_isRowColInputVisible) {
                          if ((rows == 0 || columns == 0) &&
                              (_rowController.text.isEmpty ||
                                  _columnController.text.isEmpty)) {
                            _validateColumns = true;
                            _validateRows = true;
                        }else {
                             rows = int.parse(_rowController.text);
                            columns = int.parse(_columnController.text);

                            updateGridData();

                            no_of_alphabets = rows * columns;
                            _validateColumns = false;
                            _validateRows = false;

                            _isRowColInputVisible = false;
                        }
                      } else {
                        if (!hasEmptyCell()) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SearchGridViewScreen(
                                  rows: rows,
                                  gridItems: gridData,
                                ),
                              ),
                            );

                      } else {
                        print("Else is called");
                          }
                        }
                      });
                    },
                    child: const Text("Submit"),
                  ),
                  _isRowColInputVisible
                      ? const SizedBox()
                      : TextButton(
                          onPressed: () {
                            setState(() {
                              _isRowColInputVisible = true;
                            });
                          },
                          child: const Text("Change Rows & Columns"),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}







class GridCell extends StatefulWidget {
  const GridCell({super.key, required this.onChanged, required this.value});
  final Function(String) onChanged;
  final String value;

  @override
  State<GridCell> createState() => _GridCellState();
}

class _GridCellState extends State<GridCell> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged,
      textAlign: TextAlign.center,
      maxLength: 1,
      controller: TextEditingController(text: widget.value),
      decoration: InputDecoration(
        errorText: widget.value.isEmpty ? "Add a value" : null,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        // isDense: true,
        contentPadding: EdgeInsets.all(10.0),
        // filled: true,
      ),
    );
  }
}
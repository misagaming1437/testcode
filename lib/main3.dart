import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_expandable_table/flutter_expandable_table.dart';

const Color primaryColor = Color(0xFF1e2f36); //corner
const Color accentColor = Color(0xFF0d2026); //background
const TextStyle textStyle = TextStyle(color: Colors.white);
const TextStyle textStyleSubItems = TextStyle(color: Colors.grey);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExpandableTable Example',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: const MyHomePage(),
      scrollBehavior: AppCustomScrollBehavior(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class DefaultCellCard extends StatelessWidget {
  final Widget child;

  const DefaultCellCard({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      margin: const EdgeInsets.all(1),
      child: child,
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  _buildCell(String content, {CellBuilder? builder}) {
    return ExpandableTableCell(
      child: builder != null
          ? null
          : DefaultCellCard(
              child: Center(
                child: Text(
                  content,
                  style: textStyle,
                ),
              ),
            ),
      builder: builder,
    );
  }

  ExpandableTableCell _buildFirstRowCell() {
    return ExpandableTableCell(
      builder: (context, details) => DefaultCellCard(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              SizedBox(
                width: 24 * details.row!.address.length.toDouble(),
                child: details.row?.children != null
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: AnimatedRotation(
                          duration: const Duration(milliseconds: 500),
                          turns:
                              details.row?.childrenExpanded == true ? 0.25 : 0,
                          child: const Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : null,
              ),
              Text(
                'ac ac ac',
                style: textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  final columnTile = ['1', '2', '3'];
  static const int columnsCount = 2;
  static const int subColumnsCount = 2;
  static const int rowsCount = 3;
  static const int subRowsCount = 3;
  static const int totalColumns = columnsCount + subColumnsCount;

  List<ExpandableTableRow> _generateRows(int quantity, {int depth = 0}) {
    bool generateLegendRow = (depth == 0 || depth == 2);
    return List.generate(
      quantity,
      (rowIndex) => ExpandableTableRow(
          firstCell: _buildFirstRowCell(),
          // children: ((rowIndex == 3 || rowIndex == 2) && depth < 3)
          //     ? _generateRows(subRowsCount, depth: depth + 1)
          //     : null,
          children: [
            ExpandableTableRow(
              firstCell: _buildCell('content'),
              cells: [
                _buildCell('a'),
                _buildCell('b'),
              ],
            ),
          ],
          // cells: [
          //   _buildCell('1'),
          //   _buildCell('2'),
          //   _buildCell('3'),
          //   _buildCell('4'),
          // ],
          legend: const DefaultCellCard(
            child: Align(
              alignment: FractionalOffset.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Text(
                  'This is row legend',
                  style: textStyle,
                ),
              ),
            ),
          )),
    );
  }

  ExpandableTable _buildExpandableTable() {
    //Creation header
    List<ExpandableTableHeader> subHeader = List.generate(
      subColumnsCount,
      (index) => ExpandableTableHeader(
        cell: _buildCell('Sub Column $index'),
      ),
    );

    //Creation header
    List<ExpandableTableHeader> headers = List.generate(
      columnsCount,
      (index) => ExpandableTableHeader(
          cell: _buildCell(
              '${index == 1 ? 'Expandable\nColumn' : 'Column'} $index'),
          children: index == 1 ? subHeader : null),
    );

    return ExpandableTable(
      firstHeaderCell: _buildCell('Expandable\nTable'),
      rows: _generateRows(rowsCount),
      headers: headers,
      defaultsRowHeight: 60,
      defaultsColumnWidth: 150,
      firstColumnWidth: 250,
      scrollShadowColor: accentColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            '   Simple Table                    |                    Expandable Table'),
        centerTitle: true,
      ),
      body: Container(
        color: accentColor,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: _buildExpandableTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

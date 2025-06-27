import 'package:flutter/material.dart';

class DraggableSheetWithList extends StatefulWidget {
  const DraggableSheetWithList({Key? key}) : super(key: key);

  @override
  State<DraggableSheetWithList> createState() => _DraggableSheetWithListState();
}

class _DraggableSheetWithListState extends State<DraggableSheetWithList> {
  bool _isDraggingHandle = false;
  late DraggableScrollableController _sheetController;
  late ScrollController _scrollController;

  var currentSheetSize = 0.5;
  var maxSheetSize = 1.0;
  var minSheetSize = 0.1;

  @override
  void initState() {
    super.initState();
    _sheetController = DraggableScrollableController();
    _scrollController = ScrollController();
    _sheetController.addListener(() {
      print('sheetController.size: ${_sheetController.size}');
      if (_sheetController.size == 1.0) {
        setState(() {
          // currentSheetSize = 0.99;
          // minSheetSize = 0.99;
        });
      }
    });
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Draggable Sheet with List')),
      body: Stack(
        children: [
          // Your main content here (e.g., a map)
          Container(
            color: Colors.lightBlue[100],
            child: const Center(child: Text('Main Content')),
          ),
          // Draggable Scrollable Sheet
          DraggableScrollableSheet(
            controller: _sheetController,
            expand: true,
            shouldCloseOnMinExtent: false,
            initialChildSize: 0.5,
            minChildSize: minSheetSize,
            maxChildSize: maxSheetSize,
            snap: true,
            snapSizes: [0.1, 0.5, 1],
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10.0, spreadRadius: 2.0)],
                ),
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: GestureDetector(
                        onTapDown: (details) {
                          print('onTapDown');
                          setState(() {
                            _isDraggingHandle = true;
                          });
                        },
                        onTapUp: (details) {
                          print('onTapUp');
                          setState(() {
                            _isDraggingHandle = false;
                            print('isDraggingHandle: $_isDraggingHandle');
                          });
                        },
                        onPanStart: (_) {
                          print('onPanStart');
                          setState(() {
                            _isDraggingHandle = true;
                          });
                        },
                        onPanEnd: (_) {
                          print('onPanEnd');
                          setState(() {
                            _isDraggingHandle = false;
                            print('isDraggingHandle: $_isDraggingHandle');
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    PrimaryScrollController(
                      controller: _scrollController,
                      child: SliverList.builder(
                        itemCount: 50,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text('Item ${index + 1}'),
                            onTap: () {
                              // Handle item tap
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

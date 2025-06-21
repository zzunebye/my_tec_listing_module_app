import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_tec_listing_module_app/screens/draggable_sheet_with_list.dart';

enum ViewMode { list, listHalf, map }

class BookingListScreen extends StatefulHookWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  double _sheetPosition = 0.5;
  late DraggableScrollableController draggableController;

  @override
  void initState() {
    super.initState();
    draggableController = DraggableScrollableController();
  }

  @override
  Widget build(BuildContext context) {
    final topTapController = useTabController(initialLength: 4);
    final isScrollingInside = useState(false);
    final scrollControllerContainer = useRef<ScrollController?>(null);
    final viewMode = useState(ViewMode.map);

    useEffect(() {
      draggableController.addListener(() {
        print(draggableController.size);
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DraggableSheetWithList()),
          ),
        ),
        bottom: TabBar(
          controller: topTapController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Meeting Room'),
            Tab(text: 'Coworking'),
            Tab(text: 'Day Office'),
            Tab(text: 'Event Space'),
          ],
        ),
        title: Center(
          child: TextButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('Hong Kong'), SizedBox(width: 8), Icon(Icons.navigation_rounded)],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (viewMode.value == ViewMode.list || viewMode.value == ViewMode.listHalf) {
                draggableController.animateTo(
                  0.1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
                viewMode.value = ViewMode.map;
              } else {
                draggableController.animateTo(
                  1.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
                viewMode.value = ViewMode.list;
              }
            },
            icon: viewMode.value == ViewMode.list || viewMode.value == ViewMode.listHalf
                ? const Icon(Icons.list)
                : const Icon(Icons.map),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/tec_map_sample.png'),
          DraggableScrollableSheet(
            initialChildSize: _sheetPosition,
            controller: draggableController,
            snap: true,
            expand: false,
            minChildSize: 0.2,
            maxChildSize: 1.0,
            snapSizes: [0.2, 0.5, 1.0],
            builder: (BuildContext context, ScrollController scrollController) {
              return ColoredBox(
                color: Theme.of(context).colorScheme.primary,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onVerticalDragStart: (DragStartDetails details) {
                        isScrollingInside.value = false;
                        print('isScrollingInside: ${isScrollingInside.value}');
                      },
                      onVerticalDragEnd: (DragEndDetails details) {
                        isScrollingInside.value = false;
                        print('isScrollingInside: ${isScrollingInside.value}');
                      },
                      onVerticalDragUpdate: (DragUpdateDetails details) {
                        isScrollingInside.value = false;
                        print('isScrollingInside: ${isScrollingInside.value}');
                      },
                      onTap: () {
                        isScrollingInside.value = !isScrollingInside.value;
                        scrollControllerContainer.value = isScrollingInside.value ? null : scrollController;
                        print('isScrollingInside: ${isScrollingInside.value}');
                      },

                      child: Column(
                        children: [
                          Text("Tapme: ${isScrollingInside.value}", style: TextStyle(color: Colors.white)),
                          Container(
                            width: double.infinity,
                            color: Theme.of(context).colorScheme.onSurface,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                width: 32.0,
                                height: 4.0,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    WrappedFilter(),
                    Flexible(
                      child: SingleChildScrollView(
                        controller: isScrollingInside.value ? null : scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 25,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text(
                                    'Item $index',
                                    style: TextStyle(color: Theme.of(context).colorScheme.surface),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
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

class WrappedFilter extends StatelessWidget {
  const WrappedFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.filter_list, size: 18.0, color: Theme.of(context).colorScheme.surface),
                  const SizedBox(width: 4.0),
                  Text('Filter', style: TextStyle(color: Theme.of(context).colorScheme.surface)),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today, size: 18.0, color: Theme.of(context).colorScheme.surface),
                const SizedBox(width: 4.0),
                Text('Today', style: TextStyle(color: Theme.of(context).colorScheme.surface)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.access_time, size: 18.0, color: Theme.of(context).colorScheme.surface),
                const SizedBox(width: 4.0),
                Text('06:15 PM - 06:45 PM', style: TextStyle(color: Theme.of(context).colorScheme.surface)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.people, size: 18.0, color: Theme.of(context).colorScheme.surface),
                const SizedBox(width: 4.0),
                Text('4 Seats', style: TextStyle(color: Theme.of(context).colorScheme.surface)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.people, size: 18.0, color: Theme.of(context).colorScheme.surface),
                const SizedBox(width: 4.0),
                Text('4 Seats', style: TextStyle(color: Theme.of(context).colorScheme.surface)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

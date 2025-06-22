import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_tec_listing_module_app/screens/draggable_sheet_with_list.dart';
import 'package:my_tec_listing_module_app/widgets/room_card.dart';

enum ViewMode { list, map }

class BookingListScreen extends StatefulHookWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  double _sheetPosition = 0.5;
  late DraggableScrollableController draggableController;
  late ScrollController listController;

  @override
  void initState() {
    super.initState();
    draggableController = DraggableScrollableController();
    listController = ScrollController();
  }

  @override
  void dispose() {
    draggableController.dispose();
    listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topTapController = useTabController(initialLength: 4);
    final viewMode = useState(ViewMode.map);
    final isFullScreen = useState(false);

    useEffect(() {
      void updateFullScreen() {
        final currentSize = draggableController.size;
        if (currentSize == 1.0) {
          isFullScreen.value = true;
        } else {
          isFullScreen.value = false;
        }
        print('isFullScreen: ${isFullScreen.value}');
      }

      void updateViewMode() {
        final currentSize = draggableController.size;
        if (currentSize >= 0.5) {
          viewMode.value = ViewMode.list;
          // isFullScreen.value = currentSize == 1.0;
        } else if (currentSize <= 0.2) {
          viewMode.value = ViewMode.map;
          // isFullScreen.value = false;
        }
        print('Sheet size: $currentSize');
        print('View mode: ${viewMode.value}');
        // if (currentSize >= 0.8) {
        //   viewMode.value = ViewMode.list;
        // } else if (currentSize >= 0.4) {
        //   viewMode.value = ViewMode.listHalf;
        // } else {
        //   viewMode.value = ViewMode.map;
        // }
      }

      draggableController.addListener(updateViewMode);
      draggableController.addListener(updateFullScreen);
      return () {
        draggableController.removeListener(updateViewMode);
        draggableController.removeListener(updateFullScreen);
      };
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
              // isFullScreen.value = false;
              if (viewMode.value == ViewMode.list) {
                draggableController.animateTo(
                  0.2,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );

                // viewMode.value = ViewMode.map;
              } else {
                draggableController.animateTo(
                  1.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
                // viewMode.value = ViewMode.list;
              }
            },
            icon: viewMode.value == ViewMode.map ? const Icon(Icons.map) : const Icon(Icons.list),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          InteractiveViewer(
            boundaryMargin: const EdgeInsets.all(20.0),
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.asset('assets/images/tec_map_sample.png', fit: BoxFit.cover),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.2,
            controller: draggableController,
            snap: true,
            // expand: false,
            minChildSize: 0.2,
            maxChildSize: 1.0,
            snapSizes: [0.2, 0.5, 1.0],
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: isFullScreen.value == false
                      ? const BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))
                      : BorderRadius.zero,
                ),
                child: CustomScrollView(
                  controller: scrollController,
                  physics: isFullScreen.value == true
                      ? const NeverScrollableScrollPhysics()
                      : const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // Draggable Handle
                    isFullScreen.value == false
                        ? SliverToBoxAdapter(
                            child: Container(
                              width: double.infinity,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 48.0,
                                  height: 4.0,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SliverToBoxAdapter(child: SizedBox.shrink()),
                    SliverToBoxAdapter(child: SizedBox(height: 8)),
                    // Filter Section
                    const SliverToBoxAdapter(child: WrappedFilter()),
                    SliverToBoxAdapter(child: SizedBox(height: 8)),
                    // List Content with SliverLayoutBuilder
                    SliverLayoutBuilder(
                      builder: (context, constraints) {
                        // Use remaining paint extent for available height
                        double availableHeight = constraints.remainingPaintExtent;

                        return SliverToBoxAdapter(
                          child: SizedBox(
                            height: availableHeight > 100 ? availableHeight : 300, // Fallback height
                            child: draggableController.size > 0.2
                                ? ListView.builder(
                                    controller: listController,
                                    itemCount: 25,
                                    itemBuilder: (BuildContext context, int index) {
                                      return RoomCard();
                                    },
                                  )
                                : SizedBox.shrink(),
                          ),
                        );
                      },
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        spacing: 4.0,
        // runSpacing: 8.0,
        children: [
          FilterChip(key: Key('filter_chip_0'), label: 'Filter', icon: Icons.people),
          FilterChip(key: Key('filter_chip_1'), label: 'Today', icon: Icons.access_time),
          FilterChip(key: Key('filter_chip_2'), label: '06:15 PM - 06:45 PM', icon: Icons.people),
          FilterChip(key: Key('filter_chip_3'), label: '4 Seats', icon: Icons.calendar_today),
          FilterChip(key: Key('filter_chip_4'), label: 'All centres in the City', icon: Icons.filter_list),
        ],
      ),
    );
  }
}

class FilterChip extends StatelessWidget {
  const FilterChip({super.key, required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Chip(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      avatar: Icon(icon, size: 18.0, color: Theme.of(context).colorScheme.surface),
      label: Text(label, style: Theme.of(context).textTheme.labelMedium),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      labelPadding: const EdgeInsets.only(left: 2.0, right: 4.0),
    );
  }
}

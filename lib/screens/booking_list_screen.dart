import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_tec_listing_module_app/presentation/providers/current_city_state.dart';
import 'package:my_tec_listing_module_app/widgets/city_selection_dialog.dart';
import 'package:my_tec_listing_module_app/widgets/room_card.dart';
import 'package:my_tec_listing_module_app/widgets/wrapped_filters.dart';

enum ViewMode { list, map }

enum SearchMode { meetingRoom, coworking, dayOffice, eventSpace }

class BookingListScreen extends StatefulHookWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
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
    final searchMode = useState<SearchMode>(SearchMode.meetingRoom);

    useEffect(() {
      void updateFullScreen() {
        final currentSize = draggableController.size;
        if (currentSize == 1.0) {
          isFullScreen.value = true;
        } else {
          isFullScreen.value = false;
        }
      }

      void updateViewMode() {
        final currentSize = draggableController.size;
        if (currentSize >= 0.5) {
          viewMode.value = ViewMode.list;
        } else if (currentSize <= 0.2) {
          viewMode.value = ViewMode.map;
        }
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
          onPressed: () => {},
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
          child: Consumer(
            builder: (context, ref, child) {
              final currentCity = ref.watch(currentCityStateProvider);
              return TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => CitySelectionDialog(
                      onCitySaved: (String city) {
                        ref.read(currentCityStateProvider.notifier).state = city;
                      },
                      currentCity: currentCity,
                    ),
                    barrierDismissible: false,
                    useSafeArea: true,
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(currentCity), SizedBox(width: 8), Icon(Icons.navigation_rounded)],
                ),
              );
            },
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
                    const SliverToBoxAdapter(child: WrappedFilters()),
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

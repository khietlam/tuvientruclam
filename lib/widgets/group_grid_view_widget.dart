import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../models/person.dart';
import 'cached_image_widget.dart';
import 'person_info_widget.dart';
import '../screens/slideshow_page.dart';
import '../services/image_preloader.dart';
import 'layout_constants.dart';

class GroupGridView extends StatefulWidget {
  final List<Person> persons;

  const GroupGridView({super.key, required this.persons});

  @override
  State<GroupGridView> createState() => _GroupGridViewState();
}

class _GroupGridViewState extends State<GroupGridView> {
  @override
  void initState() {
    super.initState();
    // Preload grid images for better performance
    ImagePreloader.preloadGridImages(widget.persons);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = MediaQuery.of(context).padding;

    // Calculate available space after padding and system UI
    final availableWidth =
        screenWidth -
        padding.left -
        padding.right -
        LayoutConstants.systemUIPadding;
    final availableHeight =
        screenHeight -
        padding.top -
        padding.bottom -
        LayoutConstants.controlsHeight;

    // Calculate item dimensions to fit columns and rows
    final itemWidth =
        (availableWidth / LayoutConstants.gridColumnCount) -
        LayoutConstants.gridSpacing;
    final itemHeight =
        (availableHeight / LayoutConstants.gridRowCount) -
        LayoutConstants.gridSpacing;

    return Scrollbar(
      thumbVisibility:
          widget.persons.length > LayoutConstants.scrollbarVisibilityThreshold,
      thickness: LayoutConstants.scrollbarThickness,
      radius: const Radius.circular(LayoutConstants.scrollbarRadius),
      child: GridView.count(
        crossAxisCount: LayoutConstants.gridColumnCount,
        padding: const EdgeInsets.all(LayoutConstants.gridPadding),
        childAspectRatio: itemWidth / itemHeight,
        mainAxisSpacing: LayoutConstants.gridSpacing,
        crossAxisSpacing: LayoutConstants.gridSpacing,
        children: widget.persons.map((p) {
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => Dialog(
                  backgroundColor: Colors.transparent,
                  child: SizedBox(
                    width:
                        MediaQuery.of(context).size.width *
                        LayoutConstants.dialogWidthRatio,
                    height:
                        MediaQuery.of(context).size.height *
                        LayoutConstants.dialogHeightRatio,
                    child: Card(
                      color: Colors.black87,
                      shadowColor: Colors.black,
                      surfaceTintColor: Colors.black,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          LayoutConstants.dialogBorderRadius,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Header with close button
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                  LayoutConstants.dialogBorderRadius,
                                ),
                                topRight: Radius.circular(
                                  LayoutConstants.dialogBorderRadius,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: AutoSizeText(
                                    "Thông tin chi tiết",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          ResponsiveBreakpoints.of(
                                            context,
                                          ).isMobile
                                          ? 18
                                          : 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Hero(
                                      tag: 'slideshow_button_${p.id}',
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.slideshow,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  SlideshowPage(persons: [p]),
                                            ),
                                          );
                                        },
                                        tooltip: 'Xem slideshow',
                                      ),
                                    ),
                                    Hero(
                                      tag: 'close_dialog_${p.id}',
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Content with image and person info
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  // Image display
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[900],
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                            LayoutConstants.dialogBorderRadius,
                                          ),
                                          topRight: Radius.circular(
                                            LayoutConstants.dialogBorderRadius,
                                          ),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          LayoutConstants.cardBorderRadius,
                                        ),
                                        child: CachedImageWidget(
                                          id: p.id,
                                          heroTag: 'grid_${p.id}',
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Person information
                                  Expanded(
                                    flex: 1,
                                    child: PersonInfoWidget(person: p),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            child: Card(
              color: Colors.black54,
              elevation: 8,
              shadowColor: Colors.black,
              surfaceTintColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  LayoutConstants.cardBorderRadius,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              LayoutConstants.cardBorderRadius,
                            ),
                            topRight: Radius.circular(
                              LayoutConstants.cardBorderRadius,
                            ),
                          ),
                        ),
                        child: CachedImageWidget(
                          id: p.id,
                          heroTag: 'grid_${p.id}',
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(
                              LayoutConstants.cardBorderRadius,
                            ),
                            bottomRight: Radius.circular(
                              LayoutConstants.cardBorderRadius,
                            ),
                          ),
                          color: Colors.grey[900],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              p.theDanh,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              minFontSize:
                                  ResponsiveBreakpoints.of(context).isMobile
                                  ? 6
                                  : 8,
                              maxFontSize:
                                  ResponsiveBreakpoints.of(context).isMobile
                                  ? 12
                                  : 16,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (p.phapDanh != null) ...[
                              const SizedBox(height: 2),
                              AutoSizeText(
                                "Pháp Danh: ${p.phapDanh!}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white70),
                                maxLines: 1,
                                minFontSize:
                                    ResponsiveBreakpoints.of(context).isMobile
                                    ? 6
                                    : 8,
                                maxFontSize:
                                    ResponsiveBreakpoints.of(context).isMobile
                                    ? 10
                                    : 12,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

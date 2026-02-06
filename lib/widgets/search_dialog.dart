import 'package:flutter/material.dart';
import '../models/person.dart';
import '../services/search_service.dart';
import '../widgets/app_dialogs.dart';

class SearchDialog extends StatefulWidget {
  final List<Person> persons;
  final Map<String, Person> personsMap;
  final Function(Person) onSingleResult;
  final Function(List<Person>) onMultipleResults;
  final VoidCallback? onReopenSearch;

  const SearchDialog({
    super.key,
    required this.persons,
    required this.personsMap,
    required this.onSingleResult,
    required this.onMultipleResults,
    this.onReopenSearch,
  });

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;
  int _currentOffset = 0;
  List<Person> _currentResults = [];
  int _totalResults = 0;
  bool _hasMoreResults = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _performSearch({bool isLoadMore = false}) async {
    final searchTerms = SearchService.parseSearchTerms(_controller.text);

    if (searchTerms.isEmpty) return;

    if (searchTerms.length > 6) {
      Navigator.pop(context);
      if (mounted) {
        showDialog(
          context: context,
          builder: (dialogContext) => AppDialogs.errorDialog(
            dialogContext,
            "Lỗi!",
            "Tối đa 6 từ khóa một lần tìm",
            "Đóng",
            () {
              Navigator.pop(dialogContext);
              widget.onReopenSearch?.call();
            },
          ),
        );
      }
      return;
    }

    setState(() {
      _isSearching = true;
      if (!isLoadMore) {
        _currentOffset = 0;
        _currentResults = [];
      }
    });

    try {
      // Get total count first
      final totalCount = await Future.microtask(() => 
        SearchService.getTotalResultCount(
          widget.persons,
          widget.personsMap,
          searchTerms,
        )
      );

      // Get paginated results
      final foundPersons = await SearchService.searchPersonsAsync(
        widget.persons,
        widget.personsMap,
        searchTerms,
        offset: _currentOffset,
      );

      setState(() {
        if (isLoadMore) {
          _currentResults.addAll(foundPersons);
        } else {
          _currentResults = foundPersons;
        }
        _totalResults = totalCount;
        _hasMoreResults = (_currentOffset + foundPersons.length) < totalCount;
        _isSearching = false;
      });

      if (!isLoadMore) {
        _handleSearchResults();
      }
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (dialogContext) => AppDialogs.errorDialog(
            dialogContext,
            "Lỗi!",
            "Lỗi tìm kiếm: ${e.toString()}",
            "Đóng",
            () => Navigator.pop(dialogContext),
          ),
        );
      }
    }
  }

  void _handleSearchResults() {
    if (_currentResults.isEmpty) {
      Navigator.pop(context);
      if (mounted) {
        showDialog(
          context: context,
          builder: (dialogContext) => AppDialogs.errorDialog(
            dialogContext,
            "Lỗi!",
            "Không tìm thấy kết quả!",
            "Đóng",
            () {
              Navigator.pop(dialogContext);
              widget.onReopenSearch?.call();
            },
          ),
        );
      }
    } else if (_currentResults.length == 1 && _totalResults == 1) {
      Navigator.pop(context);
      widget.onSingleResult(_currentResults.first);
    } else {
      Navigator.pop(context);
      widget.onMultipleResults(_currentResults);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black87,
      title: Text(
        "Tìm kiếm",
        style: AppTextStyles.getResponsiveStyle(context, 20, 28),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nhập ID, thê danh, pháp danh, ngày mất, hướng thổ hoặc nguyên quán:",
              style: AppTextStyles.getResponsiveStyle(context, 12, 20, Colors.white70),
            ),
            const SizedBox(height: 16),
            TextField(
              autofocus: true,
              controller: _controller,
              style: AppTextStyles.getResponsiveStyle(context, 12, 20, Colors.white),
              decoration: InputDecoration(
                hintText: "Ví dụ: 1023, Hữu Thành, Huu Thanh",
                hintStyle: AppTextStyles.getResponsiveStyle(context, 12, 20, Colors.white38),
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            Text(
              "Mẹo: Có thể tìm kiếm có dấu hoặc không dấu",
              style: AppTextStyles.getResponsiveBodyStyle(context),
            ),
            if (_totalResults > 0) ...[
              const SizedBox(height: 8),
              Text(
                "Tìm thấy $_totalResults kết quả${_totalResults > SearchService.defaultPageSize ? ' (hiển thị ${_currentResults.length})' : ''}",
                style: AppTextStyles.getResponsiveStyle(context, 10, 16, Colors.white70),
              ),
            ],
            if (_isSearching)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          style: AppButtonStyles.cancelButton(),
          child: Text(
            "Hủy",
            style: AppTextStyles.getResponsiveStyle(context, 12, 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        if (_hasMoreResults && !_isSearching)
          TextButton(
            style: AppButtonStyles.primaryButton(),
            onPressed: () {
              setState(() {
                _currentOffset += SearchService.defaultPageSize;
              });
              _performSearch(isLoadMore: true);
            },
            child: Text(
              "Tải thêm",
              style: AppTextStyles.getResponsiveStyle(context, 12, 20),
            ),
          ),
        TextButton(
          style: AppButtonStyles.primaryButton(),
          onPressed: _isSearching ? null : () => _performSearch(),
          child: Text(
            "Tìm",
            style: AppTextStyles.getResponsiveStyle(context, 12, 20),
          ),
        ),
      ],
    );
  }
}

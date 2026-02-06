import 'package:diacritic/diacritic.dart';
import '../models/person.dart';

class SearchService {
  static const int defaultResultLimit = 100;
  static const int defaultPageSize = 20;

  static List<Person> searchPersons(
    List<Person> persons,
    Map<String, Person> personsMap,
    List<String> searchTerms, {
    int? limit,
    int? offset,
  }) {
    if (searchTerms.isEmpty) return [];

    final resultLimit = limit ?? defaultResultLimit;
    final resultOffset = offset ?? 0;
    final foundPersons = <Person>{}; // Use Set for deduplication
    
    for (final term in searchTerms) {
      // Try to parse as ID first
      final id = int.tryParse(term);
      if (id != null && personsMap.containsKey(id.toString())) {
        foundPersons.add(personsMap[id.toString()]!);
        continue;
      }

      // Search in all text fields with diacritic handling
      final termNormalized = removeDiacritics(term.toLowerCase());
      
      for (final person in persons) {
        if (foundPersons.length >= resultLimit) break;
        if (foundPersons.contains(person)) continue;

        if (_matchesSearchTerm(person, term, termNormalized)) {
          foundPersons.add(person);
        }
      }
    }

    final resultList = foundPersons.toList();
    resultList.sort((a, b) => a.id.compareTo(b.id));
    
    // Apply pagination
    final startIndex = resultOffset;
    final endIndex = (startIndex + defaultPageSize < resultList.length) 
        ? startIndex + defaultPageSize 
        : resultList.length;
    
    if (startIndex >= resultList.length) return [];
    return resultList.sublist(startIndex, endIndex);
  }

  static bool _matchesSearchTerm(Person person, String term, String termNormalized) {
    // Check theDanh
    if (person.theDanh.isNotEmpty) {
      final theDanhNormalized = removeDiacritics(person.theDanh.toLowerCase());
      if (theDanhNormalized.contains(termNormalized) ||
          person.theDanh.toLowerCase().contains(term.toLowerCase())) {
        return true;
      }
    }

    // Check phapDanh
    if (person.phapDanh != null && person.phapDanh!.isNotEmpty) {
      final phapDanhNormalized = removeDiacritics(person.phapDanh!.toLowerCase());
      if (phapDanhNormalized.contains(termNormalized) ||
          person.phapDanh!.toLowerCase().contains(term.toLowerCase())) {
        return true;
      }
    }

    // Check ngayMat
    if (person.ngayMat != null && person.ngayMat!.isNotEmpty) {
      final ngayMatNormalized = removeDiacritics(person.ngayMat!.toLowerCase());
      if (ngayMatNormalized.contains(termNormalized) ||
          person.ngayMat!.toLowerCase().contains(term.toLowerCase())) {
        return true;
      }
    }

    // Check huongTho
    if (person.huongTho != null) {
      final huongThoStr = person.huongTho.toString();
      if (huongThoStr.contains(term)) {
        return true;
      }
    }

    // Check nguyenQuan
    if (person.nguyenQuan != null && person.nguyenQuan!.isNotEmpty) {
      final nguyenQuanNormalized = removeDiacritics(person.nguyenQuan!.toLowerCase());
      if (nguyenQuanNormalized.contains(termNormalized) ||
          person.nguyenQuan!.toLowerCase().contains(term.toLowerCase())) {
        return true;
      }
    }

    return false;
  }

  static List<String> parseSearchTerms(String input) {
    return input
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  // Async version for large datasets
  static Future<List<Person>> searchPersonsAsync(
    List<Person> persons,
    Map<String, Person> personsMap,
    List<String> searchTerms, {
    int? limit,
    int? offset,
  }) async {
    return await Future.microtask(() {
      return searchPersons(persons, personsMap, searchTerms, limit: limit, offset: offset);
    });
  }

  // Get total count for pagination info
  static int getTotalResultCount(
    List<Person> persons,
    Map<String, Person> personsMap,
    List<String> searchTerms, {
    int? limit,
  }) {
    if (searchTerms.isEmpty) return 0;

    final resultLimit = limit ?? defaultResultLimit;
    final foundPersons = <Person>{};
    
    for (final term in searchTerms) {
      // Try to parse as ID first
      final id = int.tryParse(term);
      if (id != null && personsMap.containsKey(id.toString())) {
        foundPersons.add(personsMap[id.toString()]!);
        continue;
      }

      // Search in all text fields with diacritic handling
      final termNormalized = removeDiacritics(term.toLowerCase());
      
      for (final person in persons) {
        if (foundPersons.length >= resultLimit) break;
        if (foundPersons.contains(person)) continue;

        if (_matchesSearchTerm(person, term, termNormalized)) {
          foundPersons.add(person);
        }
      }
    }

    return foundPersons.length;
  }
}

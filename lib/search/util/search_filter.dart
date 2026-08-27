import 'package:qbpanel/api/entity/response/search_result_response.dart';
import 'package:qbpanel/log/util/log_search.dart';
import 'package:qbpanel/search/entity/search_result_filter.dart';

int _sizeToBytes(double value, int unitIndex) {
  if (value <= 0) return 0;
  return (value * (1 << (unitIndex * 10))).round();
}

({int min, int max}) _normalizeSeedRange(int min, int max) {
  if (min > max && max > 0) {
    return (min: max, max: min);
  }
  return (min: min, max: max);
}

({int min, int max}) _normalizeSizeRange(
  double minValue,
  int minUnit,
  double maxValue,
  int maxUnit,
) {
  final min = _sizeToBytes(minValue, minUnit);
  final max = _sizeToBytes(maxValue, maxUnit);
  if (min > max && max > 0) {
    return (min: max, max: min);
  }
  return (min: min, max: max);
}

bool matchesSearchResultFilters({
  required SearchResultResponse result,
  required String resultFilterQuery,
  required SearchResultFilter filter,
}) {
  final terms = parseLogSearchTerms(resultFilterQuery);
  if (terms.isNotEmpty &&
      !logContainsAllTerms(result.fileName, terms)) {
    return false;
  }

  final seeds = _normalizeSeedRange(filter.minSeeders, filter.maxSeeders);
  if (seeds.min > 0 && result.nbSeeders < seeds.min) return false;
  if (seeds.max > 0 && result.nbSeeders > seeds.max) return false;

  final size = _normalizeSizeRange(
    filter.minSizeValue,
    filter.minSizeUnit,
    filter.maxSizeValue,
    filter.maxSizeUnit,
  );
  if (size.min > 0 && result.fileSize < size.min) return false;
  if (size.max > 0 && result.fileSize > size.max) return false;

  return true;
}

List<SearchResultResponse> filterSearchResults({
  required List<SearchResultResponse> results,
  required String resultFilterQuery,
  required SearchResultFilter filter,
}) {
  if (resultFilterQuery.trim().isEmpty && !filter.isActive) {
    return results;
  }

  return results
      .where(
        (result) => matchesSearchResultFilters(
          result: result,
          resultFilterQuery: resultFilterQuery,
          filter: filter,
        ),
      )
      .toList(growable: false);
}

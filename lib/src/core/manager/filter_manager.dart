part of ose;

/// Filter manager responds for adding and registering new filters.
///
/// By using of [add] method, new filters will be easily added to staged area.
/// Next, find time to register all filters from stage.
/// It gives you flexible way to prepare filters whenever you want.
class FilterManager {
  /// List of registered filters.
  List<Filter> _filters;

  /// Filters that are added but not registered yet.
  List<Filter> _stagedFilters;

  FilterManager() {
    _filters = <Filter>[];
    _stagedFilters = <Filter>[];
  }

  /// Add [Filter] to staged area.
  bool add(Filter filter) {
    bool isAdded = false;
    if (_filters.contains(filter)) {
      window.console.warn(
          "Filter #${filter.uuid} is already registered and will be omit");
    } else if (_stagedFilters.contains(filter)) {
      window.console.warn("Filter #{$filter.uuid} is already pushed in stage");
    } else {
      _stagedFilters.add(filter);
      isAdded = true;
    }
    return isAdded;
  }

  /// Remove [Filter] from stage zone.
  /// If [force] is [true],
  bool remove(bool force) {

  }

  List<Filter> get filters => _filters;

  List<Filter> get stagedFilters => _stagedFilters;
}

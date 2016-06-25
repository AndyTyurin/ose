part of ose;

abstract class FilterMixin {
  Filter _filter;

  Filter get filter => _filter;

  set filter(Filter filter) => _filter = filter;
}
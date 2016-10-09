part of ose;

class AttributeManager {
  static final Function eq = const ListEquality().equals;

  final Map<String, Attribute> prevAttributes;

  final Map<String, Attribute> nextAttributes;

  AttributeManager()
      : prevAttributes = <String, Attribute>{},
        nextAttributes = <String, Attribute>{};

  bool shouldBindAttribute(String name) {
    return prevAttributes[name] != nextAttributes[name];
  }

  void setActiveAttribute(String name, Attribute attribute) {
    prevAttributes[name] = nextAttributes[name];
    nextAttributes[name] = attribute;
  }
}

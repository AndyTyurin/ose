part of ose_utils;

/// Check is image dimensions is power of two.
bool isPowerOfTwo(ImageElement img) {
  return img.width % 2 == 0 && img.height % 2 == 0;
}

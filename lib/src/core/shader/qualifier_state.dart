part of ose;

enum QualifierState {
  INITIALIZED, // Value was initialized.
  CHANGED,     // Value has been changed.
  CACHED       // Value hasn't been changed.
}

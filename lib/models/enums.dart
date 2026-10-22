/// Review status for spaced repetition
enum ReviewStatus {
  /// Card has never been reviewed
  newCard,

  /// Card is being actively learned
  learning,

  /// Card is in the review cycle
  review,

  /// Card is considered mastered
  mastered,
}

/// Review rating given by the user
enum ReviewRating {
  /// Complete failure — reset interval
  again,

  /// Difficult recall — reduce interval growth
  hard,

  /// Correct with some effort — normal interval growth
  good,

  /// Effortless recall — accelerate interval growth
  easy,
}

/// Duplicate resolution strategy for CSV import
enum DuplicateResolution {
  /// Skip the duplicate row, keep existing card
  skip,

  /// Replace existing card content, preserve review history
  replace,

  /// Keep both the existing and imported card
  keepBoth,
}

/// Backwards compatibility alias for DuplicateResolution
typedef DuplicateStrategy = DuplicateResolution;

/// Import row validation status
enum ImportRowStatus {
  /// Row is valid and ready to import
  valid,

  /// Row has validation errors
  invalid,

  /// Row is a duplicate of an existing card
  duplicate,

  /// Row was skipped during import
  skipped,

  /// Row was successfully imported
  imported,

  /// Row replaced an existing card
  replaced,
}

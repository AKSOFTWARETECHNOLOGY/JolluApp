class WatchlistModel {
  int id;
  int wUserId;
  int wMovieId;
  // ignore: non_constant_identifier_names
  int season_id;
  int added;
  String wCreatedAt;
  String wUpdatedAt;

  WatchlistModel({
    this.id,
    this.wUserId,
    this.wMovieId,
    // ignore: non_constant_identifier_names
    this.season_id,
    this.added,
    this.wCreatedAt,
    this.wUpdatedAt

  });
}

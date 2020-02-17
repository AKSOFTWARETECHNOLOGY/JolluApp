import 'package:meta/meta.dart';

class EpisodesModel{
  EpisodesModel({
    @required this.id,
    @required this.title,
    // ignore: non_constant_identifier_names
    this.season_id,
    this.episodeNo,
    this.thumbnail,
    this.cover,
    this.description,
    this.released,
    this.language,
    this.type
  });
  final int id;
  final String title;
  // ignore: non_constant_identifier_names
  final int season_id;
  final int episodeNo;
  final String thumbnail;
  final String cover;
  final String description;
  final String released;
  final String language;
  final String type;
}

import 'package:meta/meta.dart';
import 'package:next_hour/model/seasons.dart';

class VideoDataModel {
  VideoDataModel({
    @required this.name,
    @required this.box,
    this.duration,
    this.cover,
    this.description,
    this.platforms,
    this.rating,
    this.screenshots,
    this.url,
    this.menuId,
    this.genre,
    this.maturityRating,
    this.genres,
    this.id,
    this.datatype,
    this.seasons,
    this.released
  });
  final int id;
  final List<String> genres;
  final String name;
  final String duration;
  final String box;
  final String cover;
  final String description;
  final List<String> platforms;
  final double rating;
  final String url;
  final List<String> screenshots;
  final int menuId;
  final List<String> genre;
  final String maturityRating;
  final String datatype;
  final List<Seasons> seasons;
  final String released;

  String getPlatforms() {
    String platformText = "";
    if (platforms.length > 1) {
      for (int i = 0; i < platforms.length; i++) {
        if (i == 0) {
          platformText = platforms[0];
        } else {
          platformText = platformText + " | " + platforms[i];
        }
      }
    } else if (platforms.length == 1) {
      platformText = platforms[0];
    }

    return platformText;
  }

}

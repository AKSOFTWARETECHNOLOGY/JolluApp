import 'package:meta/meta.dart';
import 'package:next_hour/model/seasons.dart';
class Wishlist {
  Wishlist({
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
}

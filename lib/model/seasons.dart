import 'package:meta/meta.dart';

class Seasons{
  Seasons({
    @required this.id,
    @required this.sTvSeriesId,
    this.sSeasonNo,
    this.thumbnail,
    this.cover,
    this.description,
    this.sActorId,
    this.language,
    this.type
  });

  final int id;
  final int sTvSeriesId;
  final int sSeasonNo;
  final String thumbnail;
  final String cover;
  final String description;
  final String sActorId;
  final String language;
  final String type;



}

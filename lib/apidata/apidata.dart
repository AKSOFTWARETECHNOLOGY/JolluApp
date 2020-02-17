
class APIData {

// Replace with your domain link
 //static const String domainLink = "https://mediacity.co.in/nexthourapp/public/";
 /*
https://jollu.app/public/api/menu
 */
 static const String domainLink = "https://jollu.app/public/";
 static const String domainApiLink = domainLink+"api/";

 // API Links
 static const String tokenApi = domainApiLink+"login";
 static const String userProfileApi = domainApiLink+"userProfile";
 static const String profileApi = domainApiLink+"profile";
 static const String registerApi = domainApiLink+"register";
 static const String allMovies = domainApiLink+"movie";
 static const String sliderApi = domainApiLink+"slider";
 static const String allDataApi = domainApiLink+"main";
 static const String movieTvApi = domainApiLink+"movietv";
 static const String topMenu = domainApiLink+"menu";
 static const String menuDataApi = domainApiLink+"MenuByCategory";
 static const String episodeDataApi = domainApiLink+"episodes/";
 static const String watchListApi = domainApiLink+"showwishlist";
 static const String removeWatchlistMovie = domainApiLink+"removemovie/";
 static const String removeWatchlistSeason = domainApiLink+"removeseason/";
 static const String addWatchlist = domainApiLink+"addwishlist";
 static const String checkWatchlistSeason = domainApiLink+"checkwishlist/S/";
 static const String checkWatchlistMovie = domainApiLink+"checkwishlist/M/";
 static const String homeDataApi = domainApiLink+"home";
 static const String faq = domainApiLink+"faq";
 static const String userProfileUpdate = domainApiLink+"profileupdate";
 static const String stripeProfileApi = domainApiLink+"stripeprofile";
 static const String stripeDetailApi = domainApiLink+"stripedetail";
 static const String clientNonceApi = domainApiLink+"bttoken";
 static const String sendPaymentNonceApi = domainApiLink+"btpayment";
 static const String stripeUpdateApi = domainApiLink+"stripeupdate/";
 static const String paypalUpdateApi = domainApiLink+"paypalupdate/";
 static const String sendPaystackDetails = domainApiLink+"paystack";

// URI Links

 static const String loginImageUri = domainLink+"images/login/";
 static const String logoImageUri = domainLink+"images/logo/";
 static const String landingPageImageUri = domainLink+"images/main-home/";
 static const String movieImageUri = domainLink+"images/movies/thumbnails/";
 static const String movieImageUriPosterMovie = domainLink+"images/movies/posters/";
 static const String tvImageUriPosterTv = domainLink+"images/tvseries/posters/";
 static const String tvImageUriTv = domainLink+"images/tvseries/thumbnails/";
 static const String profileImageUri = domainLink+"images/user/";
 static const String silderImageUri = domainLink+"images/home_slider/";
 static const String shareSeasonsUri = domainLink+"show/detail/";
 static const String shareMovieUri = domainLink+"movie/detail/";

/*
*           Replace android app ID with your app package name.
*           Replace IOS app ID with your IOS app ID.
*/

 static const String androidAppId = '';
 static const String iosAppId = '';
 static const String shareAndroidAppUrl = 'https://play.google.com/store/apps/details?id='+'$androidAppId';

// For Player
/*
 static const String tvSeriesPlayer = 'https://raghavsspl.com/nexthournew/public/watchseason/';
 static const String moviePlayer = 'https://raghavsspl.com/nexthournew/public/watchmovie/';
 static const String episodePlayer = 'https://raghavsspl.com/nexthournew/public/watchepisode/';
 static const String trailerPlayer = 'https://raghavsspl.com/nexthournew/public/movietrailer/';
*/

 static const String tvSeriesPlayer = 'https://jollu.app/public/watchseason/';
 static const String moviePlayer = 'https://jollu.app/public/watchmovie/';
 static const String episodePlayer = 'https://jollu.app/public/watchepisode/';
 static const String trailerPlayer = 'https://jollu.app/public/movietrailer/';


}
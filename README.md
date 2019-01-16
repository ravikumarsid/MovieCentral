README for MovieCentral App:

The MovieCentral App makes it easy to discover movies. It uses the TMDB API for fetching movie data. 
It has 4 main views:
Now Playing, Discover, Watchlist
1) Now Playing is a table view which fetches movies that are currently in theatres.
Tapping on the movie takes to the movie view screen
2) THe Discover view has options to apply filters and serach for movies.
The add filters button shows a screen with three ways to filter movies.
First is various sort parametrs such as revenue, votes, release date etc.
Second is by genre of the movie like Action, Comedy, Thriller.
Third option is to add people/actors/crew to the filter option to search for their movies. Multiple people could be added to search for movies they have worked together.
Tapping on the movie takes to the movie view screen
3) Movie view screen shows movie title, poster, overview text, genres and video trailer links if any. It also has a add to watchlist button which adds the current movie to the watchlist.
4) Watchlist is the screen that shows movies that have been added to the watchlist, they can be deleted by swiping the individual cell.

Before running the app, the API key must be changed in the TMDBConstants file. The TMDB API key can be acquired from  https://www.themoviedb.org/settings/api, by registering for free Account.

Dependencies are to be installed using Cocoapods, include the following dependcies in the podfile in order to run the app. The App relies on TMDB Swift wrapper extensively, so be sure to include TMDBSwift in the pod file.

pod 'Firebase/Auth'
pod 'Firebase/Core'

pod 'FirebaseUI'
pod 'FirebaseUI/Auth'

pod 'FirebaseUI/Google'
pod 'FirebaseUI/Facebook'
pod 'FirebaseUI/Phone'

pod 'Alamofire', '~> 4.7'
pod 'SwiftyJSON', '~> 4.0'
pod "TMDBSwift"
pod 'PureLayout'

After adding the pod names, from the folder where the pod file is present open terminal and run "pod update" to install all the dependencies. After that open project workspace to run the project.

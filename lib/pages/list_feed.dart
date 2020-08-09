import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// TODO 2: Import packages we added to our pubspec.yaml file.
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FeedList extends StatefulWidget {
  FeedList() : super();

  // Setting title for the action bar.
  final String title = '<CNN News\\> | Edition Feed';

  @override
  FeedListState createState() => FeedListState();
}

class FeedListState extends State<FeedList> {
  // Feed URL being used for the app. In this case is the Hacker News job feed.
  // TODO 3: Define RSS Feed URL
  static const FEED_URL = "https://www.rssmix.com/u/11885885/rss.xml";

  // TODO 4: Create a variable to hold our RSS feed data.
  RssFeed _feed; // RSS Feed Object
  // TODO 5: Create a place holder for our title.
  String _title; // Place holder for appbar title.

  // TODO 6: Setup our notification messages.
  // Notification Strings
  static const String loadingMessage = 'Loading Feed...';
  static const String feedLoadErrorMessage = 'Error Loading Feed.';
  static const String feedOpenErrorMessage = 'Error Opening Feed.';
  static const String placeholderImg = 'assets/images/no_image.png';

  // TODO 7: Create a GlobalKey object to hold our key for the refresh feature.
  // Key for the RefreshIndicator
  // See the documentation linked below for info on the RefreshIndicatorState
  // class and the GloablKey class.
  // https://api.flutter.dev/flutter/widgets/GlobalKey-class.html
  // https://api.flutter.dev/flutter/material/RefreshIndicatorState-class.html
  GlobalKey<RefreshIndicatorState> _refreshKey;

  // TODO 8: Create a method to update the user about data changes.
  // Method to change the title as a way to inform the user what is going on
  // while retrieving the RSS data.
  updateTitle(title) {
    setState(() {
      _title = title;
    });
  }

  // TODO 9: Create a method to reload the RSS feed data when the refresh feature is used.
  // Method to help refresh the RSS data.
  updateFeed(feed) {
    setState(() {
      _feed = feed;
    });
  }

  // TODO 10: Create a method to navigate to the selected RSS item.
  // Method to navigate to the URL of a RSS feed item.
  Future<void> openFeed(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: false,
      );
      return;
    }
    updateTitle(feedOpenErrorMessage);
  }

  // TODO 11: Create a method to load the RSS data.
  // Method to load the RSS data.
  load() async {
    updateTitle(loadingMessage);
    loadFeed().then((result) {
      if (null == result || result.toString().isEmpty) {
        // Notify user of error.
        updateTitle(feedLoadErrorMessage);
        return;
      }
      // If there is no error, load the RSS data into the _feed object.

      updateFeed(result);

      // Reset the title.
      updateTitle("<EPA\\> | NewsReleases");
    });
  }

  // TODO 12: Create a method to grab the RSS data from the provided URL.
  // Method to get the RSS data from the provided URL in the FEED_URL variable.
  Future<RssFeed> loadFeed() async {
    try {
      final client = http.Client();
      final response = await client.get(FEED_URL);
      return RssFeed.parse(response.body);
    } catch (e) {
      // handle any exceptions here
    }

    return null;
  }

  // TODO 13: Override the initState() method and setup the _refreshKey variable, update the title, and call the load() method.
  // When the app is initialized, we setup our GlobalKey, set our title, and
  // call the load() method which loads the RSS feed and UI.
  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    updateTitle(widget.title);
    load();
  }

  // TODO 14: Create a method to check if the RSS feed is empty.
  // Method to check if the RSS feed is empty.
  isFeedEmpty() {
    return null == _feed || null == _feed.items;
  }

  // TODO 15: Create method to load the UI and RSS data.
  // Method for the pull to refresh indicator and the actual ListView UI/Data.
  body() {
    return isFeedEmpty()
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            key: _refreshKey,
            child: list(),
            onRefresh: () => load(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: body(),
    );
  }

  // TODO 16: Create the UI for the ListView and plug in the retrieved RSS data.
  // ==================== ListView Components ====================

  // ListView
  // Consists of two main widgets. A Container Widget displaying info about the
  // RSS feed and the ListView containing the RSS Data. Both contained in a
  // Column Widget.
  list() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Container displaying RSS feed info.

          // ListView that displays the RSS data.
          Expanded(
            flex: 3,
            child: Container(
              margin: new EdgeInsets.only(top: 35.0),
              child: ListView.builder(
                padding: EdgeInsets.all(5.0),
                itemCount: _feed.items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = _feed.items[index];

                  var date = item.pubDate;

                  if (item.pubDate == null) {
                    var now = new DateTime.now();
                    date = now.toString();
                  }

                  var itemImgArray = [];
                  if (item.media.group != null) {
                    for (var imgUrl in item.media.group.contents) {
                      itemImgArray.add(imgUrl.url);
                    }
                  } else {
                    itemImgArray.add(placeholderImg);
                  }

                  return Container(
                    margin: EdgeInsets.only(
                      bottom: 3.0,
                    ),
                    child: Card(
                      child: ListTile(
                        title: title(item.title),
                        subtitle: Column(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(item.link,
                                    style: TextStyle(color: Colors.black)),
                                Text(date,
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ],
                        ),
                        leading: thumbnail(itemImgArray[0]),
                        trailing: rightIcon(),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () => openFeed(item.link),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ]);
  }

  // Method that returns the Text Widget for the title of our RSS data.
  title(title) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.black),
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
    );
  }

  thumbnail(imageUrl) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: CachedNetworkImage(
        errorWidget: (context, url, error) => Image.asset(
          placeholderImg,
          height: 50,
          width: 75,
        ),
        imageUrl: imageUrl,
        alignment: Alignment.center,
        fit: BoxFit.fill,
      ),
    );
  }

  // Method that returns Icon Widget.
  rightIcon() {
    return Icon(
      Icons.keyboard_arrow_right,
      color: Colors.black,
      size: 15.0,
    );
  }
}

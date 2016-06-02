var TweetActions = require('../actions/TweetActions');

var TweetApi = {
  fetchTweets: function () {
    $.ajax({
      url: "/api/tweets",
      method: "GET",
      dataType: 'json',
      success: function (tweets) {
        TweetActions.receiveTweets(tweets);
      },
      error: function () {
        console.log('error, couldn\'t fetch tweets');
      }
    });
  },

  createTweet: function (tweet, callback) {
    $.ajax({
      url: "/api/tweets",
      method: "POST",
      dataType: "json",
      data: {tweet: tweet},
      success: function() {
        callback();
      }
    });
  },



};

module.exports = TweetApi;

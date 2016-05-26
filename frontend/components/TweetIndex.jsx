var React = require("react");
var TweetStore = require("../stores/TweetStore.js");
var TweetApi = require('../utils/TweetApi');

var TweetIndex = React.createClass({

  getInitialState: function () {
    return { tweets: [] };
  },

  componentDidMount: function () {
    this.listener = TweetStore.addListener(this.updateTweets);
    TweetApi.fetchTweets();
  },

  componentWillUnmount: function () {
    this.listener.remove();
  },

  updateTweets: function () {
    this.setState({ tweets: TweetStore.all() });
  },

  render: function () {

    var tweets = this.state.tweets.map(function (tweet) {
      return (
        <article key={ tweet.id }>
          <p>{ tweet.body }</p>
        </article>
      );
    });


    return (
      <section className="tweets">
        <h2>All the Tweets!!!!</h2>
        { tweets }
      </section>
    );
  }

});

module.exports = TweetIndex;

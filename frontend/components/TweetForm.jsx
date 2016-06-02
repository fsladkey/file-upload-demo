var React = require("react");
var Link = require("react-router").Link;

var TweetStore = require("../stores/TweetStore.js");
var TweetApi = require('../utils/TweetApi');

var TweetForm = React.createClass({
  contextTypes: {
    router: React.PropTypes.object.isRequired
  },

  getInitialState: function () {
    return({
      body: ""
    });
  },

  updateBody: function (e) {
    this.setState({
      body: e.target.value
    });
  },

  handleSubmit: function (e) {
    TweetApi.createTweet(this.state, this.goBack);
  },

  goBack: function () {
    this.context.router.push("/");
  },

  render: function () {

    return(
      <div>
        Tweet form!

        <Link to="/">Back to Tweets</Link>
        <input type="text" onChange={this.updateBody}></input>
        <button onClick={this.handleSubmit}>Make Tweet!</button>
      </div>);
  }
});

module.exports = TweetForm;

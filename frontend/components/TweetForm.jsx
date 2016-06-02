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
      body: "",
      imageFile: null,
      imageUrl: null
    });
  },

  updateBody: function (e) {
    this.setState({
      body: e.target.value
    });
  },

  updateFile: function (e) {
    var file = e.currentTarget.files[0];
    var fileReader = new FileReader();
    fileReader.onloadend = function () {
      this.setState({ imageFile: file, imageUrl: fileReader.result });
    }.bind(this);

    if (file) {
      fileReader.readAsDataURL(file);
    }
  },

  handleSubmit: function (e) {
    var formData = new FormData();
    formData.append("tweet[body]", this.state.body);
    formData.append("tweet[image]", this.state.imageFile);
    TweetApi.createTweet(formData, this.goBack);
  },

  goBack: function () {
    this.context.router.push("/");
  },

  render: function () {

    return(
      <div>
        Tweet form!

        <Link to="/">Back to Tweets</Link>
        <input type="text" onChange={this.updateBody}/>
        <input type="file" onChange={this.updateFile}/>
        <button onClick={this.handleSubmit}>Make Tweet!</button>
        <img src={this.state.imageUrl}/>
      </div>);
  }
});

module.exports = TweetForm;

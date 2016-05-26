var React = require("react");
var ReactDOM = require("react-dom");

var TweetIndex = require("./components/TweetIndex.jsx");

document.addEventListener('DOMContentLoaded', function () {
  ReactDOM.render(<TweetIndex />, document.getElementById("root"));
});

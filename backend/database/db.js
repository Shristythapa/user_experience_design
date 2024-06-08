const mongoose = require("mongoose");

//importing any necessary packages
//function (Any)
const connectDB = () => {
  //moongoose connect
  mongoose.connect("mongodb://127.0.0.1:27017/momo_rating_app").then(() => {
    console.log("Connected to Database");
  });
};
//export
module.exports = connectDB;

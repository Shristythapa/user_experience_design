const mongoose = require("mongoose");
const User = require("./userModel");

const preferenceSchema = mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: User,
    required: true,
  },
  cookType: {
    type: [String], 
  },

  filling: {
    type: [String], // Allow filling to be an array of strings
  },
});

//"users" = mongodb collection name
const Preference = mongoose.model("preference", preferenceSchema);
module.exports = Preference;

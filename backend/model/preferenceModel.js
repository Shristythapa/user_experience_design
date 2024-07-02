const mongoose = require("mongoose");
const User = require("./userModel");

const preferenceSchema = mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: User,
    required: true,
  },
  cookType: {
    type: String,
  },
  fillingType: {
    type: String,
  },
  filling: {
    type: String,
  },
});

//"users" = mongodb collection name
const Preference = mongoose.model("preference", preferenceSchema);
module.exports = Preference;

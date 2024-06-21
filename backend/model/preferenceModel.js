const mongoose = require("mongoose");
const User = require("./userModel");

const preferenceSchema = mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: User,
    required: true,
  },

  sizeOfMomo: {
    type: Number,
  },

  fillings: {
    type: Number,
  },
  aesthetics: {
    type: Number,
  },
  sauceVarity: {
    type: Number,
  },
  spiceLevel: {
    type: Number,
  },
});

//"users" = mongodb collection name
const Preference = mongoose.model("preference", preferenceSchema);
module.exports = Preference;

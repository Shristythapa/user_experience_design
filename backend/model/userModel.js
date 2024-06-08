const mongoose = require("mongoose");

const userSchema = mongoose.Schema({
  userName: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
  },
  password: {
    type: String,
    required: true,
  },
  profileImageUrl: {
    type: String,
    required: true,
    trim: true,
  },
});

//"users" = mongodb collection name
const User = mongoose.model("users", userSchema);
module.exports = User;

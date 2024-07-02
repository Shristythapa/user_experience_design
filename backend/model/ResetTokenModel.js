// models/ResetToken.js
const mongoose = require("mongoose");

const resetTokenSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Users",
    required: true,
  },
  token: {
    type: String,
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
    expires: 3600,
  },
});

module.exports = mongoose.model("ResetToken", resetTokenSchema);

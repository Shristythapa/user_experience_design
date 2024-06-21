const mongoose = require("mongoose");
const User = require("./userModel");
const Momo = require("./momoModel");

const savedMomoSchema = mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: User,
    required: true,
  },
  momoId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: Momo,
    required: true,
  },
});

module.exports = mongoose.model("SavedMomo", savedMomoSchema);

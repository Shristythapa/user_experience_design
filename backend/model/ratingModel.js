const mongoose = require("mongoose");
const Momo = require("./momoModel");

const ratingSchema = mongoose.Schema({
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
  overallRating: {
    type: Number,
    required: true,
  },
  fillingAmount: {
    type: Number,
    required: true,
  },
  sizeOfMomo: {
    type: Number,
    required: true,
  },
  sauceVariety: {
    type: Number,
    required: true,
  },
  aesthectic:{
    type: Number,
    required: true
  },
  spiceLevel:{
    type: Number,
    required: true
  },
  priceValue:{
    type: Number,
    required: true
  },
  review:{
    type: String,
    required: true
  }
});

const Rating = mongoose.model("rating", ratingSchema);

module.exports = Rating;
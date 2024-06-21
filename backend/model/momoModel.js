const mongoose = require("mongoose");
const Rating = require("./ratingModel");
const User = require("./userModel");

const momoSchema = mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: User,
    required: true,
  },
  momoName: {
    type: String,
    required: true,
  },
  momoImage: {
    type: String,
    required: true,
  },
  momoPrice: {
    type: Number,
    required: true,
  },
  cookType: {
    type: String,
    required: true,
  },
  fillingType: {
    type: String,
    required: true,
  },
  location: {
    type: String,
    required: true,
  },
  shop: {
    type: String,
    required: true,
  },
  overallRating: {
    type: Number,
  },
  reviews: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: Rating,
    },
  ],
});

const Momo = mongoose.model("momo", momoSchema);
module.exports = Momo;

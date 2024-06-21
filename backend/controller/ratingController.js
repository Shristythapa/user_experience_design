const Momo = require("../model/momoModel");
const Rating = require("../model/ratingModel");
const User = require("../model/userModel");

const addRating = async (req, res) => {
  console.log(req.body);

  const {
    userId,
    momoId,
    overallRating,
    fillingAmount,
    sizeOfMomo,
    sauceVariety,
    aesthectic,
    spiceLevel,
    priceValue,
    review,
  } = req.body;

  if (!userId || !momoId) {
    return res.json({
      success: false,
      message: "Enter all feilds",
    });
  }

  const existingUser = await User.findOne({ userId: userId });

  if (!existingUser) {
    return res.status(400).json("User doesn't exist.");
  }

  try {
    console.log("savig review");
    const newRating = new Rating({
      userId: userId,
      overallRating: overallRating,
      fillingAmount: fillingAmount,
      sizeOfMomo: sizeOfMomo,
      sauceVariety: sauceVariety,
      aesthectic: aesthectic,
      spiceLevel: spiceLevel,
      priceValue: priceValue,
      review: review,
    });

    const savedReview = await newRating.save();
    console.log("review saved sucessfully");

    const momo = await Momo.findByIdAndUpdate(
      momoId,
      {
        $push: { reviews: savedReview._id },
      },
      { new: true }
    );

    // Calculate new average overall rating
    const ratings = await Rating.find({ momoId: momoId });
    const totalRatings = ratings.length;
    const sumRatings = ratings.reduce(
      (acc, rating) => acc + rating.overallRating,
      0
    );
    const avgRating = sumRatings / totalRatings;

    momo.overallRating = avgRating;
    await momo.save();

    res.status(200).json({
      success: true,
      message: "Preferences added sucessfully",
      data: newRating,
    });
  } catch (e) {
    console.log(e);
    res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

module.exports = {
  addRating,
};

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
    return res.status(400).json({
      success: false,
      message: "Enter all feilds",
    });
  }

  const existingUser = await User.findOne({ _id: userId });

  if (!existingUser) {
    return res.status(400).json({
      message: "User doesn't exist.",
      success: false,
    });
  }

  try {
    const momofi = await Momo.findById(momoId).populate("reviews");
    if (!momofi) {
      return res.status(404).json({
        message: "Momo not found.",
        success: false,
      });
    }

    // Check if the user has already added a review for the same momo
    const existingRating = momofi.reviews.find(
      (review) => review.userId.toString() === userId
    );
    if (existingRating) {
      return res.status(400).json({
        success: false,
        message: "Review for this momo already added.",
      });
    }
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
    const ratings = await Rating.find({ _id: { $in: momo.reviews } });
    console.log(ratings);
    const totalRatings = ratings.length;
    if (totalRatings > 0) {
      const sumRatings = ratings.reduce(
        (acc, rating) => acc + rating.overallRating,
        0
      );
      const avgRating = sumRatings / totalRatings;

      momo.overallRating = avgRating;
      await momo.save();
    } else {
      momo.overallRating = overallRating;
      await momo.save();
    }

    res.status(200).json({
      success: true,
      message: "Rating added sucessfully",
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

const deleteRating = async (req, res) => {
  const { id } = req.params; // Assuming ratingId is passed as a parameter
 console.log(id);
  try {
    // Find the rating by ID
    const rating = await Rating.findById(id);

    if (!rating) {
      return res.status(404).json({
        success: false,
        message: "Rating not found",
      });
    }

    // Remove the rating from the Momo document's reviews array
    const momo = await Momo.findOneAndUpdate(
      { reviews: id },
      { $pull: { reviews: id } },
      { new: true }
    );

    if (!momo) {
      return res.status(404).json({
        success: false,
        message: "Momo not found",
      });
    }

    // Delete the rating
    await Rating.findByIdAndDelete(id);

    // Recalculate the average overall rating for the Momo
    const ratings = await Rating.find({ _id: { $in: momo.reviews } });
    const totalRatings = ratings.length;
    const sumRatings = ratings.reduce(
      (acc, rating) => acc + rating.overallRating,
      0
    );
    const avgRating = totalRatings > 0 ? sumRatings / totalRatings : 0;

    momo.overallRating = avgRating;
    await momo.save();

    res.status(200).json({
      success: true,
      message: "Rating deleted successfully",
    });
  } catch (error) {
    console.error("Error deleting rating:", error);
    res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};


module.exports = {
  addRating,
  deleteRating,
};

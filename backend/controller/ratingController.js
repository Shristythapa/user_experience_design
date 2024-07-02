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

// const getRatingsByUser = async (req, res) => {
//   const { id } = req.params; // Assuming userId is passed as a parameter

//   try {
//     const userRatings = await Rating.find({ userId: id }).populate(
//       "momoId"
//     ); // Assuming 'momoId' is the reference field

//     if (!userRatings) {
//       return res.status(404).json({
//         success: false,
//         message: "No ratings found for the user.",
//       });
//     }

//     res.status(200).json({
//       success: true,
//       message: "User ratings retrieved successfully.",
//       data: userRatings,
//     });
//   } catch (error) {
//     console.error(error);
//     res.status(500).json({
//       success: false,
//       message: "Server error.",
//     });
//   }
// };

const getRatingsByUser = async (req, res) => {
  const { id } = req.params; // Assuming userId is passed as a parameter
  try {
    const userRatings = await Rating.find({ userId: id })
      .populate({
        path: "momo", // https://stackoverflow.com/questions/74441286/how-to-load-referenced-document-in-mongoose
        model: "momo",
        select:
          "momoName momoImage momoPrice cookType fillingType location shop overallRating",
      })
      .exec();
    if (userRatings != null) {
      return res.status(200).json({
        message: "Ratigns",
        ratings: userRatings,
        success: true,
      });
    } else {
      return res.status(400).json({
        message: "ratings not found",

        success: false,
      });
    }
  } catch (error) {
    return res.status(400).json({
      message: error,
      success: false,
    });
  }
};
const getRatingById = async (req, res) => {
  const { id } = req.params; // Assuming ratingId is passed as a parameter
  try {
    const rating = await Rating.findById(id)
      .populate({
        path: "momo", // Ensure you have a reference to 'momo' in your Rating model
        model: "momo",
        select:
          "momoName momoImage momoPrice cookType fillingType location shop overallRating",
      })
      .exec();

    if (rating) {
      return res.status(200).json({
        message: "Rating found",
        rating: rating,
        success: true,
      });
    } else {
      return res.status(400).json({
        message: "Rating not found",
        success: false,
      });
    }
  } catch (error) {
    return res.status(500).json({
      message: error.message,
      success: false,
    });
  }
};

module.exports = {
  addRating,
  getRatingsByUser,
  getRatingById,
  deleteRating
};

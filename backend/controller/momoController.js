const Momo = require("../model/momoModel");
const User = require("../model/userModel");
const cloudinary = require("cloudinary");
const Rating = require("../model/ratingModel");
const SavedMomo = require("../model/saveMomoModel");
const addMomo = async (req, res) => {
  console.log(req.body);
  const {
    userId,
    momoName,
    momoPrice,
    cookType,
    fillingType,
    location,
    shop,
    overallRating,
    fillingAmount,
    sizeOfMomo,
    sauceVariety,
    aesthetic,
    spiceLevel,
    priceValue,
    review,
  } = req.body;

  const { momoImage } = req.files;

  if (
    (!userId,
    !momoName,
    !momoImage,
    !momoPrice,
    !cookType,
    !fillingType,
    !location,
    !shop)
  ) {
    console.log("not all fields found");
    return res.json({
      success: false,
      message: "Enter all fields",
    });
  }

  let newMomo;

  try {
    // Step 5: upload images to Cloudinary
    const uploadedImage = await cloudinary.v2.uploader.upload(momoImage.path, {
      folder: "momo",
      crop: "scale",
    });

    newMomo = new Momo({
      userId: userId,
      momoName: momoName,
      momoImage: uploadedImage.secure_url,
      momoPrice: momoPrice,
      cookType: cookType,
      fillingType: fillingType,
      location: location,
      shop: shop,
      overallRating: 0,
    });

    await newMomo.save();
    console.log("Momo saved");
    console.log(newMomo);

    const newRating = new Rating({
      userId: userId,
      overallRating: overallRating,
      fillingAmount: fillingAmount,
      sizeOfMomo: sizeOfMomo,
      sauceVariety: sauceVariety,
      aesthectic: aesthetic,
      spiceLevel: spiceLevel,
      priceValue: priceValue,
      review: review,
      momoId: newMomo._id, // assuming momoId is part of Rating schema
    });

    console.log(newRating);
    const savedReview = await newRating.save();
    console.log("Review saved successfully");

    const momo = await Momo.findByIdAndUpdate(
      newMomo._id,
      {
        $push: { reviews: savedReview },
      },
      { new: true }
    );
    console.log(momo);

    // Calculate new average overall rating
    const ratings = await Rating.find({ momoId: newMomo._id });
    const totalRatings = ratings.length;

    if (totalRatings > 0) {
      const sumRatings = ratings.reduce(
        (acc, rating) => acc + rating.overallRating,
        0
      );
      const avgRating = sumRatings / totalRatings;

      momo.overallRating = avgRating;
    } else {
      momo.overallRating = overallRating;
    }
    await momo.save();
    console.log("sum aratting ");

    res.status(200).json({
      success: true,
      message: "Momo and review added successfully",
      data: {
        momo: newMomo,
        review: savedReview,
      },
    });
  } catch (e) {
    console.log(e);
    res.json({
      success: false,
      message: "Server Error",
    });
  }
};

const getMomoById = async (req, res) => {
  try {
    const { userId, momoId } = req.query;

    console.log("get momo by id..");
    // Find the momo by ID and populate reviews
    const momo = await Momo.findById(momoId).populate("reviews").exec();
    if (!momo) {
      return res.status(404).json({
        success: false,
        message: "Momo not found",
      });
    }

    // Check if the momo is saved by the user
    const savedMomo = await SavedMomo.findOne({ userId, momoId });

    res.status(200).json({
      success: true,
      message: "Get momo by id successful",
      data: {
        momo: momo,
        momoSaved: !!savedMomo, // momoSaved is true if savedMomo exists, false otherwise
      },
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const updateMomo = async (req, res) => {
  console.log(req.body);

  const {
    userId,
    momoName,
    momoImage,
    momoPrice,
    cookType,
    fillingType,
    location,
  } = req.body;

  if (
    (!userId,
    !momoName,
    !momoImage,
    !momoPrice,
    !cookType,
    !fillingType,
    !location)
  ) {
    return res.json({
      success: false,
      message: "Enter all feilds",
    });
  }
  const existingUser = await User.findOne({ email: email });
  if (!existingUser) {
    return res.status(400).json("User Doesn't exists.");
  }

  //destructure id from url
  const id = req.params.id;

  try {
    const updatedMomo = new Momo({
      userId: userId,
      momoName: momoName,
      momoImage: momoImage,
      momoPrice: momoPrice,
      cookType: cookType,
      fillingType: fillingType,
      location: location,
    });

    await Products.findByIdAndUpdate(id, updatedMomo);
    res.status(200).json({
      success: true,
      message: "Momo Updated Sucessfully",
      data: updateMomo,
    });
  } catch (e) {
    console.log(e);
    res.status(500).json({
      success: false,
      message: "Server Error",
    });
  }
};
const getRatingsByUser = async (req, res) => {
  const { id } = req.params; // Assuming userId is passed as a parameter
  try {
    const momos = await Momo.find({ userId: id }).populate({
      path: "reviews",
      model: "rating",
      select:
        "overallRating fillingAmount sizeOfMomo sauceVariety aesthectic spiceLevel priceValue review",
    });

    if (momos.length > 0) {
      return res.status(200).json({
        message: "Ratings found",
        ratings: momos.map((momo) => ({
          momoId: momo._id,
          momoName: momo.momoName,
          momoImage: momo.momoImage,
          ratings: momo.reviews, // Array of ratings associated with this momo
        })),
        success: true,
      });
    } else {
      return res.status(404).json({
        message: "Ratings not found for the user",
        success: false,
      });
    }
  } catch (error) {
    console.error("Error fetching ratings:", error);
    return res.status(500).json({
      message: "Server error",
      success: false,
    });
  }
};

const getRatingById = async (req, res) => {
  const { id } = req.params; 

  try {
    const momo = await Momo.findOne({ reviews: id }).populate({
      path: "reviews",
      match: { _id: id }, 
      model: "rating",
      select:
        "overallRating fillingAmount sizeOfMomo sauceVariety aesthectic spiceLevel priceValue review",
    });

    if (momo && momo.reviews.length > 0) {
      const rating = momo.reviews[0];

      return res.status(200).json({
        message: "Rating found",
        rating: rating,
        momo: {
          momoId: momo._id,
          momoName: momo.momoName,
          momoImage: momo.momoImage,
          momoPrice: momo.momoPrice,
          cookType: momo.cookType,
          fillingType: momo.fillingType,
          location: momo.location,
          shop: momo.shop,
          overallRating: momo.overallRating,
        },
        success: true,
      });
    } else {
      return res.status(404).json({
        message: "Rating not found",
        success: false,
      });
    }
  } catch (error) {
    console.error("Error fetching rating:", error);
    return res.status(500).json({
      message: "Server error",
      success: false,
    });
  }
};

const getAllMomo = async (req, res) => {
  try {
    const listOfMomo = await Momo.find();
    res.json({
      success: true,
      momos: listOfMomo,
      message: "Momos featched sucessfully",
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
  addMomo,
  updateMomo,
  getAllMomo,
  getMomoById,
  getRatingsByUser,
  getRatingById,
};

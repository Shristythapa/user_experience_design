const Momo = require("../model/momoModel");
const User = require("../model/userModel");
const cloudinary = require("cloudinary");
const Rating = require("../model/ratingModel");
const SavedMomo = require("../model/saveMomoModel");
const Preference = require("../model/preferenceModel");

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
    (!userId, !momoImage, !momoPrice, !cookType, !fillingType, !location, !shop)
  ) {
    console.log("not all fields found");
    return res.status(200).json({
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
    // const momo = await Momo.findById(momoId).populate("reviews").exec();
    // if (!momo) {
    //   return res.status(404).json({
    //     success: false,
    //     message: "Momo not found",
    //   });
    // }

    const momo = await Momo.findById(momoId)
      .populate({
        path: "reviews",
        populate: {
          path: "userId",
          select: "userName profileImageUrl",
        },
      })
      .exec();

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
    // Fetch all momos and populate their reviews
    const momos = await Momo.find().populate({
      path: "reviews",
      model: "rating",
      select:
        "userId overallRating fillingAmount sizeOfMomo sauceVariety aesthectic spiceLevel priceValue review",
    });

    if (momos.length > 0) {
      // Filter and populate ratings that match the userId
      const filteredRatings = momos
        .map((momo) => ({
          momoId: momo._id,
          shop: momo.shop,
          location: momo.location,
          fillingType: momo.fillingType,
          cookType: momo.cookType,
          momoImage: momo.momoImage,
          ratings: momo.reviews.filter(
            (review) => review.userId.toString() === id
          ),
        }))
        .filter((momo) => momo.ratings.length > 0); // Remove momos with empty ratings

      if (filteredRatings.length > 0) {
        return res.status(200).json({
          message: "Ratings found",
          ratings: filteredRatings,
          success: true,
        });
      } else {
        return res.status(404).json({
          message: "No ratings found for the user",
          ratings: [],
          success: false,
        });
      }
    } else {
      return res.status(404).json({
        message: "No momos found",
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
        "userId overallRating fillingAmount sizeOfMomo sauceVariety aesthectic spiceLevel priceValue review",
    });

    if (momo) {
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

const searchMomo = async (req, res) => {
  try {
    console.log(req.body);
    const { query, filling, cook } = req.body;

    // Build the search criteria
    let searchCriteria = [];

    // Add location or shop to search criteria
    if (query) {
      console.log("query added to search criteria");
      searchCriteria.push(
        { location: { $regex: query, $options: "i" } },
        { shop: { $regex: query, $options: "i" } }
      );
    }

    // Add fillingType to search criteria if filling is an array
    if (
      filling !== null &&
      (Array.isArray(filling) ? filling.length > 0 : true)
    ) {
      console.log("filling added to search criteria");
      searchCriteria.push({ fillingType: { $in: filling } });
    }

    // Add cookType to search criteria if cook is an array
    if (cook !== null && (Array.isArray(cook) ? cook.length > 0 : true)) {
      console.log("cook type added to search criteria");
      searchCriteria.push({ cookType: { $in: cook } });
    }

    console.log("Search Criteria: ", searchCriteria);

    // Use $or to match any criteria
    const finalCriteria =
      searchCriteria.length > 0 ? { $or: searchCriteria } : {};

    // Search in the database
    const momos = await Momo.find(finalCriteria)
      .populate("reviews")
      .populate("userId");

    console.log("Momos Found: ", momos);

    // Return the result
    res.status(200).json({
      success: true,
      message: "search result",
      data: momos,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "An error occurred while searching for momos",
      error: error.message,
    });
  }
};

const recommendMomo = async (req, res) => {
  const { id } = req.params;

  try {
    // Fetch user preferences
    const preferences = await Preference.findOne({ userId: id });

    if (!preferences) {
      console.log("No preferences found for user");
      return res.status(404).json({
        success: false,
        message: "No preferences found for user",
      });
    }

    console.log(preferences);

    // Fetch all MoMos
    const allMoMos = await Momo.find();

    // Helper function to extract value from string with curly braces
    const extractValue = (str) => str.replace(/[{}]/g, "");

    const sortedMoMos = allMoMos.sort((a, b) => {
      console.log(extractValue(a.fillingType));
      const aFilling = extractValue(a.fillingType);
      const bFilling = extractValue(b.fillingType);
      const aCookType = extractValue(a.cookType);
      const bCookType = extractValue(b.cookType);

      console.log("Comparing:", aFilling, bFilling, aCookType, bCookType);

      const aFillingMatches = preferences.filling.includes(aFilling);
      const bFillingMatches = preferences.filling.includes(bFilling);
      const aCookTypeMatches = preferences.cookType.includes(aCookType);
      const bCookTypeMatches = preferences.cookType.includes(bCookType);

      // Give higher priority if both filling and cook type matches
      if (
        aFillingMatches &&
        aCookTypeMatches &&
        !bFillingMatches &&
        !bCookTypeMatches
      )
        return -1;
      if (
        !aFillingMatches &&
        !aCookTypeMatches &&
        bFillingMatches &&
        bCookTypeMatches
      )
        return 1;

      // Sort by filling type first
      if (aFillingMatches && !bFillingMatches) return -1;
      if (!aFillingMatches && bFillingMatches) return 1;

      // If both or neither match the filling type, sort by cook type
      if (aCookTypeMatches && !bCookTypeMatches) return -1;
      if (!aCookTypeMatches && bCookTypeMatches) return 1;

      return 0;
    });
    console.log(sortedMoMos);

    return res.status(200).json({
      success: true,
      momo: sortedMoMos,
      message: "Recommendation retrieved",
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

const getPopularMomo = async (req, res) => {
  try {
    // Fetch all MoMos
    const listOfMomo = await Momo.find();

    // Sort MoMos based on the number of reviews (descending order)
    listOfMomo.sort((a, b) => b.reviews.length - a.reviews.length);

    res.json({
      success: true,
      momos: listOfMomo,
      message: "Momos fetched successfully and sorted by number of reviews",
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
  searchMomo,
  recommendMomo,
  getPopularMomo,
};

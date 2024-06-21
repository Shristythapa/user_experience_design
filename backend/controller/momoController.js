const Momo = require("../model/momoModel");
const User = require("../model/userModel");
const cloudinary = require("cloudinary");
const Rating = require("../model/ratingModel");
// const addMomo = async (req, res) => {
//   console.log(req.body);
//   const { userId, momoName, momoPrice, cookType, fillingType, location, shop } =
//     req.body;

//   const { momoImage } = req.files;

//   if (
//     (!userId,
//     !momoName,
//     !momoImage,
//     !momoPrice,
//     !cookType,
//     !fillingType,
//     !location,
//     !shop,
//     !momoImage)
//   ) {
//     console.log("not all feilds found");
//     return res.json({
//       success: false,
//       message: "Enter all feilds",
//     });
//   }
//   // const existingUser = await User.findOne({ email: email });
//   // if (!existingUser) {
//   //   return res.status(400).json("User Doesn't exists.");
//   // }

//   try {
//     //step 5: upload images to cloudainary
//     //uploadedImage holds info send after images are uploded
//     //scale -> all images are stored in same format (croped)
//     const uploadedImage = await cloudinary.v2.uploader.upload(momoImage.path, {
//       folder: "momo",
//       crop: "scale",
//     });
//     const newMomo = new Momo({
//       userId: userId,
//       momoName: momoName,
//       momoImage: uploadedImage.secure_url,
//       momoPrice: momoPrice,
//       cookType: cookType,
//       fillingType: fillingType,
//       location: location,
//       shop: shop,
//       overallRating: 0,
//     });

//     console.log("momo saved");
//     console.log(newMomo);
//     await newMomo.save();
//     res.status(200).json({
//       success: true,
//       message: "Momo Added Sucessfully",
//       data: newMomo,
//     });
//   } catch (e) {
//     console.log(e);
//     res.status(500).json({
//       success: false,
//       message: "Server Error",
//       data: newMomo,
//     });
//   }
// };
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
      await momo.save();
    }
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
    res.status(500).json({
      success: false,
      message: "Server Error",
    });
  }
};

const getMomoById = async (req, res) => {
  try {
    const momo = await Momo.findById(req.params.id).populate("reviews").exec();
    res.status(200).json({
      success: true,
      message: "get momo by id sucessful",
      data: momo,
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
    res.status(500).json("Server error");
  }
};

module.exports = {
  addMomo,
  updateMomo,
  getAllMomo,
  getMomoById,
};

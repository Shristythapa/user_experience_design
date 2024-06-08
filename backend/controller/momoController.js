const Momo = require("../model/momoModel");
const User = require("../model/userModel");
const cloudinary = require("cloudinary");
const addMomo = async (req, res) => {
  console.log(req.body);
  const {
    userId,
    momoName,

    momoPrice,
    cookType,
    fillingType,
    location,
  } = req.body;

  const { momoImage } = req.files;

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
  // const existingUser = await User.findOne({ email: email });
  // if (!existingUser) {
  //   return res.status(400).json("User Doesn't exists.");
  // }

  try {
    //step 5: upload images to cloudainary
    //uploadedImage holds info send after images are uploded
    //scale -> all images are stored in same format (croped)
    const uploadedImage = await cloudinary.v2.uploader.upload(momoImage.path, {
      folder: "momo",
      crop: "scale",
    });
    const newMomo = new Momo({
      userId: userId,
      momoName: momoName,
      momoImage: uploadedImage.secure_url,
      momoPrice: momoPrice,
      cookType: cookType,
      fillingType: fillingType,
      location: location,
    });

    await newMomo.save();
    res.status(200).json({
      success: true,
      message: "Momo Added Sucessfully",
      data: newMomo,
    });
  } catch (e) {
    console.log(e);
    res.status(500).json({
      success: false,
      message: "Server Error",
    });
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

module.exports = {
  addMomo,
  updateMomo,
};

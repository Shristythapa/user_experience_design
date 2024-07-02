const Preference = require("../model/preferenceModel");
const User = require("../model/userModel");

const addPeference = async (req, res) => {
  console.log(req.body);

  const { userId, cookType, fillingType, filling } = req.body;

  if (!userId) {
    return res.json({
      success: false,
      message: "User Id not found",
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
    const userPreferences = new Preference({
      userId: userId,
      cookType: cookType,
      fillingType: fillingType,
      filling: filling,
    });

    await userPreferences.save();
    res.status(200).json({
      success: true,
      message: "Preferences added sucessfully",
      data: userPreferences,
    });
  } catch (e) {
    console.log(e);
    res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

//update product
const updatePreferences = async (req, res) => {
  console.log(req.body);

  const { userId, sizeOfMomo, fillings, aesthetics, sauceVariaty } = req.body;

  if (!userId) {
    return res.json({
      success: false,
      message: "UserId not found",
    });
  }
  //destructure id from url
  const id = req.params.id;

  try {
    const updatedPreferences = {
      userId: userId,
      sizeOfMomo: sizeOfMomo,
      fillings: fillings,
      aesthetics: aesthetics,
      sauceVariaty: sauceVariaty,
    };
    await Products.findByIdAndUpdate(id, updatedPreferences);
    res.json({
      success: true,
      message: "Preferences Updated Sucessfully",
      product: updatedPreferences,
    });
  } catch (error) {
    console.log(error);
    res.json({
      message: "Server error",
      success: false,
    });
  }
};

const getUserPreference = async (req, res) => {
  //destructure userId form request
  const userId = req.params.id;

  if (!userId) {
    return res.json({
      success: false,
      message: "UserId Not Recived",
    });
  }

  try {
    const prefrence = await Preference.findOne({ userId: userId });
    res.json({
      success: true,
      message: "Preference featched Successfully",
      prefrence: prefrence,
    });
  } catch (e) {
    console.log(e);
    res.status(500).json("Server Error");
  }
};

module.exports = {
  addPeference,
  updatePreferences,
  getUserPreference,
};

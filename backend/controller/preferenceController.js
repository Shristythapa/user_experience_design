const Preference = require("../model/preferenceModel");
const User = require("../model/userModel");

const addPeference = async (req, res) => {
  console.log(req.body);

  const { userId, cookType, filling } = req.body;

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
      // fillingType: fillingType,
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
const updatePreferences = async (req, res) => {
  console.log(req.body);

  const { cookType, filling } = req.body;

  // Destructure id from URL
  const id = req.params.id;

  try {
    // Find the product by ID
    const product = await Preference.findById(id);

    if (!product) {
      return res.json({
        success: false,
        message: "Product not found",
      });
    }

    // Update only the required fields, keeping the userId unchanged
    const updatedPreferences = {
      cookType: cookType || product.cookType,
      // fillingType: fillingType || product.fillingType,
      filling: filling || product.filling,
    };

    await Preference.findByIdAndUpdate(id, updatedPreferences);

    res.json({
      success: true,
      message: "Preferences Updated Successfully",
      product: { ...product.toObject(), ...updatedPreferences },
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
    if (prefrence != null) {
      res.json({
        success: true,
        message: "Preference featched Successfully",
        prefrence: prefrence,
      });
    } else {
      res.status(400).json({
        success: false,
        message: "Preference not found",
      });
    }
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

const SavedMomo = require("../model/saveMomoModel");

const saveMomo = async (req, res) => {
  const { userId, momoId } = req.body;

  if (!userId || !momoId) {
    return res.status(400).json({
      success: false,
      message: "User ID and Momo ID are required",
    });
  }

  try {
    // Check if the Momo is already saved by the user
    // const existingSavedMomo = await SavedMomo.findOne({ userId, momoId });
    // if (existingSavedMomo) {
    //   return res.status(400).json({
    //     success: false,
    //     message: "Momo is already saved by the user",
    //   });
    // }

    const newSavedMomo = new SavedMomo({
      userId,
      momoId,
    });

    await newSavedMomo.save();

    res.status(200).json({
      success: true,
      message: "Momo saved successfully",
      data: newSavedMomo,
    });
  } catch (e) {
    console.log(e);
    res.status(500).json({
      success: false,
      message: "Server Error",
    });
  }
};

const getSavedMomosByUser = async (req, res) => {
  const { userId } = req.params;

  if (!userId) {
    return res.status(400).json({
      success: false,
      message: "User ID is required",
    });
  }

  try {
    const savedMomos = await SavedMomo.find({ userId }).populate("momoId");

    res.status(200).json({
      success: true,
      message: "Saved Momos fetched successfully",
      data: savedMomos,
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
  saveMomo,
  getSavedMomosByUser,
};

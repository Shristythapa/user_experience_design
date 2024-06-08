const Momo = require("../model/momoModel");
const Rating = require("../model/ratingModel")

const addRating = async (req, res) =>{
    console.log(req.body);

    const {userId,momoId, overallRating,fillingAmount,sizeOfMomo,sauceVariety,aesthectic,spiceLevel,priceValue,taste,review} = req.body;

    if(!userId || !momoId){
        return res.json({
            success: false,
            message:"Enter all feilds"
        })
    }

    const existingUser = await User.findOne({ userId: userId });

    if (!existingUser) {
      return res.status(400).json("User doesn't exist.");
    }

    try {
      const newRating = new Rating({
        userId: userId,
        momoId: momoId,
        overallRating: overallRating,
        fillingAmount: fillingAmount,
        sizeOfMomo: sizeOfMomo,
        sauceVariety: sauceVariety,
        aesthectic: aesthectic,
        spiceLevel: spiceLevel,
        priceValue: priceValue,
        taste: taste,
        review: review,
      });

      await newRating.save();
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

    
}
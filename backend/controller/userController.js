const Users = require("../model/userModel");

const bycrypt = require("bcrypt");
const cloudinary = require("cloudinary");
const jwt = require("jsonwebtoken");

const createUser = async (req, res) => {
  console.log(req.body);

  const { userName, email, password } = req.body;

  if (!userName || !email || !password) {
    return res.status(400).json("Please enter all fields.");
  }
  const { profilePicture } = req.files;

  console.log(profilePicture);

  try {
    const existingUser = await Users.findOne({ email: email });
    if (existingUser) {
      return res.status(400).json("User already exists.");
    }

    const uploadedImage = await cloudinary.v2.uploader.upload(
      profilePicture.path,
      {
        folder: "user",
        crop: "scale",
      }
    );

    console.log(uploadedImage);

    const generatedSalt = await bycrypt.genSalt(10);
    const encryptedPassword = await bycrypt.hash(password, generatedSalt);

    const newUser = new Users({
      userName: userName,
      email: email,
      password: encryptedPassword,
      profileImageUrl: uploadedImage.secure_url,
    });

    await newUser.save();
    res.status(200).json("User created sucessfully.");
  } catch (error) {
    console.log(error);
    res.status(500).json(error);
  }
};

const loginUser = async (req, res) => {
  console.log(req.body);

  const { email, password } = req.body;

  if (!email || !password) {
    return res.json({
      sucess: false,
      message: "Please enter all fields.",
    });
  }

  try {
    const user = await Users.findOne({ email: email });
    if (!user) {
      return res.json({
        sucess: false,
        message: "User not found",
      });
    }

    console.log(user);

    const passwordToCompare = user.password;
    const isMatch = bycrypt.compare(password, user.password);

    if (!isMatch) {
      res.json({
        sucess: false,
        message: "Password dosen't match",
      });
    }

    const token = jwt.sign({ id: user._id }, process.env.JWT_TOKEN_SECRET);
    res.status(200).json({
      sucess: true,
      token: token,
      userData: user,
      message: "User loged in Sucessfully",
    });
  } catch (error) {
    console.log(error);
    res.json(error);
  }
};

module.exports = {
  createUser,
  loginUser,
};

const Users = require("../model/userModel");

const bycrypt = require("bcrypt");
const cloudinary = require("cloudinary");
const jwt = require("jsonwebtoken");
const nodemailer = require("nodemailer");
const ResetToken = require("../model/ResetTokenModel");

const createUser = async (req, res) => {
  console.log(req.body);

  const { userName, email, password } = req.body;

  if (!userName || !email || !password) {
    return res.status(400).json({
      success: flase,
      message: "Please enter all fields.",
    });
  }
  const { profilePicture } = req.files;

  console.log(profilePicture);

  try {
    const existingUser = await Users.findOne({ email: email });
    if (existingUser) {
      return res.status(409).json({
        message: "User already exists.",
        success: false,
      });
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
    const token = jwt.sign({ id: newUser._id }, process.env.JWT_TOKEN_SECRET);
    res.status(200).json({
      token: token,
      userData: newUser,
      message: "User created sucessfully.",
      success: true,
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      message: error,
      success: false,
    });
  }
};

const loginUser = async (req, res) => {
  console.log(req.body);

  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({
      sucess: false,
      message: "Please enter all fields.",
    });
  }

  try {
    const user = await Users.findOne({ email: email });
    if (!user) {
      return res.status(404).json({
        sucess: false,
        message: "User not found",
      });
    }

    console.log(user);

    const passwordToCompare = user.password;
    const isMatch = await bycrypt.compare(password, user.password);
    console.log(isMatch);
    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: "Password dosen't match",
      });
    }

    const token = jwt.sign({ id: user._id }, process.env.JWT_TOKEN_SECRET);
    return res.status(200).json({
      sucess: true,
      token: token,
      userData: user,
      message: "User loged in Sucessfully",
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({
      success: false,
      message: error,
    });
  }
};
const forgotPassword = async (req, res) => {
  const { email } = req.body;

  if (!email) {
    return res.status(400).json({
      message: "Enter email",
      success: false,
    });
  }

  try {
    const user = await Users.findOne({ email: email });
    if (!user) {
      return res
        .status(404)
        .json({ message: "User not existed", success: false });
    }

    // Generate a random OTP code
    const otpCode = Math.floor(100000 + Math.random() * 900000).toString();

    // Save the OTP code in the ResetToken collection
    const resetToken = new ResetToken({
      userId: user._id,
      token: otpCode,
    });
    await resetToken.save();

    var transporter = nodemailer.createTransport({
      service: "gmail",
      auth: {
        user: "testing99st@gmail.com",
        pass: "cohbyloqsegkxbeu",
      },
    });

    var mailOptions = {
      from: "thapashristy110@gmail.com",
      to: email,
      subject: "MoMoMatch Application Reset Password Code",
      text: `Your reset password OTP code is ${otpCode}`,
    };

    transporter.sendMail(mailOptions, function (error, info) {
      if (error) {
        console.error("Error sending mail:", error);
        return res
          .status(500)
          .json({ success: false, message: "Mail send unsuccessful" });
      } else {
        console.log("Mail sent:", info.response);
        return res
          .status(200)
          .json({ success: true, message: "Mail sent successfully" });
      }
    });
  } catch (error) {
    console.error("Server error:", error);
    return res.status(500).json({ success: false, message: "Server error" });
  }
};

const resetPassword = async (req, res) => {
  const { email, otpCode, newPassword } = req.body;
  console.log(req.body);
  if (!email || !otpCode || !newPassword) {
    return res.status(400).json({
      message: "Enter all required fields",
      success: false,
    });
  }

  try {
    const user = await Users.findOne({ email: email });
    if (!user) {
      return res
        .status(400)
        .json({ message: "User not existed", success: false });
    }

    const resetToken = await ResetToken.findOne({
      userId: user._id,
      token: otpCode,
    });
    if (!resetToken) {
      return res
        .status(400)
        .json({ message: "Invalid or expired OTP code", success: false });
    }

    const generatedSalt = await bycrypt.genSalt(10);
    const encryptedPassword = await bycrypt.hash(newPassword, generatedSalt);

    user.password = encryptedPassword;
    await user.save();

    await ResetToken.deleteOne({ _id: resetToken._id });

    res
      .status(200)
      .json({ success: true, message: "Password reset successful" });
  } catch (error) {
    return res.status(500).json({ success: false, message: "Server error" });
  }
};

module.exports = {
  createUser,
  loginUser,
  forgotPassword,
  resetPassword,
};

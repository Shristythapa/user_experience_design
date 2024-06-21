//create a instance of express app
const express = require("express");
const app = express();

//dotenv config
const dotenv = require("dotenv");
dotenv.config();
console.log(process.env.PORT);

//storeimage in cloud
const cloudinary = require("cloudinary");

cloudinary.config({
  cloud_name: "duhlo06nb",
  api_key: "617821885829489",
  api_secret: "7hELqPjemOLTQMHygIAsDJmpGME",
});

//cors policy
const cors = require("cors");
const corsPolicy = {
  //   origin: "http://localhost:3000",
  origin: "*",
  credentials: true,
  optionSuccessStatus: 200,
};
app.use(cors(corsPolicy));
//json middleware(to accept json data)
app.use(express.json());

const multiparty = require("connect-multiparty");
app.use(multiparty());
app.use(express.json());
//RUN THE server
const PORT = process.env.PORT;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

//mongodb connection
const connectDB = require("./database/db");
connectDB();

// USER ROUTES
app.use("/api/user", require("./routes/userRoutes"));
//our actual routes
//http://localhost:5000/api/user/create
//http://localhost:5000/api/user/login

// app.use("/api/user", require("./routes/preferenceRoutes"));
app.use("/api/momo", require("./routes/momoRoutes"));

app.use("/api/ratings", require("./routes/ratingRouter"));

app.use("/api/saveMomo", require("./routes/saveMomoRoutes"));

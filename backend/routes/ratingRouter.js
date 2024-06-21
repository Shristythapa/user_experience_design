const router = require("express").Router();
const ratingController = require("../controller/ratingController");

router.post("/addRating", ratingController.addRating);

module.exports = router;

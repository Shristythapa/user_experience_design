const router = require("express").Router();
const ratingController = require("../controller/ratingController");

router.post("/addRating", ratingController.addRating);

router.post("/deleteRating/:id", ratingController.deleteRating);

module.exports = router;

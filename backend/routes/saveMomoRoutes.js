const express = require("express");
const router = express.Router();
const saveMomoController = require("../controller/saveMomoController");

router.post("/saveMomo", saveMomoController.saveMomo);
router.post("/removeSavedMomo", saveMomoController.removeSavedMomo);
router.get("/savedMomos/:userId", saveMomoController.getSavedMomosByUser);

module.exports = router;

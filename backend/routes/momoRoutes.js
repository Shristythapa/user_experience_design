const router = require("express").Router();
const momoController = require("../controller/momoController");

router.post("/add", momoController.addMomo);
router.post("/update", momoController.updateMomo)

module.exports = router;
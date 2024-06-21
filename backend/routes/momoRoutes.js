const router = require("express").Router();
const momoController = require("../controller/momoController");

router.post("/add", momoController.addMomo);
router.post("/update", momoController.updateMomo);
router.get("/getAllMomo", momoController.getAllMomo);
router.get("/getMomoById/:id", momoController.getMomoById);
module.exports = router;

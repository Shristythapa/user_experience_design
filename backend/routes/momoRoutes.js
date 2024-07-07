const router = require("express").Router();
const momoController = require("../controller/momoController");

router.post("/add", momoController.addMomo);
router.post("/update", momoController.updateMomo);
router.get("/getAllMomo", momoController.getAllMomo);
router.get("/getMomoById", momoController.getMomoById);
router.get("/getRatingByUser/:id", momoController.getRatingsByUser);
router.get("/getRatingById/:id", momoController.getRatingById);
router.post("/searchMomo", momoController.searchMomo);
router.get("/getRecommendations/:id", momoController.recommendMomo);
router.get("/getPopularMomo", momoController.getPopularMomo);
module.exports = router;

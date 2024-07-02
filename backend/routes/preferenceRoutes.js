const router = require("express").Router();
const preferenceController = require("../controller/preferenceController")

router.post("/create",preferenceController.addPeference);
router.post("/edit", preferenceController.updatePreferences);
router.get("/getPreference/:id",preferenceController.getUserPreference);

module.exports = router;
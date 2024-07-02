const router = require("express").Router();
const userController = require("../controller/userController");

//create user api
router.post("/create", userController.createUser);

//login user api
router.post("/login", userController.loginUser);

router.post("/forgotPassword", userController.forgotPassword);

router.post("/resetPassword", userController.resetPassword);

//exporting all routers created above
module.exports = router;

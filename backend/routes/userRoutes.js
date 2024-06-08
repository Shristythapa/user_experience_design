const router = require("express").Router();
const userController = require("../controller/userController");

//create user api
router.post("/create", userController.createUser);

//login user api
router.post("/login", userController.loginUser);

//exporting all routers created above
module.exports = router;

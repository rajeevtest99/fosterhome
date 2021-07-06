const router = require("express").Router();
const User = require("../models/User");
const bCrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const config = require("../config");

// Register

router.post("/signup", async (req, res) => {
  try {
    //create hashpassword
    const salt = await bCrypt.genSalt(10);
    const hashedPassword = await bCrypt.hash(req.body.password, salt);

    //create user
    const user = await new User({
      firstname: req.body.firstname,
      lastname: req.body.lastname,
      username: req.body.username,
      email: req.body.email,
      password: hashedPassword,
    });

    var token = jwt.sign({ id: req.body.username }, config.key);

    //save data and respond
    const newUser = await user.save();
    res.status(200).json({
      userdate: newUser,
      token: token,
      userId: newUser.id,
      username: newUser.username,
    });
  } catch (err) {
    console.log(err);
  }
});

//Login user

router.post("/login", async (req, res) => {
  try {
    const loginUser = await User.findOne({ email: req.body.email });
    !loginUser && res.status(404).json("user not found");

    const validatePassword = await bCrypt.compare(
      req.body.password,
      loginUser.password
    );
    !validatePassword && res.status(400).json("wrong password");

    var token = jwt.sign({ id: req.body.username }, config.key);
    res.status(200).json({
      userdata: loginUser,
      token: token,
      userId: loginUser.id,
      username: loginUser.username,
    });
  } catch (error) {
    console.log(error);
  }
});

module.exports = router;

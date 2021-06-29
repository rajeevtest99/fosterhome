const User = require("../models/User");
const router = require("express").Router();
const bCrypt = require("bcrypt");
const middleware = require("../checktoken");
const multer = require("multer");
const { diskStorage } = require("multer");
const path = require("path");

const storage = diskStorage({
  destination: (req, file, cb) => {
    cb(null, "./uploads");
  },
  filename: (req, file, cb) => {
    cb(null, req.params.username + ".jpg");
  },
});

const fileFilter = (req, file, cb) => {
  if (file.mimetype == "image/jpeg" || file.mimetype == "image/png") {
    cb(null, true);
  } else {
    cb(null, false);
  }
};

const upload = multer({
  storage: storage,
  limits: {
    fileSize: 1024 * 1024 * 2,
    fileFilter: fileFilter,
  },
});

//add image

router.patch(
  "/addimage/:username",
  middleware.checkToken,
  upload.single("img"),

  async (req, res) => {
    try {
      await User.findOneAndUpdate(
        { username: req.params.username },
        {
          $set: { profilePicture: req.file.path },
        },
        { new: true },
        (err, profile) => {
          if (err) return res.statusCode(404).json("404 error");
          const response = {
            message: "image successfully added",
            data: profile,
          };
          res.status(200).json(response);
        }
      );
    } catch (error) {
      res.statusCode(500).json("error occured");
    }
  }
);

//checkusername

router.get("/checkusername/:username", async (req, res) => {
  try {
    await User.findOne({ username: req.params.username }, (err, result) => {
      if (err) return res.status(500).json({ msg: err });
      if (result !== null) {
        return res.json({
          Status: true,
        });
      } else {
        return res.json({
          Status: false,
        });
      }
    });
  } catch (error) {
    res.status(404).json("error while checking for username");
  }
});

//check user email

router.get("/checkemail/:email", async (req, res) => {
  try {
    await User.findOne({ email: req.params.email }, (err, result) => {
      if (result !== null) {
        return res.json({
          Status: true,
        });
      } else {
        return res.json({
          Status: false,
        });
      }
    });
  } catch (error) {
    res.status(404).json("error while checking for username");
  }
});

//get the user by username

router.get("/getuser/:username", middleware.checkToken, async (req, res) => {
  try {
    await User.findOne({ username: req.params.username }, (err, result) => {
      if (err) {
        res.statusCode(500).json("error has occcured");
      } else {
        return res.json({
          data: result,
          username: req.params.username,
        });
      }
    });
  } catch (error) {
    res.statusCode(404).json(error);
  }
});

//update user
router.put("/:id/update", middleware.checkToken, async (req, res) => {
  if (req.body.userId === req.params.id || req.body.isAdmin) {
    if (req.body.password) {
      try {
        const salt = await bCrypt.genSalt(10);
        req.body.password = await bCrypt.hash(req.body.password, salt);
      } catch (error) {
        return res.status(500).json(error);
      }
    }
    try {
      const user = await User.findByIdAndUpdate(req.params.id, {
        $set: req.body,
      });
      res.status(200).json("updated successfully");
    } catch (error) {
      return res.status(500).json(error);
    }
  } else {
    return res.status(403).json("you can update only your account");
  }
});

//delete user

router.delete("/:id", middleware.checkToken, async (req, res) => {
  if (req.body.userId === req.params.id || req.body.isAdmin) {
    try {
      await User.findByIdAndDelete(req.params.id);
      res.status(200).json("deleted successfully");
    } catch (error) {
      return res.status(500).json(error);
    }
  } else {
    return res.status(403).json("you can delete only your account");
  }
});

//search user

router.get("/searchuser", async (req, res) => {
  const searchField = req.query.username;
  try {
    User.find(
      { username: { $regex: searchField, $options: "$i" } },
      (err, result) => {
        if (err) {
          res.json(err);
        } else {
          res.status(200).json({ searchresult: result });
        }
      }
    );
  } catch (error) {
    res.status(500).json("error");
  }
});

//get all users

router.get("/getallusers", async (req, res) => {
  try {
    User.find({}).then((users) => {
      res.status(200).json({ allusers: users });
    });
  } catch (error) {
    res.send.json(error);
  }
});

//get a user

router.get("/:id", middleware.checkToken, async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    const { password, updatedAt, ...other } = user._doc;
    res.status(200).json(other);
  } catch (error) {
    res.status(500).json(error);
  }
});

//follow user

router.put("/:id/follow", middleware.checkToken, async (req, res) => {
  if (req.body.userId !== req.params.id) {
    try {
      const user = await User.findById(req.params.id);
      const currentUser = await User.findById(req.body.userId);
      if (!user.boopers.includes(req.body.userId)) {
        await user.updateOne({ $push: { boopers: req.body.userId } });
        await currentUser.updateOne({ $push: { booping: req.params.id } });
        res.status(200).json("user has been booped");
      } else {
        res.status(403).json("you already follow this user");
      }
    } catch (error) {
      res.status(500).json(error);
    }
  } else {
    res.status(403).json("you cant follow yourself");
  }
});

//unfollow user

router.put("/:id/unfollow", middleware.checkToken, async (req, res) => {
  if (req.body.userId !== req.params.id) {
    try {
      const user = await User.findById(req.params.id);
      const currentUser = await User.findById(req.body.userId);
      if (user.boopers.includes(req.body.userId)) {
        await user.updateOne({ $pull: { boopers: req.body.userId } });
        await currentUser.updateOne({ $pull: { booping: req.params.id } });
        res.status(200).json("user has been unbooped");
      } else {
        res.status(403).json("you already unfollow this user");
      }
    } catch (error) {
      res.status(500).json(error);
    }
  } else {
    res.status(403).json("you cant unfollow yourself");
  }
});

module.exports = router;

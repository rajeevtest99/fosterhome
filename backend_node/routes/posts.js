const router = require("express").Router();
const Post = require("../models/Posts");
const User = require("../models/User");
const multer = require("multer");
const { diskStorage } = require("multer");
const middleware = require("../checktoken");

//multer instance

const storage = diskStorage({
  destination: (req, file, cb) => {
    cb(null, "./uploads");
  },
  filename: (req, file, cb) => {
    cb(null, req.params.id + ".jpg");
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
  "/addimage/:id",
  middleware.checkToken,
  upload.single("img"),

  async (req, res) => {
    try {
      await Post.findOneAndUpdate(
        { _id: req.params.id },
        {
          $set: { image: req.file.path },
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

//create post

router.post("/create", middleware.checkToken, async (req, res) => {
  const newPost = await Post(req.body);
  try {
    const savedPost = await newPost.save();
    res.status(200).json(savedPost);
  } catch (error) {
    res.status(500).json(error);
  }
});

//update post

router.put("/:id/update", middleware.checkToken, async (req, res) => {
  try {
    const post = await Post.findById(req.params.id);
    if (post.userId === req.body.userId) {
      await post.updateOne({ $set: req.body });
      res.status(200).json("the post has been updated");
    } else {
      res.status(403).json("only the owner can edit the post");
    }
  } catch (error) {
    res.status(500).json(error);
  }
});
//delete post

router.delete("/:id/delete", middleware.checkToken, async (req, res) => {
  try {
    const post = await Post.findById(req.params.id);
    if (post.userId === req.body.userId) {
      await post.deleteOne();
      res.status(200).json("the post has been deleted");
    } else {
      res.status(403).json("only the owner can delete the post");
    }
  } catch (error) {
    res.status(500).json(error);
  }
});

//like and dislike post

router.put("/like/:id", middleware.checkToken, async (req, res) => {
  try {
    const post = await Post.findById(req.params.id);
    if (!post.likes.includes(req.body.userId)) {
      await post.updateOne({ $push: { likes: req.body.userId } });
      res.status(200).json("your post has been liked");
    } else {
      await post.updateOne({ $pull: { likes: req.body.userId } });
      res.status(200).json("your post has been disliked");
    }
  } catch (error) {
    res.status(500).json(error);
  }
});

//get current user post

router.get("/getpost/:id", middleware.checkToken, async (req, res) => {
  try {
    await Post.find({ userId: req.params.id }, (err, result) => {
      if (err) return res.status(404).json("error 404");
      return res.status(200).json({ data: result });
    });
  } catch (error) {
    res.status(500).json("error");
  }
});

//add comment

router.post("/:id/comment", middleware.checkToken, async (req, res) => {
  try {
    const post = await Post.findById(req.params.id);
    const comment = await post.updateOne({ $push: { comments: req.body } });
    res.status(200).json(comment);
  } catch (err) {
    res.status(500).json("error");
  }
});

//get all users

router.get("/getallposts", async (req, res) => {
  try {
    Post.find({}).then((posts) => {
      res.status(200).json({ allposts: posts });
    });
  } catch (error) {
    res.status(500).json(error);
  }
});

//get post

router.get("/:id", middleware.checkToken, async (req, res) => {
  try {
    const post = await Post.findById(req.params.id);
    res.status(200).json(post);
  } catch (error) {
    res.status(500).json(error);
  }
});

//get user timeline post

router.get("/timeline/all/:id", middleware.checkToken, async (req, res) => {
  try {
    const currentUser = await User.findById(req.params.id);
    const userPosts = await Post.find({ userId: currentUser._id });
    const friendPosts = await Promise.all(
      currentUser.booping.map((friendId) => {
        return Post.find({ userId: friendId });
      })
    );
    res.json({ feed: userPosts.concat(...friendPosts) });
  } catch (error) {
    res.status(500).json(error);
  }
});

module.exports = router;

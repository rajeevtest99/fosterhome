const mongoose = require("mongoose");

const PostSchema = new mongoose.Schema(
  {
    userId: {
      type: String,
      require: true,
    },
    description: {
      type: String,
      max: 1000,
    },
    image: {
      type: String,
      default: "",
    },
    likes: {
      type: Array,
      default: [],
    },

    comments: [
      new mongoose.Schema(
        {
          userId: {
            type: String,
            require: true,
          },
          comment: {
            type: String,
            default: "",
          },
        },

        { timestamps: true }
      ),
      { default: [] },
    ],
  },

  { timestamps: true }
);

module.exports = mongoose.model("Post", PostSchema);

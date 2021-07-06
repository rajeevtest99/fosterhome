const mongoose = require("mongoose");

mongoose.set("useFindAndModify", false);

const UserSchema = new mongoose.Schema(
  {
    firstname: {
      type: String,
      require: true,
      min: 4,
      max: 15,
      unique: false,
    },
    lastname: {
      type: String,
      require: true,
      min: 4,
      max: 15,
      unique: false,
    },
    username: {
      type: String,
      require: true,
      min: 4,
      max: 10,
      unique: true,
    },
    email: {
      type: String,
      require: true,
      min: 4,
      max: 35,
      unique: true,
    },
    password: {
      type: String,
      require: true,
      min: 8,
      max: 16,
      unique: false,
    },
    profilePicture: {
      type: String,
      default: "",
    },

    boopers: {
      type: Array,
      default: "",
    },

    booping: {
      type: Array,
      default: "",
    },

    fostered: {
      type: String,
      default: "",
    },

    about: {
      type: String,
      default: "",
      max: 250,
    },

    isAdmin: {
      type: Boolean,
      default: false,
    },

    hasFostered: {
      type: Boolean,
      default: false,
    },

    isWilling: {
      type: Boolean,
      default: false,
    },

    hideSocial: {
      type: Boolean,
      default: true,
    },

    hideLocation: {
      type: Boolean,
      default: true,
    },

    instaId: {
      type: String,
      default: "",
    },
    instaLink: {
      type: String,
      default: "",
    },
    twitterId: {
      type: String,
      default: "",
    },
    twitterLink: {
      type: String,
      default: "",
    },
    fbId: {
      type: String,
      default: "",
    },
    fbLink: {
      type: String,
      default: "",
    },

    latitude: {
      type: String,
      default: "",
    },
    longitude: {
      type: String,
      default: "",
    },

    city: {
      type: String,
      default: "",
    },

    country: {
      type: String,
      default: "",
    },
  },

  { timestamps: true }
);

module.exports = mongoose.model("User", UserSchema);

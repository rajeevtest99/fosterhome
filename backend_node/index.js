const express = require("express");
const app = express();
const mongoose = require("mongoose");
const morgan = require("morgan");
const helmet = require("helmet");
const dotenv = require("dotenv");
const authRoute = require("./routes/auth");
const userRoute = require("./routes/user");
const postRoute = require("./routes/posts");

dotenv.config();

mongoose.connect(
  process.env.MONGO_URL,
  { useNewUrlParser: true, useUnifiedTopology: true },
  () => {
    console.log("connected to mongoDb");
  }
);

//middleware
app.use(express.json());
app.use(helmet());
app.use(morgan("common"));

app.use("/uploads", express.static("uploads"));
app.get("/", (req, res) => {
  res.status(200).json({ message: "hey its working" });
});
app.use("/auth/users", authRoute);
app.use("/user", userRoute);
app.use("/posts", postRoute);

app.listen(process.env.PORT || 3000, "0.0.0.0", () => {
  console.log("listening to port");
});

const mongoose = require('mongoose');
const uri = "mongodb+srv://habittracking:G1HDEewgMJXCo5qn@habittrucking.rjzolku.mongodb.net/fitflow?retryWrites=true&w=majority";
mongoose.connect(uri).then(async () => {
  const db = mongoose.connection.db;
  const posts = await db.collection('posts').find().sort({createdAt: -1}).limit(5).toArray();
  console.log(JSON.stringify(posts, null, 2));
  process.exit(0);
});

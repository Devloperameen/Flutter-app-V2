const mongoose = require('mongoose');

const postSchema = new mongoose.Schema(
  {
    authorId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    authorName: {
      type: String,
      required: true,
    },
    authorRole: {
      type: String,
      default: 'Member',
    },
    content: {
      type: String,
      required: true,
    },
    imageUrl: {
      type: String,
    },
    videoUrl: {
      type: String,
    },
    likes: [{
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
    }],
    commentCount: {
      type: Number,
      default: 0,
    },
  },
  {
    timestamps: true,
  }
);

// Virtual for likeCount
postSchema.virtual('likeCount').get(function () {
  return this.likes ? this.likes.length : 0;
});

// Helper method to check if user liked the post
postSchema.methods.checkIsLikedBy = function (userId) {
  return this.likes && this.likes.some(id => id.toString() === userId.toString());
};

module.exports = mongoose.model('Post', postSchema);

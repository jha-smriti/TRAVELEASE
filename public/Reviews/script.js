const btn = document.querySelector("button");
const post = document.querySelector(".post");
const icon = document.querySelector(".star-icon");
const edit = document.querySelector(".edit");
const reviewsContainer = document.querySelector(".packet");

btn.onclick = () => {
  // Get the selected rating
  const rating = document.querySelector('input[name="rate"]:checked');
  const ratingValue = rating ? rating.value : "No rating";

  // Get the review text
  const reviewText = document.getElementById("review-text").value;

  // Create new review HTML
  const newReview = `
    <div class="box">
      <div class="boxtop">
        <div class="profile">
          <div class="profile-img">
            <img src="user_new.jpg" />
          </div>
          <div class="name-user">
            <strong>Your Name</strong>
            <span>@your_username</span>
          </div>
        </div>
        <div class="stars">
          ${getStarsHtml(ratingValue)}
        </div>
      </div>
      <div class="comment">
        <p>${reviewText}</p>
      </div>
    </div>
  `;

  // Append new review to reviews container
  reviewsContainer.insertAdjacentHTML("beforeend", newReview);

  // Reset form
  document.getElementById("review-text").value = "";
  document.querySelector('input[name="rate"]:checked').checked = false;

  // Show the thank you message
  icon.style.display = "none";
  post.style.display = "block";
};

// Helper function to generate star icons based on rating value
function getStarsHtml(rating) {
  const stars = parseInt(rating);
  const halfStar = rating % 1 !== 0 ? '<i class="fa fa-star-half-o"></i>' : '';
  const fullStars = '<i class="fa fa-star"></i>'.repeat(stars);
  const emptyStars = '<i class="fa fa-star-o"></i>'.repeat(5 - stars);

  return `${fullStars}${halfStar}${emptyStars}`;
}

// Toggle between post and edit mode
edit.onclick = () => {
  icon.style.display = "block";
  post.style.display = "none";
  return false;
};

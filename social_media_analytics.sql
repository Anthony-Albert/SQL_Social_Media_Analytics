create database Analytics;
use Analytics;

CREATE TABLE Users (
    user_id INT PRIMARY KEY not null,
    username VARCHAR(50) not null,
    email VARCHAR(100) not null,
    join_date DATE
);

CREATE TABLE Posts (
    post_id INT PRIMARY KEY not null,
    user_id INT not null,
    post_content varchar(50),
    post_date DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Comments (
    comment_id INT PRIMARY KEY,
    post_id INT not null,
    user_id INT not null,
    comment_content varchar(50),
    comment_date DATE,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Likes (
    like_id INT PRIMARY KEY,
    post_id INT not null,
    user_id INT not null,
    like_date DATE,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Followers (
    follower_id INT PRIMARY KEY not null,
    follower_user_id INT not null,
    following_user_id INT not null,
    follow_date DATE,
    FOREIGN KEY (follower_user_id) REFERENCES Users(user_id),
    FOREIGN KEY (following_user_id) REFERENCES Users(user_id)
);

-- Inserting values into Users table
INSERT INTO Users (user_id, username, email, join_date) VALUES
(1, 'Anthony', 'anthony135@gmail.com', '2023-01-01'),
(2, 'Albert', 'albert013@gmail.com', '2023-01-05'),
(3, 'Melwyn', 'melwin07@gmail.com', '2023-01-10'),
(4, 'Magnes', 'Magnes13@gmail.com', '2023-01-15'),
(5, 'Benno', 'benno10@gmail.com', '2023-01-20'),
(6, 'Shivaram', 'shivaram01@gmail.com', '2023-01-25'),
(7, 'Frankinn', 'frankinn06@gmail.com', '2023-01-30'),
(8, 'Alan', 'alan10@gmail.com', '2023-02-01'),
(9, 'Kishore', 'kishore12@gmail.com', '2023-02-05'),
(10, 'Gokul', 'gokul23@gmail.com', '2023-02-10');


-- Inserting values into Posts table
INSERT INTO Posts (post_id, user_id, post_content, post_date) VALUES
(1, 1, 'This is my first post!', '2023-01-02'),
(2, 2, 'Hello world!', '2023-01-06'),
(3, 3, 'Just sharing some thoughts.', '2023-01-10'),
(4, 4, 'New day, new post!', '2023-01-16'),
(5, 5, 'Feeling inspired today.', '2023-01-21'),
(6, 6, 'Check out this amazing photo!', '2023-01-26'),
(7, 7, 'Excited to share some news!', '2023-01-31'),
(8, 8, 'Reflecting on the past week.', '2023-02-02'),
(9, 9, 'Looking forward to the weekend!', '2023-02-06'),
(10, 10, 'Just posted a new blog entry.', '2023-02-11');


-- Inserting values into Comments table
INSERT INTO Comments (comment_id, post_id, user_id, comment_content, comment_date) VALUES
(1, 1, 2, 'Nice post!', '2023-01-03'),
(2, 2, 1, 'Great!', '2023-01-07'),
(3, 3, 4, 'Interesting thoughts.', '2023-01-11'),
(4, 4, 3, 'Keep it up!', '2023-01-17'),
(5, 5, 6, 'I feel the same.', '2023-01-22'),
(6, 6, 5, 'Amazing photo!', '2023-01-27'),
(7, 7, 8, 'Can''t wait to hear!', '2023-02-01'),
(8, 8, 9, 'Me too!', '2023-02-03'),
(9, 9, 10, 'Weekend vibes!', '2023-02-07'),
(10, 10, 7, 'Will check it out.', '2023-02-12');


-- Inserting values into Likes table
INSERT INTO Likes (like_id, post_id, user_id, like_date) VALUES
(1, 1, 2, '2023-01-04'),
(2, 2, 1, '2023-01-08'),
(3, 3, 5, '2023-01-12'),
(4, 4, 6, '2023-01-18'),
(5, 5, 3, '2023-01-23'),
(6, 6, 7, '2023-01-28'),
(7, 7, 4, '2023-02-01'),
(8, 8, 8, '2023-02-04'),
(9, 9, 9, '2023-02-08'),
(10, 10, 10, '2023-02-13');


-- Inserting values into Followers table
INSERT INTO Followers (follower_id, follower_user_id, following_user_id, follow_date) VALUES
(1, 1, 2, '2023-01-02'),
(2, 2, 1, '2023-01-06'),
(3, 3, 4, '2023-01-11'),
(4, 4, 3, '2023-01-17'),
(5, 5, 6, '2023-01-22'),
(6, 6, 5, '2023-01-27'),
(7, 7, 8, '2023-02-01'),
(8, 8, 9, '2023-02-03'),
(9, 9, 10, '2023-02-07'),
(10, 10, 7, '2023-02-12');


-- Query 1: Get all posts along with their authors' usernames
SELECT Posts.post_id, Posts.post_content, Users.username
FROM Posts
JOIN Users ON Posts.user_id = Users.user_id;

-- Query 2: Get all comments along with the usernames of the users who made them
SELECT Comments.comment_id, Comments.comment_content, Users.username
FROM Comments
JOIN Users ON Comments.user_id = Users.user_id;

-- Query 3: Get the count of likes for each post along with their content
SELECT Posts.post_id, Posts.post_content, COUNT(Likes.like_id) AS like_count
FROM Posts
LEFT JOIN Likes ON Posts.post_id = Likes.post_id
GROUP BY Posts.post_id, Posts.post_content;

-- Query 4: Get all followers for a particular user
SELECT Users.username AS follower, Followers.follow_date
FROM Followers
JOIN Users ON Followers.follower_user_id = Users.user_id
WHERE Followers.following_user_id = 9; 
-- Assuming user_id 1 is the target user

-- Subquery 1: Get all users who commented on posts made by user with user_id = 1
SELECT username
FROM Users
WHERE user_id IN (SELECT user_id FROM Comments WHERE post_id IN (SELECT post_id FROM Posts WHERE user_id = 5));

-- Subquery 2: Get all posts liked by users who joined before a certain date
SELECT post_content
FROM Posts
WHERE user_id IN (SELECT user_id FROM Likes WHERE user_id IN (SELECT user_id FROM Users WHERE join_date < '2023-01-15'));

-- Subquery 3: Get all posts made by users followed by user with user_id = 2
SELECT post_content
FROM Posts
WHERE user_id IN (SELECT following_user_id FROM Followers WHERE follower_user_id = 2);

-- Subquery 4: Get all users who have not made any posts
SELECT username
FROM Users
WHERE user_id IN (SELECT user_id FROM Posts);

-- Get the usernames of users who have posted at least once
SELECT username
FROM Users
WHERE EXISTS (
    SELECT 1
    FROM Posts
    WHERE Posts.user_id = Users.user_id
);

select * from users;
select * from posts;
select * from comments;
select * from likes;
select * from followers;

desc users;
desc posts;
desc comments;
desc likes;
desc followers;









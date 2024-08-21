-- user initialization
CREATE TABLE users (
id INT NOT NULL UNIQUE AUTO_INCREMENT,
user_name VARCHAR(30) NOT NULL unique,
first_name VARCHAR(20) NOT NULL,
last_name VARCHAR(20) NOT NULL,
day_streak INT NOT NULL,
phone_number VARCHAR(11) NOT NULL,
birth_date DATE NOT NULL,


PRIMARY KEY(id)
);
-- commit and rollback after each user init is a good idea
COMMIT;

-- User login 
SELECT COUNT(*) AS user_count -- if returns 1, success
FROM users
WHERE username = 'provided_username' AND password_hash = 'provided_password';


-- fetch 10 profiles to show free tier user


-- the beginner user's first right swipe(given that swipes on one of 20 first profiles(bots)) gets a match


-- user views own profile

-- -- get basic user info
-- -- get prompts
-- -- get profile pics
-- -- get social graph lib

-- 






------
use sql_store;


CREATE TABLE users (
user_id INT NOT NULL AUTO_INCREMENT ,
user_name VARCHAR(30) NOT NULL unique,
first_name VARCHAR(20) NOT NULL,
last_name VARCHAR(20) NOT NULL,
phone_number VARCHAR(11) NOT NULL,
birth_date DATE NOT NULL,
gender_is_male BOOLEAN NOT NULL,
password_hash VARCHAR(50) NOT NULL,
height INT,
weight INT,
location POINT,
day_streak INT NOT NULL,
day_streak_record INT NOT NULL,
ref_to_pics INT NOT NULL UNIQUE,
ref_to_audio INT NOT NULL UNIQUE,
ref_to_prompts INT NOT NULL UNIQUE,
-- ref to social-graph(rel tags) and interest-tags


PRIMARY KEY(user_id),
FOREIGN KEY (ref_to_pics) REFERENCES pics(pic_id),
FOREIGN KEY (ref_to_audio) REFERENCES audios(audio_id),
FOREIGN KEY (ref_to_prompts) REFERENCES prompts(prompt_id)
);

-- media tables
CREATE TABLE pics(
	pic_id INT NOT NULL AUTO_INCREMENT,
    pic_link VARCHAR(255) NOT NULL,
    owner_id INT NOT NULL,
    
    PRIMARY KEY(pic_id),
    FOREIGN KEY (owner_id) REFERENCES users(user_id)
);

CREATE TABLE audios(
	audio_id INT NOT NULL AUTO_INCREMENT,
    audio_link VARCHAR(255) NOT NULL,
    owner_id INT NOT NULL,
    
    PRIMARY KEY(audio_id),
    FOREIGN KEY (owner_id) REFERENCES users(user_id)
);

CREATE TABLE prompts(
	prompt_id INT NOT NULL AUTO_INCREMENT,
    owner_id INT NOT NULL,
    prompt_title VARCHAR(255) NOT NULL,
    prompt_answer VARCHAR(500) NOT NULL,
    
    PRIMARY KEY(prompt_id),
	FOREIGN KEY (owner_id) REFERENCES users(user_id)
);

CREATE TABLE social_graph(
	-- prompt_id INT NOT NULL AUTO_INCREMENT,
--     owner_id INT NOT NULL,
--     prompt_title VARCHAR(255) NOT NULL,
--     prompt_answer VARCHAR(500) NOT NULL,
--     
--     PRIMARY KEY(prompt_id),
-- 	FOREIGN KEY (owner_id) REFERENCES users(user_id)
);

CREATE TABLE relationship_tags(
	title VARCHAR(255) NOT NULL,
    descriptions VARCHAR(1000) NOT NULL
);

CREATE TABLE interest_tags(
    title VARCHAR(255) NOT NULL,
    descriptions VARCHAR(1000) NOT NULL
);



-- commit and rollback after each user init is a good idea
COMMIT;

SELECT * FROM users;

INSERT INTO users VALUES(1, 'Jack', 'crack');
INSERT INTO users VALUES(2, 'Kate', 'hate');

-- user login: get username and password(convert to hash), check if username exists and pass is correct
SELECT COUNT(*) AS user_count -- if returns 1, success
FROM users
WHERE username = 'provided_username' AND password_hash = 'provided_password';

-- each time a user(A) swipes right on a user(B) a record in Likes table is created by the id of userB
-- so when userB likes userA too, the query of Likes with userB's id will rerurn .

CREATE TABLE likes(
like 
);

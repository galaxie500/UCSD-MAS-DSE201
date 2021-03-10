create database CATS201;

use CATS201;

/* User's fb login and names */
create table users(
	login_name varchar(255) primary key, # user's web app login names(fb login), could be emails
    user_name varchar(255) not null # user's name when create app acount
);

/* Each login, a user may watch one of the suggested videos and like a suggested video */
create table logins(
	login_id int primary key auto_increment, # index of each logins
    login_name varchar(255) not null, # login name used when a user conducts a login
    video_liked int, # the video liked by a user during this login
    liked_time timestamp, # the time when the user liked the video
    video_watched int, # the video watched by a user during this login
    watched_time timestamp, # the time when the user watched the video
    
    constraint fk1 foreign key(login_name) references users(login_name)
		on delete cascade on update restrict
);

/* The videos that were suggested to the user whn he/she logged in */
create table videos_suggested(
	video_id int not null,
    login_id int not null,
    
    primary key(video_id, login_id)
);

/* Which users are friends of each other */
create table friends(
	login_name varchar(255) not null,
    friend_login_name varchar(255) not null,
    
    primary key(login_name, friend_login_name),
    constraint fk4 foreign key(login_name) references users(login_name)
		on delete cascade on update restrict
);



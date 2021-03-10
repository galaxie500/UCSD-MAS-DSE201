create database SalesCube;

use SalesCube;

create table customers(
	id int primary key auto_increment,
    name varchar(255) not null,
    state varchar(255) not null
);

create table states(
	id int primary key auto_increment,
    name varchar(255) not null
);

create table products(
	id int primary key auto_increment,
    price decimal(5, 2) not null,
    name varchar(255) not null,
    category varchar(255) not null
);

create table categories(
	id int primary key auto_increment,
    name varchar(255) not null,
    description varchar(255) not null
);

create table sales(
	id int primary key auto_increment,
    product varchar(255) not null,
    price decimal(5, 2) not null,
    quantity int not null,
    discount decimal(4, 2) not null
);
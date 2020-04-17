create table if not exists director
(
	id serial not null
		constraint director_pk
			primary key,
	first_name varchar(255) not null,
	last_name varchar(255),
	birth_date date,
	country_of_residence varchar(255)
);

alter table director owner to postgres;

create table if not exists movie
(
	id serial not null
		constraint movie_pk
			primary key,
	title varchar(255),
	plot_brief_description varchar(1023),
	rating smallint not null
		constraint check_rating_range
			check ((rating >= 0) AND (rating <= 100)),
	release_date date,
	duration_seconds integer,
	director_id integer
		constraint movie_director_id_fk
			references director
);

alter table movie owner to postgres;

create table if not exists actor
(
	id serial not null
		constraint actor_pk
			primary key,
	first_name varchar(255) not null,
	last_name varchar(255),
	birth_date date,
	height_cm smallint,
	country_of_residence varchar(255)
);

alter table actor owner to postgres;

-- Uses object_types.sql
create table if not exists role
(
	id serial not null
		constraint role_pk
			primary key,
	name varchar(255) not null,
	significance significance default 'primary'::significance,
	hostility hostility,
	description varchar(32767)
);

alter table role owner to postgres;

create table if not exists actor_role
(
	actor_id integer
		constraint actor_role_actor_id_fk
			references actor
				on delete cascade,
	role_id integer
		constraint actor_role_role_id_fk
			references role
				on delete cascade
);

alter table actor_role owner to postgres;

create table if not exists genre
(
	id serial not null
		constraint genre_pk
			primary key,
	name varchar(255) not null
);

alter table genre owner to postgres;

create table if not exists movie_genre
(
	movie_id integer
		constraint movie_genre_movie_id_fk
			references movie
				on delete cascade,
	genre_id integer
		constraint movie_genre_genre_id_fk
			references genre
				on delete cascade
);

alter table movie_genre owner to postgres;

create table if not exists movie_actor
(
	movie_id integer
		constraint movie_actor_movie_id_fk
			references movie
				on delete cascade,
	actor_id integer
		constraint movie_actor_actor_id_fk
			references actor
				on delete cascade
);

alter table movie_actor owner to postgres;


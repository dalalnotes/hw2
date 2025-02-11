# In this assignment, you'll be using the domain model from hw1 (found in the hw1-solution.sql file)
# to create the database structure for "KMDB" (the Kellogg Movie Database).
# The end product will be a report that prints the movies and the top-billed
# cast for each movie in the database.

# To run this file, run the following command at your terminal prompt:
# `rails runner kmdb.rb`

# Requirements/assumptions
#
# - There will only be three movies in the database – the three films
#   that make up Christopher Nolan's Batman trilogy.
# - Movie data includes the movie title, year released, MPAA rating,
#   and studio.
# - There are many studios, and each studio produces many movies, but
#   a movie belongs to a single studio.
# - An actor can be in multiple movies.
# - Everything you need to do in this assignment is marked with TODO!
# - Note rubric explanation for appropriate use of external resources.

# Rubric
# 
# There are three deliverables for this assignment, all delivered within
# this repository and submitted via GitHub and Canvas:
# - Generate the models and migration files to match the domain model from hw1.
#   Table and columns should match the domain model. Execute the migration
#   files to create the tables in the database. (5 points)
# - Insert the "Batman" sample data using ruby code. Do not use hard-coded ids.
#   Delete any existing data beforehand so that each run of this script does not
#   create duplicate data. (5 points)
# - Query the data and loop through the results to display output similar to the
#   sample "report" below. (10 points)
# - You are welcome to use external resources for help with the assignment (including
#   colleagues, AI, internet search, etc). However, the solution you submit must
#   utilize the skills and strategies covered in class. Alternate solutions which
#   do not demonstrate an understanding of the approaches used in class will receive
#   significant deductions. Any concern should be raised with faculty prior to the due date.

# Submission
# 
# - "Use this template" to create a brand-new "hw2" repository in your
#   personal GitHub account, e.g. https://github.com/<USERNAME>/hw2
# - Do the assignment, committing and syncing often
# - When done, commit and sync a final time before submitting the GitHub
#   URL for the finished "hw2" repository as the "Website URL" for the 
#   Homework 2 assignment in Canvas

# Successful sample output is as shown:

# Movies
# ======

# Batman Begins          2005           PG-13  Warner Bros.
# The Dark Knight        2008           PG-13  Warner Bros.
# The Dark Knight Rises  2012           PG-13  Warner Bros.

# Top Cast
# ========

# Batman Begins          Christian Bale        Bruce Wayne
# Batman Begins          Michael Caine         Alfred
# Batman Begins          Liam Neeson           Ra's Al Ghul
# Batman Begins          Katie Holmes          Rachel Dawes
# Batman Begins          Gary Oldman           Commissioner Gordon
# The Dark Knight        Christian Bale        Bruce Wayne
# The Dark Knight        Heath Ledger          Joker
# The Dark Knight        Aaron Eckhart         Harvey Dent
# The Dark Knight        Michael Caine         Alfred
# The Dark Knight        Maggie Gyllenhaal     Rachel Dawes
# The Dark Knight Rises  Christian Bale        Bruce Wayne
# The Dark Knight Rises  Gary Oldman           Commissioner Gordon
# The Dark Knight Rises  Tom Hardy             Bane
# The Dark Knight Rises  Joseph Gordon-Levitt  John Blake
# The Dark Knight Rises  Anne Hathaway         Selina Kyle

# Delete existing data, so you'll start fresh each time this script is run.
# Use `Model.destroy_all` code.
# TODO!

# Generate models and tables, according to the domain model.
# TODO!

# Insert data into the database that reflects the sample data shown above.
# Do not use hard-coded foreign key IDs.
# TODO!

# Prints a header for the movies output
puts "Movies"
puts "======"
puts ""

# Query the movies data and loop through the results to display the movies output.
# TODO!

# Prints a header for the cast output
puts ""
puts "Top Cast"
puts "========"
puts ""

# Query the cast data and loop through the results to display the cast output for each movie.
# TODO!

# db/migrate/XXXX_create_movies.rb
class CreateMovies < ActiveRecord::Migration[7.0]
    def change
      create_table :movies do |t|
        t.string :title
        t.integer :year
        t.string :rating
        t.string :studio
        t.timestamps
      end
    end
  end
  
  # db/migrate/XXXX_create_actors.rb
  class CreateActors < ActiveRecord::Migration[7.0]
    def change
      create_table :actors do |t|
        t.string :name
        t.timestamps
      end
    end
  end
  
  # db/migrate/XXXX_create_roles.rb
  class CreateRoles < ActiveRecord::Migration[7.0]
    def change
      create_table :roles do |t|
        t.references :movie, foreign_key: true
        t.references :actor, foreign_key: true
        t.string :character_name
        t.timestamps
      end
    end
  end
  
  # app/models/movie.rb
  class Movie < ApplicationRecord
    has_many :roles
    has_many :actors, through: :roles
  end
  
  # app/models/actor.rb
  class Actor < ApplicationRecord
    has_many :roles
    has_many :movies, through: :roles
  end
  
  # app/models/role.rb
  class Role < ApplicationRecord
    belongs_to :movie
    belongs_to :actor
  end
  
  # db/seeds.rb
  Movie.destroy_all
  Actor.destroy_all
  Role.destroy_all
  
  movies_data = [
    { title: "Batman Begins", year: 2005, rating: "PG-13", studio: "Warner Bros." },
    { title: "The Dark Knight", year: 2008, rating: "PG-13", studio: "Warner Bros." },
    { title: "The Dark Knight Rises", year: 2012, rating: "PG-13", studio: "Warner Bros." }
  ]
  
  actors_data = [
    "Christian Bale", "Michael Caine", "Liam Neeson", "Katie Holmes", "Gary Oldman",
    "Heath Ledger", "Aaron Eckhart", "Maggie Gyllenhaal", "Tom Hardy", "Joseph Gordon-Levitt", "Anne Hathaway"
  ]
  
  roles_data = [
    ["Batman Begins", "Christian Bale", "Bruce Wayne"],
    ["Batman Begins", "Michael Caine", "Alfred"],
    ["Batman Begins", "Liam Neeson", "Ra's Al Ghul"],
    ["Batman Begins", "Katie Holmes", "Rachel Dawes"],
    ["Batman Begins", "Gary Oldman", "Commissioner Gordon"],
    ["The Dark Knight", "Christian Bale", "Bruce Wayne"],
    ["The Dark Knight", "Heath Ledger", "Joker"],
    ["The Dark Knight", "Aaron Eckhart", "Harvey Dent"],
    ["The Dark Knight", "Michael Caine", "Alfred"],
    ["The Dark Knight", "Maggie Gyllenhaal", "Rachel Dawes"],
    ["The Dark Knight Rises", "Christian Bale", "Bruce Wayne"],
    ["The Dark Knight Rises", "Gary Oldman", "Commissioner Gordon"],
    ["The Dark Knight Rises", "Tom Hardy", "Bane"],
    ["The Dark Knight Rises", "Joseph Gordon-Levitt", "John Blake"],
    ["The Dark Knight Rises", "Anne Hathaway", "Selina Kyle"]
  ]
  
  movies = movies_data.map { |data| Movie.create!(data) }
  actors = actors_data.map { |name| [name, Actor.create!(name: name)] }.to_h
  roles_data.each do |movie_title, actor_name, character_name|
    Role.create!(movie: Movie.find_by(title: movie_title), actor: actors[actor_name], character_name: character_name)
  end
  
  # script/report.rb
  puts "Movies"
  puts "======"
  Movie.order(:year).each do |movie|
    puts "#{movie.title.ljust(25)} #{movie.year}  #{movie.rating}  #{movie.studio}"
  end
  
  puts "\nTop Cast"
  puts "========"
  Role.includes(:movie, :actor).order('movies.year').each do |role|
    puts "#{role.movie.title.ljust(25)} #{role.actor.name.ljust(20)} #{role.character_name}"
  end
  
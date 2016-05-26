# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  email      :string           not null
#  created_at :datetime
#  updated_at :datetime
#  country_id :integer          not null
#

class User < ActiveRecord::Base
  belongs_to(
    :country,
    class_name: "Country",
    foreign_key: :country_id,
    primary_key: :id
  )

  has_many(
    :tweets,
    class_name: "Tweet",
    foreign_key: :author_id,
    primary_key: :id
  )
# goal: return a hash with usernames pointing to # of tweets

  # N+1 query. bad!!
  # n+1 queries are the exception to the "don't prematurely optimize" rule.
  # consider n+1 queries to be an error, not just slow.
  def self.usernames_and_tweet_counts_n_plus_one_version
    tweet_counts = {} #keys will be users and values will be tweet counts

    User.all.each do |user| # .all did not execute query. .each did!
      tweet_counts[user.name] = user.tweets.length #runs a new query each time!
    end

    tweet_counts
  end



  # two queries version using .includes
  def self.usernames_and_tweet_counts_two_queries_version
    tweet_counts = {}

    # parameter we pass in to .includes is an association. Can be belongs_to or has_many, or has_many :through. etc.
    # order of ActiveRecord chaining methods does not matter unless they force execution.
    # this could be .all.includes or .includes.all. Since .each is the one that actually forces execution.

    User.includes(:tweets).all.each do |user| # this runs the queries for User.all AND for all those users' tweets.
      tweet_counts[user.name] = user.tweets.length #this does not hit db again since tweets were already loaded.
    end

    # you can also use .includes to chain multiple associations.
    # example: Country.includes(users: :tweets)
    # would include all of countries' users, and all those users' tweets.

    tweet_counts
  end



  # but we can do even better! no need to instantiate Tweet objects like we're doing in the above version.
  # all we care about regarding the tweets is how many there are.
  # Let's make it one query, using ActiveRecord Relations methods.

  # #here's how we'd build this query in SQL.
  # <<-SQL
  #   SELECT
  #     users.name, COUNT(tweets.id)
  #   FROM
  #     users
  #   LEFT OUTER JOIN
  #     tweets
  #   ON
  #     users.id = tweets.user_id
  #   GROUP BY
  #     users.id
  # SQL


  #let's do it in ActiveRecord!

  def self.usernames_and_tweet_counts
    tweet_counts = {}

    users = User
      .select("users.*, COUNT(tweets.id) AS tweet_count")
      .joins(:tweets)
      .group(:id)

    users.each do |user|
      tweet_counts[user.name] = user.tweet_count
    end

    tweet_counts

  end

  # chaining .count on to our query is not what we want; it would modify the entire query
  #   so the whole query just returned a #. if we added .count in here, what it would return is the # of users.
  #   since what we care about is the COUNT(tweets), we put it in the SELECT line instead of using the AR method.


  # we'll get a reader method for each column returned by our query. so we can call Daniel.tweet_count, since
  #   we've aliased our COUNT(tweets.id) column to be "tweet_count".
  #   makes sense to alias column names so names make semantic sense for your use later.


  # chaining method calls on new lines like this doesn't change how they work, just much easier to read.

  # if we wanted to get all users, even those who haven't tweeted yet, we'd use a left outer join on the tweets table.
  #   check the guides for how to do .joins with a left outer join (hint: pass it a string!)

  # GROUP BY : a big "smush". Since we're grouping by users.id, user information doesn't collapse
  #   and we'll be able to still access users.name.
  #   You should GROUP BY the main thing (users.id instead of tweets.user_id).


  # Aside: when should you GROUP BY multiple columns? when you care about the combo of those groups.
  #   e.g., if you had a "tweet type" -- food vs. emotional tweet; you could GROUP BY users.id and tweets.type
  #   this would result with two different groups per user -- we could get TOMMY FOOD TWEETS and also TOMMY EMOTIONS tweets
  #   but don't worry about this! Just understand how GROUP BY works for one group.


end

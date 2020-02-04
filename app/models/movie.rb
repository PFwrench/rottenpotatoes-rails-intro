class Movie < ActiveRecord::Base

    def Movie.get_ratings
        ['G', 'PG', 'PG-13', 'R']
    end

    def Movie.with_ratings(ratings)
        if ratings.length > 0
            return Movie.all.select { |m| ratings.key?(m.rating) }
        else
            return Movie.all
        end
    end
end

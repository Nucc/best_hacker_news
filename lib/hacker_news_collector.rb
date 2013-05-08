require "net/http"
require "json"
require "mail"

require_relative "leaderboard"

class HackerNewsCollector

  def self.send_statistics_to(email)
    news = self.new
    mail = Mail.new do
      from    "no-reply@email-example.tld"
      to      email
      subject "Hacker news statistics"
      body    news.body
    end
    $stderr.puts "The following mail has been sent:"
    $stderr.puts mail.to_s


    # More info about configuration: https://github.com/mikel/mail
    mail.delivery_method :sendmail
    mail.deliver
  end

  def initialize
    @leader_board = Leaderboard.new("hacker_news")
    @news_items = {}
  end

  def prepare_statistics
    site_content["items"].each do |v|
      @leader_board[v["id"].to_s] = v["points"]
      @news_items[v["id"].to_s] = v
    end
  end

  def site_content
    pages = "http://api.ihackernews.com/page"
    resp = Net::HTTP.get_response(URI.parse(pages))
    JSON.parse(resp.body)
  end

  def body
    prepare_statistics

    body  = "Mean: #{@leader_board.mean}\n"
    body += "Median: #{@leader_board.median}\n"
    body += "Mode: #{@leader_board.mode}\n\n"
    body += "Interesting posts:\n\n"
    @leader_board.values_over_the_median.reverse.each do |post_id|
      @news_items[post_id.to_s]
      post = @news_items[post_id.to_s]
      body += "#{post['title']} [points: #{post['points']}] (#{post['url']})\n\n"
    end
    body
  end

end

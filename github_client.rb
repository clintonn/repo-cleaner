require "dotenv/load"
require "httparty"
require "pry"

class GithubClient
  include HTTParty
  base_uri "https://api.github.com/"
  def initialize(opts = {})
    @auth = {
      username: ENV["GITHUB_USERNAME"],
      password: ENV["GITHUB_PAT"]
    }
  end

  def fetch_repos
    res = self.class.get("/users/#{ENV["GITHUB_USERNAME"]}/repos", basic_auth: @auth)
    # If paginated
    pages = res.headers["link"] ? res.headers["link"].split(", ").last.match(/page=(\d+)/).to_a.last.to_i : 1
    repos = []
    1.upto(pages) do |n|
      puts "Processing page #{n}"
      repos << self.class.get("/user/repos?page=#{n}", basic_auth: @auth)
    end
    repos = yield(repos.flatten) if block_given?
  end

  def find_fs_repos
    fetch_repos {|repos| repos.select{|r| is_fs_repo?(r)}}
  end

  def is_fs_repo?(repo)
    repo["owner"]["id"] == ENV["GITHUB_USER_ID"].to_i &&
    !repo["private"] &&
    repo["name"].match(ENV["FS_MATCHER"])
  end

  def delete_repos(repos)
    repos.each do |repo|
      res = self.class.delete("/repos/#{ENV["GITHUB_USERNAME"]}/#{repo["name"]}", basic_auth: @auth)
      if res && res.headers["status"] == "204 No Content"
        puts "#{repo["name"]} SUCCESSFULLY DELETED!"
      else
        puts "COULD NOT DELETE #{repo["name"]} - #{repo["html_url"]}"
      end
    end
  end
end
require_relative "./github_client"

gc = GithubClient.new
repos = gc.find_fs_repos
puts repos.map{|r| r["name"]}
puts ">>>>>>>>>>>>>>>>>> PLEASE CONFIRM YOU WANT TO DELETE THESE REPOS (y/n)"
print "> "
input = gets.chomp.downcase
if input == "y"
  gc.delete_repos(repos)
elsif input != "n"
  puts "Invalid response"
end
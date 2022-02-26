class GithubService
  def self.conn
    Faraday.new("https://api.github.com")
  end

  def self.repository#(user, repo)
    # conn doesn't need class name specified
    response = conn.get("/repos/mcharrod/little-esty-shop")

    # this is more dynamic
    # response = conn.get("/repos/#{user}/#{repo}")

    JSON.parse(response.body, symbolize_names: true)
  end

  # service > facade > poro > controller > view
end

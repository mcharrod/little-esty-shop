class GithubFacade
  def self.repository
    payload = GithubService.repository
    Repository.new(payload)
    # payload.map do |result|
    #   Repository.new(result)
    # end
  end
end

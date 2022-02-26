require 'rails_helper'

RSpec.describe 'github request' do
  it 'receives success response' do

    wip = GithubService.repository
    # test = JSON.parse(response.body, symbolize_names: true)

    wip[:name]

    binding.pry
  end
end

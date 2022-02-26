class Repository
  attr_reader :name

  def initialize(data)
    @name = data[:name]
    # add more attributes as needed
  end
end

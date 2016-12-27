class Semble

  def initialize(configuration)
    @configuration = configuration
  end

  def assemble(*version)

  end

  def assemble_all

  end

  private
  def get_source_repository
    load_repository unless @repository
    @repository
  end

  def load_repository
    @configuration.semble
  end
end
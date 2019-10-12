# precompile issue workaround http://stackoverflow.com/a/24887827/38753
module Precompile
  # Public: ignore the following block during rake assets:precompile
  def self.ignore
    unless ARGV.any? { |e| e == 'assets:precompile' }
      yield
    else
      line = caller.first
      puts "**** Ignoring line '#{line}' during precompile"
    end
  end
end
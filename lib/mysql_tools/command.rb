module MysqlTools
  class Command
    def self.pre(global, options, args)
      verbose "Command, pre check."
      true
    end

    def initialize(global, options, args)
      @global, @options, @args = global, options, args
    end
  end
end

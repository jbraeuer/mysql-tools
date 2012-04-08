module MysqlTools

  class Backup
    def self.pre(global, options, args)
      verbose "Backup command, pre check."
      return false if global[:username].nil? or global[:password].nil? or global[:host].nil?
      return true
    end

    def initialize(global, options, arg)
    end
  end
end

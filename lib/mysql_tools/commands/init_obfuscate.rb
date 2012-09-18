desc "Initialize obfuscate file"
command :initobfuscate do |c|

  c.desc "Output filename"
  c.arg_name "FILENAME"
  c.default_value '~/.mysql-tools.obfuscate'
  c.flag [:'obfuscate-file']

  c.action do |global,command,args|
    MysqlTools::InitObfuscate.new(global, command,args).run
  end
end

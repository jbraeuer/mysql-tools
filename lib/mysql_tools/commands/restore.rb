desc "Restore a database dump"
long_desc <<-EOS
  	Restore a database dump from file.
  	EOS
arg_name "dump_file"
command :restore do |c|

  c.desc "Database"
  c.arg_name "DB"
  c.default_value 'test'
  c.flag [:db]

  c.desc "Dont create DB user"
  c.switch [:'no-user']

  c.desc "DB Username"
  c.arg_name "USER"
  c.default_value 'user'
  c.flag [:'db-username']

  c.desc "DB Password"
  c.arg_name "PASSWORD"
  c.default_value 'password'
  c.flag [:'db-password']

  c.action do |global,command,args|
    MysqlTools::Restore.new(global, command,args).run
  end
end

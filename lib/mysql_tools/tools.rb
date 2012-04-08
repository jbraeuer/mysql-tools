def log(msg)
  puts msg
end

def setup_logging(global)
  if global[:verbose]
    puts "Verbose mode."
    def verbose(msg); log msg; end
  else
    def verbose(_); end
  end
end

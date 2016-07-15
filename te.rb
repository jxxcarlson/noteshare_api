exec  "ruby -I'Lib:spec' #{ARGV[0]} -v" if ARGV.count == 1
exec  "ruby -I'Lib:spec' #{ARGV[0]} -v -n /#{ARGV[1]}/" if ARGV.count == 2



rm -fr tmp/pids/server.pid
bundle exec rails db:migrate
bundle exec rails s -b 0.0.0.0 -p 4444
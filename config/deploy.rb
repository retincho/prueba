# config valid only for Capistrano 3.1
lock '~> 3.16.0'



set :application, 'prueba'
set :repo_url, 'git@github.com:retincho/prueba.git' 
set :ssh_options, { :forward_agent => true }
#set :scm, :git
set :branch, "master"
set :deploy_via, :copy
set :user, 'deploy'
set :rvm_ruby_version, '2.7.2'



# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/deploy/workspace/prueba'
set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}


namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end


namespace :config do
  task :symlink do
     on roles(:app) do
      # execute :ln, "-s /home/deploy/workspace/prueba/shared/master.key  /home/deploy/workspace/prueba/config/master.key"
     end
  end
end

after 'deploy:symlink:shared', 'config:symlink'



namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

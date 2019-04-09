module Jinda_todo
  module Generators
    class InstallGenerator < Rails::Generators::Base

      desc "Install Jinda Todo to existing Jinda app "
      def self.source_root
        File.dirname(__FILE__) + "/templates"
      end

      def settup_gems
        gem 'jquery-ui-rails'
        gem 'jquery-datatables-rails', github: 'rweng/jquery-datatables-rails'
      end

      def setup_routes
        route "resources :todos"
        route "get '/todos/my' => 'todos/my'"
        route "get '/todos/ex' => 'todos/ex'"
        route "get '/todos/complete' => 'todos#complete'"
        route "get '/todos/my/destroy' => 'todos#destroy'"
        route "get '/todos/ex/destroy' => 'todos#destroy'"
        route "get '/todos/destroy' => 'todos#destroy'"
      end

      def setup_app
        inside("app/views/layouts") { run "mv application.haml application.haml.bak" }
        inside("app/views/layouts") { run "mv lte lte.bak" }
        inside("app/assets") { run "mv jinda_assets ../../tmp/cache" }
        inside("app/assets") { run "mv javascripts ../../tmp/cache" }
        inside("app/assets") { run "mv stylesheets ../../tmp/cache" }
        directory "app/assets/jinda_assets"
        directory "app/views/layouts/lte"
        directory "app/datatables"
        directory "app/views/todos"
        directory "app/models"
      end

      def copy_assets_and_app
        copy_file "application.js","app/assets/javascripts/application.js"
        copy_file "todos.coffee","app/assets/javascripts/todos.coffee"
        copy_file "jinda-todo.js","app/assets/javascripts/jinda-todo.js"
        copy_file "todo-my.js","app/assets/javascripts/todo-my.js"
        copy_file "todo-ex.js","app/assets/javascripts/todo-ex.js"
        copy_file "application.css.scss","app/assets/stylesheets/application.css.scss"
        copy_file "jinda-todo.css.scss","app/assets/stylesheets/jinda-todo.css.scss"
        copy_file "application.haml","app/views/layouts/application.haml"
        copy_file "_head.html.erb","app/views/layouts/_head.html.erb"
        copy_file "index.mm","app/jinda/index.mm"
        copy_file "todos_controller.rb","app/controllers/todos_controller.rb"
        copy_file "todo.rb","app/models/todo.rb"
        copy_file "todos_datatable.rb","app/datatables/todos_datatable.rb"
        copy_file "todo-seed.rb","todo_seed.rb"
      end

      def finish        
        puts "------------------------------------------------\n"
        puts "                                                \n"
        puts "  Jinda Todo installation finished             \n"
        puts "  Note: last jinda_assets was move to tmp/cache \n"
        puts "  To delte run the following command            \n"
        puts "                                                \n"
        puts "rake tmp:cache:clear                            \n"
        puts "------------------------------------------------\n"
      end
    end
  end
end


class TodosController < ApplicationController
  before_action :load_todo, only: [:show]
  before_action :load_edit_todo, only: [:edit, :destroy, :complete]
  helper_method :sort_column, :sort_direction

  def index
    # @todos = Todo.desc(:created_at).page(params[:page]).per(10)
    @todos = @my_todo
    respond_to do |format|
      format.html
      format.json { render json: TodosDatatable.new(view_context) }
    end
  end

  def my
    # @todos  = Todo.where(user_id: current_ma_user)
    create_todo_user 
    @page_title = 'My Todo'
    @todos = @my_todo.where(user_id: current_ma_user)
  end
  
  def ex
    # @todos  = Todo.where(user_id: current_ma_user)
    create_todo_user 
    @page_title = 'My Todo'
    @todos = @my_todo.where(user_id: current_ma_user)
  end

  def create
    create_todo_user 
    @todo = @my_todo.new(
      title: $xvars["form_todo"]["title"],
      completed: $xvars["form_todo"]["completed"],
      due: $xvars["form_todo"]["due"],
      user_id: $xvars["user_id"])
    @todo.save!
  end

  def show
  end

  def complete
    if current_ma_user.role.upcase.split(',').include?("A") || current_ma_user == @todo.user
      @todo.completed = !@todo.completed
      @todo.save!
    end
    redirect_to :action => 'my'
  end

  def destroy
    if current_ma_user.role.upcase.split(',').include?("A") || current_ma_user == @todo.user
      @todo.destroy
    end
    # redirect_to '/todos/my'
    redirect_to :action => 'my'
  end

  private

  def create_todo_user
    if $user_id != ''
      my_todo_file   = "todo_m#{$user_id.to_s}"
      my_model_file  = "TodoM#{$user_id.to_s}"
      model_file_location = "#{Rails.root}/app/models/todo/#{my_todo_file}.rb"
      if File.exist?(model_file_location)
        @my_todo =  "Todo::TodoM#{$user_id.to_s}".constantize
      else
        system "rails generate model Todo::#{my_model_file} --parent Todo --no-test-framework"
        @my_todo =  "Todo::TodoM#{$user_id.to_s}".constantize
      end
    else
      @my_todo = Todo
    end
  end

  def load_edit_todo
    create_todo_user
    #@todo = Todo.find(params.require(:todo_id))
    @todo = @my_todo.find(params.require(:todo_id))
  end

  def load_todo
    create_todo_user
    #@todo = Todo.find(params.permit(:id))
    @todo = @my_todo.find(params.permit(:id))
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def sort_column
    #"Todo::TodoM#{$xvars["user_id"].to_s}".constantize.attrubute_names.inclue?(params[:sort]) ? params[:sort] : "name"
    "Todo::TodoM#{$user_id.to_s}".constantize.attrubute_names.inclue?(params[:sort]) ? params[:sort] : "name"
  end

end

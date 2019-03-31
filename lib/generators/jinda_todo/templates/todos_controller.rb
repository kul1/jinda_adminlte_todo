class TodosController < ApplicationController
  before_action :load_todo, only: [:show]
  before_action :load_edit_todo, only: [:edit, :destroy, :complete]
  helper_method :sort_column, :sort_direction

  def index
    # @todos = Todo.desc(:created_at).page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.json { render json: TodosDatatable.new(view_context) }
    end
  end

  def my
    @todo = Todo.new(
      title: ""
    )
    @todos  =Todo.where(user_id: current_ma_user)
    @page_title = 'My Todo'
  end

  def create
    @todo = Todo.new(
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
  
  def load_edit_todo
    @todo = Todo.find(params.require(:todo_id))
  end
  
  def load_todo
    @todo = Todo.find(params.permit(:id))
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def sort_column
    Todo.attribute_names.include?(params[:sort]) ? params[:sort] : "name"
  end
end

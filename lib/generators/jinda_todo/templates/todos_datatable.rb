class TodosDatatable
  delegate :params, :link_to, to: :@view

  def initialize(view)
	@view = view
  end

  def as_json(options = {})
	{
	  sEcho: params[:sEcho].to_i,
	  iTotalRecords: todos.count,
	  iTotalDisplayRecords: todos.total_count,
	  aaData: data
	}
  end

  private

  def data
  	todos.map do |todo|
    	[
			todo.completed,
      		link_to(todo.title, "show"),
            #todo.title,
      		todo.due
    	]
	end
  end

  def todos
    @todos ||= fetch_todos
  end

  def fetch_todos
    # get Todo file from todos_controller
    # @todo = Rails.cache.read("todo_cache")
    # todos = $todos
    if $user_id != ''
      todos = "Todo::TodoM#{$user_id.to_s}".constantize 
      flash.now[:error] = "Found User File"
      # Guest User which no id
      # Display for sample
      todos = Todo
    end
    todos = todos.order("#{sort_column} #{sort_direction}")
    todos = todos.page(page).per(per_page)
    if params[:sSearch].present?
      #todos = todos.where("name like :search or category like :search", search: "%#{params[:sSearch]}%")
      todos = todos.where(title: /#{params[:sSearch]}/) 
    end
    todos
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[completed title due ]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

end

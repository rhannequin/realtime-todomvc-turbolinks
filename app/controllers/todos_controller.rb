class TodosController < ApplicationController
  before_action :set_todo, only: [:update, :destroy]

  def index
    @todos = Todo.all
  end

  def create
    @todo = Todo.new(todo_params)

    if @todo.save
      redirect_to todos_url, notice: 'Todo was successfully created.'
    else
      render :index
    end
  end

  def update
    respond_to do |format|
      if @todo.update(todo_params)
        redirect_to todos_url, notice: 'Todo was successfully updated.'
      else
        render :index
      end
    end
  end

  def destroy
    @todo.destroy
    redirect_to todos_url, notice: 'Todo was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def todo_params
      params.require(:todo).permit(:title, :is_completed)
    end
end

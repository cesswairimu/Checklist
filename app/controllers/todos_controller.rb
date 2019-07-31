class TodosController < ApplicationController
  before_action :get_todo, only: [:show, :update, :destroy]

  def create
    @todo = Todo.create!(todo_params)
    json_response(@todo, :created)
  end

  def index
    @todos = Todo.all
    json_response(@todos)
  end

  def show
    json_response(@todo)
  end

  def update
    @todo.update(todo_params)
    head :no_content
  end

  def destroy
    @todo.destroy
    head :no_content
  end

  private

  def todo_params
    params.permit(:title, :created_by)
  end

  def get_todo
    @todo = Todo.find(params[:id])
  end
end

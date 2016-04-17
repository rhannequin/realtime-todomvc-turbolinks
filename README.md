## Realtime TodoMVC with Rails 5, Action Cable and Turbolinks 5

```sh
$ rails new realtime-todomvc-turbolinks
$ cd realtime-todomvc-turbolinks
$ bundle install
$ bundle exec rails g scaffold Todo \
  title:string is_completed:boolean \
  --skip-test-framework --no-helper --no-assets --skip-jbuilder
$ rm app/views/todos/edit.html.erb app/views/todos/show.html.erb \
  app/views/todos/new.html.erb app/views/todos/_form.html.erb
$ bundle exec rails db:migrate
```

Remove useless actions, redirects, formats, routes and view links:

```ruby
# app/controllers/todos_controller.rb

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

```

```ruby
# config/routes.rb

Rails.application.routes.draw do
  resources :todos, only: [:index, :create, :update, :destroy], path: ''
  root 'todos#index'
end
```

```erb
<p id="notice"><%= notice %></p>

<h1>Todos</h1>

<table>
  <thead>
    <tr>
      <th>Title</th>
      <th>Is completed</th>
      <th></th>
    </tr>
  </thead>

  <tbody>
    <% @todos.each do |todo| %>
      <tr>
        <td><%= todo.title %></td>
        <td><%= todo.is_completed %></td>
        <td><%= link_to 'Destroy', todo, method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
    <% end %>
  </tbody>
</table>
```

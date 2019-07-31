require 'rails_helper'

RSpec.describe 'Todos Api', type: :request do
  let!(:todos) { create_list(:todo, 10) }
  let(:todo_id) { todos.first.id }

  describe 'GET /todos' do
    before { get '/todos' }

    it 'returns todos' do
      expect(json).not_to be_empty
      expect(json).size eq(10)
    end

    it 'return status of 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /todos/:id' do
    before { get "/todos/#{todo_id}" }

    context 'when record exists' do
      it 'returns first todo'do
        expect(json).not_to be_empty
        expect(json['id']).to eq(todo_id)
      end

      it 'returns a status of 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when record does not exist' do
      let(:todo_id) { 100 }

      it 'returns status of 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Coudn't find Todo/)
      end
    end
  end

  describe 'POST /todos' do
    let(:valid_attributes) { { title: 'Finish part 1', created_by: '1'  } }

    context 'when request is valid' do
      before { post '/todos', params: valid_attributes }

      it 'creates a todo' do
        expect(json['title']).to eq('Finish part 1')
      end

      it 'returns a status of 201' do
        expect(response).to  have_http_status(201)
      end
    end

    context 'when request is invalid' do
      let(:invalid_attributes) { { title: 'Apple' } }
      before { post '/todos', params: invalid_attibutes }

      it 'returns status 422' do
        expect(response).to have_http_status(422)
      end

      it 'return a failure message' do
        expect(response.body).to match(/Validation failed: Created by can't be blank/)
      end
    end
  end

  describe 'PUT /todos/:id' do
    let(:valid_attributes) { { title: 'Elixir' } }

    context 'when the record exists' do
      before { put  "/todos/#{todo_id}", params: valid_attributes }

      it 'updates the record' do
        # expect(json['title']).to eq('Elixir')
        expect(json.body).to be_empty
      end

      it 'returns a status off 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /todos/:id' do
    before { delete "/todos/#{todo_id}" }

    it 'return a status of 204' do
      expect(response).to have_http_status(204)
    end
  end
end

require 'rails_helper'

RSpec.describe 'Items Api', type: :request do
  let!(:todo) { create(:todo) }
  let!(:items) { create_list(:item, 20, todo_id: todo.id) }
  let(:todo_id) { todo.id }
  let(:id) { items.first.id }

  describe 'GET /todos/:todo_id/items' do
    before { get "/todos/#{todo_id}/items" }

    context 'when todo exists'do
      it 'return a status of 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all items' do
        expect(json).not_to be_empty
        expect(json.size).to eq(20)
      end
    end

    context 'when todo does not exist' do
      let(:todo_id) { 100 }

      it 'return status of 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns an error message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  describe 'GET /todos/:todo_id/items/:item_id' do
    before { get "/todos/#{todo_id}/items/#{id}" }

    context 'When item exists' do
      it 'returns a status of 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns an item' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when item does not exist' do
      let(:id) { 100 }
      it 'returns a status of 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  describe 'POST /todos/:todo_id/items' do
    let(:valid_attributes) { { name: 'Mattern maching', done: false  } }

    context 'with valid attributes' do
      before { post "/todos/#{todo_id}/items", params: valid_attributes }

      it 'returns a status of 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when request has invalid attributes' do
      before { post "/todos/#{todo_id}/items", params: {} }

      it 'returns status 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

    describe 'PUT /todos/:tod_id/item/:item_id' do
      let(:valid_attr) { { name: 'Immutable' } }
      before { put "/todos/#{todo_id}/items/#{id}", params: valid_attr }

      context 'when item exists' do
        it 'returns a status of 204' do
          expect(response).to have_http_status(204)
        end

        it 'updates the item' do
          item = Item.find id
          expect(item.name).to match(/Immutable/)
        end
      end

      context 'when item does not exist' do
        let(:id) {100}

        it 'returns a status of 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a failure message' do
          expect(response.body).to match(/Couldn't find Item/)
        end
      end
    end

    describe 'DELETE /todos/:todo_id/items/item_id' do
      before { delete "/todos/#{todo_id}/items/#{id}" }

      it 'returns a status of 204' do
        expect(response).to have_http_status(204)
      end
    end
end

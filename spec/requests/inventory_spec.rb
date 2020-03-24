require 'rails_helper'

RSpec.describe 'Vendo-O-Matic API', type: :request do
  let!(:items) do
    [create(:item, name: 'Coca-cola'),
     create(:item, name: 'Pepsi'),
     create(:item, name: 'Mountain Dew')]
  end

  def add_coin(quantity)
    put '/', params: { 'coin': quantity }
  end

  describe 'Putting coins into the machine' do
    context 'PUT /' do
      before { expect { add_coin('1') }.to change { Coin.count }.by(1) }

      it 'adds coins to the machine' do
        expect(Coin.first.quantity).to eq(1)
      end

      it 'responds with 204' do
        expect(response.code).to eq('204')
      end

      it 'response header includes X-Coin' do
        expect(response.header['X-Coin']).to eq('1')
      end

      context 'Adding multiple coins into the machine' do
        it 'increases the coin quantity' do
          3.times { add_coin('1') }
          expect(Coin.first.quantity).to eq(4)
        end
      end
    end
  end

  describe 'Putting anything other than coins into the machine' do
    context 'PUT /' do
      before { put('/', params: { 'bitcoin': '1' }) }

      it 'responds with 400' do
        expect(response.code).to eq('400')
      end

      it 'response header includes X-Coin' do
        expect(response.header['X-Coin']).to eq(nil)
      end
    end
  end

  describe 'Returning coins from the machine' do
    before { 3.times { add_coin('1') } }

    context 'DELETE /' do
      before { delete('/') }

      it 'removes coins from the machine' do
        expect(response.header['X-Coin']).to eq(3)
      end

      it 'responds with 204' do
        expect(response.code).to eq('204')
      end
    end
  end

  describe 'View available items to purchase' do
    context 'GET /inventory' do
      before { get('/inventory') }

      it 'returns available items' do
        expect(JSON.parse(response.body)[0]).to include(
          "name" => 'Coca-cola', "quantity" => 5, "price" => 2
        )
        expect(JSON.parse(response.body)[1]).to include(
          "name" => 'Pepsi', "quantity" => 5, "price" => 2
        )
        expect(JSON.parse(response.body)[2]).to include(
          "name" => 'Mountain Dew', "quantity" => 5, "price" => 2
        )
      end

      it 'responds with 200' do
        expect(response.code).to eq('200')
      end
    end
  end

  describe 'Purchasing an item' do
    context 'PUT /inventory/:id' do
      context 'Item is in stock and sufficient funds are available' do
        before do
          add_coin('3')
          put("/inventory/#{items.first.id}")
        end

        it 'returns number of items purchased' do
          expect(JSON.parse(response.body)).to include("quantity" => "1")
        end

        it 'responds with 200' do
          expect(response.code).to eq('200')
        end

        context 'Response Header' do
          it 'response header includes X-Coin' do
            expect(response.header['X-Coin']).to eq(1)
          end

          it 'response header includes X-Inventory-Remaining' do
            expect(response.header['X-Inventory-Remaining']).to eq(4)
          end
        end
      end

      context 'When the item is out of stock' do
        before do
          add_coin('3')
          items.first.update_attribute(:quantity, 0)
          put("/inventory/#{items.first.id}")
        end

        it 'responds with 404' do
          expect(response.code).to eq('404')
        end

        context 'Response Header' do
          it 'response header includes X-Coin' do
            expect(response.header['X-Coin']).to eq(3)
          end
        end
      end

      context 'When insufficent funds' do
        before do
          add_coin('1')
          put("/inventory/#{items.first.id}")
        end

        it 'responds with 403' do
          expect(response.code).to eq('403')
        end

        context 'Response Header' do
          it 'response header includes X-Coin' do
            expect(response.header['X-Coin']).to eq(1)
          end
        end
      end
    end
  end
end

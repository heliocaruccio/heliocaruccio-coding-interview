require 'rails_helper'

RSpec.describe "Users", type: :request do

  RSpec.shared_context 'with multiple companies' do
    let!(:company_1) { create(:company) }
    let!(:company_2) { create(:company) }

    before do
      5.times do
        create(:user, company: company_1)
      end
      5.times do
        create(:user, company: company_2)
      end
    end
  end

  describe "#index" do
    let(:result) { JSON.parse(response.body) }

    context 'when fetching users by company' do
      include_context 'with multiple companies'

      it 'returns only the users for the specified company' do
        get company_users_path(company_1)

        expect(result.size).to eq(company_1.users.size)
        expect(result.map { |element| element['id'] } ).to eq(company_1.users.ids)
      end
    end

    context 'when fetching users by like username' do
      include_context 'with multiple companies'
      it 'returns only the users for the specified like' do
        username_like = Company.first.users.first.username[0..5]
        #users_like_count = Company.first.users.where("users.username LIKE '%#{username_like}%'").map{|d|}
        users_like_usernames = Company.first.users.where("users.username LIKE '%#{username_like}%'").map{|d| d.username}
        get company_users_path(company_1, :params => { :username => username_like})
        expect(result.map{|d| d['username'] }).to eq(users_like_usernames)
      end
    end

    context 'when fetching all users' do
      include_context 'with multiple companies'

      it 'returns all the users' do

      end
    end
  end
end

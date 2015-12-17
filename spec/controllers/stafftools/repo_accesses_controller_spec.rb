require 'rails_helper'

RSpec.describe Stafftools::RepoAccessesController, type: :controller do
  let(:user)         { GitHubFactory.create_owner_classroom_org.users.first }
  let(:organization) { user.organizations.first                             }

  let(:student)     { GitHubFactory.create_classroom_student                       }
  let(:repo_access) { RepoAccess.create(user: student, organization: organization) }

  before(:each) do
    sign_in(user)
  end

  after do
    RepoAccess.destroy_all
  end

  describe 'GET #show', :vcr do
    context 'as an unauthorized user' do
      it 'returns a 404' do
        expect { get :show, id: repo_access.id }.to raise_error(ActionController::RoutingError)
      end
    end

    context 'as an authorized user' do
      before do
        user.update_attributes(site_admin: true)
        get :show, id: repo_access.id
      end

      it 'succeeds' do
        expect(response).to have_http_status(:success)
      end

      it 'sets the GroupAssignment' do
        expect(assigns(:repo_access).id).to eq(repo_access.id)
      end
    end
  end
end

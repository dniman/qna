require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:answer) { create(:answer) }
    let(:comment) { build(:comment, commentable: question, user: user) }

    let(:question_params) do
      ActiveSupport::HashWithIndifferentAccess.new( 
        question_id: question.id,
        comment: comment.attributes,
        commentable_type: 'question'
      )
    end
    
    let(:answer_params) do
      ActiveSupport::HashWithIndifferentAccess.new( 
        answer_id: answer.id,
        comment: comment.attributes,
        commentable_type: 'answer'
      ) 
    end

    context 'question comment' do
      subject { post :create, params: question_params, format: :json }
      let(:body) { JSON.parse(response.body) }

      context 'when user authenticated' do
        before { sign_in(user) }

        context 'with valid attributes' do
          it 'saves a new question comment to the database' do
            expect { subject }.to change(Comment, :count).by(1)
          end
          
          it 'renders json' do
            subject

            expect(body["body"]).to eq(comment.body)
          end
          
          it "transmits comment" do
            expect { subject }.to have_broadcasted_to("comments").with { |data|
              expect(data[:body]).to eq(comment.body)
            }
          end
          
        end

        context 'with invalid attributes' do
          let(:comment) { build(:comment, :invalid, commentable: question, user: user) }

          it 'does not save the comment' do
            expect { subject }.to_not change(Comment, :count)
          end
          
          it 'renders json' do
            subject

            expect(body["errors"]).to eq(["Body can't be blank"])
          end
        end
      end

      context 'when user not authenticated' do
        it '401' do
          subject
          expect(response).to have_http_status(401)
        end
          
        it 'does not save the comment' do
          expect { subject }.to_not change(Comment, :count)
        end
      end
    end

    context 'answer comment' do
      subject { post :create, params: question_params, format: :json }
      let(:body) { JSON.parse(response.body) }

      context 'and user authenticated' do
        before { sign_in(user) }

        context 'with valid attributes' do
          it 'saves a new comment to the database' do
            expect { subject }.to change(Comment, :count).by(1)
          end

          it 'renders json' do
            subject
            
            expect(body["body"]).to eq(comment.body)
          end

          it "transmits comment" do
            expect { subject }.to have_broadcasted_to("comments").with { |data|
              expect(data[:body]).to eq(comment.body)
            }
          end
        end

        context 'with invalid attributes' do
          let(:comment) { build(:comment, :invalid, commentable: question, user: user) }

          it 'does not save the comment' do
            expect { subject }.to_not change(Comment, :count)
          end

          it 'renders json' do
            subject

            expect(body["errors"]).to eq(["Body can't be blank"])
          end
        end
      end

      context 'when user not authenticated' do
        it '401' do
          subject

          expect(response).to have_http_status(401)
        end
          
        it 'does not save the comment' do
          expect { subject }.to_not change(Comment, :count)
        end
      end
    end
  end
end

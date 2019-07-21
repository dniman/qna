class AddColumnUserIdToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_reference :answers, :user, index: true, null: false
  end
end

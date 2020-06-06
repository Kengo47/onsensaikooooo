require 'rails_helper'

RSpec.describe 'User', type: :system do
  it '新規登録ページの要素検証' do
    visit signup_path

  end
end
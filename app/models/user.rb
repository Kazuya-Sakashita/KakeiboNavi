# frozen_string_literal: true

class User < ApplicationRecord
  has_many :incomes, dependent: :destroy
  has_many :expenses, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end

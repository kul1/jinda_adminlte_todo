# encoding: utf-8
class Todo
  include Mongoid::Document
  # jinda begin
  include Mongoid::Timestamps
  field :title, :type => String
  field :completed, :type => Boolean
  belongs_to :user, :class_name => "Jinda::User"
  field :due, :type => String
  index({ title: 1 }, { unique: false, name: "title_index" })
  # jinda end
end

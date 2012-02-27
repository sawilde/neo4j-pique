class Tag < ActiveRecord::Base
  include Neoid::Node

  has_many :likes
  has_many :tags, :through => :likes

  def to_neo
    neo_properties_to_hash(%w( name ))
  end

  class << self

    def get_tag_by_name(name)
      Tag.where(:name => name).first
    end

    def create_or_update_tag(tagdata)
    
      tag = Tag.get_tag_by_name(tagdata[:name])
      
      if tag.nil?
        tag = Tag.new
        tag.name = tagdata[:name]      
      end
          
      tag.save
      
      tag
    end

  end

end

# frozen_string_literal: true

class TagService
  def find_all_tags
    Tag.all
  end

  def find_tag(id)
    Tag.find(id)
  end

  def create_tag(params)
    Tag.create!(params)
  end

  def update_tag(id, params)
    tag = Tag.find(id)
    tag.update!(params)
    tag
  end

  def destroy_tag(id)
    Tag.find(id).destroy
  end
end

# frozen_string_literal: true

class Api::V1::TagsController < Api::V1::BaseController
  def index
    tags = service.find_all_tags.page(params[:page]).per(params[:per_page] || 10)
    render json: {
      status: "success",
      data: TagBlueprint.render_as_hash(tags),
      meta: {
        current_page: tags.current_page,
        next_page: tags.next_page,
        prev_page: tags.prev_page,
        total_pages: tags.total_pages,
        total_count: tags.total_count
      }
    }, status: :ok
  end

  def show
    tag = service.find_tag(params[:id])
    render json: { status: "success", data: TagBlueprint.render_as_hash(tag) }, status: :ok
  end

  def create
    tag = service.create_tag(tag_params)
    render json: { status: "success", data: TagBlueprint.render_as_hash(tag) }, status: :created
  end

  def update
    tag = service.update_tag(params[:id], tag_params)
    render json: { status: "success", data: TagBlueprint.render_as_hash(tag) }, status: :ok
  end

  def destroy
    service.destroy_tag(params[:id])
    render json: { status: "success" }, status: :no_content
  end

  private

  def tag_params
    params.permit(:name)
  end

  def service
    @service ||= TagService.new
  end
end

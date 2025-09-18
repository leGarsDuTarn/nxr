module Paginable
  extend ActiveSupport::Concern

  included do
    # helper_method :apply_pagination
  end

  private

  # Applique la pagination uniquement si Kaminari est dispo
  def apply_pagination(scope)
    return scope unless defined?(Kaminari) && scope.respond_to?(:page)

    per = params[:per].presence&.to_i
    per = per&.clamp(1, 100) || 2 # 6 par défaut
    scope.page(params[:page]).per(per)
  end
end

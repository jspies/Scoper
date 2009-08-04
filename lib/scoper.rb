module Scoper
  def self.included(klass)
    klass.send :extend, ScoperClassMethods
  end
  
  module ScoperClassMethods
    def scope_to_user(model = nil)
      model = self.to_s.split('::').last.sub(/Controller$/, '').pluralize.singularize.underscore unless model
      around_filter {|c, action|
        model = model.to_s.pluralize.singularize.camelize.constantize
        model.send(:with_scope, :find => {:conditions => {:user_id => c.send(:current_user).id}}, :create => {:user_id => c.send(:current_user).id}) do
          action.call
        end
      }
    end
  end
end
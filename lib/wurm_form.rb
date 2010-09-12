# WurmForm
module WurmForm
  
  module ActionController

    def self.included(base)
    base.extend(ClassMethods)
    end
    
    module ClassMethods
      def wurm_ajax_validate(form)
        define_method(:validate) do
          fields = params[:user]
          if fields.blank?
            render :nothing => true
          else
            model = Object.const_get(form.to_s.camelize)
            validity = model.new(fields)
            validity.valid?
            valid = {}
            fields.each do | field, values |
              if validity.errors[field].blank?
                valid[field] = {:valid => true}
              else
                valid[field] = {:valid => false, :message => validity.errors[field]}
              end  
            end
            render :json => valid
          end
        end
      end
    end
  end
  
end
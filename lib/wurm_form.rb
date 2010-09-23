# WurmForm
module WurmForm
  
  module ActionController

    def self.included(base)
    base.extend(ClassMethods)
    end
    
    module ClassMethods
      def wurm_ajax_validate(form)
        define_method(:validate) do
          fields = params[form]
          if fields.blank?
            render :nothing => true
          else
            model = Object.const_get(form.to_s.camelize)
            if fields[:id]
              validity = model.find(fields[:id])
              fields.delete(:id)
              validity.update_attributes(fields)
            else
              validity = model.new(fields)
              validity.valid?
            end
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
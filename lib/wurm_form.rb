# WurmForm
module WurmForm

  module ActionController

    def self.included(base)
    base.extend(ClassMethods)
    end

    module ClassMethods
      def wurm_ajax_validate(form, callback = false)
        define_method(:validate) do
          fields = params[form]
          if fields.blank?
            render :nothing => true
          else
            model = form.to_s.gsub('_', '/').camelize.split('::').reduce(Object){|cls, c| cls.const_get(c) }
            #model = Object.const_get(form.to_s.camelize)
            if fields[:id]
              validity = model.find(fields[:id]) rescue model.new(fields)
              fields.delete(:id)
              validity.attributes = fields
            else
              validity = model.new(fields)
            end
            if callback
              eval callback
            end
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
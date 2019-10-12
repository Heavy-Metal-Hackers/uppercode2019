module JsonUtils

  def self.classname(object)
    object.class.to_s.split("(")[0]
  end

  def self.prepare_linked_record_params(params)
    @linked_record_params = {
        show_linked_records: params[:show_linked_records],
        link_direction: params[:link_direction]
    }
    @linked_record_params
  end

end
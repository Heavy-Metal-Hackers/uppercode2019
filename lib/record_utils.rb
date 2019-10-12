module RecordUtils

  def self.classname(object)
    object.class.to_s.split("(")[0]
  end

  def self.create_unique_record_id(record)
    string_id = record.class.table_name + '_' + record.id.to_s
    string_id.to_sym
  end

end
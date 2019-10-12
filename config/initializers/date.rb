class ActiveSupport::TimeWithZone
    def as_json(options = {})
        strftime('%Y-%m-%dT%H:%M:%S.%L%z')
    end
end

class ActiveSupport::DateTime
    def as_json(options = {})
        strftime('%Y-%m-%dT%H:%M:%S.%L%z')
    end
end

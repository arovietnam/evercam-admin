module ApplicationHelper
  def human_boolean(boolean)
    boolean ? 'Yes' : 'No'
  end

  def avatar_url
    gravatar_id = Digest::MD5.hexdigest(current_user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}1.png"
  end

  def get_hours(schedule)
    total_hours = 0
    Time.zone = "UTC"
    if schedule
      hours = schedule["Monday"].first.to_s.split("-")
      if hours.present?
        from = Time.zone.parse(hours.first)
        to = Time.zone.parse(hours[1])
        total_hours += ((to - from) / 1.hour).round
      end
      hours = schedule["Tuesday"].first.to_s.split("-")
      if hours.present?
        from = Time.zone.parse(hours.first)
        to = Time.zone.parse(hours[1])
        total_hours += ((to - from) / 1.hour).round
      end
      hours = schedule["Wednesday"].first.to_s.split("-")
      if hours.present?
        from = Time.zone.parse(hours.first)
        to = Time.zone.parse(hours[1])
        total_hours += ((to - from) / 1.hour).round
      end
      hours = schedule["Thursday"].first.to_s.split("-")
      if hours.present?
        from = Time.zone.parse(hours.first)
        to = Time.zone.parse(hours[1])
        total_hours += ((to - from) / 1.hour).round
      end
      hours = schedule["Friday"].first.to_s.split("-")
      if hours.present?
        from = Time.zone.parse(hours.first)
        to = Time.zone.parse(hours[1])
        total_hours += ((to - from) / 1.hour).round
      end
      hours = schedule["Saturday"].first.to_s.split("-")
      if hours.present?
        from = Time.zone.parse(hours.first)
        to = Time.zone.parse(hours[1])
        total_hours += ((to - from) / 1.hour).round
      end
      hours = schedule["Sunday"].first.to_s.split("-")
      if hours.present?
        from = Time.zone.parse(hours.first)
        to = Time.zone.parse(hours[1])
        total_hours += ((to - from) / 1.hour).round
      end
    end
    total_hours
  end

  def connect_bucket
    access_key_id = ENV["AWS_ACCESS_KEY"]
    secret_access_key = ENV["AWS_SECRET_KEY"]
    s3 = AWS::S3.new(
      access_key_id: access_key_id,
      secret_access_key: secret_access_key
    )
  end
end

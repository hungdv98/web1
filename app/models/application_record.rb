class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  def distince_date issue
    string = TimeDifference.between(Time.now, issue.strftime("%d-%m-%Y %H:%M:%S").in_time_zone(Time.zone))
    @day  = string.in_seconds.to_i
    if @day < 60
      @day_dv = @day.to_s + "s"
    elsif 60 < @day && @day < 3600
      @day = string.in_minutes.to_i
      @day_dv = @day.to_s + "'"
    elsif 3600 < @day && @day < 86400
      @day = string.in_hours.to_i
      @day_dv = @day.to_s + "h"
    elsif 86400 < @day && @day < 2592000
      @day = string.in_days.to_i
      @day_dv = @day.to_s + " ngày"
    elsif 2592000 < @day && @day < 31104000
      @day = string.in_months.to_i
      @day_dv = @day.to_s + " tháng"
    else
      @day = string.in_years.to_i
      @day_dv = @day.to_s + " năm"
    end
  end
end
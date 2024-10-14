require 'active_record'

class Alert < ActiveRecord::Base
    has_many :alert_signups

    ALERT_CATEGORY_GENERAL_ALERTS = 1
    ALERT_CATEGORY_WOODSHOP_ALERTS = 2
    ALERT_CATEGORY_METALSHOP_ALERTS = 3
    ALERT_CATEGORY_DIGITAL_FABRICATION_ALERTS = 4
    ALERT_CATEGORY_ART_ALERTS = 5

    ALERT_CATEGORY_ENGINEERING_GENERAL_ALERTS = 6
    ALERT_CATEGORY_ENGINEERING_WOODSHOP_ALERTS = 7
    ALERT_CATEGORY_ENGINEERING_METALSHOP_ALERTS = 8
    ALERT_CATEGORY_ENGINEERING_DIGITAL_FABRICATION_ALERTS = 9

    def self.category_options
        if SS_ID == 1
            {
                ALERT_CATEGORY_GENERAL_ALERTS => 'General Alerts',
                ALERT_CATEGORY_WOODSHOP_ALERTS => 'Woodshop Alerts',
                ALERT_CATEGORY_METALSHOP_ALERTS => 'Metalshop Alerts',
                ALERT_CATEGORY_DIGITAL_FABRICATION_ALERTS => 'Digital Fabrication Alerts',
                ALERT_CATEGORY_ART_ALERTS => 'Art Alerts',
            }
		elsif SS_ID == 8
			{
				ALERT_CATEGORY_ENGINEERING_GENERAL_ALERTS => 'General Alerts',
                ALERT_CATEGORY_ENGINEERING_WOODSHOP_ALERTS => 'Woodshop Alerts',
                ALERT_CATEGORY_ENGINEERING_METALSHOP_ALERTS => 'Metalshop Alerts',
                ALERT_CATEGORY_ENGINEERING_DIGITAL_FABRICATION_ALERTS => 'Digital Fabrication Alerts',
			}
		end
    end

    def self.valid_category_id?(category_id)
        self.category_options.key?(category_id.to_i)
    end

    def category_name
        return self.class.category_options[category_id] if self.class.category_options.include?(category_id)
        'Other'
    end

end
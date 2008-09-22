module Approveable

  def self.included(base)
    base.send :include, InstanceMethods
    base.named_scope :approved, lambda { |*args| {:conditions => ["#{base.to_s.tableize}.approved_at IS NOT NULL AND #{base.to_s.tableize}.approved_at < ?", (args.first || Time.now)]} }
    base.named_scope :unapproved, lambda { |*args| {:conditions => ["#{base.to_s.tableize}.approved_at IS NULL OR #{base.to_s.tableize}.approved_at > ?", (args.first || Time.now)]} }    
  end
  
  module InstanceMethods

    def approved?
      !self.approved_at.nil?
    end
    
    def approve
      self.approved_at = Time.now
    end
    
    def approve!
      self.approved_at = Time.now
      save!
      reload
    end
    
    def approval_status
      approved? ? "Approved" : "Unapproved"
    end

    def unapproved?
      self.approved_at.nil?
    end
    
    def unapprove
      self.approved_at = nil
    end
    
    def unapprove!
      self.approved_at = nil
      save!
      reload
    end
    
    def toggle_approval!
      approved? ? unapprove! : approve!
    end
    
  end
  
end
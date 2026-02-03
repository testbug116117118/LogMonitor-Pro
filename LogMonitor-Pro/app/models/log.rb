class Log < ApplicationRecord
    belongs_to :user
    has_one_attached :file
    
    validates :name, presence: true
    validates :file, attached: true, 
              content_type: ['text/plain', 'text/csv', 'application/json', 'application/octet-stream']
    
    enum status: { pending: 0, processing: 1, processed: 2, error: 3 }
    
    after_create :set_default_status
    
    private
    
    def set_default_status
      self.status ||= :pending
      save if changed?
    end
  end
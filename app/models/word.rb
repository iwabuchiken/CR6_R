#encoding: utf-8

    #REF http://edgeguides.rubyonrails.org/active_record_validations.html 6.1 Custom Validators
    class MyValidator < ActiveModel::Validator
      def validate(record)
          
          w = record.w1
          
          results = Word.where(:w1 => w, :lang_id => record.lang_id)
          
          # if results != nil or results.length > 0 \
          if results.length > 0 \
                and record.lang.name != "German"
            
            record.errors[:w1] << 'すでに、登録されてます'
            
          end
          
        # unless record.name.starts_with? 'X'
          # record.errors[:name] << 'Need a name starting with X please!'
        # end
      end
    end 
    
class Word < ActiveRecord::Base
  
  #####################################
  #
  # Validations
  #
  #####################################
  # validates :w1, uniqueness: true
  # validates_uniqueness_of :w1, :scope => :lang_id
  include ActiveModel::Validations
  validates_with MyValidator
  
  #####################################
  #
  # Relations
  #
  #####################################
  # has_many    :word_lists
  has_many    :word_lists, :dependent => :destroy
  has_many    :texts, through: :word_lists
  belongs_to  :lang


  #####################################
  #
  # Before operations
  #
  #####################################
  before_save :add_created_at_millsec
  before_save :add_updated_at_millsec

  before_update :add_updated_at_millsec
  # before_update :update_created_at_millsec
  
  
  #####################################
  #
  # Methods
  #
  #####################################  
  protected
  def add_created_at_millsec
    
    mill_sec = (Time.now.to_f * 1000.0).to_i
    
    self.created_at_mill = mill_sec
    self.updated_at_mill = mill_sec
    
    # self.created_at_mill = (Time.now.to_f * 1000.0).to_i
    
  end#def add_created_at_millsec
  
  def add_updated_at_millsec
  # def update_created_at_millsec
    
    mill_sec = (Time.now.to_f * 1000.0).to_i
    
    self.updated_at_mill = mill_sec
    
  end#def update_created_at_millsec


end


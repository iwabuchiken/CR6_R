module Const

    #==============================
    #
    # => NR4
    #
    #==============================
    BACKUP_FNAME_CSV   =
        "cr6_csv.zip"
    
    BACKUP_PATH = "doc/backup"
    
    BACKUP_URL_WORDS    = "http://benfranklin.chips.jp/rails_apps/nr4/cakephp-2.3.10/words/add"
    
    MODELS_PATH = "app/models"
    
    LOG_PATH    = "doc/mylog"
    
    LOG_FILE_NAME = "log.log"

    #REF module in module // http://stackoverflow.com/questions/4255596/rails-3-including-nested-module-inside-controller answered Nov 23 '10 at 11:58
    module ViewWords
        
        SearchTagHidden = "search_w"
        
        SearchTag        = "search"
        
    end    
end
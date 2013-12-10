require_dependency 'basic'

# Without this line below, heroku site => "uninitialized"
require_dependency 'const'
include Basic
include Const

class AdminController < ApplicationController
  
  layout "layout_admin"
  
  def main
    
    target = "doc/mylog.txt"
    
    # @content = "111111111"
    @content = ""
    
    if File.exists?(target)
      
      # File.open(target, "r") do |f|
#         
        # @contentArray = f.each_line {|line|}
        # # @content = f.read()
        # # f.write(content)
        # # f.write("\n")
      # end

      # => http://www.ruby-forum.com/topic/66733
      @contentArray = File.readlines(target)

    else
      
      @content = "abcdefg"
      
    end

    #======================================
    #
    # Flash
    #
    #======================================
    if params[:item_refactor_table_word_lists]
      
      # flash[:notice] = "item_refactor_table_word_lists"
      flash[:notice] = "The user was successfully created"
      
    else
      
      flash[:notice] = "Welcome to admin/main"
      
    end
      
    
    # respond_to do |format|
        # format.html { redirect_to :controller => 'admin', :action => 'main', notice: 'Word was successfully created.' }
        # # format.html { redirect_to @word, notice: 'Word was successfully created.' }
        # format.json { render json: @word, status: :created, location: @word }
    # end

    
  end

  def sub1
    
    logout("Starting... sub1")
    
    param_destroy_word_list = params[:item_refactor_table_word_lists]
    
    param_refactor_text_ids = params[:item_refactor_text_ids]
    
    
    if param_destroy_word_list != nil
      
      logout("param_destroy_word_list => " + param_destroy_word_list)
    
      _sub1__1_refactor_table_word_lists()
    
      flash[:notice] = "word_list object destroyed: " + @counter.to_s
      
      #REF http://amigobellick.blog.fc2.com/blog-entry-16.html
      render layout: "layout_admin" 
      
    elsif param_refactor_text_ids != nil
      
      _sub1__2_refactor_text_ids()
      
      flash[:notice] = "text_ids updated: " + @counter.to_s

      render layout: "layout_admin"      
      
    else
      
      logout("param_destroy_word_list => nil")
      
      render layout: "layout_admin"
      
    end


      
    
    # flash[:notice] = "word_list object destroyed: " + @counter.to_s
    # if params[:item_refactor_table_word_lists]
#       
      # flash[:notice] = "Refactoring word_lists"
#       
    # else
#       
      # flash[:notice] = "Welcome"
#       
    # end
#
    # _sub1_redirection()
    
  end#def sub1


  def _sub1__2_refactor_text_ids()
    
    @counter = 0
    
    words = Word.all()
    
    msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
        "words.length.to_s => " + words.length.to_s

    logout(msg)

    for i in (0..(words.length - 1)) do
      
        word = words[i]
      
        if word != nil && word.text_ids != nil
          
          msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
            "word != nil && word.text_ids != nil"

          logout(msg)

          # if words[0] != nil && words[0].text_ids != nil
          
          text_ids = word.text_ids
          
          text_id = word.text_id
          
          # Validation => id number more than 0?
          if not text_id > 0
            
            msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
              "Not text_id > 0"
  
            logout(msg)
            
            next
            
          end
          
          # Flag
          is_in = false
          
          # text_ids contains the text_id ?
          for j in (0..(text_ids.length - 1)) do
            
            if text_id == text_ids[j]
              
              is_in = true
              
              break
              
            end
            
          end#for j in (0..(text_ids.length - 1)) do
          
          # Judge => If text_ids contains text_id, then move to
          # =>        the next word object
          # =>      If doesn't contain, then do text << word
          if is_in

            msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
              "is_in => word.id=" + word.id.to_s +
              "/text_id=" + text_id.to_s
  
            logout(msg)
            
            next
            
          else  # => if doesn't contain

            msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
              "Not in => word.id=" + word.id.to_s +
              "/text_id=" + text_id.to_s
  
            logout(msg)
            
            # => Build a text instance
            # => If no instance found, then do the next word object(i.e. continue
            # =>  the for loop)
            begin
              
              msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
                "Finding a text instance ... => text_id=" + text_id.to_s
                
  
              logout(msg)
              
              text = Text.find_by_id(text_id)
              # text = Text.find(:all, :id => text_id)
              # text = Text.find(text_id)
              
              text.words << word
              # text << word
              # word << text
              
              msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
                "word added to the text: text_id=" + text_id.to_s +
                      "/word_id=" + word.id.to_s
    
              logout(msg)
              
              # logout("word added to the text: text_id=" + text_id.to_s +
                      # "/word_id=" + word.id.to_s)
              
            rescue

              msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
                "Finding text => Failed: id=" + text_id.to_s
    
              logout(msg)
              
              # logout("Finding text => Failed: id=" + text_id.to_s)
              
              next
              
            end
            
          end#if is_in
          
          # logout("words[0].text_ids.class.to_s => " + words[0].text_ids.class.to_s)
          
        else

          msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
              "word => nil: id of i=" + i.to_s

          logout(msg)
          
          # logout("word => nil: id of i=" + i.to_s)
          
        end#if word != nil && word.text_ids != nil
    
    end#for i in (0..(words.length - 1)) do
    
    # for i in (0..(words.length - 1)) do
#       
      # word = words[i]
#       
      # text_ids = word.text_ids
#       
#       
#       
    # end#for i in (0..(words.length - 1)) do
    
  end#def _sub1__2_refactor_text_ids()
  
  def _sub1__1_refactor_table_word_lists
    
    word_lists = WordList.all()
    
    @counter = 0
    
    for i in (0..(word_lists.length - 1)) do
      
      word_list = word_lists[i]
      
      if not word_list.word_id > 0
        
        logout("word_list.word_id <= 0: id=" + word_list.word_id.to_s)
        
        word_list.destroy
        
        logout("word_list object destroyed => id=" + word_list.id.to_s)
        
        @counter += 1
        # REF http://doc.ruby-lang.org/ja/1.9.3/doc/spec=2fcontrol.html#next
        next
        
      end
      
      # Destroy?
      begin
        
        word = Word.find(word_list.word_id)
        
      rescue
        
        logout("No word object for id=" + word_list.word_id.to_s)
        
        word_list.destroy
        
        logout("word_list object destroyed => id=" + word_list.id.to_s)
        
        @counter += 1
        
        # next
      end
      
    end#for i in (0..(word_lists.length - 1)) do
    
    logout("for operation => Done: (Destoryed:" + @counter.to_s + ")")

      # if word == nil
#         
        # word_list.destroy
#         
        # counter += 1
#         
      # end
    
  end#def _sub1__1_refactor_table_word_lists
  
  # def _sub1_redirection
# 
    # respond_to do |format|
        # format.html { redirect_to :controller => 'admin', :action => 'sub1', notice: 'redirected' }
        # # format.html { redirect_to @word, notice: 'Word was successfully created.' }
        # # format.json { render json: @word, status: :created, location: @word }
    # end
#     
  # end
  
  def sub2
    
      respond_to do |format|
          format.html # show.html.erb
          format.js
          format.json { render json: @text }
      end
  end

    #====================================
    # => backup_db
    # => @methods: utils.rb
    # =>    _backup_db__execute
    # =>    
    #====================================
    def backup_db
        
        param = params['dl']
        
        # Routing
        if param == "words"
            
            f = File.join(_backup_path, "Word_backup.csv")
                
            _download_file(f)
            
        elsif param == "build_csv"
            
            @message = _backup_db__execute(get_models)
            
        else
            
            @message = "Welcome"
            
            # msg = Const::BACKUP_PATH
            
        end
        
        # render :text => Const::BACKUP_PATH
        # render :text => "doc/backup/"
        
    end

    def show_log
        
        #target = "doc/mylog/articles/log.log"
        target = File.join(Const::LOG_PATH, Const::LOG_FILE_NAME)
        
        @content = ""
        
        if File.exists?(target)
          
          contentArray = File.readlines(target).reverse!
    
        else
          
          contentArray = ['No log data']
          
        end
        
        respond_to do |format|
          format.html { render :text => contentArray.join('<br/>') }
          # format.json { head :no_content }
        end        
    end#show_log


end

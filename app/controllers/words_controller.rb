require 'socket'
# require 'request' # => cannot load such file -- request
require_dependency 'basic'
include Basic

class WordsController < ApplicationController
  # GET /words
  # GET /words.json
  def index
  
      #=====================================
      #
      # Variables
      #
      #=====================================
      @per_page = 10

      #=====================================
      #
      # Params
      #
      #=====================================
      # lang_id  ======================================
      lang_id = _index_param_lang_id()
      
      msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
                "lang_id.to_s=" + lang_id.to_s
        
      logout(msg)
        
      # Sort =================================
      param_sort = params[:sort]
      
      default_sort_key = _index_param_sort(param_sort)
    

    
      # Since =================================
      since = params[:since]
      
      @words = _index_GetWords_FilterSince(
                    param_sort, default_sort_key, since, lang_id)
      
      @all_words = Word.all()
      
      #=====================================
      #
      # Filtering: lang_id
      #
      #=====================================
      if lang_id != -1
  
          @words.select!{|item| item.lang_id == lang_id}
          # @texts.sort!{|item| item.lang_id == lang_id} # => undefined method `>' for true:TrueClass
        
      end
      
      #=====================================
      #
      # Langs => To count the number of entries
      #
      #=====================================
      @langs = Lang.all()
      
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @words }
    end
  end

  def _index_GetWords_FilterSince(param_sort, default_sort_key, since, lang_id)

      
    
      if since == nil

        logout("since == nil")
        #words = Word.all
        
        if lang_id == -1
              words = Word.paginate(
                            :page => params[:page],
                            :order => 'created_at asc',
                            :per_page => @per_page)
                            
        else 
        
              words = Word.where(:lang_id => lang_id).paginate(
                            :page => params[:page],
                            :order => 'created_at asc',
                            :per_page => @per_page
                            )        
            
        
        end
        
        # => REF sort_by! http://ref.xaio.jp/ruby/classes/array/sort
        # => REF {...} http://stackoverflow.com/questions/5739158/rails-ruby-how-to-sort-an-array answered Apr 21 '11 at 3:36
        
        # => REF {|word| - ...} http://www.ruby-forum.com/topic/148948 Posted by Rob Biedenharn (Guest) on 2008-04-09 00:34
        # @words.sort_by!{|word| - word[default_sort_key]}
        # @words.sort_by!{|word| word[default_sort_key]}.reverse  # => Doesn't descend
        
        return words.sort_by!{|word| word[default_sort_key]}
        
        # @words.sort!{|t1, t2| t1.lang_id <=> t2.lang_id}
        
        # @words.reverse          # => Doesn't descend
        
        # @words.sort_by!{|word| word[:created_at]}
        
      else
        
          if is_numeric?(since)
          # if since.numeric?
        
              words = 
                  Word.find(
                        :all,
                        :conditions => [
                                  # "updated_at_mill > ?", since.to_i])
                                  "created_at_mill > ?", since.to_i],
                        # => REF http://rubyrails.blog27.fc2.com/blog-entry-13.html
                        :order => default_sort_key.to_s + " DESC "
                        # :order => default_sort_key.to_s + " DESC "
                        # :order => "created_at"
                        )
                                  # "created_at_mill > ?", since.to_i + (9*60*60)])
                                  # "created_at > ?",
                                  # Time.at(since.to_i / 1000).utc])
                                  # Time.at(since.to_i / 1000).utc + (9*60*60)])
    
                                  # REF=> http://www.treeder.com/2011/06/converting-ruby-time-to-milliseconds.html
                                  # Time.at(since.to_i / 1000).utc + (9*60*60 + 1)])
    
                                  
                        # :conditions => ["created_at > ?", Time.at(since.to_i / 1000)])
              
              # logout(Time.at(since.to_i / 1000) + "/utc=" + Time.at(since.to_i / 1000).utc)
              # logout(Time.at(since.to_i / 1000).to_s + "/utc=" + Time.at(since.to_i / 1000).utc.to_s)
              logout((Time.at(since.to_i / 1000) + (9*60*60 + 1)).to_s\
                      + "/utc="\
                      + (Time.at(since.to_i / 1000).utc + (9*60*60 + 1)).to_s\
                      + "/since=" + since.to_i.to_s
                      )
              
              # logout((Time.at(since.to_i / 1000) + (9*60*60)).to_s\
                      # + "/utc="\
                      # + (Time.at(since.to_i / 1000).utc + (9*60*60)).to_s)
              
              # @words.paginate
              
              return words
            
          else
              logout("since -> " + since)
              
              # logout("since -> " + since + "(" + Time.at(since.to_i / 1000) + ")")
              
              words =
                  Word.all
              
              return words.sort_by!{|word| word[default_sort_key]}
              # @words.sort_by!{|word| word[:created_at]}
            
          end#if since.numeric?
  
        # @words = Word.find(:all, :conditions => ["created_at > ?", Time.at(since.to_i / 1000).utc])
        
      end#if since == nil 
  end#def _index_GetWords_FilterSince(param_sort, default_sort_key)

  def _index_param_sort(param_sort)
  
      if param_sort != nil and param_sort == "lang"

        return :lang_id
        
      elsif param_sort != nil and param_sort == "id"
        
        return :id
        
      elsif param_sort != nil and param_sort == "w1"
        
        return :w1
        
      elsif param_sort != nil and param_sort == "w2"
        
        return :w2
        
      elsif param_sort != nil and param_sort == "w3"
        
        return :w3
        
      elsif param_sort != nil and param_sort == "text_id"
        
        return :text_id
        
      else
        
        return :id
        
      end#if param_sort != nil and param_sort == "lang"
      
  end#def _index_param_sort


  def _index_param_lang_id
    
    if params[:text] == nil

        msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
              "params[:text] => nil"
      
        logout(msg)
      
        return -1
    
    elsif params[:text] != nil && params[:text] == ""

        msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
              "params[:text] => \"\""
      
        logout(msg)
      
        return -1
      
    else
      
      msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
            "params[:text] => " + params[:text].class.to_s +
            "/" + "params[:text][:lang_id].class=" + params[:text][:lang_id].class.to_s
    
      logout(msg)
      
      if params[:text][:lang_id] != nil &&
            params[:text][:lang_id] != ""
        
          msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
                "params[:text] => " + params[:text].class.to_s +
                "/" + "params[:text][:lang_id]=" + params[:text][:lang_id]
        
          logout(msg)
        
      elsif params[:text][:lang_id] != nil &&
            params[:text][:lang_id] == ""
        
          msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
                "params[:text] => " + params[:text].class.to_s +
                "/" + "params[:text][:lang_id] => \"\""
        
          logout(msg)
        
      else

          msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
                "params[:text] => " + params[:text].class.to_s +
                "/" + "params[:text][:lang_id] => nil"
        
          logout(msg)
        
      end
        
      lang_id = params[:text][:lang_id]
      
    end
    
    if lang_id != nil && lang_id != ""
      
      return lang_id.to_i
      
    else
      
      return -1
      
    end
    
    # if lang_id != nil
#       
      # if lang_id == ""
#         
        # msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
            # "lang_id => \"\""
#     
        # logout(msg)
# 
      # else
#         
        # msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
            # "lang_id=" + lang_id
#     
        # logout(msg)
#       
      # end
#       
    # else
#       
        # msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
            # "lang_id => nil"
#     
        # logout(msg)
#       
    # end#if lang_id != nil 
    
  end#def _index_param_lang_id

  # GET /words/1
  # GET /words/1.json
  def show
      @word = Word.find(params[:id])
  
      if @word != nil && @word.text_id > 0
        
          @text = Text.find(@word.text_id)
        
      else
        
          @text = nil
        
      end
      
      
      
      # @text = Text.find(@word.text_id)
      
      # => B13-CHANGE-5
      
      
      # msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " 
            # # "Socket.gethostname=" + Socket.gethostname +
            # # "/" + "requset.protocol=" + requset.protocol
#             
      # ENV.each { |key, value|
          # msg += "#{key} - #{value} <br/> "
      # }
#       
      # logout(msg)
  
      respond_to do |format|
          format.html # show.html.erb
          format.json { render json: @word }
      end
  end

  # GET /words/new
  # GET /words/new.json
  def new
    @word = Word.new

    
    if params[:text_id] && is_numeric?(params[:text_id])
    # if params[:text_id] && params[:text_id].numeric?
      
      @word.text_id = params[:text_id].to_i
      
    end

    if params[:lang_id] && is_numeric?(params[:lang_id])
    # if params[:lang_id] && params[:lang_id].numeric?
      
      @word.lang_id = params[:lang_id].to_i
      
    end

    #debug
    if params[:text_id] != nil
      
      logout("params[:text_id]=" + params[:text_id])
      logout(is_numeric?(params[:text_id]))
        
    else
      
      logout("params[:text_id] => nil")
      
    end
    
    

    # REF http://stackoverflow.com/questions/3757491/can-i-get-the-name-of-the-current-controller-in-the-view answered Sep 21 '10 at 5:27
    #debug
    @current_controller = params[:controller]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @word }
    end
  end

  # GET /words/1/edit
  def edit
    @word = Word.find(params[:id])
    
    @text_ids = @word.text_ids.join(" ")
    
  end

  # POST /words
  # POST /words.json
  def create
    @word = Word.new(params[:word])

    @word.created_at_mill = (Time.now.to_f * 1000.0).to_i
    
    # Get text instance
    text_id = @word.text_id
    
    if text_id != 0
    
      text = Text.find(text_id.to_i)
      
    else

      text = nil
      
    end
    
    respond_to do |format|
      if @word.save
        if text != nil
          
          text.words << @word
          
          write_log2(
                  LOG_PATH,
                  "word added to the text: word id => " + @word.id.to_s,
                  __FILE__.split("/")[-1],
                  __LINE__.to_s)        
                  
            _post_data(BACKUP_URL, @word)
            
        else
          
            write_log2(
                  LOG_PATH,
                  "text == nil(for the word #{@word.w1})",
                  __FILE__.split("/")[-1],
                  __LINE__.to_s)        
                  
        end

        format.html { redirect_to @word, notice: 'Word was successfully created.' }
        # format.html { redirect_to @word, notice: 'Word was successfully created.' }
        format.json { render json: @word, status: :created, location: @word }
      else
        format.html { render action: "new" }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /words/1
  # PUT /words/1.json
  def update
    @word = Word.find(params[:id])
#     
#     
    # #debug
    # msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
            # "params[:id]=" + params[:id]
            # # "params[:text_ids]=" + params[:text_ids]  # => nil
            # # "Updating word ..." + "(@word.text_ids=" + @word.text_ids + ")"
# 
    # logout(msg)
# 
    # msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
            # "params.length=" + params.length.to_s
            # # "params[:text_ids]=" + params[:text_ids]
            # # "Updating word ..." + "(@word.text_ids=" + @word.text_ids + ")"
# 
    # logout(msg)
# 
    # msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " +
            # "params.class.to_s=" + params.class.to_s 
            # # "params.join(\" // \")=" + params.join(" // ")
            # # "params[:text_ids]=" + params[:text_ids]
            # # "Updating word ..." + "(@word.text_ids=" + @word.text_ids + ")"
# 
    # logout(msg)
# 
    # msg = ""
#     
    # params.each do |k, v|
#       
      # msg += "k=" + k + "/"
#       
    # end#params.each do |k, v|
# 
    # logout(msg)
# 
    # # msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " +
            # # "Updating word ..." + "(@word.text_ids=" + @word.text_ids + ")" # => nil

    respond_to do |format|
      if @word.update_attributes(params[:word])
        format.html { redirect_to @word, notice: 'Word was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /words/1
  # DELETE /words/1.json
  def destroy
    @word = Word.find(params[:id])
    @word.destroy

    respond_to do |format|
      format.html { redirect_to words_url }
      format.json { head :no_content }
    end
  end
end

# def logout(label)
#   
#     
    # target = "doc/mylog.txt"
#     
    # if not File.exists?(target)
#       
      # FileUtils.touch(target)
#       
    # end
#     
    # # content = "abcdefg"
    # # File.open(target, "w+") do |f|
    # File.open(target, "a") do |f|
      # f.write("[" + __FILE__ + " " + Time.now.to_s + "/" + __LINE__.to_s + "]" + "\n")
      # # f.write(content)
      # f.write(label)
      # f.write("\n")
    # end
# 
# end

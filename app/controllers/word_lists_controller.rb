require_dependency 'basic'
include Basic

class WordListsController < ApplicationController
  # GET /word_lists
  # GET /word_lists.json
  def index
      #=====================================
      #
      # Variables
      #
      #=====================================
#      @per_page = 10
      @per_page = 5

      #=====================================
      #
      # Params
      #
      #=====================================
      # lang_id  ======================================
      lang_id = _index_param_lang_id()
      
      # Sort =================================
      param_sort = params[:sort]
      
      default_sort_key = _index_param_sort(param_sort)
        
      # Since =================================
      since = params[:since]
      
      @word_lists = _index_GetWordLists_FilterSince(
                    param_sort, default_sort_key, since, lang_id)
      
      #=====================================
      #
      # Filtering: lang_id
      #
      #=====================================
      msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
              "lang_id=" + lang_id.to_s
      
      logout(msg)
      
      if lang_id != -1
  
          @word_lists.select!{|item| item.lang_id == lang_id}
          # @texts.sort!{|item| item.lang_id == lang_id} # => undefined method `>' for true:TrueClass
        
      end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @word_lists }
    end
  end

  def _index_GetWordLists_FilterSince(param_sort, default_sort_key, since, lang_id)
    
      if since == nil

        logout("since == nil")
#        word_lists = WordList.all
 
        if lang_id == -1
              word_lists = WordList.paginate(
                            :page => params[:page],
                            :order => 'created_at asc',
                            :per_page => @per_page)
                            
        else 
        
              word_lists = WordList.where(:lang_id => lang_id).paginate(
                            :page => params[:page],
                            :order => 'created_at asc',
                            :per_page => @per_page
                            )        
            
        
        end

 
 
        
        # => REF sort_by! http://ref.xaio.jp/ruby/classes/array/sort
        # => REF {...} http://stackoverflow.com/questions/5739158/rails-ruby-how-to-sort-an-array answered Apr 21 '11 at 3:36
        
        # => REF {|word| - ...} http://www.ruby-forum.com/topic/148948 Posted by Rob Biedenharn (Guest) on 2008-04-09 00:34
        # @word_lists.sort_by!{|word| - word[default_sort_key]}
        # @word_lists.sort_by!{|word| word[default_sort_key]}.reverse  # => Doesn't descend
        
        return word_lists.sort_by!{|word| word[default_sort_key]}
        
        # @word_lists.sort!{|t1, t2| t1.lang_id <=> t2.lang_id}
        
        # @word_lists.reverse          # => Doesn't descend
        
        # @word_lists.sort_by!{|word| word[:created_at]}
        
      else
        
          if is_numeric?(since)
          # if since.numeric?
        
              word_lists = WordList.all()
              
              word_lists.select!{|item| item.created_at_mill > since.to_i}
              # word_lists = word_lists.select!{|item| item.created_at_mill > since.to_i}
              
              word_lists.sort_by!{|word| word[default_sort_key]}
              
                  # WordList.find(
                        # :all,
                  # # WordList.all(
# 
                        # :conditions => [
                                  # # "updated_at_mill > ?", since.to_i])
                                  # "created_at_mill > ?", since.to_i],
                        # # => REF http://rubyrails.blog27.fc2.com/blog-entry-13.html
                        # :order => default_sort_key.to_s + " DESC "
                        # # :order => default_sort_key.to_s + " DESC "
                        # # :order => "created_at"
                        # )
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
              
              # @word_lists.paginate
              
              return word_lists
            
          else
              logout("since -> " + since)
              
              # logout("since -> " + since + "(" + Time.at(since.to_i / 1000) + ")")
              
              word_lists =
                  WordList.all
              
              return word_lists.sort_by!{|word| word[default_sort_key]}
              # @word_lists.sort_by!{|word| word[:created_at]}
            
          end#if since.numeric?
  
        # @word_lists = WordList.find(:all, :conditions => ["created_at > ?", Time.at(since.to_i / 1000).utc])
        
      end#if since == nil 
  end#def _index_GetWordLists_FilterSince(param_sort, default_sort_key)

  def _index_param_sort(param_sort)
    
      if param_sort != nil and param_sort == "lang_id"
      # if param_sort != nil
        
        # msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
            # "param_sort=" + param_sort +
            # "/" + "param_sort.to_sym.class.to_s=" + param_sort.to_sym.class.to_s
  #   
        # logout(msg)
  
        
        # default_sort_key = param_sort.to_sym
        return :lang_id
        
      elsif param_sort != nil and param_sort == "id"
        
        return :id
        
      elsif param_sort != nil and param_sort == "text_id"
        
        return :text_id
        
      elsif param_sort != nil and param_sort == "lang_id"
        
        return :lang_id
        
      elsif param_sort != nil and param_sort == "word_id"
        
        return :word_id
        
      end#if param_sort != nil and param_sort == "lang"
      
  end#def _index_param_sort

  def _index_param_lang_id
    
    if params[:word_list] == nil

        msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
              "params[:word_list] => nil"
      
        logout(msg)
      
        return -1
    
    elsif params[:word_list] != nil && params[:word_list] == ""

        msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
              "params[:word_list] => \"\""
      
        logout(msg)
      
        return -1
      
    else
      
      msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
            "params[:word_list] => " + params[:word_list].class.to_s +
            "/" + "params[:word_list][:lang_id].class=" + params[:word_list][:lang_id].class.to_s
    
      logout(msg)
      
      if params[:word_list][:lang_id] != nil &&
            params[:word_list][:lang_id] != ""
        
          msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
                "params[:word_list] => " + params[:word_list].class.to_s +
                "/" + "params[:word_list][:lang_id]=" + params[:word_list][:lang_id]
        
          logout(msg)
        
      elsif params[:word_list][:lang_id] != nil &&
            params[:word_list][:lang_id] == ""
        
          msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
                "params[:word_list] => " + params[:word_list].class.to_s +
                "/" + "params[:word_list][:lang_id] => \"\""
        
          logout(msg)
        
      else

          msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
                "params[:word_list] => " + params[:word_list].class.to_s +
                "/" + "params[:word_list][:lang_id] => nil"
        
          logout(msg)
        
      end
        
      lang_id = params[:word_list][:lang_id]
      
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

  # GET /word_lists/1
  # GET /word_lists/1.json
  def show
    @word_list = WordList.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @word_list }
    end
  end

  # GET /word_lists/new
  # GET /word_lists/new.json
  def new
    @word_list = WordList.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @word_list }
    end
  end

  # GET /word_lists/1/edit
  def edit
    @word_list = WordList.find(params[:id])
  end

  # POST /word_lists
  # POST /word_lists.json
  def create
    @word_list = WordList.new(params[:word_list])

    @word_list.created_at_mill = (Time.now.to_f * 1000.0).to_i

    respond_to do |format|
      if @word_list.save
        
        logout("created_at_mill=" + @word_list.created_at_mill.to_s)
        format.html { redirect_to @word_list, notice: 'Word list was successfully created.' }
        format.json { render json: @word_list, status: :created, location: @word_list }
      else
        format.html { render action: "new" }
        format.json { render json: @word_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /word_lists/1
  # PUT /word_lists/1.json
  def update
    @word_list = WordList.find(params[:id])

    respond_to do |format|
      if @word_list.update_attributes(params[:word_list])
        format.html { redirect_to @word_list, notice: 'Word list was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @word_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /word_lists/1
  # DELETE /word_lists/1.json
  def destroy
    @word_list = WordList.find(params[:id])
    @word_list.destroy

    respond_to do |format|
      format.html { redirect_to word_lists_url }
      format.json { head :no_content }
    end
  end
end

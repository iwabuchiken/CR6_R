# => http://stackoverflow.com/questions/1698225/where-to-put-common-code-found-in-multiple-models ## "answered Nov 8 '09 at 23:29" 
require_dependency 'basic'
include Basic

require 'utils'

# require 'will_paginate'

class TextsController < ApplicationController
  
  # before_filter :validate_login
  # include Basic
  
  # GET /texts
  # GET /texts.json
  def index
    
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

      
      # Sort ======================================
      #debug
      # default_sort_key = :title
      # default_sort_key = :id
      param_sort = params[:sort]
      
      default_sort_key = _index_param_sort(param_sort)
      
      msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
                "default_sort_key.to_s=" + default_sort_key.to_s
        
      logout(msg)
  
      # Since ======================================
      since = params[:since]
      
      
      #=====================================
      #
      # Build list: since
      #
      #=====================================
      #@texts = _index_GetTexts_FilterSince(param_sort, default_sort_key, since)
      @texts = _index_GetTexts_FilterSince(
                              param_sort, default_sort_key, since, lang_id)
  
      #=====================================
      #
      # Filtering: lang_id
      #
      #=====================================
      if lang_id != -1
  
          @texts.select!{|item| item.lang_id == lang_id}
          # @texts.sort!{|item| item.lang_id == lang_id} # => undefined method `>' for true:TrueClass
        
      end
      
  
      # @texts = Text.all
  
      respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @texts }
      end
      
  end#def index

  # GET /texts/1
  # GET /texts/1.json

  def _index_GetTexts_FilterSince(param_sort, default_sort_key, since, lang_id)
    
      if since == nil

        logout("since == nil")
        # texts = Text.all
        if lang_id == -1
              texts = Text.paginate(
                            :page => params[:page],
                            :order => 'created_at asc',
                            :per_page => 3)
                            
        else 
        
              texts = Text.where(:lang_id => lang_id).paginate(
                            :page => params[:page],
                            :order => 'created_at asc',
                            :per_page => 3
                            )        
            
        
        end
        # => REF sort_by! http://ref.xaio.jp/ruby/classes/array/sort
        # => REF {...} http://stackoverflow.com/questions/5739158/rails-ruby-how-to-sort-an-array answered Apr 21 '11 at 3:36
        
        # => REF {|word| - ...} http://www.ruby-forum.com/topic/148948 Posted by Rob Biedenharn (Guest) on 2008-04-09 00:34
        # @texts.sort_by!{|word| - word[default_sort_key]}
        # @texts.sort_by!{|word| word[default_sort_key]}.reverse  # => Doesn't descend
        
        return texts.sort_by!{|word| word[default_sort_key]}
        
        # @texts.sort!{|t1, t2| t1.lang_id <=> t2.lang_id}
        
        # @texts.reverse          # => Doesn't descend
        
        # @texts.sort_by!{|word| word[:created_at]}
        
      else
        
          if is_numeric?(since)
          # if since.numeric?
        
              texts = 
                  Text.find(
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
              
              # @texts.paginate
              
              return texts
            
          else
              logout("since -> " + since)
              
              # logout("since -> " + since + "(" + Time.at(since.to_i / 1000) + ")")
              
              texts =
                  Text.all
              
              return texts.sort_by!{|word| word[default_sort_key]}
              # @texts.sort_by!{|word| word[:created_at]}
            
          end#if since.numeric?
  
        # @texts = Text.find(:all, :conditions => ["created_at > ?", Time.at(since.to_i / 1000).utc])
        
      end#if since == nil 
  end#def _index_GetTexts_FilterSince(param_sort, default_sort_key)

  def __index_GetTexts_FilterSince(param_sort, default_sort_key, since)
    
      if since == nil

        logout("since == nil")
        # texts = Text.all
        # texts = Text.pagenate(
        texts = Text.paginate(
                      :page => params[:page],
                      :order => 'created_at desc',
                      :per_page => 3)
        
        # => REF sort_by! http://ref.xaio.jp/ruby/classes/array/sort
        # => REF {...} http://stackoverflow.com/questions/5739158/rails-ruby-how-to-sort-an-array answered Apr 21 '11 at 3:36
        
        # => REF {|word| - ...} http://www.ruby-forum.com/topic/148948 Posted by Rob Biedenharn (Guest) on 2008-04-09 00:34
        # @texts.sort_by!{|word| - word[default_sort_key]}
        # @texts.sort_by!{|word| word[default_sort_key]}.reverse  # => Doesn't descend
        
        return texts.sort_by!{|word| word[default_sort_key]}
        
        # @texts.sort!{|t1, t2| t1.lang_id <=> t2.lang_id}
        
        # @texts.reverse          # => Doesn't descend
        
        # @texts.sort_by!{|word| word[:created_at]}
        
      else
        
          if is_numeric?(since)
          # if since.numeric?
        
              texts = 
                  Text.find(
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
              
              # @texts.paginate
              
              return texts
            
          else
              logout("since -> " + since)
              
              # logout("since -> " + since + "(" + Time.at(since.to_i / 1000) + ")")
              
              texts =
                  Text.all
              
              return texts.sort_by!{|word| word[default_sort_key]}
              # @texts.sort_by!{|word| word[:created_at]}
            
          end#if since.numeric?
  
        # @texts = Text.find(:all, :conditions => ["created_at > ?", Time.at(since.to_i / 1000).utc])
        
      end#if since == nil 
  end#def _index_GetTexts_FilterSince(param_sort, default_sort_key)

  def _index_param_sort(param_sort)
      if param_sort != nil and param_sort == "lang"
      # if param_sort != nil
        
        # msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
            # "param_sort=" + param_sort +
            # "/" + "param_sort.to_sym.class.to_s=" + param_sort.to_sym.class.to_s
  #   
        # logout(msg)
  
        # => REF to_sym http://chulip.org/entry/20090627/1246117665
        # default_sort_key = param_sort.to_sym
        # default_sort_key = :lang_id
        return :lang_id
        
      elsif param_sort != nil and param_sort == "id"
        
        # default_sort_key = :id
        return :id
        
      elsif param_sort != nil and param_sort == "text"
        
        return :text
        # default_sort_key = :text
        
      elsif param_sort != nil and param_sort == "title"
        
        return :title
        # default_sort_key = :title
        
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
    
  end#def _index_param_lang_id

  def show
    @text = Text.find(params[:id])

    #B14
    if @text != nil
      
      @text.text = _show__1_colorize_words(@text)
      
    end#if @text != nil
    

    respond_to do |format|
      format.html # show.html.erb
      format.js
      format.json { render json: @text }
    end
  end

  # GET /texts/new
  # GET /texts/new.json
  def new
    @text = Text.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @text }
    end
  end

  # GET /texts/1/edit
  def edit
    @text = Text.find(params[:id])
  end

  # POST /texts
  # POST /texts.json
  def create
    @text = Text.new(params[:text])
    
    # #debug  => http://stackoverflow.com/questions/3479551/how-to-get-an-array-with-column-names-of-a-table
    # Text.columns.map {|c|
      # c.name
      # logout("c.name=" + c.name)
    # }
    
    
    @text.created_at_mill = (Time.now.to_f * 1000.0).to_i
    
        #D-9
    if @text.title == ""
      
      if @text.text.length > 30
        
        @text.title = @text.text[0..30]
        
      else
        
        @text.title = @text.text
        
      end
      
    end#if @text.title == ""

    
    respond_to do |format|
      if @text.save
        format.html { redirect_to @text, notice: 'Text was successfully created.' }
        format.json { render json: @text, status: :created, location: @text }
      else
        format.html { render action: "new" }
        format.json { render json: @text.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /texts/1
  # PUT /texts/1.json
  def update
      @text = Text.find(params[:id])

      #debug
      if @text.word_lists != nil
        
          msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
                    "@text.word_lists.size.to_s=" + @text.word_lists.size.to_s
                  
      else
        
          msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
            "@text.word_list.id.to_s=" + @text.word_list.id.to_s

      end#if @text.word_list != nil
        
      logout(msg)
      
      #params[:text]
      msg = ""
      
      if params[:text] != nil
        
        params[:text].each {|k, v|
            
            # msg += "k=" + k + "/" + "v=" + v.to_s + " "
            msg += "k=" + k + "/" + "v=" + v + " "
        }
        
      else
        
        msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
            "params[:text] => nil"
        
      end
      
      # msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
        

      logout(msg)
      

    
    respond_to do |format|
      if @text.update_attributes(params[:text])
        format.html { redirect_to @text, notice: 'Text was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @text.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /texts/1
  # DELETE /texts/1.json
  def destroy
    @text = Text.find(params[:id])
    @text.destroy

    respond_to do |format|
      format.html { redirect_to texts_url }
      format.json { head :no_content }
    end
  end

  def build_word_list
    #=======================================
    #
    # Prep: Data
    #
    #=======================================
    text_id = params[:text_id]
    
    @text = Text.find_by_id(text_id)
    
    diff_words = _build_word_list__1_build_list(text_id)
    
    selected_words = _build_word_list__2_select_words(text_id, diff_words)
    
    if selected_words.length > 0
    
      msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
          "selected_words.length=" + selected_words.length.to_s
  
      logout(msg)
  
      msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
          "selected_words[0].w1=" + selected_words[0].w1
  
      logout(msg)
      
    else
      
      msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
          "selected_words.length =< 0"
  
      logout(msg)
    end
    
    #=======================================
    #
    # Register new words
    #
    #=======================================
    if selected_words.length > 0
      
      word_ids = []
      
      selected_words.each {|word|
        
        word_ids << word.id
      }
      
      msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
            "word_ids.length.to_s=" + word_ids.length.to_s

      logout(msg)
      
      res = _build_word_list__3_register_words(text_id, word_ids, @text.lang_id)
      
    else
      
      msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
      "selected_words.length > 0="

      logout(msg)

      
    end#if selected_words.length > 0
    
    respond_to do |format|
      format.html { redirect_to @text, notice: 'Back from building word list' }
      format.json { head :no_content }
    end#respond_to do |format|
    
  end#def build_word_list

  private #==================================================
  
  
  def _build_word_list__1_build_list(text_id)
    #===========================
    #
    # Prepare: Data
    #
    #===========================
    text = Text.find_by_id(text_id)
    
    if text != nil
      
      all_words = Word.find_all_by_lang_id(text.lang_id)
      
    else
      
      all_words = Word.find(:all)
      
    end
    # all_words = Word.find(:all)
    
    this_words = Word.find_all_by_text_id(text_id)
    
    # => REF subtract http://favstar.fm/users/hassyX/status/11376406955
    diff_words = all_words - this_words
    
    msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
              "diff_words.length=" + diff_words.length.to_s
    logout(msg)
    
    return diff_words
    

  end#def _build_word_list__1_build_list

  def _build_word_list__2_select_words(text_id, diff_words)
    
    text = Text.find_by_id(text_id)
    
    selected_words = []
    
    for i in (0..(diff_words.length - 1))
      
      kw = diff_words[i].w1
      
      reg = /#{kw}/
      
      if reg =~ text.text
        
        selected_words << diff_words[i]
        
      end#if reg =~ text.text
      
    # for i in (0..(diff_words.length))
      
      # if _build_word_list__2_build_list(text_id)
        # word_list = WordList.new()
#         
        # word_list.text_id = text.id
        # word_list.word_id = diff_words[i].id
        # word_list.lang_id = text.lang_id
#         
        # if word_list.save
#           
          # msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
              # "word_list saved: text=" + text.id.to_s +
              # "/" + "word=" + diff_words[i].w1
#   
          # logout(msg)
#           
        # else
#   
          # msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
              # "word_list couldn't be saved: text=" + text.id.to_s +
              # "/" + "word=" + diff_words[i].w1
#   
          # logout(msg)
#   
        # end#if word_list.save
#       
      # end#if _build_word_list__2_build_list(text_id)
      
    end#for i in (0..(diff_words.length))
    
    return selected_words
    
  end#def _build_word_list__2_select_words(text_id, diff_words)

  def _build_word_list__3_register_words(text_id, word_ids, lang_id)
    
    for i in (0..word_ids.length - 1)

        word_list = WordList.new()
        
        word_list.text_id = text_id
        word_list.word_id = word_ids[i]
        word_list.lang_id = lang_id
        
        if word_list.save
          
          msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
              "word_list saved: text=" + text_id.to_s +
              "/" + "word=" + word_ids[i].to_s
  
          logout(msg)
          
        else
  
          msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
              "word_list couldn't be saved: text=" + text_id.to_s +
              "/" + "word=" + word_ids[i].to_s
  
          logout(msg)
  
        end#if word_list.save
    
      
    end#for i in (0..word_ids.length - 1)
    
  end#def _build_word_list__3_register_words(text_id, word_ids, lang_id)
  
  def _show__1_colorize_words(text)
    
    text_id = text.id
    
    text = Text.find(text_id)
    
    if text == nil
      
      msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
            "text => nil"
      
      logout(msg)

      return text
      
    end
    
    
    # => REF http://d.hatena.ne.jp/nakakoh/20080510/1210390013
    # words = Word.find_all_by_text_id(text_id)
    
    words = text.words
    
    # words = Word.find_by_text_id(text_id)
    
    if words != nil
    
      msg = "text.id=" + text_id.to_s + "/" + "Num of words=" + words.length.to_s
      # msg = "text.id=" + text_id.to_s + "/" + "Num of words=" + words.count
      
    else
      
      msg = "text.id=" + text_id.to_s + "/" + "words => nil"
      
    end
    
    logout(msg)
    
    ##########################
    #
    #
    #
    ##########################
    new_text = ""
    # tag1 = "<span style='color: blue;'>"
    # tag1 = "<span style='color: blue;'>"
    # tag2 = "</span>"
    
    for i in 0..(words.length - 1)
        tag1 = "<span style='color: blue;' onClick='alert(\"#{words[i].w1}/#{words[i].w2}/#{words[i].w3}\");'>"
        # tag1 = "<span style='color: blue;' onClick='alert(\"hi\");'>" # => Works
        # tag1 = "<span style='color: blue;' onmouseover='alert(\"hi\");'>" # => Works
        # tag1 = "<span style='color: blue; onmouseover='alert('hi');'>"
        # tag1 = "<span style='color: blue; onClick='alert('hi');'>"
        # tag1 = "<span style='color: blue; onclick='alert('hi');'>"
        tag2 = "</span>"
        word = words[i]
  #       
        if text.lang_id == 2 || # => German
            text.lang_id == 3 || # => French
            text.lang_id == 4 # => English
            
            text.text = _add_span2_GeFrEn(text.text, word, tag1, tag2)
            
        else
          
          text.text = _add_span2(text.text, word, tag1, tag2)
          
        end
        # text.text = _add_span(text.text, word.w1, tag1, tag2)
   
    end#for i in 0..(words.length - 1)
    
    # text.text.insert(5, tag1)
    # text.text.insert(5 + tag1.size + 5, tag2)
#     
    return text.text
    
  end#def _show__1_colorize_words(@text)
  
  def _add_span2(text, word, start_tag, end_tag)

    # => REF /#{}/ http://stackoverflow.com/questions/2648054/ruby-recursive-regex answered Apr 15 '10 at 18:48
    r       = /#{word.w1}/
    marker  = 0
    t1      = start_tag
    t2      = end_tag
    counter = 0
  
    # => REF =~ http://www.rubylife.jp/regexp/ini/index4.html
    while r =~ text[marker..(text.size - 1)] do
    # while r =~ text[marker..(text.size - 1)] && counter < maxnum do
      #debug
      logout("r=" + r.source)
      
      point = (r =~ text[marker..(text.size - 1)])
      
      text.insert(marker + point, t1)
      text.insert(marker + point + t1.size + r.source.size, t2)
  
      marker += point + t1.size + r.source.size + t2.size
      
      counter += 1
  
      
    end#while r =~ text[marker..(text.size - 1)] && counter < maxnum do
    
    return text
    
  end#def _add_span(text, keyword, start_tag, end_tag)
  
  def _add_span2_GeFrEn(text, word, start_tag, end_tag)

      # => REF /#{}/ http://stackoverflow.com/questions/2648054/ruby-recursive-regex answered Apr 15 '10 at 18:48
      r       = /#{word.w1}/
      marker  = 0
      t1      = start_tag
      t2      = end_tag
      counter = 0
      
      new_text = []
      
      text_split = text.split(" ")
      
      for i in (0..(text_split.length - 1))
          
          point = (r =~ text_split[i])
          # point = (r =~ text[marker..(text.size - 1)])
          
          if  point
          # if r =~ text_split[i]
              #debug
              msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
                "text_split[i]=" + text_split[i] +
                "/" + "point=" + point.to_s
        
              logout(msg)
              
              text_split[i].insert(point, t1)
              
              #debug
              msg = "(" + __FILE__ + ":" + __LINE__.to_s + ") " + 
                "text_split[i]=" + text_split[i]
        
              logout(msg)
              
              text_split[i].insert(point + t1.size + r.source.size, t2)
              
              new_text << text_split[i]
              # new_text << t1 + text_split[i] + t2
              
          else
              
              new_text << text_split[i]
            
          end#if r =~ text_split[i]
        
          # # => REF =~ http://www.rubylife.jp/regexp/ini/index4.html
          # while r =~ text_split[i][marker..(text_split[i].size - 1)] do
          # # while r =~ text[marker..(text.size - 1)] && counter < maxnum do
            # #debug
            # logout("r=" + r.source)
#             
            # point = (r =~ text[marker..(text.size - 1)])
#             
            # text.insert(marker + point, t1)
            # text.insert(marker + point + t1.size + r.source.size, t2)
#         
            # marker += point + t1.size + r.source.size + t2.size
#             
            # counter += 1
#         
#             
          # end#while r =~ text[marker..(text.size - 1)] && counter < maxnum do
#       
      end#for i in (0..(text_split.length - 1))
      
      return new_text.join(" ")
      # return text
    
  end#def _add_span(text, keyword, start_tag, end_tag)

  def _add_span2(text, word, start_tag, end_tag)

    # => REF /#{}/ http://stackoverflow.com/questions/2648054/ruby-recursive-regex answered Apr 15 '10 at 18:48
    r       = /#{word.w1}/
    marker  = 0
    t1      = start_tag
    t2      = end_tag
    counter = 0
  
    # => REF =~ http://www.rubylife.jp/regexp/ini/index4.html
    while r =~ text[marker..(text.size - 1)] do
    # while r =~ text[marker..(text.size - 1)] && counter < maxnum do
      #debug
      logout("r=" + r.source)
      
      point = (r =~ text[marker..(text.size - 1)])
      
      text.insert(marker + point, t1)
      text.insert(marker + point + t1.size + r.source.size, t2)
  
      marker += point + t1.size + r.source.size + t2.size
      
      counter += 1
  
      
    end#while r =~ text[marker..(text.size - 1)] && counter < maxnum do
    
    return text
    
  end#def _add_span(text, keyword, start_tag, end_tag)

  def _add_span(text, keyword, start_tag, end_tag)

    # => REF /#{}/ http://stackoverflow.com/questions/2648054/ruby-recursive-regex answered Apr 15 '10 at 18:48
    r       = /#{keyword}/
    marker  = 0
    t1      = start_tag
    t2      = end_tag
    counter = 0
  
    # => REF =~ http://www.rubylife.jp/regexp/ini/index4.html
    while r =~ text[marker..(text.size - 1)] do
    # while r =~ text[marker..(text.size - 1)] && counter < maxnum do
      #debug
      logout("r=" + r.source)
      
      point = (r =~ text[marker..(text.size - 1)])
      
      text.insert(marker + point, t1)
      text.insert(marker + point + t1.size + r.source.size, t2)
  
      marker += point + t1.size + r.source.size + t2.size
      
      counter += 1
  
      
    end#while r =~ text[marker..(text.size - 1)] && counter < maxnum do
    
    return text
    
  end#def _add_span2(text, keyword, start_tag, end_tag)

  def validate_login
    
      if session['user_id']
          
          msg = "session['user_id'] => Set"
        
          write_log(msg, __FILE__, __LINE__)

          redirect_to :controller => "texts", :action => "index"
          
          # session[:return_to] ||= request.referer
#           
          # redirect_to session[:return_to]
        
      else
          msg = "session['user_id'] => Not yet"
        
          write_log(msg, __FILE__, __LINE__)
          
          flash['notice'] = "Please login"
          
          # redirect_to :controller => "members", :action => "login"
          redirect_to :root
          
      end
    
  end#def validate_login
  
end#class TextsController < ApplicationController

#REF=> http://stackoverflow.com/questions/5661466/test-if-string-is-a-number-in-ruby-on-rails
# class String
  # def numeric?
    # return true if self =~ /^\d+$/
    # true if Float(self) rescue false
  # end
# end  

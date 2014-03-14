# -*- coding: utf-8 -*-
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
      
      # Sort ======================================
      #debug
      # default_sort_key = :title
      # default_sort_key = :id
      param_sort = params[:sort]
      
      default_sort_key = _index_param_sort(param_sort)
      
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
      
      #=====================================
      #
      # Edit text => Insert "<br/>" after '。' char
      #
      #=====================================      
      
  
      # @texts = Text.all
  
      respond_to do |format|
          # format.html # index.html.erb
          # format.html {render :action => 'index', :page => 2} # index.html.erb
          # format.html {render :page => 2} # index.html.erb
          # format.html {render :html => {:page => 2}} # index.html.erb
          # format.html.parameters.push("page=2") # index.html.erb
          # format.html {redirect_to :action => 'index', :page => 2} # => このウェブページにはリダイレクト ループが含まれていますbu
          format.html # index.html.erb
          
          # write_log(msg, __FILE__, __LINE__)
          
          format.json { render json: @texts }
      end
      
  end#def index

  # GET /texts/1
  # GET /texts/1.json

  def _index_GetTexts_FilterSince(param_sort, default_sort_key, since, lang_id)
    
      if since == nil

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
              
              # @texts.paginate
              
              return texts
            
          else
              
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
              
              # ((Time.at(since.to_i / 1000) + (9*60*60)).to_s\
                      # + "/utc="\
                      # + (Time.at(since.to_i / 1000).utc + (9*60*60)).to_s)
              
              # @texts.paginate
              
              return texts
            
          else
            
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
    # Validation
    if params[:text] == nil
        
        # session => set?
        session_lang_id = session[:lang_id]
        
        # Session
        if session_lang_id != nil && session_lang_id != ""
            
            #debug
            msg= "params[:text] => nil, 
                    but session[:lang_id] is set => 
                    #{session[:lang_id]}"
                    
            write_log(msg, __FILE__, __LINE__)
          
            lang_id = session_lang_id
            
            return lang_id.to_i
          
        end
        
        #debug
        msg= "params[:text] => nil"
        write_log(msg, __FILE__, __LINE__)
        
        return -1
    
    elsif params[:text] != nil && params[:text] == ""

        #debug
        msg= 'params[:text] != nil && params[:text] == ""'
        write_log(msg, __FILE__, __LINE__)
        
        return -1
      
    else#   params[:text] => {"lang_id"=>""} 
      
        #debug
        msg= "params[:text] => #{params[:text]}"
        write_log(msg, __FILE__, __LINE__)
        
        # 'lang_id' => "" ==> means, the user chose a blank
        # => entry in the 'Lang' dropdown list
        session[:lang_id] = nil
      
      lang_id = params[:text][:lang_id]
      
    end#if params[:text] == nil
    
    # lang_id parameter => set?
    if lang_id != nil && lang_id != ""
        
        session[:lang_id] = lang_id
        
        #debug
        msg= "session[:lang_id] => #{session[:lang_id]}"
        write_log(msg, __FILE__, __LINE__)
        
        return lang_id.to_i
        
    end
    
    # session => set?
    session_lang_id = session[:lang_id]
    
    #debug
    msg= "session[:lang_id] => #{session[:lang_id]}"
    write_log(msg, __FILE__, __LINE__)
    
    # Session
    if session_lang_id != nil && session_lang_id != ""
      
        lang_id = session_lang_id
        
        return lang_id.to_i
      
    end
    
    # No param, no session => return -1
    return -1
    
  end#def _index_param_lang_id
  
  def _index_param_lang_id__D_48_v_1_1a
    
    if params[:text] == nil

        return -1
    
    elsif params[:text] != nil && params[:text] == ""

        return -1
      
    else
      
      lang_id = params[:text][:lang_id]
      
    end
    
    # Session
    if session[:lang_id] != nil && lang_id != ""
      
        lang_id = session[:lang_id]
      
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
      
      point = ""
      
      if (@text.lang != nil and @text.lang.name == "Chinese") ||
          (@text.lang != nil and @text.lang.name == "Japanese")
        
          point = "。"
          
      else
          
          point = "\\."
        
      end
      
      @text.text = @text.text.gsub(/#{point}/, "。<br/>-")
      
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
    
    else
      
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
      
      res = _build_word_list__3_register_words(text_id, word_ids, @text.lang_id)
      
    else
      
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
          
        else
  
        end#if word_list.save
    
      
    end#for i in (0..word_ids.length - 1)
    
  end#def _build_word_list__3_register_words(text_id, word_ids, lang_id)
  
  #===================================
  # => @var words: Array<Word>
  # => @var 
  #===================================
  def _show__1_colorize_words(text)
    
    text_id = text.id
    
    text = Text.find(text_id)
    
    if text == nil
      
      return text
      
    end
    
    
    # => REF http://d.hatena.ne.jp/nakakoh/20080510/1210390013
    # words = Word.find_all_by_text_id(text_id)
    
    words = text.words
    
    #debug
    # msg= words.collect{|w| w.w1}.to_s
    msg= "words => " + words.collect{|w| "#{w.w1}/#{w.w2}/#{w.w3}"}.to_s
    write_log(msg, __FILE__, __LINE__)
    
    
    
    #debug
    msg= "Calling => _show__1_colorize_words__ShrinkWords(words)"
    write_log(msg, __FILE__, __LINE__)
    
    words = _show__1_colorize_words__ShrinkWords(words)
    
    # Shrink => German texts
    if text.lang != nil and text.lang.name == "German"
      
        words = _show__1_colorize_words__ShrinkWords_Ge(words)
    
    end
    
    # words = Word.find_by_text_id(text_id)
    
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
        tag1 = "<span style='color: 
                blue;'onClick='alert(\"#{words[i].w1}"\
                    + " / #{words[i].w2}"\
                    + " / #{words[i].w3}\");'>"
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

    def _show__1_colorize_words__ShrinkWords(words)
        
        len = words.length
        
        #debug
        msg= "len=#{len.to_s}"
        write_log(msg, __FILE__, __LINE__)
        
        new_words = words
        
        len.times do |i|    # => Each word
            
            # #debug
            # msg= "i=#{i.to_s}"
            # write_log(msg, __FILE__, __LINE__)
            
            len.times do |j|# => Lookup
                
                # #debug
                # msg= "i=#{i}/j=#{j}"
                # write_log(msg, __FILE__, __LINE__)
                
                target_w = words[i]
                refer_w  = words[j]
                
                if words[i] == nil or words[j] == nil
                    
                    next
                    
                end
                
                target  = words[i].w1
                
                refer   = words[j].w1
                
                # #debug
                # msg= "target=#{target}/refer=#{refer}"
                # # write_log(msg, __FILE__, __LINE__)
                
                res = refer.include?(target) && refer != target
                # res = refer.include?(target)
                #res = words[j].w1.include?(words[i].w1)
                
                if res == true
                    
                    write_log(msg, __FILE__, __LINE__)
                    new_words = new_words - [target_w]
                    # new_words.delete(target_w)
                    # new_words.delete(words[i])
                  
                    break
                    
                end
=begin
=end
            
            end#len.times do |j|
            
        end#len.times do |i|
        
        return new_words
        
    end#_show__1_colorize_words__ShrinkWords(words)

    def _show__1_colorize_words__ShrinkWords_Ge(words)
        
        len = words.length
        
        # If words has only one Word instance
        #   then, return words unprocessed
        if len < 2
          
          return words
          
        end
        
        #debug
        msg = words.collect{|w| "#{w.w1}/#{w.w2}/#{w.w3}"}.to_s
        
        write_log(msg, __FILE__, __LINE__)
        
        
        # Processing starts
        
        new_words = []; temp_words = []

        
        len.times do |i|
            
            if temp_words.include?(words[i])
                next
            end
            
            target_w = words[i]
            
            if target_w == nil
                
                next
                
            end
            
            # i => Counter for w2, w3
            #i = 1
            k = 1
            
            # flag => Used in building strings for w2 and w3
            # => true if refer word is the second of such in
            # =>    words
            flag = false
            
            len.times do |j|
                
                refer_w = words[j]
                
                if refer_w == nil
                    
                    next
                    
                end
                
                target_w1   = target_w.w1
                refer_w1    = refer_w.w1
                
                # #debug
                # msg = "target_w1=#{target_w1}/refer_w1=#{refer_w1}"
                # write_log(msg, __FILE__, __LINE__)
                
                if target_w1 == refer_w1
                # if target == refer and target_w.w3 != refer_w.w3
                
                    #debug
                    msg = "Equal: target_w1=
                            #{target_w1}/refer_w1=#{refer_w1}"
                    write_log(msg, __FILE__, __LINE__)
                    
                    if target_w != refer_w
                        
                        #debug
                        msg = "Equal: target_w=
                                (#{target_w.w1}-#{target_w.w2})
                                /refer_w=(#{refer_w.w1}-#{refer_w.w2})"
                                
                        write_log(msg, __FILE__, __LINE__)
                        
                            
                        target_w.w2 += " * " + k.to_s + "~" + refer_w.w2
                        #target_w.w2 += "," + k.to_s + "~" + refer_w.w2
                        
                        target_w.w3 += " * " + k.to_s + "~" + refer_w.w3
                        #target_w.w3 += "," + k.to_s + "~" + refer_w.w3
                        #target_w.w2 += "," + i.to_s + "~" + refer_w.w2
                        
                        #target_w.w3 += "," + i.to_s + "~" + refer_w.w3
                        
                        #i += 1
                        k += 1
                            
                        #new_words.push(target_w)
                        
                        temp_words.push(refer_w)
                        
                    end#if target_w != refer_w
                
                else#if target_w1 == refer_w1
                    
                    # #debug
                    # msg = "Not equal: target_w1=#{target_w1}
                            # /refer_w1=#{refer_w1}_w1"
                            
                    write_log(msg, __FILE__, __LINE__)
                    
                end#if target_w1 == refer_w1
                
            end#len.times do |j|
            
            new_words.push(target_w)
            
        end#len.times do |i|
        
        #debug
        
        msg = new_words.collect{|w| "#{w.w1}/#{w.w2}/#{w.w3}"}.to_s
        write_log("new_words => #{msg}", __FILE__, __LINE__)
        
        msg = temp_words.collect{|w| "#{w.w1}/#{w.w2}/#{w.w3}"}
        
        write_log("temp_words => #{msg}", __FILE__, __LINE__)
        
        return new_words
        
    end#_show__1_colorize_words__ShrinkWords_Ge(words)
       
    def _show__1_colorize_words__ShrinkWords_Ge_v_1_0e(words)
        
        len = words.length
        
        # If words has only one Word instance
        #   then, return words unprocessed
        if len < 2
          
          return words
          
        end
        
        #debug
        msg = words.collect{|w| "#{w.w1}/#{w.w2}/#{w.w3}"}.to_s
        
        write_log(msg, __FILE__, __LINE__)
        
        
        # Processing starts
        
        new_words = words
        
        len.times do |i|
        # 1.times do |i|
            
            target_w = words[i]
            
            if target_w == nil
                
                next
                
            end
            
            # i => Counter for w2, w3
            i = 1
            
            # flag => Used in building strings for w2 and w3
            # => true if refer word is the second of such in
            # =>    words
            flag = false
            
            len.times do |j|
                
                refer_w = words[j]
                
                if refer_w == nil
                    
                    next
                    
                end
                
                target = target_w.w1
                refer = refer_w.w1
                
                #debug
                msg = "target=#{target}/refer=#{refer}"
                write_log(msg, __FILE__, __LINE__)
                
                if target == refer
                # if target == refer and target_w.w3 != refer_w.w3
                
                    #debug
                    msg = "Equal: target=#{target}/refer=#{refer}"
                    write_log(msg, __FILE__, __LINE__)
                    
                    if flag == false
                        
                        target_w.w2 = refer_w.w2
                        target_w.w3 = refer_w.w3
                        # target_w.w2 = i.to_s + "~" + refer_w.w2
                        # target_w.w3 = i.to_s + "~" + refer_w.w3
                        
                        flag = true
                        
                    else
                        
                        target_w.w2 += "," + i.to_s + "~" + refer_w.w2
                        
                        target_w.w3 += "," + i.to_s + "~" + refer_w.w3
                        
                        i += 1
                        
                    end
                    
                    
                    new_words -= [refer_w]
                    
                    #debug
                    msg = "word removed => #{refer_w.w1}"
                    
                    write_log(msg, __FILE__, __LINE__)
                
                else#if target == refer
                    
                    #debug
                    msg = "Not equal: target=#{target}/refer=#{refer}"
                    write_log(msg, __FILE__, __LINE__)
                    
                end#if target == refer
                
            end#len.times do |j|
            
            new_words.push(target_w)
            
            #debug
            msg = new_words.collect{|w| "#{w.w1}/#{w.w2}/#{w.w3}"}
            
            write_log(msg, __FILE__, __LINE__)
            
        end#len.times do |i|
        
        
        
        return new_words
        
    end#_show__1_colorize_words__ShrinkWords_Ge(words)
       
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
    
      point = (r =~ text[marker..(text.size - 1)])
      
      text.insert(marker + point, t1)
      text.insert(marker + point + t1.size + r.source.size, t2)
  
      marker += point + t1.size + r.source.size + t2.size
      
      counter += 1
  
      
    end#while r =~ text[marker..(text.size - 1)] && counter < maxnum do
    
    return text
    
  end#def _add_span(text, keyword, start_tag, end_tag)
  
  #===================================
  # _add_span2_GeFrEn(text, word, start_tag, end_tag)
  #
  # Split the text by " ". For each token, process
  #   the tagging
  #===================================
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
              
              text_split[i].insert(point, t1)
              
              
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

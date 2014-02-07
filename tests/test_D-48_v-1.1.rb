# -*- coding: utf-8 -*-
class TEST
    
    attr_accessor :w1, :w2, :w3
    
    
    
end

    def _colorize(words)
        
        len = words.length
        
        # If words has only one Word instance
        #   then, return words unprocessed
        if len < 2
          
          return words
          
        end
        
        #debug
        msg = words.collect{|w| "#{w.w1}/#{w.w2}/#{w.w3}"}.to_s

        # Processing starts
        
        new_words = []; temp_words = []
        
        len.times do |i|
            
            #debug
            puts "i => #{i.to_s}"
            puts
            
            if temp_words.include?(words[i])
                next
            end
            
            target_w = words[i]
            
            if target_w == nil
                
                next
                
            end
            
            # i => Counter for w2, w3
            counter = 1
            
            # flag => Used in building strings for w2 and w3
            # => true if refer word is the second of such in
            # =>    words
            flag = false
            
            len.times do |j|
                
                #debug
                puts "\tj => #{j.to_s}"
                puts
                
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
                    msg = "Judge: (target_w1=
                            #{target_w1}) == (refer_w1=#{refer_w1})"
                    puts "[#{__FILE__} : #{__LINE__}] #{msg}"
                    
                    if target_w != refer_w
                        
                        #debug
                        msg = "Judge: (target_w=
                            (#{target_w.w1}-#{target_w.w2}))
                             != (refer_w=(#{refer_w.w1}-#{refer_w.w2}))"
                                
                        puts "[#{__FILE__} : #{__LINE__}] #{msg}"
                        
                        target_w.w2 += "," \
                                    + counter.to_s \
                                    + "~" \
                                    + refer_w.w2
                        
                        target_w.w3 += "," \
                                    + counter.to_s \
                                    + "~" \
                                    + refer_w.w3
                        
                        counter += 1
                            
                        #new_words.push(target_w)
                        
                        temp_words.push(refer_w)
                        
                        #puts
                        #puts "<new_words>"
                        #p new_words
                        
                        puts
                        puts "<temp_words>"
                        p temp_words
                        
                    else#if target_w != refer_w
                        
                        #debug
                        msg = "Judge: (target_w=
                            (#{target_w.w1}-#{target_w.w2}))
                             == (refer_w=(#{refer_w.w1}-#{refer_w.w2}))"
                                
                        puts "[#{__FILE__} : #{__LINE__}] #{msg}"
                    
                    end#if target_w != refer_w
                
                else#if target_w1 == refer_w1
                    
                    #debug
                    msg = "Judge: (target_w1=
                            #{target_w1}) != (refer_w1=#{refer_w1})"
                    puts "[#{__FILE__} : #{__LINE__}] #{msg}"
                    
                end#if target_w1 == refer_w1
                
            end#len.times do |j|
            
            new_words.push(target_w)
                        
            puts
            puts "<new_words>"
            p new_words
            
        end#len.times do |i|

        
    end#_show__1_colorize_words__ShrinkWords_Ge(words)


def job
    
    t1 = TEST.new()
    t2 = TEST.new()
    
    t3 = TEST.new()
    t4 = TEST.new()
    
    #"["jemals/ever/", "jemals/aaaaa/an-",
    # => "jemals/bbbbb/vor-", "traurig/sad/"] "
    
    t1.w1 = "jemals"; t1.w2 = "ever"; t1.w3 = ""
    t2.w1 = "jemals"; t2.w2 = "aaaaa"; t2.w3 = "an-"
    t3.w1 = "jemals"; t3.w2 = "bbbbb"; t3.w3 = "vor-"
    t4.w1 = "traurig"; t4.w2 = "sad";   t4.w3 = ""
    
    ary1 = [t1, t2, t3, t4]

    p ary1
=begin
    puts "t1 => #{t1.w1}/#{t1.w2}"
    puts "t1.w3 => #{t1.w3.class.to_s}"
    
    puts    
    
    puts "t2 => #{t2.w1}/#{t2.w2}"
    puts "t2.w3 => #{t2.w3.class.to_s}"
    
    puts
=end

    _colorize(ary1)
        
end#def job

job()

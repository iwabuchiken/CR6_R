# -*- coding: utf-8 -*-
class TEST
    
    attr_accessor :a, :b
    
    
    
end

def job
    
    t1 = TEST.new()
    t2 = TEST.new()
    
    t3 = TEST.new()
    t4 = TEST.new()
    
    t1.a = "aaa"; t1.b = "bbb"
    t2.a = "aaa"; t2.b = "2bbb"
    t3.a = "aaa"; t3.b = "3bbb"
    t4.a = "aaa"; t4.b = "bbb"
    
    ary1 = [t1, t2, t3]
    ary2 = [t4]
    
    # ary3 = ary1.collect{|t| ary2.include?(t) ? t : nil}
    
    ary4 = []
    ary3 = ary1.collect{|t|
        # ary2.include?(t) ? t : nil
        keys = ary2.collect{|t| t.b}
        
        keys.include?(t.b) ? t : nil
        
    }.each do |t|
        if t != nil
            ary4.push(t)
        end
    end
    
    # ary4 = []
    # ary3.each do |t|
        # if t != nil
            # ary4.push(t)
        # end
    # end
    
    p ary1
    
    puts "ary3="
    p ary3
    
    puts "ary4="
    p ary4
    
end#def job

def job2
    
    t1 = TEST.new()
    t2 = TEST.new()

    t1.a = "xxxxxxxxxxxx"
    t1.b = "yyyyyyyyyyyyyyy"
    
    p t1
    
    x = t1.a
    
    x = "xx"
    
    p t1
    
end#def job

def job3
    
    t1 = TEST.new()
    t2 = TEST.new()

    t1.a = "xxxxxxxxxxxx"
    t1.b = "yyyyyyyyyyyyyyy"
    
    p t1
    
    x = t1.a
    
    x = "xx"
    
    p t1
    
end#def job3


#job()
job2()

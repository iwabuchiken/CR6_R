require "csv"

require "uri"
require "net/http"

require 'zip/zip'
require 'zip/zipfilesystem'

# require 'fileutils'

# @max_line_num = 3000
# This line is needed; otherwise => C:/WORKS/WS/WS_Android/CR6(R)/lib/utils.rb:5:in `<top (required)>': uninitialized constant Const (NameError)
require_dependency 'const'
include Const

def get_time_label_now()
  
  return Time.now.strftime("%Y/%m/%d %H:%M:%S")
  # return Time.now.strftime("%Y%m%d_%H%M%S")
  
end#def get_time_label_now()

def get_time_label_now_2()
  
  return Time.now.strftime("%Y%m%d_%H%M%S")
  # return Time.now.strftime("%Y%m%d_%H%M%S")
  
end#def get_time_label_now()


def write_log(text, file, line)
    
    # max_line_num = 300
    max_line_num = 20000
    #-----------------------
    # => File exists?
    #-----------------------

    dname = "doc/mylog"
    # fname = "mylog/log.log"
    # f = File.new(dname)
    
    if !File.exists?(dname)
        # => REF mkdir http://ruby-doc.org/stdlib-1.9.3/libdoc/fileutils/rdoc/FileUtils.html
        FileUtils.mkdir dname
    end

    # => REF SEPARATOR: http://doc.ruby-lang.org/ja/1.9.3/class/File.html#C_-P-A-T-H_-S-E-P-A-R-A-T-O-R
    fname = [dname, "log.log"].join(File::SEPARATOR)
    
    if !File.exists?(fname)
        # => REF touch: http://stackoverflow.com/questions/8100574/creating-an-empty-file-in-ruby-touch-equivalent answered Nov 11 '11 at 22:14
        FileUtils.touch(fname)
    end    
    
    
    # f = open(fname, "r")
    f = open(fname, "a")
    # f = open("mylog/log.log", "a")
    # f = open("log.log", "a")
    
    #-----------------------
    # => File full?
    #-----------------------    
    # lines = f.readlines()
    
    # if lines.length > @max_line_num
    
    # if File.size?(fname) > @max_line_num
    # if File.size(fname) && File.size(fname) > @max_line_num
    if File.size(fname) && File.size(fname) > max_line_num
        # => REF rename http://stackoverflow.com/questions/5530479/how-to-rename-a-file-in-ruby answered Apr 3 '11 at 15:29
        # File.rename(f, 
                # dname + File::SEPARATOR +
                # File.basename(f, File.extname(f)) + "_" +
                # get_time_label_now_2 + File.extname(f))
        new_fname = [dname,
                    File.basename(f, File.extname(f)) + "_" +
                      get_time_label_now_2 + File.extname(f)].join(File::SEPARATOR)
        
        # => REF cp: http://miyohide.hatenablog.com/entry/20050916/1126881010
        # => REF cp: http://doc.ruby-lang.org/ja/search/module:FileUtils/query:FileUtils.%23cp/
        FileUtils.cp(fname, new_fname)
                    
                  # File.basename(f, File.extname(f)) + "_" +
                    # get_time_label_now_2 + File.extname(f))
        
        f.close
        
        # f = open(fname, "a")
        f = open(fname, "w")
    
    end
    
      
    
    f.write("[begin]------------------------=\n")
    
    # f.write("[#{get_time_label_now()}]" + line + ": " + text)
    f.write("[#{get_time_label_now()}] [#{file}: #{line}]\n")
    # f.write("\n#{text}")
    # f.write("\n")
    # f.write("\n\nyes")
    f.write(text)
    
    f.write("\n")
    # f.write("<br/>")
    
    if File.size(fname)
        f.write("File size=" + File.size(fname).to_s)
        # f.write("@max_line_num=" + @max_line_num.to_s)
    else 
      
        f.write("File.size(fname) => nil")
      
    end
    
    f.write("------------------------=[end]\n\n")
    
    f.close
  
end#def write_log()

def write_log2(dpath, text, file, line)
    
    # max_line_num = 300
    # max_line_num = 20000
    max_line_num = 40000
    
    #-----------------------
    # => File exists?
    #-----------------------

    dname = dpath
    #dname = "doc/mylog"
    #dname = "doc/mylog/articles"
    # fname = "mylog/log.log"
    # f = File.new(dname)
    
    if !File.exists?(dname)
        # => REF mkdir http://ruby-doc.org/stdlib-1.9.3/libdoc/fileutils/rdoc/FileUtils.html
#        FileUtils.mkdir dname

        #REF http://stackoverflow.com/questions/3686032/how-to-create-directories-recursively-in-ruby answered Sep 10 '10 at 15:49
        FileUtils.mkpath dname
    end

    # => REF SEPARATOR: http://doc.ruby-lang.org/ja/1.9.3/class/File.html#C_-P-A-T-H_-S-E-P-A-R-A-T-O-R
    fname = [dname, "log.log"].join(File::SEPARATOR)
    
    if !File.exists?(fname)
        # => REF touch: http://stackoverflow.com/questions/8100574/creating-an-empty-file-in-ruby-touch-equivalent answered Nov 11 '11 at 22:14
        FileUtils.touch(fname)
    end    
    
    
    # f = open(fname, "r")
    f = open(fname, "a")
    # f = open("mylog/log.log", "a")
    # f = open("log.log", "a")
    
    #-----------------------
    # => File full?
    #-----------------------    
    # lines = f.readlines()
    
    # if lines.length > @max_line_num
    
    # if File.size?(fname) > @max_line_num
    # if File.size(fname) && File.size(fname) > @max_line_num
    if File.size(fname) && File.size(fname) > max_line_num
        # => REF rename http://stackoverflow.com/questions/5530479/how-to-rename-a-file-in-ruby answered Apr 3 '11 at 15:29
        # File.rename(f, 
                # dname + File::SEPARATOR +
                # File.basename(f, File.extname(f)) + "_" +
                # get_time_label_now_2 + File.extname(f))
        new_fname = [dname,
                    File.basename(f, File.extname(f)) + "_" +
                      get_time_label_now_2 + File.extname(f)].join(File::SEPARATOR)
        
        # => REF cp: http://miyohide.hatenablog.com/entry/20050916/1126881010
        # => REF cp: http://doc.ruby-lang.org/ja/search/module:FileUtils/query:FileUtils.%23cp/
        FileUtils.cp(fname, new_fname)
                    
                  # File.basename(f, File.extname(f)) + "_" +
                    # get_time_label_now_2 + File.extname(f))
        
        f.close
        
        # f = open(fname, "a")
        f = open(fname, "w")
    
    end
    
      
    
    f.write("[begin]------------------------=\n")
    
    # f.write("[#{get_time_label_now()}]" + line + ": " + text)
    f.write("[#{get_time_label_now()}] [#{file}: #{line}]\n")
    # f.write("\n#{text}")
    # f.write("\n")
    # f.write("\n\nyes")
    f.write(text)
    
    f.write("\n")
    # f.write("<br/>")
    
    if File.size(fname)
        f.write("File size=" + File.size(fname).to_s + "\n")
        # f.write("@max_line_num=" + @max_line_num.to_s)
    else 
      
        f.write("File.size(fname) => nil")
      
    end
    
    f.write("------------------------=[end]\n\n")
    
    f.close
  
end#write_log2(dpath, text, file, line)

def _backup_path
        
    return Const::BACKUP_PATH
    # return BACKUP_PATH
        
end

# def _backup_db__execute(model_names)
def _backup_db__execute
    
    start = Time.now
    
    msg = ""
    
    # => Dir exists?
    #backup_path = _backup_path
    backup_path = Const::BACKUP_PATH
    
    if !File.exists?(backup_path)
        
        #REF http://stackoverflow.com/questions/3686032/how-to-create-directories-recursively-in-ruby answered Sep 10 '10 at 15:49
        FileUtils.mkpath backup_path
        
        msg += "Dir created: #{backup_path}<br/>"
        
    else
        
        # msg += "Dir exists!!: #{backup_path}"
        msg += "Dir exists: #{backup_path}<br/>"
        
    end
    
    # Get models
    models = get_models
    
    # # Build csv
    # models = [Lang, Word]
    
    class_and_columns = _backup_db__get_columns(models)
    
    counter = _backup_db__create_backup_files(class_and_columns)
    
    msg += "#{counter} model(s) done<br/>"
    
    # write_log2(
            # Const::LOG_PATH,
            # class_and_columns,
            # __FILE__,
            # __LINE__)
    
    now = Time.now
    
    msg += "(#{now - start} seconds)"
    
    return msg
    
end#_backup_db__execute

def get_models()
    
    tmp = Dir.glob(File.join(Const::MODELS_PATH, "*.rb"))
    #tmp = Dir.glob("app/models/*.rb")
    
    models = []
        
    tmp.each do |x|
        
        #REF extension https://www.ruby-forum.com/topic/179524 2009-02-24 00:03
        models.push(File.basename(x, File.extname(x)).classify.constantize)
        # class_names.push(File.basename(x))
        
    end
    
    return models
    
end#get_models()

    def _backup_db__get_columns(class_names)
        
        res = {}
        
        class_names.each_with_index do |x, i|
            
            columns = class_names[i].columns.map{|c| c.name}
            
            res[class_names[i]] = columns
        
        end
        
        return res
        
    end#_backup_db__get_columns

    ################################################
    # => _backup_db__create_backup_files(class_and_columns)
    # => @param
    # =>    class_and_columns
    # =>        {Keyword => ["id", "name", ...], Genre => ...}
    # => @return
    # =>    void
    ################################################
    def _backup_db__create_backup_files(class_and_columns)
        
        models = class_and_columns.keys
        
        counter = 0
        
        models.each do |m|
            
            columns = class_and_columns[m]
        
            #REF table_name http://stackoverflow.com/questions/6139640/how-to-determine-table-name-within-a-rails-3-model-class answered May 26 '11 at 14:12
            table_info = [m.to_s, m.table_name]

            t = Time.now
            
            # fpath = "tmp/backup/backup_#{models[0].to_s}.csv"
            fpath = File.join(
                        _backup_path,
                        "#{m.table_name.singularize.capitalize}_backup.csv")
            
            CSV.open(fpath, 'w') do |w|
                
                w << table_info
                w << [t]
                # w << t
                w << columns
                
                # data
                entries = m.all
                
                entries.each do |e|
                    
                    data = []
                    
                    columns.each do |c|
                        
                        data.push(e[c])
                        
                    end#columns.each do |c|
                    
                    w << data
                    
                end#entries.each do |e|
                
            end#CSV.open(fpath, 'w') do |w|
            
            counter += 1
            
        end#models.each do |m|
        
        #===============================
        #
        #   Zip file
        #
        #===============================
        archive = File.join(Const::BACKUP_PATH, Const::BACKUP_FNAME_CSV)
        
        build_zip_file(archive)
        
        return counter
        
    end#_create_backup_files(class_and_columns)
    
    def _download_file(fullpath)
        
        #REF http://qiita.com/akkun_choi/items/64080a8e17930879b4da
        
        stat = File::stat(fullpath)
        
        send_file(fullpath,
            :filename => File.basename(fullpath),
            :length => stat.size)
        
    end

def _post_data(remote_url, model)
    
    # model_name = model.table_name.singularize.capitalize
    model_name = model.class.to_s
    
    attrs = _get_attrs(model_name)
#     
    values = _get_values(model)
    # # values = _get_values(model_name)
#     
    parameters = _backup_db__build_params(model_name, attrs, values)
=begin
    write_log2(
                  LOG_PATH,
                  "parameters => #{parameters}",
                  # "model_name => #{model_name}/attrs => #{attrs}/values => #{values}",
                  # parameters,
                  # __FILE__,
                  __FILE__.split("/")[-1],
                  __LINE__.to_s)    
=end  

# =begin
    #debug
    write_log2(
                  LOG_PATH,
                  "Posting data => Starts",
                  # __FILE__,
                  __FILE__.split("/")[-1],
                  __LINE__.to_s)

    x = Net::HTTP.post_form(
            URI.parse(URI.encode(remote_url)),
            parameters)
#    x = Net::HTTP.post_form(
#            URI.parse(remote_url),
#            parameters)
    

    #debug
    write_log2(
                  LOG_PATH,
                  "Posting data => Done: result=#{x.message}",
                  # __FILE__,
                  __FILE__.split("/")[-1],
                  __LINE__.to_s)

# =end

    # return "Done"
    return "Done (result => #{x})"
    
end#_post_data(remote_url, model)

def _get_values(model)
    
    values = []
    
    # m = model_name.constantize
    
    if model.class.to_s == "Word"
    #if model == "Word"
        
        values.push(model.w1)
        values.push(model.w2)
        values.push(model.w3)

        values.push(model.text_ids)
        values.push(model.text_id)
        values.push(model.lang_id)
        
        values.push(model.id) # => "dbId"
        values.push(model.id) # => "remote_id"
        
        values.push(model.created_at.to_s)
        # values.push(model.created_at_mill)
        values.push(model.updated_at.to_s)
        # values.push(model.updated_at_mill)
        
    else
        
        return nil
        
    end
    
end#def _get_values(model_name)

def _get_attrs(model_name)
    
    attrs = []
    
    if model_name == "Word"
        
        attrs.push("w1")
        attrs.push("w2")
        attrs.push("w3")
        
        attrs.push("text_ids")
        attrs.push("text_id")
        attrs.push("lang_id")
        
        attrs.push("dbId")
        attrs.push("remote_id")
        
        attrs.push("created_at_mill")
        attrs.push("updated_at_mill")
        
    else
        
        return nil
        
    end
    
end

def _get_backup_url
    
    return BACKUP_URL
    
end

=begin
    _backup_db__build_params(data)
    
    data => {'model_name' => ..., 'attrs' => ...,}
=end
def _backup_db__build_params(model_name, attrs, values)
    # Name
    params = {}
    
    # attrs = [
                # "name", "genre_id", "category_id",
                # "remote_id", "created_at", "updated_at"]
#     
    # values = [
                # kw.name, kw.genre_id, kw.category_id,
                # kw.id, kw.created_at, kw.updated_at]
    
    attrs.size.times do |i|
        
        #REF add element http://www.rubylife.jp/ini/hash/index5.html
        params["data[#{model_name}][#{attrs[i]}]"] = values[i]
        # params["data[Keyword][#{attrs[i]}]"] = values[i]
    
    end

    return params
    
end#_backup_db__build_params

def build_zip_file(archive)
    
    # archive = File.join(Const::BACKUP_PATH, "nr4", Const::BACKUP_FNAME_CSV)
    # archive = File.join(Const::BACKUP_PATH, "nr4", "csv.zip")
    
    Zip::ZipFile.open(archive, 'w') do |zipfile|
        
        # Dir["#{path}/**/**"].reject{|f|f==archive}.each do |file|
        # Dir[File.join(Const::BACKUP_PATH, "nr4") + "/*"].reject{|f|f==archive}.each do |file|
        Dir[Const::BACKUP_PATH + "/*"].reject{|f|f==archive}.each do |file|
          # zipfile.add(file.sub(path+'/',''),file)
            begin
                
                zipfile.add(File.basename(file),file)
                #zipfile.add("csv_files",file)
            
            rescue => e
                
                write_log(
                      @log_path,
                      e.to_s,
                      # __FILE__,
                      __FILE__.split("/")[-1],
                      __LINE__.to_s)

                
            end
        end#Dir[File.join(Const::BACKUP_PATH, "nr4") + "/*"]
        
    end#Zip::ZipFile.open(archive, 'w') do |zipfile|

    
end
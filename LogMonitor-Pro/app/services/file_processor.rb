class FileProcessor
    def initialize(log)
      @log = log
      @file = log.file
    end
  
    def process
      # Download the file to process it
      temp_file = download_blob_to_tempfile
      file_extension = File.extname(temp_file.path).downcase
      
      # Process based on file type
      result = case file_extension
      when '.json'
        parse_json(temp_file)
      when '.dump' # Ruby Marshal format for custom reporting
        marshal_data = File.binread(temp_file)
        Marshal.load(marshal_data)
      when '.csv'
        parse_csv(temp_file)
      else
        parse_text(temp_file)
      end
      
      temp_file.close
      temp_file.unlink
      
      result
    end
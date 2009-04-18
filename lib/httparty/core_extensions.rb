class BlankSlate #:nodoc:
  instance_methods.each { |m| undef_method m unless m =~ /^__/ }
end
 
# 1.8.6 has mistyping of transitive in if statement
require "rexml/document"
module REXML #:nodoc:
  class Document < Element #:nodoc:
    def write( output=$stdout, indent=-1, transitive=false, ie_hack=false )
      if xml_decl.encoding != "UTF-8" && !output.kind_of?(Output)
        output = Output.new( output, xml_decl.encoding )
      end
      formatter = if indent > -1
          if transitive
            REXML::Formatters::Transitive.new( indent, ie_hack )
          else
            REXML::Formatters::Pretty.new( indent, ie_hack )
          end
        else
          REXML::Formatters::Default.new( ie_hack )
        end
      formatter.write( self, output )
    end
  end
end

# Inject Hash#to_params unless it is already defined (Usually by Merb)
unless defined?(Hash.new.to_params)
  class Hash
    def to_params
      params = self.map { |k,v| normalize_param(k,v) }.join
      params.chop! # trailing &
      params
    end
   
    def normalize_param(key, value)
      param = ''
      stack = []
   
      if value.is_a?(Array)
        param << value.map { |element| normalize_param("#{key}[]", element) }.join
      elsif value.is_a?(Hash)
        stack << [key,value]
      else
        param << "#{key}=#{value}&"
      end
   
      stack.each do |parent, hash|
        hash.each do |k, v|
          if v.is_a?(Hash)
            stack << ["#{parent}[#{k}]", v]
          else
            param << normalize_param("#{parent}[#{k}]", v)
          end
        end
      end
   
      param
    end
  end
end

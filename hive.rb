#!/usr/bin/ruby
# works on OSX
require 'java'

lib_path = '/usr/local/Cellar/hive/0.14.0/libexec/lib'

#brew install hive on OSX and the libs are at /usr/local/Cellar/hive/0.14.0/libexec/lib
#for now I opted to import all the jars to avoid dependency hell.
Dir.entries(lib_path).each do |jar|
	require lib_path + jar if File.extname(jar) == '.jar'
end

java_import org.apache.hadoop.hive.ql.lib.DefaultGraphWalker
java_import org.apache.hadoop.hive.ql.lib.DefaultRuleDispatcher
java_import org.apache.hadoop.hive.ql.lib.Dispatcher
java_import org.apache.hadoop.hive.ql.lib.GraphWalker
java_import org.apache.hadoop.hive.ql.lib.Node
java_import org.apache.hadoop.hive.ql.lib.NodeProcessor
java_import org.apache.hadoop.hive.ql.lib.NodeProcessorCtx
java_import org.apache.hadoop.hive.ql.lib.Rule
java_import org.apache.hadoop.hive.ql.parse.ASTNode
java_import org.apache.hadoop.hive.ql.parse.BaseSemanticAnalyzer
java_import org.apache.hadoop.hive.ql.parse.HiveParser
java_import org.apache.hadoop.hive.ql.parse.ParseDriver
java_import org.apache.hadoop.hive.ql.parse.ParseException
java_import org.apache.hadoop.hive.ql.parse.SemanticException
java_import org.apache.hadoop.hive.ql.tools.LineageInfo


testcase_path = '/usr/local/Cellar/hive/0.14.0/libexec/examples/queries/'

test = Proc.new {
	|query|	
	a = LineageInfo.new
	a.getLineageInfo query
	p a.get_input_table_list.to_a
	p a.get_output_table_list.to_a
}

query_arr = Dir.entries(testcase_path).map { |i| testcase_path + i if File.extname(i) ==  '.q' }

query_arr.compact!

query_arr.map { |q| puts q;test.call(IO.read(q)) }


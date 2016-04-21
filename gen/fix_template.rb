# glib for Nim, fix this:
#template G_TYPE_FUNDAMENTAL*(`type`: expr): expr = 

arg0 = ARGV[0]
arg1 = ARGV[1]
text = File.read(arg0)
list = Array.new
text.lines{|line|
	#if m = /^(\s*)(\w+)\* = object $/.match(line)
	if m = /^\s*template #{arg1}(\w+)\*?\(/.match(line)
		list << m[1]
	end
}

list.sort_by!{|el| -el.length}
list.each{|pat|
	re = pat.dup.gsub('_', '')
	re[0] = re[0].downcase
	text.gsub!(/\b#{arg1}#{pat}\b/, re)
	#text.gsub!(arg1, '')
	#text.gsub!('_', '')
}

File.open(arg0, "w") {|file|
	file.write(text)
}


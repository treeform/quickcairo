# GTK3 for nimrod, fix this:
#
# remove the remaining _xxx_ and __yyy__ identifiers by
# just deleteing the underscores but watching for conflicts.
# And remove export markers -- underscore should mark private stuff.
#
arg0 = ARGV[0]
text = File.read(arg0)
list = Array.new
text.lines{|line|
	h = line.scan(/(?:\b__?\w+\*?\b)|(?:\b\w+__?\*?\b)/)
	unless h.empty?
		list += h
	end
}

t = text.upcase
t.gsub!(/PROC \w+\*?\s*\(.*?\)/m, '') # ignore proc parameters
list.uniq!
list.sort_by!{|el| -el.length}
list.each{|pat|
	p = pat.gsub(/^__?/, '')
	p.gsub!(/__?$/, '')
	p.gsub!(/\*$/, '')
	if t.index(/\b#{p.upcase}\b/)
		print 'possible name conflict: ', pat , ' ==> ', p, "\n"
	end
	text.gsub!(/([^"])\b#{pat}(\*|\b)/, '\1' + p)
}
File.open(arg0, "w") {|file|
	file.write(text)
}


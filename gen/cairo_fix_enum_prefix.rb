# Cairo for nim, fix this:
# cairo_content_t* {.size: sizeof(cint).} = enum 
#  CAIRO_CONTENT_COLOR = 0x00001000, CAIRO_CONTENT_ALPHA = 0x00002000, 
# 
list = Array.new
check = Array.new
arg0 = ARGV[0]
text = File.read(arg0)
lines = text.each_line
new = String.new
dep = String.new
l = lines.next.dup

# caution, GIOStatus and such
loop do
	if m = /^( +)([A-Z][a-z]*)?([A-Z]{1,2}[a-z]*)?([A-Z][a-z]+)?([A-Z][a-z]+)?.* = enum$/.match(l)
	#if (m = /^(\s+)([a-z]+_)?([a-z]+_)?([a-z]+_)?([a-z]+_)?.* = enum $/.match(l))
		n = /^\s*(\w+)\* /.match(l)[1]
		list << n
		indent = m[1] + '  '
		a = m[2..5]
		a.compact!
		l.gsub!('.} = enum', ', pure.} = enum')
		p = n.gsub(/T\b/, '')
		p.gsub!("Cairo", '')
		#p.capitalize!
		check << p
		dep << "{.deprecated: [T#{p}: #{p}].}\n"
		new << l
		l = lines.next.dup
		while !a.empty?
			s = a.join('_').upcase + '_'
			#s = a.join('').upcase
			#break if s.length < 3 # do not remove only single letters
			if /#{indent}#{s}/.match(l)
				l.gsub!(' ' + s, ' ')
				l.gsub!(' END,', ' `END`,')
				l.gsub!(/ END$/, ' `END`')
				l.gsub!(' IMPORT,', ' `IMPORT`,')
				l.gsub!(' EXPORT,', ' `EXPORT`,')
				l.gsub!(' BIND,', ' `BIND`,')
				l.gsub!(' INCLUDE,', ' `INCLUDE`,')
				l.gsub!(' IN,', ' `IN`,')
				l.gsub!(' OUT,', ' `OUT`,')
				l.gsub!(' STATIC,', ' `STATIC`')
				l.gsub!(' CONTINUE,', ' `CONTINUE`,')
				new << l
				l = lines.next.dup
				while true do
					if /#{indent}#{s}/.match(l)
						l.gsub!(' ' + s, ' ')
						l.gsub!(' END,', ' `END`,')
						l.gsub!(/ END$/, ' `END`')
						l.gsub!(' IMPORT,', ' `IMPORT`,')
						l.gsub!(' EXPORT,', ' `EXPORT`,')
						l.gsub!(/ EXPORT$/, ' `EXPORT`')
						l.gsub!(' BIND,', ' `BIND`,')
						l.gsub!(' INCLUDE,', ' `INCLUDE`,')
						l.gsub!(' IN,', ' `IN`,')
						l.gsub!(' OUT,', ' `OUT`,')
						l.gsub!(' STATIC,', ' `STATIC`')
						l.gsub!(' CONTINUE,', ' `CONTINUE`,')
						new << l
						l = lines.next.dup
					else
						break
					end
				end
				break # better be carefully and break here
			else
				a.pop
			end
		end
	else
		new << l
		l = lines.next.dup
	end
end

check.each{|el|
	if new.index(' ' + el + ' ')
		puts 'name conflict: ', el
	end
}

list.sort_by!{|el| -el.length}
list.each{|pat|
	p = pat.gsub(/T\b/, '')
	p.gsub!("Cairo", '')
	#p.capitalize!
	new.gsub!(/\b#{pat}\b/, p)
}
#new.gsub!(/(when CAIRO_HAS_XLIB_SURFACE: \n)/, dep + '\1')
File.open(arg0, "w") {|file|
	new.lines{|line|
		file.write(line)
	}
}


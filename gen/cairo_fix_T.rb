# Cairo for Nim, fix this:
#   cairo_surface_t* = object 

check = Array.new
arg0 = ARGV[0]
modname = ARGV[1]
text = File.read(arg0)
new = String.new
sedlist = String.new
list = Array.new
dep = Array.new
text.lines{|line|
	if m = /^(\s*)(\w+)T\* = object$/.match(line)
		list << m[2]
		n = m[2].gsub(/^Cairo/, '')#.capitalize
		check << n
		#dep.push("{.deprecated: [P#{n}: #{n}, T#{n}: #{n}Obj].}\n")
		new << m[1] + n + 'salewski1911* =  ptr ' + n + "Obj\n"  
		new << m[1] + n + 'Ptr* = ptr ' + n + "Obj\n"  
		new << m[1] + n + "Obj* = object\n"  
	else
		new << line
	end
}

check.each{|el|
	if new.index(' ' + el + ' ')
		puts 'name conflict: ', el
	end
}

list.sort_by!{|el| -el.length}.uniq!
list.each{|pat|
	p1 = '\bptr ptr ' + pat + 'T\b'
	p2 = 'vaaaaar' + pat.gsub(/^Cairo/, '')#.capitalize
	sedlist << "s/#{p1}/#{modname}#{p2}/g\n"
	new.gsub!(/#{p1}/, p2)
	p1 = '\bptr ' + pat + 'T\b'
	p2 = 'ptttttr' + pat.gsub(/^Cairo/, '')#.capitalize
	sedlist << "s/#{p1}/#{modname}#{p2}/g\n"
	new.gsub!(/#{p1}/, p2)
	p1 = '\b' + pat + 'T\b'
	p2 = pat.gsub(/^Cairo/, '') + 'Obj'
	sedlist << "s/#{p1}/#{modname}\.#{p2}/g\n"
	new.gsub!(/#{p1}/,  pat + 'O@bj') # with special marker!
}

# we have to care for aliases like
#type 
#  GInitiallyUnowned* = GObjectObj
#  GInitiallyUnownedClass* = GObjectClassObj

list = Array.new
text = new
new = String.new
text.lines{|line|
	if m = /^(\s*)(\w+)\* = (\w+O@bj ?)$/.match(line)
		list << m[2]
		n = m[2]
		#dep.push("{.deprecated: [P#{n}: #{n}, T#{n}: #{n}Obj].}\n")
		new << m[1] + n + 'salewski1911* =  ptr ' + n + "Obj\n"  
		new << m[1] + n + 'Ptr* = ptr ' + n + "Obj\n"  
		new << m[1] + n + "Obj* = #{m[3]}\n"  
	else
		new << line
	end
}

list.sort_by!{|el| -el.length}.uniq!
list.each{|pat|
	p1 = '\bptr ptr ' + pat + '\b'
	p2 = 'vaaaaar' + pat
	sedlist << "s/#{p1}/#{modname}#{p2}/g\n"
	new.gsub!(/#{p1}/, p2)
	p1 = '\bptr ' + pat + '\b'
	p2 = 'ptttttr' + pat
	sedlist << "s/#{p1}/#{modname}#{p2}/g\n"
	new.gsub!(/#{p1}/, p2)
	p1 = '\b' + pat + '\b'
	p2 = pat + 'Obj'
	sedlist << "s/#{p1}/#{modname}\.#{p2}/g\n"
	new.gsub!(/#{p1}/, p2)
}

new.gsub!('O@bj','Obj')

sedlist << "s/#{modname}vaaaaar/var #{modname}\./g\n"
sedlist << "s/#{modname}ptttttr/#{modname}\./g\n"
new.gsub!(/vaaaaar/, 'var ')
new.gsub!(/ptttttr/, '')
new.gsub!(/salewski1911/, '')

new.gsub!(/(when CAIRO_HAS_XLIB_SURFACE: \n)/, dep.uniq.join + '\1')

File.open(arg0, "w") {|file|
	file.write(new)
}

File.open(ARGV[1] + '_sedlist', "w") {|file|
	file.write(sedlist)
}


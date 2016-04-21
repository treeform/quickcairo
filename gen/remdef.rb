# GTK3 for nimrod, fix this:
#
#when not(defined(__DEVICE_H__)): 
#  const 
#    __DEVICE_H__* = true

arg0 = ARGV[0]
text = File.read(arg0)
text << "\n\n\n\n"
lines = text.lines

skip = 0
File.open(arg0, "w") {|file|
	lines.each_cons(4){|l1, l2, l3, l4|
		if skip > 0
			skip -= 1
			next
		end
		m = (/^(  )?when not\(defined\(_?_?\w+_H_?_?\)\): $/.match(l1) || /^(  )?when not defined\(_?_?\w+_H_?_?\): $/.match(l1))
		i = ''
		i = m[1] if m
		if m && /^#{i}  const $/.match(l2) && /^#{i}    _?_?\w+_H_?_?/.match(l3) 
			if /^#{i}    \w/.match(l4)
				file.write(l2)
			end
			skip = 2
		else
			file.write(l1)
		end
	}
}


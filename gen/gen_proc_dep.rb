# GTK3 for nimrod -- allow long deprecated proc names

h = Hash.new
text = File.read( ARGV[0])
File.open('proc_dep_list', "w") {|file|
	text.each_line('proc '){|l|
	m = /^(`?\w+`?)\*.+?"(\w+)"/m.match(l)
	if m
		if m[1] && m[2] && m[1] != '' && m[2] != '' && m[1] != m[2]
			v = m[2].gsub('__', '_')
			if !h.has_key?(v)
				file.write("{.deprecated: [#{v}: #{m[1]}].}\n")
				h[v] = true
			end
		end
	end
	}
}


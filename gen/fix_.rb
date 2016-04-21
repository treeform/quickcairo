# GTK3 for nimrod, fix this:
# typedef struct _GtkWindow GtkWindow;
# remove that line and substitute _GtkWindow with GtkWindow
arg0 = ARGV[0]
text = File.read(arg0)
new = String.new
list = Array.new
text.lines{|line|
	if m = /typedef\s+(?:(?:union)|(?:struct))\s+(_\w+)\s+(\w+)\s*;/.match(line)
		a, b = m[1..2]
		if a == '_' + b
			list << b
		else
			new << line
		end
	else
		new << line
	end
}
list.each{|pat|
	new.gsub!('_' + pat, pat)
}
File.open(arg0, "w") {|file|
	new.lines{|line|
		file.write(line)
	}
}


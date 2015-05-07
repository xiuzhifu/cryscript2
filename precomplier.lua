local m = {}

function m.load(source)
	m.source = source
	m.length = string.len(source)
	m.current = 1
	m.output = ''
	m.skipnote()
	return m.output 
end

function m.skipnote()
	while m.current ~= m.length do
		local w = string.sub(m.source, m.current, m.current)
		if w == '-' then
			w = string.sub(m.source, m.current + 1, m.current + 1)
			if w == '-' then
				while w ~= '\n' do
					m.current = m.current + 1
					w = string.sub(m.source, m.current + 1, m.current + 1)
				end
			end
		end
		m.output = m.output..w
		m.current = m.current + 1
	end
end

return m
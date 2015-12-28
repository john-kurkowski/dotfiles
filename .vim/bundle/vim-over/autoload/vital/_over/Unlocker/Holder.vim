scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! s:_glob(expr, dir)
	let cwd = getcwd()
	try
		execute "lcd" fnameescape(a:dir)
		return filter(split(glob(a:expr), '\n'), "!isdirectory(v:val)")
	finally
		execute "lcd" fnameescape(cwd)
	endtry
endfunction


let s:holder_files = s:_glob("Holder/**", expand("<sfile>:h"))

function! s:_to_modulename(file)
	let result = substitute(a:file, '^Holder[\/]', '', 'g')
	let result = fnamemodify(result, ':r')
	let result = substitute(result, '[\/]', ".", "g")
	return result
endfunction


let s:holder_module_names = map(copy(s:holder_files), "s:_to_modulename(v:val)")


let s:holder_module = {}
function! s:_vital_loaded(V)
	let s:V = a:V
	for name in s:holder_module_names
		let s:holder_module[name] = a:V.import("Unlocker.Holder." . name)
	endfor
endfunction


function! s:_vital_depends()
	return map(copy(s:holder_module_names), "'Unlocker.Holder.' . v:val")
endfunction


function! s:as_get_deepcopy(holder)
	if has_key(a:holder, "__holder_as_get_deepcopy_get")
		return a:holder
	endif
	let result = copy(a:holder)
	let result.__holder_as_get_deepcopy_get = result.get
	function! result.get()
		return deepcopy(self.__holder_as_get_deepcopy_get())
	endfunction
	return result
endfunction


function! s:as_set_extend(holder)
	if has_key(a:holder, "__holder_as_set_extend_set")
		return a:holder
	endif
	let result = copy(a:holder)
	let result.__holder_as_set_extend_set = result.set
	function! result.set(value)
		let result = deepcopy(extend(self.get(), a:value))
		call self.__holder_as_set_extend_set(result)
	endfunction
	return result
endfunction


function! s:get(name)
	return get(s:holder_module, a:name, {})
endfunction


function! s:exists(name)
	return has_key(s:holder_module, a:name)
endfunction


function! s:make(name, ...)
	let module = s:get(a:name)
	if empty(module)
		return {}
	endif
	return call(module.make, a:000, module)
endfunction


" for s:name in s:holder_module_names
" 	execute
" \		"function! s:" . tolower(substitute(s:name, '\.', '_', 'g')) . "(...)\n"
" \		"	return call(s:" . s:name . ".make, a:000, s:" . s:name . ")\n"
" \		"endfunction\n"
" endfor


let &cpo = s:save_cpo
unlet s:save_cpo

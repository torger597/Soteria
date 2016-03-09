//This code is copied or modified from the 2016 Public Goonstation release, originally produced by the Goons from the Something Awful forums.
//Released under a CC BY-NC-SA license.
//Practically Copy-Pasta'd.
/proc/s_es(var/number as num, var/es = 0)
	if (isnull(number))
		return
	if (number == 1)
		return null
	else
		if (es)
			return "es"
		else
			return "s"

/proc/minmax(var/number, var/min, var/max)
	return max(min(number, max), min)

proc/atan2(x, y)
    if(!x && !y) return 0
    return y >= 0 ? arccos(x / sqrt(x * x + y * y)) : -arccos(x / sqrt(x * x + y * y))

proc/get_angle(atom/a, atom/b)
    return atan2(b.y - a.y, b.x - a.x)

/*
proc
    //  returns an angle, [0, 360), from given offsets
    //  0 = north, increases clockwise
    atan2(x, y)
        if(!(x || y)) return 1.#IND
        if(istype(x, /list) && x:len == 2) { y = x[2]; x = x[1] }
        return x >= 0 ? arccos(y / sqrt(x * x + y * y)) : 360 - arccos(y / sqrt(x * x + y * y))
*/

//list2params without the dumb encoding
/proc/list2params_noencode(var/list/L)
	var/strbuild = ""
	var/first = 1
	for(var/x in L)
		strbuild += "[first?"":"&"][x]=[L[x]]"
		first = 0
	return strbuild

/proc/reverse_list(var/list/the_list)
	var/list/reverse = list()
	for(var/i = the_list.len, i > 0, i--)
		reverse.Add(the_list[i])
	return reverse

/turf/var/movable_area_next_type = null
/turf/var/movable_area_prev_type = null

/proc/get_steps(var/atom/ref, var/direction, var/numsteps)
	var/atom/curr = ref
	for(var/num=0, num<numsteps, num++)
		curr = get_step(curr, direction)
	return curr

/proc/movable_area_check(var/atom/A)
	if(!A.loc) return 0
	if(!A) return 0
	if(A.x > world.maxx) return 0
	if(A.x < 1) return 0
	if(A.y > world.maxy) return 0
	if(A.y < 1) return 0
	if(A.density) return 0
	for(var/atom/curr in A)
		if(curr.density) return 0
	return 1

/proc/get_edge_cheap(var/atom/A, var/direction)
	. = A.loc
	switch(direction)
		if(NORTH)
			. = locate(A.x, world.maxy, A.z)
		if(NORTHEAST)
			. = locate(world.maxx, world.maxy, A.z)
		if(EAST)
			. = locate(world.maxx, A.y, A.z)
		if(SOUTHEAST)
			. = locate(world.maxx, 1, A.z)
		if(SOUTH)
			. = locate(A.x, 1, A.z)
		if(SOUTHWEST)
			. = locate(1, 1, A.z)
		if(WEST)
			. = locate(1, A.y, A.z)
		if(NORTHWEST)
			. = locate(1, world.maxy, A.z)

/proc/sanitize_noencode(var/t)
	var/index = findtext(t, "\n")
	while(index)
		t = copytext(t, 1, index) + "#" + copytext(t, index+1)
		index = findtext(t, "\n")

	index = findtext(t, "\t")
	while(index)
		t = copytext(t, 1, index) + "#" + copytext(t, index+1)
		index = findtext(t, "\t")
	return t

/proc/dd_file2list(file_path, separator)
	if(separator == null)
		separator = "\n"
	if(isfile(file_path))
		. = file_path
	else
		. = file(file_path)
	. = dd_text2list(file2text(.), separator)

/proc/dd_replacetext(text, search_string, replacement_string)
	. = dd_text2list(text, search_string)
	. = dd_list2text(., replacement_string)

/proc/dd_replaceText(text, search_string, replacement_string)
	. = dd_text2List(text, search_string)
	. = dd_list2text(., replacement_string)

/proc/dd_text2list(text, separator, var/list/withinList)
	var/textlength = length(text)
	var/separatorlength = length(separator)
	if(withinList && !withinList.len) withinList = null
	var/list/textList = new()
	var/searchPosition = 1
	var/findPosition = 1
	while(1)
		findPosition = findtext(text, separator, searchPosition, 0)
		var/buggyText = copytext(text, searchPosition, findPosition)
		if(!withinList || (buggyText in withinList)) textList += "[buggyText]"
		if(!findPosition) return textList
		searchPosition = findPosition + separatorlength
		if(searchPosition > textlength)
			textList += ""
			return textList

/proc/dd_text2List(text, separator, var/list/withinList)
	var/textlength = length(text)
	var/separatorlength = length(separator)
	if(withinList && !withinList.len) withinList = null
	var/list/textList = new()
	var/searchPosition = 1
	var/findPosition = 1
	while(1)
		findPosition = findtextEx(text, separator, searchPosition, 0)
		var/buggyText = copytext(text, searchPosition, findPosition)
		if(!withinList || (buggyText in withinList)) textList += "[buggyText]"
		if(!findPosition) return textList
		searchPosition = findPosition + separatorlength
		if(searchPosition > textlength)
			textList += ""
			return textList

/proc/dd_list2text(var/list/the_list, separator)
	var/total = the_list.len
	if(!total)
		return
	var/count = 2
	. = "[the_list[1]]"
	while(count <= total)
		if(separator)
			. += separator
		. += "[the_list[count]]"
		count++

/proc/text_input(var/Message, var/Title, var/Default, var/length=MAX_MESSAGE_LEN)
	. = sanitize(input(Message, Title, Default) as text, length)

/proc/scrubbed_input(var/user, var/Message, var/Title, var/Default, var/length=MAX_MESSAGE_LEN)
	. = strip_html(input(user, Message, Title, Default) as null|text, length)

var/global/list/string_cache

/proc/strings(filename as text, key as text, var/accept_absent = 0)
	var/list/fileList
	if(!string_cache)
		string_cache = new
	if(!(filename in string_cache))
		if(fexists("strings/[filename]"))
			string_cache[filename] = list()
			var/list/stringsList = list()
			fileList = dd_file2list("strings/[filename]")
			var/lineCount = 0
			for(var/s in fileList)
				lineCount++
				if (!s)
					continue

				stringsList = dd_text2list(s, "@=")
				if(stringsList.len != 2)
					CRASH("Invalid string list in strings/[filename] - line: [lineCount]")
				if(findtext(stringsList[2], "@,"))
					string_cache[filename][stringsList[1]] = dd_text2list(stringsList[2], "@,")
				else
					string_cache[filename][stringsList[1]] = stringsList[2] // Its a single string!
		else
			CRASH("file not found: strings/[filename]")
	if((filename in string_cache) && (key in string_cache[filename]))
		return string_cache[filename][key]
	else if (accept_absent) //Don't crash, just return null. It's fine. Honest
		return null
	else
		CRASH("strings list not found: strings/[filename], index=[key]")

/proc/corruptText(var/t, var/p)
	if(!t)
		return ""
	var/tmp = ""
	for(var/i = 1, i < length(t), i++)
		if(prob(p))
			tmp += pick("{", "|", "}", "~", "€", "ƒ", "†", "‡", "‰", "¡", "¢", "£", "¤", "¥", "¦", "§", "©", "«", "¬", "®", "°", "±", "²", "³", "¶", "¿", "ø", "ÿ", "þ")
		else
			tmp += copytext(t, i, i+1)
	return tmp
/proc/boutput(target, msg )
	target << msg
/proc/showCoords(x, y, z, plaintext, holder)
	var text
	if (plaintext)
		text += "[x], [y], [z]"
	else
		text += "<a href='?src=[holder ? "\ref[holder]" : "%admin_ref%"];action=jumptocoords;target=[x],[y],[z]' title='Jump to Coords'>[x],[y],[z]</a>"

	return text
function items(search) {
	switch(search[0]){
		case "=":
			
			break;
		default:
			return fuzzy_find(DesktopEntries.applications.values, desktopEntryStrings, search).map((entry)=>{return {
				obj: entry,
				str: entry.name
			}}).slice(0,12);
			break;
	}	
}
function act(search, item) {
	switch(search[0]){
		case "=":
			break;
		default:
			Quickshell.execDetached({
				command: ["app2unit", ...(item.runInTerminal?["-T"]:[]), "--", ...item.command],
				workingDirectory: item.workingDirectory
			});
			break;
	}
}

function desktopEntryStrings(entry) {
	return [entry.name,...entry.keywords]
}

// FUZZY FINDER adapted from microfuzz.js (https://github.com/Nozbe/microfuzz/tree/main)
function normalize(text) {return text.toLowerCase().trim()}
const validWordBoundaries = new Set('  []()-–—\'"“”'.split(''))
function isBoundary(character) {return validWordBoundaries.has(character)}
function matchesFuzzily(item,query){
	if(item===query) return 0
	else if(item.startsWith(query)) return 0.5
	const idx = item.indexOf(query);
	if(idx>-1&&isBoundary(item[idx-1])) return 1
	const itemWords = new Set(item.split(" ")), queryWords = new Set(query.split(" "))
	if(queryWords.length>1 && queryWords.every((word)=>itemWords.has(word))) return 1.5 + queryWords.length*.2
	if(idx>-1) return 2
	const indices = []
	let queryIdx = 0, queryChar = query[queryIdx]
	let chunkFirstIdx = -1, chunkLastIdx = -2
	while(true) {
		const index = item.indexOf(queryChar, chunkLastIdx+1)
		if(index===-1) break;
		if(index===0 || isBoundary(item[index-1])) chunkFirstIdx = index
		else {
			const queryCharsLeft = query.length-queryIdx
			const itemCharsLeft = item.length-index
			const minChunkLen = Math.min(3, queryCharsLeft, itemCharsLeft)
			const minQueryChunk = query.slice(queryIdx, queryIdx+minChunkLen)
			if(item.slice(index, index+minChunkLen)===minQueryChunk) chunkFirstIdx = index
			else {
				chunkLastIdx += 1
				continue
			}
		}
		for(chunkLastIdx = chunkFirstIdx; chunkLastIdx < item.length; chunkLastIdx += 1) {
			if(item[chunkLastIdx]!==queryChar) break;
			queryIdx += 1
			queryChar = query[queryIdx]
		}
		chunkLastIdx -= 1
		indices.push([chunkFirstIdx, chunkLastIdx])
		if(queryIdx===query.length) return scoreConsecutiveLetters(indices, item)
	}
	return null
}
function scoreConsecutiveLetters(indices, item) {
	let score = 2;
	indices.forEach(([firstIdx,lastIdx])=>{
		const chunkLength = lastIdx-firstIdx+1
		const isWordStart = firstIdx===0 || item[firstIdx]===" " || item[firstIdx-1]===" "
		const isWordEnd = lastIdx===item.length-1 || item[lastIdx]===" " || item[lastIdx+1]===" "
		const isFullWord = isWordStart && isWordEnd
		if(isFullWord) score += 0.2
		else if(isWordStart) score += 0.4
		else if(chunkLength >= 3) score += 0.8
		else score += 1.6
	})
	return score;
}
function fuzzy_find(collection, textValuesLambda, query){
	const strings = collection.map((item)=>[item,textValuesLambda(item)]).map((item)=>[item[0],item[1].map((t)=>normalize(t||''))])
	const results = []
	const normal = normalize(query)
	if(!normal.length) return results
	strings.forEach(([item, texts]) => {
		let bestScore = Number.MAX_SAFE_INTEGER
		for(let i = 0, len = texts.length; i < len; i++){
			const result = matchesFuzzily(texts[i], normal)
			if(result!==null) bestScore = Math.min(bestScore, result)
		}
		if(bestScore<Number.MAX_SAFE_INTEGER) results.push({item: item, score: bestScore});
	})
	results.sort((a,b)=>a.score-b.score)
	return results.map(r=>r.item);
}

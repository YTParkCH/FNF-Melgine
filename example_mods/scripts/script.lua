--options

local songPositionBar = false --whether or not the song position/time bar will be active
local judgementCounter = false --self explanatory
local displayAcc = true --whether or not the info bar shows accuracy/ranking details
local laneAlpha = 0 --lane underlay alpha

--real script shit

local ratingFCKade = ''
local ratingNameKade = ''

function onCreatePost()

    setProperty('scoreTxt.visible', false)
    setProperty('timeBarBG.visible', false)
    setProperty('timeBar.visible', false)
    setProperty('timeTxt.visible', false)

    setProperty('grpNoteSplashes.visible', false)
    makeLuaText('newScoreTxt', '', 1000, 0, getProperty('healthBarBG.y') + 50)
    setTextSize('newScoreTxt', 16)
    setTextBorder('newScoreTxt', 1, '000000')
    screenCenter('newScoreTxt', 'X')
    addLuaText('newScoreTxt')
    setObjectCamera('newScoreTxt', 'hud')

    makeLuaText('botPlayState', 'BOTPLAY', 0, getProperty('healthBarBG.x') + getProperty('healthBarBG.width') / 2 - 75, getProperty('healthBarBG.y') - 100)
    setTextSize('botPlayState', 42)
    setTextBorder('botPlayState', 4, '000000')
    addLuaText('botPlayState')
    setObjectCamera('botPlayState', 'hud')
    setProperty('botPlayState.visible', false)

    if judgementCounter then
        makeLuaText('judgementCounterTxt', '', screenWidth, 8, 0)
        setTextSize('judgementCounterTxt', 20)
        setTextBorder('judgementCounterTxt', 2, '000000')
        screenCenter('judgementCounterTxt', 'Y')
        setTextAlignment('judgementCounterTxt', 'left')
        addLuaText('judgementCounterTxt')
        setObjectCamera('judgementCounterTxt', 'hud')
    end

    if songPositionBar then
        makeLuaSprite('songPosBG', 'healthBar', screenWidth / 2 - 300.5, 10)
        scaleObject('songPosBG', 0.88, 1.35)
        screenCenter('songPosBG', 'X')
        addLuaSprite('songPosBG', true)
        setObjectCamera('songPosBG', 'hud')

        makeLuaSprite('songPosBar1', null, screenWidth / 2 - 298, 13)
        makeGraphic('songPosBar1', getProperty('songPosBG.width') - 4, getProperty('songPosBG.height') - 5, '000000')
        screenCenter('songPosBar1', 'X')
        addLuaSprite('songPosBar1', true)
        setObjectCamera('songPosBar1', 'hud')

        makeLuaSprite('songPosBar2', null, screenWidth / 2 - 298, 13)
        makeGraphic('songPosBar2', getProperty('songPosBG.width') - 4, getProperty('songPosBG.height') - 5, '00FF80')
        screenCenter('songPosBar2', 'X')
        addLuaSprite('songPosBar2', true)
        setObjectCamera('songPosBar2', 'hud')
        setProperty('songPosBar2.alpha', 0)

        makeLuaText('songName', songName, 601, screenWidth / 2 - 300.5, getProperty('songPosBG.y') + 3)
        setTextAlignment('songName', 'center')
        setTextSize('songName', 16)
        setTextBorder('songName', 1, '000000')
        screenCenter('songName', 'X')
        addLuaText('songName')
        setObjectCamera('songName', 'hud')
    end

    --downscroll positions
    if downscroll then
        setProperty('kadeEngineWatermark.y', screenHeight * 0.9 + 45)

        setProperty('botPlayState.y', getProperty('healthBarBG.y') + 100)

        if songPositionBar then
            setProperty('songPosBG.y', screenHeight * 0.9 + 45)
            setProperty('songPosBar1.y', screenHeight * 0.9 + 49.5)
            setProperty('songPosBar2.y', screenHeight * 0.9 + 49.5)
            setProperty('songName.y', screenHeight * 0.9 + 45)
        end
    end

    --lane underlays
    if laneAlpha >= 0 then
        makeLuaSprite('laneunderlay', null, defaultPlayerStrumX0 - 25, 0)
        makeGraphic('laneunderlay', 110 * 4 + 50, screenHeight * 2, '000000')
        screenCenter('laneunderlay', 'Y')
        setProperty('laneunderlay.alpha', laneAlpha)
        addLuaSprite('laneunderlay', true)
        setObjectCamera('laneunderlay', 'hud')
        setObjectOrder('laneunderlay', getObjectOrder('strumLineNotes') - 1)
    end

    if laneAlpha >= 0 and not middlescroll then
        makeLuaSprite('laneunderlayOpponent', null, defaultOpponentStrumX0 - 25, 0)
        makeGraphic('laneunderlayOpponent', 110 * 4 + 50, screenHeight * 2, '000000')
        screenCenter('laneunderlayOpponent', 'Y')
        setProperty('laneunderlayOpponent.alpha', laneAlpha)
        addLuaSprite('laneunderlayOpponent', true)
        setObjectCamera('laneunderlayOpponent', 'hud')
        setObjectOrder('laneunderlayOpponent', getObjectOrder('strumLineNotes') - 1)
    end
end

function onUpdate()
    if displayAcc then
        if hits < 1 and misses < 1 then
            setTextString('newScoreTxt', '')
        else
            setTextString('newScoreTxt', ' ')
        end
    else
        if hits < 1 and misses < 1 then
            setTextString('newScoreTxt', '')
        else
            setTextString('newScoreTxt', '')
        end
    end

    if ratingFC == 'SFC' then
        ratingFCKade = 'MFC'
    else
        ratingFCKade = ratingFC
    end

    if judgementCounter then
        setTextString('judgementCounterTxt', 'Sicks: ' .. getProperty('sicks') .. '\nGoods: ' .. getProperty('goods') .. '\nBads: ' .. getProperty('bads') .. '\nShits: ' .. getProperty('shits'))
    end

    if songPositionBar then
        setTextString('songName', songName .. " (" .. milliToHuman(math.floor(songLength - (getPropertyFromClass('Conductor', 'songPosition') - noteOffset))) .. ")")
    end

    if botPlay and getProperty('botplayTxt.visible') == true then
        setProperty('botplayTxt.visible', false)
    end

    if botPlay and getProperty('botPlayState.visible') == false then
        setProperty('botPlayState.visible', true)
        setProperty('newScoreTxt.visible', false)
    elseif not botPlay and getProperty('botPlayState.visible') == true then
        setProperty('botPlayState.visible', false)
        setProperty('newScoreTxt.visible', true)
    end

    --sorry this could probably be so much better
    if rating >= 0.999935 then
        ratingNameKade = 'AAAAA'
    elseif rating >= 0.99980 then
        ratingNameKade = 'AAAA:'
    elseif rating >= 0.99970 then
        ratingNameKade = 'AAAA.'
    elseif rating >= 0.99955 then
        ratingNameKade = 'AAAA'
    elseif rating >= 0.9990 then
        ratingNameKade = 'AAA:'
    elseif rating >= 0.9980 then
        ratingNameKade = 'AAA.'
    elseif rating >= 0.9970 then
        ratingNameKade = 'AAA'
    elseif rating >= 0.99 then
        ratingNameKade = 'AA:'
    elseif rating >= 0.9650 then
        ratingNameKade = 'AA.'
    elseif rating >= 0.93 then
        ratingNameKade = 'AA'
    elseif rating >= 0.90 then
        ratingNameKade = 'A:'
    elseif rating >= 0.85 then
        ratingNameKade = 'A.'
    elseif rating >= 0.80 then
        ratingNameKade = 'A'
    elseif rating >= 0.70 then
        ratingNameKade = 'B'
    elseif rating >= 0.60 then
        ratingNameKade = 'C'
    elseif rating <= 0.60 then
        ratingNameKade = 'D'
    end
end

function onSongStart()
    if songPositionBar then
        daSongLength = getProperty('songLength') / 1000

        --i have zero clue if using lua tweens for this is the right idea but for now this is what i'm doing
        doTweenX('timeStart', 'songPosBar2.scale', 0.001, 0.001, 'linear')
    end
end

function round(x, n) --https://stackoverflow.com/questions/18313171/lua-rounding-numbers-and-then-truncate
    n = math.pow(10, n or 0)
    x = x * n
    if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
    return x / n
end

function milliToHuman(milliseconds) -- https://forums.mudlet.org/viewtopic.php?t=3258
	local totalseconds = math.floor(milliseconds / 1000)
	local seconds = totalseconds % 60
	local minutes = math.floor(totalseconds / 60)
	minutes = minutes % 60
	return string.format("%02d:%02d", minutes, seconds)  
end

--icons
function onUpdatePost()
    setProperty('iconP1.y', getProperty('healthBar.y') + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26 - 50)
    setProperty('iconP2.y', getProperty('healthBar.y') + (150 * getProperty('iconP2.scale.x') - 150) / 2 - 26 - 50)
end

function onBeatHit()
    setProperty('iconP1.scale.x', 1.3)
    setProperty('iconP1.scale.y', 1.3)
    setProperty('iconP2.scale.x', 1.3)
    setProperty('iconP2.scale.y', 1.3)
end

function onTweenCompleted(tag)
    if songPositionBar then
        if tag == 'timeStart' then
            setProperty('songPosBar2.origin.x', 0)
            doTweenX('timeFill', 'songPosBar2.scale', 1, daSongLength, 'linear')
            setProperty('songPosBar2.alpha', 1)
        end
    end
end
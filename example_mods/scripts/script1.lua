function onSongStart()

    for i = 0, getProperty('opponentStrums.length') - 1 do

        setPropertyFromGroup('opponentStrums', i, 'visible', false);

        local strum = 'dadStrum' .. i;
        local dir = 'LEFT';

        if i == 1 then
            dir = 'DOWN';
        elseif i == 2 then
            dir = 'UP'
        elseif i == 3 then
            dir = 'RIGHT';
        end

        makeAnimatedLuaSprite(strum, getPropertyFromGroup('opponentStrums', i, 'texture'),
            getPropertyFromGroup('opponentStrums', i, 'x', 200), getPropertyFromGroup('opponentStrums', i, 'y'));
        addAnimationByPrefix(strum, 'static', 'arrow' .. dir);
        scaleObject(strum, getPropertyFromGroup('opponentStrums', i, 'scale.x'),
            getPropertyFromGroup('opponentStrums', i, 'scale.y'));
        setObjectCamera(strum, 'hud');
        addLuaSprite(strum);
        objectPlayAnimation(strum, 'static');
    end
end

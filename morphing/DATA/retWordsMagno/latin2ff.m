function ffword = latin2ff(word, offset)
    % cambiamos el codigo ascii usando el decalaje dado por cada script
    % Primero hay que limpiar las tildes
    chars_old = 'ÁÉÍÓÚáéíóúÑñÜü';
    chars_new = 'AEIOUaeiouNnUu';
    [tf, loc] = ismember(word, chars_old);
    word(tf) = chars_new(loc(tf));
    % Make this a function, we don't like for-s in Matlab
    for j = 1:length(word)
        ffword(j) = char(offset + abs(word(j))); 
    end
end

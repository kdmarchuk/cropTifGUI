function outStack = reduceBitDepth( fileStack,c )
%reduceBitDepth Kyle Marchuk, March 2017
%   This function reduces the size of the cropped file by changing the bit
%   depth of the tif. If 16-bit is selected, the decimals are rounded off.
%   If 8-bit is selected, each stack is normalized to its brightest pixel.
%   R2015b

    dimensions = size(fileStack);
    tempStack = zeros(dimensions,'uint16');
    for ii = 1:dimensions(3)
        tempStack(:,:,ii) = uint16(round(fileStack(:,:,ii)));
    end % for
    
    maxArray = zeros(1,dimensions(3));
    if strcmp(c,'uint8')
        for ii = 1:dimensions(3)
            maxArray(ii) = max(max(tempStack(:,:,ii)));
            maxInt = max(maxArray);
        end % for
        outStack = zeros(dimensions,'uint8');
        for ii = 1:dimensions(3)
            outStack(:,:,ii) = uint8(round(fileStack(:,:,ii)/maxInt*255));
        end % for
    else
        outStack = tempStack;
    end % if

end % reduceBitDepth


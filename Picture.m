classdef Picture < handle
    % generation of the background picture
    
    properties
        N; % size
    end
    
    methods
        % constructor of picture samle(size)
        function pic = Picture(size)
            size = uint16(size);
            if size>0
                pic.N = size;
            else error('wrong size of picture') % size of picture should be integer
            end
        end
    end
    
    methods
        % make blank background with zero intensities
        function B = blank(pic)
            B = zeros(pic.N,pic.N, 'uint8');
        end
    end
    
end


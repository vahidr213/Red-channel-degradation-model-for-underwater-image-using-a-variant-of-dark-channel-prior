im=imread(fileNameDataSet);
im2 = im;
%%%%%% destructing image
gsdestruction = 3;
[medtransMat , globalBackgLight]  =  mediumtransmissionMat ( im , gsdestruction ) ;
im2( : , : , 1) = im2uint8( im2double( im( : , : , 1) ) .* medtransMat - ( globalBackgLight(1) ) * ( 1 - medtransMat) );

function [medtransMat , globalBackgLight]  =  mediumtransmissionMat ( im , gs ) 
###### gs must be an odd num

im = im2double(im);
imheight = size ( im , 1 ) ;
imwidth = size ( im , 2 ) ;

## find brightest pixel in the dark channel- red
maxvalred  =  max  ( max ( im (  :  ,  :  ,  1  )   )   ) ;
indxmaxvalred = find ( im ( : , : , 1 )  == maxvalred ) ;
## green global background light- scalar
greenglobalBackLight = im ( indxmaxvalred ( 1 ) +imheight*imwidth ) ;
## blue global background light- scalar
blueglobalBackLight = im ( indxmaxvalred ( 1 ) +2*imheight*imwidth ) ;

globalBackgLight = double ( [maxvalred , greenglobalBackLight , blueglobalBackLight] );

##  medium transmission size is as im
mediumtransmission = zeros ( imheight , imwidth ) ;

##  gs is grid size

for r = 1:imheight
    for c = 1:imwidth
##      four corners of rect
      rmin = r- ( gs-1 ) /2;
      rmax = r+ ( gs-1 ) /2;
      cmin = c- ( gs-1 ) /2;
      cmax = c+ ( gs-1 ) /2;
##      if rmin is out of boundary
      if  ( rmin<1 ) 
        rmin = 1;
        rmax = rmin + gs - 1;
      endif
##      if cmin is out of boundary
      if  ( cmin<1 ) 
        cmin = 1;
        cmax = cmin+gs - 1;
      endif
##      if rmax is out of boundary
      if  ( rmax>imheight ) 
        rmax = imheight;
        rmin = rmax - gs - 1;
      endif
##      if cmax is out of boundary
      if  ( cmax>imwidth ) 
        cmax = imwidth;
        cmin = cmax - gs - 1;
      endif
    
##    get gs by gs patch from image
      patchImage =  im ( rmin:rmax , cmin:cmax , 1:3 );

##    find the min of each patch- scalar
      minpatchred = min ( min ( 1 - patchImage ( : , : , 1 ) ) );
      minpatchgreen = min ( min ( patchImage ( : , : , 2 )  )  ) ;
      minpatchblue = min ( min ( patchImage ( : , : , 3 )  )  ) ;

##    normalize green and blue by local back light
      patchImage ( : , : , 1 ) = patchImage ( : , : , 1 ) / ( 1 - maxvalred );
      patchImage ( : , : , 2 )  = patchImage ( : , : , 2 ) /greenglobalBackLight;
      patchImage ( : , : , 3 )  = patchImage ( : , : , 3 ) /blueglobalBackLight;

##    min of green and blue patches-scalar
      minpatch = min ( minpatchgreen , minpatchblue ) ;
      minpatch = min ( minpatch , minpatchred );
      
##    medium transmission- scalar
      mediumtransmission ( r , c )  = 1 - minpatch;
      
    endfor # for c
    
endfor  # for r
medtransMat = mediumtransmission;
##  disp ( 'min of mediumtransmission:' ) 
##  min ( min ( mediumtransmission )  ) 
##  disp ( 'max of mediumtransmission:' ) 
##  max ( max ( mediumtransmission )  ) 
  
end  % end of function
##clc
##clear all
##close all
##
##pkg load image
###### number of available pictures in dataset
###### put dataset in folder and use 
####prefix "water" prefix
##npicdataset = 100;
###### num of bins for histogram computation
##nBins = 256;
####pixel pdf for each pixel 
##
##
##redHists = zeros ( nBins , npicdataset ) ;
##greenHists = zeros ( nBins , npicdataset ) ;
##blueHists = zeros ( nBins , npicdataset ) ;
##for i = 1:npicdataset
##  fileNameDataSet = sprintf ( 'E:/MS/VisualStudio/opencv4.2exampleproject/WaterDataSet/water  ( %d ) .png' , i ) ;
##  im = im2double ( imread ( fileNameDataSet )  ) ;
####  dims of image
##  imheight = size ( im , 1 ) ;
##  imwidth = size ( im , 2 ) ;
##
#### find brightest pixel in the dark channel- red
##  maxvalred = max ( max ( im ( : , : , 1 )  )  ) ;
##  indxmaxvalred = find ( im ( : , : , 1 )  =  = maxvalred ) ;
#### green global background light- scalar
##  greenglobalBackLight = im ( indxmaxvalred ( 1 ) +imheight*imwidth ) ;
#### blue global background light- scalar
##  blueglobalBackLight = im ( indxmaxvalred ( 1 ) +2*imheight*imwidth ) ;
##  
####  medium transmission size is as im
##  mediumtransmission = zeros ( imheight , imwidth ) ;
####  restored image - color
##  imrestored = zeros ( imheight , imwidth , 3 ) ;
####  gs is grid size
##  gs = 3;
##for r = 1:imheight
##    for c = 1:imwidth
####      four corners of rect
##      rmin = r- ( gs-1 ) /2;
##      rmax = r+ ( gs-1 ) /2;
##      cmin = c- ( gs-1 ) /2;
##      cmax = c+ ( gs-1 ) /2;
####      if rmin is out of boundary
##      if  ( rmin<1 ) 
##        rmin = 1;
##        rmax = rmin+gs;
##      endif
####      if cmin is out of boundary
##      if  ( cmin<1 ) 
##        cmin = 1;
##        cmax = cmin+gs;
##      endif
####      if rmax is out of boundary
##      if  ( rmax>imheight ) 
##        rmax = imheight;
##        rmin = rmax-gs;
##      endif
####      if cmax is out of boundary
##      if  ( cmax>imwidth ) 
##        cmax = imwidth;
##        cmin = cmax-gs;
##      endif
##    
####    get gs by gs patch from image
##      patchImage = im ( rmin:rmax , cmin:cmax , 1:3 ) ;
####    normalize green and blue by local back light
##      patchImage ( : , : , 2 )  = patchImage ( : , : , 2 ) /greenglobalBackLight;
##      patchImage ( : , : , 3 )  = patchImage ( : , : , 3 ) /blueglobalBackLight;
####    find the min of each patch- scalar
##      minpatchgreen = min ( min ( patchImage ( : , : , 2 )  )  ) ;
##      minpatchblue = min ( min ( patchImage ( : , : , 3 )  )  ) ;
####    min of green and blue patches-scalar
##      minpatch = min ( minpatchgreen , minpatchblue ) ;
####    medium transmission- scalar
##      mediumtransmission ( r , c )  = 1-minpatch;
##      
##    endfor # for c
##    
##endfor  # for r
##  disp ( 'min of mediumtransmission:' ) 
##  min ( min ( mediumtransmission )  ) 
##  disp ( 'max of mediumtransmission:' ) 
##  max ( max ( mediumtransmission )  ) 
##  mediumtransmission = im2uint8 ( mediumtransmission ) ;
##  
##  mediumtransmission = im2uint8 ( mediumtransmission>145 ) ;
##
####  show the medium transmission
##  medd ( : , : , 1 )  = mediumtransmission;
##  medd ( : , : , 2 )  = mediumtransmission;
##  medd ( : , : , 3 )  = mediumtransmission;
##  
##  disp ( 'min of mediumtransmission:' ) 
##  min ( min ( medd )  ) 
##  disp ( 'max of mediumtransmission:' ) 
##  max ( max ( medd )  ) 
##  
##  im =  ( imread ( fileNameDataSet )  ) ;
##  sidebysideimage = cat  ( 2 ,  im ,  medd ) ;
##  figure , imshow ( sidebysideimage ) ;
##  
####  termred = maxvalred.* ( 1-mediumtransmission ) ;
####  termgreen = greenglobalBackLight.* ( 1-mediumtransmission ) ;
####  termblue = blueglobalBackLight.* ( 1-mediumtransmission ) ;
####  imrestored ( : , : , 1 )  = im ( : , : , 1 ) -termred;
####  imrestored ( : , : , 1 )  = imrestored ( : , : , 1 ) ./ ( eps+mediumtransmission ) ;
##  waitforbuttonpress;
######  show the restored image
####  imrestored ( : , : , 3 )  = im ( : , : , 3 ) ;
####  imrestored ( : , : , 2 )  = im ( : , : , 2 ) ;
####  imrestored = uint8 ( 255*imrestored ) ;
####  imwrite ( imrestored , 'result.jpg' ) ;
####  figure , imshow ( imrestored ) ;
##  close all
##  clear all
##end  ## end for npicdataset

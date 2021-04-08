# Red-channel-degradation-model-for-underwater-image-using-a-variant-of-dark-channel-prior


Red channel degradation model for underwater image using a variant of dark channel prior

The importance of numeral quality measuring of enhancements made by any restoring method is crucial since image enhancement is mostly certified by visual inspection. Like any other areas, perfect images are not available in many situations. In case of underwater images, we are highly posed this way. The dataset provided in [1] contains 890 underwater images in which a few non-degraded images can be found. These perfect images are best choices to opt for reference inputs. Therefore, we requirea mathematical model for red channel degradation.
The problem of measuring the amount of improvement after enhancing image is crucial provided that we form a degraded image from an perfect image that exhibits no haze and blurring. So you can add haze to your haze free (reference) images and then apply your restoring method to estimate the haze free image back. In this way, you can measure the quality of your restoration method by computing mean square error or L2 Norm and etc.
The following code provides a model based on medium transmission in underwater images. The medium transmission is computed based on Dark Channel Prior. To estimate medium transmission, it is supposed that a haze free environment is colourful with some shadows. Therefore, at least one colour channel has some pixel with low intensity. This assumption is called Dark Channel Prior. Here, we are going to employ a variant of dark channel prior [2] suitable for hazing underwater images.
The equation that is used to calculate medium transmission is as follows:

t(x)=1-min⁡( {min┬(y∈Ω(x) )⁡( 1-I^R (y))/(1-A^R )  }  {(min┬(y∈Ω(x) ) I^G (y))/A^G }  {(min┬(y∈Ω(x) ) I^B (y))/A^B })

Where each of {} is provided from Red, Green and Blue channels from the image.
The following degradation model is used on the red channel:
I(x) = J(x)t(x) - A ( 1 – t(x) )
To increase the amount of degradation, the term A ( 1 – t(x) ) is subtracted from J(x)t(x).
To show an example of degrading red channel using the above model for an almost clear underwater image see the image below.
![image](https://user-images.githubusercontent.com/6873668/114090074-32ebda00-98cc-11eb-991e-f7e8a5deed99.png)

 
Red Channel Degraded image						Original Image		

[1]	https://li-chongyi.github.io/proj_benchmark.html

[2]	Automatic Red-Channel Underwater Image Restoration



Code:
Use this script to run the mediumtransmissionMat() function. Assign the path to your image into fileNameDataSet.
Notice: the parameter gsdestruction is set to 3 but feel free to change it with any greater odd number.


          im=imread(fileNameDataSet);
          im2 = im;
          %%%%%% destructing image
          gsdestruction = 3;
          [medtransMat , globalBackgLight]  =  mediumtransmissionMat ( im , gsdestruction ) ;
          im2( : , : , 1) = im2uint8( im2double( im( : , : , 1) ) .* medtransMat - ( globalBackgLight(1) ) * ( 1 - medtransMat) );


Definition of mediumtransmissionMat:


        function [medtransMat , globalBackgLight]  =  mediumtransmissionMat ( im , gs ) 
        %%%%%% gs must be an odd num
        im = im2double(im);
        imheight = size ( im , 1 ) ;
        imwidth = size ( im , 2 ) ;
        %% find brightest pixel in the dark channel- red
        maxvalred  =  max  ( max ( im (  :  ,  :  ,  1  )   )   ) ;
        indxmaxvalred = find ( im ( : , : , 1 )  == maxvalred ) ;
        %% green global background light- scalar
        greenglobalBackLight = im ( indxmaxvalred ( 1 ) +imheight*imwidth ) ;
        %% blue global background light- scalar
        blueglobalBackLight = im ( indxmaxvalred ( 1 ) +2*imheight*imwidth ) ;
        globalBackgLight = double ( [maxvalred , greenglobalBackLight , blueglobalBackLight] );
        %%  medium transmission size is as im
        mediumtransmission = zeros ( imheight , imwidth ) ;
        %%  gs is grid size
        for r = 1:imheight
            for c = 1:imwidth
        %%      four corners of rect
              rmin = r- ( gs-1 ) /2;
              rmax = r+ ( gs-1 ) /2;
              cmin = c- ( gs-1 ) /2;
              cmax = c+ ( gs-1 ) /2;
        %%      if rmin is out of boundary
              if  ( rmin<1 ) 
                rmin = 1;
                rmax = rmin + gs - 1;
              endif
        %%      if cmin is out of boundary
              if  ( cmin<1 ) 
                cmin = 1;
                cmax = cmin+gs - 1;
              endif
        %%      if rmax is out of boundary
              if  ( rmax>imheight ) 
                rmax = imheight;
                rmin = rmax - gs - 1;
              endif
        %%      if cmax is out of boundary
              if  ( cmax>imwidth ) 
                cmax = imwidth;
                cmin = cmax - gs - 1;
              endif    
        %%    get gs by gs patch from image
              patchImage =  im ( rmin:rmax , cmin:cmax , 1:3 );
        %%    find the min of each patch- scalar
              minpatchred = min ( min ( 1 - patchImage ( : , : , 1 ) ) );
              minpatchgreen = min ( min ( patchImage ( : , : , 2 )  )  ) ;
              minpatchblue = min ( min ( patchImage ( : , : , 3 )  )  ) ;
        %%    normalize green and blue by local back light
              patchImage ( : , : , 1 ) = patchImage ( : , : , 1 ) / ( 1 - maxvalred );
              patchImage ( : , : , 2 )  = patchImage ( : , : , 2 ) /greenglobalBackLight;
              patchImage ( : , : , 3 )  = patchImage ( : , : , 3 ) /blueglobalBackLight;
        %%    min of green and blue patches-scalar
              minpatch = min ( minpatchgreen , minpatchblue ) ;
              minpatch = min ( minpatch , minpatchred );      
        %%    medium transmission- scalar
              mediumtransmission ( r , c )  = 1 - minpatch;     
            endfor % for c    
        endfor  % for r
        medtransMat = mediumtransmission;
        end  % end of function

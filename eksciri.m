function eksciri()
  
f1 = figure('units','normalized','position', [0.05 0.3 1 0.5])
ax1 = axes('units','normalized','position', [0.04 0.6 0.3 0.3])
ax2 = axes('units','normalized','position', [0.4 0.6 0.3 0.3])
ax3 = axes('units','normalized','position', [0.4 0.1 0.3 0.3])

txt1 =uicontrol('units','normalized','style','text','string',...
'Distance: ','position',[0.76 0.9 0.1 0.05])
edit1 = uicontrol('units','normalized','style','edit','string',...
'','position',[0.87 0.91 0.05 0.04])

txt2 =uicontrol('units','normalized','style','text','string',...
'Angle : ','position',[0.76 0.825 0.1 0.05])
edit2 = uicontrol('units','normalized','style','edit','string',...
'','position',[0.87 0.826 0.05 0.04])

txt3 =uicontrol('units','normalized','style','text','string',...
'Levels: ','position',[0.76 0.75 0.1 0.05])
edit3 = uicontrol('units','normalized','style','edit','string',...
'','position',[0.87 0.756 0.05 0.04])

push1 = uicontrol('units','normalized','style','pushbutton','string',...
'Buka File','position',[0.06 0.9 0.1 0.05],'callback',{@browse ax1}) 
push2 = uicontrol('units','normalized','style','pushbutton','string',...
'Konversi ','position',[0.42 0.9 0.1 0.05],'callback',{@convert ax2 edit1 edit2 edit3}) 

txt4=uicontrol('units','normalized','style','text','string',...
'GLCM : ','position',[0.76 0.58 0.1 0.05])

txt5 =uicontrol('units','normalized','style','text','string',...
'Contrast    : ','position',[0.76 0.50 0.1 0.05])
edit4 = uicontrol('units','normalized','style','edit','string',...
'','position',[0.86 0.50 0.05 0.05],'enable','off')

txt6 =uicontrol('units','normalized','style','text','string',...
'Homogeneity : ','position',[0.76 0.45 0.1 0.05])
edit5 = uicontrol('units','normalized','style','edit','string',...
'','position',[0.86 0.45 0.05 0.05],'enable','off')

txt7 =uicontrol('units','normalized','style','text','string',...
'Dissimilarity      : ','position',[0.76 0.40 0.1 0.05])
edit6 = uicontrol('units','normalized','style','edit','string',...
'','position',[0.86 0.40 0.05 0.05],'enable','off')


push3 = uicontrol('units','normalized','style','pushbutton','string',...
'Ekstrasi ciri','position',[0.76 0.65 0.1 0.08],'callback',{@GLCM edit4 edit5 edit6}) 

txt8 =uicontrol('units','normalized','style','text','string',...
'Training 1  ','position',[0.06 0.45 0.1 0.06])
push4 = uicontrol('units','normalized','style','pushbutton','string',...
'Save ','position',[0.06 0.39 0.1 0.05],'callback',{@training1 edit4 edit5 edit6 ax1}) 
push5 = uicontrol('units','normalized','style','pushbutton','string',...
'OK ','position',[0.06 0.34 0.1 0.05]) 

txt9 =uicontrol('units','normalized','style','text','string',...
'Training 2  ','position',[0.2 0.45 0.1 0.06])
push6 = uicontrol('units','normalized','style','pushbutton','string',...
'Save ','position',[0.2 0.39 0.1 0.05],'callback',{@training2 edit4 edit5 edit6 ax1}) 
push7 = uicontrol('units','normalized','style','pushbutton','string',...
'OK ','position',[0.2 0.34 0.1 0.05])

push8 = uicontrol('units','normalized','style','pushbutton','string',...
'Klasifikasi ','position',[0.42 0.45 0.1 0.05],'callback',{@klasifikasi edit4 edit5 edit6 ax3})
endfunction

function browse(hObject, eventdata, ax1)
  [namafile pathfile] = uigetfile('*.jpg',  'buka file jpg')
  img1 = imread([pathfile namafile]);
  axes(ax1);
  imshow(img1);
  save img1.mat img1
endfunction

function convert(hObject, eventdata, ax2, edit1, edit2, edit3)
  warning('off','all');
  pkg load image
  load img1.mat
  gray1 = (rgb2gray(img1));
  axes(ax2);
  imshow(gray1);
  save gray1.mat gray1
  
  dist=str2num(get(edit1,'string'));
  agl=str2num(get(edit2,'string'));
  lvl=str2num(get(edit3,'string'));
  
  glcm=graycomatrix(gray1,lvl,dist,agl);
  save glcm.mat glcm
  glcm
endfunction

function GLCM(hObject, eventdata,edit4, edit5, edit6)
  pkg load image
  load glcm.mat;
  contrast=0;
  homogenity=0;
  dissimilarity=0;
  ukuran=size(glcm)
  
  for i=1:ukuran(1)
    for j=1:ukuran(2)
      contrast=contrast+(glcm(i,j,1)*(i-j)*(i-j))
    endfor
  endfor
  contrast= contrast
  set(edit4,'string',num2str(contrast));
    for i=1:ukuran(1)
    for j=1:ukuran(2)
      homogenity=homogenity+(glcm(i,j,1)/1+((i-j)*(i-j))); 
    endfor
  endfor
  homogenity= homogenity/10
  set(edit5,'string',num2str(homogenity));
  
      for i=1:ukuran(1)
    for j=1:ukuran(2)
      dissimilarity=dissimilarity+(-log(glcm(i,j,1))*glcm(i,j,1)); 
    endfor
  endfor
  dissimilarity= dissimilarity/100
  set(edit6,'string',num2str(dissimilarity));
  
endfunction

function training1(hObject, eventdata, edit4, edit5,edit6,ax1)
 kontras1=str2num(get(edit4,'string'))
  homogen1=str2num(get(edit5,'string'))
  diss1=str2num(get(edit6,'string'))
  ciri1=[kontras1,homogen1,diss1]
  save ciri1.mat ciri1
endfunction

function training2(hObject, eventdata, edit4, edit5,edit6,ax1)
 kontras2=str2num(get(edit4,'string'))
  homogen2=str2num(get(edit5,'string'))
  diss2=str2num(get(edit6,'string'))
  ciri2=[kontras2,homogen2,diss2]
  save ciri2.mat ciri2
endfunction

function klasifikasi(hObject, eventdata, edit4, edit5,edit6,ax3)
   pkg load image
  load ciri1.mat
  load ciri2.mat
  
 kontras_img=str2num(get(edit4,'string'))
 homogen_img=str2num(get(edit5,'string'))
 diss_img=str2num(get(edit6,'string'))
 ciri_img=[kontras_img,diss_img,homogen_img]

  eu1 = (ciri1(1)-kontras_img)^2+(ciri1(2)-homogen_img)^2+(ciri1(3)-diss_img)^2;
  eu2 = (ciri2(1)-kontras_img)^2+(ciri2(2)-homogen_img)^2+(ciri2(3)-diss_img)^2;
 
 if eu1<eu2
 citra1 = imread('sunflower1.jpg');
 axes(ax3)
 imshow(citra1)
 
else 
 citra2 = imread('layar1.jpg');
 axes(ax3)
 imshow(citra2)   
 endif
endfunction
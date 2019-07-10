%Date:2015-01-29
%Hujing
close all;
clear;
clc;
X_old=[-1000.00 -105.00 -95.00 -90.00 -85.00 -80.00 -75.00 -70.00 -65.00 -60.00 -55.00 ...
    -50.00 -45.00 -40.00 -35.00 -30.00 -25.00 -20.00 -15.00 -10.00 -5.00 0.00 5.00 ...
    10.00 15.00 20.00 25.00 30.00 35.00 40.00 45.00 50.00 55.00 60.00 65.00 70.00 75.00 ...
    80.00 85.00 90.00 95.00 100.00 105.00 110.00 115.00 120.00 125.00 130.00 135.00 140.00 ...
    145.00 150.00 155.00 160.00 1000.00];
Y_old=[-1000.00 -55.00 -45.00 -40.00 -35.00 -30.00 -25.00 -20.00 -15.00 -10.00 ...
    -5.00 0.00 5.00 10.00 15.00 20.00 25.00 30.00 35.00 40.00 45.00 50.00 60.00 70.00 80.00 105.00 1000.00];
Z_old=[-1000.00 0.00 3.00 5.00 7.00 9.00 11.00 13.00 18.00 40.00 1000.00];


X_old=[-1000.00  -105.00  -101.00   -97.00   -93.00   -89.00   -85.00 ...
    -81.00   -77.00   -73.00   -69.00   -65.00   -61.00   -57.00  ...
    -53.00   -49.00   -45.00   -41.00   -37.00   -33.00   -29.00   -25.00 ...
    -21.00   -17.00   -13.00    -9.00    -5.00    -1.00     3.00     7.00  ...
    11.00    15.00    19.00    23.00    27.00    31.00    35.00    39.00    43.00 ...
    47.00    51.00    55.00    59.00    63.00    67.00    71.00    75.00    79.00 ...
    83.00    87.00    91.00    95.00    99.00   103.00   107.00   111.00   115.00 ...
    119.00   123.00   127.00   131.00   135.00   139.00   143.00   147.00   151.00 ...
    155.00   159.00  1000.00]; 
Y_old=[-1000.00   -55.00   -51.00   -47.00   -43.00   -39.00   -35.00   -31.00 ...
    -27.00   -23.00   -19.00   -15.00   -11.00    -7.00    -3.00     1.00  ...
    5.00     9.00    13.00    17.00    21.00    25.00    29.00    33.00    37.00 ...
    41.00    45.00    49.00    53.00    57.00    61.00    65.00    69.00    73.00 ...
    77.00    81.00    85.00    89.00    93.00    97.00   101.00   105.00  1000.00 ];
Z_old=[-1000.00     0.00     2.00     4.00     6.00     8.00    10.00    12.00  ...
    16.00    40.00  1000.00 ];






dx=10;dy=10;
X_NEW=[-1000 ];Y_NEW=[-1000 ];
for i=-105:dx:160
    X_NEW=[X_NEW i];
end
X_NEW = [X_NEW  1000];
for i=-55:dy:105
    Y_NEW=[Y_NEW i];
end
Y_NEW = [Y_NEW  1000];                                                                            
Z_NEW=[-1000    0   4  7  10  13 18 40 1000 ];
% get origin grid space
mod=textread('MOD.bakusc');
mod=textread('MOD_bakinverted4x4kmOnlyPwave');
nx=mod(1,2);
ny=mod(1,3);
nz=mod(1,4);
X=mod(2,1:nx);
Y=mod(3,1:ny);
Z=mod(4,1:nz);
% input velocity  model
vpvs  = mod(5:end,1:nx);
vp = vpvs(1:ny*nz,:);
vps = vpvs(ny*nz+1:end,:);
vs = vp./vps;
disp('X grids : ');disp(num2str(X,'%4.2f'));
disp('Y grids : ');disp(num2str(Y,'%4.2f'));
disp('Z grids : ');disp(num2str(Z,'%4.2f'));
Vp=zeros(ny,nx,nz);Vs=zeros(ny,nx,nz);
for k=1:nz
    for i=1:nx
        for j=1:ny
            Vp(j,i,k)=vp((k-1)*ny+j,i);
            Vs(j,i,k)=vs((k-1)*ny+j,i);
        end
    end
end
[XI,YI,ZI]=meshgrid(X,Y,Z);
[XII,YII,ZII]=meshgrid(X_NEW,Y_NEW,Z_NEW);
Vp_new=interp3(XI,YI,ZI,Vp,XII,YII,ZII,'linear');
Vs_new=interp3(XI,YI,ZI,Vs,XII,YII,ZII,'linear');
vp=zeros(length(Y_NEW)*length(Z_NEW),length(X_NEW));
vs=zeros(length(Y_NEW)*length(Z_NEW),length(X_NEW));
for k=1:length(Z_NEW)
    for j=1:length(Y_NEW)
        vs((k-1)*length(Y_NEW)+j,:)=Vs_new(j,:,k);
        vp((k-1)*length(Y_NEW)+j,:)=Vp_new(j,:,k);
    end
end
vps = vp./vs;
bld=0.1;
fid=fopen('MOD_new','w');
fprintf(fid,'%4.1f%3i%3i%3i',bld,length(X_NEW),length(Y_NEW),length(Z_NEW));
C={'%8.2f ','\n'};
format_X=[C{[2,ones(1,length(X_NEW))]}];
fprintf(fid,format_X,X_NEW);
format_Y=[C{[2,ones(1,length(Y_NEW))]}];
fprintf(fid,format_Y,Y_NEW);
format_Z=[C{[2,ones(1,length(Z_NEW))]}];
fprintf(fid,format_Z,Z_NEW);
fprintf(fid,'\n');
for  i=1:size(vp,1)
    fprintf(fid,'%s\n',num2str(vp(i,:),'%8.3f'));
end
for  i=1:size(vps,1)
    fprintf(fid,'%s\n',num2str(vps(i,:),'%8.3f'));
end
fclose(fid);
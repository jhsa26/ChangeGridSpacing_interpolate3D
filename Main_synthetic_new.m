%Date:2015-01-29
%Hujing
close all;
clear;
clc;
 X_NEW=[-500.00   -40.00   -35.00   -30.00   -26.00   -22.00   -18.00   -15.00 ...
     -12.00    -9.00    -6.00    -3.00     0.00     3.00     6.00    10.00   ...
     15.00    20.00    30.00    43.00   500.00 ];
 Y_NEW=[-500.00   -16.00   -10.00    -6.00    -3.00     0.00     2.00    ...
     4.00     6.00     9.00    15.00   500.00 ];
 Z_NEW=[-500.00     0.00     5.00     6.00     7.00     8.00     9.00 ...
     10.00    11.00    13.00    25.00   550.00 ];

% get origin grid space
mod=textread('./Input/GuoHao_MOD');
nx=mod(1,2);
ny=mod(1,3);
nz=mod(1,4);
X=mod(2,1:nx);
Y=mod(3,1:ny);
Z=mod(4,1:nz);
% input velocity  model
vp = load('./Input/GuoHao_Vp.dat');
vs = load('./Input/GuoHao_Vs.dat');
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
fid=fopen('MOD_VpVs','w');
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


%% only output Vp
fid=fopen('MOD_Vp','w');
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
fclose(fid);
%% Only Output Vs

fid=fopen('MOD_Vs','w');
fprintf(fid,'%4.1f%3i%3i%3i',bld,length(X_NEW),length(Y_NEW),length(Z_NEW));
C={'%8.2f ','\n'};
format_X=[C{[2,ones(1,length(X_NEW))]}];
fprintf(fid,format_X,X_NEW);
format_Y=[C{[2,ones(1,length(Y_NEW))]}];
fprintf(fid,format_Y,Y_NEW);
format_Z=[C{[2,ones(1,length(Z_NEW))]}];
fprintf(fid,format_Z,Z_NEW);
fprintf(fid,'\n');
for  i=1:size(vs,1)
    fprintf(fid,'%s\n',num2str(vp(i,:),'%8.3f'));
end
fclose(fid);
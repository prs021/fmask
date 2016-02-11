function clr_pct = Fmask(im,cldpix,sdpix,snpix,cldprob,num_Lst)
% 3.0 stand alone version
% Output image data description:
% This algorithm provide mask for cloud, cloud Shadow, Snow, Land, and Water.
% bsq ENVI readable '*Fmask' image
tic
[zen,azi,ptm,Temp,t_templ,t_temph,Water,Snow,Cloud,Shadow,dim,ul,resolu,zc]=plcloud(im,cldprob,num_Lst);
clr_pct = fcssm(im,zen,azi,ptm,Temp,t_templ,t_temph,Water,Snow,Cloud,Shadow,dim,ul,resolu,zc,cldpix,sdpix,snpix);
fprintf('Fmask finished for %s with %.2f%% clear pixels\n',im,clr_pct);
toc
end
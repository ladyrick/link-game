close all;clc;clear;
addpath('tools');



[t,omg,FT,IFT] = prefourier([0,50*pi],1000,[0,pi],1000);

a = sin(linspace(0,50*pi,1000))';
f = FT*a;
figure;plot(t,a);
figure;plot(omg,abs(f))
[~,index] = max(abs(f));

f(index-2:index+2)
b=f(index)
angle(b)/pi*180


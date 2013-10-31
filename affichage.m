clc
clear all
close all

load('SCFDE.mat');
semilogy(TEB_zf,'r')
hold on

load('OFDM.mat');
semilogy(TEB_zf,'g')
hold off

xlabel('Es/No');
ylabel('TEB');
legend('SCFDE','OFDM');
title('64-QAM avec ZF');
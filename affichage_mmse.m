clc
clear all
close all


load('SCFDE.mat');


semilogy(EbNo(1,:),TEB_mmse(1,:),'r')
hold on
semilogy(EbNo(2,:),TEB_mmse(2,:),'r+-')
hold on
semilogy(EbNo(3,:),TEB_mmse(3,:),'rs-')
hold on
semilogy(EbNo(4,:),TEB_mmse(4,:),'r*-')
hold on
semilogy(EbNo(5,:),TEB_mmse(5,:),'rx-')
hold on

load('OFDM.mat');


semilogy(EbNo(1,:),TEB_mmse(1,:),'g')
hold on
semilogy(EbNo(2,:),TEB_mmse(2,:),'g+-')
hold on
semilogy(EbNo(3,:),TEB_mmse(3,:),'gs-')
hold on
semilogy(EbNo(4,:),TEB_mmse(4,:),'g*-')
hold on
semilogy(EbNo(5,:),TEB_mmse(5,:),'gx-')
hold off

xlabel('Eb/No');
ylabel('TEB');
legend('SCFDE 4-QAM','SCFDE 8-QAM','SCFDE 16-QAM','SCFDE 32-QAM','SCFDE 64-QAM',...
    'OFDM 4-QAM','OFDM 8-QAM','OFDM 16-QAM','OFDM 32-QAM','OFDM 64-QAM');
title('Egaliseur MMSE');
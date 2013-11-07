clc
clear all
close all

%%% Canal A
load('SCFDE.mat');
semilogy(EbNo(5,:),TEB_mmse(5,:),'r')
hold on
semilogy(EbNo(5,:),TEB_zf(5,:),'r+-')
hold on


%%% Canal B
load('SCFDE_B.mat');
semilogy(EbNo(5,:),TEB_mmse(5,:),'b')
hold on
semilogy(EbNo(5,:),TEB_zf(5,:),'b+-')
hold on


%%% Canal C
load('SCFDE_C.mat');
semilogy(EbNo(5,:),TEB_mmse(5,:),'g')
hold on
semilogy(EbNo(5,:),TEB_zf(5,:),'g+-')
hold on


xlabel('Eb/No');
ylabel('TEB');
legend('canal A avec MMSE','canal A avec ZF','canal B avec MMSE',...
    'canal B avec ZF','canal C avec MMSE','canal C avec ZF');
title('SCFDE 64 QAM');
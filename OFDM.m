clc
clear all
close all

%%% Constantes
NFFT = 512;     % nb de symbole par bloc
Ntrame = 10 ;   % nb de trames
N = NFFT*Ntrame;       % nb de symboles QAM
Ncp = 32;       % longueur du prefixe


%%%%%%%% Emetteur

j=1;
etats = [4 8 16 32 64];
couleur = ['r' 'g' 'b' 'm' 'k'];

for M = etats
    
    %%% Modulateur QAM
    mapping = modem.qammod('M',M,'SymbolOrder','Gray','Input','Bit');
    
    i=1;
    echelle = 0:100;
    TEB_zf = zeros(1,length(echelle));
    TEB_mmse = zeros(1,length(echelle));
    
    for EsNo = echelle
        
        %%% Modulation
        bits = randi([0 1],log2(M),N);
        x = modulate(mapping,bits);
        
        
        %%% IFFT
        x_tmp = reshape(x,Ntrame,NFFT);
        x_ifft = ifft(x_tmp,NFFT,2);
        
        %%% Prefixe cyclique
        x_cp = [x_ifft(:,end-Ncp+1:end) x_ifft]; % Ajout du prefixe cyclique de taille Ncp
        
        
        %%%%%%%%%% Canal
        
        
        %%% Canal de Proakis
        Ha = [0.004,-0.05,0.07,-0.21,-0.5,0.75,0.36,0,0.21,0.03,0.07];
        Hb = [0.407,0.812,0.407];
        Hc = [0.227,0.46,0.688,0.460,0.227];
        canal = Ha;
        
        
        %%% Canal AWGN
        sigma1 = var(x)/(2*(10^(EsNo/10)));
        [dim1,dim2] = size(x_cp);
        bruitI = sqrt(sigma1).*randn(dim1,dim2);
        bruitQ = sqrt(sigma1).*randn(dim1,dim2);
        bruit = bruitI + 1j*bruitQ;

        
        reception = filter(canal,1,x_cp,[],2) + bruit;
        
        
        %%%%%%%%%%%%  Recepteur
        

        y_cp = reception(:,(Ncp+1):end);
        
        
        %%% FFT
        y_fft = fft(y_cp,NFFT,2);
        
        
        %%% Egaliseur
        H = fft(canal,NFFT);
        Wzf = conj(H)./(abs(H).^2);
        Wmmse = conj(H)./(abs(H).^2+(1/(EsNo)));
        
        y_eq_zf = y_fft.*repmat(Wzf,Ntrame,1);
        y_eq_mmse = y_fft.*repmat(Wmmse,Ntrame,1);
        
        y_eq_zf = reshape(y_eq_zf,1,N);
        y_eq_mmse = reshape(y_eq_mmse,1,N);
        
        
        %%% Decision
        demodObj = modem.qamdemod(mapping,'DecisionType','Hard');
        
        decision_zf = demodulate(demodObj,y_eq_zf);
        decision_mmse = demodulate(demodObj,y_eq_mmse);
        
        
        %%% Nombre d'erreurs apres demodulation
        nb_erreur_zf = sum(sum(decision_zf~=bits));
        nb_erreur_mmse = sum(sum(decision_mmse~=bits));
        [dim1,dim2] = size(bits);
        TEB_zf(i) = nb_erreur_zf / (dim1*dim2);
        TEB_mmse(i) = nb_erreur_mmse / (dim1*dim2);
        
        i= i+1;
        
    end
    
    semilogy(echelle,TEB_mmse,couleur(j))
    
    hold on
    j= j+1;
    
end

hold off
xlabel('Es/No');
ylabel('TEB');
legend('4-QAM','8-QAM','16-QAM','32-QAM','64-QAM');
title('SC-FDE avec ZF');

save('SCFDE.mat','TEB_zf','TEB_mmse')
close all 
clear all
clc

%% Carico i dati delle traiettorie

load car0.mat
load car1.mat

figure(1)
plot(car0(:,1), car0(:,2),'o');
title('Punti della traiettoria - Plot preliminare');
grid on

figure(2)
plot(car1(:,1), car1(:,2),'o');
title('Punti della traiettoria - Plot preliminare');
grid on

%% utilizzo delle spline - traiettoria 0

%faccio un tentativo preliminare con la spline calcolata classicamente
%pur aspettandomi che il risultato non sia corretta, per capire come
%modificare eventualmente la funzione spline
disegno1= linspace(min(car0(:,1)), max(car0(:,1)),1000);
disegno2= linspace(min(car1(:,1)), max(car1(:,1)),1000);
tempo1= linspace(min(car0(:,3)), max(car0(:,3)),1000);
tempo2= linspace(min(car1(:,3)), max(car1(:,3)),1000);

%s0=spline_nat(car0(:,1),car0(:,2),disegno)

%tratto= linspace(-4.368019365260635e+02, 5.435300578266384e+02, 1000);

%costruzione "a mano dei vettori richiesti per il plot"
down0= [-436.801936526063,221.765070850202,39; -379.843956918846,90.8440182186235,36.5000000000000; -296.943605713991,-151.261244939271,30; -125.661316348947,-126.261244939271,19.5000000000000; 62.0928338649241,-123.680850202429,11.4000000000000; 283.684148915576,-147.313876518219,74.2500000000000; 442.471949832241,-147.971771255061,70.5000000000000; 543.530057826638,-48.6296659919028,65.2500000000000];
up0= [-436.801936526063,221.765070850202,39; -388.865735449499,335.580860323887,45; -267.500839416025,280.975597165992,49.5000000000000; 11.3610545452623,-2.57703441295551,56.7000000000000; 268.793196473152,-34.1559817813766,61.5000000000000; 543.530057826638,-48.6296659919028,65.2500000000000];
s0_down=spline_nat(down0(:,1),down0(:,2),disegno1);
s0_up=spline_nat(up0(:,1),up0(:,2),disegno1);

figure(3)
plot(car0(:,1), car0(:,2),'o',disegno1,s0_down, 'r', 'LineWidth', 3);
hold on 
plot(disegno1,s0_up, 'r', 'LineWidth', 3);
grid on
title('Utilizzo di spline naturali per disegno traiettoria')

%% utilizzo delle spline - traiettoria 1
down1= [-455.909627418661,306.633491902834,44.1000000000000; -392.917318593007,119.796085887796,40.5000000000000; -263.841257215732,-165.077034412956,31.5000000000000 ; -110.521200863099,-144.682297570850,21.7500000000000; 283.684148915576,-147.313876518219,75 ; 283.68414891557677,-147.31387651821977,0; 459.046483116692,-145.998087044535,70.5000000000000; 536.633086360742,-45.9980870445345,65.2500000000000];
up1= [-455.909627418661,306.633491902834,44.1000000000000; -315.677552041451,338.212439271255,46.5000000000000 ; -162.502166135076,166.182149797571,51; 3.08849544379474,2.02822874493921,57.3000000000000; 164.551338479445,-31.5244028340082,60; 350.257399580492,-34.8138765182186,63; 536.633086360742,-45.9980870445345,65.2500000000000];
s1_down=spline_nat(down1(:,1),down1(:,2),disegno2);
s1_up=spline_nat(up1(:,1),up1(:,2),disegno2);

figure(4)
plot(car1(:,1), car1(:,2),'o', disegno2,s1_down, 'b', 'LineWidth', 3);
hold on 
plot(disegno2,s1_up, 'b', 'LineWidth', 3);
grid on
title('Utilizzo di spline naturali per disegno traiettoria')

%% utilizzo della spline prima su x,t e poi su y,t
s0x=spline_nat(car0(:,3),car0(:,1),tempo1);
s0y=spline_nat(car0(:,3),car0(:,2),tempo1);
s1x=spline_nat(car1(:,3),car1(:,1),tempo2);
s1y=spline_nat(car1(:,3),car1(:,2),tempo2);

figure(5)
plot(car0(:,1), car0(:,2),'o', s0x, s0y, 'b', 'LineWidth', 3);
grid on
title('Macchina 0 - Utilizzo di spline naturali per disegno traiettoria')

figure(6)
plot(car1(:,1), car1(:,2),'o', s1x, s1y, 'r', 'LineWidth', 3);
grid on
title('Macchina 1 - Utilizzo di spline naturali per disegno traiettoria')

%% calcolo dello spazio percorso - car0
%inizializzo a zero lo spazio percorso
s0(1,1)=0; %spazio percorso
s0(1,2)=0; %istante iniziale

for ii=1:12
diff(1)=car0(ii,1) - car0(ii+1,1); %vettore differenza lungo x
diff(2)=car0(ii,2) - car0(ii+1,2); %vettore differenza lungo y
s0(ii+1,1)= s0(ii,1)+norm(diff); %norma euclidea del vettore
s0(ii+1,2)=car0(ii+1,3);
end

%plot dello spazio percorso
disegno3= linspace( min(s0(:,2)), max(s0(:,2)), 10000); 
spazio0=spline_nat(s0(:,2),s0(:,1),disegno3);

figure(7)
plot(s0(:,2), s0(:,1), 'o',disegno3, spazio0, 'LineWidth', 3);
title('Macchina 0 - Spazio percorso')
grid on

%% calcolo dello spazio percorso - car1
%inizializzo a zero lo spazio percorso
s1(1,1)=0; %spazio percorso
s1(1,2)=0; %istante iniziale

for ii=1:12
diff(1)=car1(ii,1) - car1(ii+1,1); %vettore differenza lungo x
diff(2)=car1(ii,2) - car1(ii+1,2); %vettore differenza lungo y
s1(ii+1,1)= s1(ii,1)+norm(diff); %norma euclidea del vettore
s1(ii+1,2)=car1(ii+1,3);
end

%plot dello spazio percorso
disegno4= linspace( min(s1(:,2)), max(s1(:,2)), 10000); %vettore dei tempi
spazio1=spline_nat(s1(:,2),s1(:,1),disegno4); %

figure(8)
plot(s1(:,2), s1(:,1), 'o',disegno4, spazio1, 'LineWidth', 3);
title('Macchina 1 - Spazio percorso')
grid on

%% distanza totale percorsa
dist_tot_0=s0(end,1);
dist_tot_1=s1(end,1);

%% determinare le velocità
%utilizzo del metodo delle differenze  - car0
v0(1,1)=0; %velocità iniziale nulla
v0(1,2)=0; %tempo zero

%qui io inizialmente l'avevo fatto solamente sui 12 punti dati dal problema, 
%poi ho cambiato considerando tutti i valori ottenuti tramite spline
%tuttavia sono più convinto che sia corretto farlo a partire dai dati
%iniziali
N= length(disegno3); 

for jj= 2:N
    v0(jj,1)= (spazio0(jj) - spazio0(jj-1))/(disegno3(jj) - disegno3(jj-1)); %calcolo della velocità
    v0(jj,2)= disegno3(jj); %assegnazione del tempo corrispondente
end

%utilizzo del metodo delle differenze  - car0
v1(1,1)=0; %velocità iniziale nulla
v1(1,2)=0; %tempo zero
N1=length(disegno4);
for jj= 2:N1
    v1(jj,1)= (spazio1(jj) - spazio1(jj-1))/(disegno4(jj) - disegno4(jj-1)); %calcolo della velocità
    v1(jj,2)= disegno4(jj); %assegnazione del tempo corrispondente
end

%plot delle velocità

figure(9)
plot(disegno3,v0(:,1),'r', disegno4, v1(:,1), 'b');
title('andamento velocita');
legend('vettura 0', 'vettura 1');
grid on

%% calcolo delle velocità massime e del tempo a cui sono raggiunte

v0_max= max(v0(:,1));
t0_max= v0(v0== max(v0(:,1)),2);

v1_max= max(v1(:,1));
t1_max= v1(v1== max(v1(:,1)),2);


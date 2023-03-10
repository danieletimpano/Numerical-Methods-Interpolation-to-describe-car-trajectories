function s=spline_nat(x,y,zi,type,der)
%SPLINE_NAT calcola una spline cubica
%   S=SPLINE_NAT(X,Y,ZI) calcola le valutazioni
%   nei nodi ZI della spline cubica naturale che
%   interpola i valori Y relativi ai nodi X.
%   S=SPLINE_NAT(X,Y,ZI,TYPE,DER) se TYPE=0
%   calcola le valutazioni nei nodi ZI della
%   spline cubica interpolante i valori Y con
%   derivata prima assegnata agli estremi (DER(1)
%   e DER(2)). Se TYPE=1 i valori DER(1) e DER(2)
%   si riferiscono ai valori della derivata seconda.
[n,m]=size(x);
if n == 1
    x = x';    y = y';    n = m;
end
if nargin == 3
    der0 = 0; dern = 0; type = 1; % spline cubica interpolatoria naturale
else
    der0 = der(1); dern = der(2);
end
h = x(2:end)-x(1:end-1);
e = 2*[h(1); h(1:end-1)+h(2:end); h(end)];
A = spdiags([[h; 0] e [0; h]],-1:1,n,n);
d = (y(2:end)-y(1:end-1))./h;
rhs = 3*(d(2:end)-d(1:end-1));
if type == 0
    A(1,1) = 2*h(1);   A(1,2) = h(1);
    A(n,n) = 2*h(end); A(end,end-1) = h(end);
    rhs = [3*(d(1)-der0); rhs; 3*(dern-d(end))];
else
    A(1,:) = 0; A(1,1) = 1;
    A(n,:) = 0; A(n,n) = 1;
    rhs = [der0; rhs; dern];
end
S = zeros(n,4);
S(:,3) = A\rhs;
for m = 1:n-1
    S(m,4) = (S(m+1,3)-S(m,3))/3/h(m);
    S(m,2) = d(m) - h(m)/3*(S(m + 1,3)+2*S(m,3));
    S(m,1) = y(m);
end
S = S(1:n-1, 4:-1:1);  pp = mkpp(x,S);
s = ppval(pp,zi);
return

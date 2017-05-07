%Q8
clear
% Scrambling with the seed scr The initial sequence scr_ini should be produced from the seven least significant digits of 
% your student ID number.
ID = [8 1 9 9 0 1 4];

scr_ini = ID - mean(ID);
%scr = uint8([1 1 1 1 1 1 1]) ; % the scrambler seed
scr = scr_ini;

% 7 a) 
msg = '<ding yalei><ydin0002@student.monash.edu>';
a = ('4B19DFA5');
b = dec2hex(msg);
b = b(:)';
msgF = [b, a];
%  scrambled message  msgF_scr 
% convert msgF  hex to bin
[ta, tb] = size(msgF);
msgF_t = zeros(1, 4 * tb);

for i = 1:tb
    h2b = dec2bin(hex2dec(msgF(i)), 4);
    for j = 1: 4
        msgF_t(1, (i - 1) * 4 + j) = h2b(j) - '0';
    end
end

msgF_bc = msgF_t(:)';
msgF_b = uint8(msgF_bc);

n = numel(msgF_b);

msgF_Scr = zeros(1, n, 'uint8');

% 7 b) scrambling sequence  scr.  is calued in the next loop
s = zeros(1, n, 'uint8') ;       %  the n-bit scrambling sequence
for k = 1 : n  
    s(k) = xor(scr(1), scr(4)) ;          % big-small     x0 = x4 ? x7                                    
    msgF_Scr(k) = xor(msgF_b(k), s(k)) ;
    scr = [scr(2:7) s(k)] ;  % the last 7 bits of the scrambling sequence
end

% 7 c)
% descramble
%msgF_dScr = uint8(xor(msgF_Scr, s)) ;
% sum = 0, screamble and deacrambled;
%sum = sum(msgF_dScr - msgF_b); 

% Coding msgF_Scr  with a convolutional encoder as in slides 23, 24

shR = zeros(1, 6, 'uint8') ;  %  6-bit shift register intialized with zeros
msgF_Scr_C = zeros(2, n, 'uint8') ;
for k = 1:n
    msgF_Scr_C(1,k) = mod(sum([msgF_Scr(k) shR([2 3 5 6])]),2); % 1st row
    msgF_Scr_C(2,k) = mod(sum([msgF_Scr(k) shR([1 2 3 6])]),2); % 2nd row
    shR = [msgF_Scr(k) shR(1:5)] ;
end
% txc_C is a convoluted text produced by y_a and y_b in slide 24

% the convoluted test as a single binary string (as uint8 numbers)
msgF_Cnv = msgF_Scr_C(:)' ;  % note that the length is 2n

% as above as 0, 1 characters  
msgF_Cnv_ch = char(msgF_Cnv + '0') ;

length(msgF_Cnv_ch) / length(msgF_b)


%Q9 puncture
pattern = [1 1 0 1 1 0];
len = length(pattern);
msg_conv = msgF_Cnv_ch(find(pattern(1 + mod((0 : length(msgF_Cnv_ch) - 1), len)) == 1));

format rat;
length(msg_conv) / length(msgF_b)






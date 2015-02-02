:- module(p99, ['1.01'/2, my_last/2,
                '1.02']).

% 1.01 (*) Find the last element of a list.
% Example:
% ?- my_last(X,[a,b,c,d]).
% X = d
my_last(A, B) :- '1.01'(A, B).
'1.01'(X, [X]) :- !.
'1.01'(X, [_|Ys]) :- '1.01'(X, Ys).


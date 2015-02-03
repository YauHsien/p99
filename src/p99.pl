:- module(p99, ['1.01'/2, my_last/2,
                '1.02'/2, my_last_but_one/2,
	        '1.03'/3, element_at/3,
                '1.04'/2, list_len/2,
		'1.05'/2, list_rev/2,
		'1.06'/1, palindrome/1,
                '1.07'/2, my_flatten/2,
		'1.08'/2, compress/2,
		'1.09'/2, pack/2,
		'1.10'/2, encode/2,
		'1.11'/2, encode_modified/2,
		'1.12'/2, uncompress/2,
		'1.13'/2, encode_direct/2,
		'1.14'/2, dupli/2,
		'1.15'/3, dupli/3,
		'1.16'/3, drop/3,
		'1.17'/4, split/4,
                '1.18'/4, slice/4,
                '1.19'/3, rotate/3,
		'1.20'/4, remove_at/4
	  ]).

% 1.01 (*) Find the last element of a list.
%       Example:
%       ?- my_last(X,[a,b,c,d]).
%       X = d
my_last(A, B) :- '1.01'(A, B).
'1.01'(X, [X]) :- !.
'1.01'(X, [_|Ys]) :- '1.01'(X, Ys).

% 1.02 (*) Find the last but one element of a list.
%       (de: zweitletztes Element, fr: avant-dernier élément)
my_last_but_one(A, B) :- '1.02'(A, B).
'1.02'(X, [X, _]) :- !.
'1.02'(X, [_|Ys]) :- '1.02'(X, Ys).

% 1.03 (*) Find the Kth element of a list.
%       The first element in the list is number 1.
%       Example:
%       ?- element_at(X,[a,b,c,d,e],3).
%       X = c
element_at(X, List, N) :- '1.03'(X, List, N).
'1.03'(X, [X|_], 1) :- !.
'1.03'(X, [_|List], N) :-
    N1 is N - 1,
    '1.03'(X, List, N1).

% 1.04 (*) Find the number of elements of a list.
list_len(List, N) :- '1.04'(List, N).
'1.04'([], 0).
'1.04'([_|List], N) :- '1.04'(List, N1), N is N1 + 1.

% 1.05 (*) Reverse a list.
list_rev(List, List1) :- '1.05'(List, List1).
'1.05'([], []).
'1.05'([X], [X]) :- !.
'1.05'([X|List], List1) :-
    '1.05'(List, List2),
    list:append(List2, [X], List1).
% I tried writing the third clause of '1.05' as followings,
%   '1.05'([X|List], List1) :-
%       '1.05'(List, List2),
%       list_append(List2, [X], List1).
%   list_append(List1, List2, List3) :-
%       list_rev(List1, List4),
%       list_append(List1, List2, List4, List3).
%   list_append(_, [], Acc, List3) :- format('a~n'),
%       list_rev(Acc, List3).
%   list_append(_, [X|List], Acc, List3) :- format('b~n'),
%       list_append(_, List, [X|Acc], List3).
% and I found that it is circular recursion. Interesting.

% 1.06 (*) Find out whether a list is a palindrome.
%       A palindrome can be read forward or backward; e.g. [x,a,m,a,x].
palindrome(List) :- '1.06'(List).
'1.06'(List) :-
    list_rev(List, List).

% 1.07 (**) Flatten a nested list structure.
%        Transform a list, possibly holding lists as elements into a 'flat' list by replacing each list with its elements (recursively).
%
% Example:
% ?- my_flatten([a, [b, [c, d], e]], X).
% X = [a, b, c, d, e]
%
% Hint: Use the predefined predicates is_list/1 and append/3
my_flatten(List, List1) :- '1.07'(List, List1).
'1.07'([], []).
'1.07'([X|List], List1) :- is_list(X), !,
    '1.07'(X, X1),
    '1.07'(List, List2),
    list:append(X1, List2, List1).
'1.07'([X|List], [X|List1]) :-
    '1.07'(List, List1).

% 1.08 (**) Eliminate consecutive duplicates of list elements.
%       If a list contains repeated elements they should be replaced with a single copy of the element. The order of the elements should not be changed.
%
% Example:
% ?- compress([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
% X = [a,b,c,a,d,e]
compress(List, List1) :- '1.08'(List, List1).
'1.08'(List, List1) :-
    '1.08'(List, [], List1).
'1.08'([], Acc, List1) :-
    list_rev(Acc, List1).
'1.08'([X|List], [X|Acc], List1) :- !,
    '1.08'(List, [X|Acc], List1).
'1.08'([X|List], Acc, List1) :-
    '1.08'(List, [X|Acc], List1).

% 1.09 (**) Pack consecutive duplicates of list elements into sublists.
%       If a list contains repeated elements they should be placed in separate sublists.
%
% Example:
% ?- pack([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
% X = [[a,a,a,a],[b],[c,c],[a,a],[d],[e,e,e,e]]
pack(List, List1) :- '1.09'(List, List1).
'1.09'([], []).
'1.09'([X,X|List], [[X|Xs]|List1]) :- !,
    '1.09'([X|List], [Xs|List1]).
'1.09'([X|List], [[X]|List1]) :-
    '1.09'(List, List1).

% 1.10 (*) Run-length encoding of a list.
%       Use the result of problem 1.09 to implement the so-called run-length encoding data compression method. Consecutive duplicates of elements are encoded as terms [N,E] where N is the number of duplicates of the element E.
%
% Example:
% ?- encode([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
% X = [[4,a],[1,b],[2,c],[2,a],[1,d][4,e]]
encode(List, List1) :- '1.10'(List, List1).
'1.10'([], []).
'1.10'([Xs|List], [[N,X]|List1]) :- is_list(Xs), !,
    list_len(Xs, N),
    compress(Xs, [X]),
    '1.10'(List, List1).
'1.10'(List, List1) :-
    pack(List, List2),
    '1.10'(List2, List1).

% 1.11 (*) Modified run-length encoding.
%       Modify the result of problem 1.10 in such a way that if an element has no duplicates it is simply copied into the result list. Only elements with duplicates are transferred as [N,E] terms.
%
% Example:
% ?- encode_modified([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
% X = [[4,a],b,[2,c],[2,a],d,[4,e]]
encode_modified(List, List1) :- '1.11'(List, List1).
'1.11'([], []).
'1.11'([Xs|List], [X|List1]) :- [X] = Xs, !,
    '1.11'(List, List1).
'1.11'([Xs|List], [[N,X]|List1]) :- is_list(Xs), !,
    list_len(Xs, N),
    compress(Xs, [X]),
    '1.11'(List, List1).
'1.11'(List, List1) :-
    pack(List, List2),
    '1.11'(List2, List1).

% 1.12 (**) Decode a run-length encoded list.
%       Given a run-length code list generated as specified in problem 1.11. Construct its uncompressed version.
uncompress(List, List1) :- '1.12'(List, List1).
'1.12'([], []).
'1.12'([[0,_]|List], List1) :-
    '1.12'(List, List1).
'1.12'([[N,X]|List], [X|List1]) :-
    N1 is N - 1,
    '1.12'([[N1,X]|List], List1).
'1.12'([X|List], [X|List1]) :-
    '1.12'(List, List1).

% 1.13 (**) Run-length encoding of a list (direct solution).
%        Implement the so-called run-length encoding data compression method directly. I.e. don''t explicitly create the sublists containing the duplicates, as in problem 1.09, but only count them. As in problem 1.11, simplify the result list by replacing the singleton terms [1,X] by X.
%
% Example:
% ?- encode_direct([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
% X = [[4,a],b,[2,c],[2,a],d,[4,e]]
encode_direct(List, List1) :- '1.13'(List, List1).
'1.13'([], []).
'1.13'([X,X|List], [[N,X]|List1]) :- !,
    '1.13'([X|List], [[N1,X]|List1]),
    N is N1 + 1.
'1.13'([X|List], [[1,X]|List1]) :-
    '1.13'(List, List1).

% 1.14 (*) Duplicate the elements of a list.
% Example:
% ?- dupli([a,b,c,c,d],X).
% X = [a,a,b,b,c,c,c,c,d,d]
dupli(List, List1) :- '1.14'(List, List1).
'1.14'([], []).
'1.14'([X|List], [X,X|List1]) :-
    '1.14'(List, List1).

% 1.15 (**) Duplicate the elements of a list a given number of times.
% Example:
% ?- dupli([a,b,c],3,X).
% X = [a,a,a,b,b,b,c,c,c]
%
% What are the results of the goal:
% ?- dupli(X,3,Y).
dupli(List, N, List1) :- '1.15'(List, N, List1).
'1.15'(List, N, List1) :-
    distri(N, List, List2),
    uncompress(List2, List1).
distri(_, [], []).
distri(N, [X|List], [[N,X]|List1]) :-
    distri(N, List, List1).

% 1.16 (**) Drop every Nth element from a list.
% Example:
% ?- drop([a,b,c,d,e,f,g,h,i,k],3,X).
% X = [a,b,d,e,g,h,k]
drop(List, N, List1) :- '1.16'(List, N, List1).
'1.16'(List, N, List1) :- '1.16'(List, N, N, [], List1).
'1.16'([], _, _, Acc, List1) :-
    list_rev(Acc, List1).
'1.16'([_|List], 1, N, Acc, List1) :- !,
    '1.16'(List, N, N, Acc, List1).
'1.16'([X|List], M, N, Acc, List1) :-
    M1 is M - 1,
    '1.16'(List, M1, N, [X|Acc], List1).

% 1.17 (*) Split a list into two parts; the length of the first part is given.
% Do not use any predefined predicates.
%
% Example:
% ?- split([a,b,c,d,e,f,g,h,i,k],3,L1,L2).
% L1 = [a,b,c]
% L2 = [d,e,f,g,h,i,k]
split(List, N, List1, List2) :- '1.17'(List, N, List1, List2).
'1.17'(List, N, List1, List2) :- N >= 0, !,
    '1.17'(List, N, [], List1, List2).
'1.17'(List, 0, Acc, List1, List) :-
    list_rev(Acc, List1).
'1.17'([], _, Acc, List1, []) :-
    list_rev(Acc, List1).
'1.17'([X|List], N, Acc, List1, List2) :-
    N1 is N - 1,
    '1.17'(List, N1, [X|Acc], List1, List2).

% 1.18 (**) Extract a slice from a list.
%       Given two indices, I and K, the slice is the list containing the elements between the I'th and K'th element of the original list (both limits included). Start counting the elements with 1.
%
% Example:
% ?- slice([a,b,c,d,e,f,g,h,i,k],3,7,L).
% X = [c,d,e,f,g]
slice(List, I, K, List1) :- '1.18'(List, I, K, List1).
'1.18'(List, I, K, List1) :- I >= 1, K >= 1, !,
    I1 is I - 1,
    split(List, I1, _, List2),
    split(List2, K, List3, _).

% 1.19 (**) Rotate a list N places to the left.
% Examples:
% ?- rotate([a,b,c,d,e,f,g,h],3,X).
% X = [d,e,f,g,h,a,b,c]
%
% ?- rotate([a,b,c,d,e,f,g,h],-2,X).
% X = [g,h,a,b,c,d,e,f]
%
% Hint: Use the predefined predicates length/2 and append/3, as well as the result of problem 1.17.
rotate(List, N, List1) :- '1.19'(List, N, List1).
'1.19'(List, 0, List).
'1.19'(List, N, List1) :- N > 0, !,
    split(List, N, List2, List3),
    list:append(List3, List2, List1).
'1.19'(List, N, List1) :- % N < 0,
    list_len(List, Len),
    N1 is Len + N,
    '1.19'(List, N1, List1).

% 1.20 (*) Remove the Kth element from a list.
% Example:
% ?- remove_at(X,[a,b,c,d],2,R).
% X = b
% R = [a,c,d]
remove_at(X, List, N, List1) :- '1.20'(X, List, N, List1).
'1.20'(X, [X|List], 1, List).
'1.20'(X, List, N, List1) :- N > 1, list_len(List, L), N =< L, !,
    N1 is N - 1,
    split(List, N1, List2, [_|List3]),
    list:append(List2, List3, List1).

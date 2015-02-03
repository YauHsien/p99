:- module(p99, ['1.01'/2, my_last/2,
                '1.02'/2, my_last_but_one/2,
	        '1.03'/3, element_at/3,
                '1.04'/2, list_len/2,
		'1.05'/2, list_rev/2,
		'1.06'/1, palindome/1,
                '1.07'/2, my_flatten/2,
		'1.08'/2, compress/2,
		'1.09'/2, pack/2,
		'1.10'/2, encode/2
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
% Use the result of problem 1.09 to implement the so-called run-length encoding data compression method. Consecutive duplicates of elements are encoded as terms [N,E] where N is the number of duplicates of the element E.
%
% Example:
% ?- encode([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
% X = [[4,a],[1,b],[2,c],[2,a],[1,d][4,e]]
encode(List, List1) :- '1.10'(List, List1).
'1.10'([], []).
'1.10'([X,X|List], [[N,X]|List1]) :- !,
    '1.10'([X|List], [[N1,X]|List1]),
    N is N1 + 1.
'1.10'([X|List], [[1,X]|List1]) :-
    '1.10'(List, List1).


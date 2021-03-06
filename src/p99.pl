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
		'1.20'/4, remove_at/4,
		'1.21'/4, insert_at/4,
		'1.22'/3, range/3,
		'1.23'/3, rnd_select/3,
		'1.24'/3,
		'1.25'/2, rnd_permu/2,
		'1.26'/3, combination/3,
		group3/4,
		group3
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
'1.10'([], []) :- !.
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
'1.11'([], []) :- !.
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
'1.17'(List, 0, Acc, List1, List) :- !,
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
    K1 is K - I1,
    split(List, I1, _, List2),
    split(List2, K1, List1, _).

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
'1.20'(M, List, N, List1) :- N > 1, list_len(List, L), N =< L, !,
    N1 is N - 1,
    split(List, N1, List2, [M|List3]),
    list:append(List2, List3, List1).

% 1.21 (*) Insert an element at a given position into a list.
% Example:
% ?- insert_at(alfa,[a,b,c,d],2,L).
% L = [a,alfa,b,c,d]
insert_at(X, List, N, List1) :- '1.21'(X, List, N, List1).
'1.21'(X, List, N, List1) :-
    N1 is N -1,
    split(List, N1, List2, List3),
    list:append(List2, [X|List3], List1).

% 1.22 (*) Create a list containing all integers within a given range.
% Example:
% ?- range(4,9,L).
% L = [4,5,6,7,8,9]
range(M, N, List) :- '1.22'(M, N, List).
'1.22'(N, N, [N]).
'1.22'(M, N, List) :- M < N, !,
    M1 is M + 1,
    '1.22'(M1, N, List1),
    List = [M|List1].

% 1.23 (**) Extract a given number of randomly selected elements from a list.
%       The selected items shall be put into a result list.
% Example:
% ?- rnd_select([a,b,c,d,e,f,g,h],3,L).
% L = [e,d,a]
%
% Hint: Use the built-in random number generator random/2 and the result of problem 1.20.
%
% 1.24 (*) Lotto: Draw N different random numbers from the set 1..M.
% The selected numbers shall be put into a result list.
% Example:
% ?- rnd_select(6,49,L).
% L = [23,1,17,33,21,37]
%
% Hint: Combine the solutions of problems 1.22 and 1.23.
rnd_select(List, N, List1) :- is_list(List), !,
    '1.23'(List, N, List1).
rnd_select(M, N, List) :-
    '1.24'(M, N, List).
'1.23'(List, N, List1) :- '1.23'(List, N, [], List1).
'1.23'(_, 0, Acc, Acc).
'1.23'(List, N, Acc, List1) :- N > 0, !,
    N1 is N - 1,
    list_len(List, Len),
    random_between(1, Len, R),
    remove_at(M, List, R, List2),
    '1.23'(List2, N1, [M|Acc], List1).

'1.24'(M, N, List) :-
    range(1, N, List1),
    rnd_select(List1, M, List).

% 1.25 (*) Generate a random permutation of the elements of a list.
% Example:
% ?- rnd_permu([a,b,c,d,e,f],L).
% L = [b,a,d,c,e,f]
%
% Hint: Use the solution of problem 1.23.
rnd_permu(List, List1) :- '1.25'(List, List1).
'1.25'(List, List1) :-
    p99:list_len(List, Len),
    rnd_select(List, Len, List1).

% 1.26 (**) Generate the combinations of K distinct objects chosen from the N elements of a list
% In how many ways can a committee of 3 be chosen from a group of 12 people? We all know that there are C(12,3) = 220 possibilities (C(N,K) denotes the well-known binomial coefficients). For pure mathematicians, this result may be great. But we want to really generate all the possibilities (via backtracking).
%
% Example:
% ?- combination(3,[a,b,c,d,e,f],L).
% L = [a,b,c] ;
% L = [a,b,d] ;
% L = [a,b,e] ;
% ... 
combination(N, List, List1) :-
    p99:list_len(List, Len),
    (N < Len -> '1.26'(N, List, List1);
     N == Len -> List1 = List;
     N > Len -> '1.26'(Len, List, List1)).
'1.26'(0, _, []).
'1.26'(N, List, [X|List1]) :- N > 0, !,
    p99:list_len(List, Len),
    range(1, Len, Indecies),
    member(I, Indecies),
    remove_at(X, List, I, List2), 
    N1 is N - 1,
    '1.26'(N1, List2, List1).

% 1.27 (**) Group the elements of a set into disjoint subsets.
% a) In how many ways can a group of 9 people work in 3 disjoint subgroups of 2, 3 and 4 persons? Write a predicate that generates all the possibilities via backtracking.
%
% Example:
% ?- group3([aldo,beat,carla,david,evi,flip,gary,hugo,ida],G1,G2,G3).
% G1 = [aldo,beat], G2 = [carla,david,evi], G3 = [flip,gary,hugo,ida]
% ...
%
% b) Generalize the above predicate in a way that we can specify a list of group sizes and the predicate will return a list of groups.
%
% Example:
% ?- group([aldo,beat,carla,david,evi,flip,gary,hugo,ida],[2,2,5],Gs).
% Gs = [[aldo,beat],[carla,david],[evi,flip,gary,hugo,ida]]
% ...
%
% Note that we do not want permutations of the group members; i.e. [[aldo,beat],...] is the same solution as [[beat,aldo],...]. However, we make a difference between [[aldo,beat],[carla,david],...] and [[carla,david],[aldo,beat],...].
%
% You may find more about this combinatorial problem in a good book on discrete mathematics under the term "multinomial coefficients". 
group3([], [], [], []).
group3([X|List], [X|List1], List2, List3) :-
    group3(List, List1, List2, List3),
    list_len(List1, N), N < 2.
group3([X|List], List1, [X|List2], List3) :-
    group3(List, List1, List2, List3),
    list_len(List2, N), N < 3.
group3([X|List], List1, List2, [X|List3]) :-
    group3(List, List1, List2, List3),
    list_len(List3, N), N < 4.

group([], Spec, List) :-
    list_len(Spec, LenS),
    dupli([[]], LenS, List).
group([X|List], Spec, List1) :-
    group(List, Spec, List2),
    list_len(Spec, LenS),
    range(1, LenS, Indecis),
    member(I, Indecis),
    remove_at(N, Spec, I, _),
    remove_at(List3, List2, I, List4),
    list_len(List3, M),
    M < N,
    insert_at([X|List3], List4, I, List1).

% 1.28 (**) Sorting a list of lists according to length of sublists
%       a) We suppose that a list (InList) contains elements that are lists themselves. The objective is to sort the elements of InList according to their length. E.g. short lists first, longer lists later, or vice versa.
%
% Example:
% ?- lsort([[a,b,c],[d,e],[f,g,h],[d,e],[i,j,k,l],[m,n],[o]],L).
% L = [[o], [d, e], [d, e], [m, n], [a, b, c], [f, g, h], [i, j, k, l]]
%
%       b) Again, we suppose that a list (InList) contains elements that are lists themselves. But this time the objective is to sort the elements of InList according to their length frequency; i.e. in the default, where sorting is done ascendingly, lists with rare lengths are placed first, others with a more frequent length come later.
%
% Example:
% ?- lfsort([[a,b,c],[d,e],[f,g,h],[d,e],[i,j,k,l],[m,n],[o]],L).
% L = [[i, j, k, l], [o], [a, b, c], [f, g, h], [d, e], [d, e], [m, n]]
%
%    Note that in the above example, the first two lists in the result L have length 4 and 1, both lengths appear just once. The third and forth list have length 3; there are two list of this length. And finally, the last three lists have length 2. This is the most frequent length. 

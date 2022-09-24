%% Binary Tree
%  . . . by using two rules to build trees.
%  1. a term `t(X, L, R)` where `X` means a node and both `L` and `R` are trees.
%  2. a term `nil`

%% 4.01
%  istree/1
%  . . . to check whether a given term represents a binary tree.

istree(nil).
istree(t(_, L, R)) :-
    istree(L),
    istree(R).

%% 4.02
%  cbal_tree/2
%  cbal_tree(+N, -Tree)
%  . . . to build a Completely Balanced Binary Tree with `N` nodes by a given number `N`.
%  Note: a CBAT has both subtrees with almostly-equal numbers of nodes; the difference is either `0` or `1`.

cbal_tree(0, nil).
cbal_tree(1, t(x,nil,nil)).
cbal_tree(N, t(x,L,R)) :-
    N > 1,
    !,
    N1 is N - 1,
    M1 is N1 div 2,
    M2 is N1 - M1,
    ( cbal_tree(M1, L),
      cbal_tree(M2, R)
    ; cbal_tree(M2, L),
      cbal_tree(M1, R)
    ).
% The third clause of `cbal_tree/2` will generate duplicate cases.

%% 4.03
%  symmetric/1
%  mirror/2
%  . . . to check if a tree symmetric. Note the predicate `mirror/2` checks if a tree is the mirror image of another one.

symmetric(nil).
symmetric(t(_,L,R)) :-
    mirror(L, R).

mirror(nil, nil).
mirror(t(_,L1,R1), t(_,L2,R2)) :-
    symmetric(t(_,L1,R2)),
    symmetric(t(_,R1,L2)).

%% 4.04
%  construct/2
%  construct(+List, -Tree)
%  add/3
%  add(+N, +Tree, +New_tree)
%  test_symmetric/1
%  test_symmetric(+List)
%  . . . to `construct` a Binary Search Tree by the given `List` of numbers.
%  Note the `add/3` is a suggested built-in block for this exercise.

construct(L, T) :-
    construct(L, nil, T).

construct([], T, T).
construct([N|L], nil, T) :- !,
    add(N, nil, T1),
    construct(L, T1, T).
construct([N|L], T0, T) :-
    add(N, T0, T1),
    construct(L, T1, T).

add(N, nil, t(N,nil,nil)).
add(N, t(M,L,R), t(M,L1,R)) :- N =< M, !,
                               add(N, L, L1).
add(N, t(M,L,R), t(M,L,R1)) :- add(N, R, R1).

test_symmetric(L) :-
    construct(L, T), !,
    symmetric(T).

%% 4.05 Generate-and-test paradigm
%  sym_cbal_trees/2
%  sym_cbal_trees(+N, -List)
%  . . . to generate all symmetric, completely balanced binary trees with a given number of nodes.

sym_cbal_trees(N, L) :-
    setof(T, (cbal_tree(N, T), symmetric(T)), L).

%% 4.06
%  hbal_tree/2
%  hbal_tree(+H, -Tree)
%  . . . to generate a Height-Balanced Binary Trees with a given height `H`.

hbal_tree(0, nil).
hbal_tree(1, t(x,nil,nil)) :- !.
hbal_tree(H, t(x,L,R)) :- H > 1,
    N_ is H - 1,
    N__ is H - 2,
    member(N1, [N_,N__]),
    member(N2, [N_,N__]),
    not((N1=:=N__, N2=:=N__)),
    hbal_tree(N1, L),
    hbal_tree(N2, R).

%% 4.07
%  hbal_tree_nodes/2
%  hbal_tree_nodes(+N, -Tree)
%  . . . to generate a Height-Balanced Binary Trees by a given number of nodes `N`.
%  By using following building blocks:
%  MaxN = 2**H - 1
%  minNodes(+H, -N)
%  maxHeight(+N, -H)

minNodes(0, 0) :- !.
minNodes(H, N) :- H > 0,
    H_ is H - 1,
    N is 2**H_. % N is (2**H_ - 1) + 1.

maxHeight(0, 0) :- !.
maxHeight(N, H) :- N > 0, !,
    maxHeight(N, 0, H).

maxHeight(N, A, H) :-
    minNodes(A, N0),
    (   N > N0, !,
        A1 is A + 1,
        maxHeight(N, A1, H)
    ;   N =:= N0, !,
        H is A
    ;   N < N0, !,
        H is A - 1
    ).

hbal_tree_nodes(N, T) :-
    maxHeight(N, H),
    hbal_tree(H, T).
% . . . and I got `315` Height-Balanced Binary Trees with nodes number `15`.

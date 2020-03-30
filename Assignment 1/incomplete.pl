%%  Ruth Anne Brennan - 17329846

%    represent as the list
arc([H|T],Node,Cost,KB) :-  member([H|B],KB), 
                            append(B,T,Node),
                            length(B,L), 
                            Cost is L+1.

heuristic(Node,H) :- length(Node,H).

goal([]).

% less than
less-than([[Node1|_],Cost1],[[Node2|_],Cost2]) :-   heuristic(Node1,Hvalue1),
                                                    heuristic(Node2,Hvalue2),
                                                    F1 is Cost1+Hvalue1,
                                                    F2 is Cost2+Hvalue2,
                                                    F1 =< F2.

%   The file incomplete
:- dynamic(kb/1).

makeKB(File)    :-  open(File,read,Str),
                    readK(Str,K),
                    reformat(K,KB),
                    asserta(kb(KB)),
                    close(Str).

readK(Stream,[])    :-  at_end_of_stream(Stream),!.
readK(Stream,[X|L]) :-  read(Stream,X),
                        readK(Stream,L).
reformat([],[]).
reformat([end_of_file],[]) :- !.
reformat([:-(H,B)|L],[[H|BL]|R])   :-   !,
                                        mkList(B,BL),
                                        reformat(L,R).
reformat([A|L],[[A]|R]) :- reformat(L,R).
mkList((X,T),[X|R]) :- !, mkList(T,R).
mkList(X,[X]).
initKB(File) :- retractall(kb(_)), makeKB(File).
astar(Node,Path,Cost) :- kb(KB), astar(Node,Path,Cost,KB).

% astar(Node,Path,Cost,KB) :- ???

% Modify:
%       search([Node|_])    :- goal(Node).
%       search([Node|More]) :- findall(X,arc(Node,X),Children),
%                              add-to-frontier(Children,More,New),
%                              search(New).

%   so that the head of the list New obtained in add-to-frontier has f-value
%   no larger than any in New’s tail, where
%   f(node) = cost(node) + h(node).
%   Let the frontier be a list of path-cost pairs (instead of just nodes), being
%   careful to update path cost, and to bring in the heuristic function in forming
%   the frontier New.

astarr([[Node, Path, Cost]|_], [Node,Path], Cost, _)    :-  goal(Node).
astarr([[Node, Path1, Cost1]|Tail], Path, Cost, KB)     :-  findall([X,[Node|Path1],Sum], (arc(Node, X, Y, KB), Sum is Y+Cost1), Children),
                                                            add-to-frontier(Children, Tail, X),
                                                            sortM(X, [[Node2, Path2, Cost2]|Tail1]),
                                                            astarr([[Node2, Path2, Cost2]|Tail1], Path, Cost, KB).



sortM([H|T], R) :- sort1(H, [], T, R).
sort1(H, S, [], [H|S]).
sort1(C, S, [H|T], R) :- lessthan(C, H), !, sort1(C, [H|S], T, R)   ;  sort1(H, [C|S], T, R).
 
add-to-frontier(C, F, N) :- append(C, F, N).

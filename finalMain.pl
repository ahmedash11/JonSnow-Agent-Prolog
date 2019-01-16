% :- include('Kb.pl').
% :- include('Kb2.pl').
:- include('Kb1.pl').
dragon_number(1).

% checks if the movements is in boundries
inBoundaries(location(X, Y)):-
    rows(X), columns(Y).

% checks if cell has no WW or Obs
freeCell(Cell, S):-
     \+obst(Cell), \+whiteWalkers(Cell , S).

% checks for the validity of the destination cell
validMove(To, S):-
    inBoundaries(To) , freeCell(To , S).

% Actions
action(north, -1, 0).   % Moving north would decrease the X by 1
action(east, 0, 1).     % Moving east would increase the Y by 1
action(south, 1, 0).    % Moving south would increase the X by 1
action(west, 0, -1).    % Moving west would decrease the Y by 1


increment(X, S):-
    S is X+1.

decrement(X, S):-
    S is X-1.

% jon axioms
jon(location(2,2), 0, s0).
jon(location(X, Y), Dg, result(A, S)):-
    jon(location(Xf, Yf), Dgprev, S),
    (
         (
            % To Apply a pickup action then we must check if Jon was in the cell containing the DragonStone 
            % in the previous situation     

            A = pickup,
            dS(location(Xf, Yf)),
            dragon_number(Glass),
            Dg = Glass,
            X = Xf,
            Y = Yf
        );
        (
            % To Apply a move action then we must check if it is possible to move to location(X,Y) 
            % by checking on the validity of the cell(If it is inBoundaries and freeCell)

            action(A, Dx, Dy),
            X is Xf + Dx,
            Y is Yf + Dy,
            Dg = Dgprev,
            validMove(location(X, Y) , S)
        );
        (
            % To Apply action killww then Jon must have had more than 0 DragonGlass 
            % in the previous situation and check for White Walkers in neighboring cells.

            A=killww,
            Dgprev > 0,
            Dg is Dgprev - 1,
            Y = Yf, X = Xf,
            (
                % Checking if there are any White Walkers in neighboring cells.

                (
                    decrement(Xf, N1),
                    inBoundaries(location(N1, Yf)),
                    whiteWalkers(location(N1, Yf), S)
                );
                (
                    decrement(Yf , N1) ,
                    inBoundaries(location(Xf, N1)),
                    whiteWalkers(location(Xf, N1), S)
                );
                (
                    increment(Xf , N1) ,
                    inBoundaries(location(N1, Yf)),
                    whiteWalkers(location(N1, Yf), S)
                );
                (
                    increment(Yf, N1) ,
                    inBoundaries(location(Xf, N1)),
                    whiteWalkers(location(Xf, N1), S)
                )
            )
        )
    ).


% walkers axioms
whiteWalkers(location(X,Y), result(A, S)):-
    whiteWalkers(location(X,Y) , S),
    (
        % The following actions would not affect the axiom and none of them 
        % could lead to the death of the White Walker.

        (
            A = north;
            A = south;
            A = east;
            A = west;
            A = pickup
        );
        (

            % To Apply action killww and for the axiom to stay true, 
            % then Jon in the previous situation must have had 0 DragonGlass; 
            % thus not being able to kill the White Walkers. 
            % Another Case would be that Jon was not in a 
            % neighbor cell of this White Walker in the previous situation.
            
            A = killww,
            (
                jon(_, 0, S);
            	\+(
                    (
                        decrement(X , N1),
                        inBoundaries(location(N1, Y)),
                        jon(location(N1, Y), _, S)
                    );
                    (
                        decrement(Y , N1),
                        inBoundaries(location(X, N1)),
                        jon(location(X, N1), _, S)
                    );
                    (
                        increment(X, N1),
                        inBoundaries(location(N1, Y)),
                        jon(location(N1, Y), _, S)
                    );
                    (
                        increment(Y , N1),
                        inBoundaries(location(X, N1)),
                        jon(location(X, N1), _, S)
                    )
            	)
            )
        )
    ).

run(S, D):-
    call_with_depth_limit(jon(location(_, _), 0, S), 15, D),
    goal(S).

goal(S):-
	forall(whiteWalkers(location(X, Y), s0), \+whiteWalkers(location(X, Y), S)).

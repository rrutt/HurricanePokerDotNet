  x :-  
	text_title(" Hurricane Poker "),
	write(" Hurricane is two-card draw poker,"),
	nl, write(" played as high/low, with deuces wild."),
	nl, write(" Aces and deuces play both high and low;"),
	nl, write(" two deuces always pair."),
	nl, nl, write(" No straights, no flushes."),
	nl, write(" Checking allowed."),
	nl, write(" Maximum bet/raise is $3."),
	nl, write(" 1 bet and 2 raises per round."),
	nl,
	shuffle_deck(new),
	%trace('shuffle_deck new to old'),trace_nl,
	shuffle_deck(old),
	nl, write(" Shuffled new deck "), nl, !,
	clear_player_amt(0, pot),
	clear_player_amt(0, hand),
	set_player(init),
	show_players(clear),
	repeat,
		peekaboo,
		main_menu(CHOICE),
		/* until */  game_over(CHOICE), !,
	text_close.
		
  main_menu(CHOICE) :- 
	menu(" Main Menu ",
		[
		"Deal",
		"Players",
		"New Deck",
		"Exit Game"
		], 
		CHOICE), !,
	%trace('main_menu choice = '),trace(CHOICE),trace_nl,
	process(CHOICE, 0), !.

  process(1, _) :-  % Deal cards 
    %trace('process(1, _)'),trace_nl,
    % peekaboo,
  	process_round(deal), !.
  process(2, _) :-
  	set_player_amt(0, peek, 1),  % Avoid peeking 
  	show_players(info), !.
  process(3, _) :-  % New deck 
	shuffle_deck(new),
	shuffle_deck(old), !,
	nl, write(" Shuffled new deck "), nl.
  process(4, _) :- 
	ask_yes_no("Do you want to quit?"), !.
  process(4, _) :- !,
  	fail.             % Continue game 


  game_over(4) :- !,
  	game_over(-1).
  game_over(CHOICE) :-
  	CHOICE > 0,
  	next(P, _),
  	get_player_amt(P, stake, A),
  	A =< 0, !,
  	ask_ok("Game Over."),
  	game_over(-1).
  game_over(-1) :-
	text_title(" Game Over. "),
	text_clear,
	text_cursor(0,1),
	text_write("Won:"),
  	next(P, _),
	get_player_amt(P, stake, A),
		A > 100,
		str_int(SA, A),
		text_cursor(P,1),
		text_write("#"), text_write(P), text_write(" $"), text_write(SA),
		fail.
  game_over(-1) :-
  	player_mode(P, human),
	get_player_amt(P, stake, A),
	A > 100,
	text_cursor(P,1),
  	text_write("ö"),  % Smiley face 
	fail.
  game_over(-1) :-
	text_cursor(0,10),
	text_write("Even:"),
  	next(P, _),
	get_player_amt(P, stake, A),
		A = 100,
		str_int(SA, A),
		text_cursor(P,10),
		text_write("#"), text_write(P), text_write(" $"), text_write(SA),
		fail.
  game_over(-1) :-
  	player_mode(P, human),
	get_player_amt(P, stake, A),
	A = 100,
	text_cursor(P,10),
  	text_write("ö"),  % Smiley face 
	fail.
  game_over(-1) :-
	text_cursor(0,19),
	text_write("Lost:"),
  	next(P, _),
	get_player_amt(P, stake, A),
		A >= 0, A < 100,
		str_int(SA, A),
		text_cursor(P,19),
		text_write("#"), text_write(P), text_write(" $"), text_write(SA),
		fail.
  game_over(-1) :-
  	player_mode(P, human),
	get_player_amt(P, stake, A),
	A >= 0, A < 100,
	text_cursor(P,19),
  	text_write("ö"),  % Smiley face 
	fail.
  game_over(-1) :-
	text_cursor(0,28),
	text_write("In Debt:"),
  	next(P, _),
	get_player_amt(P, stake, A),
		A < 0,
		str_int(SA, A),
		text_cursor(P,28),
		text_write("#"), text_write(P), text_write(" $"), text_write(SA),
		fail.
  game_over(-1) :-
  	player_mode(P, human),
	get_player_amt(P, stake, A),
	A < 0,
	text_cursor(P,28),
  	text_write("ö"),  % Smiley face 
	fail.
  game_over(-1) :-
  	get_player_amt(0, hand, H),
  	text_cursor(10,1),
  	text_write("(Original stakes were $100)"),
	text_cursor(12,1),
  	text_write("Hand #"), text_write(H), text_nl, !,
  	ask_ok,
	clear_player_amt(0, peek),  % Turn off extra info 
	show_players(info),
	ask_ok("Game Over.").

  set_player(init) :-
	assertz(player_mode(1, init)),
	assertz(player_mode(2, init)),
	assertz(player_mode(3, init)),
	assertz(player_mode(4, init)),
	assertz(player_mode(5, init)),
	assertz(player_mode(6, init)),
	assertz(player_mode(7, init)),
	assertz(player_mode(8, init)),
  	set_player(clear),
  	set_player(human),
  	set_player(auto),
  	set_player(dealer).

  set_player(clear) :-
  	player_mode(P, init),
	        change_player_mode(P, init, clear),
  		clear_player(P),
  		fail.
  set_player(clear).  % Terminate loop

  clear_player(P) :-
	clear_player_amt(P, stake),
	add_player_amt(P, stake, 100),
	clear_player_amt(P, bet),
	clear_player_amt(P, high),
	clear_player_amt(P, low),
        !.

  change_player_mode(P, M1, M2) :-
        retract(player_mode(P, M1)),
        assertz(player_mode(P, M2)),
        !.

  retract_player_mode(P, M) :-
        retract(player_mode(P, M)),
        !.
  retract_player_mode(P, M).

  set_player(human) :-
  	player_mode(P, human),
  		retract_player_mode(P, human),
  		fail.
  set_player(human) :-
  	P is random_int(8),
  	retract_player_mode(P, clear),
	asserta(player_mode(P, human)).

  set_player(auto) :-
  	player_mode(P, clear),
  		pick_random_mode(0, M),
  		change_player_mode(P, clear, M),
  		fail.
  set_player(auto).  % Terminate loop 

  set_player(dealer) :-
    not(player_is_dealer(_)), !,
  	P is random_int(8),
  	asserta(player_is_dealer(P)).
  set_player(dealer) :-
  	player_is_dealer(P), !,
  	retract(player_is_dealer(P)),
  	next(P, NP),
  	asserta(player_is_dealer(NP)).


  pick_random_mode(0, M) :-
  	N is random_int(7),
  	pick_random_mode(N, M).
  pick_random_mode(1, random).
  pick_random_mode(2, checker).
  pick_random_mode(3, pairwise).
  pick_random_mode(4, highrise).
  pick_random_mode(5, lowdown).
  pick_random_mode(6, hilo).
  pick_random_mode(7, foldout).
  

  peekaboo :-
    peek_enabled,
	peek_nl, peek_write("+++ Peek-a-boo +++"),
	fail.
  peekaboo :-
    peek_enabled,
  	peek_nl, peek_write("Modes:"), peek_nl, peek_write(" "),
	player_mode(P, M),
		peek_write(" #"), peek_write(P), peek_write("="), peek_write(M),
		fail.
  peekaboo :-
    peek_enabled,
	peek_nl, peek_write("Left Split:"), peek_nl,
  	fetch_card_deck(left, DECK),
	peek_write(DECK),
	fail.
  peekaboo :-
    peek_enabled,
	peek_nl, peek_write("Right Split:"), peek_nl,
  	fetch_card_deck(right, DECK),
	peek_write(DECK),
	fail.
  peekaboo :-
    peek_enabled,
	peek_nl, peek_write("Main Deck:"), peek_nl,
  	fetch_card_deck(main, DECK),
	peek_write(DECK),
	fail.
  peekaboo :-
    peek_enabled,
	peek_nl, peek_write("Discard Pile:"), peek_nl,
  	fetch_card_deck(discard, DECK),
	peek_write(DECK),
	fail.
  peekaboo :-
    peek_enabled,
  	peek_nl, peek_write("Hands:"), peek_nl, peek_write(" "),
  	player_hand(P, C1, C2),
  		peek_write(" #"), peek_write(P), peek_write("≡"), peek_write(C1), peek_write(C2),
  		fail.
  peekaboo :-
    peek_enabled,
    peek_nl, peek_write("--- Peek-a-boo ---"), peek_nl, !.
  peekaboo :- !.


  retract_player_text(P, T) :-
        retract(player_text(P, T)),
        !.
  retract_player_text(P, T).

  show_players(clear) :-
  	player_text(P, T),
  		retract_player_text(P, T),
  		fail.
  show_players(clear) :-
	text_title(" Hurricane Poker "),
	text_clear,
	text_nl, text_write("#1"), text_nl, text_write("#2"), text_nl, text_write("#3"), text_nl, text_write("#4"), text_nl, text_write("#5"), text_nl, text_write("#6"), text_nl, text_write("#7"), text_nl, text_write("#8"),
	show_players(human),
	show_players(dealer),
	show_players(pot).

  show_players(human) :-
	!,
	player_mode(P, human),
    %trace('show_players(human) P='),trace(P),trace_nl,
	text_cursor(P, 0),
	text_write("ö"),  % Smiley face 
    %trace('show_players(human) get stake'),trace_nl,
	get_player_amt(P, stake, A),
    %trace('show_players(human) stake A='),trace(A),trace_nl,
	str_int(SA, A),
    %trace('show_players(human) stake SA='),trace(SA),trace_nl,
	text_cursor(12, 1),
	text_write("ö $"), text_write(SA), text_write("     ").  % Smiley face 

  show_players(dealer) :-
	!,
	player_is_dealer(P),
	text_cursor(P, 2),
	text_write("≡").  % Triple-bar 

  show_players(deal) :-
    next(P, _),
		%trace(' show_players(deal) P:'),trace(P),trace_nl,
		text_cursor(P, 3),
		text_write("  "),
	  	player_hand(P, _, _),
  			text_cursor(P, 3),
  			text_write("--"),
  			fail.
  show_players(deal) :-
  	player_hand(P, C1, C2),
  	    %trace(' show_players(deal) player_hand('),trace(P),trace(','),trace(C1),trace(','),trace(C2),trace(')'),trace_nl,
  		player_mode(P, human),
			%trace(' show_players(deal) human P:'),trace(P),trace(' C1:'),trace(C1),trace(' C2:'),trace(C2),trace_nl,
  			text_cursor(P, 3),
  			text_write(C1), text_write(C2),
  			fail.
  show_players(deal) :-
	%trace(' show_players(deal) done'),trace_nl,
	!.

  show_players(hands) :-
  	player_hand(P, C1, C2),
  		text_cursor(P, 3),
  		text_write(C1), text_write(C2),
  		fail.
  show_players(hands).  % Terminate loop 

  show_players(pot) :- !,
  	get_player_amt(0, pot, N),
  	str_int(SN, N),
	text_cursor(10, 1),
	text_write("Pot: $"), text_write(SN), text_write("     ").

  show_players(info) :-
	text_title(" Player Information "),
	text_clear,
	next(P, _),
	get_player_amt(P, stake, A),
	        str_int(SA, A),
		text_cursor(P, 0),
		text_write("#"), text_write(P), text_write(" $"), text_write(SA),
		fail.
  show_players(info) :-
	player_mode(P, human),
	text_cursor(P, 0),
	text_write("ö"),  % Smiley face 
	fail.
  show_players(info) :-
    next(P, _),
	get_player_amt(P, high, A),
	        str_int(SA, A),
		text_cursor(P, 12),
		text_write("Hi: "), text_write(SA),
		fail.
  show_players(info) :-
    next(P, _),
	get_player_amt(P, low, A),
	        str_int(SA, A),
		text_cursor(P, 20),
		text_write("Lo: "), text_write(SA),
		fail.
  show_players(info) :-
  	get_player_amt(0, peek, 0),
	player_mode(P, M),
		text_cursor(P, 28),
		text_write(M),
		fail.
  show_players(info) :-
  	get_player_amt(0, hand, A),
        str_int(SA, A),
  	text_cursor(10, 3),
  	text_write("Hand #"), text_write(SA),
  	fail.
  show_players(info) :-
  	!.

  show_players(debug) :-
	text_title(" Player Amounts "),
    next(P, _),
	get_player_amt(P, X, A),
	        str_int(SA, A),
		write(" #"), write(P), write(":"), write(X), write("="), write(SA),
		fail.
  show_players(debug) :-
  	ask_ok, !.


  make_player_bet(P, B) :-
    %trace('make_player_bet P='),trace(P),trace(' B='),trace(B),trace_nl,
  	MB is (-1 * B),
  	add_player_amt(P, stake, MB),
  	add_player_amt(P, bet, B),
  	add_player_amt(0, pot, B).

  add_player_text(P, T) :-
	not(player_text(P, _)), !,
	assertz(player_text(P, T)),
	text_cursor(P, 6),
	text_write(T).
  add_player_text(P, T) :-
	player_text(P, T0), !,
	text_concat(T0, T, T1),
	retract_player_text(P, T0),
	assertz(player_text(P, T1)),
	text_cursor(P, 6),
	text_write(T1).


  asserta_card_deck(X, D) :-
  	denomination_value(C, D, _),  % Use "high" value 
    add_card_to_top_of_deck(X, C),
    !.
  asserta_card_deck(X, D) :-
    !.

  assertz_card_deck(X, D) :-
  	denomination_value(C, D, _),  % Use "high" value 
    add_card_to_bottom_of_deck(X, C),
    !.
  assertz_card_deck(X, D):-
	!.

  retract_player_hand(P, C1, C2) :-
    retract(player_hand(P, C1, C2)),
    !.
  retract_player_hand(P, C1, C2) :-
	!.

  shuffle_deck(new) :-
    %trace('shuffle_deck(new)'),trace_nl,
    clear_all_card_decks,
    fail.
  shuffle_deck(new) :-
    %trace('shuffle_deck(new) clear player hands'),trace_nl,
  	player_hand(P, C1, C2),
  		retract_player_hand(P, C1, C2),
  		fail.  % loop to delete old hands 
  shuffle_deck(new) :-
    %trace('shuffle_deck(new) 1'),trace_nl,
  	denomination_value(_, DNM, _),  % Use "high" value 
  		assertz_card_deck(discard, DNM),
  		fail.
  shuffle_deck(new) :-
    %trace('shuffle_deck(new) 2'),trace_nl,
  	denomination_value(_, DNM, _),  % Use "high" value 
  		assertz_card_deck(discard, DNM),
  		fail.
  shuffle_deck(new) :-
    %trace('shuffle_deck(new) 3'),trace_nl,
  	denomination_value(_, DNM, _),  % Use "high" value 
  		asserta_card_deck(discard, DNM),
  		fail.
  shuffle_deck(new) :-
    %trace('shuffle_deck(new) 4'),trace_nl,
  	denomination_value(_, DNM, _),  % Use "high" value 
  		asserta_card_deck(discard, DNM),
  		fail.
  shuffle_deck(new) :-
    %trace('shuffle_deck(new) done'),trace_nl,
    no_op.  

  shuffle_deck(old) :-
    %trace('shuffle_deck(old)'),trace_nl,
  	negative_amount_exists,
  	!.  % Game over, skip shuffling 
  shuffle_deck(old) :-
    %trace('shuffle_deck(old) discard to main'),trace_nl,
  	nl, write(" Shuffling cards "),
  	move_cards_between_decks(discard, main),
  	fail.  % Continue with next clause.
  shuffle_deck(old) :-
	%trace('shuffle_deck(old) riffling'),trace_nl,
	shuffle_deck(riffle),
	shuffle_deck(riffle),
	shuffle_deck(riffle),
	shuffle_deck(riffle),
	shuffle_deck(riffle).

  shuffle_deck(riffle) :-
  	write(":"),
  	shuffle_deck(split),
  	write("."),
  	shuffle_deck(combine), 
  	!.
  	   	
  shuffle_deck(split):-
    %trace('shuffle_deck(split)'),trace_nl,
    split_card_decks_randomly(main, left, right).
  	   	
  shuffle_deck(combine):-
    %trace('shuffle_deck(combine) left'),trace_nl,
    move_cards_between_decks(left, main),
    fail.  % Proceed to next clause.
  shuffle_deck(combine):-
    %trace('shuffle_deck(combine) right'),trace_nl,
    move_cards_between_decks(right, main),
    fail.  % Proceed to next clause.
  shuffle_deck(combine) :- !.


  deal_cards(start) :-
  	%trace('deal_cards(start)'),trace_nl,
  	add_player_amt(0, hand, 1),
  	%trace('deal_cards(start) deal_cards(ante)'),trace_nl,
  	deal_cards(ante),
  	%trace('deal_cards(start) deal_cards(around) #1'),trace_nl,
  	deal_cards(around),
  	%trace('deal_cards(start) deal_cards(around) #2'),trace_nl,
  	deal_cards(around),
  	%trace('deal_cards(start) show_players(deal)'),trace_nl,
  	show_players(deal),
  	%trace('deal_cards(start) show_players(pot)'),trace_nl,
  	show_players(pot),
  	%trace('deal_cards(start) show_players(human)'),trace_nl,
  	show_players(human), !,
  	%trace('deal_cards(start) Ready for betting.'),trace_nl,
  	% peekaboo,
  	ask_ok(" Ready for betting. ").

  deal_cards(ante) :-
    add_player_amt(1, stake, -1),
    add_player_amt(2, stake, -1),
    add_player_amt(3, stake, -1),
    add_player_amt(4, stake, -1),
    add_player_amt(5, stake, -1),
    add_player_amt(6, stake, -1),
    add_player_amt(7, stake, -1),
    add_player_amt(8, stake, -1),
    add_player_amt(0, pot, 8).

  deal_cards(around) :-
    %trace('deal_a_card(1)'),trace_nl,
  	deal_a_card(1),
    %trace('deal_a_card(2)'),trace_nl,
  	deal_a_card(2),
    %trace('deal_a_card(3)'),trace_nl,
  	deal_a_card(3),
    %trace('deal_a_card(4)'),trace_nl,
  	deal_a_card(4),
    %trace('deal_a_card(5)'),trace_nl,
  	deal_a_card(5),
    %trace('deal_a_card(6)'),trace_nl,
  	deal_a_card(6),
    %trace('deal_a_card(7)'),trace_nl,
  	deal_a_card(7),
    %trace('deal_a_card(8)'),trace_nl,
  	deal_a_card(8).

  deal_cards(done) :-
  	player_hand(P, C1, C2),
  		retract_player_hand(P, C1, C2),
  		denomination_value(C1, D1, _),  % Use "high" value 
  		denomination_value(C2, D2, _),
  		assertz_card_deck(discard, D1),
  		assertz_card_deck(discard, D2),
  		fail.
  deal_cards(done).  % Terminate loop 
  
  	
  deal_a_card(P) :-
    %trace('deal_a_card P='),trace(P),trace_nl,
  	deal_card_from_deck(main, C),
    %trace('deal_a_card C='),trace(C),trace_nl,
  	!,
  	denomination_value(C, D, _),  % Use "high" value 
  	%trace('deal_a_card D='),trace(D),trace_nl,
  	%trace('deal_a_card deal_to_player P='),trace(P),trace_nl,
  	deal_to_player(P, D),
  	%trace('deal_a_card deal_to_player done P='),trace(P),trace(' D='),trace(D),trace_nl,
  	no_op.

  deal_to_player(P, D2) :-  % Sorts as "high" card followed by "low" card
  	player_hand(P, C1, '*'),
  	denomination_value(C1, D1, _),  % Use "high" value 
  	D2 > D1, 
  	!,
  	%trace('deal_to_player D2>D1 P='),trace(P),trace(' D2='),trace(D2),trace_nl,
  	denomination_value(C2, D2, _),  % Use "high" value 
  	retract(player_hand(P, C1, '*')),
  	assertz(player_hand(P, C2, C1)).  % C2 is highest card
  deal_to_player(P, D2) :-
  	player_hand(P, C1, '*'),
  	!,
  	%trace('deal_to_player P='),trace(P),trace(' D2='),trace(D2),trace_nl,
  	denomination_value(C2, D2, _),  % Use "high" value 
  	retract(player_hand(P, C1, '*')),
  	assertz(player_hand(P, C1, C2)).  % C1 is highest card (or a pair)
  deal_to_player(P, _) :-
  	player_hand(P, C1, C2),
  	!,
  	%trace('deal_to_player already has two cards P='),trace(P),trace_nl,  % Already has 2 cards
  	no_op.
  deal_to_player(P, D) :-
    !,
  	denomination_value(C, D, _),  % Use "high" value 
  	%trace('deal_to_player P='),trace(P),trace(' D='),trace(D),trace_nl,
  	assertz(player_hand(P, C, '*')).


  process_round(deal) :-
    %trace('process_round(deal)'),trace_nl,
  	show_players(clear),
  	%trace('process_round(deal) deal_cards(start)'),trace_nl,
  	deal_cards(start),
  	%trace('process_round(deal) clear_player_amt(0, draws)'),trace_nl,
  	clear_player_amt(0, draws),
  	%trace('process_round(deal) process_round(bet) 1'),trace_nl,
	process_round(bet),
  	%trace('process_round(deal) process_round(draw)'),trace_nl,
	process_round(draw),
  	%trace('process_round(deal) process_round(bet) 2'),trace_nl,
	process_round(bet), !,
	ask_ok(" Ready for Showdown! "),
  	show_players(hands),
  	decide_hands.

  process_round(bet) :-
    %trace('process_round(bet) clear bets'),trace_nl,
	next(P, _),
		clear_player_amt(P, bet),
		fail.
  process_round(bet) :-
    %trace('process_round(bet) locate dealer'),trace_nl,
	player_is_dealer(D),
    %trace('process_round(bet) D='),trace(D),trace_nl,
	next(D, P),
    %trace('process_round(bet) next player P='),trace(P),trace_nl,
  	player_round(bet, P, 8, 3, 0, 0).

  process_round(draw) :-
	player_is_dealer(D),
	next(D, P),
  	player_round(draw, P, 8, 0, 0, 0),
  	show_players(deal).


  player_round(DEBUG, P, N, R, T, A) :-
  	DEBUG = "debug",
  	nl, write("{"), write(DEBUG), write("} #"), write(P), write(" N="), write(N), write(" R="), write(R), write(" T="), write(T), write(" A="), write(A), nl, % debug 
  	fail.

  player_round(bet, _, 0, _, _, _) :- !,  % Terminate recursion
    %trace('player_round(bet,...) terminate recursion'),trace_nl,
  	show_players(pot),
  	show_players(human).
  player_round(bet, P, N, R, T, _) :-
    %trace('player_round(bet,...) P='),trace(P),trace(' N='),trace(N),trace(' R='),trace(R),trace(' T='),trace(T),trace_nl,
  	N > 0,
  	player_hand(P, _, _), !,  % Player still in 
    %trace('player_round(bet,...) P='),trace(P),trace(' player still in'),trace_nl,
    %trace('player_round(bet,...) has hand P='),trace(P),trace_nl,
	player_mode(P, M),
    %trace('player_round(bet,...) P='),trace(P),trace(' M='),trace(M),trace_nl,
	get_action(bet, M, P, N, R, T, ACT, B),
    %trace('player_round(bet,...) P='),trace(P),trace(' get_action_bet returns ACT='),trace(ACT),trace(' B='),trace(B),trace_nl,
	player_round(ACT, P, N, R, T, B).
  player_round(bet, P, N, R, T, _) :-  % Player folded 
  	N > 0, !,
    %trace('player_round(bet,...) P='),trace(P),trace(' player folded'),trace_nl,
	next(P, NP),
	N1 is N - 1,
	player_round(bet, NP, N1, R, T, 0).

  player_round(draw, _, 0, _, _, _) :-  % Terminate recursion 
        !.
  player_round(draw, P, N, R, _, _) :-
  	N > 0,
  	player_hand(P, _, _), !, % Player still in 
	player_mode(P, M),
	get_action(draw, M, P, N, R, 0, ACT, _),
	player_round(ACT, P, N, 0, 0, 0).
  player_round(draw, P, N, _, _, _) :-  % Player folded 
  	N > 0, !,
	next(P, NP),
	N1 is N - 1,
	player_round(draw, NP, N1, 0, 0, 0).

  player_round(raise, P, N, 0, T, _) :- !,  % Past max. # raises, call instead 
	%trace('player_round(raise) max raises, call instead P='),trace(P),trace(' N='),trace(N),trace(' R=0 T='),trace(T),trace_nl,
  	player_round(call, P, N, 0, T, 0). 
  player_round(raise, P, _, R, T, A) :-
	R > 0, !,
	%trace('player_round(raise) P='),trace(P),trace(' N='),trace(N),trace(' R='),trace(R),trace(' T='),trace(T),trace_nl,
	get_player_amt(P, bet, B),
	TA is T + A,
	TB is TA - B,
	make_player_bet(P, TB),
	str_int(SA, A),
	text_concat("+", SA, S),
	add_player_text(P, S),
	write("Player "), write(P), write(" raises $"), write(A), nl,
	next(P, NP),
	R1 is R - 1,
	N1 is 8 - 1,
	player_round(bet, NP, N1, R1, TA, 0).

  player_round(call, P, N, R, T, _) :-
	get_player_amt(P, bet, B),
	T = B, !,
	%trace('player_round(call) check instead P='),trace(P),trace(' N='),trace(N),trace(' R='),trace(R),trace(' T='),trace(T),trace_nl,
	add_player_text(P, "# "),
	write("Player "), write(P), write(" checks"), nl,
	next(P, NP),
	N1 is N - 1,
	player_round(bet, NP, N1, R, T, 0).
  player_round(call, P, N, R, T, _) :-
	%trace('player_round(call) P='),trace(P),trace(' N='),trace(N),trace(' R='),trace(R),trace(' T='),trace(T),trace_nl,
	get_player_amt(P, bet, B), !,
	TB is T - B,
	make_player_bet(P, TB),
	str_int(STB, TB),
	text_concat("=", STB, S),
	add_player_text(P, S),
	write("Player "), write(P), write(" calls $"), write(TB), nl,
	next(P, NP),
	N1 is N - 1,
	player_round(bet, NP, N1, R, T, 0).

  player_round(fold, P, N, R, 0, _) :-  % Convert fold to check 
	%trace('player_round(fold)  check instead P='),trace(P),trace(' N='),trace(N),trace(' R=0 T='),trace(T),trace_nl,
  	player_round(call, P, N, R, 0, 0), !.
  player_round(fold, P, N, R, T, _) :-
	%trace('player_round(fold) P='),trace(P),trace(' N='),trace(N),trace(' R='),trace(R),trace(' T='),trace(T),trace_nl,
  	T > 0, !,
  	player_hand(P, C1, C2),
  	retract_player_hand(P, C1, C2),
	denomination_value(C1, D1, _),  % Use "high" value 
	assertz_card_deck(discard, D1),
	denomination_value(C2, D2, _),  % Use "high" value 
	assertz_card_deck(discard, D2),
	add_player_text(P, "x "),
	write("Player "), write(P), write(" folds"), nl,
	text_cursor(P, 3),
	text_write("  "),
	next(P, NP),
	N1 is N - 1,
	player_round(bet, NP, N1, R, T, 0).

  player_round(keep, P, N, _, _, _) :-
	add_player_text(P, "- "), !,
	write("Player "), write(P), write(" keeps both cards"), nl,
	next(P, NP),
	N1 is N - 1,
	player_round(draw, NP, N1, 0, 0, 0).
  player_round(high, P, N, _, _, _) :-
	add_player_text(P, "± "), !,  % Plus-or-minus 
	write("Player "), write(P), write(" draws a card"), nl,
	add_player_amt(0, draws, 1),
	player_hand(P, C1, C2),
	retract_player_hand(P, C1, C2),
	assertz(player_hand(P, C2, '*')),
	denomination_value(C1, D1, _),  % Use "high" value 
	assertz_card_deck(discard, D1),
	deal_a_card(P),
	next(P, NP),
	N1 is N - 1,
	player_round(draw, NP, N1, 0, 0, 0).
  player_round(low, P, N, _, _, _) :-
	add_player_text(P, "± "), !,  % Plus-or-minus 
	write("Player "), write(P), write(" draws a card"), nl,
	add_player_amt(0, draws, 1),
	player_hand(P, C1, C2),
	retract_player_hand(P, C1, C2),
	assertz(player_hand(P, C1, '*')),
	denomination_value(C2, D2, _),  % Use "high" value 
	assertz_card_deck(discard, D2),
	deal_a_card(P),
	next(P, NP),
	N1 is N - 1,
	player_round(draw, NP, N1, 0, 0, 0).


  get_action(bet, random, P, _, R, T, ACT, B) :-
  	N is random_int(5),
  	get_action(bet, index, P, N, R, T, ACT, B).

  get_action(draw, random, P, _, _, _, ACT, B) :-
  	X is random_int(3),
  	get_action(draw, index, P, X, 0, 0, ACT, B).


  get_action(bet, checker, _, _, _, _, call, 0).

  get_action(draw, checker, _, _, _, _, keep, 0).


  get_action(bet, pairwise, P, _, _, _, raise, 3) :-  % Raise on wild 
  	player_hand(P, _, '2'), !.
  get_action(bet, pairwise, P, _, _, _, raise, 3) :-  % Raise on A,K,Q pair 
  	player_hand(P, C1, C2),
  	C1 = C2,
	denomination_value(C1, D1, _),  % Use "high" value 
	D1 > 11, !.  	
  get_action(bet, pairwise, P, _, _, _, raise, 2) :-  % Raise on pair 
  	player_hand(P, C1, C2),
  	C1 = C2, !.
  get_action(bet, pairwise, P, _, _, _, raise, 1) :-  % Raise on face card 
  	player_hand(P, C, _),
	denomination_value(C, D, _),  % Use "high" value 
	D > 10, !.  	
  get_action(bet, pairwise, _, _, _, _, raise, 1) :-  % Defensive raise 
  	get_player_amt(0, draws, 0), !.  % Only before draw 
  get_action(bet, pairwise, _, _, _, T, fold, 0) :-  % Fold if big bet without pair 
  	get_player_amt(0, draws, N), N > 0,  % Only after draw 
  	T > 2, !.
  get_action(bet, pairwise, _, _, _, _, call, 0).

  get_action(draw, pairwise, P, N, R, T, ACT, B) :-  % Same as highrise 
	get_action(draw, highrise, P, N, R, T, ACT, B).


  get_action(bet, highrise, P, _, _, _, raise, 3) :-  % Raise on wild 
  	player_hand(P, _, '2'), !.
  get_action(bet, highrise, P, _, _, _, raise, 3) :-  % Raise on A,K,Q pair 
  	player_hand(P, C1, C2),
  	C1 = C2,
	denomination_value(C1, D1, _),  % Use "high" value 
	D1 > 11, !.  	
  get_action(bet, highrise, P, _, _, _, raise, 2) :-  % Raise on pair 
  	player_hand(P, C1, C2),
  	C1 = C2, !.
  get_action(bet, highrise, P, _, _, _, raise, 1) :-  % Raise on A,K,Q 
  	player_hand(P, C, _),
	denomination_value(C, D, _),  % Use "high" value 
	D > 11, !.
  get_action(bet, highrise, P, _, _, _, fold, 0) :-  % Fold if poor high card 
  	get_player_amt(0, draws, 0),  % Only before draw 
  	player_hand(P, C1, C2),
  	C1 \= C2,  % Stay on a pair 
	denomination_value(C1, D1, _),  % Use "high" value 
	D1 < 10, !.
  get_action(bet, highrise, P, _, _, _, fold, 0) :-  % Fold if "medium" 
  	get_player_amt(0, draws, N), N > 0,  % Only after draw 
  	player_hand(P, C1, C2),
  	C1 \= C2,  % Stay on a pair 
	denomination_value(C1, D1, _),  % Use "high" value 
	D1 > 5, D1 < 12, !.
  get_action(bet, highrise, _, _, _, _, raise, 1) :-  % Defensive raise 
  	get_player_amt(0, draws, 0), !.  % Only before draw 
  get_action(bet, highrise, _, _, _, T, fold, 0) :-  % Fold if BIG bet 
  	get_player_amt(0, draws, N), N > 0,  % Only after draw 
  	T > 6, !.
  get_action(bet, highrise, _, _, _, _, call, 0) :- !.

  get_action(draw, highrise, P, _, _, _, keep, 0) :-  % Hold on pair 
  	player_hand(P, C1, C2),
  	C1 = C2, !.
  get_action(draw, highrise, P, _, _, _, keep, 0) :-  % Hold on wild, face 
  	player_hand(P, C, '2'),
	denomination_value(C, D, _),  % Use "high" value 
	D > 10, !.
  get_action(draw, highrise, P, _, _, _, high, 0) :-  % Try for higher wild 
  	player_hand(P, _, '2'), !.
  get_action(draw, highrise, _, _, _, _, low, 0).  % Toss low card 


  get_action(bet, lowdown, P, _, _, _, raise, 3) :-
  	player_hand(P, 'A', '2'), !.
  get_action(bet, lowdown, P, _, _, _, raise, 2) :-
  	player_hand(P, 'A', _), !.
  get_action(bet, lowdown, P, _, _, _, raise, 1) :-  % Raise on low hi-card 
  	player_hand(P, C, _),
	denomination_value(C, D, _),  % Use "high" value 
	D < 7, !.
  get_action(bet, lowdown, P, _, _, _, fold, 0) :-  % Fold if high low-card 
  	get_player_amt(0, draws, 0),  % Only before draw 
  	player_hand(P, C1, C2),
  	C1 \= C2,  % Stay on a pair 
	denomination_value(C2, D2, _),  % Use "high" value 
	D2 > 6, !.
  get_action(bet, lowdown, P, _, _, T, fold, 0) :-  % Fold if not low and big bet 
  	get_player_amt(0, draws, N), N > 0,  % Only after draw 
  	player_hand(P, C1, C2),
  	C1 \= C2,  % Stay on a pair 
	denomination_value(C1, D1, _),  % Use "high" value 
	D1 > 6,
	T > 1, !.
  get_action(bet, lowdown, _, _, _, _, call, 0).

  get_action(draw, lowdown, P, _, _, _, keep, 0) :-
  	player_hand(P, 'A', '2'), !.
  get_action(draw, lowdown, P, _, _, _, keep, 0) :-  % Hold if low hi-card 
  	player_hand(P, C, _),
	denomination_value(C, D, _),  % Use "high" value 
	D < 7, !.
  get_action(draw, lowdown, _, _, _, _, high, 0).


  get_action(bet, hilo, P, _, _, _, raise, 3) :-
  	player_hand(P, 'A', '2'), !.
  get_action(bet, hilo, P, _, _, _, raise, 2) :-
  	player_hand(P, 'A', _), !.
  get_action(bet, hilo, P, _, _, _, raise, 2) :-  % Raise on low hi-card 
  	player_hand(P, C, _),
	denomination_value(C, D, _),  % Use "high" value 
	D < 7, !.
  get_action(bet, hilo, P, _, _, T, fold, 0) :-  % Fold if both medium and big bet 
  	player_hand(P, C1, C2),
  	C1 \= C2,  % Stay on a pair 
	denomination_value(C1, D1, _),  % Use "high" value 
	denomination_value(C2, D2, _),  % Use "high" value 
	D1 > 6, D1 < 10,
	D2 > 6, D2 < 10,
	T > 1, !.
  get_action(bet, hilo, P, _, _, _, raise, 1) :-  % Defensive raise if both medium 
  	get_player_amt(0, draws, N), N > 0,  % Only after draw 
  	player_hand(P, C1, C2),
  	C1 \= C2,  % Stay on a pair 
	denomination_value(C1, D1, _),  % Use "high" value 
	denomination_value(C2, D2, _),  % Use "high" value 
	D1 > 6, D1 < 10,
	D2 > 6, D2 < 10, !.
  get_action(bet, hilo, P, N, R, T, ACT, B) :-  % Else, same as highrise 
	get_action(bet, highrise, P, N, R, T, ACT, B).

  get_action(draw, hilo, P, _, _, _, keep, 0) :-
  	player_hand(P, 'A', '2'), !.
  get_action(draw, hilo, P, _, _, _, keep, 0) :-  % Hold if low hi-card 
  	player_hand(P, C, _),
	denomination_value(C, D, _),  % Use "high" value 
	D < 6, !.
  get_action(draw, hilo, P, _, _, _, high, 0) :-  % Discard poor high if good low card 
  	player_hand(P, C1, C2),
  	C1 \= C2,  % Hold on pair 
	denomination_value(C1, D1, _),  % Use "high" value 
	denomination_value(C2, D2, _),
	D1 < 12,
	D2 < 6, !.
  get_action(draw, hilo, P, N, R, T, ACT, B) :-  % Else, same as highrise 
	get_action(draw, highrise, P, N, R, T, ACT, B).


  get_action(bet, foldout, P, _, _, _, raise, 3) :-
  	player_hand(P, 'A', '2'), !.
  get_action(bet, foldout, P, _, _, _, raise, 2) :-
  	player_hand(P, 'A', _), !.
  get_action(bet, foldout, P, _, _, _, raise, 2) :-  % Raise on low hi-card 
  	player_hand(P, C, _),
	denomination_value(C, D, _),  % Use "high" value 
	D < 6, !.
  get_action(bet, foldout, P, _, _, _, fold, 0) :-  % Fold if both medium and big bet 
  	player_hand(P, C1, C2),
  	C1 \= C2,  % Stay on a pair 
	denomination_value(C1, D1, _),  % Use "high" value 
	denomination_value(C2, D2, _),  % Use "high" value 
	D1 > 5, D1 < 12,
	D2 > 5, D2 < 12, !.
  get_action(bet, foldout, P, N, R, T, ACT, B) :-  % Else, same as hilo 
	get_action(bet, hilo, P, N, R, T, ACT, B).

  get_action(draw, foldout, P, N, R, T, ACT, B) :-  % Else, same as hilo 
	get_action(draw, hilo, P, N, R, T, ACT, B).


  get_action(bet, human, P, _, R, T, ACT, B) :-
  	show_players(pot),
  	show_players(human),
  	get_player_amt(P, bet, PB),
  	CB is T - PB,  % Call bet amount 
	peekaboo,
    %trace('get_action(bet, human) bet_menu'),trace_nl,	
  	bet_menu(R, CB, ACT, B).

  get_action(draw, human, P, _, _, _, ACT, 0) :-
	peekaboo,
    %trace('get_action(bet, human) draw_menu'),trace_nl,
  	draw_menu(P, ACT).


  get_action(bet, _, _, _, _, _, call, 0).   % Safety net 

  get_action(draw, _, _, _, _, _, keep, 0).  % Safety net 


  get_action(bet, index, _, 0, _, _, call, 0).
  get_action(bet, index, _, N, 0, _, call, 0) :-
  	N < 4.
  get_action(bet, index, _, N, R, _, raise, B) :-
  	R > 0,
  	N > 0,
  	N < 4,
  	B = N.
  get_action(bet, index, _, 4, _, _, fold, 0).

  get_action(draw, index, _, 0, _, _, keep, 0).
  get_action(draw, index, _, 1, _, _, low, 0).
  get_action(draw, index, _, 2, _, _, high, 0).


  bet_menu(_, 0, ACT, B) :-
    %trace('bet_menu'),trace_nl,
	player_mode(P, human),
  	player_hand(P, C1, C2),
  	text_concat(" Bet?  Hand = ", C1, S1),
  	text_concat(S1, C2, S2),
	menu(S2,
		[
		"Check   ",
		"Bet $1",
		"Bet $2",
		"Bet $3",
		""  % No sense folding, since no $ needed 
		], 
		CHOICE), !,
	bet_choice(CHOICE, ACT, B).
  bet_menu(R, C, ACT, B) :-
  	R > 0,
  	C > 0,
  	str_int(SC, C),
  	text_concat("Call $", SC, S),
	player_mode(P, human),
  	player_hand(P, C1, C2),
  	text_concat(" Bet?  Hand = ", C1, S1),
  	text_concat(S1, C2, S2),
	menu(S2,
		[
		S,
		"Raise $1",
		"Raise $2",
		"Raise $3",
		"Fold    "
		], 
		CHOICE), !,
	bet_choice(CHOICE, ACT, B).
  bet_menu(0, C, ACT, B) :-
  	C > 0,
  	str_int(SC, C),
  	text_concat("Call $", SC, S),
	player_mode(P, human),
  	player_hand(P, C1, C2),
  	text_concat(" Bet?  Hand = ", C1, S1),
  	text_concat(S1, C2, S2),
	menu(S2,
		[
		S,
		"",
		"",
		"",
		"Fold    "
		], 
		CHOICE), !,
	bet_choice(CHOICE, ACT, B).
	
  bet_choice(0, call, 0).
  bet_choice(1, call, 0).
  bet_choice(2, raise, 1).
  bet_choice(3, raise, 2).
  bet_choice(4, raise, 3).
  bet_choice(5, fold, 0).

  draw_menu(P, ACT) :-
  	player_hand(P, C1, C2),
  	str_char(S1, C1),
  	str_char(S2, C2),
  	text_concat("Discard ", S1, SD1),
  	text_concat("Discard ", S2, SD2),
	menu(" Draw? ",
		[
		"Keep",
		SD1,
		SD2
		], 
		CHOICE), !,
	draw_choice(CHOICE, ACT).

  draw_choice(0, keep).
  draw_choice(1, keep).
  draw_choice(2, high).
  draw_choice(3, low).


  decide_hands :-
    trace('decide_hands clear player_hand_score values'),trace_nl,
    clear_player_hand_scores,
  	best_player_score(P, HL, V),
  		retract(best_player_score(P, HL, V)),
  		fail.  % Loop to erase old scores 
  decide_hands :-
  	player_hand(P, C1, C2),
  		trace('player_hand P='),trace(P),trace(' '),trace(C1),trace(C2),trace_nl,
  		hand_value(high, C1,C2, VH),
  		trace('  VH='),trace(VH),trace_nl,
  		record_player_hand_score(P, high, VH),
  		hand_value(low,  C1,C2, VL),
  		trace('  VL='),trace(VL),trace_nl,
  		record_player_hand_score(P, low, VL),
  		fail.  % Loop for all hands 
  decide_hands :-
    trace('decide_hands low'),trace_nl,
    next(P, _),
  	player_has_best_hand_score(P, low, VL),
  	    assertz(best_player_score(P, low, VL)),
  		add_player_amt(P, low, 1),
  		text_cursor(P, 2),
  		text_write("▼"),
  		fail.  % Loop for any ties 
  decide_hands :-
    trace('decide_hands high'),trace_nl,
    next(P, _),
  	player_has_best_hand_score(P, high, VH),
  	    assertz(best_player_score(P, high, VH)),
  		add_player_amt(P, high, 1),
  		text_cursor(P, 5),
  		text_write("▲"),
  		fail.  % Loop for any ties 
  decide_hands :-  % Terminate loop 
    trace('decide_hands pay winners'),trace_nl,
	findall(P, best_player_score(P, low,  _), LP_LIST),
	pay_winners(count, low, LP_LIST, 0, NL),
	findall(P, best_player_score(P, high, _), HP_LIST),
	pay_winners(count, high, HP_LIST, 0, NH),
	get_player_amt(0, pot, A),
	AL is (A // 2) // NL,  % Odd extra goes to High winners 
	AH is (A - (AL * NL)) // NH,  % Odd breakage stays as ante 
	pay_winners(pay, low, LP_LIST, AL, _),
	pay_winners(pay, high, HP_LIST, AH, _),
	show_players(pot),
	show_players(human),
  	set_player(dealer),
  	deal_cards(done),
  	shuffle_deck(old).


  pay_winners(count, _, [], 0, 1).  % Avoid division by zero 
  pay_winners(count, _, [], N, N) :-
  	N > 0.
  pay_winners(count, HL, [_|T], N, W) :-
  	N1 is N + 1,
  	pay_winners(count, HL, T, N1, W).

  pay_winners(pay, _, [], _, 0).
  pay_winners(pay, HL, [H|T], A, 0) :-
  	MA is (-1 * A),
  	add_player_amt(H, stake, A),
  	add_player_amt(0, pot, MA),
  	str_int(SA, A),
  	text_concat(" $", SA, S),
  	add_player_text(H, S),
  	write("Player "), write(H), write(" wins $"), write(A), write(" for "), write(HL), write(" hand"), nl,
  	pay_winners(pay, HL, T, A, _).
  	

  decide_player_hand(_, HL, V1) :-  % Delete any lower scores 
  	player_hand_score(P2, HL, V2),
  		V2 < V1,
  		retract_player_hand_score(P2, HL, V2),
  		fail.  % Loop for all lower scores 
  decide_player_hand(P1, HL, V) :-  % Solitary best score 
  	not(player_hand_score(_, HL, _)),
 	assertz(player_hand_score(P1, HL, V)), !.
  decide_player_hand(P1, HL, V) :-  % Tied for best score 
  	player_hand_score(_, HL, V),
  	assertz(player_hand_score(P1, HL, V)), !.
  decide_player_hand(_, _, _) :- !.  % Not best score 


  hand_value(high, '2','2', V) :-  % Wild pair = Aces 
  	denomination_value('A', D, _),
  	V is 1000 * D, !.
  hand_value(high, C,'2', V) :-  % Wild makes pair 
  	denomination_value(C, D, _),
  	V is 1000 * D, !.
  hand_value(high, '2',C, V) :-  % Wild makes pair 
  	denomination_value(C, D, _),
  	V is 1000 * D, !.
  hand_value(high, C,C, V) :-
  	denomination_value(C, D, _),
  	V is 1000 * D, !.
  hand_value(high, C1,C2, V) :-  % High card C1 
  	denomination_value(C1, D1, _),
  	denomination_value(C2, D2, _),
  	D1 > D2,
  	V is (20 * D1) + D2, !.
  hand_value(high, C1,C2, V) :-  % High card C2 
  	denomination_value(C1, D1, _),
  	denomination_value(C2, D2, _),
  	D1 < D2,
  	V is (20 * D2) + D1, !.

  hand_value(low, '2','2', V) :-  % Wild pair = low Aces 
  	denomination_value('A', _, D),
  	V is (-1000 * D), !.
  hand_value(low, 'A','2', V) :-  % Wild treated as two 
  	denomination_value('2', _, D1),
  	denomination_value('A', _, D2),
  	V is (-20 * D1) - D2, !.
  hand_value(low, '2','A', V) :-  % Wild treated as two (should never occur, but cover if it does)
  	denomination_value('2', _, D1),
  	denomination_value('A', _, D2),
  	V is (-20 * D1) - D2, !.
  hand_value(low, C,'2', V) :-  % Wild treated as Ace, so 23 ties with A3
  	denomination_value(C, _, D1),
  	denomination_value('A', _, D2),
  	V is (-20 * D1) - D2, !.
  hand_value(low, '2',C, V) :-  % (Should never occur, but cover if it does)
  	denomination_value(C, _, D1),
  	denomination_value('A', _, D2),
  	V is (-20 * D1) - D2, !.
  hand_value(low, C,C, V) :-  % Low pair
  	denomination_value(C, _, D),
  	V is (-1000 * D), !.
  hand_value(low, C1,C2, V) :-  % High card C1 
  	denomination_value(C1, _, D1),
  	denomination_value(C2, _, D2),
  	D1 > D2,
  	V is (-20 * D1) - D2, !.
  hand_value(low, C1,C2, V) :-  % High card C2 (should never occur, but cover if it does)
  	denomination_value(C1, _, D1),
  	denomination_value(C2, _, D2),
  	D1 < D2,
  	V is (-20 * D2) - D1, !.
  	  

  denomination_value('A', 14, 1).  % High, Low value 
  denomination_value('2', 2, 2).   % Wild 
  denomination_value('3', 3, 3).
  denomination_value('4', 4, 4).
  denomination_value('5', 5, 5).
  denomination_value('6', 6, 6).
  denomination_value('7', 7, 7).
  denomination_value('8', 8, 8).
  denomination_value('9', 9, 9).
  denomination_value('T', 10, 10).
  denomination_value('J', 11, 11).
  denomination_value('Q', 12, 12).
  denomination_value('K', 13, 13).

  next(1, 2).
  next(2, 3).
  next(3, 4).
  next(4, 5).
  next(5, 6).
  next(6, 7).
  next(7, 8).
  next(8, 1).

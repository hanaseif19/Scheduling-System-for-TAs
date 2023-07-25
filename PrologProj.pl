 ta_slot_assignment(TAs,RemTAs,Name):-TAs= [H|T] ,
                                     H= ta(Name,Load) ,
                                     Load > 0,
									 NewLoad is  Load-1, 
									 RemTAs=[ta(Name,NewLoad)|T].
ta_slot_assignment(TAs,RemTAs,Name):-H=ta(Other,_),
                                     TAs= [H|T], 
                                     Other\= Name,
									 RemTAs=[H|T1],
                                     ta_slot_assignment(T,T1,Name).
slot_assignment(0,RemTAs,RemTAs,[]).
slot_assignment(LabsNum,TAs,RemTAs,Assignment):-LabsNum >0,
                                                TAs=[Ta|Rem],
                                                Ta=ta(Name,_),
												ta_slot_assignment(TAs,RemTAs1,Name),
												Assignment=[Name|RemAss],
												RemLabs is LabsNum-1,
												RemTAs1=[H|Rem],
												RemTAs=[H|Rem2],
                                                slot_assignment(RemLabs,Rem,Rem2,RemAss).
slot_assignment(LabsNum,TAs,RemTAs,Assignment):-LabsNum >0,
                                                TAs=[TA|Rem],
												RemTAs=[TA|Rem1],
                                                slot_assignment(LabsNum,Rem,Rem1,Assignment).
removeX([],_,[],0).
removeX(List ,X ,Result,Count):-List= [H|T],H\=X,
                                Result=[H|T1] ,
                                removeX(T,X,T1,Count).
removeX(List,X,Result,Count):-List=[H|T],
                              H=X, 
                              Result=T1,
							  removeX(T,X,T1,Count1),
                              Count is Count1 + 1.
max_slots_per_day(DaySched,_):-flatten(DaySched,Result),Result=[].
max_slots_per_day(DaySched,Max):-flatten(DaySched,Result),
                                 Result= [H|_],
                                 removeX(Result,H,Rem,Count),
								 Count =< Max,
                                 max_slots_per_day(Rem,Max).
day_schedule([],RemTAs,RemTAs,[]).
day_schedule(DaySlots,TAs,RemTAs,Assignment):- DaySlots=[Slot|RemDay],
                                               slot_assignment(Slot,TAs,RemTAs1,SlotAss),
											   permutation(SlotAss,SlotAss1),
											   Assignment=[SlotAss1|RemAss],
											   day_schedule(RemDay,RemTAs1,RemTAs,RemAss).
week_schedule([],_,_,[]).
week_schedule(WeekSlots,TAs,DayMax,WeekSched):-WeekSlots =[Day|RemWeek],
	                                           max_slots_per_day(DaySched,DayMax),
	                                           day_schedule(Day,TAs,RemTAs,DaySched),
											   WeekSched=[DaySched|RemSched],
												   week_schedule(RemWeek,RemTAs,DayMax,RemSched).
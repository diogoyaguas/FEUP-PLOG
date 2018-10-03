table = [[A19,A18,A17,A16,A15,A14,A13,A12,A11,A10,A9,A8,A7,A6,A5,A4,A3,A2,A1],
[B19,B18,B17,B16,B15,B14,B13,B12,B11,B10,B9,B8,B7,B6,B5,B4,B3,B2,B1],
[C19,C18,C17,C16,C15,C14,C13,C12,C11,C10,C9,C8,C7,C6,C5,C4,C3,C2,C1],
[D19,D18,D17,D16,D15,D14,D13,D12,D11,D10,D9,D8,D7,D6,D5,D4,D3,D2,D1],
[E19,E18,E17,E16,E15,E14,E13,E12,E11,E10,E9,E8,E7,E6,E5,E4,E3,E2,E1],
[F19,F18,F17,F16,F15,F14,F13,F12,F11,F10,F9,F8,F7,F6,F5,F4,F3,F2,F1],
[G19,G18,G17,G16,G15,G14,G13,G12,G11,G10,G9,G8,G7,G6,G5,G4,G3,G2,G1],
[H19,H18,H17,H16,H15,H14,H13,H12,H11,H10,H9,H8,H7,H6,H5,H4,H3,H2,H1],
[I19,I18,I17,I16,I15,I14,I13,I12,I11,I10,I9,I8,I7,I6,I5,I4,I3,I2,I1],
[J19,J18,J17,J16,J15,J14,J13,J12,J11,J10,J9,J8,J7,J6,J5,J4,J3,J2,J1],
[K19,K18,K17,K16,K15,K14,K13,K12,K11,K10,K9,K8,K7,K6,K5,K4,K3,K2,K1],
[L19,L18,L17,L16,L15,L14,L13,L12,L11,L10,L9,L8,L7,L6,L5,L4,L3,L2,L1],
[M19,M18,M17,M16,M15,M14,M13,M12,M11,M10,M9,M8,M7,M6,M5,M4,M3,M2,M1],
[N19,N18,N17,N16,N15,N14,N13,N12,N11,N10,N9,N8,N7,N6,N5,N4,N3,N2,N1],
[O19,O18,O17,O16,O15,O14,O13,O12,O11,O10,O9,O8,O7,O6,O5,O4,O3,O2,O1],
[P19,P18,P17,P16,P15,P14,P13,P12,P11,P10,P9,P8,P7,P6,P5,P4,P3,P2,P1],
[Q19,Q18,Q17,Q16,Q15,Q14,Q13,Q12,Q11,Q10,Q9,Q8,Q7,Q6,Q5,Q4,Q3,Q2,Q1],
[R19,R18,R17,R16,R15,R14,R13,R12,R11,R10,R9,R8,R7,R6,R5,R4,R3,R2,R1],
[S19,S18,S17,S16,S15,S14,S13,S12,S11,S10,S9,S8,S7,S6,S5,S4,S3,S2,S1]].    


getPiece(Line, Column , Table, Piece) :-
    getLine(Line, Table, ActualLine),
    getColumn(Column, ActualLine, Piece).

getLine(1, [Line | _ ], Line).
getLine(N, [ _ | Remainder], Line) :-
    N > 1,
    Previous is N - 1,
    getLine(Previous, Remainder, Line).

getColumn(1, [Piece | _ ], Piece).
getColumn(N, [ _ | Remainder], Piece) :-
    N > 1,
    Previous is N - 1,
    getColumn(Previous, Remainder, Piece).


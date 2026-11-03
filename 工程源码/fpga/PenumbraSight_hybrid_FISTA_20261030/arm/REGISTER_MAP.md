# HYF1 AXI Lite register map

The isolated board BD assigns `0xA2000000`, length `0x100`. Read ID before any command. Accesses are aligned 32-bit little-endian. Writes require WSTRB=0xF. Invalid writes return SLVERR and set a sticky command-error bit; command 7 resets the new accelerator only.

| Offset | Register |
|---|---|
| 00 | RO ID `48594631` |
| 04 | WO command: 1 clear input vector, 2 append indexed input, 3 start Gx, 4 first TV iteration, 5 resume TV iteration, 7 soft reset |
| 08 | RO status: bit1 busy, bit2 sticky done, bit3 error, bit4 TV saturation, bit5 TV result selected, bit6 input complete, bit7 G ready |
| 0C | RW input/result index, 0..1043 |
| 10 | RW signed32 Q20 input sample; command 2 appends it; indices must increase 0..1043 after command 1 |
| 14 | RW DMA address of 8-byte-aligned, driver-owned G buffer, below 4GiB |
| 18 | RW unsigned theta Q32, min 256 |
| 1C/20 | RW low/high words of unsigned inverse(8*theta) Q32; `(1<<64)//(8*theta_q32)` |
| 24 | RW unsigned TV beta Q30, range 0..1 |
| 28/2C/30/34 | RO result little-endian words: Gx is signed112 Q52 sign-extended to128; TV result is signed32 Q20 sign-extended to128 |
| 38 | RO loaded sample count |
| 3C | RO N=1044 |
| 40/44 | RO low/high active-cycle counter |

Each completed Gx result is stored, with no need for ARM polling at individual output-valid cycles. TV dual variables persist across command 5, but loading any new b invalidates them. A new b requires command 4. Hardware rejects result reads before completion and busy-time changes to compute configuration. Both AXI Lite address/data arrival orders and response backpressure are covered by the bench.

Input load currently writes both G's vector and TV's b memory, so a Gx job between two resumed TV iterations invalidates TV context. The ARM controller executes an entire prox call without interleaving a Gx. Initialization, gradient subtraction, outer momentum, objective checks, line search and stop rules are ARM operations.

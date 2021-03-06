
/* magic.cl -- (C) Mark Rodenkirch, December 2013

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the License, or
   (at your option) any later version.
 */

__kernel void magic_kernel(__global const long *primes,
                           __global      ulong *magicNumbers,
                           __global      ulong *magicShifts)
{
   int   gid = get_global_id(0);

   long   thePrime = primes[gid];
   ulong  magicNumber, magicShift;
   ulong  mN, mS;

   ulong two63 = 0x8000000000000000;

   ulong d = thePrime;
   ulong t = two63;
   ulong anc = t - 1 - t%d;    // Absolute value of nc.
   ulong p = 63;               // Init p.
   ulong q1 = two63/anc;       // Init q1 = 2**p/|nc|.
   ulong r1 = two63 - q1*anc;  // Init r1 = rem(2**p, |nc|).
   ulong q2 = two63/d;         // Init q2 = 2**p/|d|.
   ulong r2 = two63- q2*d;     // Init r2 = rem(2**p, |d|).
   ulong delta;

   do {
      p = p + 1;
      q1 = 2*q1;               // Update q1 = 2**p/|nc|.
      r1 = 2*r1;               // Update r1 = rem(2**p, |nc|.
      if (r1 >= anc) {         // Must be an unsigned comparison
         q1 = q1 + 1;
         r1 = r1 - anc;
      }
      q2 = 2*q2;               // Update q2 = 2**p/|d|.
      r2 = 2*r2;               // Update r2 = rem(2**p, |d|.
      if (r2 >= d) {           // Must be an unsigned comparison
         q2 = q2 + 1;
         r2 = r2 - d;
      }
      delta = d - r2;
   } while (q1 < delta || (q1 == delta && r1 == 0));

   magicNumbers[gid] = (q2 + 1);
   magicShifts[gid] = (p - 64);
}


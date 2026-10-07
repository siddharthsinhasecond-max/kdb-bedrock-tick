/ feedsim.q - random trade/quote generator for testing
/ usage (startq from repo root)
/ q q/feedsim.q
\l q/schema.q


/-----helpers------
/stamps: n timestamps, 1ms apart, starting now

stamps:{[n] .z.p+1000000*til n}


/randwalk: n prices starting near px0, each step upto +/-0.5 basis points

randWalk:{[n;px0] px0+sums px0*0.0001*-0.5+n?1.0}

/exchLag: exchange tiemstamps 1ns to 1ms before our receive times t
exchLag:{[t] t-1+(count t)?100000}

/---generators----
/genTrades n random trades for sym s arond price px0

genTrades:{[s;n;px0]
    t:stamps n;
    ([] time:t;
        sym:n#s;
        price:randWalk[n;px0];
        size:n?1.0;
        side:n?"bs";
        tradeId:1+til n;
        exchTime:exchLag t)
    }

genQuotes:{[s;n;px0]
  t:stamps n;
  mid:randWalk[n;px0];
  half:0.5*0.0001*mid;
  ([] time:t;
      sym:n#s;
      bid:mid-half;
      ask:mid+half;
      bsize:n?1.0;
      asize:n?1.0;
      exchTime:exchLag t)
  }


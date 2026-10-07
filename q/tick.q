/ tick.q - minimal tickerplant v1
/ Usage (from repo root): q/tick.q -p 5010

\l q/schema.q
.u.log:{-1 string[.z.p]," ", x;}
.z.po:{0N! "Connection started for ", string x}
/ ----state----
.u.t:tables[]
.u.w:.u.t!(count .u.t)#enlist()

/------subscribe----
/ .u.sub[t]: called remotely by a subscriber; returns (t;empty table)
.u.sub:{[t]
     if[not t in .u.t; '"unknown table: ", string t];
     if[0=.z.w; '"must subscribe remotely"];
     .u.w[t]:distinct .u.w[t],.z.w;
     .u.log "subscribed handle ", string[.z.w], " to ", string t;
     (t;0#value t)
       }


/---------publishing------
/ .u.send[h;t;d]: async -send (`upd;t;d) to ONE subscriber handle h
.u.send:{[h;t;d] neg[h] (`upd;t;d);}

/ ----sending to everyone subscribed to teh table----
/.u.pub[t;d]: send to every handler subscribed to table t
.u.pub:{[t;d] .u.send[;t;d] each .u.w t;}

/----feed entry point----
/.u.upd[t;d]: called by the FEED with new data( a table matching table t)
/-- This is called by the feed handler C with the table name and table of new row

.u.upd:{[t;d] 
     if[not t in .u.t; '"unknown table: ", string t];
     if[not (cols d)~cols value t; '"column mismatch for ",string t];
     .u.pub[t;d]
     }

/----Connection Events----
.z.po:{.u.log "Connection opened, handle ", string x;}
.z.pc:{.u.w:.u.w except\: x; .u.log "Connection closed, handle ", string x;}

/-----Startup ----
.u.log "tickeplant started on port ", string[system "p"], ", tables: ",", " sv string .u.t

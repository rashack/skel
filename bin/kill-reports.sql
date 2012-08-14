declare
 
cursor cur_rep is
select sid, serial#, inst_id from gv$session where username='REPORTS';
 
sSql varchar2 (100);
 
begin
       for r in cur_rep loop
     
          sSql := 'alter system kill session ' || '''' || r.sid || ',' || r.serial# ||'''';     
         
              execute immediate sSql;
             
                  commit;
                   end loop;
end;

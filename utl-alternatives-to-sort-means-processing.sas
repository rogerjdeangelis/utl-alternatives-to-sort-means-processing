Alternatives to sort means processing

   Problem: Summarize all numeric variables by year and month

   Two Solutions (both handle all numeric variables)

       1. proc report
       2. SQL arrays (see macros for authors)

If you are not concerned about efficiency you can use SQL or 'proc report',
However the SQL solution may be the fastest in database on a  big data server?

github
https://tinyurl.com/ybjw388a
https://github.com/rogerjdeangelis/utl-alternatives-to-sort-means-processing

SAS F orum
https://tinyurl.com/yckaxtkx
https://communities.sas.com/t5/SAS-Procedures/output-out-using-proc-means/m-p/517085

macros
https://tinyurl.com/y9nfugth
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories

INPUT
=====

 WORK.HAVE total obs=18

  YEAR    MONTH    FATKG    PROTKG    MILKKG

  2015     FEB        3       10        44
  2015     FEB       14        3        45   SUM=89

  2015     JAN       24        8        38
  2015     JAN        9       25         8   SUM=46

  2015     MAR        8       90        96
  2015     MAR       73       40        37
  2016     JAN       32       51        28
  2016     JAN       35       25        43
  2016     FEB       12       71         0
  2016     FEB       51       90        23
  2016     MAR       79       14        11
  2016     MAR       53       64        77
  2017     JAN       54       97        53
  2017     JAN       42       49        94
  2017     FEB       70       34        18
  2017     FEB       87       13        31
  2017     MAR       96       57        31
  2017     MAR       65       54        69


EXAMPLE OUTPUT
--------------

 WORK.WANT total obs=9

  YEAR    MONTH    FATKG    PROTKG    MILKKG

  2015     FEB       17        13        89  ** sea above
  2015     JAN       33        33        46  ** sea above

  2015     MAR       81       130       133
  2016     FEB       63       161        23
  2016     JAN       67        76        71
  2016     MAR      132        78        88
  2017     FEB      157        47        49
  2017     JAN       96       146       147
  2017     MAR      161       111       100


PROCESS
=======

  1. proc report

     proc report data=have out=want(drop=_:) nowd missing;
        cols year month _numeric_;
        define year/ group ;
        define month / group;
     run;quit;

  2. SQL arrays (potential to be the fastest if in database)

     %array(vars,values=%utl_varlist(have,keep=_numeric_));
     proc sql;
       create
          table want as
       select
          year
         ,month
         ,%do_over(vars,phrase=sum(?) as ?,between=comma)
       from
         have
       group
          by year, month
     ;quit;

OUTPUT
======
 see above

*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

data have;
  do year='2015','2016', '2017';
    do month='JAN','FEB','MAR';
       fatkg  = int(100*uniform(1234));
       protkg = int(100*uniform(1234));
       milkkg = int(100*uniform(1234));
       output;
       fatkg  = int(100*uniform(1234));
       protkg = int(100*uniform(1234));
       milkkg = int(100*uniform(1234));
       output;
    end;
  end;
  stop;
run;quit;




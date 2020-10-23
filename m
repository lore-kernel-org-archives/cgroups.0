From: Rong Chen <rong.a.chen@intel.com>
Subject: Re: [PATCH v19 18/20] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Fri, 23 Oct 2020 10:00:19 +0800
Message-ID: <20201023020019.GG31092@shao2-debian>
References: <1600918115-22007-1-git-send-email-alex.shi@linux.alibaba.com>
 <1600918115-22007-19-git-send-email-alex.shi@linux.alibaba.com>
 <ef27dcbd-37fe-c16a-71ee-61709cc135f3@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ef27dcbd-37fe-c16a-71ee-61709cc135f3@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com, aaron.lwe@gmail.com, Michal Hocko <mhocko@kernel.org>, Yang Shi <yang.shi@linux.alibaba.com>, "lkp@linux.intel.com" <lkp@linux.intel.com>

On Wed, Oct 21, 2020 at 03:23:34PM +0800, Alex Shi wrote:
> 
> 在 2020/9/24 上午11:28, Alex Shi 写道:
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -273,6 +273,8 @@ enum lruvec_flags {
> >  };
> >  
> >  struct lruvec {
> > +	/* per lruvec lru_lock for memcg */
> > +	spinlock_t			lru_lock;
> >  	struct list_head		lists[NR_LRU_LISTS];
> >  	/*
> >  	 * These track the cost of reclaiming one LRU - file or anon -
> 
> Hi All,
> 
> Intel Rong Chen, LKP, report a big regression on this patch, about 12 ~ 32% performance drop on fio.read_iops and case-lru-file-mmap-read case on wide Intel machine with attached kernel config. Hugh Dickins pointed it's a false sharing issue on the lru_lock. And that could be fixed by move the lru_lock out of busy lists[] cacheline, like the following patch:
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index a75e6d0effcb..58b21bffef95 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -272,9 +272,9 @@ enum lruvec_flags {
>  };
> 
>  struct lruvec {
> +       struct list_head                lists[NR_LRU_LISTS];
>         /* per lruvec lru_lock for memcg */
>         spinlock_t                      lru_lock;
> -       struct list_head                lists[NR_LRU_LISTS];
>         /*
>          * These track the cost of reclaiming one LRU - file or anon -
>          * over the other. As the observed cost of reclaiming one LRU
> 
> Although the problem fixed， But I still no idea of the reasons and the gut problem. Any comments for this?
> 
> 

Hi all,

Here is the detail for your reference:

in testcase: fio-basic
on test machine: 96 threads Intel(R) Xeon(R) Gold 6252 CPU @ 2.10GHz with 256G memory
with following parameters:

	disk: 2pmem
	fs: xfs
	runtime: 200s
	nr_task: 50%
	time_based: tb
	rw: randread
	bs: 2M
	ioengine: mmap
	test_size: 200G
	cpufreq_governor: performance
	ucode: 0x5002f01


=========================================================================================
bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase/time_based/ucode:
  2M/gcc-9/performance/2pmem/xfs/mmap/x86_64-rhel-8.3/50%/debian-10.4-x86_64-20200603.cgz/200s/randread/lkp-csl-2sp6/200G/fio-basic/tb/0x5002f01

commit: 
  b53890a41e2848c429ba7091b118f8219e9708f1 ("mm/swap.c: serialize memcg changes in pagevec_lru_move_fn")
  16c8a4eabc9980d6a11d4f39d9420e4b1d2f25eb ("mm/lru: replace pgdat lru_lock with lruvec lock")
  0a8b34c9a678c3421c83200a76d57ef0fc01b5b7 ("lru: fix false sharing on lru_lock")

b53890a41e2848c4 16c8a4eabc9980d6a11d4f39d94 0a8b34c9a678c3421c83200a76d 
---------------- --------------------------- --------------------------- 
       fail:runs  %reproduction    fail:runs  %reproduction    fail:runs
           |             |             |             |             |    
        321:3        20022%         921:3        10199%         627:3     dmesg.timestamp:last
        925:3         -136%         921:3         -333%         915:3     kmsg.timestamp:last
          3:3            0%           3:3            0%           3:3     stderr.Events_disabled
          3:3            0%           3:3            0%           3:3     stderr.Events_enabled
          3:3            0%           3:3            0%           3:3     stderr.[perf_record:Captured_and_wrote#MB/tmp/lkp/perf_c2c.data(#samples)]
          3:3            0%           3:3            0%           3:3     stderr.[perf_record:Woken_up#times_to_write_data]
          3:3            0%           3:3            0%           3:3     stderr.has_stderr
          1:3          -15%           0:3           -3%           1:3     perf-profile.children.cycles-pp.error_entry
          0:3           -3%           0:3           -1%           0:3     perf-profile.self.cycles-pp.error_entry
         %stddev     %change         %stddev     %change         %stddev
             \          |                \          |                \  
      0.01 ± 70%      +0.0        0.01 ± 80%      -0.0        0.00 ±141%  fio.latency_1000ms%
      0.41 ±  8%      -0.3        0.16 ± 11%      -0.2        0.24 ± 11%  fio.latency_1000us%
      0.25 ± 18%      +0.7        0.96 ± 19%      -0.1        0.17 ± 40%  fio.latency_100ms%
     41.92 ± 14%      +2.5       44.38 ±  5%      +3.5       45.42 ±  5%  fio.latency_10ms%
      0.01 ± 70%      +0.0        0.01 ± 83%      -0.0        0.00 ±141%  fio.latency_2000ms%
     26.70 ±  7%     -17.3        9.45 ± 21%      +2.0       28.70 ±  4%  fio.latency_20ms%
      0.07 ± 30%      +0.3        0.33 ± 20%      -0.0        0.04 ± 60%  fio.latency_250ms%
      0.01            +0.0        0.02 ± 45%      +0.0        0.01 ± 13%  fio.latency_250us%
      0.07 ± 44%      -0.1        0.02 ± 11%      -0.0        0.02 ± 45%  fio.latency_2ms%
     24.08 ± 27%      -1.2       22.92 ± 13%      -4.1       20.02 ± 15%  fio.latency_4ms%
      0.02 ± 23%      +0.0        0.06 ± 42%      -0.0        0.02 ± 27%  fio.latency_500ms%
      0.35 ± 17%      +0.2        0.51 ± 12%      +0.0        0.37 ±  9%  fio.latency_500us%
      5.34 ± 42%     +15.0       20.31 ± 14%      -1.2        4.11 ± 12%  fio.latency_50ms%
      0.01            +0.0        0.01            -0.0        0.00 ±141%  fio.latency_750ms%
      0.77 ±  5%      +0.1        0.88            +0.1        0.88 ±  7%  fio.latency_750us%
      0.00            +0.0        0.00 ±141%      +0.0        0.00        fio.latency_>=2000ms%
     10386 ±  2%     -27.8%       7494 ±  4%      -3.5%      10027        fio.read_bw_MBps
  18219008 ±  5%     +45.1%   26432853 ±  8%      +0.0%   18219008        fio.read_clat_90%_us
  20316160 ±  6%     +49.0%   30277632 ±  5%      -3.4%   19617109        fio.read_clat_95%_us
  33335978 ±  7%     +79.3%   59768832 ± 11%     -15.7%   28093098 ± 14%  fio.read_clat_99%_us
   9025993 ±  2%     +36.9%   12355145 ±  3%      +2.8%    9274865        fio.read_clat_mean_us
  12717159 ± 14%     +90.7%   24256888 ± 33%     -18.5%   10359535 ± 29%  fio.read_clat_stddev
      5193 ±  2%     -27.8%       3747 ±  4%      -3.5%       5013        fio.read_iops
    201.39            -0.0%     201.37            -0.1%     201.28        fio.time.elapsed_time
    201.39            -0.0%     201.37            -0.1%     201.28        fio.time.elapsed_time.max
 4.187e+09 ±  2%     -27.8%  3.022e+09 ±  4%      -3.4%  4.046e+09        fio.time.file_system_inputs
    487428 ±  4%      -9.0%     443649 ±  8%     +13.7%     554115 ±  3%  fio.time.involuntary_context_switches
 5.236e+08 ±  2%     -27.8%   3.78e+08 ±  4%      -3.4%   5.06e+08        fio.time.major_page_faults
   1602456 ±  9%      +1.3%    1622745 ±  4%      -1.2%    1582553 ± 13%  fio.time.maximum_resident_set_size
     42438 ± 59%     -11.3%      37625 ± 51%     +30.1%      55210 ± 58%  fio.time.minor_page_faults
      4096            +0.0%       4096            +0.0%       4096        fio.time.page_size
      4691            +0.5%       4714            +0.3%       4703        fio.time.percent_of_cpu_this_job_got
      8982            +2.4%       9195            +0.6%       9032        fio.time.system_time
    466.06 ±  3%     -35.6%     300.30 ±  7%      -6.4%     436.07 ±  4%  fio.time.user_time
     26383 ±  5%      +1.4%      26759 ±  6%      -7.0%      24543 ±  5%  fio.time.voluntary_context_switches
   1038928 ±  2%     -27.8%     749695 ±  4%      -3.5%    1003014        fio.workload
    397.85            -0.5%     395.74            -0.9%     394.15        uptime.boot
     27592            -0.7%      27391            -1.2%      27250        uptime.idle
     21.05            +0.1%      21.08            +0.0%      21.06        boot-time.boot
     15.50            +0.9%      15.64            +0.4%      15.57        boot-time.dhcp
      1666            +0.3%       1670            +0.1%       1668        boot-time.idle
      0.86            -0.0%       0.86            -0.0%       0.86        boot-time.smp_boot
     48.68            -0.0%      48.66            -0.2%      48.58        iostat.cpu.idle
      0.00        +1.6e+97%       0.00 ±141%  +4.9e+97%       0.00        iostat.cpu.iowait
     48.91            +1.8%      49.77            +0.5%      49.16        iostat.cpu.system
      2.41 ±  3%     -35.0%       1.57 ±  7%      -6.0%       2.26 ±  4%  iostat.cpu.user
      2699 ± 15%     -15.4%       2282 ±  6%      -3.6%       2602 ± 12%  perf-c2c.DRAM.local
      4502 ±  7%      +1.8%       4583 ±  8%      +3.6%       4666 ± 11%  perf-c2c.DRAM.remote
      4120 ±  8%     +27.3%       5243 ±  5%      +4.5%       4306 ±  6%  perf-c2c.HITM.local
      1061 ± 13%     +25.7%       1333 ±  5%      -8.8%     967.33 ±  8%  perf-c2c.HITM.remote
     48.20            -0.0       48.18            -0.1       48.11        mpstat.cpu.all.idle%
      1.29 ±  4%      -0.4        0.94 ±  3%      -0.1        1.19 ±  2%  mpstat.cpu.all.irq%
      0.06            -0.0        0.05 ±  2%      -0.0        0.06        mpstat.cpu.all.soft%
     48.02            +1.2       49.26            +0.3       48.35        mpstat.cpu.all.sys%
      2.43 ±  3%      -0.9        1.58 ±  7%      -0.1        2.28 ±  4%  mpstat.cpu.all.usr%
    830372 ± 16%   +4631.9%   39292060 ±135%     +34.2%    1114546 ± 11%  cpuidle.C1.time
     29231 ± 11%   +1554.6%     483661 ±124%     +28.9%      37675 ± 13%  cpuidle.C1.usage
 3.351e+09 ± 20%     +24.1%  4.159e+09 ± 59%     +75.2%  5.871e+09 ± 48%  cpuidle.C1E.time
  10620526 ±  2%     +16.1%   12329066 ± 20%     +41.5%   15026448 ± 22%  cpuidle.C1E.usage
 6.025e+09 ± 11%     -14.4%  5.158e+09 ± 49%     -42.2%   3.48e+09 ± 81%  cpuidle.C6.time
   8578083 ±  3%     -27.3%    6239788 ± 51%     -52.8%    4049845 ± 83%  cpuidle.C6.usage
     63769 ±  8%     +10.6%      70508 ± 19%      +0.4%      64022 ±  3%  cpuidle.POLL.time
     21855 ± 12%      -1.5%      21532 ± 16%      -5.7%      20609 ±  6%  cpuidle.POLL.usage
     48.00            +0.0%      48.00            +0.0%      48.00        vmstat.cpu.id
     48.67            +0.7%      49.00            +0.7%      49.00        vmstat.cpu.sy
      2.00           -50.0%       1.00            +0.0%       2.00        vmstat.cpu.us
  10243915 ±  2%     -27.8%    7394480 ±  4%      -3.2%    9915457        vmstat.io.bi
     55.67            +1.8%      56.67            +2.4%      57.00        vmstat.io.bo
      0.00          -100.0%       0.00          -100.0%       0.00        vmstat.memory.buff
  42704186            -0.0%   42695150            -0.1%   42659921        vmstat.memory.cache
   1097298            +0.3%    1100401            +1.6%    1114684 ±  2%  vmstat.memory.free
     48.33            +0.7%      48.67            +0.0%      48.33        vmstat.procs.r
      6914 ±  3%      -7.1%       6423 ±  6%      +8.7%       7517 ±  3%  vmstat.system.cs
    422616           -20.7%     335155            -4.3%     404446        vmstat.system.in
      0.00          -100.0%       0.00          -100.0%       0.00        numa-numastat.node0.interleave_hit
  2.02e+08 ±  7%     -28.1%  1.453e+08 ± 10%      -6.3%  1.893e+08 ±  5%  numa-numastat.node0.local_node
  55522626 ±  9%     -22.3%   43136856 ± 12%     +10.0%   61056981 ±  9%  numa-numastat.node0.numa_foreign
  2.02e+08 ±  7%     -28.1%  1.453e+08 ± 10%      -6.3%  1.893e+08 ±  5%  numa-numastat.node0.numa_hit
  52932496 ±  7%     -24.3%   40095020 ± 16%     +22.5%   64842596 ± 13%  numa-numastat.node0.numa_miss
  52965570 ±  7%     -24.3%   40109615 ± 16%     +22.5%   64882016 ± 13%  numa-numastat.node0.other_node
      0.00          -100.0%       0.00          -100.0%       0.00        numa-numastat.node1.interleave_hit
 2.142e+08 ±  2%     -29.8%  1.505e+08 ±  8%     -10.5%  1.918e+08 ±  4%  numa-numastat.node1.local_node
  52932496 ±  7%     -24.3%   40095020 ± 16%     +22.5%   64842596 ± 13%  numa-numastat.node1.numa_foreign
 2.142e+08 ±  2%     -29.7%  1.505e+08 ±  8%     -10.5%  1.918e+08 ±  4%  numa-numastat.node1.numa_hit
  55522626 ±  9%     -22.3%   43136856 ± 12%     +10.0%   61056981 ±  9%  numa-numastat.node1.numa_miss
  55533458 ±  9%     -22.3%   43166155 ± 12%     +10.0%   61061394 ±  9%  numa-numastat.node1.other_node
    201.39            -0.0%     201.37            -0.1%     201.28        time.elapsed_time
    201.39            -0.0%     201.37            -0.1%     201.28        time.elapsed_time.max
 4.187e+09 ±  2%     -27.8%  3.022e+09 ±  4%      -3.4%  4.046e+09        time.file_system_inputs
    487428 ±  4%      -9.0%     443649 ±  8%     +13.7%     554115 ±  3%  time.involuntary_context_switches
 5.236e+08 ±  2%     -27.8%   3.78e+08 ±  4%      -3.4%   5.06e+08        time.major_page_faults
   1602456 ±  9%      +1.3%    1622745 ±  4%      -1.2%    1582553 ± 13%  time.maximum_resident_set_size
     42438 ± 59%     -11.3%      37625 ± 51%     +30.1%      55210 ± 58%  time.minor_page_faults
      4096            +0.0%       4096            +0.0%       4096        time.page_size
      4691            +0.5%       4714            +0.3%       4703        time.percent_of_cpu_this_job_got
      8982            +2.4%       9195            +0.6%       9032        time.system_time
    466.06 ±  3%     -35.6%     300.30 ±  7%      -6.4%     436.07 ±  4%  time.user_time
     26383 ±  5%      +1.4%      26759 ±  6%      -7.0%      24543 ±  5%  time.voluntary_context_switches
   2414054 ±  2%      -1.8%    2370953            -4.3%    2310463        meminfo.Active
    578242 ±  4%     -13.5%     500374 ±  6%      -9.6%     522734 ±  4%  meminfo.Active(anon)
   1835811 ±  5%      +1.9%    1870577            -2.6%    1787729 ±  3%  meminfo.Active(file)
    348542            -0.4%     347123            -0.4%     347162        meminfo.AnonHugePages
    427055 ±  4%      +2.8%     438931 ±  2%      +4.5%     446092 ±  4%  meminfo.AnonPages
      0.00          -100.0%       0.00          -100.0%       0.00        meminfo.Buffers
  42294566            -0.0%   42281746            -0.1%   42250064        meminfo.Cached
     16759 ± 16%     -10.5%      14995           +12.7%      18896 ±  7%  meminfo.CmaFree
    204800            +0.0%     204800            +0.0%     204800        meminfo.CmaTotal
  24554032            +0.0%   24554032            +0.0%   24554032        meminfo.CommitLimit
   7089949            -1.0%    7019050            -0.6%    7047335        meminfo.Committed_AS
 2.531e+08            +0.6%  2.545e+08            +0.4%  2.541e+08        meminfo.DirectMap1G
  16418816 ±  3%      -8.7%   14994773 ±  3%      -6.5%   15353856 ±  6%  meminfo.DirectMap2M
    733290 ±  6%      +3.5%     759232 ±  3%      +2.2%     749674 ±  5%  meminfo.DirectMap4k
     30.33 ±  8%     -24.2%      23.00 ± 46%     -33.0%      20.33 ± 52%  meminfo.Dirty
      2048            +0.0%       2048            +0.0%       2048        meminfo.Hugepagesize
  39299826            +0.1%   39342118            +0.2%   39378057        meminfo.Inactive
   1574193            +0.8%    1587196            +1.4%    1595969        meminfo.Inactive(anon)
  37725632            +0.1%   37754922            +0.1%   37782087        meminfo.Inactive(file)
    378394            -1.0%     374526            +0.1%     378773        meminfo.KReclaimable
     16395            -0.1%      16385            +1.0%      16551        meminfo.KernelStack
  40522612            +0.3%   40652115            +0.2%   40605722        meminfo.Mapped
  40473542            +0.2%   40551231            +0.0%   40474208        meminfo.MemAvailable
   1124751            +1.1%    1137591            +1.3%    1139065        meminfo.MemFree
  49108064            +0.0%   49108064            +0.0%   49108064        meminfo.MemTotal
  47983312            -0.0%   47970471            -0.0%   47968997        meminfo.Memused
    553.00 ±  4%    +215.9%       1747 ± 48%    +213.8%       1735 ± 49%  meminfo.Mlocked
    397858            -0.6%     395466            +0.2%     398746        meminfo.PageTables
     46645            +0.8%      47036            +0.8%      47032        meminfo.Percpu
    378394            -1.0%     374526            +0.1%     378773        meminfo.SReclaimable
    206409            +0.6%     207718            +2.0%     210473        meminfo.SUnreclaim
   1725674            -4.4%    1649151            -3.0%    1673109        meminfo.Shmem
    584804            -0.4%     582245            +0.8%     589247        meminfo.Slab
   1001980            +0.0%    1002155            -0.0%    1001531        meminfo.Unevictable
 3.436e+10            +0.0%  3.436e+10            +0.0%  3.436e+10        meminfo.VmallocTotal
    142428            +0.0%     142461            +0.1%     142563        meminfo.VmallocUsed
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        meminfo.Writeback
    244185            +1.5%     247913            -0.0%     244163        meminfo.max_used_kB
   1050297 ±  6%     +12.7%    1184106 ±  4%      +5.6%    1109366 ±  7%  numa-meminfo.node0.Active
    174440 ± 19%     +60.4%     279850 ± 10%     +11.3%     194215 ± 27%  numa-meminfo.node0.Active(anon)
    875856 ± 10%      +3.2%     904255 ±  3%      +4.5%     915150 ±  4%  numa-meminfo.node0.Active(file)
    206183 ±  4%     +13.1%     233289 ± 20%     -10.6%     184306 ± 13%  numa-meminfo.node0.AnonHugePages
    250281 ±  8%     +16.1%     290525 ± 16%      -9.5%     226424 ±  5%  numa-meminfo.node0.AnonPages
      8.33 ±116%     +72.0%      14.33 ± 92%     -88.0%       1.00        numa-meminfo.node0.Dirty
  20764162            +0.2%   20807560            +0.2%   20804043        numa-meminfo.node0.FilePages
  19442140            -0.2%   19398241            -0.2%   19403151        numa-meminfo.node0.Inactive
    999002 ± 53%      +4.7%    1045717 ± 45%     -76.0%     239626 ±  7%  numa-meminfo.node0.Inactive(anon)
  18443137 ±  2%      -0.5%   18352523 ±  2%      +3.9%   19163524        numa-meminfo.node0.Inactive(file)
    206631 ±  3%      -5.6%     195049            -3.0%     200521        numa-meminfo.node0.KReclaimable
      9527 ±  2%      -2.8%       9261 ±  5%     -14.8%       8121 ±  4%  numa-meminfo.node0.KernelStack
  19983031            -0.3%   19923881            +0.3%   20035155        numa-meminfo.node0.Mapped
    553317 ±  2%      -0.6%     550113           +16.2%     642679 ±  9%  numa-meminfo.node0.MemFree
  24375744            +0.0%   24375744            +0.0%   24375744        numa-meminfo.node0.MemTotal
  23822425            +0.0%   23825629            -0.4%   23733063        numa-meminfo.node0.MemUsed
    304.33 ±  7%    +191.3%     886.67 ± 48%    +226.8%     994.67 ± 49%  numa-meminfo.node0.Mlocked
    225803 ±  2%      -1.2%     223146 ±  2%      -8.8%     205830 ± 11%  numa-meminfo.node0.PageTables
    206631 ±  3%      -5.6%     195049            -3.0%     200521        numa-meminfo.node0.SReclaimable
    122049            -1.4%     120292 ±  8%     -11.2%     108426 ± 11%  numa-meminfo.node0.SUnreclaim
    923343 ± 60%     +12.1%    1035323 ± 50%     -77.5%     207781 ± 26%  numa-meminfo.node0.Shmem
    328681 ±  2%      -4.1%     315342 ±  2%      -6.0%     308948 ±  3%  numa-meminfo.node0.Slab
    518678            -1.1%     513226            -0.8%     514726        numa-meminfo.node0.Unevictable
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        numa-meminfo.node0.Writeback
   1362489 ±  3%     -13.0%    1185342 ±  3%     -12.2%    1196148 ±  6%  numa-meminfo.node1.Active
    404100 ±  3%     -44.9%     222523 ±  3%     -19.0%     327252 ± 22%  numa-meminfo.node1.Active(anon)
    958388 ±  2%      +0.5%     962818 ±  4%      -9.3%     868895 ±  2%  numa-meminfo.node1.Active(file)
    142319 ±  7%     -19.9%     113947 ± 43%     +14.3%     162624 ± 16%  numa-meminfo.node1.AnonHugePages
    176746 ±  2%     -16.2%     148168 ± 25%     +24.4%     219794 ± 15%  numa-meminfo.node1.AnonPages
     21.33 ± 57%     -60.9%       8.33 ±133%     -12.5%      18.67 ± 57%  numa-meminfo.node1.Dirty
  21518698            -0.2%   21474912            -0.3%   21445060        numa-meminfo.node1.FilePages
  19846573            +0.5%   19945997            +0.7%   19979152        numa-meminfo.node1.Inactive
    574439 ± 91%      -6.0%     540254 ± 90%    +135.6%    1353307 ±  3%  numa-meminfo.node1.Inactive(anon)
  19272133 ±  2%      +0.7%   19405741 ±  2%      -3.4%   18625844        numa-meminfo.node1.Inactive(file)
    172057 ±  2%      +4.4%     179601            +3.6%     178227 ±  2%  numa-meminfo.node1.KReclaimable
      6872 ±  5%      +3.7%       7128 ±  5%     +22.6%       8428 ±  4%  numa-meminfo.node1.KernelStack
  20528715            +0.7%   20665531            +0.2%   20567867        numa-meminfo.node1.Mapped
    582511 ±  2%      +0.8%     587127           -14.3%     499088 ±  8%  numa-meminfo.node1.MemFree
  24732320            +0.0%   24732320            +0.0%   24732320        numa-meminfo.node1.MemTotal
  24149807            -0.0%   24145191            +0.3%   24233230        numa-meminfo.node1.MemUsed
    246.00 ±  4%    +249.7%     860.33 ± 53%    +200.7%     739.67 ± 49%  numa-meminfo.node1.Mlocked
    172131 ±  3%      -0.2%     171865 ±  2%     +11.9%     192643 ± 11%  numa-meminfo.node1.PageTables
    172057 ±  2%      +4.4%     179601            +3.6%     178227 ±  2%  numa-meminfo.node1.SReclaimable
     84364 ±  3%      +3.6%      87423 ± 13%     +20.9%     102036 ± 12%  numa-meminfo.node1.SUnreclaim
    801917 ± 65%     -23.3%     614842 ± 86%     +82.2%    1460885 ±  5%  numa-meminfo.node1.Shmem
    256422            +4.1%     267025 ±  4%      +9.3%     280263 ±  3%  numa-meminfo.node1.Slab
    483301            +1.2%     488928            +0.7%     486804        numa-meminfo.node1.Unevictable
      0.00          -100.0%       0.00          -100.0%       0.00        numa-meminfo.node1.Writeback
     10.34            -3.8%       9.94 ±  4%      +0.6%      10.40        perf-stat.i.MPKI
 1.232e+10 ±  2%     -20.4%  9.805e+09 ±  2%      -2.1%  1.207e+10        perf-stat.i.branch-instructions
      0.40            -0.0        0.37            +0.0        0.41        perf-stat.i.branch-miss-rate%
  49139003 ±  3%     -24.7%   37006246 ±  3%      -1.4%   48432296        perf-stat.i.branch-misses
     67.05            -3.7       63.38 ±  2%      -0.6       66.42        perf-stat.i.cache-miss-rate%
 4.269e+08 ±  2%     -26.4%   3.14e+08 ±  2%      -3.0%  4.139e+08        perf-stat.i.cache-misses
 6.312e+08 ±  2%     -23.2%   4.85e+08            -2.0%  6.189e+08        perf-stat.i.cache-references
      6927 ±  3%      -7.1%       6433 ±  6%      +8.7%       7531 ±  3%  perf-stat.i.context-switches
      2.36           +35.0%       3.19            +1.7%       2.40        perf-stat.i.cpi
     96017            -0.0%      96016            -0.0%      96012        perf-stat.i.cpu-clock
 1.382e+11            +0.4%  1.388e+11            -0.0%  1.382e+11        perf-stat.i.cpu-cycles
    125.33 ±  2%      -7.1%     116.43 ±  2%      -5.2%     118.82 ±  2%  perf-stat.i.cpu-migrations
    361.51           +66.5%     601.95 ± 10%      +0.6%     363.81 ±  3%  perf-stat.i.cycles-between-cache-misses
      0.40            -0.1        0.35            -0.0        0.40        perf-stat.i.dTLB-load-miss-rate%
  63070072 ±  2%     -30.2%   44024618 ±  4%      -4.9%   59969139        perf-stat.i.dTLB-load-misses
 1.517e+10 ±  2%     -21.8%  1.187e+10 ±  3%      -2.5%  1.479e+10        perf-stat.i.dTLB-loads
      0.05 ± 11%      +0.0        0.05 ±  6%      +0.0        0.05 ± 11%  perf-stat.i.dTLB-store-miss-rate%
   3712383 ± 13%     -25.0%    2785404 ±  9%      +8.1%    4014638 ± 12%  perf-stat.i.dTLB-store-misses
 7.653e+09 ±  2%     -27.5%   5.55e+09 ±  4%      -3.6%  7.375e+09        perf-stat.i.dTLB-stores
     89.95            -2.6       87.39            -0.3       89.64        perf-stat.i.iTLB-load-miss-rate%
  24264833 ±  4%     -22.9%   18720179 ±  3%      -4.1%   23274977 ±  3%  perf-stat.i.iTLB-load-misses
   2537218            -9.1%    2305974 ±  4%      +0.4%    2546729 ±  2%  perf-stat.i.iTLB-loads
 6.018e+10 ±  2%     -21.7%  4.713e+10 ±  3%      -2.3%  5.877e+10        perf-stat.i.instructions
      2569            +9.4%       2812 ±  6%      +0.9%       2592 ±  3%  perf-stat.i.instructions-per-iTLB-miss
      0.44 ±  2%     -21.6%       0.34 ±  3%      -2.2%       0.43        perf-stat.i.ipc
   2592013 ±  2%     -27.6%    1876230 ±  4%      -3.4%    2504255        perf-stat.i.major-faults
      1.44            +0.4%       1.45            -0.0%       1.44        perf-stat.i.metric.GHz
      0.11 ±  2%      -4.9%       0.11 ±  4%      +5.8%       0.12 ±  3%  perf-stat.i.metric.K/sec
    374.21 ±  2%     -22.6%     289.73 ±  3%      -2.6%     364.45        perf-stat.i.metric.M/sec
      3359 ±  4%      -3.6%       3238 ±  2%      +1.5%       3411 ±  4%  perf-stat.i.minor-faults
     62.49 ±  2%      +5.1       67.58 ±  4%      +2.9       65.38 ±  7%  perf-stat.i.node-load-miss-rate%
  18804483 ±  2%     -12.1%   16531877 ±  4%      +5.8%   19898585 ±  8%  perf-stat.i.node-load-misses
  11650303 ±  4%     -27.8%    8414395 ±  9%      -7.4%   10787735 ± 12%  perf-stat.i.node-loads
     31.36 ±  6%      +6.1       37.46 ±  8%      +4.2       35.52 ±  6%  perf-stat.i.node-store-miss-rate%
  27565405 ±  6%     -18.3%   22508980 ±  9%     +13.5%   31279383 ±  7%  perf-stat.i.node-store-misses
  66371056 ±  5%     -29.8%   46577558 ±  8%      -7.5%   61415123 ±  4%  perf-stat.i.node-stores
   2595373 ±  2%     -27.6%    1879470 ±  4%      -3.4%    2507667        perf-stat.i.page-faults
     96017            -0.0%      96016            -0.0%      96012        perf-stat.i.task-clock
     10.49            -1.8%      10.30 ±  3%      +0.4%      10.53        perf-stat.overall.MPKI
      0.40            -0.0        0.38            +0.0        0.40        perf-stat.overall.branch-miss-rate%
     67.63            -2.9       64.74 ±  2%      -0.7       66.88        perf-stat.overall.cache-miss-rate%
      2.30 ±  2%     +28.5%       2.95 ±  2%      +2.3%       2.35        perf-stat.overall.cpi
    323.92 ±  2%     +36.8%     443.22 ±  2%      +3.0%     333.79        perf-stat.overall.cycles-between-cache-misses
      0.41            -0.0        0.37            -0.0        0.40        perf-stat.overall.dTLB-load-miss-rate%
      0.05 ± 12%      +0.0        0.05 ±  6%      +0.0        0.05 ± 11%  perf-stat.overall.dTLB-store-miss-rate%
     90.52            -1.5       89.01            -0.4       90.14        perf-stat.overall.iTLB-load-miss-rate%
      2482            +1.5%       2520 ±  2%      +1.8%       2527 ±  2%  perf-stat.overall.instructions-per-iTLB-miss
      0.44 ±  2%     -22.1%       0.34 ±  2%      -2.3%       0.43        perf-stat.overall.ipc
     61.74 ±  2%      +4.6       66.30 ±  4%      +3.0       64.79 ±  7%  perf-stat.overall.node-load-miss-rate%
     29.37 ±  8%      +3.3       32.70 ± 12%      +4.3       33.72 ±  8%  perf-stat.overall.node-store-miss-rate%
  11673055            +8.3%   12636088            +1.0%   11784264        perf-stat.overall.path-length
 1.226e+10 ±  2%     -20.5%  9.743e+09 ±  2%      -2.1%  1.201e+10        perf-stat.ps.branch-instructions
  48948647 ±  3%     -24.9%   36780728 ±  3%      -1.4%   48264445        perf-stat.ps.branch-misses
 4.247e+08 ±  2%     -26.6%  3.118e+08 ±  2%      -3.0%  4.119e+08        perf-stat.ps.cache-misses
 6.281e+08 ±  2%     -23.3%  4.816e+08            -1.9%  6.159e+08        perf-stat.ps.cache-references
      6891 ±  3%      -7.1%       6402 ±  6%      +8.8%       7495 ±  3%  perf-stat.ps.context-switches
     95521            -0.0%      95519            -0.0%      95521        perf-stat.ps.cpu-clock
 1.375e+11            +0.4%  1.381e+11            -0.0%  1.375e+11        perf-stat.ps.cpu-cycles
    125.05 ±  2%      -7.2%     116.05 ±  2%      -5.1%     118.67 ±  2%  perf-stat.ps.cpu-migrations
  62750257 ±  2%     -30.3%   43706114 ±  4%      -4.9%   59672484        perf-stat.ps.dTLB-load-misses
  1.51e+10 ±  2%     -21.9%  1.179e+10 ±  3%      -2.5%  1.472e+10        perf-stat.ps.dTLB-loads
   3693247 ± 13%     -25.1%    2765293 ±  9%      +8.2%    3994538 ± 12%  perf-stat.ps.dTLB-store-misses
 7.615e+09 ±  2%     -27.6%  5.513e+09 ±  3%      -3.6%  7.339e+09        perf-stat.ps.dTLB-stores
  24142213 ±  4%     -23.0%   18588478 ±  3%      -4.1%   23159291 ±  3%  perf-stat.ps.iTLB-load-misses
   2523754            -9.2%    2292057 ±  4%      +0.4%    2533327 ±  2%  perf-stat.ps.iTLB-loads
 5.987e+10 ±  2%     -21.8%  4.683e+10 ±  3%      -2.3%  5.848e+10        perf-stat.ps.instructions
   2579173 ±  2%     -27.8%    1862784 ±  4%      -3.4%    2492104        perf-stat.ps.major-faults
      3345 ±  3%      -3.6%       3224 ±  3%      +1.6%       3400 ±  4%  perf-stat.ps.minor-faults
  18707796 ±  2%     -12.2%   16427710 ±  4%      +5.8%   19798960 ±  8%  perf-stat.ps.node-load-misses
  11593240 ±  4%     -27.9%    8355615 ±  9%      -7.4%   10737491 ± 13%  perf-stat.ps.node-loads
  27422418 ±  6%     -18.5%   22361316 ±  9%     +13.4%   31096559 ±  7%  perf-stat.ps.node-store-misses
  66049478 ±  5%     -30.0%   46241141 ±  8%      -7.4%   61146712 ±  4%  perf-stat.ps.node-stores
   2582518 ±  2%     -27.7%    1866009 ±  4%      -3.4%    2495504        perf-stat.ps.page-faults
     95521            -0.0%      95519            -0.0%      95521        perf-stat.ps.task-clock
 1.213e+13 ±  2%     -21.9%  9.469e+12 ±  3%      -2.5%  1.182e+13        perf-stat.total.instructions
     43625 ± 19%     +60.6%      70078 ±  9%     +11.3%      48552 ± 27%  numa-vmstat.node0.nr_active_anon
    219159 ± 10%      +3.3%     226404 ±  3%      +4.4%     228829 ±  4%  numa-vmstat.node0.nr_active_file
     62543 ±  8%     +16.2%      72664 ± 16%      -9.5%      56629 ±  5%  numa-vmstat.node0.nr_anon_pages
    100.00 ±  5%     +13.7%     113.67 ± 20%     -10.3%      89.67 ± 13%  numa-vmstat.node0.nr_anon_transparent_hugepages
  33438804 ± 68%      +3.2%   34506747 ± 67%     -93.9%    2045900 ± 42%  numa-vmstat.node0.nr_dirtied
      1.67 ±141%     +80.0%       3.00 ±118%    -100.0%       0.00        numa-vmstat.node0.nr_dirty
   5191398            +0.1%    5198729            +0.1%    5197458        numa-vmstat.node0.nr_file_pages
    138407 ±  2%      +1.6%     140634           +18.6%     164115 ±  9%  numa-vmstat.node0.nr_free_pages
    250153 ± 53%      +4.5%     261450 ± 45%     -76.1%      59888 ±  7%  numa-vmstat.node0.nr_inactive_anon
   4610563 ±  2%      -0.6%    4584446 ±  2%      +3.8%    4787384        numa-vmstat.node0.nr_inactive_file
      0.00          -100.0%       0.00          -100.0%       0.00        numa-vmstat.node0.nr_isolated_anon
    125.00 ±  4%     +17.6%     147.00 ±  9%     +23.7%     154.67 ± 12%  numa-vmstat.node0.nr_isolated_file
      9525 ±  2%      -2.8%       9255 ±  5%     -14.7%       8122 ±  4%  numa-vmstat.node0.nr_kernel_stack
   4987445            -0.0%    4985165            +0.5%    5013596        numa-vmstat.node0.nr_mapped
     76.00 ±  5%    +192.1%     222.00 ± 47%    +226.8%     248.33 ± 49%  numa-vmstat.node0.nr_mlock
     56329 ±  2%      -0.9%      55829 ±  2%      -8.5%      51528 ± 11%  numa-vmstat.node0.nr_page_table_pages
    231279 ± 60%     +12.0%     258933 ± 50%     -77.6%      51902 ± 26%  numa-vmstat.node0.nr_shmem
     51650 ±  3%      -5.7%      48680            -2.9%      50131        numa-vmstat.node0.nr_slab_reclaimable
     30509            -1.4%      30071 ±  8%     -11.1%      27107 ± 11%  numa-vmstat.node0.nr_slab_unreclaimable
    129669            -1.1%     128306            -0.8%     128681        numa-vmstat.node0.nr_unevictable
     31.33 ±130%     +12.8%      35.33 ± 64%     -91.5%       2.67 ± 17%  numa-vmstat.node0.nr_vmscan_immediate_reclaim
      0.00          -100.0%       0.00          -100.0%       0.00        numa-vmstat.node0.nr_writeback
  33438802 ± 68%      +3.2%   34506743 ± 67%     -93.9%    2045900 ± 42%  numa-vmstat.node0.nr_written
     43629 ± 19%     +60.6%      70082 ±  9%     +11.3%      48556 ± 27%  numa-vmstat.node0.nr_zone_active_anon
    219062 ± 10%      +3.3%     226249 ±  3%      +4.4%     228694 ±  4%  numa-vmstat.node0.nr_zone_active_file
    250182 ± 53%      +4.5%     261480 ± 45%     -76.0%      59919 ±  7%  numa-vmstat.node0.nr_zone_inactive_anon
   4610176 ±  2%      -0.6%    4584095 ±  2%      +3.8%    4787084        numa-vmstat.node0.nr_zone_inactive_file
    129669            -1.1%     128306            -0.8%     128681        numa-vmstat.node0.nr_zone_unevictable
      1.67 ±141%     +80.0%       3.00 ±118%    -100.0%       0.00        numa-vmstat.node0.nr_zone_write_pending
  30289403 ± 17%     -26.0%   22415296 ± 22%      +2.9%   31166745 ±  9%  numa-vmstat.node0.numa_foreign
 1.394e+08 ± 10%     -19.4%  1.124e+08 ± 19%     -31.1%   96106445 ±  6%  numa-vmstat.node0.numa_hit
    139905            +0.1%     139988            -0.0%     139889        numa-vmstat.node0.numa_interleave
 1.393e+08 ± 10%     -19.3%  1.124e+08 ± 19%     -31.1%   96023624 ±  6%  numa-vmstat.node0.numa_local
  25181301 ± 10%     -25.5%   18764436 ± 24%     +36.0%   34238111 ± 16%  numa-vmstat.node0.numa_miss
  25257943 ± 10%     -25.6%   18783711 ± 24%     +35.9%   34321089 ± 16%  numa-vmstat.node0.numa_other
    176633 ± 21%     -22.4%     137056 ±  6%     +16.5%     205726 ± 13%  numa-vmstat.node0.workingset_activate_file
    168137 ±  4%      -5.8%     158446            -4.2%     161103 ±  3%  numa-vmstat.node0.workingset_nodes
  16538515 ±  9%     -34.4%   10853930 ± 11%      +2.2%   16895852 ±  4%  numa-vmstat.node0.workingset_refault_file
      6492 ± 46%     -13.8%       5595 ± 14%    +102.3%      13134 ± 38%  numa-vmstat.node0.workingset_restore_file
    101207 ±  4%     -45.0%      55710 ±  3%     -19.0%      81931 ± 22%  numa-vmstat.node1.nr_active_anon
    239627 ±  3%      +0.4%     240616 ±  4%      -9.3%     217376 ±  2%  numa-vmstat.node1.nr_active_file
     44157 ±  2%     -16.1%      37038 ± 25%     +24.5%      54958 ± 15%  numa-vmstat.node1.nr_anon_pages
     68.67 ±  7%     -19.4%      55.33 ± 43%     +14.6%      78.67 ± 16%  numa-vmstat.node1.nr_anon_transparent_hugepages
  18990065 ±120%      -5.6%   17922123 ±129%    +165.3%   50382970        numa-vmstat.node1.nr_dirtied
      5.33 ± 57%     -62.5%       2.00 ±141%     -18.8%       4.33 ± 57%  numa-vmstat.node1.nr_dirty
   5379686            -0.2%    5366863            -0.3%    5361699        numa-vmstat.node1.nr_file_pages
      4240 ± 15%     -12.1%       3726           +10.9%       4704 ±  7%  numa-vmstat.node1.nr_free_cma
    146370            +1.6%     148686           -14.7%     124887 ±  8%  numa-vmstat.node1.nr_free_pages
    143278 ± 91%      -6.1%     134595 ± 90%    +136.3%     338638 ±  2%  numa-vmstat.node1.nr_inactive_anon
   4818099 ±  2%      +0.7%    4850042 ±  2%      -3.4%    4656235        numa-vmstat.node1.nr_inactive_file
      0.67 ±141%    -100.0%       0.00          -100.0%       0.00        numa-vmstat.node1.nr_isolated_anon
    129.00 ±  5%     +29.2%     166.67 ±  5%      +9.6%     141.33 ±  6%  numa-vmstat.node1.nr_isolated_file
      6873 ±  5%      +3.7%       7126 ±  5%     +22.6%       8427 ±  4%  numa-vmstat.node1.nr_kernel_stack
   5123259            +1.0%    5172122            +0.5%    5150260        numa-vmstat.node1.nr_mapped
     61.33 ±  4%    +250.5%     215.00 ± 53%    +201.1%     184.67 ± 50%  numa-vmstat.node1.nr_mlock
     42938 ±  2%      +0.1%      42978 ±  2%     +12.3%      48240 ± 11%  numa-vmstat.node1.nr_page_table_pages
    200360 ± 65%     -23.5%     153321 ± 86%     +82.5%     365642 ±  5%  numa-vmstat.node1.nr_shmem
     43011 ±  2%      +4.4%      44896            +3.6%      44571 ±  2%  numa-vmstat.node1.nr_slab_reclaimable
     21089 ±  3%      +3.6%      21855 ± 13%     +21.0%      25509 ± 12%  numa-vmstat.node1.nr_slab_unreclaimable
    120825            +1.2%     122231            +0.7%     121700        numa-vmstat.node1.nr_unevictable
     71.67 ± 62%     -56.3%      31.33 ±136%     +13.5%      81.33 ± 24%  numa-vmstat.node1.nr_vmscan_immediate_reclaim
      0.00          -100.0%       0.00          -100.0%       0.00        numa-vmstat.node1.nr_writeback
  18990060 ±120%      -5.6%   17922121 ±129%    +165.3%   50382965        numa-vmstat.node1.nr_written
    101212 ±  4%     -45.0%      55713 ±  3%     -19.0%      81935 ± 22%  numa-vmstat.node1.nr_zone_active_anon
    239504 ±  2%      +0.4%     240475 ±  4%      -9.3%     217328 ±  2%  numa-vmstat.node1.nr_zone_active_file
    143314 ± 91%      -6.1%     134628 ± 90%    +136.3%     338671 ±  2%  numa-vmstat.node1.nr_zone_inactive_anon
   4817828 ±  2%      +0.7%    4849859 ±  2%      -3.4%    4656086        numa-vmstat.node1.nr_zone_inactive_file
    120825            +1.2%     122231            +0.7%     121700        numa-vmstat.node1.nr_zone_unevictable
      5.00 ± 71%     -60.0%       2.00 ±141%     -13.3%       4.33 ± 57%  numa-vmstat.node1.nr_zone_write_pending
  25183355 ± 10%     -25.5%   18766785 ± 24%     +36.0%   34240646 ± 16%  numa-vmstat.node1.numa_foreign
 1.265e+08 ± 23%     -24.4%   95645441 ± 31%     +17.0%  1.481e+08 ±  2%  numa-vmstat.node1.numa_hit
    139985            -0.1%     139894            -0.1%     139847        numa-vmstat.node1.numa_interleave
 1.264e+08 ± 23%     -24.5%   95473968 ± 31%     +17.1%  1.479e+08 ±  2%  numa-vmstat.node1.numa_local
  30291122 ± 17%     -26.0%   22417710 ± 22%      +2.9%   31169202 ±  9%  numa-vmstat.node1.numa_miss
  30405026 ± 17%     -25.7%   22589299 ± 22%      +2.9%   31276582 ±  9%  numa-vmstat.node1.numa_other
    263132 ±  5%     -29.7%     184983 ±  2%     -29.1%     186545        numa-vmstat.node1.workingset_activate_file
    136992 ±  4%      +5.2%     144058            +4.5%     143212 ±  2%  numa-vmstat.node1.workingset_nodes
  19319023           -34.5%   12661014 ±  5%     -14.7%   16474573 ±  2%  numa-vmstat.node1.workingset_refault_file
     10002 ± 29%     -38.6%       6137 ± 24%     -19.2%       8080 ± 47%  numa-vmstat.node1.workingset_restore_file
    356986 ±  2%     -30.5%     248036 ±  3%      -4.0%     342586 ±  2%  proc-vmstat.allocstall_movable
      2875 ± 17%     -21.6%       2254 ±  8%      -5.6%       2713 ±  8%  proc-vmstat.allocstall_normal
   2052774 ± 29%     -51.9%     986935 ± 50%     -33.5%    1365578 ± 32%  proc-vmstat.compact_daemon_free_scanned
   1199355 ± 12%     -28.2%     861419 ± 20%     +21.3%    1454234 ± 35%  proc-vmstat.compact_daemon_migrate_scanned
      2013 ± 20%     -13.2%       1748 ±  6%     +12.6%       2267 ± 12%  proc-vmstat.compact_daemon_wake
    186.00 ± 21%      +4.3%     194.00 ± 10%     -31.4%     127.67 ± 26%  proc-vmstat.compact_fail
   2166008 ± 28%     -46.9%    1149814 ± 39%     -28.1%    1558440 ± 32%  proc-vmstat.compact_free_scanned
    226662 ±  4%     -43.4%     128279 ± 54%      -4.8%     215878 ± 16%  proc-vmstat.compact_isolated
   1200209 ± 12%     -28.1%     863088 ± 20%     +21.4%    1456590 ± 35%  proc-vmstat.compact_migrate_scanned
    189.67 ± 20%      +3.7%     196.67 ± 11%     -31.1%     130.67 ± 26%  proc-vmstat.compact_stall
      3.67 ± 25%     -27.3%       2.67 ± 17%     -18.2%       3.00 ± 54%  proc-vmstat.compact_success
     11.67 ± 31%     -40.0%       7.00 ± 30%     +20.0%      14.00 ± 67%  proc-vmstat.kswapd_high_wmark_hit_quickly
      6603 ±  5%     -22.9%       5091 ±  3%      -3.7%       6357 ±  5%  proc-vmstat.kswapd_low_wmark_hit_quickly
    144882 ±  4%     -13.1%     125923 ±  6%     -10.1%     130201 ±  4%  proc-vmstat.nr_active_anon
    458897 ±  5%      +2.1%     468725            -2.8%     445946 ±  3%  proc-vmstat.nr_active_file
    106708 ±  4%      +2.8%     109660 ±  2%      +4.6%     111584 ±  4%  proc-vmstat.nr_anon_pages
    169.67            -0.4%     169.00            -0.2%     169.33        proc-vmstat.nr_anon_transparent_hugepages
     57.33            +0.0%      57.33            +0.0%      57.33        proc-vmstat.nr_dirtied
      7.00 ± 11%     -23.8%       5.33 ± 46%     -33.3%       4.67 ± 61%  proc-vmstat.nr_dirty
   1008812            +0.2%    1010746            +0.1%    1009493        proc-vmstat.nr_dirty_background_threshold
   2020092            +0.2%    2023966            +0.1%    2021454        proc-vmstat.nr_dirty_threshold
  10570596            -0.0%   10567453            -0.1%   10562418        proc-vmstat.nr_file_pages
      4201 ± 15%     -10.7%       3753           +14.0%       4791 ±  9%  proc-vmstat.nr_free_cma
    284363            +0.8%     286767            +0.4%     285635        proc-vmstat.nr_free_pages
    393517            +0.7%     396184            +1.3%     398687        proc-vmstat.nr_inactive_anon
   9428031            +0.1%    9434308            +0.2%    9447327        proc-vmstat.nr_inactive_file
      0.00          -100.0%       0.00          -100.0%       0.00        proc-vmstat.nr_isolated_anon
    250.00           +24.9%     312.33 ±  4%     +18.3%     295.67 ±  7%  proc-vmstat.nr_isolated_file
     16394            -0.1%      16381            +1.0%      16554        proc-vmstat.nr_kernel_stack
  10116113            +0.3%   10141659            +0.5%   10167670        proc-vmstat.nr_mapped
    138.67 ±  3%    +214.9%     436.67 ± 48%    +212.5%     433.33 ± 49%  proc-vmstat.nr_mlock
     99468            -0.7%      98784            +0.3%      99794        proc-vmstat.nr_page_table_pages
    431764            -4.4%     412573 ±  2%      -3.3%     417418        proc-vmstat.nr_shmem
     94695            -1.0%      93721            -0.0%      94693        proc-vmstat.nr_slab_reclaimable
     51603            +0.6%      51929            +2.0%      52617        proc-vmstat.nr_slab_unreclaimable
    250494            +0.0%     250538            -0.0%     250382        proc-vmstat.nr_unevictable
    119.33 ±  6%     -35.2%      77.33 ± 29%     -18.2%      97.67 ± 23%  proc-vmstat.nr_vmscan_immediate_reclaim
      0.00          -100.0%       0.00          -100.0%       0.00        proc-vmstat.nr_writeback
     56.00            +0.6%      56.33            +0.6%      56.33        proc-vmstat.nr_written
    144890 ±  4%     -13.1%     125930 ±  6%     -10.1%     130207 ±  4%  proc-vmstat.nr_zone_active_anon
    458667 ±  5%      +2.1%     468467            -2.8%     445698 ±  3%  proc-vmstat.nr_zone_active_file
    393577            +0.7%     396249            +1.3%     398753        proc-vmstat.nr_zone_inactive_anon
   9427741            +0.1%    9433856            +0.2%    9447305        proc-vmstat.nr_zone_inactive_file
    250494            +0.0%     250538            -0.0%     250382        proc-vmstat.nr_zone_unevictable
      7.00 ± 11%     -23.8%       5.33 ± 46%     -33.3%       4.67 ± 61%  proc-vmstat.nr_zone_write_pending
 1.084e+08 ±  8%     -23.3%   83145561 ± 14%     +15.9%  1.256e+08 ± 11%  proc-vmstat.numa_foreign
     51139 ± 40%     -27.3%      37184 ± 38%     +13.5%      58053 ± 47%  proc-vmstat.numa_hint_faults
     23972 ± 36%     -39.3%      14550 ± 31%      +0.8%      24161 ± 40%  proc-vmstat.numa_hint_faults_local
 4.162e+08 ±  5%     -28.9%  2.957e+08 ±  9%      -8.7%  3.801e+08 ±  5%  proc-vmstat.numa_hit
      1605 ± 14%     -30.0%       1124 ± 14%     -21.9%       1254 ± 18%  proc-vmstat.numa_huge_pte_updates
      0.00          -100.0%       0.00          -100.0%       0.00        proc-vmstat.numa_interleave
 4.161e+08 ±  5%     -28.9%  2.957e+08 ±  9%      -8.7%    3.8e+08 ±  5%  proc-vmstat.numa_local
 1.084e+08 ±  8%     -23.3%   83145561 ± 14%     +15.9%  1.256e+08 ± 11%  proc-vmstat.numa_miss
 1.085e+08 ±  8%     -23.3%   83189591 ± 14%     +15.9%  1.257e+08 ± 11%  proc-vmstat.numa_other
     38930 ± 19%     -39.3%      23638 ± 15%     -13.3%      33767 ± 22%  proc-vmstat.numa_pages_migrated
    886156 ± 13%     -29.5%     624406 ± 16%     -19.4%     714093 ± 20%  proc-vmstat.numa_pte_updates
      6617 ±  5%     -22.9%       5101 ±  3%      -3.7%       6373 ±  5%  proc-vmstat.pageoutrun
   6812161 ±  3%     -25.8%    5057613            -6.0%    6405488 ±  5%  proc-vmstat.pgactivate
      0.00          -100.0%       0.00          -100.0%       0.00        proc-vmstat.pgalloc_dma
  19651994 ±  2%     -28.6%   14041272 ±  3%      -4.7%   18737401        proc-vmstat.pgalloc_dma32
 5.054e+08 ±  2%     -27.7%  3.653e+08 ±  4%      -3.3%  4.885e+08        proc-vmstat.pgalloc_normal
   7011545 ±  4%     -28.1%    5042341            -6.7%    6542693 ±  6%  proc-vmstat.pgdeactivate
 1.048e+09 ±  2%     -27.8%  7.568e+08 ±  4%      -3.4%  1.012e+09        proc-vmstat.pgfault
 5.148e+08 ±  2%     -28.3%   3.69e+08 ±  4%      -3.5%  4.968e+08        proc-vmstat.pgfree
 5.233e+08 ±  2%     -27.8%  3.778e+08 ±  4%      -3.4%  5.055e+08        proc-vmstat.pgmajfault
     66259 ± 75%     -68.9%      20636 ± 39%     -58.7%      27376 ± 53%  proc-vmstat.pgmigrate_fail
    147352 ±  2%     -42.0%      85440 ± 38%      -6.6%     137591 ± 17%  proc-vmstat.pgmigrate_success
 2.093e+09 ±  2%     -27.8%  1.511e+09 ±  4%      -3.4%  2.022e+09        proc-vmstat.pgpgin
    132.00 ±  8%      -6.1%     124.00            -6.1%     124.00        proc-vmstat.pgpgout
   7011545 ±  4%     -28.1%    5042343            -6.7%    6542700 ±  6%  proc-vmstat.pgrefill
     36650            -0.5%      36450            -0.8%      36351        proc-vmstat.pgreuse
    458.00 ± 10%     -54.9%     206.33 ± 13%     -34.0%     302.33 ± 22%  proc-vmstat.pgrotated
 8.877e+08 ±  3%     -30.2%  6.194e+08 ±  5%      -5.4%  8.394e+08 ±  2%  proc-vmstat.pgscan_direct
 1.037e+09 ±  2%     -28.2%  7.449e+08 ±  4%      -3.5%  1.001e+09        proc-vmstat.pgscan_file
 1.497e+08 ±  3%     -16.2%  1.255e+08 ±  4%      +8.1%  1.618e+08 ±  6%  proc-vmstat.pgscan_kswapd
 4.648e+08 ±  2%     -27.6%  3.366e+08 ±  3%      -2.9%  4.514e+08        proc-vmstat.pgsteal_direct
 5.134e+08 ±  2%     -28.4%  3.678e+08 ±  4%      -3.5%  4.956e+08        proc-vmstat.pgsteal_file
  48611615 ±  2%     -36.0%   31132152 ±  9%      -9.2%   44134337 ±  2%  proc-vmstat.pgsteal_kswapd
     75785 ±  2%      +0.1%      75864 ± 10%     -15.2%      64268 ± 13%  proc-vmstat.slabs_scanned
      0.67 ± 70%     -50.0%       0.33 ±141%      +0.0%       0.67 ± 70%  proc-vmstat.thp_collapse_alloc
      0.00       +3.3e+101%       0.33 ±141% +6.7e+101%       0.67 ± 70%  proc-vmstat.thp_collapse_alloc_failed
      0.00          -100.0%       0.00       +6.7e+101%       0.67 ±141%  proc-vmstat.thp_deferred_split_page
     60.33            +1.1%      61.00 ±  2%      +1.7%      61.33 ±  2%  proc-vmstat.thp_fault_alloc
      0.00          -100.0%       0.00       +6.7e+101%       0.67 ±141%  proc-vmstat.thp_split_pmd
      0.00          -100.0%       0.00          -100.0%       0.00        proc-vmstat.thp_zero_page_alloc
    100.33           -55.5%      44.67 ± 90%     -56.5%      43.67 ± 91%  proc-vmstat.unevictable_pgs_culled
    586.00           -66.7%     195.33 ±141%     -66.7%     195.33 ±141%  proc-vmstat.unevictable_pgs_mlocked
    440304 ±  9%     -26.8%     322290           -11.0%     391833 ±  6%  proc-vmstat.workingset_activate_file
    305338            -0.6%     303592            -0.2%     304734        proc-vmstat.workingset_nodes
  35897368 ±  4%     -34.4%   23532131 ±  8%      -7.1%   33334969        proc-vmstat.workingset_refault_file
     16525 ± 32%     -29.0%      11737 ±  5%     +28.2%      21186 ± 41%  proc-vmstat.workingset_restore_file
    130.25 ±110%     -79.0%      27.41 ±141%     -55.1%      58.46 ±141%  sched_debug.cfs_rq:/.MIN_vruntime.avg
      9442 ±103%     -73.6%       2494 ±141%     -65.3%       3273 ±141%  sched_debug.cfs_rq:/.MIN_vruntime.max
      0.00            +0.0%       0.00            +0.0%       0.00        sched_debug.cfs_rq:/.MIN_vruntime.min
      1099 ±107%     -76.4%     260.04 ±141%     -60.6%     433.53 ±141%  sched_debug.cfs_rq:/.MIN_vruntime.stddev
     35640 ± 19%     +29.5%      46156           +15.0%      40988 ± 18%  sched_debug.cfs_rq:/.exec_clock.avg
     60004 ± 20%     +36.8%      82102 ±  4%     +15.0%      69029 ± 15%  sched_debug.cfs_rq:/.exec_clock.max
     10509 ± 61%      -9.4%       9521 ± 25%     -12.6%       9181 ± 43%  sched_debug.cfs_rq:/.exec_clock.min
     11415 ± 20%     +41.3%      16134 ± 14%     +11.1%      12678 ± 14%  sched_debug.cfs_rq:/.exec_clock.stddev
    445507            +8.2%     481992 ±  4%      +4.7%     466232 ±  7%  sched_debug.cfs_rq:/.load.avg
    851108 ± 16%     +23.4%    1050048           +23.2%    1048576        sched_debug.cfs_rq:/.load.max
    361177 ±  6%     +11.8%     403965 ±  2%     +12.1%     404733 ±  4%  sched_debug.cfs_rq:/.load.stddev
    460.09            +3.9%     477.93 ±  4%      +1.6%     467.41 ±  7%  sched_debug.cfs_rq:/.load_avg.avg
      1131 ±  8%      -7.1%       1051 ±  5%      -5.8%       1066 ±  6%  sched_debug.cfs_rq:/.load_avg.max
    415.17 ±  6%      -0.2%     414.41            +1.6%     422.02 ±  4%  sched_debug.cfs_rq:/.load_avg.stddev
    130.25 ±110%     -79.0%      27.41 ±141%     -55.1%      58.46 ±141%  sched_debug.cfs_rq:/.max_vruntime.avg
      9442 ±103%     -73.6%       2494 ±141%     -65.3%       3273 ±141%  sched_debug.cfs_rq:/.max_vruntime.max
      0.00            +0.0%       0.00            +0.0%       0.00        sched_debug.cfs_rq:/.max_vruntime.min
      1099 ±107%     -76.4%     260.04 ±141%     -60.6%     433.53 ±141%  sched_debug.cfs_rq:/.max_vruntime.stddev
     67776 ± 14%     +16.0%      78590           +11.6%      75647 ± 13%  sched_debug.cfs_rq:/.min_vruntime.avg
    121925 ± 23%     +19.4%     145579 ± 16%      -6.8%     113645 ± 14%  sched_debug.cfs_rq:/.min_vruntime.max
     38249 ± 20%      +3.3%      39529 ± 11%      +3.8%      39684 ± 15%  sched_debug.cfs_rq:/.min_vruntime.min
     15708 ± 27%     +26.9%      19935 ± 19%      -2.7%      15280 ± 14%  sched_debug.cfs_rq:/.min_vruntime.stddev
      0.48 ±  3%      +4.4%       0.51 ±  4%      +3.6%       0.50 ±  5%  sched_debug.cfs_rq:/.nr_running.avg
      1.00            +8.3%       1.08 ± 10%      +0.0%       1.00        sched_debug.cfs_rq:/.nr_running.max
      0.45            +0.5%       0.45            +2.2%       0.46        sched_debug.cfs_rq:/.nr_running.stddev
      0.10 ±105%    +133.8%       0.23 ± 17%     +62.2%       0.16 ± 60%  sched_debug.cfs_rq:/.nr_spread_over.avg
      1.64 ± 26%     +32.2%       2.17 ± 27%      +8.5%       1.78 ± 21%  sched_debug.cfs_rq:/.nr_spread_over.max
      0.26 ± 46%     +48.8%       0.39 ± 17%      +4.3%       0.27 ± 29%  sched_debug.cfs_rq:/.nr_spread_over.stddev
     12.04 ± 69%     -77.9%       2.67 ± 82%     -31.6%       8.24 ± 88%  sched_debug.cfs_rq:/.removed.load_avg.avg
    312.89 ± 12%     -47.2%     165.33 ± 70%     -26.2%     231.03 ± 78%  sched_debug.cfs_rq:/.removed.load_avg.max
     55.69 ± 38%     -63.3%      20.43 ± 73%     -28.9%      39.58 ± 71%  sched_debug.cfs_rq:/.removed.load_avg.stddev
      4.66 ± 74%     -75.2%       1.15 ± 76%     -32.0%       3.16 ± 73%  sched_debug.cfs_rq:/.removed.runnable_avg.avg
    133.08 ± 22%     -37.3%      83.50 ± 70%      -8.5%     121.81 ± 92%  sched_debug.cfs_rq:/.removed.runnable_avg.max
     21.26 ± 47%     -56.6%       9.22 ± 71%     -17.6%      17.51 ± 76%  sched_debug.cfs_rq:/.removed.runnable_avg.stddev
      4.63 ± 74%     -75.1%       1.15 ± 76%     -31.7%       3.16 ± 73%  sched_debug.cfs_rq:/.removed.util_avg.avg
    131.64 ± 21%     -36.6%      83.50 ± 70%      -7.6%     121.69 ± 92%  sched_debug.cfs_rq:/.removed.util_avg.max
     21.14 ± 46%     -56.4%       9.22 ± 71%     -17.2%      17.50 ± 76%  sched_debug.cfs_rq:/.removed.util_avg.stddev
    559.67 ±  5%      -1.5%     551.27 ±  4%      +2.0%     570.88 ±  4%  sched_debug.cfs_rq:/.runnable_avg.avg
      1205 ±  6%      -0.3%       1201 ±  3%      -0.6%       1197 ±  4%  sched_debug.cfs_rq:/.runnable_avg.max
    450.27 ±  2%      +3.1%     464.36            +1.4%     456.41 ±  2%  sched_debug.cfs_rq:/.runnable_avg.stddev
    -16675          +198.1%     -49704          -173.3%      12227 ± 55%  sched_debug.cfs_rq:/.spread0.avg
     37499 ± 19%     -53.9%      17291 ±106%     +33.9%      50223 ± 27%  sched_debug.cfs_rq:/.spread0.max
    -46203           +92.1%     -88758           -48.6%     -23735        sched_debug.cfs_rq:/.spread0.min
     15711 ± 27%     +26.9%      19937 ± 19%      -2.7%      15280 ± 14%  sched_debug.cfs_rq:/.spread0.stddev
    556.76 ±  5%      -1.3%     549.62 ±  4%      +2.3%     569.73 ±  5%  sched_debug.cfs_rq:/.util_avg.avg
      1192 ±  6%      -0.1%       1190 ±  3%      -0.0%       1191 ±  5%  sched_debug.cfs_rq:/.util_avg.max
    448.11 ±  2%      +3.3%     463.11            +1.6%     455.40 ±  2%  sched_debug.cfs_rq:/.util_avg.stddev
    425.88            +7.7%     458.57 ±  4%      +3.3%     440.14 ±  6%  sched_debug.cfs_rq:/.util_est_enqueued.avg
    864.06 ±  2%     +12.2%     969.50 ±  5%      +1.8%     879.94 ±  3%  sched_debug.cfs_rq:/.util_est_enqueued.max
    370.13 ±  5%      +8.8%     402.70            +4.7%     387.50 ±  4%  sched_debug.cfs_rq:/.util_est_enqueued.stddev
    844186            -9.2%     766344 ±  3%      +1.6%     857345 ±  3%  sched_debug.cpu.avg_idle.avg
   1000000            +0.0%    1000000           +13.3%    1133287 ±  7%  sched_debug.cpu.avg_idle.max
    150262 ± 26%     -30.3%     104774 ± 22%     +11.5%     167572 ± 23%  sched_debug.cpu.avg_idle.min
    218705 ±  7%     +19.1%     260527            +3.3%     225850 ± 11%  sched_debug.cpu.avg_idle.stddev
    265382 ±  6%      +6.9%     283597            +2.5%     272057 ±  5%  sched_debug.cpu.clock.avg
    265395 ±  6%      +6.9%     283613            +2.5%     272068 ±  5%  sched_debug.cpu.clock.max
    265368 ±  6%      +6.9%     283576            +2.5%     272047 ±  5%  sched_debug.cpu.clock.min
      7.86 ± 40%     +32.2%      10.39 ± 50%      -9.1%       7.14 ± 42%  sched_debug.cpu.clock.stddev
    264275 ±  6%      +6.9%     282546            +2.5%     270910 ±  5%  sched_debug.cpu.clock_task.avg
    264516 ±  6%      +6.9%     282752            +2.5%     271142 ±  5%  sched_debug.cpu.clock_task.max
    259102 ±  6%      +7.1%     277511            +2.4%     265421 ±  5%  sched_debug.cpu.clock_task.min
    607.39 ±  6%      -1.7%     597.13 ±  2%      +2.3%     621.32        sched_debug.cpu.clock_task.stddev
      1144 ±  3%      +5.7%       1209 ±  2%      +2.0%       1167 ±  4%  sched_debug.cpu.curr->pid.avg
      4399 ±  8%     +10.2%       4846            +6.2%       4670 ±  7%  sched_debug.cpu.curr->pid.max
      1260            +2.5%       1290 ±  3%      +0.2%       1262 ±  2%  sched_debug.cpu.curr->pid.stddev
    500008            +0.0%     500196            +0.2%     501204        sched_debug.cpu.max_idle_balance_cost.avg
    500770            +3.3%     517520 ±  4%     +12.5%     563425 ±  7%  sched_debug.cpu.max_idle_balance_cost.max
    500000            +0.0%     500000            +0.0%     500000        sched_debug.cpu.max_idle_balance_cost.min
     78.20 ±141%   +2179.8%       1782 ±141%   +8670.1%       6858 ± 67%  sched_debug.cpu.max_idle_balance_cost.stddev
      4294            +0.0%       4294            +0.0%       4294        sched_debug.cpu.next_balance.avg
      4294            +0.0%       4294            +0.0%       4294        sched_debug.cpu.next_balance.max
      4294            +0.0%       4294            +0.0%       4294        sched_debug.cpu.next_balance.min
      0.00 ± 27%     +12.5%       0.00 ± 23%     -16.4%       0.00 ±  2%  sched_debug.cpu.next_balance.stddev
      0.42 ±  3%      +6.5%       0.44            +2.9%       0.43 ±  4%  sched_debug.cpu.nr_running.avg
      1.00           +16.7%       1.17 ± 20%      +0.0%       1.00        sched_debug.cpu.nr_running.max
      0.45            +2.1%       0.46 ±  2%      +0.2%       0.45        sched_debug.cpu.nr_running.stddev
     65936 ± 12%      -7.0%      61303 ± 19%     -18.7%      53596 ±  4%  sched_debug.cpu.nr_switches.avg
   3145363 ± 59%     -15.4%    2659603 ± 55%     -77.6%     703277 ± 36%  sched_debug.cpu.nr_switches.max
      3014 ± 27%      +8.9%       3281 ± 21%     +22.4%       3690 ±  5%  sched_debug.cpu.nr_switches.min
    336745 ± 50%     -11.2%     298976 ± 47%     -64.8%     118391 ± 20%  sched_debug.cpu.nr_switches.stddev
      0.01 ± 12%     -18.2%       0.01           -22.7%       0.00 ± 36%  sched_debug.cpu.nr_uninterruptible.avg
     42.22 ±  5%     +13.7%      48.00 ±  8%     -40.2%      25.25 ± 29%  sched_debug.cpu.nr_uninterruptible.max
    -15.97            -2.4%     -15.58           -14.8%     -13.61        sched_debug.cpu.nr_uninterruptible.min
      7.65 ±  8%      +8.2%       8.28 ± 10%      -7.0%       7.12        sched_debug.cpu.nr_uninterruptible.stddev
      5353 ± 17%     +15.1%       6160 ±  7%     +17.8%       6308 ± 13%  sched_debug.cpu.sched_count.avg
     12336            +4.0%      12828            -2.2%      12065 ± 18%  sched_debug.cpu.sched_count.max
      1989 ± 40%      +1.1%       2012 ± 20%     +24.1%       2469 ± 10%  sched_debug.cpu.sched_count.min
      1562 ± 10%     +27.1%       1986 ±  3%     +15.7%       1807 ± 17%  sched_debug.cpu.sched_count.stddev
    710.90 ± 17%     +23.9%     880.64 ±  2%      +9.7%     780.08 ± 15%  sched_debug.cpu.sched_goidle.avg
      3581           +35.0%       4834 ±  6%      +9.0%       3903 ± 19%  sched_debug.cpu.sched_goidle.max
    137.75 ± 29%     -15.9%     115.83 ± 19%     -19.9%     110.33 ± 14%  sched_debug.cpu.sched_goidle.min
    625.81 ± 10%     +47.4%     922.70 ±  9%     +20.0%     750.91 ± 16%  sched_debug.cpu.sched_goidle.stddev
      2613 ± 17%     +14.7%       2998 ±  8%     +18.0%       3083 ± 13%  sched_debug.cpu.ttwu_count.avg
      5031 ± 19%     +34.8%       6783 ± 13%     +19.2%       5998 ±  4%  sched_debug.cpu.ttwu_count.max
    884.53 ± 46%      +3.0%     911.00 ± 24%     +18.1%       1045 ± 23%  sched_debug.cpu.ttwu_count.min
    773.84 ± 12%     +37.1%       1060 ± 11%     +23.4%     954.55 ±  9%  sched_debug.cpu.ttwu_count.stddev
      1904 ± 20%     +18.2%       2251 ±  4%     +30.8%       2491 ± 17%  sched_debug.cpu.ttwu_local.avg
      3336 ± 16%     +40.7%       4694 ± 18%     +33.0%       4438 ± 20%  sched_debug.cpu.ttwu_local.max
    658.94 ± 49%      -5.9%     620.00 ± 19%     +22.0%     803.94 ± 28%  sched_debug.cpu.ttwu_local.min
    506.63 ± 17%     +38.0%     699.01 ± 13%     +38.3%     700.74 ± 15%  sched_debug.cpu.ttwu_local.stddev
    265370 ±  6%      +6.9%     283577            +2.5%     272048 ±  5%  sched_debug.cpu_clk
    996147            +0.0%     996147            +0.0%     996147        sched_debug.dl_rq:.dl_bw->bw.avg
    996147            +0.0%     996147            +0.0%     996147        sched_debug.dl_rq:.dl_bw->bw.max
    996147            +0.0%     996147            +0.0%     996147        sched_debug.dl_rq:.dl_bw->bw.min
 4.295e+09            +0.0%  4.295e+09            +0.0%  4.295e+09        sched_debug.jiffies
    264873 ±  6%      +6.9%     283081            +2.5%     271552 ±  5%  sched_debug.ktime
    950.00            +0.0%     950.00            +0.0%     950.00        sched_debug.rt_rq:/.rt_runtime.avg
    950.00            +0.0%     950.00            +0.0%     950.00        sched_debug.rt_rq:/.rt_runtime.max
    950.00            +0.0%     950.00            +0.0%     950.00        sched_debug.rt_rq:/.rt_runtime.min
    265722 ±  6%      +6.9%     283930            +2.5%     272402 ±  5%  sched_debug.sched_clk
      1.00            +0.0%       1.00            +0.0%       1.00        sched_debug.sched_clock_stable()
   4156219            +0.0%    4156219            +0.0%    4156219        sched_debug.sysctl_sched.sysctl_sched_features
     24.00            +0.0%      24.00            +0.0%      24.00        sched_debug.sysctl_sched.sysctl_sched_latency
      3.00            +0.0%       3.00            +0.0%       3.00        sched_debug.sysctl_sched.sysctl_sched_min_granularity
      1.00            +0.0%       1.00            +0.0%       1.00        sched_debug.sysctl_sched.sysctl_sched_tunable_scaling
      4.00            +0.0%       4.00            +0.0%       4.00        sched_debug.sysctl_sched.sysctl_sched_wakeup_granularity
      0.00          -100.0%       0.00       +6.7e+101%       0.67 ±141%  latency_stats.avg.d_alloc_parallel.__lookup_slow.walk_component.path_lookupat.filename_lookup.vfs_statx.__do_sys_newstat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00          -100.0%       0.00         +8e+102%       8.00 ±141%  latency_stats.avg.stop_two_cpus.migrate_swap.task_numa_migrate.task_numa_fault.do_huge_pmd_numa_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     54.67 ±141%    -100.0%       0.00          -100.0%       0.00        latency_stats.avg.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_lookup.nfs_lookup.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64
    121.67 ±141%    -100.0%       0.00          -100.0%       0.00        latency_stats.avg.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_do_create.nfs3_proc_create.nfs_create.path_openat.do_filp_open.do_sys_openat2.do_sys_open
      9.67 ±141%    -100.0%       0.00          -100.0%       0.00        latency_stats.avg.stop_one_cpu.sched_exec.bprm_execve.do_execveat_common.__x64_sys_execve.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.33 ±141%    -100.0%       0.00          -100.0%       0.00        latency_stats.avg.rwsem_down_write_slowpath.__x64_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.33 ±141%    -100.0%       0.00         +1700.0%       6.00 ±108%  latency_stats.avg.d_alloc_parallel.__lookup_slow.walk_component.path_lookupat.filename_lookup.do_faccessat.do_syscall_64.entry_SYSCALL_64_after_hwframe
    314.33 ±120%     -95.3%      14.67 ±141%     +12.3%     353.00 ±141%  latency_stats.avg.poll_schedule_timeout.do_sys_poll.__x64_sys_ppoll.do_syscall_64.entry_SYSCALL_64_after_hwframe
    356.33 ± 99%     -86.4%      48.33 ± 34%     -90.0%      35.67 ± 53%  latency_stats.avg.down.xfs_buf_lock.[xfs].xfs_buf_find.[xfs].xfs_buf_get_map.[xfs].xfs_buf_read_map.[xfs].xfs_trans_read_buf_map.[xfs].xfs_imap_to_bp.[xfs].xfs_trans_log_inode.[xfs].xfs_vn_update_time.[xfs].touch_atime.xfs_file_mmap.[xfs].mmap_region
      1122 ±  6%     -67.9%     360.67 ±141%     -68.6%     352.00 ±141%  latency_stats.avg.tty_wait_until_sent.tty_port_close_start.tty_port_close.tty_release.__fput.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
      2966           -67.2%     972.00 ±141%     -70.1%     886.67 ±141%  latency_stats.avg.msleep_interruptible.uart_wait_until_sent.tty_wait_until_sent.tty_port_close_start.tty_port_close.tty_release.__fput.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
      2.67 ±141%     -62.5%       1.00 ±141%     -62.5%       1.00 ±141%  latency_stats.avg.d_alloc_parallel.__lookup_slow.walk_component.link_path_walk.path_lookupat.filename_lookup.vfs_statx.__do_sys_newstat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.00 ±108%     -50.0%       1.00 ±141%     -16.7%       1.67 ± 74%  latency_stats.avg.d_alloc_parallel.__lookup_slow.walk_component.link_path_walk.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
    244.00 ± 42%     -37.3%     153.00            -6.1%     229.00 ± 44%  latency_stats.avg.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_lookup.nfs_lookup.__lookup_slow.walk_component.path_lookupat.filename_lookup.vfs_statx
    106.00 ± 40%     -26.4%      78.00 ± 54%     -54.1%      48.67 ±  2%  latency_stats.avg.hrtimer_nanosleep.__x64_sys_nanosleep.do_syscall_64.entry_SYSCALL_64_after_hwframe
    665.00 ± 15%      -9.4%     602.33 ± 10%      -8.7%     607.33 ±  4%  latency_stats.avg.futex_wait_queue_me.futex_wait.do_futex.__x64_sys_futex.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3019            -4.1%       2894 ±  7%      -5.6%       2850 ±  8%  latency_stats.avg.devkmsg_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3071            -3.7%       2956 ±  6%      -3.7%       2957 ±  8%  latency_stats.avg.do_syslog.kmsg_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
     35.33 ± 10%      -2.8%      34.33 ±  8%     -37.7%      22.00 ± 17%  latency_stats.avg.smp_call_on_cpu.lockup_detector_reconfigure.proc_watchdog_common.proc_sys_call_handler.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5.00 ± 90%      +0.0%       5.00 ± 74%     -80.0%       1.00 ±141%  latency_stats.avg.d_alloc_parallel.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
     13.00 ± 16%      +0.0%      13.00 ± 27%     +17.9%      15.33 ± 49%  latency_stats.avg.stop_one_cpu.__set_cpus_allowed_ptr.sched_setaffinity.__x64_sys_sched_setaffinity.do_syscall_64.entry_SYSCALL_64_after_hwframe
     11396 ±  3%      +0.2%      11422            +5.5%      12023 ±  2%  latency_stats.avg.msleep.cpuinfo_open.do_dentry_open.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1538 ±  6%      +0.7%       1550 ± 15%      -3.9%       1478 ±  7%  latency_stats.avg.pipe_wait.wait_for_partner.fifo_open.do_dentry_open.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1787 ± 24%      +2.7%       1836 ±  9%     -13.0%       1555 ± 14%  latency_stats.avg.poll_schedule_timeout.do_select.core_sys_select.kern_select.__x64_sys_select.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1561 ±  4%      +6.0%       1655 ±  2%      +4.5%       1631        latency_stats.avg.poll_schedule_timeout.do_sys_poll.__x64_sys_poll.do_syscall_64.entry_SYSCALL_64_after_hwframe
    107.00 ±  2%      +6.5%     114.00            +5.9%     113.33 ±  3%  latency_stats.avg.pipe_read.new_sync_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
    200.33 ± 13%     +11.1%     222.67 ±  3%     +18.3%     237.00 ±  7%  latency_stats.avg.wait_woken.__inet_stream_connect.inet_stream_connect.__sys_connect.__x64_sys_connect.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1140           +14.6%       1306 ±  3%      +6.2%       1210 ±  2%  latency_stats.avg.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
     18.67 ±141%     +19.6%      22.33 ±141%    +532.1%     118.00 ± 35%  latency_stats.avg.rwsem_down_write_slowpath.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
    884.67 ±  8%     +22.4%       1082 ± 28%     +14.1%       1009 ±  5%  latency_stats.avg.ep_poll.do_epoll_wait.__x64_sys_epoll_wait.do_syscall_64.entry_SYSCALL_64_after_hwframe
    184.67 ± 11%     +32.7%     245.00 ± 16%      -6.7%     172.33 ±  8%  latency_stats.avg.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_access.nfs_do_access.nfs_permission.inode_permission.link_path_walk.path_lookupat.filename_lookup
     16165 ± 39%     +55.7%      25174 ± 45%     +80.4%      29154 ± 73%  latency_stats.avg.max
      9126 ±124%     +77.9%      16235 ± 48%    +219.5%      29154 ± 73%  latency_stats.avg.lru_add_drain_all.generic_fadvise.ksys_fadvise64_64.__x64_sys_fadvise64.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5398 ± 85%    +291.0%      21108 ± 62%      +0.9%       5444 ± 20%  latency_stats.avg.pipe_write.new_sync_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
     55.00 ±141%    +695.2%     437.33 ± 47%    +267.3%     202.00 ± 89%  latency_stats.avg.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_lookup.nfs_lookup_revalidate_dentry.nfs_do_lookup_revalidate.__nfs_lookup_revalidate.lookup_fast.walk_component.link_path_walk
      0.00       +9.7e+102%       9.67 ±141% +2.1e+104%     214.67 ±  5%  latency_stats.avg.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.00       +2.5e+103%      25.00 ±141% +1.2e+104%     115.33 ± 43%  latency_stats.avg.do_exit.__x64_sys_exit.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00       +3.3e+103%      32.67 ±141%   +2e+104%     198.67 ± 69%  latency_stats.avg.do_madvise.__x64_sys_madvise.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  latency_stats.hits.stop_two_cpus.migrate_swap.task_numa_migrate.task_numa_fault.do_huge_pmd_numa_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.00          -100.0%       0.00       +6.7e+101%       0.67 ±141%  latency_stats.hits.d_alloc_parallel.__lookup_slow.walk_component.path_lookupat.filename_lookup.vfs_statx.__do_sys_newstat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.33 ±141%    -100.0%       0.00          -100.0%       0.00        latency_stats.hits.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_lookup.nfs_lookup.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64
      0.33 ±141%    -100.0%       0.00          -100.0%       0.00        latency_stats.hits.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_do_create.nfs3_proc_create.nfs_create.path_openat.do_filp_open.do_sys_openat2.do_sys_open
      0.33 ±141%    -100.0%       0.00          -100.0%       0.00        latency_stats.hits.rwsem_down_write_slowpath.__x64_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.33 ±141%    -100.0%       0.00          -100.0%       0.00        latency_stats.hits.stop_one_cpu.sched_exec.bprm_execve.do_execveat_common.__x64_sys_execve.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.33 ±141%    -100.0%       0.00          +100.0%       0.67 ± 70%  latency_stats.hits.d_alloc_parallel.__lookup_slow.walk_component.path_lookupat.filename_lookup.do_faccessat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5.67 ±106%     -94.1%       0.33 ±141%     -52.9%       2.67 ±115%  latency_stats.hits.d_alloc_parallel.__lookup_slow.walk_component.link_path_walk.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.33 ± 35%     -75.0%       0.33 ±141%     -50.0%       0.67 ±141%  latency_stats.hits.poll_schedule_timeout.do_sys_poll.__x64_sys_ppoll.do_syscall_64.entry_SYSCALL_64_after_hwframe
      9.00           -66.7%       3.00 ±141%     -66.7%       3.00 ±141%  latency_stats.hits.msleep_interruptible.uart_wait_until_sent.tty_wait_until_sent.tty_port_close_start.tty_port_close.tty_release.__fput.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
     38.67 ±  6%     -64.7%      13.67 ±141%     -64.7%      13.67 ±141%  latency_stats.hits.tty_wait_until_sent.tty_port_close_start.tty_port_close.tty_release.__fput.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
     31.00 ± 16%     -48.4%      16.00 ± 35%     -55.9%      13.67 ± 39%  latency_stats.hits.down.xfs_buf_lock.[xfs].xfs_buf_find.[xfs].xfs_buf_get_map.[xfs].xfs_buf_read_map.[xfs].xfs_trans_read_buf_map.[xfs].xfs_imap_to_bp.[xfs].xfs_trans_log_inode.[xfs].xfs_vn_update_time.[xfs].touch_atime.xfs_file_mmap.[xfs].mmap_region
      1464 ±  3%     -37.0%     921.67 ±  8%     -15.0%       1245 ±  7%  latency_stats.hits.poll_schedule_timeout.do_sys_poll.__x64_sys_poll.do_syscall_64.entry_SYSCALL_64_after_hwframe
    114.33 ±  3%     -23.6%      87.33 ± 32%     -18.7%      93.00 ± 26%  latency_stats.hits.ep_poll.do_epoll_wait.__x64_sys_epoll_wait.do_syscall_64.entry_SYSCALL_64_after_hwframe
    107.67 ± 32%     -22.6%      83.33 ±  5%      -4.3%     103.00 ± 24%  latency_stats.hits.poll_schedule_timeout.do_select.core_sys_select.kern_select.__x64_sys_select.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.67 ±101%     -20.0%       1.33 ± 93%     -60.0%       0.67 ±141%  latency_stats.hits.d_alloc_parallel.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5.33 ±  8%     -18.8%       4.33 ± 39%     -62.5%       2.00 ± 40%  latency_stats.hits.stop_one_cpu.__set_cpus_allowed_ptr.sched_setaffinity.__x64_sys_sched_setaffinity.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.00           -16.7%       1.67 ± 28%      +0.0%       2.00        latency_stats.hits.msleep.cpuinfo_open.do_dentry_open.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
      8.67 ± 57%      -7.7%       8.00 ± 54%     -34.6%       5.67 ± 16%  latency_stats.hits.pipe_write.new_sync_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3219            -5.7%       3034            -3.1%       3117        latency_stats.hits.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
     51.33 ±  7%      -4.5%      49.00            -3.9%      49.33 ±  6%  latency_stats.hits.lru_add_drain_all.generic_fadvise.ksys_fadvise64_64.__x64_sys_fadvise64.do_syscall_64.entry_SYSCALL_64_after_hwframe
     10.67 ±  4%      -3.1%      10.33 ±  4%      -6.2%      10.00        latency_stats.hits.hrtimer_nanosleep.__x64_sys_nanosleep.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.00            +0.0%       1.00            +0.0%       1.00        latency_stats.hits.pipe_wait.wait_for_partner.fifo_open.do_dentry_open.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
      9.00            +0.0%       9.00            +0.0%       9.00        latency_stats.hits.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_access.nfs_do_access.nfs_permission.inode_permission.link_path_walk.path_lookupat.filename_lookup
      1.00            +0.0%       1.00            +0.0%       1.00        latency_stats.hits.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_lookup.nfs_lookup.__lookup_slow.walk_component.path_lookupat.filename_lookup.vfs_statx
      1.00            +0.0%       1.00            +0.0%       1.00        latency_stats.hits.wait_woken.__inet_stream_connect.inet_stream_connect.__sys_connect.__x64_sys_connect.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.33 ±141%      +0.0%       0.33 ±141%      +0.0%       0.33 ±141%  latency_stats.hits.d_alloc_parallel.__lookup_slow.walk_component.link_path_walk.path_lookupat.filename_lookup.vfs_statx.__do_sys_newstat.do_syscall_64.entry_SYSCALL_64_after_hwframe
    189.00            +0.2%     189.33            +0.0%     189.00        latency_stats.hits.smp_call_on_cpu.lockup_detector_reconfigure.proc_watchdog_common.proc_sys_call_handler.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
     49755            +2.6%      51039            +1.9%      50701        latency_stats.hits.pipe_read.new_sync_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
     49755            +2.6%      51039            +1.9%      50701        latency_stats.hits.max
    284.00 ±  4%     +14.3%     324.67 ± 17%      +8.7%     308.67 ±  4%  latency_stats.hits.futex_wait_queue_me.futex_wait.do_futex.__x64_sys_futex.do_syscall_64.entry_SYSCALL_64_after_hwframe
     12.67 ±  9%     +34.2%      17.00 ± 25%     +39.5%      17.67 ± 14%  latency_stats.hits.do_syslog.kmsg_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
     13.00 ±  6%     +35.9%      17.67 ± 27%     +43.6%      18.67 ± 14%  latency_stats.hits.devkmsg_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.67 ±141%    +150.0%       1.67 ±141%    +700.0%       5.33 ± 17%  latency_stats.hits.rwsem_down_write_slowpath.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.33 ±141%    +500.0%       2.00 ± 40%    +100.0%       0.67 ± 70%  latency_stats.hits.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_lookup.nfs_lookup_revalidate_dentry.nfs_do_lookup_revalidate.__nfs_lookup_revalidate.lookup_fast.walk_component.link_path_walk
      0.00       +6.7e+101%       0.67 ±141%   +6e+102%       6.00 ± 54%  latency_stats.hits.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.00         +1e+102%       1.00 ±141% +9.3e+102%       9.33 ± 33%  latency_stats.hits.do_exit.__x64_sys_exit.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00         +1e+102%       1.00 ±141%   +1e+103%      10.00 ± 94%  latency_stats.hits.do_madvise.__x64_sys_madvise.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00          -100.0%       0.00         +1e+102%       1.00 ±141%  latency_stats.max.d_alloc_parallel.__lookup_slow.walk_component.path_lookupat.filename_lookup.vfs_statx.__do_sys_newstat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00          -100.0%       0.00         +8e+102%       8.00 ±141%  latency_stats.max.stop_two_cpus.migrate_swap.task_numa_migrate.task_numa_fault.do_huge_pmd_numa_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     54.67 ±141%    -100.0%       0.00          -100.0%       0.00        latency_stats.max.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_lookup.nfs_lookup.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64
    121.67 ±141%    -100.0%       0.00          -100.0%       0.00        latency_stats.max.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_do_create.nfs3_proc_create.nfs_create.path_openat.do_filp_open.do_sys_openat2.do_sys_open
      9.67 ±141%    -100.0%       0.00          -100.0%       0.00        latency_stats.max.stop_one_cpu.sched_exec.bprm_execve.do_execveat_common.__x64_sys_execve.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.33 ±141%    -100.0%       0.00          -100.0%       0.00        latency_stats.max.rwsem_down_write_slowpath.__x64_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.33 ±141%    -100.0%       0.00         +1700.0%       6.00 ±108%  latency_stats.max.d_alloc_parallel.__lookup_slow.walk_component.path_lookupat.filename_lookup.do_faccessat.do_syscall_64.entry_SYSCALL_64_after_hwframe
    584.67 ±130%     -97.5%      14.67 ±141%     +18.8%     694.33 ±141%  latency_stats.max.poll_schedule_timeout.do_sys_poll.__x64_sys_ppoll.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1587 ± 65%     -91.0%     142.33 ± 48%     -94.6%      86.33 ± 51%  latency_stats.max.down.xfs_buf_lock.[xfs].xfs_buf_find.[xfs].xfs_buf_get_map.[xfs].xfs_buf_read_map.[xfs].xfs_trans_read_buf_map.[xfs].xfs_imap_to_bp.[xfs].xfs_trans_log_inode.[xfs].xfs_vn_update_time.[xfs].touch_atime.xfs_file_mmap.[xfs].mmap_region
      3.33 ±101%     -70.0%       1.00 ±141%     -20.0%       2.67 ± 93%  latency_stats.max.d_alloc_parallel.__lookup_slow.walk_component.link_path_walk.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3750 ±  3%     -66.5%       1257 ±141%     -70.9%       1091 ±141%  latency_stats.max.msleep_interruptible.uart_wait_until_sent.tty_wait_until_sent.tty_port_close_start.tty_port_close.tty_release.__fput.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
      2.67 ±141%     -62.5%       1.00 ±141%     -62.5%       1.00 ±141%  latency_stats.max.d_alloc_parallel.__lookup_slow.walk_component.link_path_walk.path_lookupat.filename_lookup.vfs_statx.__do_sys_newstat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1360           -61.5%     523.33 ±141%     -66.9%     450.33 ±141%  latency_stats.max.tty_wait_until_sent.tty_port_close_start.tty_port_close.tty_release.__fput.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
    700.67 ± 65%     -46.4%     375.67 ±122%     -92.9%      50.00        latency_stats.max.hrtimer_nanosleep.__x64_sys_nanosleep.do_syscall_64.entry_SYSCALL_64_after_hwframe
    244.00 ± 42%     -37.3%     153.00            -6.1%     229.00 ± 44%  latency_stats.max.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_lookup.nfs_lookup.__lookup_slow.walk_component.path_lookupat.filename_lookup.vfs_statx
     14.00 ±121%     -33.3%       9.33 ± 99%     -90.5%       1.33 ±141%  latency_stats.max.d_alloc_parallel.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
     27.00 ±  8%     -17.3%      22.33 ± 14%     -25.9%      20.00 ± 57%  latency_stats.max.stop_one_cpu.__set_cpus_allowed_ptr.sched_setaffinity.__x64_sys_sched_setaffinity.do_syscall_64.entry_SYSCALL_64_after_hwframe
    119.33 ±  3%     -15.4%     101.00 ±  2%     -21.8%      93.33 ±  2%  latency_stats.max.smp_call_on_cpu.lockup_detector_reconfigure.proc_watchdog_common.proc_sys_call_handler.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
     11802 ±  5%      -1.1%      11673 ±  3%      +4.0%      12269 ±  3%  latency_stats.max.msleep.cpuinfo_open.do_dentry_open.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4987            -0.2%       4975            +0.1%       4994        latency_stats.max.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4981            +0.0%       4981            -0.1%       4975        latency_stats.max.poll_schedule_timeout.do_sys_poll.__x64_sys_poll.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4930            +0.0%       4931            -2.6%       4804 ±  3%  latency_stats.max.poll_schedule_timeout.do_select.core_sys_select.kern_select.__x64_sys_select.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4842            +0.7%       4875            +0.5%       4866 ±  2%  latency_stats.max.do_syslog.kmsg_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1538 ±  6%      +0.7%       1550 ± 15%      -3.9%       1478 ±  7%  latency_stats.max.pipe_wait.wait_for_partner.fifo_open.do_dentry_open.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4832            +0.9%       4877            +0.4%       4853 ±  2%  latency_stats.max.devkmsg_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4796 ±  2%      +2.2%       4904            +3.0%       4938        latency_stats.max.ep_poll.do_epoll_wait.__x64_sys_epoll_wait.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3018 ± 29%     +10.0%       3320 ± 26%     +16.3%       3509 ± 13%  latency_stats.max.futex_wait_queue_me.futex_wait.do_futex.__x64_sys_futex.do_syscall_64.entry_SYSCALL_64_after_hwframe
    200.33 ± 13%     +11.1%     222.67 ±  3%     +18.3%     237.00 ±  7%  latency_stats.max.wait_woken.__inet_stream_connect.inet_stream_connect.__sys_connect.__x64_sys_connect.do_syscall_64.entry_SYSCALL_64_after_hwframe
    160179 ±129%     +31.8%     211172 ± 63%     +60.9%     257737 ±131%  latency_stats.max.max
    151640 ±140%     +33.8%     202932 ± 71%     +70.0%     257737 ±131%  latency_stats.max.lru_add_drain_all.generic_fadvise.ksys_fadvise64_64.__x64_sys_fadvise64.do_syscall_64.entry_SYSCALL_64_after_hwframe
    262.33 ±  3%     +86.9%     490.33 ± 58%      +8.8%     285.33 ± 23%  latency_stats.max.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_access.nfs_do_access.nfs_permission.inode_permission.link_path_walk.path_lookupat.filename_lookup
     23.67 ±141%    +131.0%      54.67 ±141%   +1369.0%     347.67 ± 45%  latency_stats.max.rwsem_down_write_slowpath.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
     43989 ±108%    +131.6%     101864 ±107%     -79.0%       9220 ± 41%  latency_stats.max.pipe_read.new_sync_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
     18099 ± 89%    +195.5%      53485 ± 29%     -34.4%      11871 ± 38%  latency_stats.max.pipe_write.new_sync_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
     55.00 ±141%   +1337.0%     790.33 ± 83%    +267.3%     202.00 ± 89%  latency_stats.max.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_lookup.nfs_lookup_revalidate_dentry.nfs_do_lookup_revalidate.__nfs_lookup_revalidate.lookup_fast.walk_component.link_path_walk
      0.00       +1.7e+103%      16.67 ±141% +4.1e+104%     410.00 ± 37%  latency_stats.max.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.00         +5e+103%      50.33 ±141%   +3e+104%     300.33 ± 34%  latency_stats.max.do_madvise.__x64_sys_madvise.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00       +5.4e+103%      53.67 ±141% +2.4e+104%     241.67 ± 29%  latency_stats.max.do_exit.__x64_sys_exit.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00          -100.0%       0.00       +1.7e+102%       1.67 ±141%  latency_stats.sum.d_alloc_parallel.__lookup_slow.walk_component.path_lookupat.filename_lookup.vfs_statx.__do_sys_newstat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00          -100.0%       0.00         +8e+102%       8.00 ±141%  latency_stats.sum.stop_two_cpus.migrate_swap.task_numa_migrate.task_numa_fault.do_huge_pmd_numa_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     54.67 ±141%    -100.0%       0.00          -100.0%       0.00        latency_stats.sum.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_lookup.nfs_lookup.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64
    121.67 ±141%    -100.0%       0.00          -100.0%       0.00        latency_stats.sum.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_do_create.nfs3_proc_create.nfs_create.path_openat.do_filp_open.do_sys_openat2.do_sys_open
      9.67 ±141%    -100.0%       0.00          -100.0%       0.00        latency_stats.sum.stop_one_cpu.sched_exec.bprm_execve.do_execveat_common.__x64_sys_execve.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.33 ±141%    -100.0%       0.00          -100.0%       0.00        latency_stats.sum.rwsem_down_write_slowpath.__x64_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.33 ±141%    -100.0%       0.00         +1700.0%       6.00 ±108%  latency_stats.sum.d_alloc_parallel.__lookup_slow.walk_component.path_lookupat.filename_lookup.do_faccessat.do_syscall_64.entry_SYSCALL_64_after_hwframe
    597.67 ±130%     -97.5%      14.67 ±141%     +18.2%     706.33 ±141%  latency_stats.sum.poll_schedule_timeout.do_sys_poll.__x64_sys_ppoll.do_syscall_64.entry_SYSCALL_64_after_hwframe
     25.33 ±127%     -96.1%       1.00 ±141%     -61.8%       9.67 ±127%  latency_stats.sum.d_alloc_parallel.__lookup_slow.walk_component.link_path_walk.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
     12023 ±100%     -93.0%     841.67 ± 67%     -95.4%     548.33 ± 61%  latency_stats.sum.down.xfs_buf_lock.[xfs].xfs_buf_find.[xfs].xfs_buf_get_map.[xfs].xfs_buf_read_map.[xfs].xfs_trans_read_buf_map.[xfs].xfs_imap_to_bp.[xfs].xfs_trans_log_inode.[xfs].xfs_vn_update_time.[xfs].touch_atime.xfs_file_mmap.[xfs].mmap_region
     26701           -67.2%       8749 ±141%     -70.1%       7980 ±141%  latency_stats.sum.msleep_interruptible.uart_wait_until_sent.tty_wait_until_sent.tty_port_close_start.tty_port_close.tty_release.__fput.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
     43219           -65.8%      14800 ±141%     -66.6%      14439 ±141%  latency_stats.sum.tty_wait_until_sent.tty_port_close_start.tty_port_close.tty_release.__fput.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
      2.67 ±141%     -62.5%       1.00 ±141%     -62.5%       1.00 ±141%  latency_stats.sum.d_alloc_parallel.__lookup_slow.walk_component.link_path_walk.path_lookupat.filename_lookup.vfs_statx.__do_sys_newstat.do_syscall_64.entry_SYSCALL_64_after_hwframe
    244.00 ± 42%     -37.3%     153.00            -6.1%     229.00 ± 44%  latency_stats.sum.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_lookup.nfs_lookup.__lookup_slow.walk_component.path_lookupat.filename_lookup.vfs_statx
   2286234 ±  6%     -33.1%    1528413 ± 10%     -11.1%    2031545 ±  7%  latency_stats.sum.poll_schedule_timeout.do_sys_poll.__x64_sys_poll.do_syscall_64.entry_SYSCALL_64_after_hwframe
     16.67 ±124%     -32.0%      11.33 ±106%     -86.0%       2.33 ±141%  latency_stats.sum.d_alloc_parallel.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1155 ± 42%     -27.9%     832.67 ± 58%     -57.5%     491.67 ±  2%  latency_stats.sum.hrtimer_nanosleep.__x64_sys_nanosleep.do_syscall_64.entry_SYSCALL_64_after_hwframe
     22794 ±  3%     -16.2%      19111 ± 29%      +5.5%      24048 ±  2%  latency_stats.sum.msleep.cpuinfo_open.do_dentry_open.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
    177439 ±  3%     -13.7%     153212 ± 11%     -13.0%     154460 ± 10%  latency_stats.sum.poll_schedule_timeout.do_select.core_sys_select.kern_select.__x64_sys_select.do_syscall_64.entry_SYSCALL_64_after_hwframe
     72.00 ± 27%     -13.4%      62.33 ± 58%     -56.5%      31.33 ± 56%  latency_stats.sum.stop_one_cpu.__set_cpus_allowed_ptr.sched_setaffinity.__x64_sys_sched_setaffinity.do_syscall_64.entry_SYSCALL_64_after_hwframe
    101087 ±  8%     -11.6%      89382 ± 22%      -8.4%      92615 ± 20%  latency_stats.sum.ep_poll.do_epoll_wait.__x64_sys_epoll_wait.do_syscall_64.entry_SYSCALL_64_after_hwframe
      6793 ± 10%      -2.5%       6621 ±  8%     -36.7%       4303 ± 17%  latency_stats.sum.smp_call_on_cpu.lockup_detector_reconfigure.proc_watchdog_common.proc_sys_call_handler.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1538 ±  6%      +0.7%       1550 ± 15%      -3.9%       1478 ±  7%  latency_stats.sum.pipe_wait.wait_for_partner.fifo_open.do_dentry_open.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
    187755 ± 12%      +2.4%     192239 ±  8%      +0.1%     187887 ±  8%  latency_stats.sum.futex_wait_queue_me.futex_wait.do_futex.__x64_sys_futex.do_syscall_64.entry_SYSCALL_64_after_hwframe
   3671346            +8.0%    3964849 ±  3%      +2.9%    3776545        latency_stats.sum.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
   5356584            +9.0%    5839450            +7.7%    5768748 ±  3%  latency_stats.sum.pipe_read.new_sync_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
   5356584            +9.0%    5839450            +7.7%    5768748 ±  3%  latency_stats.sum.max
    200.33 ± 13%     +11.1%     222.67 ±  3%     +18.3%     237.00 ±  7%  latency_stats.sum.wait_woken.__inet_stream_connect.inet_stream_connect.__sys_connect.__x64_sys_connect.do_syscall_64.entry_SYSCALL_64_after_hwframe
     38879 ±  9%     +27.7%      49649 ± 21%     +35.1%      52519 ± 19%  latency_stats.sum.do_syslog.kmsg_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
     39288 ±  7%     +28.0%      50296 ± 22%     +36.2%      53512 ± 18%  latency_stats.sum.devkmsg_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1665 ± 12%     +32.8%       2211 ± 16%      -6.6%       1555 ±  9%  latency_stats.sum.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_access.nfs_do_access.nfs_permission.inode_permission.link_path_walk.path_lookupat.filename_lookup
    513961 ±126%     +55.3%     797989 ± 49%    +193.8%    1510268 ± 80%  latency_stats.sum.lru_add_drain_all.generic_fadvise.ksys_fadvise64_64.__x64_sys_fadvise64.do_syscall_64.entry_SYSCALL_64_after_hwframe
     43695 ±116%    +156.7%     112174 ± 26%     -28.0%      31446 ± 32%  latency_stats.sum.pipe_write.new_sync_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
     37.67 ±141%    +198.2%     112.33 ±141%   +1486.7%     597.67 ± 24%  latency_stats.sum.rwsem_down_write_slowpath.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
     55.00 ±141%   +1682.4%     980.33 ± 83%    +267.3%     202.00 ± 89%  latency_stats.sum.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_lookup.nfs_lookup_revalidate_dentry.nfs_do_lookup_revalidate.__nfs_lookup_revalidate.lookup_fast.walk_component.link_path_walk
      0.00         +2e+103%      19.67 ±141% +1.3e+105%       1317 ± 55%  latency_stats.sum.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.00       +7.5e+103%      75.00 ±141% +1.1e+105%       1066 ± 59%  latency_stats.sum.do_exit.__x64_sys_exit.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00       +9.8e+103%      98.33 ±141% +1.3e+105%       1259 ± 93%  latency_stats.sum.do_madvise.__x64_sys_madvise.do_syscall_64.entry_SYSCALL_64_after_hwframe
    194455            -0.1%     194317            -0.1%     194260        slabinfo.Acpi-Operand.active_objs
      3471            -0.1%       3469            -0.1%       3468        slabinfo.Acpi-Operand.active_slabs
    194455            -0.1%     194317            -0.1%     194260        slabinfo.Acpi-Operand.num_objs
      3471            -0.1%       3469            -0.1%       3468        slabinfo.Acpi-Operand.num_slabs
      1411 ±  9%      +1.7%       1435 ±  2%      +8.6%       1533 ±  3%  slabinfo.Acpi-Parse.active_objs
     19.33 ±  9%      +1.7%      19.67 ±  2%      +8.6%      21.00 ±  3%  slabinfo.Acpi-Parse.active_slabs
      1411 ±  9%      +1.7%       1435 ±  2%      +8.6%       1533 ±  3%  slabinfo.Acpi-Parse.num_objs
     19.33 ±  9%      +1.7%      19.67 ±  2%      +8.6%      21.00 ±  3%  slabinfo.Acpi-Parse.num_slabs
      4975            -0.1%       4968            +0.2%       4984        slabinfo.Acpi-State.active_objs
     97.00            +0.0%      97.00            +0.0%      97.00        slabinfo.Acpi-State.active_slabs
      4975            -0.1%       4968            +0.2%       4984        slabinfo.Acpi-State.num_objs
     97.00            +0.0%      97.00            +0.0%      97.00        slabinfo.Acpi-State.num_slabs
      1977 ±  3%      +8.4%       2142 ±  3%      +6.6%       2108 ±  7%  slabinfo.PING.active_objs
     61.67 ±  3%      +8.1%      66.67 ±  3%      +5.9%      65.33 ±  7%  slabinfo.PING.active_slabs
      1977 ±  3%      +8.4%       2142 ±  3%      +6.6%       2108 ±  7%  slabinfo.PING.num_objs
     61.67 ±  3%      +8.1%      66.67 ±  3%      +5.9%      65.33 ±  7%  slabinfo.PING.num_slabs
    192.00            +0.0%     192.00            +0.0%     192.00        slabinfo.RAW.active_objs
      6.00            +0.0%       6.00            +0.0%       6.00        slabinfo.RAW.active_slabs
    192.00            +0.0%     192.00            +0.0%     192.00        slabinfo.RAW.num_objs
      6.00            +0.0%       6.00            +0.0%       6.00        slabinfo.RAW.num_slabs
    112.67 ± 10%      +7.7%     121.33 ± 10%      +0.0%     112.67 ± 10%  slabinfo.RAWv6.active_objs
      4.33 ± 10%      +7.7%       4.67 ± 10%      +0.0%       4.33 ± 10%  slabinfo.RAWv6.active_slabs
    112.67 ± 10%      +7.7%     121.33 ± 10%      +0.0%     112.67 ± 10%  slabinfo.RAWv6.num_objs
      4.33 ± 10%      +7.7%       4.67 ± 10%      +0.0%       4.33 ± 10%  slabinfo.RAWv6.num_slabs
     79.33 ±  8%      +5.9%      84.00            +5.9%      84.00        slabinfo.TCP.active_objs
      5.67 ±  8%      +5.9%       6.00            +5.9%       6.00        slabinfo.TCP.active_slabs
     79.33 ±  8%      +5.9%      84.00            +5.9%      84.00        slabinfo.TCP.num_objs
      5.67 ±  8%      +5.9%       6.00            +5.9%       6.00        slabinfo.TCP.num_slabs
     52.00            +0.0%      52.00            +0.0%      52.00        slabinfo.TCPv6.active_objs
      4.00            +0.0%       4.00            +0.0%       4.00        slabinfo.TCPv6.active_slabs
     52.00            +0.0%      52.00            +0.0%      52.00        slabinfo.TCPv6.num_objs
      4.00            +0.0%       4.00            +0.0%       4.00        slabinfo.TCPv6.num_slabs
    218.67 ±  5%      -3.7%     210.67            -0.3%     218.00 ±  5%  slabinfo.UDPv6.active_objs
      8.33 ±  5%      -4.0%       8.00            +0.0%       8.33 ±  5%  slabinfo.UDPv6.active_slabs
    218.67 ±  5%      -3.7%     210.67            -0.3%     218.00 ±  5%  slabinfo.UDPv6.num_objs
      8.33 ±  5%      -4.0%       8.00            +0.0%       8.33 ±  5%  slabinfo.UDPv6.num_slabs
     24576 ±  2%      +2.3%      25145            +1.6%      24966        slabinfo.anon_vma.active_objs
    533.67 ±  2%      +2.3%     546.00            +1.6%     542.33        slabinfo.anon_vma.active_slabs
     24576 ±  2%      +2.3%      25145            +1.6%      24966        slabinfo.anon_vma.num_objs
    533.67 ±  2%      +2.3%     546.00            +1.6%     542.33        slabinfo.anon_vma.num_slabs
     52187 ±  4%      +4.0%      54299 ±  2%      +3.6%      54050        slabinfo.anon_vma_chain.active_objs
    815.00 ±  4%      +4.0%     848.00 ±  2%      +3.6%     844.00        slabinfo.anon_vma_chain.active_slabs
     52187 ±  4%      +4.0%      54299 ±  2%      +3.6%      54050        slabinfo.anon_vma_chain.num_objs
    815.00 ±  4%      +4.0%     848.00 ±  2%      +3.6%     844.00        slabinfo.anon_vma_chain.num_slabs
    455.00 ±  4%      +5.7%     481.00 ± 13%      +5.7%     481.00 ±  7%  slabinfo.bdev_cache.active_objs
     11.67 ±  4%      +5.7%      12.33 ± 13%      +5.7%      12.33 ±  7%  slabinfo.bdev_cache.active_slabs
    455.00 ±  4%      +5.7%     481.00 ± 13%      +5.7%     481.00 ±  7%  slabinfo.bdev_cache.num_objs
     11.67 ±  4%      +5.7%      12.33 ± 13%      +5.7%      12.33 ±  7%  slabinfo.bdev_cache.num_slabs
    294.00 ±  9%      -3.2%     284.67 ± 11%      +8.7%     319.67 ± 15%  slabinfo.biovec-128.active_objs
     17.67 ±  9%      -1.9%      17.33 ±  9%     +11.3%      19.67 ± 16%  slabinfo.biovec-128.active_slabs
    294.00 ±  9%      -3.2%     284.67 ± 11%      +8.7%     319.67 ± 15%  slabinfo.biovec-128.num_objs
     17.67 ±  9%      -1.9%      17.33 ±  9%     +11.3%      19.67 ± 16%  slabinfo.biovec-128.num_slabs
    213.33 ± 14%     +25.0%     266.67 ± 20%     +25.0%     266.67 ± 11%  slabinfo.biovec-64.active_objs
      6.67 ± 14%     +25.0%       8.33 ± 20%     +25.0%       8.33 ± 11%  slabinfo.biovec-64.active_slabs
    213.33 ± 14%     +25.0%     266.67 ± 20%     +25.0%     266.67 ± 11%  slabinfo.biovec-64.num_objs
      6.67 ± 14%     +25.0%       8.33 ± 20%     +25.0%       8.33 ± 11%  slabinfo.biovec-64.num_slabs
    554.67 ± 24%      -4.0%     532.67 ± 18%     +51.9%     842.67 ± 19%  slabinfo.biovec-max.active_objs
     71.33 ± 23%      -3.3%      69.00 ± 18%     +51.9%     108.33 ± 17%  slabinfo.biovec-max.active_slabs
    570.67 ± 23%      -3.3%     552.00 ± 18%     +51.9%     866.67 ± 17%  slabinfo.biovec-max.num_objs
     71.33 ± 23%      -3.3%      69.00 ± 18%     +51.9%     108.33 ± 17%  slabinfo.biovec-max.num_slabs
      2239 ±  2%      -2.9%       2175 ±  2%      -1.2%       2213        slabinfo.blkdev_ioc.active_objs
     57.00 ±  2%      +0.0%      57.00 ±  2%      +0.0%      57.00 ±  2%  slabinfo.blkdev_ioc.active_slabs
      2246 ±  2%      -0.4%       2237 ±  2%      -0.4%       2238 ±  2%  slabinfo.blkdev_ioc.num_objs
     57.00 ±  2%      +0.0%      57.00 ±  2%      +0.0%      57.00 ±  2%  slabinfo.blkdev_ioc.num_slabs
    108.00            -8.3%      99.00 ± 12%      +0.0%     108.00        slabinfo.btrfs_inode.active_objs
      4.00            -8.3%       3.67 ± 12%      +0.0%       4.00        slabinfo.btrfs_inode.active_slabs
    108.00            -8.3%      99.00 ± 12%      +0.0%     108.00        slabinfo.btrfs_inode.num_objs
      4.00            -8.3%       3.67 ± 12%      +0.0%       4.00        slabinfo.btrfs_inode.num_slabs
    299.00 ±  6%     +21.7%     364.00 ±  5%      -4.3%     286.00 ± 23%  slabinfo.buffer_head.active_objs
      7.67 ±  6%     +21.7%       9.33 ±  5%      -4.3%       7.33 ± 23%  slabinfo.buffer_head.active_slabs
    299.00 ±  6%     +21.7%     364.00 ±  5%      -4.3%     286.00 ± 23%  slabinfo.buffer_head.num_objs
      7.67 ±  6%     +21.7%       9.33 ±  5%      -4.3%       7.33 ± 23%  slabinfo.buffer_head.num_slabs
      5400            +0.0%       5403            +1.3%       5473        slabinfo.cred_jar.active_objs
    127.67            +0.0%     127.67            +1.3%     129.33        slabinfo.cred_jar.active_slabs
      5400            +0.0%       5403            +1.3%       5473        slabinfo.cred_jar.num_objs
    127.67            +0.0%     127.67            +1.3%     129.33        slabinfo.cred_jar.num_slabs
    112.00 ± 17%      +0.0%     112.00 ± 17%      +0.0%     112.00 ± 17%  slabinfo.dax_cache.active_objs
      2.67 ± 17%      +0.0%       2.67 ± 17%      +0.0%       2.67 ± 17%  slabinfo.dax_cache.active_slabs
    112.00 ± 17%      +0.0%     112.00 ± 17%      +0.0%     112.00 ± 17%  slabinfo.dax_cache.num_objs
      2.67 ± 17%      +0.0%       2.67 ± 17%      +0.0%       2.67 ± 17%  slabinfo.dax_cache.num_slabs
     99243            +3.2%     102415            +1.2%     100396        slabinfo.dentry.active_objs
      2375            +3.3%       2453            +1.2%       2404        slabinfo.dentry.active_slabs
     99771            +3.2%     102991            +1.2%     100983        slabinfo.dentry.num_objs
      2375            +3.3%       2453            +1.2%       2404        slabinfo.dentry.num_slabs
     30.00            +0.0%      30.00            +0.0%      30.00        slabinfo.dmaengine-unmap-128.active_objs
      1.00            +0.0%       1.00            +0.0%       1.00        slabinfo.dmaengine-unmap-128.active_slabs
     30.00            +0.0%      30.00            +0.0%      30.00        slabinfo.dmaengine-unmap-128.num_objs
      1.00            +0.0%       1.00            +0.0%       1.00        slabinfo.dmaengine-unmap-128.num_slabs
      4893 ±  6%      -6.8%       4561            -3.3%       4733 ±  9%  slabinfo.dmaengine-unmap-16.active_objs
    115.67 ±  6%      -6.3%     108.33            -2.9%     112.33 ±  9%  slabinfo.dmaengine-unmap-16.active_slabs
      4893 ±  6%      -6.8%       4561            -3.3%       4733 ±  9%  slabinfo.dmaengine-unmap-16.num_objs
    115.67 ±  6%      -6.3%     108.33            -2.9%     112.33 ±  9%  slabinfo.dmaengine-unmap-16.num_slabs
     15.00            +0.0%      15.00            +0.0%      15.00        slabinfo.dmaengine-unmap-256.active_objs
      1.00            +0.0%       1.00            +0.0%       1.00        slabinfo.dmaengine-unmap-256.active_slabs
     15.00            +0.0%      15.00            +0.0%      15.00        slabinfo.dmaengine-unmap-256.num_objs
      1.00            +0.0%       1.00            +0.0%       1.00        slabinfo.dmaengine-unmap-256.num_slabs
      4115 ± 12%      +5.1%       4324 ± 15%     +11.5%       4589 ±  8%  slabinfo.eventpoll_pwq.active_objs
     73.33 ± 13%      +5.0%      77.00 ± 15%     +11.4%      81.67 ±  8%  slabinfo.eventpoll_pwq.active_slabs
      4115 ± 12%      +5.1%       4324 ± 15%     +11.5%       4589 ±  8%  slabinfo.eventpoll_pwq.num_objs
     73.33 ± 13%      +5.0%      77.00 ± 15%     +11.4%      81.67 ±  8%  slabinfo.eventpoll_pwq.num_slabs
    954.67 ± 11%     +16.9%       1115 ±  8%     +19.4%       1140 ±  2%  slabinfo.file_lock_cache.active_objs
     25.33 ± 13%     +18.4%      30.00 ±  8%     +21.1%      30.67 ±  3%  slabinfo.file_lock_cache.active_slabs
    954.67 ± 11%     +16.9%       1115 ±  8%     +19.4%       1140 ±  2%  slabinfo.file_lock_cache.num_objs
     25.33 ± 13%     +18.4%      30.00 ±  8%     +21.1%      30.67 ±  3%  slabinfo.file_lock_cache.num_slabs
      4586            +1.4%       4649            +0.7%       4616        slabinfo.files_cache.active_objs
    100.00            +0.3%     100.33            +0.0%     100.00        slabinfo.files_cache.active_slabs
      4586            +1.4%       4649            +0.7%       4616        slabinfo.files_cache.num_objs
    100.00            +0.3%     100.33            +0.0%     100.00        slabinfo.files_cache.num_slabs
     32617 ±  2%      +3.8%      33851 ±  2%      +4.9%      34218        slabinfo.filp.active_objs
      1023 ±  2%      +3.9%       1063 ±  2%      +4.9%       1073        slabinfo.filp.active_slabs
     32759 ±  2%      +3.9%      34024 ±  2%      +4.9%      34357        slabinfo.filp.num_objs
      1023 ±  2%      +3.9%       1063 ±  2%      +4.9%       1073        slabinfo.filp.num_slabs
      2865 ±  7%      -4.0%       2750 ±  3%      +0.1%       2868 ± 12%  slabinfo.fsnotify_mark_connector.active_objs
     22.00 ±  7%      -3.0%      21.33 ±  2%      +1.5%      22.33 ± 12%  slabinfo.fsnotify_mark_connector.active_slabs
      2865 ±  7%      -4.0%       2750 ±  3%      +0.1%       2868 ± 12%  slabinfo.fsnotify_mark_connector.num_objs
     22.00 ±  7%      -3.0%      21.33 ±  2%      +1.5%      22.33 ± 12%  slabinfo.fsnotify_mark_connector.num_slabs
     32186            +0.0%      32186            -0.2%      32130        slabinfo.ftrace_event_field.active_objs
    378.67            +0.0%     378.67            -0.2%     378.00        slabinfo.ftrace_event_field.active_slabs
     32186            +0.0%      32186            -0.2%      32130        slabinfo.ftrace_event_field.num_objs
    378.67            +0.0%     378.67            -0.2%     378.00        slabinfo.ftrace_event_field.num_slabs
    104.00            +0.0%     104.00            +0.0%     104.00        slabinfo.hugetlbfs_inode_cache.active_objs
      2.00            +0.0%       2.00            +0.0%       2.00        slabinfo.hugetlbfs_inode_cache.active_slabs
    104.00            +0.0%     104.00            +0.0%     104.00        slabinfo.hugetlbfs_inode_cache.num_objs
      2.00            +0.0%       2.00            +0.0%       2.00        slabinfo.hugetlbfs_inode_cache.num_slabs
     54212            +3.3%      55977 ±  4%      +1.4%      54957        slabinfo.inode_cache.active_objs
      1017            +3.2%       1050 ±  4%      +1.2%       1029        slabinfo.inode_cache.active_slabs
     54928            +3.2%      56688 ±  4%      +1.3%      55636        slabinfo.inode_cache.num_objs
      1017            +3.2%       1050 ±  4%      +1.2%       1029        slabinfo.inode_cache.num_slabs
      2668 ± 18%      -5.7%       2516 ± 14%      +1.1%       2698 ± 16%  slabinfo.ip6-frags.active_objs
     60.00 ± 19%      -5.6%      56.67 ± 15%      +1.1%      60.67 ± 16%  slabinfo.ip6-frags.active_slabs
      2668 ± 18%      -5.7%       2516 ± 14%      +1.1%       2698 ± 16%  slabinfo.ip6-frags.num_objs
     60.00 ± 19%      -5.6%      56.67 ± 15%      +1.1%      60.67 ± 16%  slabinfo.ip6-frags.num_slabs
     83680            +0.0%      83698            +0.2%      83812        slabinfo.kernfs_node_cache.active_objs
      2614            +0.0%       2615            +0.2%       2619        slabinfo.kernfs_node_cache.active_slabs
     83680            +0.0%      83698            +0.2%      83812        slabinfo.kernfs_node_cache.num_objs
      2614            +0.0%       2615            +0.2%       2619        slabinfo.kernfs_node_cache.num_slabs
      1606 ±  2%      +6.7%       1714 ±  4%      +4.5%       1678 ±  2%  slabinfo.khugepaged_mm_slot.active_objs
     43.67 ±  2%      +6.9%      46.67 ±  4%      +4.6%      45.67 ±  2%  slabinfo.khugepaged_mm_slot.active_slabs
      1606 ±  2%      +6.7%       1714 ±  4%      +4.5%       1678 ±  2%  slabinfo.khugepaged_mm_slot.num_objs
     43.67 ±  2%      +6.9%      46.67 ±  4%      +4.6%      45.67 ±  2%  slabinfo.khugepaged_mm_slot.num_slabs
      5258            -1.4%       5184            -0.3%       5245        slabinfo.kmalloc-128.active_objs
    166.67            -1.8%     163.67            +0.4%     167.33        slabinfo.kmalloc-128.active_slabs
      5346            -1.9%       5244            +0.3%       5360        slabinfo.kmalloc-128.num_objs
    166.67            -1.8%     163.67            +0.4%     167.33        slabinfo.kmalloc-128.num_slabs
     35242            +0.1%      35295            +0.2%      35328        slabinfo.kmalloc-16.active_objs
    137.67            +0.5%     138.33            +0.2%     138.00        slabinfo.kmalloc-16.active_slabs
     35242            +0.5%      35413            +0.2%      35328        slabinfo.kmalloc-16.num_objs
    137.67            +0.5%     138.33            +0.2%     138.00        slabinfo.kmalloc-16.num_slabs
      5616            -0.1%       5613            +0.5%       5642        slabinfo.kmalloc-192.active_objs
    134.00            +0.7%     135.00            +0.0%     134.00        slabinfo.kmalloc-192.active_slabs
      5653            +0.7%       5694            +0.2%       5661        slabinfo.kmalloc-192.num_objs
    134.00            +0.7%     135.00            +0.0%     134.00        slabinfo.kmalloc-192.num_slabs
      5873            +0.3%       5888 ±  2%      +0.0%       5874 ±  2%  slabinfo.kmalloc-1k.active_objs
    187.00            -0.5%     186.00 ±  3%      -0.4%     186.33 ±  3%  slabinfo.kmalloc-1k.active_slabs
      5993            -0.3%       5975 ±  3%      -0.2%       5982 ±  3%  slabinfo.kmalloc-1k.num_objs
    187.00            -0.5%     186.00 ±  3%      -0.4%     186.33 ±  3%  slabinfo.kmalloc-1k.num_slabs
      7549            +4.5%       7885            +1.3%       7647        slabinfo.kmalloc-256.active_objs
    241.00            +4.0%     250.67            +2.6%     247.33        slabinfo.kmalloc-256.active_slabs
      7728            +4.1%       8043            +2.5%       7924        slabinfo.kmalloc-256.num_objs
    241.00            +4.0%     250.67            +2.6%     247.33        slabinfo.kmalloc-256.num_slabs
      9025 ±  3%      -0.1%       9012 ±  3%      +1.2%       9133 ±  3%  slabinfo.kmalloc-2k.active_objs
    567.67 ±  3%      +0.0%     567.67 ±  3%      +1.3%     575.00 ±  3%  slabinfo.kmalloc-2k.active_slabs
      9089 ±  3%      -0.0%       9087 ±  3%      +1.3%       9203 ±  3%  slabinfo.kmalloc-2k.num_objs
    567.67 ±  3%      +0.0%     567.67 ±  3%      +1.3%     575.00 ±  3%  slabinfo.kmalloc-2k.num_slabs
     72566            -2.3%      70882            -0.2%      72449        slabinfo.kmalloc-32.active_objs
    567.33            -2.4%     554.00            -0.2%     566.33        slabinfo.kmalloc-32.active_slabs
     72672            -2.3%      70995            -0.1%      72577        slabinfo.kmalloc-32.num_objs
    567.33            -2.4%     554.00            -0.2%     566.33        slabinfo.kmalloc-32.num_slabs
      1904            +0.4%       1911            +0.9%       1922        slabinfo.kmalloc-4k.active_objs
    244.33            -0.4%     243.33            +1.2%     247.33        slabinfo.kmalloc-4k.active_slabs
      1956            -0.2%       1951            +1.3%       1980        slabinfo.kmalloc-4k.num_objs
    244.33            -0.4%     243.33            +1.2%     247.33        slabinfo.kmalloc-4k.num_slabs
     32670            +1.1%      33025            +1.9%      33295        slabinfo.kmalloc-512.active_objs
      1086            +0.5%       1092            +2.3%       1111 ±  2%  slabinfo.kmalloc-512.active_slabs
     34785            +0.5%      34967            +2.3%      35581 ±  2%  slabinfo.kmalloc-512.num_objs
      1086            +0.5%       1092            +2.3%       1111 ±  2%  slabinfo.kmalloc-512.num_slabs
     48899            -0.0%      48895            -0.2%      48804        slabinfo.kmalloc-64.active_objs
    784.33            -0.4%     781.33            -0.1%     783.33        slabinfo.kmalloc-64.active_slabs
     50234            -0.4%      50036            -0.1%      50171        slabinfo.kmalloc-64.num_objs
    784.33            -0.4%     781.33            -0.1%     783.33        slabinfo.kmalloc-64.num_slabs
     54345            -0.0%      54341            +2.0%      55410        slabinfo.kmalloc-8.active_objs
    113.33            -1.2%     112.00 ±  2%      +5.3%     119.33 ±  4%  slabinfo.kmalloc-8.active_slabs
     58231            -1.1%      57601 ±  2%      +5.3%      61346 ±  4%  slabinfo.kmalloc-8.num_objs
    113.33            -1.2%     112.00 ±  2%      +5.3%     119.33 ±  4%  slabinfo.kmalloc-8.num_slabs
    794.00            -1.3%     783.33            -0.3%     791.67        slabinfo.kmalloc-8k.active_objs
    203.00            -1.3%     200.33            -0.2%     202.67        slabinfo.kmalloc-8k.active_slabs
    815.00            -1.4%     803.67            -0.3%     812.33        slabinfo.kmalloc-8k.num_objs
    203.00            -1.3%     200.33            -0.2%     202.67        slabinfo.kmalloc-8k.num_slabs
      9749 ±  5%      -0.7%       9684 ±  4%      -0.2%       9729 ±  4%  slabinfo.kmalloc-96.active_objs
    233.67 ±  5%      -1.0%     231.33 ±  4%      -0.6%     232.33 ±  4%  slabinfo.kmalloc-96.active_slabs
      9834 ±  5%      -1.0%       9732 ±  4%      -0.5%       9785 ±  4%  slabinfo.kmalloc-96.num_objs
    233.67 ±  5%      -1.0%     231.33 ±  4%      -0.6%     232.33 ±  4%  slabinfo.kmalloc-96.num_slabs
    810.67 ± 14%     -10.5%     725.33 ±  4%      +5.3%     853.33 ± 19%  slabinfo.kmalloc-rcl-128.active_objs
     25.33 ± 14%     -10.5%      22.67 ±  4%      +5.3%      26.67 ± 19%  slabinfo.kmalloc-rcl-128.active_slabs
    810.67 ± 14%     -10.5%     725.33 ±  4%      +5.3%     853.33 ± 19%  slabinfo.kmalloc-rcl-128.num_objs
     25.33 ± 14%     -10.5%      22.67 ±  4%      +5.3%      26.67 ± 19%  slabinfo.kmalloc-rcl-128.num_slabs
     42.00            +0.0%      42.00            +0.0%      42.00        slabinfo.kmalloc-rcl-192.active_objs
      1.00            +0.0%       1.00            +0.0%       1.00        slabinfo.kmalloc-rcl-192.active_slabs
     42.00            +0.0%      42.00            +0.0%      42.00        slabinfo.kmalloc-rcl-192.num_objs
      1.00            +0.0%       1.00            +0.0%       1.00        slabinfo.kmalloc-rcl-192.num_slabs
     64.00            +0.0%      64.00            +0.0%      64.00        slabinfo.kmalloc-rcl-256.active_objs
      2.00            +0.0%       2.00            +0.0%       2.00        slabinfo.kmalloc-rcl-256.active_slabs
     64.00            +0.0%      64.00            +0.0%      64.00        slabinfo.kmalloc-rcl-256.num_objs
      2.00            +0.0%       2.00            +0.0%       2.00        slabinfo.kmalloc-rcl-256.num_slabs
      1435 ±  6%     +15.8%       1662 ±  8%      +9.8%       1576 ±  7%  slabinfo.kmalloc-rcl-512.active_objs
     44.33 ±  6%     +16.5%      51.67 ±  7%     +10.5%      49.00 ±  8%  slabinfo.kmalloc-rcl-512.active_slabs
      1435 ±  6%     +15.8%       1662 ±  8%     +10.2%       1581 ±  8%  slabinfo.kmalloc-rcl-512.num_objs
     44.33 ±  6%     +16.5%      51.67 ±  7%     +10.5%      49.00 ±  8%  slabinfo.kmalloc-rcl-512.num_slabs
      4487            +6.0%       4754 ±  5%      +3.0%       4623        slabinfo.kmalloc-rcl-64.active_objs
     69.67            +6.2%      74.00 ±  4%      +2.9%      71.67        slabinfo.kmalloc-rcl-64.active_slabs
      4487            +6.0%       4754 ±  5%      +3.0%       4623        slabinfo.kmalloc-rcl-64.num_objs
     69.67            +6.2%      74.00 ±  4%      +2.9%      71.67        slabinfo.kmalloc-rcl-64.num_slabs
      2453 ±  4%      -3.4%       2369 ±  2%      -1.1%       2425 ±  6%  slabinfo.kmalloc-rcl-96.active_objs
     58.33 ±  4%      -3.4%      56.33 ±  2%      -1.1%      57.67 ±  6%  slabinfo.kmalloc-rcl-96.active_slabs
      2453 ±  4%      -3.4%       2369 ±  2%      -1.1%       2425 ±  6%  slabinfo.kmalloc-rcl-96.num_objs
     58.33 ±  4%      -3.4%      56.33 ±  2%      -1.1%      57.67 ±  6%  slabinfo.kmalloc-rcl-96.num_slabs
    437.33 ±  3%     +12.2%     490.67 ± 11%      -2.4%     426.67 ± 12%  slabinfo.kmem_cache.active_objs
     13.67 ±  3%     +12.2%      15.33 ± 11%      -2.4%      13.33 ± 12%  slabinfo.kmem_cache.active_slabs
    437.33 ±  3%     +12.2%     490.67 ± 11%      -2.4%     426.67 ± 12%  slabinfo.kmem_cache.num_objs
     13.67 ±  3%     +12.2%      15.33 ± 11%      -2.4%      13.33 ± 12%  slabinfo.kmem_cache.num_slabs
    968.67 ±  3%      +4.4%       1011 ± 10%      -4.4%     926.00 ±  9%  slabinfo.kmem_cache_node.active_objs
     15.67 ±  3%      +4.3%      16.33 ± 10%      -4.3%      15.00 ±  9%  slabinfo.kmem_cache_node.active_slabs
      1002 ±  3%      +4.3%       1045 ± 10%      -4.3%     960.00 ±  9%  slabinfo.kmem_cache_node.num_objs
     15.67 ±  3%      +4.3%      16.33 ± 10%      -4.3%      15.00 ±  9%  slabinfo.kmem_cache_node.num_slabs
     17560            -0.0%      17559            -0.6%      17447        slabinfo.lsm_file_cache.active_objs
    102.33            +0.0%     102.33            -0.7%     101.67        slabinfo.lsm_file_cache.active_slabs
     17560            -0.0%      17559            -0.6%      17447        slabinfo.lsm_file_cache.num_objs
    102.33            +0.0%     102.33            -0.7%     101.67        slabinfo.lsm_file_cache.num_slabs
      3133            -0.2%       3127            -0.2%       3127        slabinfo.mm_struct.active_objs
    103.67            -0.3%     103.33            -0.3%     103.33        slabinfo.mm_struct.active_slabs
      3133            -0.2%       3127            -0.2%       3127        slabinfo.mm_struct.num_objs
    103.67            -0.3%     103.33            -0.3%     103.33        slabinfo.mm_struct.num_slabs
      1071 ± 10%     -17.5%     884.00 ± 11%     -12.7%     935.00 ±  6%  slabinfo.mnt_cache.active_objs
     21.00 ± 10%     -17.5%      17.33 ± 11%     -12.7%      18.33 ±  6%  slabinfo.mnt_cache.active_slabs
      1071 ± 10%     -17.5%     884.00 ± 11%     -12.7%     935.00 ±  6%  slabinfo.mnt_cache.num_objs
     21.00 ± 10%     -17.5%      17.33 ± 11%     -12.7%      18.33 ±  6%  slabinfo.mnt_cache.num_slabs
     34.00            +0.0%      34.00            +0.0%      34.00        slabinfo.mqueue_inode_cache.active_objs
      1.00            +0.0%       1.00            +0.0%       1.00        slabinfo.mqueue_inode_cache.active_slabs
     34.00            +0.0%      34.00            +0.0%      34.00        slabinfo.mqueue_inode_cache.num_objs
      1.00            +0.0%       1.00            +0.0%       1.00        slabinfo.mqueue_inode_cache.num_slabs
    768.00            +0.0%     768.00            +0.0%     768.00        slabinfo.names_cache.active_objs
     96.00            +0.0%      96.00            +0.0%      96.00        slabinfo.names_cache.active_slabs
    768.00            +0.0%     768.00            +0.0%     768.00        slabinfo.names_cache.num_objs
     96.00            +0.0%      96.00            +0.0%      96.00        slabinfo.names_cache.num_slabs
    119.67           -16.4%     100.00 ± 28%      -8.1%     110.00 ± 12%  slabinfo.nfs_inode_cache.active_objs
      3.67 ± 12%      -9.1%       3.33 ± 28%      +0.0%       3.67 ± 12%  slabinfo.nfs_inode_cache.active_slabs
    119.67           -16.4%     100.00 ± 28%      -8.1%     110.00 ± 12%  slabinfo.nfs_inode_cache.num_objs
      3.67 ± 12%      -9.1%       3.33 ± 28%      +0.0%       3.67 ± 12%  slabinfo.nfs_inode_cache.num_slabs
    125.67 ±  7%      -0.3%     125.33 ± 10%      +8.2%     136.00 ± 12%  slabinfo.nfs_read_data.active_objs
      3.00            +0.0%       3.00           +11.1%       3.33 ± 14%  slabinfo.nfs_read_data.active_slabs
    125.67 ±  7%      -0.3%     125.33 ± 10%      +8.2%     136.00 ± 12%  slabinfo.nfs_read_data.num_objs
      3.00            +0.0%       3.00           +11.1%       3.33 ± 14%  slabinfo.nfs_read_data.num_slabs
      3204 ± 18%      -2.9%       3113 ± 15%      +2.9%       3297 ± 14%  slabinfo.numa_policy.active_objs
     51.33 ± 18%      -2.6%      50.00 ± 15%      +2.6%      52.67 ± 15%  slabinfo.numa_policy.active_slabs
      3204 ± 18%      -2.9%       3113 ± 15%      +2.9%       3297 ± 14%  slabinfo.numa_policy.num_objs
     51.33 ± 18%      -2.6%      50.00 ± 15%      +2.6%      52.67 ± 15%  slabinfo.numa_policy.num_slabs
      9378            +0.8%       9450            +1.4%       9505        slabinfo.pde_opener.active_objs
     91.33            +1.1%      92.33            +1.5%      92.67        slabinfo.pde_opener.active_slabs
      9378            +0.8%       9450            +1.4%       9505        slabinfo.pde_opener.num_objs
     91.33            +1.1%      92.33            +1.5%      92.67        slabinfo.pde_opener.num_slabs
      4415            +2.0%       4504            +0.9%       4454        slabinfo.pid.active_objs
    137.33            +1.9%     140.00            +1.0%     138.67        slabinfo.pid.active_slabs
      4415            +2.0%       4504            +0.9%       4454        slabinfo.pid.num_objs
    137.33            +1.9%     140.00            +1.0%     138.67        slabinfo.pid.num_slabs
     92.00 ± 27%     -19.6%      74.00 ± 34%     -39.1%      56.00        slabinfo.pid_namespace.active_objs
      1.00            +0.0%       1.00            +0.0%       1.00        slabinfo.pid_namespace.active_slabs
     92.00 ± 27%     -19.6%      74.00 ± 34%     -39.1%      56.00        slabinfo.pid_namespace.num_objs
      1.00            +0.0%       1.00            +0.0%       1.00        slabinfo.pid_namespace.num_slabs
      2989 ± 10%      -9.6%       2703 ± 15%     -16.7%       2489 ±  8%  slabinfo.pool_workqueue.active_objs
     93.33 ± 11%     -10.0%      84.00 ± 15%     -17.5%      77.00 ±  9%  slabinfo.pool_workqueue.active_slabs
      3008 ± 11%     -10.1%       2703 ± 15%     -17.2%       2490 ±  8%  slabinfo.pool_workqueue.num_objs
     93.33 ± 11%     -10.0%      84.00 ± 15%     -17.5%      77.00 ±  9%  slabinfo.pool_workqueue.num_slabs
      2912            +1.9%       2968            +1.9%       2968        slabinfo.proc_dir_entry.active_objs
     69.33            +1.9%      70.67            +1.9%      70.67        slabinfo.proc_dir_entry.active_slabs
      2912            +1.9%       2968            +1.9%       2968        slabinfo.proc_dir_entry.num_objs
     69.33            +1.9%      70.67            +1.9%      70.67        slabinfo.proc_dir_entry.num_slabs
     12479 ±  3%     -21.7%       9772 ±  4%     -15.8%      10506 ± 13%  slabinfo.proc_inode_cache.active_objs
    265.67 ±  3%     -19.9%     212.67 ±  5%     -15.6%     224.33 ± 13%  slabinfo.proc_inode_cache.active_slabs
     12738 ±  3%     -21.3%      10024 ±  3%     -15.5%      10767 ± 13%  slabinfo.proc_inode_cache.num_objs
    265.67 ±  3%     -19.9%     212.67 ±  5%     -15.6%     224.33 ± 13%  slabinfo.proc_inode_cache.num_slabs
    507751            -0.6%     504586            +0.1%     508356        slabinfo.radix_tree_node.active_objs
      9914            -1.5%       9769            +0.2%       9929        slabinfo.radix_tree_node.active_slabs
    551267            -1.4%     543647            +0.2%     552280        slabinfo.radix_tree_node.num_objs
      9914            -1.5%       9769            +0.2%       9929        slabinfo.radix_tree_node.num_slabs
     45.00            +0.0%      45.00            +0.0%      45.00 ± 27%  slabinfo.request_queue.active_objs
      3.00            +0.0%       3.00            +0.0%       3.00 ± 27%  slabinfo.request_queue.active_slabs
     45.00            +0.0%      45.00            +0.0%      45.00 ± 27%  slabinfo.request_queue.num_objs
      3.00            +0.0%       3.00            +0.0%       3.00 ± 27%  slabinfo.request_queue.num_slabs
    102.00            +0.0%     102.00            +0.0%     102.00        slabinfo.rpc_inode_cache.active_objs
      2.00            +0.0%       2.00            +0.0%       2.00        slabinfo.rpc_inode_cache.active_slabs
    102.00            +0.0%     102.00            +0.0%     102.00        slabinfo.rpc_inode_cache.num_objs
      2.00            +0.0%       2.00            +0.0%       2.00        slabinfo.rpc_inode_cache.num_slabs
    640.00            +0.0%     640.00            -1.7%     629.33 ±  2%  slabinfo.scsi_sense_cache.active_objs
     20.00            +0.0%      20.00            -1.7%      19.67 ±  2%  slabinfo.scsi_sense_cache.active_slabs
    640.00            +0.0%     640.00            -1.7%     629.33 ±  2%  slabinfo.scsi_sense_cache.num_objs
     20.00            +0.0%      20.00            -1.7%      19.67 ±  2%  slabinfo.scsi_sense_cache.num_slabs
      3264            +0.0%       3264            +0.0%       3264        slabinfo.seq_file.active_objs
     96.00            +0.0%      96.00            +0.0%      96.00        slabinfo.seq_file.active_slabs
      3264            +0.0%       3264            +0.0%       3264        slabinfo.seq_file.num_objs
     96.00            +0.0%      96.00            +0.0%      96.00        slabinfo.seq_file.num_slabs
      5384            +1.9%       5487 ±  3%      -0.4%       5364        slabinfo.shmem_inode_cache.active_objs
    116.33            +1.7%     118.33 ±  3%      -0.6%     115.67        slabinfo.shmem_inode_cache.active_slabs
      5384            +1.9%       5487 ±  3%      -0.4%       5364        slabinfo.shmem_inode_cache.num_objs
    116.33            +1.7%     118.33 ±  3%      -0.6%     115.67        slabinfo.shmem_inode_cache.num_slabs
      2345            +1.1%       2370            +2.0%       2392        slabinfo.sighand_cache.active_objs
    156.00            +0.9%     157.33            +1.9%     159.00        slabinfo.sighand_cache.active_slabs
      2345            +1.1%       2370            +2.0%       2393        slabinfo.sighand_cache.num_objs
    156.00            +0.9%     157.33            +1.9%     159.00        slabinfo.sighand_cache.num_slabs
      3755 ±  2%      +0.5%       3774            +1.8%       3821        slabinfo.signal_cache.active_objs
    133.67 ±  2%      +0.2%     134.00            +2.0%     136.33        slabinfo.signal_cache.active_slabs
      3755 ±  2%      +0.5%       3774            +2.2%       3837        slabinfo.signal_cache.num_objs
    133.67 ±  2%      +0.2%     134.00            +2.0%     136.33        slabinfo.signal_cache.num_slabs
    639.67 ±  8%      +1.5%     649.33 ± 13%      +7.5%     687.67 ±  8%  slabinfo.skbuff_fclone_cache.active_objs
     20.33 ± 10%      +0.0%      20.33 ± 12%      +4.9%      21.33 ±  9%  slabinfo.skbuff_fclone_cache.active_slabs
    639.67 ±  8%      +1.5%     649.33 ± 13%      +7.5%     687.67 ±  8%  slabinfo.skbuff_fclone_cache.num_objs
     20.33 ± 10%      +0.0%      20.33 ± 12%      +4.9%      21.33 ±  9%  slabinfo.skbuff_fclone_cache.num_slabs
      4021 ±  8%      -8.2%       3690 ±  2%      -1.8%       3950 ±  3%  slabinfo.skbuff_head_cache.active_objs
    125.67 ±  8%      -8.2%     115.33 ±  2%      -0.5%     125.00 ±  2%  slabinfo.skbuff_head_cache.active_slabs
      4021 ±  8%      -8.2%       3690 ±  2%      -0.4%       4004 ±  2%  slabinfo.skbuff_head_cache.num_objs
    125.67 ±  8%      -8.2%     115.33 ±  2%      -0.5%     125.00 ±  2%  slabinfo.skbuff_head_cache.num_slabs
      3165 ±  2%      +6.9%       3384            +4.6%       3310 ±  4%  slabinfo.sock_inode_cache.active_objs
     81.00 ±  2%      +6.6%      86.33            +4.1%      84.33 ±  4%  slabinfo.sock_inode_cache.active_slabs
      3165 ±  2%      +6.9%       3384            +4.6%       3310 ±  4%  slabinfo.sock_inode_cache.num_objs
     81.00 ±  2%      +6.6%      86.33            +4.1%      84.33 ±  4%  slabinfo.sock_inode_cache.num_slabs
      6085            +0.8%       6135            -0.7%       6043        slabinfo.task_delay_info.active_objs
    118.67            +0.8%     119.67            -0.6%     118.00        slabinfo.task_delay_info.active_slabs
      6085            +0.8%       6135            -0.7%       6043        slabinfo.task_delay_info.num_objs
    118.67            +0.8%     119.67            -0.6%     118.00        slabinfo.task_delay_info.num_slabs
      2225 ± 11%      +2.9%       2290 ±  9%      +4.1%       2317 ±  6%  slabinfo.task_group.active_objs
     52.33 ± 11%      +3.8%      54.33 ±  9%      +4.5%      54.67 ±  5%  slabinfo.task_group.active_slabs
      2225 ± 11%      +2.9%       2290 ±  9%      +4.1%       2317 ±  6%  slabinfo.task_group.num_objs
     52.33 ± 11%      +3.8%      54.33 ±  9%      +4.5%      54.67 ±  5%  slabinfo.task_group.num_slabs
      1278            +0.7%       1286            +1.4%       1295        slabinfo.task_struct.active_objs
      1285            +0.5%       1291            +1.3%       1301        slabinfo.task_struct.active_slabs
      1285            +0.5%       1291            +1.3%       1301        slabinfo.task_struct.num_objs
      1285            +0.5%       1291            +1.3%       1301        slabinfo.task_struct.num_slabs
    216.67 ± 25%     -17.8%     178.00           -18.2%     177.33        slabinfo.taskstats.active_objs
      4.00 ± 35%     -25.0%       3.00           -25.0%       3.00        slabinfo.taskstats.active_slabs
    216.67 ± 25%     -17.8%     178.00           -18.2%     177.33        slabinfo.taskstats.num_objs
      4.00 ± 35%     -25.0%       3.00           -25.0%       3.00        slabinfo.taskstats.num_slabs
      3187 ±  3%      -3.7%       3070 ±  2%      -0.3%       3177        slabinfo.trace_event_file.active_objs
     69.00 ±  3%      -3.4%      66.67 ±  2%      +0.0%      69.00        slabinfo.trace_event_file.active_slabs
      3187 ±  3%      -3.7%       3070 ±  2%      -0.3%       3177        slabinfo.trace_event_file.num_objs
     69.00 ±  3%      -3.4%      66.67 ±  2%      +0.0%      69.00        slabinfo.trace_event_file.num_slabs
     88.00 ± 17%     +12.5%      99.00           +12.5%      99.00        slabinfo.tw_sock_TCP.active_objs
      2.67 ± 17%     +12.5%       3.00           +12.5%       3.00        slabinfo.tw_sock_TCP.active_slabs
     88.00 ± 17%     +12.5%      99.00           +12.5%      99.00        slabinfo.tw_sock_TCP.num_objs
      2.67 ± 17%     +12.5%       3.00           +12.5%       3.00        slabinfo.tw_sock_TCP.num_slabs
     63425 ±  5%      +4.6%      66358 ±  2%      +5.3%      66811        slabinfo.vm_area_struct.active_objs
      1585 ±  5%      +4.8%       1661 ±  2%      +5.5%       1672        slabinfo.vm_area_struct.active_slabs
     63444 ±  5%      +4.8%      66477 ±  2%      +5.5%      66928        slabinfo.vm_area_struct.num_objs
      1585 ±  5%      +4.8%       1661 ±  2%      +5.5%       1672        slabinfo.vm_area_struct.num_slabs
     11832            +2.5%      12131            +2.1%      12083        slabinfo.vmap_area.active_objs
    184.33            +2.5%     189.00            +2.2%     188.33        slabinfo.vmap_area.active_slabs
     11834            +2.5%      12131            +2.1%      12085        slabinfo.vmap_area.num_objs
    184.33            +2.5%     189.00            +2.2%     188.33        slabinfo.vmap_area.num_slabs
    504.00 ± 70%     -11.9%     444.00 ± 55%     +95.2%     984.00 ± 19%  slabinfo.xfs_btree_cur.active_objs
     14.00 ± 70%     -11.9%      12.33 ± 55%     +95.2%      27.33 ± 19%  slabinfo.xfs_btree_cur.active_slabs
    504.00 ± 70%     -11.9%     444.00 ± 55%     +95.2%     984.00 ± 19%  slabinfo.xfs_btree_cur.num_objs
     14.00 ± 70%     -11.9%      12.33 ± 55%     +95.2%      27.33 ± 19%  slabinfo.xfs_btree_cur.num_slabs
    378.00 ± 41%     -22.2%     294.00 ± 23%      +7.4%     406.00 ± 12%  slabinfo.xfs_buf.active_objs
      9.00 ± 41%     -22.2%       7.00 ± 23%      +7.4%       9.67 ± 12%  slabinfo.xfs_buf.active_slabs
    378.00 ± 41%     -22.2%     294.00 ± 23%      +7.4%     406.00 ± 12%  slabinfo.xfs_buf.num_objs
      9.00 ± 41%     -22.2%       7.00 ± 23%      +7.4%       9.67 ± 12%  slabinfo.xfs_buf.num_slabs
    504.00 ± 76%     -13.9%     434.00 ± 66%    +116.7%       1092 ± 20%  slabinfo.xfs_ili.active_objs
     12.00 ± 76%     -13.9%      10.33 ± 66%    +116.7%      26.00 ± 20%  slabinfo.xfs_ili.active_slabs
    504.00 ± 76%     -13.9%     434.00 ± 66%    +116.7%       1092 ± 20%  slabinfo.xfs_ili.num_objs
     12.00 ± 76%     -13.9%      10.33 ± 66%    +116.7%      26.00 ± 20%  slabinfo.xfs_ili.num_slabs
    437.33 ± 63%      -9.8%     394.67 ± 55%    +100.0%     874.67 ± 19%  slabinfo.xfs_inode.active_objs
     13.67 ± 63%      -9.8%      12.33 ± 55%    +100.0%      27.33 ± 19%  slabinfo.xfs_inode.active_slabs
    437.33 ± 63%      -9.8%     394.67 ± 55%    +100.0%     874.67 ± 19%  slabinfo.xfs_inode.num_objs
     13.67 ± 63%      -9.8%      12.33 ± 55%    +100.0%      27.33 ± 19%  slabinfo.xfs_inode.num_slabs
      6.69 ±  8%      -6.7        0.00            -6.7        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__pagevec_lru_add.lru_cache_add.add_to_page_cache_lru.pagecache_get_page
      6.65 ±  8%      -6.6        0.00            -6.6        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__pagevec_lru_add.lru_cache_add.add_to_page_cache_lru
     15.82 ±  5%      -5.5       10.29 ±  3%      -8.1        7.68 ±  5%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irq.lru_note_cost.shrink_inactive_list.shrink_lruvec.shrink_node
     15.75 ±  5%      -5.5       10.24 ±  3%      -8.1        7.63 ±  5%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irq.lru_note_cost.shrink_inactive_list.shrink_lruvec
     15.23 ±  6%      -4.9       10.37 ±  3%      -7.5        7.77 ±  5%  perf-profile.calltrace.cycles-pp.lru_note_cost.shrink_inactive_list.shrink_lruvec.shrink_node.do_try_to_free_pages
      8.12            -3.4        4.76 ±  3%      -1.1        7.01 ±  7%  perf-profile.calltrace.cycles-pp.iomap_readpage.filemap_fault.__xfs_filemap_fault.__do_fault.do_fault
      6.94 ±  2%      -2.9        4.02 ±  4%      -1.0        5.97 ±  7%  perf-profile.calltrace.cycles-pp.submit_bio_noacct.submit_bio.iomap_readpage.filemap_fault.__xfs_filemap_fault
      6.96 ±  2%      -2.9        4.04 ±  4%      -1.0        5.99 ±  7%  perf-profile.calltrace.cycles-pp.submit_bio.iomap_readpage.filemap_fault.__xfs_filemap_fault.__do_fault
      6.54 ±  2%      -2.8        3.69 ±  4%      -0.9        5.60 ±  7%  perf-profile.calltrace.cycles-pp.pmem_submit_bio.submit_bio_noacct.submit_bio.iomap_readpage.filemap_fault
      5.90 ±  2%      -2.6        3.29 ±  4%      -0.9        5.04 ±  7%  perf-profile.calltrace.cycles-pp.pmem_do_read.pmem_submit_bio.submit_bio_noacct.submit_bio.iomap_readpage
      5.83 ±  2%      -2.6        3.23 ±  4%      -0.9        4.98 ±  7%  perf-profile.calltrace.cycles-pp.__memcpy_mcsafe.pmem_do_read.pmem_submit_bio.submit_bio_noacct.submit_bio
      4.91            -1.7        3.22 ±  3%      -0.4        4.50 ±  4%  perf-profile.calltrace.cycles-pp.xfs_filemap_map_pages.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      4.63 ±  2%      -1.6        3.02 ±  3%      -0.4        4.23 ±  4%  perf-profile.calltrace.cycles-pp.filemap_map_pages.xfs_filemap_map_pages.do_fault.__handle_mm_fault.handle_mm_fault
      1.35 ± 52%      -1.4        0.00            -1.4        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.pagevec_lru_move_fn.deactivate_file_page.invalidate_mapping_pages.generic_fadvise
      1.34 ± 52%      -1.3        0.00            -1.3        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.pagevec_lru_move_fn.deactivate_file_page.invalidate_mapping_pages
      2.24 ±  3%      -1.0        1.28 ± 22%      -0.4        1.82 ±  6%  perf-profile.calltrace.cycles-pp.__add_to_page_cache_locked.add_to_page_cache_lru.pagecache_get_page.filemap_fault.__xfs_filemap_fault
      0.90 ± 11%      -0.9        0.00            -0.3        0.64 ±  6%  perf-profile.calltrace.cycles-pp.rmqueue.get_page_from_freelist.__alloc_pages_nodemask.pagecache_get_page.filemap_fault
      1.22 ±  8%      -0.9        0.37 ± 70%      -0.3        0.88 ±  5%  perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_pages_nodemask.pagecache_get_page.filemap_fault.__xfs_filemap_fault
      0.77 ±  4%      -0.8        0.00            -0.8        0.00        perf-profile.calltrace.cycles-pp.lru_note_cost.shrink_inactive_list.shrink_lruvec.shrink_node.balance_pgdat
      0.70 ±  4%      -0.7        0.00            -0.1        0.60 ±  2%  perf-profile.calltrace.cycles-pp.page_add_file_rmap.alloc_set_pte.filemap_map_pages.xfs_filemap_map_pages.do_fault
      1.14 ±  9%      -0.7        0.44 ± 70%      -0.2        0.89 ± 13%  perf-profile.calltrace.cycles-pp.mem_cgroup_charge.__add_to_page_cache_locked.add_to_page_cache_lru.pagecache_get_page.filemap_fault
      0.62 ± 11%      -0.6        0.00            -0.6        0.00        perf-profile.calltrace.cycles-pp.rmqueue_bulk.rmqueue.get_page_from_freelist.__alloc_pages_nodemask.pagecache_get_page
      0.58 ±  2%      -0.6        0.00            -0.0        0.56 ±  4%  perf-profile.calltrace.cycles-pp.unlock_page.filemap_map_pages.xfs_filemap_map_pages.do_fault.__handle_mm_fault
      0.75 ±  3%      -0.6        0.17 ±141%      -0.1        0.69 ±  4%  perf-profile.calltrace.cycles-pp.page_referenced_one.rmap_walk_file.page_referenced.shrink_page_list.shrink_inactive_list
      8.09 ±  4%      -0.6        7.51            +0.7        8.76 ±  7%  perf-profile.calltrace.cycles-pp.shrink_page_list.shrink_inactive_list.shrink_lruvec.shrink_node.do_try_to_free_pages
      2.99 ±  6%      -0.5        2.48 ±  9%      -0.1        2.88 ± 14%  perf-profile.calltrace.cycles-pp.shrink_node.balance_pgdat.kswapd.kthread.ret_from_fork
      2.99 ±  6%      -0.5        2.48 ±  9%      -0.1        2.88 ± 14%  perf-profile.calltrace.cycles-pp.kswapd.kthread.ret_from_fork
      2.99 ±  6%      -0.5        2.48 ±  9%      -0.1        2.88 ± 14%  perf-profile.calltrace.cycles-pp.balance_pgdat.kswapd.kthread.ret_from_fork
      0.51            -0.5        0.00            -0.3        0.17 ±141%  perf-profile.calltrace.cycles-pp.iomap_readpage_actor.iomap_apply.iomap_readpage.filemap_fault.__xfs_filemap_fault
      3.16 ±  4%      -0.5        2.66 ±  9%      -0.1        3.05 ± 13%  perf-profile.calltrace.cycles-pp.ret_from_fork
      3.16 ±  4%      -0.5        2.66 ±  9%      -0.1        3.05 ± 13%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork
      2.96 ±  6%      -0.5        2.46 ±  9%      -0.1        2.85 ± 14%  perf-profile.calltrace.cycles-pp.shrink_inactive_list.shrink_lruvec.shrink_node.balance_pgdat.kswapd
      2.98 ±  6%      -0.5        2.48 ±  9%      -0.1        2.87 ± 14%  perf-profile.calltrace.cycles-pp.shrink_lruvec.shrink_node.balance_pgdat.kswapd.kthread
      2.09 ±  9%      -0.5        1.61 ±  5%      +0.2        2.26 ± 12%  perf-profile.calltrace.cycles-pp.__remove_mapping.shrink_page_list.shrink_inactive_list.shrink_lruvec.shrink_node
      1.05 ±  2%      -0.5        0.59 ± 14%      -0.1        0.92 ±  2%  perf-profile.calltrace.cycles-pp.alloc_set_pte.filemap_map_pages.xfs_filemap_map_pages.do_fault.__handle_mm_fault
      1.32 ±  2%      -0.4        0.87 ±  2%      -0.1        1.23 ±  4%  perf-profile.calltrace.cycles-pp.page_referenced.shrink_page_list.shrink_inactive_list.shrink_lruvec.shrink_node
      1.13 ±  5%      -0.4        0.70 ±  3%      -0.1        1.00 ±  4%  perf-profile.calltrace.cycles-pp.iomap_apply.iomap_readpage.filemap_fault.__xfs_filemap_fault.__do_fault
      1.16 ±  2%      -0.4        0.77 ±  2%      -0.1        1.08 ±  3%  perf-profile.calltrace.cycles-pp.rmap_walk_file.page_referenced.shrink_page_list.shrink_inactive_list.shrink_lruvec
      0.56 ±  3%      -0.4        0.17 ±141%      +0.0        0.59 ±  6%  perf-profile.calltrace.cycles-pp.__delete_from_page_cache.__remove_mapping.shrink_page_list.shrink_inactive_list.shrink_lruvec
      0.39 ± 71%      -0.4        0.00            -0.2        0.18 ±141%  perf-profile.calltrace.cycles-pp.__count_memcg_events.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.37 ± 70%      -0.4        0.00            -0.4        0.00        perf-profile.calltrace.cycles-pp.xfs_read_iomap_begin.iomap_apply.iomap_readpage.filemap_fault.__xfs_filemap_fault
     66.79            -0.3       66.46            -2.0       64.84 ±  2%  perf-profile.calltrace.cycles-pp.asm_exc_page_fault
     66.70            -0.3       66.40            -1.9       64.76 ±  2%  perf-profile.calltrace.cycles-pp.exc_page_fault.asm_exc_page_fault
      1.30 ±  7%      -0.3        1.01 ± 14%      +0.0        1.34 ± 13%  perf-profile.calltrace.cycles-pp.shrink_page_list.shrink_inactive_list.shrink_lruvec.shrink_node.balance_pgdat
     66.64            -0.3       66.36            -1.9       64.70 ±  2%  perf-profile.calltrace.cycles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.27 ±141%      -0.3        0.00            +0.1        0.39 ± 71%  perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_kernel.secondary_startup_64
      0.27 ±141%      -0.3        0.00            +0.1        0.39 ± 71%  perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.start_kernel.secondary_startup_64
      0.27 ±141%      -0.3        0.00            +0.1        0.39 ± 71%  perf-profile.calltrace.cycles-pp.cpuidle_enter.do_idle.cpu_startup_entry.start_kernel.secondary_startup_64
      0.27 ±141%      -0.3        0.00            +0.1        0.39 ± 71%  perf-profile.calltrace.cycles-pp.cpuidle_enter_state.cpuidle_enter.do_idle.cpu_startup_entry.start_kernel
      0.27 ±141%      -0.3        0.00            +0.1        0.39 ± 71%  perf-profile.calltrace.cycles-pp.start_kernel.secondary_startup_64
      1.04 ±  3%      -0.3        0.77 ± 10%      -0.0        1.03 ±  5%  perf-profile.calltrace.cycles-pp.try_to_unmap.shrink_page_list.shrink_inactive_list.shrink_lruvec.shrink_node
     25.69 ±  4%      -0.2       25.44 ±  3%      +1.1       26.82 ±  4%  perf-profile.calltrace.cycles-pp.secondary_startup_64
      0.95 ±  3%      -0.2        0.72 ± 12%      +0.0        0.96 ±  5%  perf-profile.calltrace.cycles-pp.rmap_walk_file.try_to_unmap.shrink_page_list.shrink_inactive_list.shrink_lruvec
     25.35 ±  4%      -0.2       25.13 ±  3%      +1.3       26.63 ±  3%  perf-profile.calltrace.cycles-pp.intel_idle.cpuidle_enter_state.cpuidle_enter.do_idle.cpu_startup_entry
      0.77 ±  3%      -0.2        0.59 ± 15%      +0.0        0.79 ±  6%  perf-profile.calltrace.cycles-pp.try_to_unmap_one.rmap_walk_file.try_to_unmap.shrink_page_list.shrink_inactive_list
      0.18 ±141%      -0.2        0.00            -0.0        0.17 ±141%  perf-profile.calltrace.cycles-pp.page_vma_mapped_walk.page_referenced_one.rmap_walk_file.page_referenced.shrink_page_list
      0.17 ±141%      -0.2        0.00            -0.2        0.00        perf-profile.calltrace.cycles-pp.get_mem_cgroup_from_mm.mem_cgroup_charge.__add_to_page_cache_locked.add_to_page_cache_lru.pagecache_get_page
      0.17 ±141%      -0.2        0.00            +0.2        0.37 ± 71%  perf-profile.calltrace.cycles-pp.workingset_eviction.__remove_mapping.shrink_page_list.shrink_inactive_list.shrink_lruvec
     66.16            -0.1       66.05            -1.9       64.28 ±  2%  perf-profile.calltrace.cycles-pp.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.59 ± 70%      -0.1        0.52 ± 70%      +0.3        0.85 ± 23%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__remove_mapping.shrink_page_list.shrink_inactive_list.shrink_lruvec
      0.55 ± 70%      -0.1        0.49 ± 70%      +0.2        0.80 ± 25%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__remove_mapping.shrink_page_list.shrink_inactive_list
      0.00            +0.0        0.00            +0.2        0.17 ±141%  perf-profile.calltrace.cycles-pp.free_unref_page_list.shrink_page_list.shrink_inactive_list.shrink_lruvec.shrink_node
      0.75 ±  2%      +0.0        0.76            -0.0        0.75 ±  5%  perf-profile.calltrace.cycles-pp.isolate_lru_pages.shrink_inactive_list.shrink_lruvec.shrink_node.do_try_to_free_pages
     25.16 ±  3%      +0.0       25.18 ±  3%      +1.2       26.36 ±  4%  perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_secondary.secondary_startup_64
     25.16 ±  3%      +0.0       25.18 ±  3%      +1.2       26.36 ±  4%  perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.start_secondary.secondary_startup_64
     25.16 ±  3%      +0.0       25.18 ±  3%      +1.2       26.36 ±  4%  perf-profile.calltrace.cycles-pp.start_secondary.secondary_startup_64
     25.16 ±  3%      +0.0       25.18 ±  3%      +1.2       26.36 ±  4%  perf-profile.calltrace.cycles-pp.cpuidle_enter.do_idle.cpu_startup_entry.start_secondary.secondary_startup_64
     25.16 ±  3%      +0.0       25.18 ±  3%      +1.2       26.36 ±  4%  perf-profile.calltrace.cycles-pp.cpuidle_enter_state.cpuidle_enter.do_idle.cpu_startup_entry.start_secondary
      0.35 ± 70%      +0.2        0.51 ± 73%      +0.2        0.58 ±  4%  perf-profile.calltrace.cycles-pp.generic_perform_write.__generic_file_write_iter.generic_file_write_iter.new_sync_write.vfs_write
      0.35 ± 70%      +0.2        0.51 ± 73%      +0.2        0.58 ±  4%  perf-profile.calltrace.cycles-pp.__generic_file_write_iter.generic_file_write_iter.new_sync_write.vfs_write.ksys_write
      0.35 ± 70%      +0.2        0.51 ± 73%      +0.2        0.58 ±  4%  perf-profile.calltrace.cycles-pp.new_sync_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.35 ± 70%      +0.2        0.51 ± 73%      +0.2        0.58 ±  4%  perf-profile.calltrace.cycles-pp.generic_file_write_iter.new_sync_write.vfs_write.ksys_write.do_syscall_64
      0.00            +0.2        0.17 ±141%      +0.0        0.00        perf-profile.calltrace.cycles-pp.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.alloc_pages_vma.shmem_alloc_page
      0.00            +0.2        0.17 ±141%      +0.0        0.00        perf-profile.calltrace.cycles-pp.do_try_to_free_pages.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.alloc_pages_vma
      0.00            +0.2        0.17 ±141%      +0.0        0.00        perf-profile.calltrace.cycles-pp.__alloc_pages_slowpath.__alloc_pages_nodemask.alloc_pages_vma.shmem_alloc_page.shmem_alloc_and_acct_page
      0.00            +0.2        0.18 ±141%      +0.0        0.00        perf-profile.calltrace.cycles-pp.__alloc_pages_nodemask.alloc_pages_vma.shmem_alloc_page.shmem_alloc_and_acct_page.shmem_getpage_gfp
      0.00            +0.2        0.18 ±141%      +0.0        0.00        perf-profile.calltrace.cycles-pp.alloc_pages_vma.shmem_alloc_page.shmem_alloc_and_acct_page.shmem_getpage_gfp.shmem_write_begin
      0.00            +0.2        0.18 ±141%      +0.0        0.00        perf-profile.calltrace.cycles-pp.shmem_alloc_and_acct_page.shmem_getpage_gfp.shmem_write_begin.generic_perform_write.__generic_file_write_iter
      0.00            +0.2        0.18 ±141%      +0.0        0.00        perf-profile.calltrace.cycles-pp.shmem_alloc_page.shmem_alloc_and_acct_page.shmem_getpage_gfp.shmem_write_begin.generic_perform_write
      0.64 ±  6%      +0.2        0.85 ±  8%      +0.2        0.86 ± 15%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irq.shrink_inactive_list.shrink_lruvec.shrink_node.balance_pgdat
     65.23            +0.3       65.53            -1.7       63.52 ±  2%  perf-profile.calltrace.cycles-pp.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.36 ± 70%      +0.3        0.68 ± 24%      +0.2        0.59 ±  4%  perf-profile.calltrace.cycles-pp.__libc_write
      0.36 ± 70%      +0.3        0.68 ± 24%      +0.2        0.59 ±  3%  perf-profile.calltrace.cycles-pp.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_write
      0.36 ± 70%      +0.3        0.68 ± 24%      +0.2        0.59 ±  4%  perf-profile.calltrace.cycles-pp.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_write
      0.36 ± 70%      +0.3        0.68 ± 24%      +0.2        0.59 ±  4%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__libc_write
      0.36 ± 70%      +0.3        0.68 ± 24%      +0.2        0.59 ±  4%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_write
     64.85            +0.4       65.23            -1.7       63.16 ±  2%  perf-profile.calltrace.cycles-pp.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault
      0.00            +0.5        0.46 ± 74%      +0.0        0.00        perf-profile.calltrace.cycles-pp.shmem_write_begin.generic_perform_write.__generic_file_write_iter.generic_file_write_iter.new_sync_write
      0.00            +0.5        0.46 ± 74%      +0.0        0.00        perf-profile.calltrace.cycles-pp.shmem_getpage_gfp.shmem_write_begin.generic_perform_write.__generic_file_write_iter.generic_file_write_iter
      2.34            +1.1        3.46 ±  8%      +0.6        2.98 ±  6%  perf-profile.calltrace.cycles-pp.smp_call_function_many_cond.on_each_cpu_cond_mask.arch_tlbbatch_flush.try_to_unmap_flush.shrink_page_list
      2.45 ±  2%      +1.2        3.63 ±  8%      +0.6        3.07 ±  6%  perf-profile.calltrace.cycles-pp.try_to_unmap_flush.shrink_page_list.shrink_inactive_list.shrink_lruvec.shrink_node
      2.45 ±  2%      +1.2        3.63 ±  8%      +0.6        3.07 ±  6%  perf-profile.calltrace.cycles-pp.arch_tlbbatch_flush.try_to_unmap_flush.shrink_page_list.shrink_inactive_list.shrink_lruvec
      2.44 ±  2%      +1.2        3.62 ±  9%      +0.6        3.07 ±  6%  perf-profile.calltrace.cycles-pp.on_each_cpu_cond_mask.arch_tlbbatch_flush.try_to_unmap_flush.shrink_page_list.shrink_inactive_list
      2.00 ± 53%      +1.4        3.40 ± 49%      +1.1        3.07 ± 30%  perf-profile.calltrace.cycles-pp.invalidate_mapping_pages.generic_fadvise.ksys_fadvise64_64.__x64_sys_fadvise64.do_syscall_64
      2.00 ± 53%      +1.4        3.41 ± 49%      +1.1        3.09 ± 30%  perf-profile.calltrace.cycles-pp.__x64_sys_fadvise64.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.00 ± 53%      +1.4        3.41 ± 49%      +1.1        3.09 ± 30%  perf-profile.calltrace.cycles-pp.ksys_fadvise64_64.__x64_sys_fadvise64.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.00 ± 53%      +1.4        3.41 ± 49%      +1.1        3.09 ± 30%  perf-profile.calltrace.cycles-pp.generic_fadvise.ksys_fadvise64_64.__x64_sys_fadvise64.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.03 ± 52%      +1.4        3.44 ± 49%      +1.1        3.11 ± 30%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe
      2.03 ± 52%      +1.4        3.44 ± 49%      +1.1        3.11 ± 30%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.48 ± 53%      +1.5        2.99 ± 51%      +1.0        2.44 ± 34%  perf-profile.calltrace.cycles-pp.deactivate_file_page.invalidate_mapping_pages.generic_fadvise.ksys_fadvise64_64.__x64_sys_fadvise64
      1.46 ± 52%      +1.5        2.97 ± 51%      +1.0        2.41 ± 34%  perf-profile.calltrace.cycles-pp.pagevec_lru_move_fn.deactivate_file_page.invalidate_mapping_pages.generic_fadvise.ksys_fadvise64_64
     59.72 ±  2%      +2.1       61.84            -1.2       58.47        perf-profile.calltrace.cycles-pp.__do_fault.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
     59.67 ±  2%      +2.1       61.80            -1.2       58.43        perf-profile.calltrace.cycles-pp.__xfs_filemap_fault.__do_fault.do_fault.__handle_mm_fault.handle_mm_fault
     59.49 ±  2%      +2.2       61.69            -1.2       58.27        perf-profile.calltrace.cycles-pp.filemap_fault.__xfs_filemap_fault.__do_fault.do_fault.__handle_mm_fault
     40.49 ±  4%      +2.3       42.79 ±  2%      -3.7       36.78 ±  4%  perf-profile.calltrace.cycles-pp.__alloc_pages_nodemask.pagecache_get_page.filemap_fault.__xfs_filemap_fault.__do_fault
      0.00            +2.9        2.87 ± 52%      +2.3        2.27 ± 35%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.lock_page_lruvec_irqsave.pagevec_lru_move_fn.deactivate_file_page
      0.00            +2.9        2.88 ± 51%      +2.3        2.28 ± 35%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.lock_page_lruvec_irqsave.pagevec_lru_move_fn.deactivate_file_page.invalidate_mapping_pages
      0.00            +2.9        2.88 ± 51%      +2.3        2.29 ± 35%  perf-profile.calltrace.cycles-pp.lock_page_lruvec_irqsave.pagevec_lru_move_fn.deactivate_file_page.invalidate_mapping_pages.generic_fadvise
     39.15 ±  4%      +3.0       42.19 ±  2%      -3.3       35.81 ±  4%  perf-profile.calltrace.cycles-pp.__alloc_pages_slowpath.__alloc_pages_nodemask.pagecache_get_page.filemap_fault.__xfs_filemap_fault
     38.75 ±  4%      +3.2       42.00 ±  2%      -3.2       35.55 ±  4%  perf-profile.calltrace.cycles-pp.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.pagecache_get_page.filemap_fault
     38.73 ±  4%      +3.3       41.99 ±  2%      -3.2       35.53 ±  4%  perf-profile.calltrace.cycles-pp.do_try_to_free_pages.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.pagecache_get_page
     38.73 ±  4%      +3.4       42.16 ±  2%      -3.2       35.52 ±  4%  perf-profile.calltrace.cycles-pp.shrink_node.do_try_to_free_pages.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask
      9.97 ±  5%      +3.6       13.55 ±  5%      +3.7       13.64 ±  9%  perf-profile.calltrace.cycles-pp.add_to_page_cache_lru.pagecache_get_page.filemap_fault.__xfs_filemap_fault.__do_fault
     37.92 ±  5%      +3.6       41.56 ±  2%      -3.2       34.74 ±  5%  perf-profile.calltrace.cycles-pp.shrink_inactive_list.shrink_lruvec.shrink_node.do_try_to_free_pages.try_to_free_pages
     38.12 ±  5%      +3.7       41.87 ±  2%      -3.0       35.09 ±  4%  perf-profile.calltrace.cycles-pp.shrink_lruvec.shrink_node.do_try_to_free_pages.try_to_free_pages.__alloc_pages_slowpath
      7.55 ±  8%      +4.6       12.16 ±  8%      +4.1       11.66 ± 12%  perf-profile.calltrace.cycles-pp.lru_cache_add.add_to_page_cache_lru.pagecache_get_page.filemap_fault.__xfs_filemap_fault
      7.48 ±  8%      +4.6       12.11 ±  8%      +4.1       11.60 ± 12%  perf-profile.calltrace.cycles-pp.__pagevec_lru_add.lru_cache_add.add_to_page_cache_lru.pagecache_get_page.filemap_fault
     50.80 ±  2%      +5.8       56.57            -0.0       50.75        perf-profile.calltrace.cycles-pp.pagecache_get_page.filemap_fault.__xfs_filemap_fault.__do_fault.do_fault
     13.35 ±  6%      +8.8       22.12 ±  2%      +3.6       16.92 ±  6%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irq.shrink_inactive_list.shrink_lruvec.shrink_node.do_try_to_free_pages
     13.95 ±  6%      +9.0       22.92 ±  2%      +3.8       17.74 ±  6%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irq.shrink_inactive_list.shrink_lruvec.shrink_node
      0.00           +11.3       11.34 ±  8%     +10.7       10.67 ± 13%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.lock_page_lruvec_irqsave.__pagevec_lru_add.lru_cache_add
      0.00           +11.4       11.37 ±  8%     +10.7       10.72 ± 13%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.lock_page_lruvec_irqsave.__pagevec_lru_add.lru_cache_add.add_to_page_cache_lru
      0.00           +11.4       11.37 ±  8%     +10.7       10.72 ± 13%  perf-profile.calltrace.cycles-pp.lock_page_lruvec_irqsave.__pagevec_lru_add.lru_cache_add.add_to_page_cache_lru.pagecache_get_page
     16.27 ±  5%      -5.2       11.05 ±  4%      -7.9        8.33 ±  5%  perf-profile.children.cycles-pp.lru_note_cost
      8.12            -3.4        4.77 ±  3%      -1.1        7.02 ±  7%  perf-profile.children.cycles-pp.iomap_readpage
      6.96 ±  2%      -2.9        4.04 ±  4%      -1.0        5.99 ±  7%  perf-profile.children.cycles-pp.submit_bio
      6.94 ±  2%      -2.9        4.03 ±  4%      -1.0        5.97 ±  7%  perf-profile.children.cycles-pp.submit_bio_noacct
      6.54 ±  2%      -2.8        3.69 ±  4%      -0.9        5.61 ±  7%  perf-profile.children.cycles-pp.pmem_submit_bio
      5.90 ±  2%      -2.6        3.30 ±  4%      -0.9        5.04 ±  7%  perf-profile.children.cycles-pp.pmem_do_read
      5.84 ±  2%      -2.6        3.24 ±  4%      -0.8        5.00 ±  7%  perf-profile.children.cycles-pp.__memcpy_mcsafe
      4.91            -1.7        3.22 ±  3%      -0.4        4.50 ±  4%  perf-profile.children.cycles-pp.xfs_filemap_map_pages
      4.69 ±  2%      -1.6        3.06 ±  3%      -0.4        4.30 ±  4%  perf-profile.children.cycles-pp.filemap_map_pages
      2.25 ±  3%      -1.0        1.28 ± 22%      -0.4        1.83 ±  6%  perf-profile.children.cycles-pp.__add_to_page_cache_locked
      9.55 ±  2%      -0.9        8.68 ±  2%      +0.7       10.24 ±  4%  perf-profile.children.cycles-pp.shrink_page_list
      2.60            -0.8        1.76 ±  3%      -0.1        2.51        perf-profile.children.cycles-pp.rmap_walk_file
      1.53 ±  4%      -0.8        0.70 ±  5%      -0.4        1.12 ±  5%  perf-profile.children.cycles-pp.get_page_from_freelist
      1.18 ±  6%      -0.7        0.52 ±  9%      -0.3        0.86 ±  6%  perf-profile.children.cycles-pp.rmqueue
      2.37 ±  7%      -0.6        1.77 ±  5%      +0.2        2.52 ± 11%  perf-profile.children.cycles-pp.__remove_mapping
      1.64            -0.6        1.07 ±  4%      -0.1        1.56        perf-profile.children.cycles-pp.page_referenced
      1.15 ±  9%      -0.5        0.62 ± 12%      -0.3        0.90 ± 13%  perf-profile.children.cycles-pp.mem_cgroup_charge
      2.99 ±  6%      -0.5        2.48 ±  9%      -0.1        2.88 ± 14%  perf-profile.children.cycles-pp.kswapd
      2.99 ±  6%      -0.5        2.48 ±  9%      -0.1        2.88 ± 14%  perf-profile.children.cycles-pp.balance_pgdat
      3.16 ±  4%      -0.5        2.66 ±  9%      -0.1        3.05 ± 13%  perf-profile.children.cycles-pp.ret_from_fork
      3.16 ±  4%      -0.5        2.66 ±  9%      -0.1        3.05 ± 13%  perf-profile.children.cycles-pp.kthread
      1.04 ±  9%      -0.5        0.54 ± 11%      -0.2        0.82 ± 14%  perf-profile.children.cycles-pp.__count_memcg_events
      1.10            -0.5        0.61 ±  4%      -0.2        0.92 ±  3%  perf-profile.children.cycles-pp.__list_del_entry_valid
      0.80 ±  7%      -0.5        0.32 ± 11%      -0.2        0.56 ±  8%  perf-profile.children.cycles-pp.rmqueue_bulk
      1.06 ±  2%      -0.5        0.59 ± 14%      -0.1        0.93 ±  2%  perf-profile.children.cycles-pp.alloc_set_pte
      0.98 ±  3%      -0.5        0.52 ±  9%      -0.2        0.75 ± 11%  perf-profile.children.cycles-pp._raw_spin_lock
      1.13 ±  5%      -0.4        0.70 ±  3%      -0.1        1.00 ±  4%  perf-profile.children.cycles-pp.iomap_apply
      0.88 ±  3%      -0.4        0.48 ±  4%      -0.1        0.74 ±  7%  perf-profile.children.cycles-pp.native_irq_return_iret
      1.24            -0.4        0.88 ±  9%      -0.0        1.21 ±  3%  perf-profile.children.cycles-pp.try_to_unmap
      0.71 ±  3%      -0.4        0.36 ± 22%      -0.1        0.61 ±  2%  perf-profile.children.cycles-pp.page_add_file_rmap
      0.94            -0.3        0.61 ±  3%      -0.1        0.88        perf-profile.children.cycles-pp.page_referenced_one
     66.88            -0.3       66.55            -2.0       64.90 ±  2%  perf-profile.children.cycles-pp.asm_exc_page_fault
      0.87 ±  3%      -0.3        0.55            -0.1        0.79        perf-profile.children.cycles-pp.down_read
     66.77            -0.3       66.48            -2.0       64.81 ±  2%  perf-profile.children.cycles-pp.exc_page_fault
      0.96 ±  3%      -0.3        0.68 ± 25%      +0.0        1.00 ±  3%  perf-profile.children.cycles-pp.__mod_memcg_lruvec_state
      0.81            -0.3        0.53 ±  3%      -0.0        0.77 ±  2%  perf-profile.children.cycles-pp.page_vma_mapped_walk
     66.72            -0.3       66.45            -2.0       64.76 ±  2%  perf-profile.children.cycles-pp.do_user_addr_fault
      0.53 ± 39%      -0.3        0.26 ± 75%      -0.1        0.46 ± 39%  perf-profile.children.cycles-pp.start_kernel
      0.95            -0.3        0.68 ± 14%      -0.0        0.94 ±  4%  perf-profile.children.cycles-pp.try_to_unmap_one
     25.69 ±  4%      -0.2       25.44 ±  3%      +1.1       26.82 ±  4%  perf-profile.children.cycles-pp.secondary_startup_64
     25.69 ±  4%      -0.2       25.44 ±  3%      +1.1       26.82 ±  4%  perf-profile.children.cycles-pp.cpu_startup_entry
     25.69 ±  4%      -0.2       25.44 ±  3%      +1.1       26.82 ±  4%  perf-profile.children.cycles-pp.do_idle
     25.68 ±  4%      -0.2       25.43 ±  3%      +1.1       26.82 ±  4%  perf-profile.children.cycles-pp.cpuidle_enter
     25.68 ±  4%      -0.2       25.43 ±  3%      +1.1       26.82 ±  4%  perf-profile.children.cycles-pp.cpuidle_enter_state
      0.85 ±  2%      -0.2        0.60 ±  2%      -0.0        0.82 ±  4%  perf-profile.children.cycles-pp.unlock_page
      0.52 ± 11%      -0.2        0.29 ±  2%      -0.1        0.43 ±  6%  perf-profile.children.cycles-pp.xfs_read_iomap_begin
      0.52 ±  5%      -0.2        0.30 ± 10%      -0.1        0.45 ± 10%  perf-profile.children.cycles-pp.__mod_memcg_state
      0.53 ±  8%      -0.2        0.31 ±  7%      +0.0        0.57 ± 11%  perf-profile.children.cycles-pp.workingset_eviction
     25.60 ±  4%      -0.2       25.39 ±  3%      +1.1       26.70 ±  3%  perf-profile.children.cycles-pp.intel_idle
      0.44 ± 12%      -0.2        0.23 ± 14%      -0.1        0.31 ± 18%  perf-profile.children.cycles-pp.get_mem_cgroup_from_mm
      0.67 ±  4%      -0.2        0.47 ±  4%      -0.0        0.66        perf-profile.children.cycles-pp.asm_call_sysvec_on_stack
      0.62 ± 12%      -0.2        0.44 ±  5%      +0.0        0.63 ±  3%  perf-profile.children.cycles-pp.xas_store
      0.57            -0.2        0.38 ±  4%      -0.0        0.56 ±  9%  perf-profile.children.cycles-pp.free_unref_page_list
      0.68            -0.2        0.50 ± 11%      +0.0        0.69 ±  5%  perf-profile.children.cycles-pp.__delete_from_page_cache
      0.42 ± 10%      -0.2        0.25 ± 18%      -0.1        0.36 ±  2%  perf-profile.children.cycles-pp.shrink_slab
      0.33 ±  2%      -0.2        0.16 ±  7%      -0.1        0.24 ±  5%  perf-profile.children.cycles-pp.__mod_lruvec_state
      0.47            -0.2        0.30 ±  7%      -0.0        0.42 ±  5%  perf-profile.children.cycles-pp.up_read
      0.57 ±  2%      -0.2        0.40 ±  5%      +0.0        0.57 ±  2%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.36 ±  5%      -0.2        0.19            -0.0        0.32 ±  6%  perf-profile.children.cycles-pp.iomap_read_end_io
      0.51            -0.2        0.35 ±  4%      -0.0        0.49 ±  3%  perf-profile.children.cycles-pp.iomap_readpage_actor
      0.52 ±  3%      -0.2        0.36 ±  4%      +0.0        0.52 ±  3%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.29 ±  2%      -0.2        0.13 ±  9%      -0.1        0.20 ±  4%  perf-profile.children.cycles-pp.__mod_node_page_state
      0.49 ±  3%      -0.2        0.34 ±  5%      +0.0        0.49 ±  3%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.48 ±  4%      -0.1        0.33 ±  7%      +0.0        0.48 ±  3%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.55 ±  9%      -0.1        0.40 ±  8%      +0.0        0.56 ±  5%  perf-profile.children.cycles-pp.xas_load
      0.57 ± 14%      -0.1        0.43 ± 13%      -0.0        0.55 ± 17%  perf-profile.children.cycles-pp.free_pcppages_bulk
      0.25 ±  6%      -0.1        0.12 ±  3%      -0.0        0.22 ±  5%  perf-profile.children.cycles-pp.iomap_set_range_uptodate
      0.30 ±  8%      -0.1        0.17 ±  2%      +0.0        0.33 ±  8%  perf-profile.children.cycles-pp.workingset_age_nonresident
      0.41 ±  5%      -0.1        0.28 ±  5%      -0.0        0.40 ±  3%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.37            -0.1        0.25            -0.0        0.35 ±  3%  perf-profile.children.cycles-pp.sync_regs
      0.30            -0.1        0.19 ± 12%      -0.1        0.25 ±  8%  perf-profile.children.cycles-pp.tick_sched_timer
      0.33            -0.1        0.22 ±  3%      -0.0        0.31 ±  6%  perf-profile.children.cycles-pp.xas_create
      0.29            -0.1        0.19 ± 10%      -0.0        0.24 ±  9%  perf-profile.children.cycles-pp.tick_sched_handle
      0.29            -0.1        0.19 ± 10%      -0.0        0.24 ±  9%  perf-profile.children.cycles-pp.update_process_times
      0.30 ±  3%      -0.1        0.20 ±  4%      -0.0        0.28 ±  6%  perf-profile.children.cycles-pp.asm_sysvec_call_function
     66.24            -0.1       66.13            -1.9       64.33 ±  2%  perf-profile.children.cycles-pp.handle_mm_fault
      0.33 ±  2%      -0.1        0.23 ±  9%      -0.0        0.31 ±  4%  perf-profile.children.cycles-pp.xas_find
      0.30 ±  3%      -0.1        0.21 ±  2%      -0.0        0.27 ±  3%  perf-profile.children.cycles-pp.xfs_ilock
      0.23 ±  8%      -0.1        0.14 ±  3%      -0.0        0.20 ± 10%  perf-profile.children.cycles-pp.try_charge
      0.19 ± 11%      -0.1        0.10 ± 16%      -0.0        0.16 ±  8%  perf-profile.children.cycles-pp.mem_cgroup_charge_statistics
      0.09 ±  9%      -0.1        0.00            -0.1        0.00        perf-profile.children.cycles-pp.wake_all_kswapds
      0.23 ±  2%      -0.1        0.14 ± 10%      -0.0        0.19 ±  7%  perf-profile.children.cycles-pp.scheduler_tick
      0.18 ± 14%      -0.1        0.10            -0.0        0.16 ± 10%  perf-profile.children.cycles-pp.xfs_bmapi_read
      0.17 ±  5%      -0.1        0.09 ± 18%      -0.0        0.15 ± 13%  perf-profile.children.cycles-pp.lock_page_memcg
      0.26            -0.1        0.18 ±  2%      -0.0        0.24        perf-profile.children.cycles-pp.___might_sleep
      0.07 ±  6%      -0.1        0.00            -0.1        0.00        perf-profile.children.cycles-pp.wakeup_kswapd
      0.22 ±  2%      -0.1        0.14 ±  6%      -0.0        0.19 ±  6%  perf-profile.children.cycles-pp.xfs_iunlock
      0.22 ±  2%      -0.1        0.14 ±  3%      -0.0        0.19 ±  6%  perf-profile.children.cycles-pp.sysvec_call_function
      0.20 ±  2%      -0.1        0.13 ±  3%      -0.0        0.18 ±  4%  perf-profile.children.cycles-pp._cond_resched
      0.15 ±  8%      -0.1        0.08 ±  6%      -0.0        0.11 ±  7%  perf-profile.children.cycles-pp.xfs_ilock_for_iomap
      0.20 ±  2%      -0.1        0.13            -0.0        0.17 ±  7%  perf-profile.children.cycles-pp.flush_smp_call_function_queue
      0.20 ±  2%      -0.1        0.13            -0.0        0.18 ±  4%  perf-profile.children.cycles-pp.__sysvec_call_function
      0.23            -0.1        0.16 ±  2%      -0.0        0.23 ±  4%  perf-profile.children.cycles-pp.bio_alloc_bioset
      0.16 ± 13%      -0.1        0.09 ± 22%      -0.0        0.14 ±  8%  perf-profile.children.cycles-pp.down_read_trylock
      0.22 ±  5%      -0.1        0.15 ±  5%      +0.0        0.22 ±  5%  perf-profile.children.cycles-pp.find_get_entry
      0.15 ±  3%      -0.1        0.09 ±  5%      -0.0        0.13 ±  9%  perf-profile.children.cycles-pp.workingset_refault
      0.19 ±  5%      -0.1        0.13 ±  3%      -0.0        0.18 ±  9%  perf-profile.children.cycles-pp.__perf_sw_event
      0.06 ±  8%      -0.1        0.00            -0.0        0.04 ± 71%  perf-profile.children.cycles-pp.cpumask_any_but
      0.06 ±  8%      -0.1        0.00            -0.0        0.05 ±  8%  perf-profile.children.cycles-pp.find_vma
      0.06 ±  8%      -0.1        0.00            +0.0        0.06 ±  8%  perf-profile.children.cycles-pp.default_send_IPI_mask_sequence_phys
      0.13 ± 10%      -0.1        0.07 ± 12%      -0.0        0.11 ± 14%  perf-profile.children.cycles-pp.page_counter_try_charge
      0.07 ± 11%      -0.1        0.02 ±141%      -0.1        0.00        perf-profile.children.cycles-pp.native_flush_tlb_one_user
      0.07            -0.1        0.02 ±141%      -0.0        0.06 ± 13%  perf-profile.children.cycles-pp.bio_endio
      0.12 ±  3%      -0.1        0.07 ± 11%      -0.0        0.10 ±  9%  perf-profile.children.cycles-pp.task_tick_fair
      0.15 ±  6%      -0.1        0.10 ±  4%      -0.0        0.13 ±  9%  perf-profile.children.cycles-pp.do_shrink_slab
      0.05            -0.1        0.00            -0.1        0.00        perf-profile.children.cycles-pp.vmacache_find
      0.05            -0.1        0.00            -0.1        0.00        perf-profile.children.cycles-pp.bio_init
      0.05            -0.1        0.00            -0.1        0.00        perf-profile.children.cycles-pp.update_load_avg
      0.05            -0.1        0.00            -0.1        0.00        perf-profile.children.cycles-pp.ghes_notify_nmi
      0.05            -0.1        0.00            -0.0        0.04 ± 71%  perf-profile.children.cycles-pp.llist_reverse_order
      0.05            -0.1        0.00            +0.0        0.05        perf-profile.children.cycles-pp.check_pte
      0.07 ± 14%      -0.1        0.02 ±141%      -0.1        0.00        perf-profile.children.cycles-pp.acpi_os_read_memory
      0.16 ±  5%      -0.1        0.11 ±  4%      -0.0        0.16 ±  5%  perf-profile.children.cycles-pp.page_mapping
      0.07 ±  7%      -0.1        0.02 ±141%      -0.0        0.06 ±  7%  perf-profile.children.cycles-pp.ptep_clear_flush_young
      0.32            -0.0        0.27            -0.0        0.29 ± 11%  perf-profile.children.cycles-pp.submit_bio_checks
      0.14 ±  5%      -0.0        0.09 ±  5%      -0.0        0.13 ±  9%  perf-profile.children.cycles-pp.___perf_sw_event
      0.15            -0.0        0.10 ±  4%      +0.0        0.15 ±  3%  perf-profile.children.cycles-pp.mempool_alloc
      0.15 ±  3%      -0.0        0.11 ±  4%      -0.0        0.14 ± 13%  perf-profile.children.cycles-pp.mem_cgroup_uncharge_list
      0.16 ± 55%      -0.0        0.12 ± 33%      +0.0        0.20 ± 15%  perf-profile.children.cycles-pp.pagevec_lookup_entries
      0.16 ± 55%      -0.0        0.12 ± 33%      +0.0        0.20 ± 15%  perf-profile.children.cycles-pp.find_get_entries
      0.08 ±  6%      -0.0        0.03 ± 70%      -0.0        0.06 ±  7%  perf-profile.children.cycles-pp.bio_associate_blkg_from_css
      0.08 ±  6%      -0.0        0.03 ± 70%      -0.0        0.07        perf-profile.children.cycles-pp.__mod_zone_page_state
      0.08 ± 22%      -0.0        0.03 ± 70%      +0.0        0.08 ± 12%  perf-profile.children.cycles-pp.kmem_cache_free
      0.11 ±  8%      -0.0        0.06 ±  7%      -0.0        0.09 ±  5%  perf-profile.children.cycles-pp.rcu_all_qs
      0.14            -0.0        0.10 ±  4%      -0.0        0.14 ±  3%  perf-profile.children.cycles-pp.__might_sleep
      0.04 ± 71%      -0.0        0.00            +0.0        0.06 ±  7%  perf-profile.children.cycles-pp.copy_user_enhanced_fast_string
      0.04 ± 71%      -0.0        0.00            +0.0        0.06 ±  7%  perf-profile.children.cycles-pp.iov_iter_copy_from_user_atomic
      0.04 ± 70%      -0.0        0.00            +0.0        0.06 ±  7%  perf-profile.children.cycles-pp.copyin
      0.94            -0.0        0.90            -0.0        0.93 ±  2%  perf-profile.children.cycles-pp.isolate_lru_pages
      0.07            -0.0        0.03 ± 70%      -0.0        0.06 ±  8%  perf-profile.children.cycles-pp.perf_event_task_tick
      0.13 ±  3%      -0.0        0.09 ±  9%      -0.0        0.11 ±  4%  perf-profile.children.cycles-pp.ktime_get
      0.13 ± 14%      -0.0        0.10 ± 17%      +0.0        0.13 ±  7%  perf-profile.children.cycles-pp.xas_init_marks
      0.12 ± 21%      -0.0        0.09 ± 10%      +0.0        0.13 ± 10%  perf-profile.children.cycles-pp.release_pages
      0.11 ±  4%      -0.0        0.08 ±  6%      -0.0        0.11 ± 12%  perf-profile.children.cycles-pp.uncharge_batch
      0.10 ±  4%      -0.0        0.06 ± 14%      -0.0        0.08 ± 10%  perf-profile.children.cycles-pp.bio_associate_blkg
      0.03 ± 70%      -0.0        0.00            -0.0        0.00        perf-profile.children.cycles-pp.mem_cgroup_iter
      0.03 ± 70%      -0.0        0.00            -0.0        0.02 ±141%  perf-profile.children.cycles-pp.xfs_bmbt_to_iomap
      0.03 ± 70%      -0.0        0.00            -0.0        0.02 ±141%  perf-profile.children.cycles-pp.__default_send_IPI_dest_field
      0.03 ± 70%      -0.0        0.00            +0.0        0.03 ± 70%  perf-profile.children.cycles-pp.cpumask_next
      0.05            -0.0        0.02 ±141%      +0.0        0.05 ±  8%  perf-profile.children.cycles-pp.mem_cgroup_update_lru_size
      0.10 ± 17%      -0.0        0.07 ±  7%      +0.0        0.10 ±  4%  perf-profile.children.cycles-pp.workingset_update_node
      0.23 ±  4%      -0.0        0.20 ± 37%      +0.0        0.26        perf-profile.children.cycles-pp.page_remove_rmap
      0.09 ±  5%      -0.0        0.07 ±  7%      -0.0        0.09 ± 10%  perf-profile.children.cycles-pp.count_shadow_nodes
      0.09 ±  5%      -0.0        0.07 ±  7%      -0.0        0.09 ±  9%  perf-profile.children.cycles-pp.PageHuge
      0.09 ±  9%      -0.0        0.06 ±  7%      +0.0        0.09 ±  9%  perf-profile.children.cycles-pp.page_counter_cancel
      0.09 ±  9%      -0.0        0.06 ±  7%      +0.0        0.09 ± 13%  perf-profile.children.cycles-pp.page_counter_uncharge
      0.03 ±141%      -0.0        0.00            +0.0        0.04 ± 71%  perf-profile.children.cycles-pp.__softirqentry_text_start
      0.08 ± 20%      -0.0        0.06 ± 79%      +0.0        0.12 ± 26%  perf-profile.children.cycles-pp.__intel_pmu_enable_all
      0.02 ±141%      -0.0        0.00            -0.0        0.02 ±141%  perf-profile.children.cycles-pp.rcu_core
      0.02 ±141%      -0.0        0.00            -0.0        0.02 ±141%  perf-profile.children.cycles-pp.rcu_do_batch
      0.08 ± 14%      -0.0        0.06 ± 23%      +0.0        0.08 ±  5%  perf-profile.children.cycles-pp.xas_clear_mark
      0.08 ± 20%      -0.0        0.06 ± 81%      +0.0        0.13 ± 28%  perf-profile.children.cycles-pp.perf_mux_hrtimer_handler
      0.21 ± 15%      -0.0        0.19 ± 18%      -0.1        0.15 ± 16%  perf-profile.children.cycles-pp.__poll
      0.21 ± 15%      -0.0        0.19 ± 18%      -0.1        0.15 ± 16%  perf-profile.children.cycles-pp.__x64_sys_poll
      0.21 ± 15%      -0.0        0.19 ± 18%      -0.1        0.15 ± 16%  perf-profile.children.cycles-pp.do_sys_poll
      0.17 ±  5%      -0.0        0.14 ±  8%      +0.0        0.19 ±  6%  perf-profile.children.cycles-pp._raw_spin_unlock_irqrestore
      0.18            -0.0        0.16 ± 31%      +0.0        0.21 ±  2%  perf-profile.children.cycles-pp.unaccount_page_cache_page
      0.07 ±  6%      -0.0        0.05 ±  8%      -0.0        0.07 ±  7%  perf-profile.children.cycles-pp.flush_tlb_func_common
      0.05 ±  8%      -0.0        0.03 ± 70%      +0.0        0.05 ± 72%  perf-profile.children.cycles-pp.perf_session__deliver_event
      0.02 ±141%      -0.0        0.00            -0.0        0.00        perf-profile.children.cycles-pp.xfs_bmapi_update_map
      0.02 ±141%      -0.0        0.00            -0.0        0.00        perf-profile.children.cycles-pp.mem_cgroup_page_lruvec
      0.07            -0.0        0.05            +0.0        0.07        perf-profile.children.cycles-pp._find_next_bit
      0.02 ±141%      -0.0        0.00            -0.0        0.00        perf-profile.children.cycles-pp.shmem_mapping
      0.02 ±141%      -0.0        0.00            -0.0        0.00        perf-profile.children.cycles-pp.xfs_filemap_fault
      0.02 ±141%      -0.0        0.00            -0.0        0.00        perf-profile.children.cycles-pp.fput_many
      0.02 ±141%      -0.0        0.00            -0.0        0.00        perf-profile.children.cycles-pp.irq_exit_rcu
      0.02 ±141%      -0.0        0.00            -0.0        0.00        perf-profile.children.cycles-pp.to_nd_region
      0.02 ±141%      -0.0        0.00            -0.0        0.00        perf-profile.children.cycles-pp.mem_cgroup_from_task
      0.02 ±141%      -0.0        0.00            -0.0        0.00        perf-profile.children.cycles-pp.list_lru_del
      0.02 ±141%      -0.0        0.00            -0.0        0.00        perf-profile.children.cycles-pp.xas_alloc
      0.02 ±141%      -0.0        0.00            +0.0        0.02 ±141%  perf-profile.children.cycles-pp.smpboot_thread_fn
      0.02 ±141%      -0.0        0.00            +0.0        0.02 ±141%  perf-profile.children.cycles-pp.run_ksoftirqd
      0.03 ± 70%      -0.0        0.02 ±141%      +0.0        0.05 ± 71%  perf-profile.children.cycles-pp.perf_session__process_user_event
      0.03 ± 70%      -0.0        0.02 ±141%      +0.0        0.05 ± 71%  perf-profile.children.cycles-pp.__ordered_events__flush
      0.08            -0.0        0.06 ±  7%      -0.0        0.07 ± 14%  perf-profile.children.cycles-pp.read_tsc
      0.19 ± 12%      -0.0        0.18 ± 19%      -0.1        0.13 ± 16%  perf-profile.children.cycles-pp.perf_poll
      0.09            -0.0        0.08 ± 22%      +0.0        0.09 ± 72%  perf-profile.children.cycles-pp.process_simple
      0.09 ± 14%      -0.0        0.07 ± 25%      +0.0        0.09 ±  5%  perf-profile.children.cycles-pp.xas_start
      0.17            -0.0        0.16 ± 18%      -0.0        0.17 ± 37%  perf-profile.children.cycles-pp.cmd_record
      0.15 ±  3%      -0.0        0.14 ± 17%      -0.0        0.15 ± 37%  perf-profile.children.cycles-pp.perf_session__process_events
      0.15 ±  3%      -0.0        0.14 ± 17%      -0.0        0.15 ± 38%  perf-profile.children.cycles-pp.record__finish_output
      0.12 ± 10%      -0.0        0.12            -0.0        0.11 ± 12%  perf-profile.children.cycles-pp.blk_throtl_bio
      0.21 ± 39%      -0.0        0.21 ± 68%      -0.1        0.16 ± 29%  perf-profile.children.cycles-pp.kmem_cache_alloc
      0.15 ± 10%      +0.0        0.15 ± 23%      -0.1        0.10 ± 25%  perf-profile.children.cycles-pp.__pollwait
      0.00            +0.0        0.00            +0.0        0.02 ±141%  perf-profile.children.cycles-pp.ordered_events__queue
      0.00            +0.0        0.00            +0.0        0.02 ±141%  perf-profile.children.cycles-pp.queue_event
      0.00            +0.0        0.00            +0.0        0.02 ±141%  perf-profile.children.cycles-pp.bio_add_page
      0.00            +0.0        0.00            +0.0        0.02 ±141%  perf-profile.children.cycles-pp.clockevents_program_event
      0.17 ± 11%      +0.0        0.18 ± 16%      -0.1        0.11 ± 23%  perf-profile.children.cycles-pp.__get_free_pages
      0.07 ± 11%      +0.0        0.08 ±  5%      -0.0        0.06 ±  8%  perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.12 ± 68%      +0.0        0.13 ± 33%      -0.0        0.11 ± 71%  perf-profile.children.cycles-pp.drain_pages
     25.16 ±  3%      +0.0       25.18 ±  3%      +1.2       26.36 ±  4%  perf-profile.children.cycles-pp.start_secondary
      0.13 ± 61%      +0.0        0.15 ± 28%      -0.0        0.12 ± 70%  perf-profile.children.cycles-pp.worker_thread
      0.13 ± 65%      +0.0        0.15 ± 32%      -0.0        0.12 ± 70%  perf-profile.children.cycles-pp.process_one_work
      0.00            +0.0        0.02 ±141%      +0.0        0.00        perf-profile.children.cycles-pp.exec_binprm
      0.00            +0.0        0.02 ±141%      +0.0        0.00        perf-profile.children.cycles-pp.load_elf_binary
      0.12 ± 70%      +0.0        0.14 ± 35%      -0.0        0.11 ± 70%  perf-profile.children.cycles-pp.drain_local_pages_wq
      0.12 ± 70%      +0.0        0.14 ± 35%      -0.0        0.11 ± 70%  perf-profile.children.cycles-pp.drain_pages_zone
      0.00            +0.0        0.02 ±141%      +0.0        0.00        perf-profile.children.cycles-pp.bprm_execve
      0.00            +0.0        0.02 ±141%      +0.0        0.00        perf-profile.children.cycles-pp.mm_init
      0.00            +0.0        0.02 ±141%      +0.0        0.00        perf-profile.children.cycles-pp.pgd_alloc
      0.06            +0.0        0.09 ±  9%      +0.0        0.07 ± 14%  perf-profile.children.cycles-pp.lru_add_drain
      0.00            +0.0        0.03 ± 70%      +0.0        0.00        perf-profile.children.cycles-pp.__vmalloc_node_range
      0.06 ±  8%      +0.0        0.09 ±  9%      +0.0        0.06 ±  7%  perf-profile.children.cycles-pp.lru_add_drain_cpu
      0.10 ±  4%      +0.0        0.13 ±  3%      +0.0        0.12        perf-profile.children.cycles-pp.__list_add_valid
      0.00            +0.0        0.04 ± 70%      +0.0        0.00        perf-profile.children.cycles-pp.__x64_sys_execve
      0.00            +0.0        0.04 ± 70%      +0.0        0.00        perf-profile.children.cycles-pp.do_execveat_common
      0.00            +0.0        0.04 ± 70%      +0.0        0.00        perf-profile.children.cycles-pp.execve
      0.07 ±141%      +0.0        0.11 ±141%      -0.0        0.03 ±141%  perf-profile.children.cycles-pp.xas_nomem
      0.09 ±103%      +0.0        0.13 ±111%      -0.1        0.04 ±141%  perf-profile.children.cycles-pp.__slab_alloc
      0.09 ±103%      +0.0        0.13 ±111%      -0.1        0.04 ±141%  perf-profile.children.cycles-pp.___slab_alloc
      0.09 ±103%      +0.0        0.13 ±111%      -0.1        0.04 ±141%  perf-profile.children.cycles-pp.allocate_slab
      0.02 ±141%      +0.0        0.06 ± 77%      +0.0        0.03 ±141%  perf-profile.children.cycles-pp.do_anonymous_page
      0.04 ± 71%      +0.1        0.10 ± 48%      -0.0        0.00        perf-profile.children.cycles-pp.pte_alloc_one
      0.11 ± 23%      +0.1        0.17 ± 16%      -0.0        0.10 ±  8%  perf-profile.children.cycles-pp.smp_call_function_single
      0.00            +0.1        0.07 ± 23%      +0.0        0.02 ±141%  perf-profile.children.cycles-pp.__do_sys_clone
      0.00            +0.1        0.07 ± 23%      +0.0        0.02 ±141%  perf-profile.children.cycles-pp._do_fork
      0.00            +0.1        0.07 ± 23%      +0.0        0.02 ±141%  perf-profile.children.cycles-pp.copy_process
      0.00            +0.1        0.07 ± 23%      +0.0        0.02 ±141%  perf-profile.children.cycles-pp.__libc_fork
      0.15 ± 56%      +0.1        0.27 ± 36%      +0.2        0.31 ± 51%  perf-profile.children.cycles-pp.shrink_active_list
      0.25 ±  8%      +0.1        0.39 ± 30%      +0.0        0.28 ± 12%  perf-profile.children.cycles-pp.shmem_alloc_and_acct_page
      0.24 ± 10%      +0.1        0.39 ± 30%      +0.0        0.28 ± 12%  perf-profile.children.cycles-pp.shmem_alloc_page
      0.30 ±  3%      +0.2        0.46 ±  4%      +0.0        0.35 ±  6%  perf-profile.children.cycles-pp.move_pages_to_lru
      0.29 ±  7%      +0.2        0.47 ± 30%      +0.0        0.33 ± 15%  perf-profile.children.cycles-pp.alloc_pages_vma
      0.49 ± 15%      +0.2        0.68 ± 23%      +0.1        0.59 ±  4%  perf-profile.children.cycles-pp.vfs_write
      0.49 ± 15%      +0.2        0.68 ± 23%      +0.1        0.59 ±  4%  perf-profile.children.cycles-pp.ksys_write
      0.49 ± 15%      +0.2        0.68 ± 23%      +0.1        0.59 ±  4%  perf-profile.children.cycles-pp.__libc_write
      0.48 ± 14%      +0.2        0.68 ± 23%      +0.1        0.58 ±  4%  perf-profile.children.cycles-pp.generic_file_write_iter
      0.48 ± 15%      +0.2        0.68 ± 24%      +0.1        0.59 ±  3%  perf-profile.children.cycles-pp.new_sync_write
      0.47 ± 15%      +0.2        0.68 ± 23%      +0.1        0.58 ±  4%  perf-profile.children.cycles-pp.generic_perform_write
      0.47 ± 15%      +0.2        0.68 ± 23%      +0.1        0.58 ±  4%  perf-profile.children.cycles-pp.__generic_file_write_iter
      0.38 ± 12%      +0.2        0.60 ± 27%      +0.1        0.46 ±  5%  perf-profile.children.cycles-pp.shmem_write_begin
      0.37 ± 12%      +0.2        0.60 ± 27%      +0.1        0.46 ±  5%  perf-profile.children.cycles-pp.shmem_getpage_gfp
     65.30            +0.3       65.61            -1.7       63.57 ±  2%  perf-profile.children.cycles-pp.__handle_mm_fault
     64.91            +0.4       65.30            -1.7       63.20 ±  2%  perf-profile.children.cycles-pp.do_fault
      2.71            +1.1        3.81 ±  3%      +0.7        3.44 ±  3%  perf-profile.children.cycles-pp.smp_call_function_many_cond
      2.82            +1.2        3.98 ±  3%      +0.7        3.55 ±  3%  perf-profile.children.cycles-pp.on_each_cpu_cond_mask
      2.82            +1.2        3.98 ±  3%      +0.7        3.55 ±  3%  perf-profile.children.cycles-pp.try_to_unmap_flush
      2.82            +1.2        3.98 ±  3%      +0.7        3.55 ±  3%  perf-profile.children.cycles-pp.arch_tlbbatch_flush
      2.00 ± 53%      +1.4        3.41 ± 49%      +1.1        3.08 ± 30%  perf-profile.children.cycles-pp.invalidate_mapping_pages
      2.00 ± 53%      +1.4        3.41 ± 49%      +1.1        3.09 ± 30%  perf-profile.children.cycles-pp.__x64_sys_fadvise64
      2.00 ± 53%      +1.4        3.41 ± 49%      +1.1        3.09 ± 30%  perf-profile.children.cycles-pp.ksys_fadvise64_64
      2.00 ± 53%      +1.4        3.41 ± 49%      +1.1        3.09 ± 30%  perf-profile.children.cycles-pp.generic_fadvise
      1.48 ± 53%      +1.5        2.99 ± 51%      +1.0        2.44 ± 34%  perf-profile.children.cycles-pp.deactivate_file_page
      1.46 ± 53%      +1.5        2.99 ± 51%      +1.0        2.42 ± 34%  perf-profile.children.cycles-pp.pagevec_lru_move_fn
      2.86 ± 38%      +1.6        4.50 ± 33%      +1.1        3.96 ± 22%  perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
      2.85 ± 38%      +1.6        4.50 ± 33%      +1.1        3.96 ± 22%  perf-profile.children.cycles-pp.do_syscall_64
     59.72 ±  2%      +2.1       61.84            -1.2       58.47        perf-profile.children.cycles-pp.__do_fault
     59.67 ±  2%      +2.1       61.81            -1.2       58.43        perf-profile.children.cycles-pp.__xfs_filemap_fault
     59.50 ±  2%      +2.2       61.70            -1.2       58.28        perf-profile.children.cycles-pp.filemap_fault
     41.13 ±  4%      +2.6       43.75 ±  2%      -3.8       37.34 ±  5%  perf-profile.children.cycles-pp.__alloc_pages_nodemask
     42.33 ±  4%      +3.1       45.41 ±  2%      -3.4       38.92 ±  4%  perf-profile.children.cycles-pp.shrink_node
     41.51 ±  4%      +3.3       44.82 ±  3%      -3.4       38.14 ±  4%  perf-profile.children.cycles-pp.shrink_inactive_list
     39.76 ±  4%      +3.4       43.13 ±  2%      -3.4       36.34 ±  5%  perf-profile.children.cycles-pp.__alloc_pages_slowpath
     41.70 ±  4%      +3.4       45.10 ±  2%      -3.2       38.48 ±  4%  perf-profile.children.cycles-pp.shrink_lruvec
      9.97 ±  5%      +3.6       13.55 ±  5%      +3.7       13.64 ±  9%  perf-profile.children.cycles-pp.add_to_page_cache_lru
     39.36 ±  4%      +3.6       42.94 ±  2%      -3.3       36.06 ±  5%  perf-profile.children.cycles-pp.try_to_free_pages
     39.34 ±  4%      +3.6       42.93 ±  2%      -3.3       36.05 ±  5%  perf-profile.children.cycles-pp.do_try_to_free_pages
     30.64 ±  5%      +4.1       34.75 ±  3%      -4.0       26.64 ±  5%  perf-profile.children.cycles-pp._raw_spin_lock_irq
      7.63 ±  7%      +4.7       12.34 ±  7%      +4.2       11.81 ± 12%  perf-profile.children.cycles-pp.lru_cache_add
      7.62 ±  8%      +4.8       12.38 ±  7%      +4.2       11.81 ± 12%  perf-profile.children.cycles-pp.__pagevec_lru_add
     50.80 ±  2%      +5.8       56.57            -0.0       50.75        perf-profile.children.cycles-pp.pagecache_get_page
      9.01 ± 12%      +6.2       15.23 ± 16%      +5.1       14.14 ± 15%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     39.95 ±  2%     +10.1       50.03 ±  2%      +1.0       40.90        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
      0.00           +14.5       14.52 ± 16%     +13.2       13.22 ± 16%  perf-profile.children.cycles-pp.lock_page_lruvec_irqsave
      5.68 ±  2%      -2.5        3.16 ±  4%      -0.8        4.90 ±  7%  perf-profile.self.cycles-pp.__memcpy_mcsafe
      2.68 ±  2%      -0.9        1.82 ±  2%      -0.2        2.49 ±  6%  perf-profile.self.cycles-pp.filemap_map_pages
      1.03 ±  9%      -0.5        0.53 ± 12%      -0.2        0.81 ± 15%  perf-profile.self.cycles-pp.__count_memcg_events
      1.09            -0.5        0.60 ±  4%      -0.2        0.92 ±  4%  perf-profile.self.cycles-pp.__list_del_entry_valid
      0.87 ±  3%      -0.4        0.48 ±  4%      -0.1        0.73 ±  7%  perf-profile.self.cycles-pp.native_irq_return_iret
      0.80 ±  3%      -0.2        0.57 ±  2%      -0.0        0.78 ±  4%  perf-profile.self.cycles-pp.unlock_page
      0.60 ±  2%      -0.2        0.38            -0.1        0.55        perf-profile.self.cycles-pp.down_read
     25.60 ±  4%      -0.2       25.39 ±  3%      +1.1       26.70 ±  3%  perf-profile.self.cycles-pp.intel_idle
      0.51 ±  5%      -0.2        0.30 ±  9%      -0.1        0.44 ± 10%  perf-profile.self.cycles-pp.__mod_memcg_state
      0.43 ± 13%      -0.2        0.22 ± 13%      -0.1        0.31 ± 18%  perf-profile.self.cycles-pp.get_mem_cgroup_from_mm
      0.37 ±  5%      -0.2        0.18 ± 17%      -0.1        0.31 ±  5%  perf-profile.self.cycles-pp.__add_to_page_cache_locked
      0.51            -0.2        0.33            -0.0        0.48 ±  2%  perf-profile.self.cycles-pp.page_vma_mapped_walk
      0.45            -0.2        0.29 ±  5%      -0.0        0.41 ±  4%  perf-profile.self.cycles-pp.up_read
      0.28 ±  2%      -0.2        0.12 ± 10%      -0.1        0.19 ±  2%  perf-profile.self.cycles-pp.__mod_node_page_state
      0.27 ±  9%      -0.2        0.11 ± 32%      -0.1        0.21 ± 10%  perf-profile.self.cycles-pp.page_add_file_rmap
      0.31            -0.2        0.15 ±  6%      -0.1        0.23 ±  2%  perf-profile.self.cycles-pp.get_page_from_freelist
      0.47 ±  2%      -0.2        0.31 ±  2%      -0.0        0.44        perf-profile.self.cycles-pp.shrink_page_list
      0.41            -0.1        0.28 ±  2%      -0.0        0.38 ±  5%  perf-profile.self.cycles-pp.try_to_unmap_one
      0.25 ±  6%      -0.1        0.12 ±  6%      -0.0        0.21 ±  5%  perf-profile.self.cycles-pp.iomap_set_range_uptodate
      0.30 ±  8%      -0.1        0.17 ±  2%      +0.0        0.33 ±  8%  perf-profile.self.cycles-pp.workingset_age_nonresident
      0.45 ±  9%      -0.1        0.32 ±  6%      +0.0        0.46 ±  6%  perf-profile.self.cycles-pp.xas_load
      0.27 ±  9%      -0.1        0.14 ± 17%      -0.1        0.20 ± 12%  perf-profile.self.cycles-pp.mem_cgroup_charge
      0.34 ±  3%      -0.1        0.21 ±  4%      -0.0        0.29 ±  4%  perf-profile.self.cycles-pp.__handle_mm_fault
      0.36            -0.1        0.24 ±  3%      -0.0        0.34 ±  3%  perf-profile.self.cycles-pp.sync_regs
      0.30 ±  2%      -0.1        0.20 ±  2%      -0.0        0.28 ±  2%  perf-profile.self.cycles-pp._raw_spin_lock
      0.28            -0.1        0.19 ±  2%      -0.0        0.28 ±  7%  perf-profile.self.cycles-pp.xas_create
      0.23 ±  2%      -0.1        0.14 ±  3%      -0.0        0.21 ±  2%  perf-profile.self.cycles-pp.page_referenced_one
      0.24 ±  8%      -0.1        0.15 ± 13%      +0.0        0.27 ± 12%  perf-profile.self.cycles-pp.workingset_eviction
      0.24            -0.1        0.15 ±  5%      -0.0        0.21 ±  6%  perf-profile.self.cycles-pp.handle_mm_fault
      0.17 ±  4%      -0.1        0.09 ± 18%      -0.0        0.15 ± 13%  perf-profile.self.cycles-pp.lock_page_memcg
      0.08            -0.1        0.00            -0.0        0.07 ±  6%  perf-profile.self.cycles-pp.workingset_refault
      0.27 ±  8%      -0.1        0.19 ± 10%      -0.0        0.25 ±  8%  perf-profile.self.cycles-pp.__remove_mapping
      0.26 ±  7%      -0.1        0.19 ±  6%      -0.0        0.25 ±  5%  perf-profile.self.cycles-pp.filemap_fault
      0.24 ±  3%      -0.1        0.16            -0.0        0.22 ±  6%  perf-profile.self.cycles-pp.alloc_set_pte
      0.25            -0.1        0.17 ±  4%      -0.0        0.23 ±  2%  perf-profile.self.cycles-pp.___might_sleep
      0.23            -0.1        0.16 ±  6%      -0.0        0.23 ±  7%  perf-profile.self.cycles-pp.free_pcppages_bulk
      0.09            -0.1        0.02 ±141%      -0.0        0.05        perf-profile.self.cycles-pp.lru_note_cost
      0.07 ±  6%      -0.1        0.00            -0.0        0.07 ± 18%  perf-profile.self.cycles-pp.xfs_bmapi_read
      0.16 ± 12%      -0.1        0.09 ± 19%      -0.0        0.14 ± 10%  perf-profile.self.cycles-pp.down_read_trylock
      0.07            -0.1        0.00            -0.0        0.06 ±  7%  perf-profile.self.cycles-pp.xfs_iunlock
      0.44 ±  8%      -0.1        0.37 ± 39%      +0.1        0.55 ± 12%  perf-profile.self.cycles-pp.__mod_memcg_lruvec_state
      0.06 ±  7%      -0.1        0.00            -0.1        0.00        perf-profile.self.cycles-pp.wakeup_kswapd
      0.06            -0.1        0.00            -0.0        0.05 ±  8%  perf-profile.self.cycles-pp.asm_exc_page_fault
      0.07 ±  6%      -0.1        0.02 ±141%      -0.0        0.06        perf-profile.self.cycles-pp.flush_smp_call_function_queue
      0.07 ±  6%      -0.1        0.02 ±141%      -0.0        0.07 ±  7%  perf-profile.self.cycles-pp.__mod_zone_page_state
      0.09            -0.1        0.03 ± 70%      -0.0        0.06 ±  7%  perf-profile.self.cycles-pp.__alloc_pages_nodemask
      0.07 ± 11%      -0.1        0.02 ±141%      -0.1        0.00        perf-profile.self.cycles-pp.native_flush_tlb_one_user
      0.07 ± 11%      -0.1        0.02 ±141%      -0.0        0.06 ±  8%  perf-profile.self.cycles-pp.lru_cache_add
      0.05 ±  8%      -0.1        0.00            -0.0        0.03 ± 70%  perf-profile.self.cycles-pp.page_referenced
      0.05 ±  8%      -0.1        0.00            -0.0        0.04 ± 73%  perf-profile.self.cycles-pp.blk_throtl_bio
      0.05 ±  8%      -0.1        0.00            -0.0        0.04 ± 70%  perf-profile.self.cycles-pp.kmem_cache_free
      0.05 ±  8%      -0.1        0.00            +0.0        0.05 ±  8%  perf-profile.self.cycles-pp.iomap_read_end_io
      0.12 ± 11%      -0.1        0.07 ±  7%      -0.0        0.10 ± 12%  perf-profile.self.cycles-pp.page_counter_try_charge
      0.10 ± 12%      -0.1        0.04 ± 71%      -0.0        0.08        perf-profile.self.cycles-pp.shrink_slab
      0.22 ±  9%      -0.1        0.17 ± 10%      -0.0        0.20 ±  2%  perf-profile.self.cycles-pp._raw_spin_lock_irq
      0.16 ±  3%      -0.1        0.10 ±  4%      -0.0        0.15 ±  5%  perf-profile.self.cycles-pp.page_mapping
      0.14 ±  6%      -0.1        0.09 ±  5%      -0.0        0.13 ±  6%  perf-profile.self.cycles-pp.rmqueue
      0.05            -0.1        0.00            -0.1        0.00        perf-profile.self.cycles-pp.bio_init
      0.05            -0.1        0.00            -0.1        0.00        perf-profile.self.cycles-pp.ghes_notify_nmi
      0.05            -0.1        0.00            -0.0        0.03 ± 70%  perf-profile.self.cycles-pp.__perf_sw_event
      0.05            -0.1        0.00            -0.0        0.03 ± 70%  perf-profile.self.cycles-pp.ktime_get
      0.05            -0.1        0.00            -0.0        0.03 ± 70%  perf-profile.self.cycles-pp.perf_event_task_tick
      0.05            -0.1        0.00            -0.0        0.04 ± 71%  perf-profile.self.cycles-pp.submit_bio_checks
      0.05            -0.1        0.00            -0.0        0.04 ± 71%  perf-profile.self.cycles-pp.llist_reverse_order
      0.05            -0.1        0.00            +0.0        0.05        perf-profile.self.cycles-pp.xfs_ilock
      0.07 ± 14%      -0.1        0.02 ±141%      -0.1        0.00        perf-profile.self.cycles-pp.acpi_os_read_memory
      0.07 ±  7%      -0.1        0.02 ±141%      -0.0        0.06 ± 13%  perf-profile.self.cycles-pp.ptep_clear_flush_young
      0.15 ±  9%      -0.0        0.10 ±  4%      -0.0        0.13 ±  7%  perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.06 ±  7%      -0.0        0.02 ±141%      -0.0        0.06 ± 16%  perf-profile.self.cycles-pp.count_shadow_nodes
      0.11 ± 22%      -0.0        0.06 ± 23%      +0.0        0.11 ±  8%  perf-profile.self.cycles-pp.release_pages
      0.10 ± 21%      -0.0        0.05 ±  8%      -0.0        0.07        perf-profile.self.cycles-pp.xfs_read_iomap_begin
      0.08 ±  6%      -0.0        0.03 ± 70%      -0.0        0.06 ± 13%  perf-profile.self.cycles-pp.bio_associate_blkg_from_css
      0.11            -0.0        0.07 ±  7%      -0.0        0.09 ±  9%  perf-profile.self.cycles-pp.rmqueue_bulk
      0.14 ± 58%      -0.0        0.09 ± 36%      +0.0        0.16 ± 16%  perf-profile.self.cycles-pp.find_get_entries
      0.10 ±  4%      -0.0        0.06 ±  7%      -0.0        0.10 ±  4%  perf-profile.self.cycles-pp.try_charge
      0.04 ± 70%      -0.0        0.00            +0.0        0.06 ±  7%  perf-profile.self.cycles-pp.copy_user_enhanced_fast_string
      0.12            -0.0        0.08            -0.0        0.12 ±  4%  perf-profile.self.cycles-pp.__might_sleep
      0.10 ±  9%      -0.0        0.06            -0.0        0.09 ±  5%  perf-profile.self.cycles-pp.xas_find
      0.10 ±  4%      -0.0        0.07 ±  7%      -0.0        0.10        perf-profile.self.cycles-pp.iomap_readpage_actor
      0.09 ± 10%      -0.0        0.06 ±  8%      -0.0        0.08 ±  5%  perf-profile.self.cycles-pp.do_user_addr_fault
      0.05 ±  8%      -0.0        0.02 ±141%      -0.0        0.02 ±141%  perf-profile.self.cycles-pp.submit_bio_noacct
      0.13 ± 21%      -0.0        0.09 ± 13%      +0.0        0.14 ±  5%  perf-profile.self.cycles-pp.xas_store
      0.11 ±  4%      -0.0        0.08 ±  6%      -0.0        0.11        perf-profile.self.cycles-pp.rmap_walk_file
      0.10            -0.0        0.07 ±  7%      -0.0        0.09 ±  9%  perf-profile.self.cycles-pp.do_fault
      0.09            -0.0        0.06 ±  8%      +0.0        0.09        perf-profile.self.cycles-pp.kmem_cache_alloc
      0.03 ± 70%      -0.0        0.00            -0.0        0.02 ±141%  perf-profile.self.cycles-pp.__mod_lruvec_state
      0.03 ± 70%      -0.0        0.00            -0.0        0.02 ±141%  perf-profile.self.cycles-pp.__default_send_IPI_dest_field
      0.03 ± 70%      -0.0        0.00            +0.0        0.03 ± 70%  perf-profile.self.cycles-pp.check_pte
      0.03 ± 70%      -0.0        0.00            +0.0        0.04 ± 71%  perf-profile.self.cycles-pp.__delete_from_page_cache
      0.11 ±  8%      -0.0        0.07 ±  6%      +0.0        0.11 ±  8%  perf-profile.self.cycles-pp.___perf_sw_event
      0.09            -0.0        0.06            -0.0        0.08 ± 10%  perf-profile.self.cycles-pp.iomap_apply
      0.08 ± 10%      -0.0        0.05            -0.0        0.07 ±  6%  perf-profile.self.cycles-pp.rcu_all_qs
      0.08 ± 11%      -0.0        0.05 ±  8%      +0.0        0.08 ± 14%  perf-profile.self.cycles-pp.page_counter_cancel
      0.08            -0.0        0.05 ±  8%      +0.0        0.08        perf-profile.self.cycles-pp._cond_resched
      0.08 ± 20%      -0.0        0.06 ± 79%      +0.0        0.12 ± 26%  perf-profile.self.cycles-pp.__intel_pmu_enable_all
      0.08 ± 17%      -0.0        0.06 ± 16%      +0.0        0.08 ± 10%  perf-profile.self.cycles-pp.xas_clear_mark
      0.07 ±  6%      -0.0        0.05 ±  8%      +0.0        0.07 ±  6%  perf-profile.self.cycles-pp._raw_spin_unlock_irqrestore
      0.08 ±  6%      -0.0        0.06 ±  8%      +0.0        0.08 ± 10%  perf-profile.self.cycles-pp.PageHuge
      0.08            -0.0        0.06 ± 13%      -0.0        0.07 ± 14%  perf-profile.self.cycles-pp.read_tsc
      0.02 ±141%      -0.0        0.00            -0.0        0.00        perf-profile.self.cycles-pp.xfs_bmapi_update_map
      0.04 ± 71%      -0.0        0.02 ±141%      +0.0        0.05        perf-profile.self.cycles-pp.xas_init_marks
      0.07            -0.0        0.05            -0.0        0.06 ±  7%  perf-profile.self.cycles-pp._find_next_bit
      0.02 ±141%      -0.0        0.00            -0.0        0.00        perf-profile.self.cycles-pp.vmacache_find
      0.02 ±141%      -0.0        0.00            -0.0        0.00        perf-profile.self.cycles-pp.shmem_mapping
      0.02 ±141%      -0.0        0.00            -0.0        0.00        perf-profile.self.cycles-pp.mem_cgroup_iter
      0.02 ±141%      -0.0        0.00            -0.0        0.00        perf-profile.self.cycles-pp.xfs_filemap_fault
      0.02 ±141%      -0.0        0.00            -0.0        0.00        perf-profile.self.cycles-pp.mem_cgroup_page_lruvec
      0.02 ±141%      -0.0        0.00            +0.0        0.02 ±141%  perf-profile.self.cycles-pp.bio_endio
      0.03 ± 70%      -0.0        0.02 ±141%      +0.0        0.05 ±  8%  perf-profile.self.cycles-pp.shrink_inactive_list
      0.08 ± 16%      -0.0        0.06 ± 23%      +0.0        0.08        perf-profile.self.cycles-pp.xas_start
      0.10 ±  4%      -0.0        0.09 ± 23%      -0.0        0.08 ±  5%  perf-profile.self.cycles-pp.pmem_submit_bio
      0.07            -0.0        0.06 ± 29%      +0.0        0.08        perf-profile.self.cycles-pp.unaccount_page_cache_page
      0.08 ±  5%      -0.0        0.08 ± 40%      +0.0        0.09 ±  5%  perf-profile.self.cycles-pp.page_remove_rmap
      0.03 ±141%      -0.0        0.03 ±141%      +0.0        0.07 ± 17%  perf-profile.self.cycles-pp.invalidate_mapping_pages
      0.06            -0.0        0.05 ±  8%      -0.0        0.05 ±  8%  perf-profile.self.cycles-pp.pmem_do_read
      0.00            +0.0        0.00            +0.0        0.02 ±141%  perf-profile.self.cycles-pp.xfs_filemap_map_pages
      0.00            +0.0        0.00            +0.0        0.02 ±141%  perf-profile.self.cycles-pp.free_unref_page_list
      0.00            +0.0        0.00            +0.0        0.02 ±141%  perf-profile.self.cycles-pp.queue_event
      0.02 ±141%      +0.0        0.02 ±141%      +0.0        0.04 ± 76%  perf-profile.self.cycles-pp.pagevec_lru_move_fn
      0.02 ±141%      +0.0        0.02 ±141%      +0.0        0.05 ±  8%  perf-profile.self.cycles-pp.mem_cgroup_update_lru_size
      0.07 ±  7%      +0.0        0.08            -0.0        0.06 ±  8%  perf-profile.self.cycles-pp.percpu_counter_add_batch
      0.09 ±  5%      +0.0        0.13 ±  6%      +0.0        0.11 ±  4%  perf-profile.self.cycles-pp.__list_add_valid
      0.10 ± 19%      +0.1        0.17 ± 18%      -0.0        0.10 ±  8%  perf-profile.self.cycles-pp.smp_call_function_single
      0.18 ±  7%      +0.1        0.31 ±  5%      +0.0        0.21 ±  6%  perf-profile.self.cycles-pp.move_pages_to_lru
      0.24 ±  5%      +0.1        0.38 ±  6%      +0.1        0.37 ±  8%  perf-profile.self.cycles-pp.__pagevec_lru_add
      0.35            +0.2        0.54 ±  3%      +0.1        0.43        perf-profile.self.cycles-pp.isolate_lru_pages
      2.55            +1.1        3.70 ±  3%      +0.7        3.30 ±  3%  perf-profile.self.cycles-pp.smp_call_function_many_cond
     39.94 ±  2%     +10.1       50.03 ±  2%      +1.0       40.90        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
    365.67            +1.1%     369.67            -0.1%     365.33        softirqs.BLOCK
      6.67 ± 86%     -30.0%       4.67 ±141%     -95.0%       0.33 ±141%  softirqs.CPU0.BLOCK
      1.00            +0.0%       1.00            +0.0%       1.00        softirqs.CPU0.HI
      2.33 ±112%    +100.0%       4.67 ±112%     +28.6%       3.00 ± 54%  softirqs.CPU0.NET_RX
      0.00       +1.8e+103%      17.67 ±141% +6.7e+101%       0.67 ± 70%  softirqs.CPU0.NET_TX
     16900 ± 33%     +14.2%      19303 ± 27%     -42.6%       9706 ± 23%  softirqs.CPU0.RCU
     34359 ± 11%     -10.7%      30699 ±  8%     -10.9%      30605 ± 12%  softirqs.CPU0.SCHED
    105.00            +0.0%     105.00            +0.0%     105.00        softirqs.CPU0.TASKLET
      2833 ± 11%      +7.5%       3046 ±  3%     +30.7%       3703 ± 41%  softirqs.CPU0.TIMER
     12.33 ±135%     -78.4%       2.67 ±141%    -100.0%       0.00        softirqs.CPU1.BLOCK
      9.67 ± 57%     -89.7%       1.00 ±141%     -13.8%       8.33 ± 62%  softirqs.CPU1.NET_RX
     35.00 ± 68%     -99.0%       0.33 ±141%      -1.9%      34.33 ± 70%  softirqs.CPU1.NET_TX
     14913 ± 35%      -5.5%      14088 ± 36%     -49.0%       7598        softirqs.CPU1.RCU
     20175 ± 19%      -2.5%      19665 ± 35%     -26.5%      14821 ±  9%  softirqs.CPU1.SCHED
      0.00       +6.7e+101%       0.67 ±141%    -100.0%       0.00        softirqs.CPU1.TASKLET
    435.33 ± 35%     +12.4%     489.33 ± 17%     -14.0%     374.33 ± 54%  softirqs.CPU1.TIMER
      1.33 ± 35%      +0.0%       1.33 ± 35%     +25.0%       1.67 ± 28%  softirqs.CPU10.HI
      1.00 ± 81%   +1100.0%      12.00 ± 58%  +15866.7%     159.67 ±141%  softirqs.CPU10.NET_RX
      0.00         +2e+102%       2.00 ± 81% +3.3e+101%       0.33 ±141%  softirqs.CPU10.NET_TX
      6652 ±  7%     -11.9%       5857 ±  7%      -5.9%       6261 ±  2%  softirqs.CPU10.RCU
     14950 ± 18%     +12.4%      16806 ± 15%      -0.8%      14826 ± 16%  softirqs.CPU10.SCHED
     36.00            +6.5%      38.33 ±  4%      +0.0%      36.00        softirqs.CPU10.TASKLET
    145.67 ± 20%     +81.2%     264.00 ± 26%    +174.4%     399.67 ± 35%  softirqs.CPU10.TIMER
      0.00          -100.0%       0.00         +9e+102%       9.00 ±141%  softirqs.CPU11.BLOCK
      1.33 ±141%     +25.0%       1.67 ±101%    +200.0%       4.00 ±124%  softirqs.CPU11.NET_RX
      0.33 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU11.NET_TX
      6534 ± 10%     -19.0%       5292 ±  8%      -6.4%       6113 ±  6%  softirqs.CPU11.RCU
     14141 ± 12%     +18.8%      16793 ±  6%      -9.8%      12749 ± 29%  softirqs.CPU11.SCHED
      3.67 ± 64%     -45.5%       2.00           -45.5%       2.00        softirqs.CPU11.TASKLET
    226.00 ± 54%     -35.1%     146.67 ± 32%     -30.1%     158.00 ± 20%  softirqs.CPU11.TIMER
      0.00          -100.0%       0.00       +6.7e+102%       6.67 ±141%  softirqs.CPU12.BLOCK
      0.33 ±141%    +100.0%       0.67 ±141%   +1000.0%       3.67 ±122%  softirqs.CPU12.NET_RX
      0.00          -100.0%       0.00       +1.7e+102%       1.67 ±101%  softirqs.CPU12.NET_TX
      6326 ±  7%      +2.6%       6489 ± 18%      -3.2%       6124 ±  5%  softirqs.CPU12.RCU
     14685 ± 13%     -24.4%      11096 ± 39%      -5.4%      13885 ± 17%  softirqs.CPU12.SCHED
      9.00 ±109%     -77.8%       2.00           -77.8%       2.00        softirqs.CPU12.TASKLET
    847.67 ± 87%     -61.2%     329.00 ± 69%     -59.9%     340.00 ± 66%  softirqs.CPU12.TIMER
      8.33 ±124%     -76.0%       2.00 ± 70%    +396.0%      41.33 ±137%  softirqs.CPU13.NET_RX
      0.33 ±141%    +200.0%       1.00 ± 81%    +100.0%       0.67 ± 70%  softirqs.CPU13.NET_TX
      7025 ± 14%      -6.0%       6600 ± 17%      -4.5%       6708 ±  8%  softirqs.CPU13.RCU
     13141 ± 32%      -6.4%      12296 ± 40%      +4.0%      13668 ±  7%  softirqs.CPU13.SCHED
      2.67 ± 35%    +150.0%       6.67 ± 78%     -50.0%       1.33 ± 70%  softirqs.CPU13.TASKLET
    363.00 ± 97%     -58.3%     151.33 ± 31%     +81.5%     659.00 ± 72%  softirqs.CPU13.TIMER
      2.00 ±141%     +33.3%       2.67 ±141%    -100.0%       0.00        softirqs.CPU14.BLOCK
      2.00 ± 40%    +933.3%      20.67 ±114%     -66.7%       0.67 ± 70%  softirqs.CPU14.NET_RX
      1.67 ± 28%     -40.0%       1.00 ± 81%     -60.0%       0.67 ± 70%  softirqs.CPU14.NET_TX
      7908 ± 13%     -24.0%       6013 ±  2%     -14.5%       6763 ±  7%  softirqs.CPU14.RCU
     16706 ± 22%     -17.6%      13766 ± 32%     -28.9%      11873 ± 19%  softirqs.CPU14.SCHED
      3.00 ± 47%    +166.7%       8.00 ±106%     -11.1%       2.67 ± 35%  softirqs.CPU14.TASKLET
    929.00 ± 38%     -81.3%     174.00 ± 34%     -56.8%     401.67 ± 57%  softirqs.CPU14.TIMER
     13.33 ±141%     -60.0%       5.33 ±141%    -100.0%       0.00        softirqs.CPU15.BLOCK
    110.33 ±134%     -98.5%       1.67 ± 74%     -98.8%       1.33 ± 35%  softirqs.CPU15.NET_RX
      3.33 ± 56%     -80.0%       0.67 ± 70%     -80.0%       0.67 ± 70%  softirqs.CPU15.NET_TX
      7358 ±  9%     -13.8%       6342 ±  8%     -10.2%       6608 ±  4%  softirqs.CPU15.RCU
     13227 ±  4%     -12.1%      11626 ± 13%     +11.4%      14733 ± 12%  softirqs.CPU15.SCHED
      6.33 ± 66%     -68.4%       2.00           -78.9%       1.33 ± 70%  softirqs.CPU15.TASKLET
    635.00 ± 36%     -57.0%     273.33 ± 79%     -69.3%     194.67 ± 49%  softirqs.CPU15.TIMER
      2.67 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU16.BLOCK
      3.33 ± 37%    +350.0%      15.00 ±127%     -60.0%       1.33 ± 35%  softirqs.CPU16.NET_RX
      0.33 ±141%    +200.0%       1.00 ± 81%    +100.0%       0.67 ± 70%  softirqs.CPU16.NET_TX
      6858 ±  3%     -12.4%       6009 ± 10%      -7.5%       6343 ±  2%  softirqs.CPU16.RCU
     13320 ± 19%     +23.0%      16389 ± 15%     +39.1%      18522 ± 10%  softirqs.CPU16.SCHED
      2.67 ± 70%     -25.0%       2.00           -25.0%       2.00        softirqs.CPU16.TASKLET
    510.00 ±  8%      +4.9%     535.00 ±110%    +183.9%       1448 ± 25%  softirqs.CPU16.TIMER
     48.33 ±141%     -77.9%      10.67 ± 93%     -26.2%      35.67 ±141%  softirqs.CPU17.BLOCK
      2.67 ± 46%     -62.5%       1.00 ± 81%   +6387.5%     173.00 ±141%  softirqs.CPU17.NET_RX
      0.67 ± 70%     +50.0%       1.00 ± 81%     -50.0%       0.33 ±141%  softirqs.CPU17.NET_TX
      6084 ±  4%      -4.4%       5816 ±  2%     +14.4%       6958 ± 10%  softirqs.CPU17.RCU
     16228 ± 31%     -17.3%      13420 ± 23%     -11.5%      14367 ± 38%  softirqs.CPU17.SCHED
      0.00       +1.3e+102%       1.33 ± 70% +1.3e+103%      13.33 ±120%  softirqs.CPU17.TASKLET
      1565 ±116%     -89.9%     157.67 ± 33%     -31.6%       1070 ±100%  softirqs.CPU17.TIMER
    119.00 ± 72%      -7.0%     110.67 ± 23%     -97.8%       2.67 ±141%  softirqs.CPU18.BLOCK
      1.00 ± 81%      +0.0%       1.00 ±141%     +33.3%       1.33 ± 35%  softirqs.CPU18.NET_RX
      1.00 ± 81%     -66.7%       0.33 ±141%      +0.0%       1.00        softirqs.CPU18.NET_TX
      6306 ±  9%      +9.9%       6927 ± 13%      +4.6%       6596 ± 11%  softirqs.CPU18.RCU
     14761 ±  6%     -14.4%      12634 ±  8%      +0.2%      14789 ± 20%  softirqs.CPU18.SCHED
      0.00       +3.3e+101%       0.33 ±141% +6.7e+101%       0.67 ±141%  softirqs.CPU18.TASKLET
    401.67 ± 83%     -66.0%     136.67 ± 20%    +139.3%     961.33 ± 45%  softirqs.CPU18.TIMER
      0.00         +4e+102%       4.00 ±141% +3.5e+103%      35.33 ±141%  softirqs.CPU19.BLOCK
      2.00        +50416.7%       1010 ±141%     -50.0%       1.00 ± 81%  softirqs.CPU19.NET_RX
      0.33 ±141%    +100.0%       0.67 ± 70%    +100.0%       0.67 ± 70%  softirqs.CPU19.NET_TX
      7100 ± 12%      -5.8%       6686 ± 10%      -3.5%       6852 ±  7%  softirqs.CPU19.RCU
      9904 ±  4%      -8.1%       9102 ± 19%     +43.8%      14245 ± 16%  softirqs.CPU19.SCHED
     16.67 ±141%     -98.0%       0.33 ±141%    -100.0%       0.00        softirqs.CPU19.TASKLET
    634.67 ± 52%     -62.7%     237.00 ± 71%    +144.5%       1552 ±107%  softirqs.CPU19.TIMER
      2.33 ±112%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU2.BLOCK
    763.67 ± 75%     -99.8%       1.67 ± 28%     -98.9%       8.67 ±125%  softirqs.CPU2.NET_RX
      1.33 ± 70%     -75.0%       0.33 ±141%     -25.0%       1.00 ± 81%  softirqs.CPU2.NET_TX
      8301 ±  4%     -14.8%       7074           -14.8%       7071 ±  4%  softirqs.CPU2.RCU
     18699 ±  9%      -6.6%      17459 ± 18%     -17.6%      15409 ±  9%  softirqs.CPU2.SCHED
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        softirqs.CPU2.TASKLET
    888.67 ± 35%     -71.5%     253.33 ± 22%     -64.0%     320.00 ± 58%  softirqs.CPU2.TIMER
      0.00          -100.0%       0.00       +7.2e+103%      72.33 ±138%  softirqs.CPU20.BLOCK
      2.00 ± 40%   +9750.0%     197.00 ±131%     +33.3%       2.67 ± 17%  softirqs.CPU20.NET_RX
      1.33 ± 35%     -25.0%       1.00 ±141%     -25.0%       1.00 ± 81%  softirqs.CPU20.NET_TX
      6880 ±  8%     -12.2%       6040 ±  9%      -8.7%       6283 ±  9%  softirqs.CPU20.RCU
     12458 ± 14%      +5.0%      13080 ± 22%      +8.5%      13515 ± 18%  softirqs.CPU20.SCHED
      0.00       +3.3e+101%       0.33 ±141% +3.3e+101%       0.33 ±141%  softirqs.CPU20.TASKLET
    280.67 ± 68%    +104.3%     573.33 ±111%     +44.9%     406.67 ± 58%  softirqs.CPU20.TIMER
      0.67 ±141%    -100.0%       0.00          +300.0%       2.67 ±141%  softirqs.CPU21.BLOCK
      2.33 ± 88%     +57.1%       3.67 ± 64%     -57.1%       1.00 ± 81%  softirqs.CPU21.NET_RX
      1.33 ± 70%      +0.0%       1.33 ± 93%     -75.0%       0.33 ±141%  softirqs.CPU21.NET_TX
      6444 ±  3%      -5.2%       6111 ± 11%      +1.6%       6544 ±  5%  softirqs.CPU21.RCU
     15529 ± 13%     -10.2%      13946 ± 20%     -33.4%      10346 ± 23%  softirqs.CPU21.SCHED
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        softirqs.CPU21.TASKLET
    594.00 ± 61%     -18.6%     483.67 ± 31%     -59.8%     238.67 ± 37%  softirqs.CPU21.TIMER
      0.67 ±141%    -100.0%       0.00         +1250.0%       9.00 ±133%  softirqs.CPU22.BLOCK
     14.33 ±112%     -88.4%       1.67 ±101%    -100.0%       0.00        softirqs.CPU22.NET_RX
      2.33 ± 53%     -85.7%       0.33 ±141%    -100.0%       0.00        softirqs.CPU22.NET_TX
      6533 ± 10%      -6.1%       6133 ±  9%      -8.7%       5962 ±  5%  softirqs.CPU22.RCU
     15098 ± 14%     -17.9%      12391 ± 30%      -7.5%      13970 ± 23%  softirqs.CPU22.SCHED
      0.33 ±141%      +0.0%       0.33 ±141%    -100.0%       0.00        softirqs.CPU22.TASKLET
    391.00 ± 76%      -9.5%     353.67 ± 66%     -49.4%     197.67 ± 38%  softirqs.CPU22.TIMER
      2.00 ± 81%     +16.7%       2.33 ± 20%     -16.7%       1.67 ± 74%  softirqs.CPU23.NET_RX
      0.33 ±141%    +300.0%       1.33 ± 35%      +0.0%       0.33 ±141%  softirqs.CPU23.NET_TX
      6869 ±  8%      -7.8%       6337 ±  5%      +1.0%       6941 ±  7%  softirqs.CPU23.RCU
     11180 ±  2%     +21.7%      13609 ± 22%     +33.2%      14896 ± 21%  softirqs.CPU23.SCHED
      0.33 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU23.TASKLET
    227.00 ± 54%     -50.7%     112.00           -26.9%     166.00 ± 18%  softirqs.CPU23.TIMER
      9.00 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU24.BLOCK
      0.33 ±141%  +19400.0%      65.00 ± 94%   +9800.0%      33.00 ±128%  softirqs.CPU24.NET_RX
      0.00         +2e+102%       2.00 ±108%   +1e+102%       1.00 ± 81%  softirqs.CPU24.NET_TX
      8332 ± 12%     -18.2%       6818 ± 25%     +10.6%       9213 ± 16%  softirqs.CPU24.RCU
     15181 ± 20%     -20.6%      12050 ± 13%      -4.0%      14569 ± 18%  softirqs.CPU24.SCHED
      0.00          -100.0%       0.00          -100.0%       0.00        softirqs.CPU24.TASKLET
      2183 ±117%     -77.9%     483.33 ± 49%     -59.2%     890.33 ± 91%  softirqs.CPU24.TIMER
      9.00 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU25.BLOCK
      1.67 ±141%   +2860.0%      49.33 ± 84%    +300.0%       6.67 ± 79%  softirqs.CPU25.NET_RX
      0.67 ±141%     +50.0%       1.00 ±141%      +0.0%       0.67 ±141%  softirqs.CPU25.NET_TX
      6830 ±  7%      +0.6%       6868 ±  8%     +11.9%       7644        softirqs.CPU25.RCU
     12351 ± 16%      -3.3%      11943 ± 17%      +9.2%      13482 ±  4%  softirqs.CPU25.SCHED
      0.00          -100.0%       0.00          -100.0%       0.00        softirqs.CPU25.TASKLET
    660.00 ± 96%      -7.8%     608.33 ± 76%     -77.8%     146.33 ±  7%  softirqs.CPU25.TIMER
      0.00          -100.0%       0.00         +1e+102%       1.00 ±141%  softirqs.CPU26.BLOCK
      0.33 ±141%  +24300.0%      81.33 ±141%    +500.0%       2.00 ± 70%  softirqs.CPU26.NET_RX
      0.00          -100.0%       0.00       +6.7e+101%       0.67 ± 70%  softirqs.CPU26.NET_TX
      6728 ±  6%     +12.0%       7535 ± 36%     +15.1%       7741 ±  9%  softirqs.CPU26.RCU
     12526 ±  3%      +7.9%      13516 ± 18%      +6.9%      13387 ± 11%  softirqs.CPU26.SCHED
      2.00            +0.0%       2.00            +0.0%       2.00        softirqs.CPU26.TASKLET
    783.67 ± 61%      -1.1%     775.33 ± 61%     -69.4%     240.00 ± 31%  softirqs.CPU26.TIMER
      0.00       +6.3e+102%       6.33 ±141%    -100.0%       0.00        softirqs.CPU27.BLOCK
      0.33 ±141%    +300.0%       1.33 ± 70%      +0.0%       0.33 ±141%  softirqs.CPU27.NET_RX
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        softirqs.CPU27.NET_TX
      7577 ± 13%     -10.0%       6820 ± 18%      -6.3%       7098 ±  7%  softirqs.CPU27.RCU
     12117 ±  9%     +21.3%      14696 ±  6%      +7.6%      13037 ± 16%  softirqs.CPU27.SCHED
      2.00            +0.0%       2.00            +0.0%       2.00        softirqs.CPU27.TASKLET
    166.33 ± 12%    +513.4%       1020 ± 35%     +89.8%     315.67 ± 39%  softirqs.CPU27.TIMER
      1.00 ±141%    +700.0%       8.00 ±141%    -100.0%       0.00        softirqs.CPU28.BLOCK
      0.00          -100.0%       0.00       +3.3e+102%       3.33 ±101%  softirqs.CPU28.NET_RX
      0.00          -100.0%       0.00       +1.3e+102%       1.33 ± 93%  softirqs.CPU28.NET_TX
      7672 ± 21%     -10.1%       6897 ± 11%     -11.8%       6763 ± 15%  softirqs.CPU28.RCU
     10936 ±  4%      +4.9%      11472 ±  3%     +50.5%      16462 ± 23%  softirqs.CPU28.SCHED
      2.33 ± 20%     -14.3%       2.00           -14.3%       2.00        softirqs.CPU28.TASKLET
    198.00 ± 16%     +60.9%     318.67 ± 30%     +75.3%     347.00 ± 55%  softirqs.CPU28.TIMER
      0.00       +6.7e+101%       0.67 ±141%    -100.0%       0.00        softirqs.CPU29.BLOCK
      0.00       +6.6e+103%      65.67 ± 89%    -100.0%       0.00        softirqs.CPU29.NET_RX
      7357 ± 22%      -0.6%       7314 ±  9%      -5.4%       6959 ±  6%  softirqs.CPU29.RCU
     12415 ± 21%      -3.0%      12043 ± 16%     +15.9%      14386 ±  2%  softirqs.CPU29.SCHED
      2.00            +0.0%       2.00           +16.7%       2.33 ± 20%  softirqs.CPU29.TASKLET
    443.33 ± 76%     -41.6%     259.00 ± 21%      -9.3%     402.00 ± 55%  softirqs.CPU29.TIMER
      0.00          -100.0%       0.00       +3.7e+102%       3.67 ±141%  softirqs.CPU3.BLOCK
      6.33 ± 97%     +68.4%      10.67 ± 74%    +263.2%      23.00 ±132%  softirqs.CPU3.NET_RX
     17.67 ±133%      -1.9%      17.33 ±141%     -98.1%       0.33 ±141%  softirqs.CPU3.NET_TX
      7023 ± 10%      -5.4%       6643 ± 10%      -8.2%       6448 ±  5%  softirqs.CPU3.RCU
     15583 ±  9%      -4.4%      14901 ± 20%     -11.5%      13789 ±  5%  softirqs.CPU3.SCHED
      0.00       +5.3e+102%       5.33 ±141%    -100.0%       0.00        softirqs.CPU3.TASKLET
    316.67 ± 58%     +55.3%     491.67 ± 38%    +259.9%       1139 ± 64%  softirqs.CPU3.TIMER
      0.00       +6.7e+101%       0.67 ±141%    -100.0%       0.00        softirqs.CPU30.BLOCK
      0.67 ±141%    +200.0%       2.00 ±108%   +3200.0%      22.00 ±141%  softirqs.CPU30.NET_RX
      0.00          -100.0%       0.00         +2e+102%       2.00 ±141%  softirqs.CPU30.NET_TX
      6522 ± 14%      -3.8%       6275 ±  2%     +12.3%       7328 ± 13%  softirqs.CPU30.RCU
     14681 ±  8%     +26.7%      18607 ± 34%     -13.3%      12722 ± 16%  softirqs.CPU30.SCHED
      2.00           -16.7%       1.67 ± 28%     +33.3%       2.67 ± 35%  softirqs.CPU30.TASKLET
    312.67 ± 57%   +1466.2%       4897 ±129%      +3.3%     323.00 ± 42%  softirqs.CPU30.TIMER
      0.00         +4e+102%       4.00 ±141% +7.7e+102%       7.67 ±141%  softirqs.CPU31.BLOCK
     22.67 ±138%    -100.0%       0.00           -55.9%      10.00 ±114%  softirqs.CPU31.NET_RX
      0.33 ±141%    -100.0%       0.00          +200.0%       1.00 ± 81%  softirqs.CPU31.NET_TX
      7019 ±  5%     -16.9%       5834 ± 14%      -7.4%       6502 ± 22%  softirqs.CPU31.RCU
     10887 ± 17%     +39.4%      15174 ± 12%     +10.8%      12063 ± 43%  softirqs.CPU31.SCHED
      2.67 ± 35%     -25.0%       2.00           -25.0%       2.00        softirqs.CPU31.TASKLET
    705.67 ± 38%     +66.4%       1174 ± 44%      +7.3%     757.00 ± 73%  softirqs.CPU31.TIMER
      0.00       +2.3e+103%      23.00 ±141% +6.7e+101%       0.67 ±141%  softirqs.CPU32.BLOCK
      1.00 ±141%    -100.0%       0.00          +200.0%       3.00 ± 27%  softirqs.CPU32.NET_RX
      0.33 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU32.NET_TX
      7019 ± 10%     -22.5%       5437 ± 16%      -4.7%       6687 ± 14%  softirqs.CPU32.RCU
     11972 ± 13%     +47.7%      17683 ±  8%     +43.2%      17147 ± 13%  softirqs.CPU32.SCHED
      2.00           +16.7%       2.33 ± 20%      +0.0%       2.00        softirqs.CPU32.TASKLET
    336.33 ± 48%    +182.6%     950.33 ± 53%    +338.5%       1474 ± 37%  softirqs.CPU32.TIMER
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        softirqs.CPU33.BLOCK
     28.00 ±138%   +3128.6%     904.00 ±141%     -23.8%      21.33 ±134%  softirqs.CPU33.NET_RX
      0.00          -100.0%       0.00       +6.7e+101%       0.67 ±141%  softirqs.CPU33.NET_TX
      7107 ±  7%     -11.2%       6312 ±  2%      -7.6%       6569 ±  7%  softirqs.CPU33.RCU
     14106 ± 16%     -10.1%      12678 ± 18%      +5.9%      14943 ±  3%  softirqs.CPU33.SCHED
      1.33 ± 70%     +50.0%       2.00           +75.0%       2.33 ± 20%  softirqs.CPU33.TASKLET
      1461 ±106%     -67.4%     476.67 ± 56%     -36.1%     933.67 ± 84%  softirqs.CPU33.TIMER
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        softirqs.CPU34.NET_RX
      6175 ±  6%      -2.2%       6040 ±  9%      +5.5%       6513 ±  5%  softirqs.CPU34.RCU
     12488 ± 12%     +18.4%      14786 ± 23%     +35.6%      16940 ± 22%  softirqs.CPU34.SCHED
      1.00 ±141%    -100.0%       0.00           -66.7%       0.33 ±141%  softirqs.CPU34.TASKLET
    505.67 ± 49%      -1.6%     497.67 ± 43%    +170.5%       1368 ± 29%  softirqs.CPU34.TIMER
      0.00       +9.3e+102%       9.33 ±141%    -100.0%       0.00        softirqs.CPU35.BLOCK
    305.00 ±141%     -99.5%       1.67 ±141%     -99.3%       2.00 ± 81%  softirqs.CPU35.NET_RX
      0.00       +3.3e+101%       0.33 ±141% +6.7e+101%       0.67 ±141%  softirqs.CPU35.NET_TX
      6710 ±  6%      -2.3%       6553 ±  3%      -0.1%       6703 ±  9%  softirqs.CPU35.RCU
     12848 ± 32%      +2.3%      13146 ± 26%     +10.9%      14254 ±  7%  softirqs.CPU35.SCHED
    975.67 ± 60%      -5.7%     920.00 ± 81%     -42.4%     562.33 ± 44%  softirqs.CPU35.TIMER
      0.00          -100.0%       0.00       +5.7e+102%       5.67 ±141%  softirqs.CPU36.BLOCK
      5.67 ±141%    -100.0%       0.00          +358.8%      26.00 ±141%  softirqs.CPU36.NET_RX
      0.00          -100.0%       0.00       +6.7e+101%       0.67 ±141%  softirqs.CPU36.NET_TX
      7024 ± 14%     -22.9%       5413 ±  6%      -4.3%       6723 ±  2%  softirqs.CPU36.RCU
     12339 ±  4%     +50.2%      18532 ± 10%     +22.2%      15074 ±  6%  softirqs.CPU36.SCHED
      0.00       +1.9e+103%      18.67 ±126%    -100.0%       0.00        softirqs.CPU36.TASKLET
    274.33 ± 22%    +507.3%       1666 ± 47%      -7.2%     254.67 ± 33%  softirqs.CPU36.TIMER
      0.33 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU37.BLOCK
      1.00 ±141%     +66.7%       1.67 ± 28%     -66.7%       0.33 ±141%  softirqs.CPU37.NET_RX
      0.67 ±141%     -50.0%       0.33 ±141%    -100.0%       0.00        softirqs.CPU37.NET_TX
      6858 ± 23%     -10.9%       6113 ± 11%      -7.4%       6351 ±  2%  softirqs.CPU37.RCU
     16000 ±  9%      -8.7%      14607 ± 21%      -7.6%      14787 ± 22%  softirqs.CPU37.SCHED
    370.00 ± 44%      -2.4%     361.00 ± 30%     +60.0%     592.00 ± 95%  softirqs.CPU37.TIMER
      0.00       +6.7e+101%       0.67 ±141%    -100.0%       0.00        softirqs.CPU38.BLOCK
      0.00          -100.0%       0.00         +2e+104%     202.00 ±141%  softirqs.CPU38.NET_RX
      0.00          -100.0%       0.00          -100.0%       0.00        softirqs.CPU38.NET_TX
      6978 ± 11%     -11.3%       6192 ±  5%      +1.5%       7080 ±  9%  softirqs.CPU38.RCU
     14448 ±  9%     -33.4%       9622 ± 25%      -5.0%      13726 ± 23%  softirqs.CPU38.SCHED
    935.00 ± 79%     -60.9%     365.67 ± 93%     -28.5%     668.67 ± 40%  softirqs.CPU38.TIMER
      7.67 ±141%    +843.5%      72.33 ±135%    +126.1%      17.33 ±133%  softirqs.CPU39.NET_RX
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU39.NET_TX
      7012 ± 19%     -19.2%       5669 ±  5%      -0.8%       6956 ± 12%  softirqs.CPU39.RCU
     14687 ± 15%     -13.7%      12677 ± 21%     -12.1%      12904 ± 23%  softirqs.CPU39.SCHED
      0.33 ±141%      +0.0%       0.33 ±141%    -100.0%       0.00        softirqs.CPU39.TASKLET
    796.67 ± 57%     -64.4%     283.33 ± 75%     -35.2%     516.00 ± 29%  softirqs.CPU39.TIMER
      2.67 ±141%     -75.0%       0.67 ±141%    -100.0%       0.00        softirqs.CPU4.BLOCK
    786.33 ±141%     -99.7%       2.33 ± 88%     -99.9%       0.67 ± 70%  softirqs.CPU4.NET_RX
      0.00       +3.3e+101%       0.33 ±141% +3.3e+101%       0.33 ±141%  softirqs.CPU4.NET_TX
      7449 ±  8%     -19.3%       6012 ±  6%     -14.4%       6376 ± 11%  softirqs.CPU4.RCU
     17086 ± 27%     +32.4%      22620 ±  7%      -0.3%      17034 ± 10%  softirqs.CPU4.SCHED
      1.33 ± 93%     -50.0%       0.67 ±141%    -100.0%       0.00        softirqs.CPU4.TASKLET
    566.00 ± 91%     +36.0%     769.67 ± 66%      -9.2%     514.00 ± 51%  softirqs.CPU4.TIMER
      3.67 ±141%    -100.0%       0.00          +172.7%      10.00 ±141%  softirqs.CPU40.BLOCK
      1.00 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU40.NET_RX
      0.00          -100.0%       0.00          -100.0%       0.00        softirqs.CPU40.NET_TX
      6867 ±  5%      -7.1%       6380            -5.8%       6467 ±  3%  softirqs.CPU40.RCU
     12344 ± 28%     -12.0%      10868 ± 23%     +28.3%      15834 ±  9%  softirqs.CPU40.SCHED
      0.33 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU40.TASKLET
    653.33 ±100%     -69.7%     198.00 ± 45%     -55.9%     288.00 ± 39%  softirqs.CPU40.TIMER
      0.33 ±141%    -100.0%       0.00            +0.0%       0.33 ±141%  softirqs.CPU41.BLOCK
      0.00       +2.5e+103%      25.33 ±138%    -100.0%       0.00        softirqs.CPU41.NET_RX
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        softirqs.CPU41.NET_TX
      7048 ± 14%     -15.8%       5934 ±  3%      +0.8%       7105 ± 11%  softirqs.CPU41.RCU
     10932 ± 10%      +1.0%      11039 ± 31%      -8.4%      10009 ±  9%  softirqs.CPU41.SCHED
      0.00         +1e+103%      10.00 ±141% +3.3e+101%       0.33 ±141%  softirqs.CPU41.TASKLET
    529.00 ± 71%     -65.2%     184.00 ± 41%     -20.2%     422.00 ± 29%  softirqs.CPU41.TIMER
      4.00 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU42.BLOCK
     20.00 ±134%     -60.0%       8.00 ±141%      +5.0%      21.00 ± 83%  softirqs.CPU42.NET_RX
      0.00       +6.7e+101%       0.67 ±141%    -100.0%       0.00        softirqs.CPU42.NET_TX
      6650 ± 11%      +2.9%       6844 ±  3%      +7.4%       7139 ± 18%  softirqs.CPU42.RCU
     12259 ± 24%     -11.8%      10811 ± 43%     +15.4%      14143 ± 30%  softirqs.CPU42.SCHED
      0.33 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU42.TASKLET
    483.33 ± 55%     -42.6%     277.33 ± 19%    +136.6%       1143 ±115%  softirqs.CPU42.TIMER
      0.00          -100.0%       0.00       +1.4e+103%      14.00 ±141%  softirqs.CPU43.BLOCK
     20.67 ±138%     -95.2%       1.00 ±141%    -100.0%       0.00        softirqs.CPU43.NET_RX
      0.67 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU43.NET_TX
      7227 ±  3%     -16.5%       6035 ±  8%      -5.0%       6867 ± 20%  softirqs.CPU43.RCU
     10474 ± 23%     +18.5%      12413 ± 21%      +9.7%      11494 ± 15%  softirqs.CPU43.SCHED
      6.00 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU43.TASKLET
    925.33 ± 36%     -56.5%     402.33 ±  7%     -52.8%     436.33 ± 55%  softirqs.CPU43.TIMER
      0.00       +1.7e+103%      16.67 ±124%    -100.0%       0.00        softirqs.CPU44.BLOCK
      2.00 ±108%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU44.NET_RX
      0.67 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU44.NET_TX
      6937 ±  8%     -11.3%       6152 ±  3%      +6.7%       7403 ± 10%  softirqs.CPU44.RCU
     10911 ± 10%     +13.2%      12351 ±  5%     +20.6%      13162 ±  5%  softirqs.CPU44.SCHED
    233.67 ± 40%     +50.8%     352.33 ± 56%    +144.9%     572.33 ± 54%  softirqs.CPU44.TIMER
      0.67 ±141%    -100.0%       0.00         +2150.0%      15.00 ±132%  softirqs.CPU45.BLOCK
    113.00 ±141%     -92.0%       9.00 ±141%     -99.1%       1.00 ± 81%  softirqs.CPU45.NET_RX
      0.00       +6.7e+101%       0.67 ±141%    -100.0%       0.00        softirqs.CPU45.NET_TX
      6643 ±  9%      +1.0%       6707 ±  6%     +17.9%       7834 ± 14%  softirqs.CPU45.RCU
     13091 ± 11%      -5.5%      12367 ± 19%      -9.0%      11907 ± 28%  softirqs.CPU45.SCHED
    342.67 ± 34%     +85.9%     637.00 ±113%    +139.7%     821.33 ± 94%  softirqs.CPU45.TIMER
      0.33 ±141%    -100.0%       0.00         +2800.0%       9.67 ±100%  softirqs.CPU46.NET_RX
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU46.NET_TX
      6582 ±  7%      +2.6%       6750 ±  7%     +21.8%       8017 ± 25%  softirqs.CPU46.RCU
     13846 ± 15%     -13.9%      11922 ± 23%      -0.3%      13808 ±  2%  softirqs.CPU46.SCHED
      1.33 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU46.TASKLET
    791.33 ± 69%     +30.9%       1036 ±124%     +88.6%       1492 ±119%  softirqs.CPU46.TIMER
      0.00       +9.3e+102%       9.33 ±141% +1.6e+103%      15.67 ± 73%  softirqs.CPU47.BLOCK
      0.00       +3.3e+101%       0.33 ±141%   +2e+102%       2.00 ±108%  softirqs.CPU47.NET_RX
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU47.NET_TX
      6950 ±  2%     -16.7%       5790 ±  7%     +21.1%       8416 ± 12%  softirqs.CPU47.RCU
     10347 ± 12%     +34.4%      13911 ± 32%      -4.6%       9874 ±  2%  softirqs.CPU47.SCHED
    343.00 ± 29%    +309.9%       1406 ±120%     +56.3%     536.00 ± 64%  softirqs.CPU47.TIMER
      2.00 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU48.BLOCK
      6843 ±141%    -100.0%       0.00          -100.0%       2.00 ± 70%  softirqs.CPU48.NET_RX
      0.67 ± 70%    -100.0%       0.00            +0.0%       0.67 ± 70%  softirqs.CPU48.NET_TX
      8282 ± 30%     -31.7%       5659 ±  2%     -25.1%       6200 ± 11%  softirqs.CPU48.RCU
     13803 ± 37%      -7.9%      12706 ± 11%     -13.1%      11999 ± 35%  softirqs.CPU48.SCHED
      0.33 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU48.TASKLET
      1591 ±119%     -89.2%     172.33 ± 22%     -68.3%     504.33 ± 69%  softirqs.CPU48.TIMER
      8.00 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU49.BLOCK
      1.00 ± 81%  +1.9e+05%       1927 ±141%      +0.0%       1.00 ± 81%  softirqs.CPU49.NET_RX
      0.67 ± 70%      +0.0%       0.67 ±141%    -100.0%       0.00        softirqs.CPU49.NET_TX
      7482 ± 10%     -19.0%       6061 ± 23%     -18.7%       6082 ±  8%  softirqs.CPU49.RCU
     13065 ± 17%     +19.8%      15654 ±  8%     +14.6%      14972 ± 11%  softirqs.CPU49.SCHED
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        softirqs.CPU49.TASKLET
      1174 ±118%     -19.9%     940.33 ± 63%     -74.7%     297.67 ± 53%  softirqs.CPU49.TIMER
      2.00 ±141%    +533.3%      12.67 ±100%    -100.0%       0.00        softirqs.CPU5.BLOCK
      1.67 ±101%     -60.0%       0.67 ±141%     -80.0%       0.33 ±141%  softirqs.CPU5.NET_RX
      0.33 ±141%    +100.0%       0.67 ± 70%      +0.0%       0.33 ±141%  softirqs.CPU5.NET_TX
      6100 ±  5%      +0.2%       6113            +3.7%       6326 ±  8%  softirqs.CPU5.RCU
     16920 ±  9%     -11.6%      14949 ± 12%      -4.6%      16135 ± 22%  softirqs.CPU5.SCHED
      0.67 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU5.TASKLET
    495.00 ± 58%     -72.5%     136.00 ± 18%     -47.0%     262.33 ± 42%  softirqs.CPU5.TIMER
    393.33 ±136%     -98.5%       6.00 ±117%     -99.7%       1.33 ± 35%  softirqs.CPU50.NET_RX
      1.00           -33.3%       0.67 ± 70%     -66.7%       0.33 ±141%  softirqs.CPU50.NET_TX
      6365 ±  7%      -4.6%       6069 ±  5%      +0.2%       6376 ±  2%  softirqs.CPU50.RCU
     14683 ±  8%      -7.0%      13649 ± 32%      -6.8%      13682 ± 15%  softirqs.CPU50.SCHED
      0.00          -100.0%       0.00       +6.7e+101%       0.67 ±141%  softirqs.CPU50.TASKLET
    860.00 ± 98%     -66.4%     289.33 ± 67%     -55.0%     387.00 ± 39%  softirqs.CPU50.TIMER
      4.33 ±141%    -100.0%       0.00          +415.4%      22.33 ±141%  softirqs.CPU51.BLOCK
      9.33 ±118%   +3496.4%     335.67 ±140%     -96.4%       0.33 ±141%  softirqs.CPU51.NET_RX
      2.00 ± 40%     -33.3%       1.33 ± 35%    -100.0%       0.00        softirqs.CPU51.NET_TX
      6990 ±  7%     -10.5%       6256 ±  9%      -4.8%       6651 ± 10%  softirqs.CPU51.RCU
     13292 ± 23%      +9.9%      14604 ± 28%      +8.2%      14384 ± 22%  softirqs.CPU51.SCHED
      1229 ±127%     -10.7%       1097 ±124%     -78.4%     266.00 ± 41%  softirqs.CPU51.TIMER
      0.00         +2e+102%       2.00 ±141%    -100.0%       0.00        softirqs.CPU52.BLOCK
     47.67 ±134%     -93.7%       3.00 ± 94%     -86.7%       6.33 ±130%  softirqs.CPU52.NET_RX
      2.67 ±115%     -50.0%       1.33 ± 93%     -75.0%       0.67 ± 70%  softirqs.CPU52.NET_TX
      7553 ±  4%      -9.8%       6811 ±  8%     -10.6%       6749        softirqs.CPU52.RCU
     12471 ± 16%     -41.9%       7242 ± 26%      +1.1%      12605 ±  9%  softirqs.CPU52.SCHED
      0.67 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU52.TASKLET
    224.33 ± 50%    +727.6%       1856 ± 85%     +29.4%     290.33 ± 85%  softirqs.CPU52.TIMER
      0.33 ±141%    +500.0%       2.00 ±141%    -100.0%       0.00        softirqs.CPU53.BLOCK
     48.00 ±135%     -97.2%       1.33 ± 35%      +7.6%      51.67 ±138%  softirqs.CPU53.NET_RX
      1.67 ± 74%     -40.0%       1.00 ± 81%      +0.0%       1.67 ±101%  softirqs.CPU53.NET_TX
      7075 ± 11%     -22.0%       5517 ±  4%      -7.4%       6554 ±  7%  softirqs.CPU53.RCU
     10482 ± 14%     +25.3%      13138 ± 13%     +21.0%      12682 ± 25%  softirqs.CPU53.SCHED
    233.00 ± 39%     -19.0%     188.67 ± 58%      +5.9%     246.67 ± 45%  softirqs.CPU53.TIMER
      3.33 ±101%    -100.0%       0.00           -90.0%       0.33 ±141%  softirqs.CPU54.BLOCK
     53.67 ± 65%      -7.5%      49.67 ±130%     -15.5%      45.33 ±121%  softirqs.CPU54.NET_RX
      3.00 ± 72%     -11.1%       2.67 ±115%     -33.3%       2.00 ±108%  softirqs.CPU54.NET_TX
      7188 ±  7%     -21.4%       5649 ±  7%      -4.3%       6879 ±  7%  softirqs.CPU54.RCU
     13591 ±  7%     +17.0%      15898 ± 24%      -2.3%      13276 ± 20%  softirqs.CPU54.SCHED
      1.33 ± 93%    -100.0%       0.00           -75.0%       0.33 ±141%  softirqs.CPU54.TASKLET
    848.33 ± 55%     -83.2%     142.67 ± 43%     -53.9%     390.67 ± 47%  softirqs.CPU54.TIMER
      4.00 ±141%     -33.3%       2.67 ±141%    -100.0%       0.00        softirqs.CPU55.BLOCK
     12.33 ± 91%     +64.9%      20.33 ±120%     -54.1%       5.67 ±104%  softirqs.CPU55.NET_RX
      1.67 ± 74%     -60.0%       0.67 ± 70%     -20.0%       1.33 ± 93%  softirqs.CPU55.NET_TX
      7201 ±  3%     -19.4%       5805 ±  8%     -13.9%       6196 ±  9%  softirqs.CPU55.RCU
     12253 ± 16%      +4.8%      12837 ± 20%     +27.6%      15638 ± 22%  softirqs.CPU55.SCHED
      0.00          -100.0%       0.00       +9.3e+102%       9.33 ±141%  softirqs.CPU55.TASKLET
    544.67 ± 93%     -42.0%     316.00 ± 98%     -70.9%     158.67 ± 62%  softirqs.CPU55.TIMER
      0.67 ±141%    -100.0%       0.00          +600.0%       4.67 ±141%  softirqs.CPU56.BLOCK
     10.00 ±113%     -46.7%       5.33 ± 44%     -83.3%       1.67 ± 28%  softirqs.CPU56.NET_RX
      1.33 ± 35%     +75.0%       2.33 ± 40%     -25.0%       1.00        softirqs.CPU56.NET_TX
      6308 ± 12%     -14.1%       5418 ±  9%      +0.0%       6308 ±  4%  softirqs.CPU56.RCU
     14272 ±  9%      +5.1%      15005 ± 12%      +2.4%      14608 ±  8%  softirqs.CPU56.SCHED
      0.67 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU56.TASKLET
    472.67 ± 53%     -50.7%     233.00 ± 78%     -57.6%     200.33 ± 18%  softirqs.CPU56.TIMER
      0.00          -100.0%       0.00         +4e+102%       4.00 ±141%  softirqs.CPU57.BLOCK
     10.33 ±120%      +9.7%      11.33 ±116%     -83.9%       1.67 ± 28%  softirqs.CPU57.NET_RX
      1.00 ± 81%     -33.3%       0.67 ±141%     -33.3%       0.67 ± 70%  softirqs.CPU57.NET_TX
      6641 ±  2%      -9.0%       6045 ±  8%     -15.5%       5613 ± 12%  softirqs.CPU57.RCU
     12514 ± 32%      -7.5%      11579 ± 16%     +40.1%      17534 ± 27%  softirqs.CPU57.SCHED
      2.67 ±141%    -100.0%       0.00           -87.5%       0.33 ±141%  softirqs.CPU57.TASKLET
    113.67 ± 12%      +2.1%     116.00 ±  7%     +24.3%     141.33 ± 38%  softirqs.CPU57.TIMER
      0.00          -100.0%       0.00       +5.3e+102%       5.33 ±141%  softirqs.CPU58.BLOCK
     16.33 ±132%     -83.7%       2.67 ± 93%     -95.9%       0.67 ± 70%  softirqs.CPU58.NET_RX
      0.33 ±141%    +100.0%       0.67 ± 70%    +100.0%       0.67 ± 70%  softirqs.CPU58.NET_TX
      6561 ± 11%      -8.2%       6022 ±  7%      -2.9%       6373 ±  9%  softirqs.CPU58.RCU
     12192 ± 17%      -3.6%      11752 ± 24%      +6.6%      12994 ± 20%  softirqs.CPU58.SCHED
      0.33 ±141%    -100.0%       0.00            +0.0%       0.33 ±141%  softirqs.CPU58.TASKLET
    124.67 ± 12%     +88.8%     235.33 ± 75%     +39.8%     174.33 ± 35%  softirqs.CPU58.TIMER
      8.00 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU59.BLOCK
    204.67 ±139%     -99.5%       1.00 ± 81%     -89.4%      21.67 ±110%  softirqs.CPU59.NET_RX
      1.67 ± 28%     -80.0%       0.33 ±141%     -80.0%       0.33 ±141%  softirqs.CPU59.NET_TX
      6654 ±  6%      -5.5%       6286 ±  3%      -0.9%       6593 ±  5%  softirqs.CPU59.RCU
     13077 ± 18%     -11.5%      11568 ±  5%     +21.7%      15912 ± 24%  softirqs.CPU59.SCHED
      0.00       +1.3e+102%       1.33 ± 70%    -100.0%       0.00        softirqs.CPU59.TASKLET
    195.00 ± 27%      +3.1%     201.00 ± 36%    +242.7%     668.33 ± 84%  softirqs.CPU59.TIMER
      5.33 ±141%     -50.0%       2.67 ±141%    -100.0%       0.00        softirqs.CPU6.BLOCK
     19.67 ±134%     -84.7%       3.00 ± 72%     -94.9%       1.00 ± 81%  softirqs.CPU6.NET_RX
      1.00 ± 81%     -33.3%       0.67 ± 70%     -33.3%       0.67 ± 70%  softirqs.CPU6.NET_TX
      6888 ±  7%      -6.9%       6414 ±  6%     -13.4%       5968 ±  3%  softirqs.CPU6.RCU
     15009 ±  7%      -8.1%      13798 ± 22%      +3.7%      15563 ± 26%  softirqs.CPU6.SCHED
      0.67 ± 70%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU6.TASKLET
    496.33 ± 78%    +239.7%       1686 ± 71%     -39.2%     302.00 ± 50%  softirqs.CPU6.TIMER
      0.67 ±141%    -100.0%       0.00         +1900.0%      13.33 ± 74%  softirqs.CPU60.BLOCK
     46.67 ±138%     -97.1%       1.33 ± 35%     -97.9%       1.00        softirqs.CPU60.NET_RX
      1.67 ±141%    -100.0%       0.00           -60.0%       0.67 ± 70%  softirqs.CPU60.NET_TX
      6732 ±  7%     -19.0%       5453 ± 14%     -10.8%       6002 ±  7%  softirqs.CPU60.RCU
     11973 ± 18%     +41.8%      16973 ± 23%     +21.7%      14565 ± 21%  softirqs.CPU60.SCHED
    393.00 ± 60%     -69.9%     118.33 ± 29%     -36.6%     249.33 ± 59%  softirqs.CPU60.TIMER
      2.00 ± 40%     +50.0%       3.00 ± 54%     +16.7%       2.33 ± 20%  softirqs.CPU61.NET_RX
      0.33 ±141%    +200.0%       1.00 ± 81%    +300.0%       1.33 ± 35%  softirqs.CPU61.NET_TX
      6410 ±  2%     -11.0%       5706 ± 11%      -3.6%       6180 ±  8%  softirqs.CPU61.RCU
     15148 ± 26%      +1.9%      15434 ± 28%      +5.4%      15966 ± 16%  softirqs.CPU61.SCHED
    284.00 ± 42%     +69.6%     481.67 ± 65%     -21.2%     223.67 ± 28%  softirqs.CPU61.TIMER
     11.33 ±141%    -100.0%       0.00           -76.5%       2.67 ±141%  softirqs.CPU62.BLOCK
      1.67 ±101%    +420.0%       8.67 ±125%  +49240.0%     822.33 ±141%  softirqs.CPU62.NET_RX
      1.00 ± 81%      +0.0%       1.00 ± 81%     -33.3%       0.67 ± 70%  softirqs.CPU62.NET_TX
      6531 ± 11%     -15.2%       5540 ±  7%     -11.8%       5759 ±  6%  softirqs.CPU62.RCU
     11311 ± 42%     +24.6%      14097 ± 32%     +53.1%      17319 ±  9%  softirqs.CPU62.SCHED
     11.00 ±141%    -100.0%       0.00           -93.9%       0.67 ±141%  softirqs.CPU62.TASKLET
    223.00 ± 44%     +14.5%     255.33 ± 73%   +1209.9%       2921 ± 82%  softirqs.CPU62.TIMER
      2.00 ± 70%     -66.7%       0.67 ± 70%     -16.7%       1.67 ± 28%  softirqs.CPU63.NET_RX
      0.33 ±141%    -100.0%       0.00          +200.0%       1.00 ± 81%  softirqs.CPU63.NET_TX
      6407 ±  4%     -23.2%       4922 ±  8%      -0.7%       6361 ± 12%  softirqs.CPU63.RCU
     12594 ± 17%     +26.3%      15900 ±  9%      +6.7%      13432 ± 25%  softirqs.CPU63.SCHED
    213.67 ± 44%      +2.2%     218.33 ± 43%    +106.7%     441.67 ± 53%  softirqs.CPU63.TIMER
      4.33 ± 96%    +369.2%      20.33 ± 94%     -69.2%       1.33 ± 35%  softirqs.CPU64.NET_RX
      0.33 ±141%    +300.0%       1.33 ± 93%    +200.0%       1.00        softirqs.CPU64.NET_TX
      6413 ± 10%      -6.9%       5968 ±  4%     +11.4%       7146 ±  7%  softirqs.CPU64.RCU
     13468 ±  7%      -9.8%      12148 ± 18%     -13.0%      11716 ± 29%  softirqs.CPU64.SCHED
      0.00          -100.0%       0.00          -100.0%       0.00        softirqs.CPU64.TASKLET
    158.67 ±  9%    +120.0%     349.00 ± 92%     +66.6%     264.33 ±  7%  softirqs.CPU64.TIMER
      2.33 ±112%    +771.4%      20.33 ±127%    +457.1%      13.00 ±130%  softirqs.CPU65.NET_RX
      0.00         +1e+102%       1.00 ± 81% +6.7e+101%       0.67 ±141%  softirqs.CPU65.NET_TX
      7043 ± 14%     -15.6%       5943 ±  6%     -14.7%       6010 ± 13%  softirqs.CPU65.RCU
     10844 ± 16%     +34.4%      14574 ± 27%     +38.2%      14991 ± 36%  softirqs.CPU65.SCHED
      0.33 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU65.TASKLET
    335.67 ± 57%     -52.6%     159.00 ± 31%     -46.2%     180.67 ± 63%  softirqs.CPU65.TIMER
      0.00       +1.1e+103%      11.33 ±141%    -100.0%       0.00        softirqs.CPU66.BLOCK
    684.33 ±140%     -98.6%       9.67 ±119%     -98.6%       9.67 ±106%  softirqs.CPU66.NET_RX
      0.00          -100.0%       0.00          -100.0%       0.00        softirqs.CPU66.NET_TX
      7191 ± 14%     -23.4%       5510 ±  5%      -2.4%       7017 ± 14%  softirqs.CPU66.RCU
     16220 ± 36%      -6.4%      15189 ±  9%     -10.7%      14488 ± 25%  softirqs.CPU66.SCHED
      0.00          -100.0%       0.00       +2.7e+102%       2.67 ±141%  softirqs.CPU66.TASKLET
      3757 ±125%     -90.9%     342.33 ± 95%     -93.1%     258.00 ± 41%  softirqs.CPU66.TIMER
      0.33 ±141%    +100.0%       0.67 ±141%    -100.0%       0.00        softirqs.CPU67.BLOCK
      1649 ±141%    -100.0%       0.67 ± 70%     -97.5%      41.67 ±127%  softirqs.CPU67.NET_RX
      0.00       +3.3e+101%       0.33 ±141% +6.7e+101%       0.67 ±141%  softirqs.CPU67.NET_TX
      6192 ±  5%     -14.5%       5293 ±  9%      -2.0%       6065 ±  7%  softirqs.CPU67.RCU
     16594 ±  8%     +14.9%      19072 ± 16%      -1.9%      16284 ±  6%  softirqs.CPU67.SCHED
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        softirqs.CPU67.TASKLET
    420.00 ± 92%     -29.1%     297.67 ± 34%     +56.0%     655.33 ± 92%  softirqs.CPU67.TIMER
      0.00          -100.0%       0.00         +2e+102%       2.00 ±141%  softirqs.CPU68.BLOCK
      4.00 ±106%   +1500.0%      64.00 ±129%      +8.3%       4.33 ± 39%  softirqs.CPU68.NET_RX
      0.67 ±141%     -50.0%       0.33 ±141%    +150.0%       1.67 ± 28%  softirqs.CPU68.NET_TX
      6130 ±  9%     -12.5%       5361 ±  6%      +5.5%       6468 ±  3%  softirqs.CPU68.RCU
     14249 ± 10%     +12.1%      15980 ± 10%      +8.1%      15408 ± 16%  softirqs.CPU68.SCHED
      0.00          -100.0%       0.00       +2.3e+102%       2.33 ±112%  softirqs.CPU68.TASKLET
    447.33 ± 33%     +38.7%     620.67 ±107%     -14.5%     382.33 ± 44%  softirqs.CPU68.TIMER
      0.00       +1.2e+103%      12.00 ±141%    -100.0%       0.00        softirqs.CPU69.BLOCK
      2.33 ± 88%     -28.6%       1.67 ±141%    +314.3%       9.67 ±105%  softirqs.CPU69.NET_RX
      0.67 ±141%      +0.0%       0.67 ±141%     +50.0%       1.00 ± 81%  softirqs.CPU69.NET_TX
      6902 ±  3%     -16.7%       5748 ±  3%      +4.8%       7230 ± 24%  softirqs.CPU69.RCU
     10975 ± 18%     +27.9%      14042 ± 20%     +60.6%      17622 ± 19%  softirqs.CPU69.SCHED
      0.33 ±141%      +0.0%       0.33 ±141%    -100.0%       0.00        softirqs.CPU69.TASKLET
    628.00 ± 51%     -78.9%     132.67 ± 15%     +22.2%     767.33 ± 70%  softirqs.CPU69.TIMER
      0.00       +1.3e+103%      13.33 ±141%    -100.0%       0.00        softirqs.CPU7.BLOCK
      1.00           +33.3%       1.33 ±141%   +2200.0%      23.00 ±111%  softirqs.CPU7.NET_RX
      0.00       +6.7e+101%       0.67 ±141% +6.7e+101%       0.67 ± 70%  softirqs.CPU7.NET_TX
      7894 ± 31%     -15.1%       6703 ± 20%     -16.4%       6596 ± 10%  softirqs.CPU7.RCU
     15921 ± 10%      +3.9%      16541 ± 10%     -16.6%      13284 ± 19%  softirqs.CPU7.SCHED
    908.00 ± 38%     -75.0%     226.67 ± 76%     -51.7%     438.67 ± 73%  softirqs.CPU7.TIMER
      2.00 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU70.BLOCK
      2.67 ± 77%     -25.0%       2.00 ± 40%     -75.0%       0.67 ±141%  softirqs.CPU70.NET_RX
      0.67 ± 70%     +50.0%       1.00 ±141%    -100.0%       0.00        softirqs.CPU70.NET_TX
      8167 ± 23%     -31.5%       5596 ±  3%     -21.1%       6442 ± 14%  softirqs.CPU70.RCU
     10950 ± 31%     +39.4%      15265 ± 22%     +30.5%      14294 ± 31%  softirqs.CPU70.SCHED
      0.67 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU70.TASKLET
    630.33 ± 93%     -76.2%     150.33 ± 43%     -26.3%     464.33 ± 76%  softirqs.CPU70.TIMER
      1.00         +1633.3%      17.33 ±141%    +133.3%       2.33 ± 40%  softirqs.CPU71.NET_RX
      0.33 ±141%      +0.0%       0.33 ±141%    +100.0%       0.67 ± 70%  softirqs.CPU71.NET_TX
      6463 ± 11%     -10.6%       5780 ±  2%      -0.4%       6436 ± 10%  softirqs.CPU71.RCU
     15363 ±  7%      -7.6%      14190 ± 26%      -1.4%      15152 ±  9%  softirqs.CPU71.SCHED
      0.00       +3.3e+101%       0.33 ±141%   +1e+102%       1.00 ±141%  softirqs.CPU71.TASKLET
    796.00 ±109%     -55.9%     350.67 ± 92%     -45.5%     433.67 ± 53%  softirqs.CPU71.TIMER
      0.00       +2.3e+102%       2.33 ± 72%    -100.0%       0.00        softirqs.CPU72.BLOCK
      0.00       +3.3e+101%       0.33 ±141% +3.7e+102%       3.67 ± 56%  softirqs.CPU72.NET_RX
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU72.NET_TX
      6405 ± 10%      -9.0%       5826 ±  5%      +4.4%       6689 ±  9%  softirqs.CPU72.RCU
     17474 ± 10%      -1.5%      17216 ± 12%      -6.5%      16334 ± 16%  softirqs.CPU72.SCHED
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU72.TASKLET
    525.00 ± 42%     -53.3%     245.33 ± 39%     -43.0%     299.33 ± 67%  softirqs.CPU72.TIMER
      0.00       +3.3e+101%       0.33 ±141% +1.7e+102%       1.67 ±141%  softirqs.CPU73.NET_RX
      0.00          -100.0%       0.00          -100.0%       0.00        softirqs.CPU73.NET_TX
      6577 ± 14%      +8.1%       7112 ± 32%     +10.2%       7249 ± 13%  softirqs.CPU73.RCU
     17830 ±  9%      -4.0%      17115 ± 16%     -12.9%      15537 ±  9%  softirqs.CPU73.SCHED
      0.00          -100.0%       0.00         +3e+102%       3.00 ±141%  softirqs.CPU73.TASKLET
    462.00 ± 55%     -44.0%     258.67 ± 43%      -3.2%     447.00 ± 65%  softirqs.CPU73.TIMER
      2.00 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU74.BLOCK
      0.00       +1.3e+104%     126.33 ±141%   +3e+102%       3.00 ±141%  softirqs.CPU74.NET_RX
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU74.NET_TX
      6119           +14.3%       6995 ± 16%     +17.6%       7194 ± 14%  softirqs.CPU74.RCU
     18092 ±  8%      -3.2%      17521 ± 21%     -10.1%      16258 ± 12%  softirqs.CPU74.SCHED
    607.00 ± 23%     +13.9%     691.67 ± 56%     +85.9%       1128 ± 53%  softirqs.CPU74.TIMER
      0.00          -100.0%       0.00       +3.5e+103%      34.67 ± 90%  softirqs.CPU75.BLOCK
    944.67 ±141%     -99.9%       0.67 ± 70%     -99.4%       5.33 ± 93%  softirqs.CPU75.NET_RX
      0.00          -100.0%       0.00       +1.7e+103%      16.67 ±141%  softirqs.CPU75.NET_TX
      6590 ± 19%     -12.4%       5774 ± 15%      +3.4%       6812 ± 10%  softirqs.CPU75.RCU
     20884 ± 11%     -24.8%      15703 ± 13%     -20.8%      16542 ± 19%  softirqs.CPU75.SCHED
      1.00 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU75.TASKLET
    997.00 ± 80%     +75.9%       1753 ± 84%     -69.8%     300.67 ± 22%  softirqs.CPU75.TIMER
      7.33 ±113%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU76.BLOCK
      0.00          -100.0%       0.00          -100.0%       0.00        softirqs.CPU76.NET_RX
      6520 ± 12%     -16.2%       5463 ±  2%      +1.0%       6586 ±  7%  softirqs.CPU76.RCU
     19765            -8.6%      18071 ±  4%     -32.3%      13386 ± 32%  softirqs.CPU76.SCHED
      0.00       +6.7e+101%       0.67 ±141%    -100.0%       0.00        softirqs.CPU76.TASKLET
    592.33 ± 87%     -12.7%     517.33 ± 56%     -63.9%     213.67 ± 66%  softirqs.CPU76.TIMER
      1.00 ±141%     -33.3%       0.67 ±141%    -100.0%       0.00        softirqs.CPU77.NET_RX
      0.00          -100.0%       0.00          -100.0%       0.00        softirqs.CPU77.NET_TX
      6722 ± 25%     -16.9%       5588 ± 12%     +18.7%       7976 ± 16%  softirqs.CPU77.RCU
     19442 ± 14%     -11.8%      17142 ± 11%     -24.1%      14760 ± 11%  softirqs.CPU77.SCHED
    782.67 ± 44%     +21.3%     949.00 ±  3%      -8.9%     713.33 ± 78%  softirqs.CPU77.TIMER
     34.67 ± 76%     -56.7%      15.00 ±141%     -88.5%       4.00 ±141%  softirqs.CPU78.BLOCK
      0.00       +3.3e+101%       0.33 ±141% +2.1e+104%     208.00 ±141%  softirqs.CPU78.NET_RX
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU78.NET_TX
      7064 ± 15%      -7.6%       6526 ± 15%     +16.9%       8260 ± 29%  softirqs.CPU78.RCU
     16911 ± 12%      +2.1%      17258 ± 22%      +6.3%      17970 ± 12%  softirqs.CPU78.SCHED
      0.00       +3.7e+102%       3.67 ±141%    -100.0%       0.00        softirqs.CPU78.TASKLET
    531.67 ± 41%     -17.4%     439.00 ± 57%     +88.5%       1002 ±101%  softirqs.CPU78.TIMER
     21.67 ±141%     -72.3%       6.00 ±118%     -92.3%       1.67 ±141%  softirqs.CPU79.BLOCK
      0.33 ±141%    +600.0%       2.33 ±141%    +500.0%       2.00 ±141%  softirqs.CPU79.NET_RX
      0.00          -100.0%       0.00       +6.7e+101%       0.67 ±141%  softirqs.CPU79.NET_TX
      6134 ± 23%      -1.2%       6060 ±  5%     +29.9%       7971 ± 44%  softirqs.CPU79.RCU
     20458 ± 11%     -31.5%      14016 ± 16%     -17.1%      16969 ± 30%  softirqs.CPU79.SCHED
    431.00 ± 60%    +132.8%       1003 ± 57%     -13.1%     374.67 ± 39%  softirqs.CPU79.TIMER
      1.33 ± 35%  +29925.0%     400.33 ±141%     -25.0%       1.00        softirqs.CPU8.NET_RX
      0.67 ± 70%    -100.0%       0.00            +0.0%       0.67 ± 70%  softirqs.CPU8.NET_TX
      7230 ±  3%      +5.8%       7651 ±  7%     -14.5%       6184        softirqs.CPU8.RCU
     12284 ±  6%     +16.3%      14282 ± 16%     +16.2%      14272 ±  7%  softirqs.CPU8.SCHED
    232.00 ± 70%    +402.6%       1166 ± 76%     +76.3%     409.00 ± 61%  softirqs.CPU8.TIMER
      0.00          -100.0%       0.00       +7.7e+102%       7.67 ±141%  softirqs.CPU80.BLOCK
      0.00          -100.0%       0.00         +1e+102%       1.00 ± 81%  softirqs.CPU80.NET_RX
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU80.NET_TX
      7696 ± 26%     -20.3%       6133 ±  6%     -15.9%       6472 ±  7%  softirqs.CPU80.RCU
     18946 ±  6%     -43.0%      10793 ± 16%     -32.6%      12768 ± 25%  softirqs.CPU80.SCHED
      0.00       +6.7e+101%       0.67 ± 70%    -100.0%       0.00        softirqs.CPU80.TASKLET
      1155 ± 26%     -83.3%     192.67 ± 46%     -79.2%     240.00 ± 18%  softirqs.CPU80.TIMER
      0.00       +2.4e+103%      23.67 ±141%    -100.0%       0.00        softirqs.CPU81.BLOCK
      0.00       +1.5e+104%     148.33 ±138%    -100.0%       0.00        softirqs.CPU81.NET_RX
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        softirqs.CPU81.NET_TX
      6388 ± 10%     -15.9%       5373 ± 22%      -2.8%       6208 ±  5%  softirqs.CPU81.RCU
     17993 ±  9%      -2.2%      17591 ± 14%     -21.1%      14203 ± 11%  softirqs.CPU81.SCHED
      0.00          -100.0%       0.00          -100.0%       0.00        softirqs.CPU81.TASKLET
    663.33 ± 63%     +87.6%       1244 ± 79%     -55.2%     297.00 ± 46%  softirqs.CPU81.TIMER
      0.00       +7.7e+102%       7.67 ±141% +3.3e+101%       0.33 ±141%  softirqs.CPU82.BLOCK
      3.67 ±105%     -63.6%       1.33 ±141%  +65318.2%       2398 ±141%  softirqs.CPU82.NET_RX
      0.67 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU82.NET_TX
      6388 ± 18%      -6.1%       5999 ±  2%     +18.5%       7570 ± 24%  softirqs.CPU82.RCU
     18690 ± 12%     -20.1%      14937 ± 25%     -20.5%      14857 ± 41%  softirqs.CPU82.SCHED
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        softirqs.CPU82.TASKLET
    307.00 ± 16%     +15.9%     355.67 ± 41%    +149.9%     767.33 ±107%  softirqs.CPU82.TIMER
      0.00       +6.7e+101%       0.67 ±141%    -100.0%       0.00        softirqs.CPU83.BLOCK
    201.67 ±141%     -99.5%       1.00 ±141%     -95.9%       8.33 ±141%  softirqs.CPU83.NET_RX
      0.00       +3.3e+101%       0.33 ±141% +3.3e+101%       0.33 ±141%  softirqs.CPU83.NET_TX
      6118 ±  8%     -13.8%       5272 ± 17%      +1.4%       6202 ±  2%  softirqs.CPU83.RCU
     18673 ± 31%     -12.7%      16294 ± 16%     -16.8%      15538 ±  8%  softirqs.CPU83.SCHED
    850.33 ± 71%     -71.8%     239.67 ± 25%     +38.9%       1181 ± 48%  softirqs.CPU83.TIMER
      0.00          -100.0%       0.00       +1.2e+103%      11.67 ± 71%  softirqs.CPU84.BLOCK
      7.67 ±141%      +0.0%       7.67 ±141%     -91.3%       0.67 ±141%  softirqs.CPU84.NET_RX
      0.00          -100.0%       0.00          -100.0%       0.00        softirqs.CPU84.NET_TX
      5690 ± 11%      -0.7%       5653 ±  9%     +12.5%       6399 ± 12%  softirqs.CPU84.RCU
     21551 ± 11%     -44.9%      11870 ± 17%     -30.6%      14953 ± 14%  softirqs.CPU84.SCHED
    512.33 ± 54%     +39.4%     714.33 ±120%     -40.1%     307.00 ± 43%  softirqs.CPU84.TIMER
      0.00       +1.1e+103%      11.00 ±141%    -100.0%       0.00        softirqs.CPU85.BLOCK
      0.33 ±141%    -100.0%       0.00            +0.0%       0.33 ±141%  softirqs.CPU85.NET_RX
      6367 ±  8%      -8.6%       5822 ± 19%      +1.5%       6461 ± 17%  softirqs.CPU85.RCU
     15532 ± 14%      -6.0%      14594 ± 23%      -9.8%      14012 ± 30%  softirqs.CPU85.SCHED
      0.00       +3.3e+101%       0.33 ±141%   +3e+102%       3.00 ±141%  softirqs.CPU85.TASKLET
    544.00 ± 77%    +186.2%       1556 ± 93%     -20.6%     431.67 ± 79%  softirqs.CPU85.TIMER
      0.00       +9.3e+102%       9.33 ±141%    -100.0%       0.00        softirqs.CPU86.BLOCK
      0.33 ±141%    -100.0%       0.00        +1.4e+05%     467.67 ± 74%  softirqs.CPU86.NET_RX
      0.00          -100.0%       0.00          -100.0%       0.00        softirqs.CPU86.NET_TX
      5726 ± 12%      -9.2%       5197 ±  7%      +2.9%       5893 ± 13%  softirqs.CPU86.RCU
     17691 ± 13%      +9.5%      19374 ±  8%      -3.7%      17037 ± 19%  softirqs.CPU86.SCHED
      0.00          -100.0%       0.00         +1e+103%      10.00 ±141%  softirqs.CPU86.TASKLET
    870.67 ± 39%     -51.1%     425.33 ± 56%     -38.4%     536.67 ±  8%  softirqs.CPU86.TIMER
      0.00       +1.3e+103%      12.67 ±141%    -100.0%       0.00        softirqs.CPU87.BLOCK
    257.67 ±141%     -73.9%      67.33 ±141%    -100.0%       0.00        softirqs.CPU87.NET_RX
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        softirqs.CPU87.NET_TX
      6130 ±  5%      -2.5%       5979 ± 12%      -1.7%       6023 ±  3%  softirqs.CPU87.RCU
     17710 ± 27%      -4.5%      16904 ± 16%      -8.7%      16169 ± 12%  softirqs.CPU87.SCHED
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU87.TASKLET
    626.33 ± 57%     -26.5%     460.67 ± 61%     +50.9%     945.00 ± 70%  softirqs.CPU87.TIMER
      0.00       +6.7e+101%       0.67 ±141%    -100.0%       0.00        softirqs.CPU88.BLOCK
      0.00       +3.7e+102%       3.67 ±141%    -100.0%       0.00        softirqs.CPU88.NET_RX
      0.00       +1.7e+103%      17.00 ±141%    -100.0%       0.00        softirqs.CPU88.NET_TX
      5694 ± 20%      -7.7%       5256 ± 10%     +15.2%       6561 ±  4%  softirqs.CPU88.RCU
     18995 ± 19%      +0.2%      19025 ± 11%     -31.9%      12936 ± 14%  softirqs.CPU88.SCHED
    497.00 ±  5%     +12.3%     558.33 ± 86%     +21.3%     603.00 ± 63%  softirqs.CPU88.TIMER
      4.00 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU89.BLOCK
      1.33 ±141%    -100.0%       0.00          -100.0%       0.00        softirqs.CPU89.NET_RX
      5879 ±  9%      -5.5%       5557 ±  7%      +5.3%       6193 ± 10%  softirqs.CPU89.RCU
     19696 ±  7%      -9.1%      17895 ± 22%      -2.1%      19288 ± 10%  softirqs.CPU89.SCHED
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU89.TASKLET
    370.00 ± 54%     +41.9%     525.00 ±104%     +45.9%     540.00 ± 29%  softirqs.CPU89.TIMER
     19.33 ±134%     -93.1%       1.33 ± 35%     -98.3%       0.33 ±141%  softirqs.CPU9.NET_RX
      1.00           -33.3%       0.67 ± 70%    -100.0%       0.00        softirqs.CPU9.NET_TX
      6503 ± 11%      -7.7%       6004 ±  2%      +9.7%       7131 ±  2%  softirqs.CPU9.RCU
     14045 ± 21%     +16.9%      16421 ± 10%     -24.6%      10587 ± 25%  softirqs.CPU9.SCHED
      0.00          -100.0%       0.00       +6.7e+101%       0.67 ±141%  softirqs.CPU9.TASKLET
    202.00 ± 64%     -45.4%     110.33 ± 13%     -27.2%     147.00 ± 36%  softirqs.CPU9.TIMER
      1.33 ±141%     +75.0%       2.33 ±112%  +16525.0%     221.67 ±141%  softirqs.CPU90.NET_RX
      0.67 ±141%     -50.0%       0.33 ±141%    -100.0%       0.00        softirqs.CPU90.NET_TX
      5572 ±  4%     -11.1%       4952 ±  5%      +8.7%       6055 ±  9%  softirqs.CPU90.RCU
     18897 ± 10%      -1.6%      18604 ± 21%     -11.4%      16752 ±  9%  softirqs.CPU90.SCHED
      0.00          -100.0%       0.00          -100.0%       0.00        softirqs.CPU90.TASKLET
    376.00 ± 23%     +11.2%     418.00 ±108%     +30.5%     490.67 ± 63%  softirqs.CPU90.TIMER
      0.00       +2.3e+102%       2.33 ±141% +3.3e+101%       0.33 ±141%  softirqs.CPU91.NET_RX
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        softirqs.CPU91.NET_TX
      5213 ±  9%     +14.1%       5947 ± 30%      +5.7%       5512        softirqs.CPU91.RCU
     20732 ±  9%     -20.9%      16402 ± 13%     -12.7%      18091 ±  7%  softirqs.CPU91.SCHED
    500.67 ± 38%     -17.2%     414.67 ± 63%     -75.8%     121.33 ±  5%  softirqs.CPU91.TIMER
      0.00         +1e+102%       1.00 ±141%    -100.0%       0.00        softirqs.CPU92.BLOCK
      0.00       +6.7e+101%       0.67 ±141%   +1e+102%       1.00 ±141%  softirqs.CPU92.NET_RX
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU92.NET_TX
      5295 ±  5%     +12.6%       5960 ±  8%      +7.0%       5669 ±  3%  softirqs.CPU92.RCU
     19964 ±  5%     -10.5%      17867 ±  8%     -18.9%      16182 ± 11%  softirqs.CPU92.SCHED
    371.67 ± 18%    +115.4%     800.67 ± 97%     +38.5%     514.67 ± 57%  softirqs.CPU92.TIMER
      7.67 ±141%  +10187.0%     788.67 ±141%     +43.5%      11.00 ±141%  softirqs.CPU93.NET_RX
      0.00       +6.7e+101%       0.67 ±141%    -100.0%       0.00        softirqs.CPU93.NET_TX
      6115 ± 11%     -11.1%       5438 ± 12%      +3.5%       6331 ±  7%  softirqs.CPU93.RCU
     18240 ±  8%      +3.0%      18780 ± 17%      -1.5%      17958 ± 17%  softirqs.CPU93.SCHED
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU93.TASKLET
    406.00 ± 76%    +154.0%       1031 ±111%     -35.3%     262.67 ± 49%  softirqs.CPU93.TIMER
      5.00 ±141%    -100.0%       0.00           -33.3%       3.33 ±141%  softirqs.CPU94.BLOCK
      6275 ± 11%     -19.9%       5024 ±  5%     -15.2%       5324 ±  6%  softirqs.CPU94.RCU
     17762 ±  5%     +12.6%      20003 ±  6%      -7.6%      16420 ± 22%  softirqs.CPU94.SCHED
      0.00          -100.0%       0.00       +6.3e+102%       6.33 ±141%  softirqs.CPU94.TASKLET
    647.33 ± 44%     -54.0%     298.00 ± 87%     -16.6%     539.67 ± 58%  softirqs.CPU94.TIMER
      0.00       +6.7e+101%       0.67 ±141%    -100.0%       0.00        softirqs.CPU95.NET_TX
      6622 ± 11%     -11.6%       5852 ± 12%      +0.4%       6647 ± 14%  softirqs.CPU95.RCU
     22790 ± 17%     -25.5%      16976 ± 16%      -7.8%      21017 ± 10%  softirqs.CPU95.SCHED
      2383 ±124%     -86.6%     319.00 ± 73%     -78.2%     519.67 ± 49%  softirqs.CPU95.TIMER
      2.33 ± 20%      +0.0%       2.33 ± 20%     +14.3%       2.67 ± 17%  softirqs.HI
     13788 ± 52%     -51.6%       6667 ± 16%     -62.0%       5240 ± 53%  softirqs.NET_RX
    106.00 ±  6%      -1.9%     104.00 ±  3%      -1.6%     104.33 ±  4%  softirqs.NET_TX
    666139 ±  5%      -9.5%     602568 ±  3%      -3.2%     644544 ±  2%  softirqs.RCU
   1449751            -1.5%    1427706            -1.7%    1425517        softirqs.SCHED
    235.33            -2.4%     229.67            -3.3%     227.67        softirqs.TASKLET
     62465 ±  2%      -9.5%      56552 ±  2%     -11.8%      55077 ±  3%  softirqs.TIMER
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.0:IO-APIC.2-edge.timer
      1.33 ± 93%    +650.0%      10.00 ±141%     -50.0%       0.67 ±141%  interrupts.100:PCI-MSI.31981633-edge.i40e-eth0-TxRx-64
      4.67 ± 88%    +192.9%      13.67 ±120%    +178.6%      13.00 ±130%  interrupts.101:PCI-MSI.31981634-edge.i40e-eth0-TxRx-65
     58.33 ±128%     -89.7%       6.00 ±141%     -84.0%       9.33 ± 72%  interrupts.102:PCI-MSI.31981635-edge.i40e-eth0-TxRx-66
    530.33 ±141%     -99.9%       0.67 ±141%     -94.5%      29.33 ±120%  interrupts.103:PCI-MSI.31981636-edge.i40e-eth0-TxRx-67
      0.33 ±141%  +27900.0%      93.33 ±141%   +1100.0%       4.00 ±141%  interrupts.104:PCI-MSI.31981637-edge.i40e-eth0-TxRx-68
      2.33 ± 88%     -57.1%       1.00 ± 81%    -100.0%       0.00        interrupts.105:PCI-MSI.31981638-edge.i40e-eth0-TxRx-69
      1.00 ± 81%    -100.0%       0.00           -33.3%       0.67 ±141%  interrupts.106:PCI-MSI.31981639-edge.i40e-eth0-TxRx-70
      0.00       +1.3e+103%      12.67 ±141% +1.3e+102%       1.33 ± 93%  interrupts.107:PCI-MSI.31981640-edge.i40e-eth0-TxRx-71
      0.33 ±141%      +0.0%       0.33 ±141%    +300.0%       1.33 ± 70%  interrupts.108:PCI-MSI.31981641-edge.i40e-eth0-TxRx-72
      0.00       +1.3e+102%       1.33 ±141% +3.3e+101%       0.33 ±141%  interrupts.109:PCI-MSI.31981642-edge.i40e-eth0-TxRx-73
      0.67 ±141%   +9600.0%      64.67 ±139%     +50.0%       1.00 ± 81%  interrupts.110:PCI-MSI.31981643-edge.i40e-eth0-TxRx-74
      1250 ±141%    -100.0%       0.00           -99.7%       3.33 ±120%  interrupts.111:PCI-MSI.31981644-edge.i40e-eth0-TxRx-75
      0.00       +6.7e+101%       0.67 ±141%    -100.0%       0.00        interrupts.112:PCI-MSI.31981645-edge.i40e-eth0-TxRx-76
      0.00       +6.7e+101%       0.67 ±141%    -100.0%       0.00        interrupts.113:PCI-MSI.31981646-edge.i40e-eth0-TxRx-77
      0.00         +1e+102%       1.00 ±141% +2.4e+104%     238.00 ±141%  interrupts.114:PCI-MSI.31981647-edge.i40e-eth0-TxRx-78
      0.00         +2e+102%       2.00 ± 81% +3.3e+101%       0.33 ±141%  interrupts.115:PCI-MSI.31981648-edge.i40e-eth0-TxRx-79
      0.00          -100.0%       0.00       +1.7e+102%       1.67 ±141%  interrupts.116:PCI-MSI.31981649-edge.i40e-eth0-TxRx-80
      0.00       +2.3e+104%     228.67 ±140%    -100.0%       0.00        interrupts.117:PCI-MSI.31981650-edge.i40e-eth0-TxRx-81
      2.00 ±141%     -66.7%       0.67 ±141%  +18916.7%     380.33 ±141%  interrupts.118:PCI-MSI.31981651-edge.i40e-eth0-TxRx-82
    202.67 ±141%    -100.0%       0.00           -95.9%       8.33 ±141%  interrupts.119:PCI-MSI.31981652-edge.i40e-eth0-TxRx-83
      5.67 ±141%      -5.9%       5.33 ±141%    -100.0%       0.00        interrupts.120:PCI-MSI.31981653-edge.i40e-eth0-TxRx-84
      1.00 ±141%     -66.7%       0.33 ±141%      +0.0%       1.00 ± 81%  interrupts.121:PCI-MSI.31981654-edge.i40e-eth0-TxRx-85
      0.00          -100.0%       0.00       +6.4e+104%     644.67 ± 70%  interrupts.122:PCI-MSI.31981655-edge.i40e-eth0-TxRx-86
    107.00 ±141%     +23.1%     131.67 ±141%     -99.7%       0.33 ±141%  interrupts.123:PCI-MSI.31981656-edge.i40e-eth0-TxRx-87
      0.33 ±141%      +0.0%       0.33 ±141%    -100.0%       0.00        interrupts.124:PCI-MSI.31981657-edge.i40e-eth0-TxRx-88
      2.00 ±141%    -100.0%       0.00          -100.0%       0.00        interrupts.125:PCI-MSI.31981658-edge.i40e-eth0-TxRx-89
      0.00       +4.3e+102%       4.33 ± 84%    -100.0%       0.00        interrupts.126:PCI-MSI.31981659-edge.i40e-eth0-TxRx-90
      0.00       +5.7e+102%       5.67 ±117% +6.7e+101%       0.67 ±141%  interrupts.127:PCI-MSI.31981660-edge.i40e-eth0-TxRx-91
      1.33 ± 70%     +25.0%       1.67 ±141%     -50.0%       0.67 ±141%  interrupts.128:PCI-MSI.31981661-edge.i40e-eth0-TxRx-92
      5.67 ±129%  +12982.4%     741.33 ±141%    +105.9%      11.67 ±141%  interrupts.129:PCI-MSI.31981662-edge.i40e-eth0-TxRx-93
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.293:PCI-MSI.327680-edge.xhci_hcd
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.295:PCI-MSI.65536-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.297:PCI-MSI.67584-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.298:PCI-MSI.69632-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.299:PCI-MSI.69632-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.299:PCI-MSI.71680-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.300:PCI-MSI.71680-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.300:PCI-MSI.73728-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.301:PCI-MSI.73728-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.301:PCI-MSI.75776-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.302:PCI-MSI.75776-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.302:PCI-MSI.77824-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.303:PCI-MSI.77824-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.303:PCI-MSI.79872-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.304:PCI-MSI.79872-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.305:PCI-MSI.67174400-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.306:PCI-MSI.67174400-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.307:PCI-MSI.67176448-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.308:PCI-MSI.67176448-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.308:PCI-MSI.67178496-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.309:PCI-MSI.67178496-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.309:PCI-MSI.67180544-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.310:PCI-MSI.67180544-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.311:PCI-MSI.67182592-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.312:PCI-MSI.67184640-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.313:PCI-MSI.67186688-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.314:PCI-MSI.376832-edge.ahci[0000:00:17.0]
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.314:PCI-MSI.67188736-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.315:PCI-MSI.376832-edge.ahci[0000:00:17.0]
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.315:PCI-MSI.67188736-edge.ioat-msix
    254.33 ±  2%      +0.7%     256.00            +8.0%     274.67 ±  4%  interrupts.35:PCI-MSI.31981568-edge.i40e-0000:3d:00.0:misc
      0.67 ±141%      +0.0%       0.67 ± 70%    +650.0%       5.00 ± 81%  interrupts.36:PCI-MSI.31981569-edge.i40e-eth0-TxRx-0
      2.00 ± 70%     -66.7%       0.67 ±141%     -50.0%       1.00 ± 81%  interrupts.37:PCI-MSI.31981570-edge.i40e-eth0-TxRx-1
    949.00 ±110%     -99.8%       1.67 ±141%    -100.0%       0.00        interrupts.38:PCI-MSI.31981571-edge.i40e-eth0-TxRx-2
      1.67 ±101%     -40.0%       1.00         +2360.0%      41.00 ±136%  interrupts.39:PCI-MSI.31981572-edge.i40e-eth0-TxRx-3
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.3:IO-APIC.3-edge
    228.67 ±140%     -99.7%       0.67 ±141%    -100.0%       0.00        interrupts.40:PCI-MSI.31981573-edge.i40e-eth0-TxRx-4
      0.00         +2e+102%       2.00 ± 81% +3.3e+101%       0.33 ±141%  interrupts.41:PCI-MSI.31981574-edge.i40e-eth0-TxRx-5
     13.67 ±141%     -95.1%       0.67 ± 70%     -97.6%       0.33 ±141%  interrupts.42:PCI-MSI.31981575-edge.i40e-eth0-TxRx-6
      0.33 ±141%    +400.0%       1.67 ±141%   +5000.0%      17.00 ±141%  interrupts.43:PCI-MSI.31981576-edge.i40e-eth0-TxRx-7
      0.33 ±141%  +52500.0%     175.33 ±141%    -100.0%       0.00        interrupts.44:PCI-MSI.31981577-edge.i40e-eth0-TxRx-8
     13.33 ±141%     -90.0%       1.33 ±141%    -100.0%       0.00        interrupts.45:PCI-MSI.31981578-edge.i40e-eth0-TxRx-9
      1.00 ±141%     +33.3%       1.33 ± 70%  +10566.7%     106.67 ±141%  interrupts.46:PCI-MSI.31981579-edge.i40e-eth0-TxRx-10
      0.67 ±141%    +350.0%       3.00 ±141%    -100.0%       0.00        interrupts.47:PCI-MSI.31981580-edge.i40e-eth0-TxRx-11
      0.33 ±141%    +100.0%       0.67 ±141%      +0.0%       0.33 ±141%  interrupts.48:PCI-MSI.31981581-edge.i40e-eth0-TxRx-12
      1.00 ± 81%     -33.3%       0.67 ±141%    +500.0%       6.00 ±141%  interrupts.49:PCI-MSI.31981582-edge.i40e-eth0-TxRx-13
     51.00           -57.5%      21.67 ±141%     -66.7%      17.00 ±141%  interrupts.4:IO-APIC.4-edge.ttyS0
      1.33 ± 70%    +900.0%      13.33 ±141%    -100.0%       0.00        interrupts.50:PCI-MSI.31981583-edge.i40e-eth0-TxRx-14
    138.67 ±139%     -99.3%       1.00 ±141%     -99.5%       0.67 ±141%  interrupts.51:PCI-MSI.31981584-edge.i40e-eth0-TxRx-15
      2.67 ± 35%    +262.5%       9.67 ±141%     -37.5%       1.67 ± 74%  interrupts.52:PCI-MSI.31981585-edge.i40e-eth0-TxRx-16
      3.33 ±120%     -70.0%       1.00 ±141%   +3710.0%     127.00 ±140%  interrupts.53:PCI-MSI.31981586-edge.i40e-eth0-TxRx-17
      1.67 ±101%    -100.0%       0.00          -100.0%       0.00        interrupts.54:PCI-MSI.31981587-edge.i40e-eth0-TxRx-18
      2.00 ± 81%  +44283.3%     887.67 ±141%     -33.3%       1.33 ± 70%  interrupts.55:PCI-MSI.31981588-edge.i40e-eth0-TxRx-19
      0.00       +1.7e+104%     173.00 ±141%   +1e+102%       1.00 ±141%  interrupts.56:PCI-MSI.31981589-edge.i40e-eth0-TxRx-20
      1.67 ±141%     -80.0%       0.33 ±141%    -100.0%       0.00        interrupts.57:PCI-MSI.31981590-edge.i40e-eth0-TxRx-21
      3.33 ± 70%     -80.0%       0.67 ±141%     -90.0%       0.33 ±141%  interrupts.58:PCI-MSI.31981591-edge.i40e-eth0-TxRx-22
      3.33 ±141%     -90.0%       0.33 ±141%    -100.0%       0.00        interrupts.59:PCI-MSI.31981592-edge.i40e-eth0-TxRx-23
      0.00       +3.1e+103%      30.67 ±141%    -100.0%       0.00        interrupts.60:PCI-MSI.31981593-edge.i40e-eth0-TxRx-24
      0.00       +3.8e+103%      38.33 ± 84% +6.7e+101%       0.67 ±141%  interrupts.61:PCI-MSI.31981594-edge.i40e-eth0-TxRx-25
      1.33 ± 93%   +7425.0%     100.33 ±141%     -25.0%       1.00 ±141%  interrupts.62:PCI-MSI.31981595-edge.i40e-eth0-TxRx-26
      0.00       +2.3e+102%       2.33 ± 88% +3.3e+101%       0.33 ±141%  interrupts.63:PCI-MSI.31981596-edge.i40e-eth0-TxRx-27
      0.00          -100.0%       0.00       +3.7e+102%       3.67 ± 46%  interrupts.64:PCI-MSI.31981597-edge.i40e-eth0-TxRx-28
      0.00       +1.1e+104%     106.00 ±115%    -100.0%       0.00        interrupts.65:PCI-MSI.31981598-edge.i40e-eth0-TxRx-29
      2.00 ±141%    +100.0%       4.00 ±141%   +1216.7%      26.33 ±136%  interrupts.66:PCI-MSI.31981599-edge.i40e-eth0-TxRx-30
     16.00 ±128%    -100.0%       0.00           -81.2%       3.00 ± 81%  interrupts.67:PCI-MSI.31981600-edge.i40e-eth0-TxRx-31
      2.67 ±141%    -100.0%       0.00           +25.0%       3.33 ±101%  interrupts.68:PCI-MSI.31981601-edge.i40e-eth0-TxRx-32
     16.00 ±141%   +4533.3%     741.33 ±141%      +0.0%      16.00 ±115%  interrupts.69:PCI-MSI.31981602-edge.i40e-eth0-TxRx-33
      0.67 ±141%    -100.0%       0.00            +0.0%       0.67 ± 70%  interrupts.70:PCI-MSI.31981603-edge.i40e-eth0-TxRx-34
    346.33 ±141%     -99.5%       1.67 ±141%     -99.2%       2.67 ± 93%  interrupts.71:PCI-MSI.31981604-edge.i40e-eth0-TxRx-35
      0.33 ±141%    -100.0%       0.00         +9800.0%      33.00 ±139%  interrupts.72:PCI-MSI.31981605-edge.i40e-eth0-TxRx-36
      0.00         +2e+102%       2.00 ± 81%   +1e+102%       1.00 ±141%  interrupts.73:PCI-MSI.31981606-edge.i40e-eth0-TxRx-37
      0.00       +3.3e+101%       0.33 ±141%   +2e+104%     203.00 ±140%  interrupts.74:PCI-MSI.31981607-edge.i40e-eth0-TxRx-38
      5.33 ±141%   +2225.0%     124.00 ±133%    +112.5%      11.33 ±129%  interrupts.75:PCI-MSI.31981608-edge.i40e-eth0-TxRx-39
      1.00 ±141%    -100.0%       0.00           -33.3%       0.67 ±141%  interrupts.76:PCI-MSI.31981609-edge.i40e-eth0-TxRx-40
      0.00       +2.8e+103%      28.33 ±141%    -100.0%       0.00        interrupts.77:PCI-MSI.31981610-edge.i40e-eth0-TxRx-41
     13.33 ±141%    -100.0%       0.00          +125.0%      30.00 ± 71%  interrupts.78:PCI-MSI.31981611-edge.i40e-eth0-TxRx-42
     17.67 ±141%     -90.6%       1.67 ±141%    -100.0%       0.00        interrupts.79:PCI-MSI.31981612-edge.i40e-eth0-TxRx-43
      0.00       +6.7e+101%       0.67 ±141% +6.7e+101%       0.67 ±141%  interrupts.80:PCI-MSI.31981613-edge.i40e-eth0-TxRx-44
    165.33 ±141%     -99.4%       1.00 ± 81%     -99.6%       0.67 ±141%  interrupts.81:PCI-MSI.31981614-edge.i40e-eth0-TxRx-45
      0.00          -100.0%       0.00         +1e+103%      10.00 ± 64%  interrupts.82:PCI-MSI.31981615-edge.i40e-eth0-TxRx-46
      0.00       +1.7e+102%       1.67 ± 74%   +1e+102%       1.00 ±141%  interrupts.83:PCI-MSI.31981616-edge.i40e-eth0-TxRx-47
      9874 ±141%    -100.0%       0.67 ±141%    -100.0%       1.00 ±141%  interrupts.84:PCI-MSI.31981617-edge.i40e-eth0-TxRx-48
      0.00         +2e+105%       2013 ±141% +1.3e+102%       1.33 ±141%  interrupts.85:PCI-MSI.31981618-edge.i40e-eth0-TxRx-49
    278.33 ±133%    -100.0%       0.00           -99.3%       2.00 ± 81%  interrupts.86:PCI-MSI.31981619-edge.i40e-eth0-TxRx-50
      3.33 ±120%   +1460.0%      52.00 ±137%     -80.0%       0.67 ±141%  interrupts.87:PCI-MSI.31981620-edge.i40e-eth0-TxRx-51
     28.33 ±141%     -97.6%       0.67 ±141%     -98.8%       0.33 ±141%  interrupts.88:PCI-MSI.31981621-edge.i40e-eth0-TxRx-52
     25.33 ±141%    -100.0%       0.00           +31.6%      33.33 ±139%  interrupts.89:PCI-MSI.31981622-edge.i40e-eth0-TxRx-53
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.8:IO-APIC.8-edge.rtc0
     38.33 ± 47%     -21.7%      30.00 ±127%     -64.3%      13.67 ±141%  interrupts.90:PCI-MSI.31981623-edge.i40e-eth0-TxRx-54
      0.00       +1.5e+103%      15.00 ±123% +6.7e+101%       0.67 ± 70%  interrupts.91:PCI-MSI.31981624-edge.i40e-eth0-TxRx-55
      0.33 ±141%    +500.0%       2.00 ±141%      +0.0%       0.33 ±141%  interrupts.92:PCI-MSI.31981625-edge.i40e-eth0-TxRx-56
      1.00 ± 81%    +600.0%       7.00 ±141%    +133.3%       2.33 ± 72%  interrupts.93:PCI-MSI.31981626-edge.i40e-eth0-TxRx-57
     11.67 ±129%     -65.7%       4.00 ±141%    -100.0%       0.00        interrupts.94:PCI-MSI.31981627-edge.i40e-eth0-TxRx-58
    202.33 ±141%    -100.0%       0.00           -92.9%      14.33 ±126%  interrupts.95:PCI-MSI.31981628-edge.i40e-eth0-TxRx-59
     25.67 ±138%     -96.1%       1.00 ± 81%    -100.0%       0.00        interrupts.96:PCI-MSI.31981629-edge.i40e-eth0-TxRx-60
      1.33 ±141%     +75.0%       2.33 ±141%    -100.0%       0.00        interrupts.97:PCI-MSI.31981630-edge.i40e-eth0-TxRx-61
      2.00 ± 81%    -100.0%       0.00        +29100.0%     584.00 ±141%  interrupts.98:PCI-MSI.31981631-edge.i40e-eth0-TxRx-62
      1.67 ± 74%    -100.0%       0.00            +0.0%       1.67 ±141%  interrupts.99:PCI-MSI.31981632-edge.i40e-eth0-TxRx-63
  44400026 ±  2%     -34.7%   29014465 ±  4%      -7.0%   41301128        interrupts.CAL:Function_call_interrupts
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU0.0:IO-APIC.2-edge.timer
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU0.119:PCI-MSI.31981652-edge.i40e-eth0-TxRx-83
      0.33 ±141%    +100.0%       0.67 ± 70%   +1200.0%       4.33 ± 84%  interrupts.CPU0.36:PCI-MSI.31981569-edge.i40e-eth0-TxRx-0
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU0.71:PCI-MSI.31981604-edge.i40e-eth0-TxRx-35
    283657 ± 20%      -9.4%     256976 ± 10%     +24.1%     351971 ± 39%  interrupts.CPU0.CAL:Function_call_interrupts
     19.67 ± 65%    +116.9%      42.67 ± 51%     -57.6%       8.33 ± 46%  interrupts.CPU0.IWI:IRQ_work_interrupts
    406071            -4.4%     388293 ±  3%      -0.7%     403259        interrupts.CPU0.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU0.MCP:Machine_check_polls
     10126 ± 25%     +47.7%      14953 ± 26%     -34.0%       6681 ± 19%  interrupts.CPU0.NMI:Non-maskable_interrupts
     10126 ± 25%     +47.7%      14953 ± 26%     -34.0%       6681 ± 19%  interrupts.CPU0.PMI:Performance_monitoring_interrupts
    364.67 ±  8%     +16.4%     424.33 ± 13%     -26.9%     266.67 ± 27%  interrupts.CPU0.RES:Rescheduling_interrupts
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU0.RTR:APIC_ICR_read_retries
    339733 ± 20%      -5.2%     322171 ± 11%     +28.0%     434790 ± 39%  interrupts.CPU0.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU1.120:PCI-MSI.31981653-edge.i40e-eth0-TxRx-84
      2.00 ± 70%     -66.7%       0.67 ±141%     -50.0%       1.00 ± 81%  interrupts.CPU1.37:PCI-MSI.31981570-edge.i40e-eth0-TxRx-1
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU1.72:PCI-MSI.31981605-edge.i40e-eth0-TxRx-36
    367667 ± 22%     -21.0%     290475 ± 33%     +23.2%     453123 ± 15%  interrupts.CPU1.CAL:Function_call_interrupts
     46.33 ± 76%      +3.6%      48.00 ± 35%      -7.2%      43.00 ± 66%  interrupts.CPU1.IWI:IRQ_work_interrupts
    405981            -6.0%     381457 ±  7%      -1.3%     400689        interrupts.CPU1.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU1.MCP:Machine_check_polls
     15433 ± 44%      +7.4%      16571 ± 21%      -5.7%      14553 ± 35%  interrupts.CPU1.NMI:Non-maskable_interrupts
     15433 ± 44%      +7.4%      16571 ± 21%      -5.7%      14553 ± 35%  interrupts.CPU1.PMI:Performance_monitoring_interrupts
    488.67 ± 25%      -5.5%     461.67 ± 17%     -21.5%     383.67        interrupts.CPU1.RES:Rescheduling_interrupts
    442026 ± 21%     -16.4%     369476 ± 34%     +26.0%     556889 ± 15%  interrupts.CPU1.TLB:TLB_shootdowns
      0.33 ±141%    -100.0%       0.00          -100.0%       0.00        interrupts.CPU10.129:PCI-MSI.31981662-edge.i40e-eth0-TxRx-93
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU10.293:PCI-MSI.327680-edge.xhci_hcd
      1.00 ±141%     +33.3%       1.33 ± 70%  +10566.7%     106.67 ±141%  interrupts.CPU10.46:PCI-MSI.31981579-edge.i40e-eth0-TxRx-10
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        interrupts.CPU10.81:PCI-MSI.31981614-edge.i40e-eth0-TxRx-45
    396415 ± 21%     -39.8%     238582 ± 29%      -2.0%     388354 ± 22%  interrupts.CPU10.CAL:Function_call_interrupts
     34.00 ± 74%     -56.9%      14.67 ±112%     +35.3%      46.00 ± 62%  interrupts.CPU10.IWI:IRQ_work_interrupts
    405976            -3.8%     390689 ±  2%      -1.3%     400589        interrupts.CPU10.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU10.MCP:Machine_check_polls
     14276 ± 42%     -36.1%       9119 ± 39%      -1.4%      14077 ± 39%  interrupts.CPU10.NMI:Non-maskable_interrupts
     14276 ± 42%     -36.1%       9119 ± 39%      -1.4%      14077 ± 39%  interrupts.CPU10.PMI:Performance_monitoring_interrupts
    443.00 ± 25%      -7.1%     411.67 ± 38%      -8.1%     407.00 ± 40%  interrupts.CPU10.RES:Rescheduling_interrupts
    478632 ± 21%     -36.7%     303071 ± 30%      -0.3%     477055 ± 22%  interrupts.CPU10.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU11.297:PCI-MSI.67584-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU11.298:PCI-MSI.69632-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU11.299:PCI-MSI.71680-edge.ioat-msix
      0.67 ±141%    +300.0%       2.67 ±141%    -100.0%       0.00        interrupts.CPU11.47:PCI-MSI.31981580-edge.i40e-eth0-TxRx-11
      0.00          -100.0%       0.00       +6.7e+101%       0.67 ± 70%  interrupts.CPU11.82:PCI-MSI.31981615-edge.i40e-eth0-TxRx-46
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU11.8:IO-APIC.8-edge.rtc0
    431957 ± 22%     -45.4%     235711 ± 14%     +16.6%     503679 ± 27%  interrupts.CPU11.CAL:Function_call_interrupts
     35.33 ± 81%     -59.4%      14.33 ±111%     +53.8%      54.33 ± 35%  interrupts.CPU11.IWI:IRQ_work_interrupts
    406106            -4.8%     386741 ±  4%      -1.6%     399776        interrupts.CPU11.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU11.MCP:Machine_check_polls
     13693 ± 43%     -31.3%       9402 ± 35%     +21.1%      16577 ± 26%  interrupts.CPU11.NMI:Non-maskable_interrupts
     13693 ± 43%     -31.3%       9402 ± 35%     +21.1%      16577 ± 26%  interrupts.CPU11.PMI:Performance_monitoring_interrupts
    625.33 ± 30%     -49.3%     317.33 ± 14%     -37.5%     391.00 ± 28%  interrupts.CPU11.RES:Rescheduling_interrupts
    519094 ± 22%     -42.3%     299492 ± 14%     +19.2%     618914 ± 27%  interrupts.CPU11.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU12.298:PCI-MSI.69632-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU12.299:PCI-MSI.69632-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU12.299:PCI-MSI.71680-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU12.300:PCI-MSI.73728-edge.ioat-msix
      0.33 ±141%    +100.0%       0.67 ±141%    -100.0%       0.00        interrupts.CPU12.48:PCI-MSI.31981581-edge.i40e-eth0-TxRx-12
      0.00       +6.7e+101%       0.67 ± 70%    -100.0%       0.00        interrupts.CPU12.83:PCI-MSI.31981616-edge.i40e-eth0-TxRx-47
    407872 ± 22%      -9.2%     370181 ± 25%      +2.5%     418228 ± 31%  interrupts.CPU12.CAL:Function_call_interrupts
     19.33 ± 63%     -39.7%      11.67 ± 61%    +224.1%      62.67 ± 32%  interrupts.CPU12.IWI:IRQ_work_interrupts
    406318            -5.5%     384051 ±  3%      -1.2%     401550        interrupts.CPU12.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU12.MCP:Machine_check_polls
     10237 ± 22%     -27.5%       7423 ±  8%     +79.5%      18379 ± 20%  interrupts.CPU12.NMI:Non-maskable_interrupts
     10237 ± 22%     -27.5%       7423 ±  8%     +79.5%      18379 ± 20%  interrupts.CPU12.PMI:Performance_monitoring_interrupts
    535.00 ± 10%      +4.5%     559.00 ± 43%     -35.3%     346.33 ± 20%  interrupts.CPU12.RES:Rescheduling_interrupts
    491323 ± 21%      -4.8%     467840 ± 26%      +4.7%     514580 ± 31%  interrupts.CPU12.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU13.295:PCI-MSI.65536-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU13.298:PCI-MSI.69632-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU13.299:PCI-MSI.71680-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU13.300:PCI-MSI.71680-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU13.300:PCI-MSI.73728-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU13.301:PCI-MSI.75776-edge.ioat-msix
      0.33 ±141%    -100.0%       0.00          +100.0%       0.67 ± 70%  interrupts.CPU13.36:PCI-MSI.31981569-edge.i40e-eth0-TxRx-0
      0.67 ± 70%      +0.0%       0.67 ±141%    +800.0%       6.00 ±141%  interrupts.CPU13.49:PCI-MSI.31981582-edge.i40e-eth0-TxRx-13
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        interrupts.CPU13.84:PCI-MSI.31981617-edge.i40e-eth0-TxRx-48
    494664 ± 29%     -31.7%     338043 ± 39%      +0.5%     497024 ± 13%  interrupts.CPU13.CAL:Function_call_interrupts
     35.33 ± 69%     -17.0%      29.33 ± 84%      +0.0%      35.33 ± 71%  interrupts.CPU13.IWI:IRQ_work_interrupts
    405940            -7.5%     375579 ±  8%      -1.3%     400478        interrupts.CPU13.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU13.MCP:Machine_check_polls
     13375 ± 42%      -3.8%      12867 ± 45%      -8.1%      12287 ± 37%  interrupts.CPU13.NMI:Non-maskable_interrupts
     13375 ± 42%      -3.8%      12867 ± 45%      -8.1%      12287 ± 37%  interrupts.CPU13.PMI:Performance_monitoring_interrupts
    628.67 ± 24%     -30.9%     434.67 ± 32%     -38.5%     386.67 ±  6%  interrupts.CPU13.RES:Rescheduling_interrupts
    594215 ± 28%     -27.6%     430176 ± 38%      +2.8%     611002 ± 13%  interrupts.CPU13.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU14.295:PCI-MSI.65536-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU14.299:PCI-MSI.71680-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU14.300:PCI-MSI.73728-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU14.301:PCI-MSI.73728-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU14.301:PCI-MSI.75776-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU14.302:PCI-MSI.77824-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU14.37:PCI-MSI.31981570-edge.i40e-eth0-TxRx-1
     34.00 ± 70%    -100.0%       0.00          -100.0%       0.00        interrupts.CPU14.4:IO-APIC.4-edge.ttyS0
      1.00 ± 81%   +1233.3%      13.33 ±141%    -100.0%       0.00        interrupts.CPU14.50:PCI-MSI.31981583-edge.i40e-eth0-TxRx-14
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU14.85:PCI-MSI.31981618-edge.i40e-eth0-TxRx-49
    429908 ± 45%     -31.4%     294961 ± 40%     +17.3%     504403 ± 13%  interrupts.CPU14.CAL:Function_call_interrupts
     41.00 ± 39%      -9.8%      37.00 ± 74%     +54.5%      63.33 ± 26%  interrupts.CPU14.IWI:IRQ_work_interrupts
    405953            -6.7%     378674 ±  7%      -1.8%     398752        interrupts.CPU14.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU14.MCP:Machine_check_polls
     14767 ± 26%      -2.8%      14360 ± 41%     +22.6%      18108 ± 17%  interrupts.CPU14.NMI:Non-maskable_interrupts
     14767 ± 26%      -2.8%      14360 ± 41%     +22.6%      18108 ± 17%  interrupts.CPU14.PMI:Performance_monitoring_interrupts
    607.33 ± 29%     -16.5%     507.33 ± 28%     -22.3%     472.00 ± 42%  interrupts.CPU14.RES:Rescheduling_interrupts
    517489 ± 45%     -27.3%     376184 ± 40%     +19.6%     618675 ± 13%  interrupts.CPU14.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU15.295:PCI-MSI.65536-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU15.300:PCI-MSI.73728-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU15.301:PCI-MSI.75776-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU15.302:PCI-MSI.75776-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU15.302:PCI-MSI.77824-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU15.303:PCI-MSI.79872-edge.ioat-msix
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        interrupts.CPU15.38:PCI-MSI.31981571-edge.i40e-eth0-TxRx-2
     17.00 ±141%    -100.0%       0.00            +0.0%      17.00 ±141%  interrupts.CPU15.4:IO-APIC.4-edge.ttyS0
    138.67 ±139%     -99.3%       1.00 ±141%     -99.5%       0.67 ±141%  interrupts.CPU15.51:PCI-MSI.31981584-edge.i40e-eth0-TxRx-15
      0.00          -100.0%       0.00       +6.7e+101%       0.67 ± 70%  interrupts.CPU15.86:PCI-MSI.31981619-edge.i40e-eth0-TxRx-50
    465405 ± 12%     -23.4%     356420 ±  8%     -10.6%     416247 ± 22%  interrupts.CPU15.CAL:Function_call_interrupts
     52.67 ± 55%     -48.7%      27.00 ± 30%     -13.9%      45.33 ± 66%  interrupts.CPU15.IWI:IRQ_work_interrupts
    405874            -6.2%     380728 ±  4%      -1.1%     401458        interrupts.CPU15.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU15.MCP:Machine_check_polls
     17292 ± 37%     -31.0%      11937 ± 14%     -18.0%      14174 ± 42%  interrupts.CPU15.NMI:Non-maskable_interrupts
     17292 ± 37%     -31.0%      11937 ± 14%     -18.0%      14174 ± 42%  interrupts.CPU15.PMI:Performance_monitoring_interrupts
    545.67 ± 18%      +8.2%     590.67 ± 28%     -36.2%     348.00 ± 28%  interrupts.CPU15.RES:Rescheduling_interrupts
    560304 ± 11%     -19.2%     452556 ±  8%      -8.7%     511541 ± 22%  interrupts.CPU15.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU16.295:PCI-MSI.65536-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU16.301:PCI-MSI.75776-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU16.302:PCI-MSI.77824-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU16.303:PCI-MSI.77824-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU16.303:PCI-MSI.79872-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU16.304:PCI-MSI.79872-edge.ioat-msix
      0.33 ±141%      +0.0%       0.33 ±141%      +0.0%       0.33 ±141%  interrupts.CPU16.39:PCI-MSI.31981572-edge.i40e-eth0-TxRx-3
      0.00       +2.2e+103%      21.67 ±141%    -100.0%       0.00        interrupts.CPU16.4:IO-APIC.4-edge.ttyS0
      2.33 ± 53%    +314.3%       9.67 ±141%     -42.9%       1.33 ± 93%  interrupts.CPU16.52:PCI-MSI.31981585-edge.i40e-eth0-TxRx-16
      0.33 ±141%      +0.0%       0.33 ±141%      +0.0%       0.33 ±141%  interrupts.CPU16.87:PCI-MSI.31981620-edge.i40e-eth0-TxRx-51
    452155 ± 17%     -45.2%     247563 ± 14%     -25.6%     336433 ± 27%  interrupts.CPU16.CAL:Function_call_interrupts
     38.67 ± 81%     -30.2%      27.00 ± 78%     +47.4%      57.00 ± 40%  interrupts.CPU16.IWI:IRQ_work_interrupts
    405978            -4.4%     388008 ±  3%      -1.0%     402086        interrupts.CPU16.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU16.MCP:Machine_check_polls
     14316 ± 40%     -19.5%      11529 ± 42%     +20.8%      17286 ± 28%  interrupts.CPU16.NMI:Non-maskable_interrupts
     14316 ± 40%     -19.5%      11529 ± 42%     +20.8%      17286 ± 28%  interrupts.CPU16.PMI:Performance_monitoring_interrupts
    605.33           -24.6%     456.33 ± 24%     -53.8%     279.67 ± 13%  interrupts.CPU16.RES:Rescheduling_interrupts
    543705 ± 17%     -41.9%     315853 ± 15%     -24.3%     411397 ± 28%  interrupts.CPU16.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU17.295:PCI-MSI.65536-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU17.302:PCI-MSI.77824-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU17.303:PCI-MSI.79872-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU17.304:PCI-MSI.79872-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU17.315:PCI-MSI.376832-edge.ahci[0000:00:17.0]
      0.33 ±141%      +0.0%       0.33 ±141%    -100.0%       0.00        interrupts.CPU17.40:PCI-MSI.31981573-edge.i40e-eth0-TxRx-4
      2.67 ±141%     -75.0%       0.67 ±141%   +4637.5%     126.33 ±141%  interrupts.CPU17.53:PCI-MSI.31981586-edge.i40e-eth0-TxRx-17
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU17.88:PCI-MSI.31981621-edge.i40e-eth0-TxRx-52
    360610 ± 26%     -13.9%     310546 ± 21%     +28.0%     461533 ± 41%  interrupts.CPU17.CAL:Function_call_interrupts
     20.00 ± 99%     -10.0%      18.00 ± 74%    +116.7%      43.33 ± 69%  interrupts.CPU17.IWI:IRQ_work_interrupts
    405962            -5.2%     384737 ±  4%      -1.3%     400806        interrupts.CPU17.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU17.MCP:Machine_check_polls
     10569 ± 36%      -5.4%      10001 ± 29%     +34.4%      14200 ± 45%  interrupts.CPU17.NMI:Non-maskable_interrupts
     10569 ± 36%      -5.4%      10001 ± 29%     +34.4%      14200 ± 45%  interrupts.CPU17.PMI:Performance_monitoring_interrupts
    479.00 ± 33%     -19.2%     387.00 ±  5%     -24.0%     364.00 ± 33%  interrupts.CPU17.RES:Rescheduling_interrupts
    435283 ± 26%      -9.0%     396264 ± 21%     +30.4%     567766 ± 41%  interrupts.CPU17.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU18.303:PCI-MSI.79872-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU18.314:PCI-MSI.376832-edge.ahci[0000:00:17.0]
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU18.315:PCI-MSI.376832-edge.ahci[0000:00:17.0]
      0.00       +6.7e+101%       0.67 ± 70% +3.3e+101%       0.33 ±141%  interrupts.CPU18.41:PCI-MSI.31981574-edge.i40e-eth0-TxRx-5
      1.00 ±141%    -100.0%       0.00          -100.0%       0.00        interrupts.CPU18.54:PCI-MSI.31981587-edge.i40e-eth0-TxRx-18
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU18.89:PCI-MSI.31981622-edge.i40e-eth0-TxRx-53
    395462 ± 11%     -16.7%     329268 ± 15%      +6.9%     422919 ± 27%  interrupts.CPU18.CAL:Function_call_interrupts
     27.67 ± 99%     +30.1%      36.00 ± 72%    +136.1%      65.33 ± 25%  interrupts.CPU18.IWI:IRQ_work_interrupts
    405927            -6.6%     379114 ±  6%      -1.0%     402006        interrupts.CPU18.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU18.MCP:Machine_check_polls
     12029 ± 51%     +16.9%      14066 ± 42%     +58.3%      19042 ± 18%  interrupts.CPU18.NMI:Non-maskable_interrupts
     12029 ± 51%     +16.9%      14066 ± 42%     +58.3%      19042 ± 18%  interrupts.CPU18.PMI:Performance_monitoring_interrupts
    505.33 ± 12%      -2.3%     493.67 ± 32%     -29.9%     354.00 ± 23%  interrupts.CPU18.RES:Rescheduling_interrupts
    475837 ± 10%     -11.8%     419517 ± 14%      +9.6%     521656 ± 27%  interrupts.CPU18.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU19.315:PCI-MSI.376832-edge.ahci[0000:00:17.0]
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU19.3:IO-APIC.3-edge
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        interrupts.CPU19.42:PCI-MSI.31981575-edge.i40e-eth0-TxRx-6
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU19.4:IO-APIC.4-edge.ttyS0
      1.33 ± 93%  +66475.0%     887.67 ±141%     -50.0%       0.67 ± 70%  interrupts.CPU19.55:PCI-MSI.31981588-edge.i40e-eth0-TxRx-19
      0.33 ±141%    -100.0%       0.00          -100.0%       0.00        interrupts.CPU19.90:PCI-MSI.31981623-edge.i40e-eth0-TxRx-54
    590338 ± 10%     -27.9%     425688 ±  8%     -18.6%     480366 ± 14%  interrupts.CPU19.CAL:Function_call_interrupts
     75.33 ± 19%     -11.1%      67.00 ±  7%     -59.7%      30.33 ± 74%  interrupts.CPU19.IWI:IRQ_work_interrupts
    406123            -7.8%     374335 ±  7%      -1.3%     400685        interrupts.CPU19.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU19.MCP:Machine_check_polls
     21659 ± 15%      -6.7%      20207 ±  2%     -45.7%      11770 ± 38%  interrupts.CPU19.NMI:Non-maskable_interrupts
     21659 ± 15%      -6.7%      20207 ±  2%     -45.7%      11770 ± 38%  interrupts.CPU19.PMI:Performance_monitoring_interrupts
    671.33 ± 20%     -18.5%     547.00 ± 12%     -36.7%     424.67 ±  3%  interrupts.CPU19.RES:Rescheduling_interrupts
    711808 ± 10%     -24.1%     540475 ±  8%     -17.3%     588929 ± 15%  interrupts.CPU19.TLB:TLB_shootdowns
      0.33 ±141%      +0.0%       0.33 ±141%    +100.0%       0.67 ± 70%  interrupts.CPU2.121:PCI-MSI.31981654-edge.i40e-eth0-TxRx-85
    949.00 ±110%     -99.9%       1.33 ±141%    -100.0%       0.00        interrupts.CPU2.38:PCI-MSI.31981571-edge.i40e-eth0-TxRx-2
      0.00       +3.3e+101%       0.33 ±141% +3.3e+101%       0.33 ±141%  interrupts.CPU2.73:PCI-MSI.31981606-edge.i40e-eth0-TxRx-37
    411168 ± 16%     -33.7%     272520 ± 29%      -4.3%     393383 ± 12%  interrupts.CPU2.CAL:Function_call_interrupts
     31.00 ±127%     -21.5%      24.33 ±112%      -1.1%      30.67 ±116%  interrupts.CPU2.IWI:IRQ_work_interrupts
    405931            -4.8%     386630 ±  4%      -1.4%     400119        interrupts.CPU2.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU2.MCP:Machine_check_polls
     11993 ± 75%     +16.0%      13908 ± 31%      +1.0%      12110 ± 60%  interrupts.CPU2.NMI:Non-maskable_interrupts
     11993 ± 75%     +16.0%      13908 ± 31%      +1.0%      12110 ± 60%  interrupts.CPU2.PMI:Performance_monitoring_interrupts
    539.33 ± 28%     -26.8%     395.00 ±  8%     -36.2%     344.00 ± 26%  interrupts.CPU2.RES:Rescheduling_interrupts
    494494 ± 15%     -29.8%     347147 ± 29%      -2.5%     482047 ± 13%  interrupts.CPU2.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU20.315:PCI-MSI.376832-edge.ahci[0000:00:17.0]
      0.33 ±141%      +0.0%       0.33 ±141%    -100.0%       0.00        interrupts.CPU20.43:PCI-MSI.31981576-edge.i40e-eth0-TxRx-7
      0.00       +1.7e+104%     173.00 ±141%   +1e+102%       1.00 ±141%  interrupts.CPU20.56:PCI-MSI.31981589-edge.i40e-eth0-TxRx-20
      0.00       +3.3e+101%       0.33 ±141% +3.3e+101%       0.33 ±141%  interrupts.CPU20.91:PCI-MSI.31981624-edge.i40e-eth0-TxRx-55
    493806 ±  9%     -30.4%     343541 ± 18%      -7.4%     457350 ± 21%  interrupts.CPU20.CAL:Function_call_interrupts
     52.67 ± 26%      +0.6%      53.00 ± 40%     +27.2%      67.00 ± 37%  interrupts.CPU20.IWI:IRQ_work_interrupts
    405941            -7.3%     376506 ±  6%      -1.0%     401805        interrupts.CPU20.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU20.MCP:Machine_check_polls
     19248 ± 15%     -10.3%      17257 ± 24%      +2.9%      19803 ± 24%  interrupts.CPU20.NMI:Non-maskable_interrupts
     19248 ± 15%     -10.3%      17257 ± 24%      +2.9%      19803 ± 24%  interrupts.CPU20.PMI:Performance_monitoring_interrupts
    551.33 ± 10%      -8.6%     504.00 ± 31%     -32.9%     370.00 ± 25%  interrupts.CPU20.RES:Rescheduling_interrupts
    595289 ±  9%     -26.6%     436974 ± 18%      -5.3%     563830 ± 20%  interrupts.CPU20.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU21.3:IO-APIC.3-edge
      0.33 ±141%    -100.0%       0.00          -100.0%       0.00        interrupts.CPU21.44:PCI-MSI.31981577-edge.i40e-eth0-TxRx-8
      1.67 ±141%    -100.0%       0.00          -100.0%       0.00        interrupts.CPU21.57:PCI-MSI.31981590-edge.i40e-eth0-TxRx-21
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU21.92:PCI-MSI.31981625-edge.i40e-eth0-TxRx-56
    369712 ± 22%     -19.2%     298636 ± 25%     +49.9%     554264 ± 22%  interrupts.CPU21.CAL:Function_call_interrupts
     27.33 ±100%     +79.3%      49.00 ± 43%    +202.4%      82.67 ±  4%  interrupts.CPU21.IWI:IRQ_work_interrupts
    406295            -6.2%     380959 ±  6%      -1.6%     399836        interrupts.CPU21.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU21.MCP:Machine_check_polls
     15671 ± 33%      +4.9%      16433 ± 32%     +45.2%      22759 ±  3%  interrupts.CPU21.NMI:Non-maskable_interrupts
     15671 ± 33%      +4.9%      16433 ± 32%     +45.2%      22759 ±  3%  interrupts.CPU21.PMI:Performance_monitoring_interrupts
    438.00 ± 27%      +4.5%     457.67 ± 31%     +10.3%     483.00 ± 29%  interrupts.CPU21.RES:Rescheduling_interrupts
    448885 ± 22%     -15.7%     378279 ± 25%     +52.3%     683715 ± 22%  interrupts.CPU21.TLB:TLB_shootdowns
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        interrupts.CPU22.45:PCI-MSI.31981578-edge.i40e-eth0-TxRx-9
      3.33 ± 70%     -80.0%       0.67 ±141%    -100.0%       0.00        interrupts.CPU22.58:PCI-MSI.31981591-edge.i40e-eth0-TxRx-22
      0.00          -100.0%       0.00       +6.7e+101%       0.67 ± 70%  interrupts.CPU22.93:PCI-MSI.31981626-edge.i40e-eth0-TxRx-57
    390922 ± 25%     -13.4%     338503 ± 33%      +4.2%     407239 ± 28%  interrupts.CPU22.CAL:Function_call_interrupts
     53.00 ± 41%     -17.6%      43.67 ± 70%      +3.8%      55.00 ± 31%  interrupts.CPU22.IWI:IRQ_work_interrupts
    405987            -7.5%     375589 ±  6%      -1.3%     400885        interrupts.CPU22.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU22.MCP:Machine_check_polls
     17138 ± 29%     -13.1%      14884 ± 46%     +11.2%      19059 ± 13%  interrupts.CPU22.NMI:Non-maskable_interrupts
     17138 ± 29%     -13.1%      14884 ± 46%     +11.2%      19059 ± 13%  interrupts.CPU22.PMI:Performance_monitoring_interrupts
    555.33 ± 43%      -2.6%     540.67 ± 40%     -34.1%     366.00 ± 22%  interrupts.CPU22.RES:Rescheduling_interrupts
    470886 ± 25%      -9.0%     428590 ± 32%      +6.4%     501133 ± 27%  interrupts.CPU22.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU23.46:PCI-MSI.31981579-edge.i40e-eth0-TxRx-10
      3.00 ±141%     -88.9%       0.33 ±141%    -100.0%       0.00        interrupts.CPU23.59:PCI-MSI.31981592-edge.i40e-eth0-TxRx-23
      0.33 ±141%      +0.0%       0.33 ±141%    -100.0%       0.00        interrupts.CPU23.94:PCI-MSI.31981627-edge.i40e-eth0-TxRx-58
    526486 ±  8%     -43.1%     299585 ± 32%     -12.4%     461167 ± 15%  interrupts.CPU23.CAL:Function_call_interrupts
     53.00 ± 64%     -52.8%      25.00 ±127%     +21.4%      64.33 ± 23%  interrupts.CPU23.IWI:IRQ_work_interrupts
    406207            -6.9%     378081 ±  7%      -1.6%     399585        interrupts.CPU23.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU23.MCP:Machine_check_polls
     17383 ± 43%     -33.2%      11608 ± 60%     +11.1%      19320 ± 15%  interrupts.CPU23.NMI:Non-maskable_interrupts
     17383 ± 43%     -33.2%      11608 ± 60%     +11.1%      19320 ± 15%  interrupts.CPU23.PMI:Performance_monitoring_interrupts
    592.67 ± 11%     -16.3%     496.00 ± 37%     -36.3%     377.33 ± 33%  interrupts.CPU23.RES:Rescheduling_interrupts
    634502 ±  7%     -39.9%     381622 ± 32%     -10.5%     567846 ± 15%  interrupts.CPU23.TLB:TLB_shootdowns
      0.00       +3.1e+103%      30.67 ±141%    -100.0%       0.00        interrupts.CPU24.60:PCI-MSI.31981593-edge.i40e-eth0-TxRx-24
    626186 ±  8%     -36.6%     397180 ± 17%     -21.3%     492858 ± 20%  interrupts.CPU24.CAL:Function_call_interrupts
     49.67 ± 58%     +34.9%      67.00 ± 20%      +7.4%      53.33 ± 26%  interrupts.CPU24.IWI:IRQ_work_interrupts
    405954            -7.2%     376928 ±  6%      -1.6%     399622        interrupts.CPU24.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU24.MCP:Machine_check_polls
     17118 ± 22%     +19.4%      20442 ± 11%      -3.1%      16586 ± 17%  interrupts.CPU24.NMI:Non-maskable_interrupts
     17118 ± 22%     +19.4%      20442 ± 11%      -3.1%      16586 ± 17%  interrupts.CPU24.PMI:Performance_monitoring_interrupts
    541.33 ±  7%     -10.6%     484.00 ± 20%     -35.0%     352.00 ± 19%  interrupts.CPU24.RES:Rescheduling_interrupts
    742092 ±  7%     -32.3%     502742 ± 17%     -19.5%     597663 ± 19%  interrupts.CPU24.TLB:TLB_shootdowns
      0.00       +3.8e+103%      38.33 ± 84% +6.7e+101%       0.67 ±141%  interrupts.CPU25.61:PCI-MSI.31981594-edge.i40e-eth0-TxRx-25
    631634 ± 12%     -38.8%     386787 ± 22%     -21.2%     497497 ±  8%  interrupts.CPU25.CAL:Function_call_interrupts
     58.00 ± 49%     -35.1%      37.67 ± 76%      +0.6%      58.33 ±  7%  interrupts.CPU25.IWI:IRQ_work_interrupts
    405937            -6.4%     380097 ±  4%      -1.4%     400147        interrupts.CPU25.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU25.MCP:Machine_check_polls
     18304 ± 30%     -24.2%      13875 ± 41%      -1.2%      18084 ±  8%  interrupts.CPU25.NMI:Non-maskable_interrupts
     18304 ± 30%     -24.2%      13875 ± 41%      -1.2%      18084 ±  8%  interrupts.CPU25.PMI:Performance_monitoring_interrupts
    532.67 ± 15%      -5.3%     504.33 ± 36%     -31.7%     363.67 ± 19%  interrupts.CPU25.RES:Rescheduling_interrupts
    748513 ± 12%     -35.1%     486042 ± 22%     -19.0%     606520 ±  7%  interrupts.CPU25.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU26.305:PCI-MSI.67174400-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU26.306:PCI-MSI.67174400-edge.ioat-msix
      0.67 ±141%  +14950.0%     100.33 ±141%     +50.0%       1.00 ±141%  interrupts.CPU26.62:PCI-MSI.31981595-edge.i40e-eth0-TxRx-26
    614818 ±  2%     -39.3%     373169 ± 21%     -20.6%     488325 ±  6%  interrupts.CPU26.CAL:Function_call_interrupts
     39.67 ± 68%     -58.8%      16.33 ±115%     +33.6%      53.00 ± 44%  interrupts.CPU26.IWI:IRQ_work_interrupts
    405965            -7.1%     376998 ±  7%      -1.4%     400471        interrupts.CPU26.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU26.MCP:Machine_check_polls
     14483 ± 42%     -34.5%       9482 ± 43%     +13.4%      16418 ± 24%  interrupts.CPU26.NMI:Non-maskable_interrupts
     14483 ± 42%     -34.5%       9482 ± 43%     +13.4%      16418 ± 24%  interrupts.CPU26.PMI:Performance_monitoring_interrupts
    429.33 ±  8%      +9.6%     470.67 ± 29%      -9.1%     390.33 ± 11%  interrupts.CPU26.RES:Rescheduling_interrupts
    726518           -35.1%     471845 ± 21%     -18.2%     594355 ±  6%  interrupts.CPU26.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU27.307:PCI-MSI.67176448-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU27.308:PCI-MSI.67176448-edge.ioat-msix
      0.00         +2e+102%       2.00 ± 81%    -100.0%       0.00        interrupts.CPU27.63:PCI-MSI.31981596-edge.i40e-eth0-TxRx-27
    626552 ± 10%     -48.6%     321780 ±  5%     -23.3%     480801 ± 28%  interrupts.CPU27.CAL:Function_call_interrupts
     71.33 ± 25%     -23.4%      54.67 ± 22%     -42.5%      41.00 ± 53%  interrupts.CPU27.IWI:IRQ_work_interrupts
    405925            -5.8%     382267 ±  5%      -1.6%     399501        interrupts.CPU27.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU27.MCP:Machine_check_polls
     21779 ± 18%     -18.8%      17676 ± 15%     -36.4%      13850 ± 34%  interrupts.CPU27.NMI:Non-maskable_interrupts
     21779 ± 18%     -18.8%      17676 ± 15%     -36.4%      13850 ± 34%  interrupts.CPU27.PMI:Performance_monitoring_interrupts
    538.00 ± 15%      -0.2%     536.67 ± 26%     -22.3%     418.00 ± 29%  interrupts.CPU27.RES:Rescheduling_interrupts
    739486 ± 10%     -45.4%     403473 ±  5%     -21.1%     583527 ± 27%  interrupts.CPU27.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU28.308:PCI-MSI.67178496-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU28.309:PCI-MSI.67178496-edge.ioat-msix
      0.00          -100.0%       0.00         +3e+102%       3.00 ± 54%  interrupts.CPU28.64:PCI-MSI.31981597-edge.i40e-eth0-TxRx-28
    688450 ±  3%     -40.5%     409849 ±  7%     -42.9%     393403 ± 43%  interrupts.CPU28.CAL:Function_call_interrupts
     57.00 ± 33%     -47.4%      30.00 ± 82%     -10.5%      51.00 ± 69%  interrupts.CPU28.IWI:IRQ_work_interrupts
    406019            -6.9%     378187 ±  5%      -1.2%     401184        interrupts.CPU28.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU28.MCP:Machine_check_polls
     20813 ±  8%     -39.7%      12554 ± 42%     -23.8%      15869 ± 53%  interrupts.CPU28.NMI:Non-maskable_interrupts
     20813 ±  8%     -39.7%      12554 ± 42%     -23.8%      15869 ± 53%  interrupts.CPU28.PMI:Performance_monitoring_interrupts
    556.00 ± 27%     -15.3%     470.67 ± 18%     -47.6%     291.33 ± 52%  interrupts.CPU28.RES:Rescheduling_interrupts
    815172 ±  3%     -36.7%     515995 ±  7%     -41.4%     477423 ± 42%  interrupts.CPU28.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU29.309:PCI-MSI.67180544-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU29.310:PCI-MSI.67180544-edge.ioat-msix
      0.00       +1.1e+104%     106.00 ±115%    -100.0%       0.00        interrupts.CPU29.65:PCI-MSI.31981598-edge.i40e-eth0-TxRx-29
    601839 ± 19%     -36.5%     382381 ±  8%     -25.3%     449606 ± 11%  interrupts.CPU29.CAL:Function_call_interrupts
     66.00 ± 19%     -39.9%      39.67 ± 73%     -70.7%      19.33 ± 79%  interrupts.CPU29.IWI:IRQ_work_interrupts
    405810            -6.3%     380266 ±  5%      -1.3%     400622        interrupts.CPU29.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU29.MCP:Machine_check_polls
     20318 ± 14%     -30.2%      14175 ± 47%     -43.5%      11473 ± 10%  interrupts.CPU29.NMI:Non-maskable_interrupts
     20318 ± 14%     -30.2%      14175 ± 47%     -43.5%      11473 ± 10%  interrupts.CPU29.PMI:Performance_monitoring_interrupts
    508.00 ± 27%      +9.7%     557.33 ± 22%     -32.2%     344.67 ± 14%  interrupts.CPU29.RES:Rescheduling_interrupts
    712470 ± 19%     -32.8%     478606 ±  8%     -23.4%     546074 ± 11%  interrupts.CPU29.TLB:TLB_shootdowns
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU3.122:PCI-MSI.31981655-edge.i40e-eth0-TxRx-86
      1.33 ± 93%     -50.0%       0.67 ± 70%   +2950.0%      40.67 ±137%  interrupts.CPU3.39:PCI-MSI.31981572-edge.i40e-eth0-TxRx-3
      0.00       +3.3e+101%       0.33 ±141% +3.3e+101%       0.33 ±141%  interrupts.CPU3.74:PCI-MSI.31981607-edge.i40e-eth0-TxRx-38
    391271 ± 24%     -30.6%     271459 ± 28%     +14.7%     448877 ± 19%  interrupts.CPU3.CAL:Function_call_interrupts
     39.33 ± 69%     -44.1%      22.00 ± 87%     +46.6%      57.67 ± 57%  interrupts.CPU3.IWI:IRQ_work_interrupts
    405991            -4.7%     387035 ±  3%      -1.3%     400903        interrupts.CPU3.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU3.MCP:Machine_check_polls
     14440 ± 43%     -26.3%      10638 ± 34%     +22.0%      17620 ± 40%  interrupts.CPU3.NMI:Non-maskable_interrupts
     14440 ± 43%     -26.3%      10638 ± 34%     +22.0%      17620 ± 40%  interrupts.CPU3.PMI:Performance_monitoring_interrupts
    509.67 ± 32%      +0.6%     512.67 ±  7%     -20.9%     403.00 ± 15%  interrupts.CPU3.RES:Rescheduling_interrupts
    473147 ± 23%     -27.4%     343271 ± 28%     +16.7%     552061 ± 19%  interrupts.CPU3.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU30.311:PCI-MSI.67182592-edge.ioat-msix
      1.67 ±141%    +120.0%       3.67 ±141%   +1460.0%      26.00 ±138%  interrupts.CPU30.66:PCI-MSI.31981599-edge.i40e-eth0-TxRx-30
    505014 ±  8%     -36.2%     322110 ± 18%      +2.1%     515840 ±  8%  interrupts.CPU30.CAL:Function_call_interrupts
     39.67 ± 70%     -21.8%      31.00 ± 76%     +47.9%      58.67 ± 31%  interrupts.CPU30.IWI:IRQ_work_interrupts
    405943            -6.1%     381239 ±  5%      -1.3%     400574        interrupts.CPU30.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU30.MCP:Machine_check_polls
     14481 ± 45%     -15.5%      12231 ± 49%     +23.4%      17864 ± 23%  interrupts.CPU30.NMI:Non-maskable_interrupts
     14481 ± 45%     -15.5%      12231 ± 49%     +23.4%      17864 ± 23%  interrupts.CPU30.PMI:Performance_monitoring_interrupts
    454.67 ± 20%     -18.7%     369.67 ± 32%      -8.9%     414.00 ± 12%  interrupts.CPU30.RES:Rescheduling_interrupts
    596818 ±  8%     -32.1%     405465 ± 18%      +5.2%     627937 ±  9%  interrupts.CPU30.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU31.312:PCI-MSI.67184640-edge.ioat-msix
     15.67 ±132%    -100.0%       0.00           -80.9%       3.00 ± 81%  interrupts.CPU31.67:PCI-MSI.31981600-edge.i40e-eth0-TxRx-31
    691541 ± 14%     -56.4%     301829 ± 20%     -23.0%     532315 ± 40%  interrupts.CPU31.CAL:Function_call_interrupts
     23.00 ± 69%    +147.8%      57.00 ±  6%    +202.9%      69.67 ± 23%  interrupts.CPU31.IWI:IRQ_work_interrupts
    405963            -5.6%     383080 ±  5%      -1.7%     399138        interrupts.CPU31.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU31.MCP:Machine_check_polls
     10189 ± 38%     +92.5%      19610 ± 11%     +99.0%      20278 ± 17%  interrupts.CPU31.NMI:Non-maskable_interrupts
     10189 ± 38%     +92.5%      19610 ± 11%     +99.0%      20278 ± 17%  interrupts.CPU31.PMI:Performance_monitoring_interrupts
    531.33 ±  8%     -22.1%     414.00 ± 36%     -24.6%     400.67 ± 29%  interrupts.CPU31.RES:Rescheduling_interrupts
    819425 ± 13%     -53.7%     379582 ± 20%     -20.7%     650057 ± 40%  interrupts.CPU31.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU32.313:PCI-MSI.67186688-edge.ioat-msix
      2.33 ±141%    -100.0%       0.00           +28.6%       3.00 ± 98%  interrupts.CPU32.68:PCI-MSI.31981601-edge.i40e-eth0-TxRx-32
    655825 ± 10%     -66.1%     222139 ± 27%     -38.3%     404610 ± 26%  interrupts.CPU32.CAL:Function_call_interrupts
     47.33 ± 17%     -23.2%      36.33 ± 66%     -42.3%      27.33 ±123%  interrupts.CPU32.IWI:IRQ_work_interrupts
    406701            -4.7%     387456 ±  4%      -1.6%     400349        interrupts.CPU32.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU32.MCP:Machine_check_polls
     16035 ± 10%      -4.4%      15328 ± 31%     -26.9%      11720 ± 67%  interrupts.CPU32.NMI:Non-maskable_interrupts
     16035 ± 10%      -4.4%      15328 ± 31%     -26.9%      11720 ± 67%  interrupts.CPU32.PMI:Performance_monitoring_interrupts
    528.67 ± 20%     -43.4%     299.33 ± 30%     -43.4%     299.00 ± 26%  interrupts.CPU32.RES:Rescheduling_interrupts
    777089 ± 10%     -64.1%     278648 ± 27%     -36.9%     490622 ± 25%  interrupts.CPU32.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU33.314:PCI-MSI.67188736-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU33.315:PCI-MSI.67188736-edge.ioat-msix
     16.00 ±141%   +4533.3%     741.33 ±141%      -2.1%      15.67 ±119%  interrupts.CPU33.69:PCI-MSI.31981602-edge.i40e-eth0-TxRx-33
    613666 ±  6%     -37.0%     386460 ± 14%     -29.5%     432490 ±  8%  interrupts.CPU33.CAL:Function_call_interrupts
     33.00 ± 86%     +58.6%      52.33 ± 38%     +49.5%      49.33 ± 19%  interrupts.CPU33.IWI:IRQ_work_interrupts
    405886            -5.3%     384373 ±  3%      -1.2%     401023        interrupts.CPU33.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU33.MCP:Machine_check_polls
     13418 ± 48%     +22.4%      16430 ± 26%     +19.2%      15993 ± 14%  interrupts.CPU33.NMI:Non-maskable_interrupts
     13418 ± 48%     +22.4%      16430 ± 26%     +19.2%      15993 ± 14%  interrupts.CPU33.PMI:Performance_monitoring_interrupts
    466.00 ± 17%     -18.9%     378.00 ±  5%     -20.1%     372.33 ± 21%  interrupts.CPU33.RES:Rescheduling_interrupts
    726114 ±  6%     -32.7%     488738 ± 15%     -27.6%     525486 ±  9%  interrupts.CPU33.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU34.314:PCI-MSI.67188736-edge.ioat-msix
      0.33 ±141%    -100.0%       0.00          -100.0%       0.00        interrupts.CPU34.70:PCI-MSI.31981603-edge.i40e-eth0-TxRx-34
    595589 ± 14%     -47.9%     310122 ± 28%     -36.3%     379289 ± 36%  interrupts.CPU34.CAL:Function_call_interrupts
     40.33 ± 81%     +12.4%      45.33 ± 64%     -13.2%      35.00 ± 60%  interrupts.CPU34.IWI:IRQ_work_interrupts
    406087            -6.5%     379508 ±  6%      -1.3%     400803        interrupts.CPU34.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU34.MCP:Machine_check_polls
     14479 ± 53%     +17.5%      17014 ± 41%     -10.3%      12991 ± 34%  interrupts.CPU34.NMI:Non-maskable_interrupts
     14479 ± 53%     +17.5%      17014 ± 41%     -10.3%      12991 ± 34%  interrupts.CPU34.PMI:Performance_monitoring_interrupts
    455.00 ± 12%     -29.4%     321.33 ± 43%     -40.8%     269.33 ± 55%  interrupts.CPU34.RES:Rescheduling_interrupts
    703599 ± 14%     -44.3%     391636 ± 29%     -34.3%     462123 ± 36%  interrupts.CPU34.TLB:TLB_shootdowns
    346.33 ±141%     -99.5%       1.67 ±141%     -99.3%       2.33 ± 88%  interrupts.CPU35.71:PCI-MSI.31981604-edge.i40e-eth0-TxRx-35
    620006 ± 33%     -40.5%     368973 ± 17%     -25.7%     460416 ±  2%  interrupts.CPU35.CAL:Function_call_interrupts
     41.33 ± 83%     -17.7%      34.00 ± 82%     +10.5%      45.67 ± 57%  interrupts.CPU35.IWI:IRQ_work_interrupts
    405870            -5.0%     385556 ±  3%      -1.2%     400905        interrupts.CPU35.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU35.MCP:Machine_check_polls
     16220 ± 50%     -16.7%      13504 ± 46%      -4.8%      15438 ± 38%  interrupts.CPU35.NMI:Non-maskable_interrupts
     16220 ± 50%     -16.7%      13504 ± 46%      -4.8%      15438 ± 38%  interrupts.CPU35.PMI:Performance_monitoring_interrupts
    537.00 ± 13%     -31.4%     368.33 ± 22%     -37.0%     338.33 ±  4%  interrupts.CPU35.RES:Rescheduling_interrupts
    730810 ± 33%     -36.3%     465606 ± 17%     -23.1%     562201 ±  3%  interrupts.CPU35.TLB:TLB_shootdowns
      0.33 ±141%    -100.0%       0.00         +9700.0%      32.67 ±141%  interrupts.CPU36.72:PCI-MSI.31981605-edge.i40e-eth0-TxRx-36
    651736 ±  4%     -64.2%     233413 ± 17%     -32.6%     439558 ± 11%  interrupts.CPU36.CAL:Function_call_interrupts
     45.67 ± 59%     +21.2%      55.33 ± 40%     -35.8%      29.33 ±102%  interrupts.CPU36.IWI:IRQ_work_interrupts
    405865            -4.2%     388962 ±  3%      -1.3%     400699        interrupts.CPU36.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU36.MCP:Machine_check_polls
     16219 ± 37%      +6.5%      17268 ± 30%     -35.1%      10521 ± 53%  interrupts.CPU36.NMI:Non-maskable_interrupts
     16219 ± 37%      +6.5%      17268 ± 30%     -35.1%      10521 ± 53%  interrupts.CPU36.PMI:Performance_monitoring_interrupts
    522.33 ± 18%     -33.5%     347.33 ± 24%     -31.3%     359.00 ± 13%  interrupts.CPU36.RES:Rescheduling_interrupts
    770327 ±  4%     -61.6%     296137 ± 18%     -30.6%     534663 ± 10%  interrupts.CPU36.TLB:TLB_shootdowns
      0.00       +1.7e+102%       1.67 ± 74% +6.7e+101%       0.67 ±141%  interrupts.CPU37.73:PCI-MSI.31981606-edge.i40e-eth0-TxRx-37
    475052 ± 20%     -35.9%     304583 ± 22%      -8.4%     434947 ± 31%  interrupts.CPU37.CAL:Function_call_interrupts
     61.67 ± 30%     -90.3%       6.00 ± 49%     -39.5%      37.33 ± 34%  interrupts.CPU37.IWI:IRQ_work_interrupts
    405937            -4.5%     387773 ±  3%      -1.5%     400025        interrupts.CPU37.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU37.MCP:Machine_check_polls
     20070 ± 20%     -58.0%       8438 ± 28%     -34.8%      13086 ± 24%  interrupts.CPU37.NMI:Non-maskable_interrupts
     20070 ± 20%     -58.0%       8438 ± 28%     -34.8%      13086 ± 24%  interrupts.CPU37.PMI:Performance_monitoring_interrupts
    456.67 ± 23%      -9.1%     415.00 ± 17%     -20.3%     364.00 ± 34%  interrupts.CPU37.RES:Rescheduling_interrupts
    561117 ± 20%     -32.0%     381463 ± 22%      -5.9%     528084 ± 30%  interrupts.CPU37.TLB:TLB_shootdowns
      0.00          -100.0%       0.00         +2e+104%     202.67 ±141%  interrupts.CPU38.74:PCI-MSI.31981607-edge.i40e-eth0-TxRx-38
    534257 ± 24%     -16.5%     446207 ± 13%      -8.2%     490379 ± 25%  interrupts.CPU38.CAL:Function_call_interrupts
     34.00 ± 67%     +79.4%      61.00 ±  6%     -64.7%      12.00 ± 64%  interrupts.CPU38.IWI:IRQ_work_interrupts
    406052            -7.9%     374160 ±  7%      -1.2%     401199        interrupts.CPU38.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU38.MCP:Machine_check_polls
     14549 ± 37%     +33.4%      19415           -43.6%       8211 ± 26%  interrupts.CPU38.NMI:Non-maskable_interrupts
     14549 ± 37%     +33.4%      19415           -43.6%       8211 ± 26%  interrupts.CPU38.PMI:Performance_monitoring_interrupts
    454.67 ±  6%     +32.6%     602.67 ± 18%     -19.6%     365.67 ± 12%  interrupts.CPU38.RES:Rescheduling_interrupts
    632492 ± 24%     -11.3%     560746 ± 13%      -5.5%     597811 ± 25%  interrupts.CPU38.TLB:TLB_shootdowns
      5.33 ±141%   +2212.5%     123.33 ±134%    +112.5%      11.33 ±129%  interrupts.CPU39.75:PCI-MSI.31981608-edge.i40e-eth0-TxRx-39
    525210 ± 23%     -29.7%     369392 ± 14%      -0.2%     524256 ± 15%  interrupts.CPU39.CAL:Function_call_interrupts
     18.33 ±125%    +112.7%      39.00 ± 75%    +123.6%      41.00 ± 42%  interrupts.CPU39.IWI:IRQ_work_interrupts
    406025            -5.3%     384600 ±  3%      -1.2%     400964        interrupts.CPU39.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU39.MCP:Machine_check_polls
     10294 ± 46%     +39.8%      14389 ± 42%     +41.2%      14539 ± 28%  interrupts.CPU39.NMI:Non-maskable_interrupts
     10294 ± 46%     +39.8%      14389 ± 42%     +41.2%      14539 ± 28%  interrupts.CPU39.PMI:Performance_monitoring_interrupts
    403.33 ± 21%     +20.5%     486.00 ± 24%      +5.0%     423.67 ± 14%  interrupts.CPU39.RES:Rescheduling_interrupts
    619108 ± 23%     -24.7%     465907 ± 15%      +3.6%     641554 ± 15%  interrupts.CPU39.TLB:TLB_shootdowns
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU4.123:PCI-MSI.31981656-edge.i40e-eth0-TxRx-87
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU4.295:PCI-MSI.65536-edge.ioat-msix
    228.33 ±140%     -99.9%       0.33 ±141%    -100.0%       0.00        interrupts.CPU4.40:PCI-MSI.31981573-edge.i40e-eth0-TxRx-4
      0.00       +6.7e+101%       0.67 ± 70%    -100.0%       0.00        interrupts.CPU4.75:PCI-MSI.31981608-edge.i40e-eth0-TxRx-39
    412315 ± 22%     -78.2%      90040 ± 41%     -17.3%     341137 ± 14%  interrupts.CPU4.CAL:Function_call_interrupts
     25.33 ±121%     -82.9%       4.33 ± 76%     -34.2%      16.67 ± 76%  interrupts.CPU4.IWI:IRQ_work_interrupts
    406072            -1.5%     400064            -1.3%     400832        interrupts.CPU4.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU4.MCP:Machine_check_polls
     11552 ± 61%     -36.8%       7301 ±  9%     -29.0%       8200 ± 26%  interrupts.CPU4.NMI:Non-maskable_interrupts
     11552 ± 61%     -36.8%       7301 ±  9%     -29.0%       8200 ± 26%  interrupts.CPU4.PMI:Performance_monitoring_interrupts
    504.00 ± 37%     -67.0%     166.33 ± 39%     -44.0%     282.00 ± 47%  interrupts.CPU4.RES:Rescheduling_interrupts
    496838 ± 21%     -77.1%     113875 ± 41%     -15.8%     418465 ± 14%  interrupts.CPU4.TLB:TLB_shootdowns
      1.00 ±141%    -100.0%       0.00           -66.7%       0.33 ±141%  interrupts.CPU40.76:PCI-MSI.31981609-edge.i40e-eth0-TxRx-40
    637502 ± 26%     -34.4%     418301 ± 11%     -40.3%     380609 ± 14%  interrupts.CPU40.CAL:Function_call_interrupts
     56.33 ± 68%      +8.3%      61.00 ± 17%     -63.3%      20.67 ± 16%  interrupts.CPU40.IWI:IRQ_work_interrupts
    405938            -6.2%     380677 ±  5%      -1.1%     401616        interrupts.CPU40.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU40.MCP:Machine_check_polls
     17750 ± 51%      +9.1%      19358 ± 12%     -44.0%       9933 ± 16%  interrupts.CPU40.NMI:Non-maskable_interrupts
     17750 ± 51%      +9.1%      19358 ± 12%     -44.0%       9933 ± 16%  interrupts.CPU40.PMI:Performance_monitoring_interrupts
    513.00 ± 13%      -7.3%     475.33 ±  3%     -41.3%     301.00 ± 19%  interrupts.CPU40.RES:Rescheduling_interrupts
    754779 ± 25%     -30.2%     526890 ± 11%     -38.5%     464230 ± 14%  interrupts.CPU40.TLB:TLB_shootdowns
      0.00       +2.8e+103%      28.33 ±141%    -100.0%       0.00        interrupts.CPU41.77:PCI-MSI.31981610-edge.i40e-eth0-TxRx-41
    677934 ±  7%     -41.5%     396844 ± 27%     -10.5%     606626 ±  6%  interrupts.CPU41.CAL:Function_call_interrupts
     55.67 ± 42%     +12.6%      62.67 ± 12%     +15.6%      64.33 ± 47%  interrupts.CPU41.IWI:IRQ_work_interrupts
    406071            -6.0%     381844 ±  4%      -1.7%     399087        interrupts.CPU41.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU41.MCP:Machine_check_polls
     17693 ± 27%     +16.9%      20680 ±  7%      +9.0%      19294 ± 38%  interrupts.CPU41.NMI:Non-maskable_interrupts
     17693 ± 27%     +16.9%      20680 ±  7%      +9.0%      19294 ± 38%  interrupts.CPU41.PMI:Performance_monitoring_interrupts
    534.67 ± 11%      +2.0%     545.33 ± 27%     -11.4%     473.67 ± 24%  interrupts.CPU41.RES:Rescheduling_interrupts
    801438 ±  7%     -37.6%     500167 ± 27%      -7.7%     739377 ±  6%  interrupts.CPU41.TLB:TLB_shootdowns
     13.33 ±141%    -100.0%       0.00          +122.5%      29.67 ± 71%  interrupts.CPU42.78:PCI-MSI.31981611-edge.i40e-eth0-TxRx-42
    592278 ± 22%     -29.5%     417438 ± 21%     -16.6%     494172 ± 17%  interrupts.CPU42.CAL:Function_call_interrupts
     51.33 ± 53%     -40.9%      30.33 ±113%     -34.4%      33.67 ± 85%  interrupts.CPU42.IWI:IRQ_work_interrupts
    406054            -6.4%     380011 ±  6%      -1.3%     400733        interrupts.CPU42.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU42.MCP:Machine_check_polls
     18373 ± 24%     -32.1%      12476 ± 55%     -30.5%      12773 ± 52%  interrupts.CPU42.NMI:Non-maskable_interrupts
     18373 ± 24%     -32.1%      12476 ± 55%     -30.5%      12773 ± 52%  interrupts.CPU42.PMI:Performance_monitoring_interrupts
    547.67 ± 26%     -14.0%     471.00 ±  8%     -36.3%     348.67 ± 18%  interrupts.CPU42.RES:Rescheduling_interrupts
    700185 ± 22%     -24.7%     527165 ± 21%     -14.1%     601242 ± 17%  interrupts.CPU42.TLB:TLB_shootdowns
     17.67 ±141%     -90.6%       1.67 ±141%    -100.0%       0.00        interrupts.CPU43.79:PCI-MSI.31981612-edge.i40e-eth0-TxRx-43
    735529 ± 14%     -49.1%     374248 ± 14%     -23.4%     563492 ± 10%  interrupts.CPU43.CAL:Function_call_interrupts
     64.33 ± 14%     -28.0%      46.33 ± 47%     -36.8%      40.67 ± 80%  interrupts.CPU43.IWI:IRQ_work_interrupts
    405941            -5.2%     384655 ±  3%      -1.5%     399808        interrupts.CPU43.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU43.MCP:Machine_check_polls
     18679 ± 10%      -5.1%      17735 ± 19%     -27.0%      13644 ± 58%  interrupts.CPU43.NMI:Non-maskable_interrupts
     18679 ± 10%      -5.1%      17735 ± 19%     -27.0%      13644 ± 58%  interrupts.CPU43.PMI:Performance_monitoring_interrupts
    606.33 ± 21%     -31.4%     415.67 ± 11%     -32.3%     410.67 ± 12%  interrupts.CPU43.RES:Rescheduling_interrupts
    869529 ± 14%     -45.8%     471427 ± 14%     -20.9%     688141 ± 10%  interrupts.CPU43.TLB:TLB_shootdowns
      0.00       +3.3e+101%       0.33 ±141% +3.3e+101%       0.33 ±141%  interrupts.CPU44.80:PCI-MSI.31981613-edge.i40e-eth0-TxRx-44
    668953 ±  5%     -42.3%     385700 ±  9%     -25.0%     501953 ±  9%  interrupts.CPU44.CAL:Function_call_interrupts
     47.67 ± 73%     -76.9%      11.00 ± 80%     -67.8%      15.33 ± 77%  interrupts.CPU44.IWI:IRQ_work_interrupts
    406637            -6.2%     381527 ±  4%      -1.7%     399885        interrupts.CPU44.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU44.MCP:Machine_check_polls
     15491 ± 59%     -46.7%       8255 ± 18%     -40.3%       9253 ± 30%  interrupts.CPU44.NMI:Non-maskable_interrupts
     15491 ± 59%     -46.7%       8255 ± 18%     -40.3%       9253 ± 30%  interrupts.CPU44.PMI:Performance_monitoring_interrupts
    531.33 ± 22%      -1.3%     524.67 ± 18%     -38.1%     328.67 ±  6%  interrupts.CPU44.RES:Rescheduling_interrupts
    791112 ±  5%     -38.3%     488045 ±  8%     -22.4%     613748 ±  8%  interrupts.CPU44.TLB:TLB_shootdowns
    165.33 ±141%     -99.6%       0.67 ± 70%     -99.6%       0.67 ±141%  interrupts.CPU45.81:PCI-MSI.31981614-edge.i40e-eth0-TxRx-45
    578029 ± 12%     -32.2%     391983 ±  8%      -3.5%     557547 ± 16%  interrupts.CPU45.CAL:Function_call_interrupts
     41.00 ± 79%     +69.9%      69.67 ± 10%     +39.8%      57.33 ± 56%  interrupts.CPU45.IWI:IRQ_work_interrupts
    405990            -6.0%     381819 ±  4%      -1.3%     400655        interrupts.CPU45.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU45.MCP:Machine_check_polls
     14620 ± 51%     +46.0%      21340 ±  4%     +18.1%      17261 ± 34%  interrupts.CPU45.NMI:Non-maskable_interrupts
     14620 ± 51%     +46.0%      21340 ±  4%     +18.1%      17261 ± 34%  interrupts.CPU45.PMI:Performance_monitoring_interrupts
    492.67 ± 17%     +10.3%     543.33 ±  8%     -26.2%     363.67 ± 13%  interrupts.CPU45.RES:Rescheduling_interrupts
    683300 ± 12%     -27.2%     497474 ±  8%      +0.1%     683962 ± 16%  interrupts.CPU45.TLB:TLB_shootdowns
      0.00          -100.0%       0.00       +9.3e+102%       9.33 ± 72%  interrupts.CPU46.82:PCI-MSI.31981615-edge.i40e-eth0-TxRx-46
    549790 ± 11%     -20.5%     437212 ± 13%      -3.8%     529125 ± 21%  interrupts.CPU46.CAL:Function_call_interrupts
     27.33 ± 84%     +50.0%      41.00 ± 72%     +62.2%      44.33 ± 51%  interrupts.CPU46.IWI:IRQ_work_interrupts
    406344            -7.8%     374636 ±  6%      -1.5%     400205        interrupts.CPU46.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU46.MCP:Machine_check_polls
     11344 ± 38%     +31.8%      14953 ± 42%     +38.5%      15710 ± 28%  interrupts.CPU46.NMI:Non-maskable_interrupts
     11344 ± 38%     +31.8%      14953 ± 42%     +38.5%      15710 ± 28%  interrupts.CPU46.PMI:Performance_monitoring_interrupts
    435.33 ± 30%     +24.1%     540.33 ± 27%     -13.1%     378.33 ± 21%  interrupts.CPU46.RES:Rescheduling_interrupts
    650482 ± 12%     -15.1%     551948 ± 13%      -0.9%     644575 ± 20%  interrupts.CPU46.TLB:TLB_shootdowns
      0.00         +1e+102%       1.00 ± 81%   +1e+102%       1.00 ±141%  interrupts.CPU47.83:PCI-MSI.31981616-edge.i40e-eth0-TxRx-47
    672667 ±  6%     -47.2%     355385 ± 16%      -5.7%     634165 ± 11%  interrupts.CPU47.CAL:Function_call_interrupts
     50.00 ± 45%      +1.3%      50.67 ± 34%     +38.7%      69.33 ± 27%  interrupts.CPU47.IWI:IRQ_work_interrupts
    406006            -5.7%     382835 ±  5%      -1.9%     398481 ±  2%  interrupts.CPU47.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU47.MCP:Machine_check_polls
     17340 ± 23%      +1.2%      17545 ± 13%     +22.2%      21185 ± 17%  interrupts.CPU47.NMI:Non-maskable_interrupts
     17340 ± 23%      +1.2%      17545 ± 13%     +22.2%      21185 ± 17%  interrupts.CPU47.PMI:Performance_monitoring_interrupts
    534.33 ± 26%     -26.4%     393.33 ± 11%     -11.0%     475.67 ± 22%  interrupts.CPU47.RES:Rescheduling_interrupts
    795301 ±  6%     -43.7%     448110 ± 16%      -2.9%     772409 ± 10%  interrupts.CPU47.TLB:TLB_shootdowns
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        interrupts.CPU48.47:PCI-MSI.31981580-edge.i40e-eth0-TxRx-11
      9874 ±141%    -100.0%       0.33 ±141%    -100.0%       1.00 ±141%  interrupts.CPU48.84:PCI-MSI.31981617-edge.i40e-eth0-TxRx-48
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU48.95:PCI-MSI.31981628-edge.i40e-eth0-TxRx-59
    582755 ± 10%     -44.7%     322024 ± 14%     -15.0%     495329 ± 22%  interrupts.CPU48.CAL:Function_call_interrupts
     81.67 ±  3%     -58.0%      34.33 ± 69%     -19.2%      66.00 ± 20%  interrupts.CPU48.IWI:IRQ_work_interrupts
    406297            -6.8%     378574 ±  6%      -2.0%     398086 ±  2%  interrupts.CPU48.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU48.MCP:Machine_check_polls
     23897 ±  2%     -47.5%      12551 ± 43%     -18.7%      19417 ± 19%  interrupts.CPU48.NMI:Non-maskable_interrupts
     23897 ±  2%     -47.5%      12551 ± 43%     -18.7%      19417 ± 19%  interrupts.CPU48.PMI:Performance_monitoring_interrupts
    712.67 ± 19%     -25.3%     532.67 ± 25%     -33.6%     473.00 ± 54%  interrupts.CPU48.RES:Rescheduling_interrupts
    704515 ± 10%     -41.7%     410698 ± 13%     -13.5%     609709 ± 22%  interrupts.CPU48.TLB:TLB_shootdowns
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU49.48:PCI-MSI.31981581-edge.i40e-eth0-TxRx-12
      0.00         +2e+105%       2013 ±141%   +1e+102%       1.00 ±141%  interrupts.CPU49.85:PCI-MSI.31981618-edge.i40e-eth0-TxRx-49
      0.00       +6.7e+101%       0.67 ± 70%    -100.0%       0.00        interrupts.CPU49.96:PCI-MSI.31981629-edge.i40e-eth0-TxRx-60
    489273 ±  8%     -46.9%     259718 ± 41%     -21.4%     384476 ± 13%  interrupts.CPU49.CAL:Function_call_interrupts
     38.67 ± 80%     -69.0%      12.00 ±117%     -32.8%      26.00 ± 67%  interrupts.CPU49.IWI:IRQ_work_interrupts
    406142            -4.3%     388575 ±  3%      -1.3%     400982        interrupts.CPU49.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU49.MCP:Machine_check_polls
     16806 ± 31%     -56.7%       7275 ± 42%     -36.3%      10710 ± 34%  interrupts.CPU49.NMI:Non-maskable_interrupts
     16806 ± 31%     -56.7%       7275 ± 42%     -36.3%      10710 ± 34%  interrupts.CPU49.PMI:Performance_monitoring_interrupts
    548.00 ± 11%     -20.2%     437.33 ± 50%     -38.0%     340.00 ± 47%  interrupts.CPU49.RES:Rescheduling_interrupts
    590674 ±  8%     -44.8%     326075 ± 42%     -19.7%     474553 ± 13%  interrupts.CPU49.TLB:TLB_shootdowns
      0.33 ±141%    -100.0%       0.00          -100.0%       0.00        interrupts.CPU5.124:PCI-MSI.31981657-edge.i40e-eth0-TxRx-88
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU5.297:PCI-MSI.67584-edge.ioat-msix
      0.00       +1.3e+102%       1.33 ± 93%    -100.0%       0.00        interrupts.CPU5.41:PCI-MSI.31981574-edge.i40e-eth0-TxRx-5
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU5.76:PCI-MSI.31981609-edge.i40e-eth0-TxRx-40
    323696 ± 25%     -13.2%     280967 ± 18%     +11.2%     360054 ± 30%  interrupts.CPU5.CAL:Function_call_interrupts
     54.00 ± 44%     -37.0%      34.00 ± 86%     -69.1%      16.67 ± 76%  interrupts.CPU5.IWI:IRQ_work_interrupts
    406016            -5.2%     385063 ±  3%      -1.3%     400914        interrupts.CPU5.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU5.MCP:Machine_check_polls
     17180 ± 34%     -24.2%      13015 ± 52%     -50.6%       8485 ± 33%  interrupts.CPU5.NMI:Non-maskable_interrupts
     17180 ± 34%     -24.2%      13015 ± 52%     -50.6%       8485 ± 33%  interrupts.CPU5.PMI:Performance_monitoring_interrupts
    429.33 ± 18%      -3.0%     416.67 ± 45%     -13.8%     370.00 ± 59%  interrupts.CPU5.RES:Rescheduling_interrupts
    391387 ± 24%      -8.9%     356642 ± 18%     +12.9%     441739 ± 29%  interrupts.CPU5.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU50.295:PCI-MSI.65536-edge.ioat-msix
      0.33 ±141%    -100.0%       0.00          -100.0%       0.00        interrupts.CPU50.49:PCI-MSI.31981582-edge.i40e-eth0-TxRx-13
    278.33 ±133%    -100.0%       0.00           -99.5%       1.33 ± 93%  interrupts.CPU50.86:PCI-MSI.31981619-edge.i40e-eth0-TxRx-50
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        interrupts.CPU50.97:PCI-MSI.31981630-edge.i40e-eth0-TxRx-61
    456351 ±  9%     -32.7%     307112 ± 33%      -8.8%     416160 ± 16%  interrupts.CPU50.CAL:Function_call_interrupts
     54.67 ± 63%     -22.0%      42.67 ± 58%     -22.6%      42.33 ± 70%  interrupts.CPU50.IWI:IRQ_work_interrupts
    405962            -6.4%     379953 ±  5%      -1.2%     401093        interrupts.CPU50.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU50.MCP:Machine_check_polls
     18331 ± 41%      -6.8%      17083 ±  7%     -20.1%      14638 ± 40%  interrupts.CPU50.NMI:Non-maskable_interrupts
     18331 ± 41%      -6.8%      17083 ±  7%     -20.1%      14638 ± 40%  interrupts.CPU50.PMI:Performance_monitoring_interrupts
    553.33 ±  5%      -6.4%     518.00 ± 32%     -26.7%     405.67 ± 19%  interrupts.CPU50.RES:Rescheduling_interrupts
    549669 ±  9%     -29.4%     387843 ± 33%      -6.2%     515700 ± 17%  interrupts.CPU50.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU51.3:IO-APIC.3-edge
      0.33 ±141%    -100.0%       0.00          -100.0%       0.00        interrupts.CPU51.50:PCI-MSI.31981583-edge.i40e-eth0-TxRx-14
      3.00 ±141%   +1622.2%      51.67 ±138%     -88.9%       0.33 ±141%  interrupts.CPU51.87:PCI-MSI.31981620-edge.i40e-eth0-TxRx-51
      0.33 ±141%    -100.0%       0.00          -100.0%       0.00        interrupts.CPU51.98:PCI-MSI.31981631-edge.i40e-eth0-TxRx-62
    482509 ± 12%     -33.8%     319373 ± 37%     -14.6%     411947 ± 21%  interrupts.CPU51.CAL:Function_call_interrupts
     47.67 ± 54%      -8.4%      43.67 ± 68%     -58.0%      20.00 ± 88%  interrupts.CPU51.IWI:IRQ_work_interrupts
    406250            -7.1%     377396 ±  5%      -1.7%     399497        interrupts.CPU51.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU51.MCP:Machine_check_polls
     16513 ± 33%      -9.1%      15014 ± 45%     -39.6%       9976 ± 33%  interrupts.CPU51.NMI:Non-maskable_interrupts
     16513 ± 33%      -9.1%      15014 ± 45%     -39.6%       9976 ± 33%  interrupts.CPU51.PMI:Performance_monitoring_interrupts
    612.67 ± 18%     -15.8%     515.67 ± 40%     -43.5%     346.00 ± 39%  interrupts.CPU51.RES:Rescheduling_interrupts
    580841 ± 13%     -30.2%     405445 ± 37%     -12.7%     507354 ± 21%  interrupts.CPU51.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU52.297:PCI-MSI.67584-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU52.51:PCI-MSI.31981584-edge.i40e-eth0-TxRx-15
     28.33 ±141%     -97.6%       0.67 ±141%    -100.0%       0.00        interrupts.CPU52.88:PCI-MSI.31981621-edge.i40e-eth0-TxRx-52
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU52.99:PCI-MSI.31981632-edge.i40e-eth0-TxRx-63
    474637 ± 13%      +5.4%     500351 ± 11%      +4.2%     494380 ± 13%  interrupts.CPU52.CAL:Function_call_interrupts
     60.33 ± 48%      +5.5%      63.67 ±  9%      +1.1%      61.00 ± 23%  interrupts.CPU52.IWI:IRQ_work_interrupts
    406062            -9.5%     367361 ±  8%      -1.4%     400536        interrupts.CPU52.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU52.MCP:Machine_check_polls
     19272 ± 32%      +2.0%      19665 ±  4%      -4.4%      18430 ± 20%  interrupts.CPU52.NMI:Non-maskable_interrupts
     19272 ± 32%      +2.0%      19665 ±  4%      -4.4%      18430 ± 20%  interrupts.CPU52.PMI:Performance_monitoring_interrupts
    599.33 ± 14%     +26.5%     758.33 ± 18%     -28.0%     431.67 ±  7%  interrupts.CPU52.RES:Rescheduling_interrupts
    572909 ± 13%     +10.8%     634553 ± 11%      +6.7%     611048 ± 13%  interrupts.CPU52.TLB:TLB_shootdowns
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU53.100:PCI-MSI.31981633-edge.i40e-eth0-TxRx-64
      0.33 ±141%    -100.0%       0.00            +0.0%       0.33 ±141%  interrupts.CPU53.52:PCI-MSI.31981585-edge.i40e-eth0-TxRx-16
     25.33 ±141%    -100.0%       0.00           +30.3%      33.00 ±141%  interrupts.CPU53.89:PCI-MSI.31981622-edge.i40e-eth0-TxRx-53
    568183 ±  4%     -45.7%     308623 ± 17%     -12.4%     497869 ± 26%  interrupts.CPU53.CAL:Function_call_interrupts
     33.33 ± 66%     -22.0%      26.00 ± 67%     +60.0%      53.33 ± 20%  interrupts.CPU53.IWI:IRQ_work_interrupts
    405986            -6.2%     380919 ±  5%      -1.2%     400953        interrupts.CPU53.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU53.MCP:Machine_check_polls
     13336 ± 22%     -19.8%      10693 ± 32%     +27.6%      17014 ± 16%  interrupts.CPU53.NMI:Non-maskable_interrupts
     13336 ± 22%     -19.8%      10693 ± 32%     +27.6%      17014 ± 16%  interrupts.CPU53.PMI:Performance_monitoring_interrupts
    680.00 ± 18%     -24.2%     515.33 ± 10%     -39.0%     415.00 ± 13%  interrupts.CPU53.RES:Rescheduling_interrupts
    683513 ±  4%     -42.9%     390555 ± 16%     -10.3%     613284 ± 26%  interrupts.CPU53.TLB:TLB_shootdowns
      0.33 ±141%      +0.0%       0.33 ±141%      +0.0%       0.33 ±141%  interrupts.CPU54.101:PCI-MSI.31981634-edge.i40e-eth0-TxRx-65
      0.67 ± 70%     -50.0%       0.33 ±141%      +0.0%       0.67 ± 70%  interrupts.CPU54.53:PCI-MSI.31981586-edge.i40e-eth0-TxRx-17
     38.00 ± 49%     -21.1%      30.00 ±127%     -64.0%      13.67 ±141%  interrupts.CPU54.90:PCI-MSI.31981623-edge.i40e-eth0-TxRx-54
    476446 ±  5%     -46.9%     253144 ± 42%      +0.3%     477820 ± 26%  interrupts.CPU54.CAL:Function_call_interrupts
     50.00 ± 68%     -20.7%      39.67 ± 73%     -19.3%      40.33 ± 87%  interrupts.CPU54.IWI:IRQ_work_interrupts
    406006            -5.9%     382210 ±  6%      -1.1%     401486        interrupts.CPU54.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU54.MCP:Machine_check_polls
     15852 ± 42%     -11.4%      14045 ± 42%     -10.0%      14260 ± 49%  interrupts.CPU54.NMI:Non-maskable_interrupts
     15852 ± 42%     -11.4%      14045 ± 42%     -10.0%      14260 ± 49%  interrupts.CPU54.PMI:Performance_monitoring_interrupts
    554.33 ±  5%     -24.1%     421.00 ± 22%     -28.7%     395.00 ±  5%  interrupts.CPU54.RES:Rescheduling_interrupts
    573528 ±  6%     -44.1%     320367 ± 41%      +2.5%     587694 ± 26%  interrupts.CPU54.TLB:TLB_shootdowns
      0.33 ±141%    -100.0%       0.00            +0.0%       0.33 ±141%  interrupts.CPU55.102:PCI-MSI.31981635-edge.i40e-eth0-TxRx-66
      0.67 ± 70%    -100.0%       0.00          -100.0%       0.00        interrupts.CPU55.54:PCI-MSI.31981587-edge.i40e-eth0-TxRx-18
      0.00       +1.5e+103%      14.67 ±127% +3.3e+101%       0.33 ±141%  interrupts.CPU55.91:PCI-MSI.31981624-edge.i40e-eth0-TxRx-55
    499688 ± 11%     -35.0%     324925 ± 24%     -23.9%     380328 ± 29%  interrupts.CPU55.CAL:Function_call_interrupts
     38.33 ± 76%     +13.0%      43.33 ± 67%     -44.3%      21.33 ±121%  interrupts.CPU55.IWI:IRQ_work_interrupts
    406037            -5.9%     382156 ±  4%      -1.4%     400555        interrupts.CPU55.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU55.MCP:Machine_check_polls
     13726 ± 52%      +9.3%      15004 ± 39%     -20.0%      10977 ± 49%  interrupts.CPU55.NMI:Non-maskable_interrupts
     13726 ± 52%      +9.3%      15004 ± 39%     -20.0%      10977 ± 49%  interrupts.CPU55.PMI:Performance_monitoring_interrupts
    574.33 ± 24%     -10.3%     515.33 ± 50%     -42.0%     333.00 ± 37%  interrupts.CPU55.RES:Rescheduling_interrupts
    601639 ± 12%     -31.7%     411190 ± 24%     -22.0%     468986 ± 29%  interrupts.CPU55.TLB:TLB_shootdowns
      0.33 ±141%      +0.0%       0.33 ±141%      +0.0%       0.33 ±141%  interrupts.CPU56.103:PCI-MSI.31981636-edge.i40e-eth0-TxRx-67
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU56.297:PCI-MSI.67584-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU56.3:IO-APIC.3-edge
      0.67 ± 70%    -100.0%       0.00            +0.0%       0.67 ± 70%  interrupts.CPU56.55:PCI-MSI.31981588-edge.i40e-eth0-TxRx-19
      0.33 ±141%    +500.0%       2.00 ±141%      +0.0%       0.33 ±141%  interrupts.CPU56.92:PCI-MSI.31981625-edge.i40e-eth0-TxRx-56
    410250 ±  3%     -38.5%     252320 ± 26%      +5.3%     432085 ± 10%  interrupts.CPU56.CAL:Function_call_interrupts
      2.00         +1916.7%      40.33 ± 51%   +1016.7%      22.33 ± 67%  interrupts.CPU56.IWI:IRQ_work_interrupts
    406271            -6.0%     382066 ±  5%      -1.2%     401193        interrupts.CPU56.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU56.MCP:Machine_check_polls
      5927 ± 16%    +170.4%      16028 ± 24%     +67.4%       9920 ± 34%  interrupts.CPU56.NMI:Non-maskable_interrupts
      5927 ± 16%    +170.4%      16028 ± 24%     +67.4%       9920 ± 34%  interrupts.CPU56.PMI:Performance_monitoring_interrupts
    572.00 ± 15%     -34.8%     373.00 ± 26%     -38.9%     349.33 ± 30%  interrupts.CPU56.RES:Rescheduling_interrupts
    492860 ±  2%     -34.8%     321473 ± 25%      +8.0%     532509 ± 10%  interrupts.CPU56.TLB:TLB_shootdowns
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU57.104:PCI-MSI.31981637-edge.i40e-eth0-TxRx-68
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU57.3:IO-APIC.3-edge
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU57.56:PCI-MSI.31981589-edge.i40e-eth0-TxRx-20
      1.00 ± 81%    +600.0%       7.00 ±141%     +66.7%       1.67 ± 74%  interrupts.CPU57.93:PCI-MSI.31981626-edge.i40e-eth0-TxRx-57
    479324 ± 27%     -25.8%     355751 ± 15%     -36.9%     302613 ± 50%  interrupts.CPU57.CAL:Function_call_interrupts
      9.33 ±111%    +189.3%      27.00 ±103%     -82.1%       1.67 ± 28%  interrupts.CPU57.IWI:IRQ_work_interrupts
    406313            -7.1%     377436 ±  6%      -1.4%     400705        interrupts.CPU57.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU57.MCP:Machine_check_polls
      7814 ± 30%     +51.1%      11805 ± 52%     -24.3%       5915        interrupts.CPU57.NMI:Non-maskable_interrupts
      7814 ± 30%     +51.1%      11805 ± 52%     -24.3%       5915        interrupts.CPU57.PMI:Performance_monitoring_interrupts
    550.67 ± 23%     -38.0%     341.33 ± 15%     -43.1%     313.33 ± 60%  interrupts.CPU57.RES:Rescheduling_interrupts
    580825 ± 27%     -22.2%     451600 ± 15%     -35.9%     372037 ± 50%  interrupts.CPU57.TLB:TLB_shootdowns
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        interrupts.CPU58.105:PCI-MSI.31981638-edge.i40e-eth0-TxRx-69
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU58.3:IO-APIC.3-edge
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        interrupts.CPU58.57:PCI-MSI.31981590-edge.i40e-eth0-TxRx-21
     11.33 ±135%     -67.6%       3.67 ±141%    -100.0%       0.00        interrupts.CPU58.94:PCI-MSI.31981627-edge.i40e-eth0-TxRx-58
    506539 ± 18%     -28.3%     363256 ± 22%      -3.3%     490005 ± 22%  interrupts.CPU58.CAL:Function_call_interrupts
     54.00 ± 55%      +3.1%      55.67 ± 35%     -14.8%      46.00 ± 69%  interrupts.CPU58.IWI:IRQ_work_interrupts
    405991            -7.6%     374956 ±  7%      -1.3%     400845        interrupts.CPU58.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU58.MCP:Machine_check_polls
     17646 ± 32%      -2.5%      17197 ± 31%     -19.5%      14210 ± 47%  interrupts.CPU58.NMI:Non-maskable_interrupts
     17646 ± 32%      -2.5%      17197 ± 31%     -19.5%      14210 ± 47%  interrupts.CPU58.PMI:Performance_monitoring_interrupts
    641.33 ± 14%     -23.0%     493.67 ± 20%     -43.2%     364.33 ± 21%  interrupts.CPU58.RES:Rescheduling_interrupts
    610188 ± 18%     -24.6%     460228 ± 22%      -0.8%     605292 ± 23%  interrupts.CPU58.TLB:TLB_shootdowns
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU59.106:PCI-MSI.31981639-edge.i40e-eth0-TxRx-70
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU59.297:PCI-MSI.67584-edge.ioat-msix
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU59.58:PCI-MSI.31981591-edge.i40e-eth0-TxRx-22
    202.33 ±141%    -100.0%       0.00           -92.9%      14.33 ±126%  interrupts.CPU59.95:PCI-MSI.31981628-edge.i40e-eth0-TxRx-59
    466674 ±  9%     -21.7%     365350 ±  2%     -18.9%     378506 ± 38%  interrupts.CPU59.CAL:Function_call_interrupts
     37.33 ±103%     +55.4%      58.00 ± 44%     -43.8%      21.00 ± 80%  interrupts.CPU59.IWI:IRQ_work_interrupts
    406023            -6.6%     379413 ±  5%      -1.1%     401592        interrupts.CPU59.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU59.MCP:Machine_check_polls
     16194 ± 38%      +7.6%      17422 ± 34%     -44.0%       9074 ± 32%  interrupts.CPU59.NMI:Non-maskable_interrupts
     16194 ± 38%      +7.6%      17422 ± 34%     -44.0%       9074 ± 32%  interrupts.CPU59.PMI:Performance_monitoring_interrupts
    456.33 ± 26%     +24.0%     565.67 ± 27%     -21.8%     357.00 ± 57%  interrupts.CPU59.RES:Rescheduling_interrupts
    564068 ±  9%     -17.9%     462948 ±  2%     -17.3%     466320 ± 38%  interrupts.CPU59.TLB:TLB_shootdowns
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU6.125:PCI-MSI.31981658-edge.i40e-eth0-TxRx-89
     13.67 ±141%     -97.6%       0.33 ±141%     -97.6%       0.33 ±141%  interrupts.CPU6.42:PCI-MSI.31981575-edge.i40e-eth0-TxRx-6
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU6.77:PCI-MSI.31981610-edge.i40e-eth0-TxRx-41
    399374 ± 18%     -17.5%     329438 ± 32%      -4.6%     381146 ± 30%  interrupts.CPU6.CAL:Function_call_interrupts
     28.33 ±124%     -12.9%      24.67 ±129%     +36.5%      38.67 ± 77%  interrupts.CPU6.IWI:IRQ_work_interrupts
    406107            -5.2%     384846 ±  3%      -1.6%     399513        interrupts.CPU6.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU6.MCP:Machine_check_polls
     11873 ± 71%      -8.6%      10847 ± 70%     +10.2%      13088 ± 42%  interrupts.CPU6.NMI:Non-maskable_interrupts
     11873 ± 71%      -8.6%      10847 ± 70%     +10.2%      13088 ± 42%  interrupts.CPU6.PMI:Performance_monitoring_interrupts
    556.67 ± 22%     -20.8%     441.00 ± 37%     -31.3%     382.67 ± 58%  interrupts.CPU6.RES:Rescheduling_interrupts
    481684 ± 17%     -13.4%     417322 ± 32%      -2.5%     469682 ± 30%  interrupts.CPU6.TLB:TLB_shootdowns
      0.00          -100.0%       0.00       +6.7e+101%       0.67 ± 70%  interrupts.CPU60.107:PCI-MSI.31981640-edge.i40e-eth0-TxRx-71
      0.33 ±141%    -100.0%       0.00          -100.0%       0.00        interrupts.CPU60.59:PCI-MSI.31981592-edge.i40e-eth0-TxRx-23
     25.67 ±138%     -98.7%       0.33 ±141%    -100.0%       0.00        interrupts.CPU60.96:PCI-MSI.31981629-edge.i40e-eth0-TxRx-60
    509559 ±  9%     -59.4%     206835 ± 49%     -17.1%     422217 ± 23%  interrupts.CPU60.CAL:Function_call_interrupts
     56.67 ± 21%     -14.1%      48.67 ± 50%     -78.2%      12.33 ±118%  interrupts.CPU60.IWI:IRQ_work_interrupts
    405899            -5.6%     382996 ±  6%      -1.6%     399420        interrupts.CPU60.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU60.MCP:Machine_check_polls
     18240 ± 16%     -12.7%      15923 ± 29%     -59.5%       7395 ± 38%  interrupts.CPU60.NMI:Non-maskable_interrupts
     18240 ± 16%     -12.7%      15923 ± 29%     -59.5%       7395 ± 38%  interrupts.CPU60.PMI:Performance_monitoring_interrupts
    567.67 ± 29%     -42.6%     325.67 ± 48%     -26.2%     419.00 ± 41%  interrupts.CPU60.RES:Rescheduling_interrupts
    614693 ±  9%     -57.3%     262405 ± 49%     -15.7%     518321 ± 23%  interrupts.CPU60.TLB:TLB_shootdowns
      0.33 ±141%      +0.0%       0.33 ±141%    -100.0%       0.00        interrupts.CPU61.108:PCI-MSI.31981641-edge.i40e-eth0-TxRx-72
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU61.3:IO-APIC.3-edge
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU61.60:PCI-MSI.31981593-edge.i40e-eth0-TxRx-24
      1.33 ±141%     +50.0%       2.00 ±141%    -100.0%       0.00        interrupts.CPU61.97:PCI-MSI.31981630-edge.i40e-eth0-TxRx-61
    396610 ± 34%     -37.3%     248695 ± 53%      -7.1%     368315 ± 21%  interrupts.CPU61.CAL:Function_call_interrupts
     43.67 ± 18%      -4.6%      41.67 ± 68%      +8.4%      47.33 ± 59%  interrupts.CPU61.IWI:IRQ_work_interrupts
    405939            -3.7%     390781 ±  2%      -1.3%     400764        interrupts.CPU61.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU61.MCP:Machine_check_polls
     15927            -2.5%      15526 ± 35%      -5.8%      15005 ± 38%  interrupts.CPU61.NMI:Non-maskable_interrupts
     15927            -2.5%      15526 ± 35%      -5.8%      15005 ± 38%  interrupts.CPU61.PMI:Performance_monitoring_interrupts
    418.33 ±  8%     +10.8%     463.33 ± 42%      -9.8%     377.33 ± 44%  interrupts.CPU61.RES:Rescheduling_interrupts
    480579 ± 34%     -34.8%     313486 ± 53%      -5.3%     455212 ± 21%  interrupts.CPU61.TLB:TLB_shootdowns
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        interrupts.CPU62.109:PCI-MSI.31981642-edge.i40e-eth0-TxRx-73
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU62.297:PCI-MSI.67584-edge.ioat-msix
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU62.61:PCI-MSI.31981594-edge.i40e-eth0-TxRx-25
      1.67 ±101%    -100.0%       0.00        +34940.0%     584.00 ±141%  interrupts.CPU62.98:PCI-MSI.31981631-edge.i40e-eth0-TxRx-62
    474207 ± 36%     -40.4%     282496 ± 44%     -31.5%     324736 ± 23%  interrupts.CPU62.CAL:Function_call_interrupts
     58.00 ± 41%     -35.1%      37.67 ± 74%     -71.8%      16.33 ± 78%  interrupts.CPU62.IWI:IRQ_work_interrupts
    406078            -4.9%     386332 ±  3%      -1.1%     401522        interrupts.CPU62.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU62.MCP:Machine_check_polls
     18320 ± 24%     -19.3%      14778 ± 37%     -34.3%      12044 ± 36%  interrupts.CPU62.NMI:Non-maskable_interrupts
     18320 ± 24%     -19.3%      14778 ± 37%     -34.3%      12044 ± 36%  interrupts.CPU62.PMI:Performance_monitoring_interrupts
    601.00 ± 22%     -25.6%     447.00 ± 52%     -41.1%     354.00 ± 19%  interrupts.CPU62.RES:Rescheduling_interrupts
    571613 ± 36%     -37.8%     355421 ± 44%     -29.9%     400541 ± 23%  interrupts.CPU62.TLB:TLB_shootdowns
      0.33 ±141%      +0.0%       0.33 ±141%      +0.0%       0.33 ±141%  interrupts.CPU63.110:PCI-MSI.31981643-edge.i40e-eth0-TxRx-74
      0.67 ± 70%    -100.0%       0.00          -100.0%       0.00        interrupts.CPU63.62:PCI-MSI.31981595-edge.i40e-eth0-TxRx-26
      1.67 ± 74%    -100.0%       0.00           -20.0%       1.33 ±141%  interrupts.CPU63.99:PCI-MSI.31981632-edge.i40e-eth0-TxRx-63
    471835 ±  9%     -47.8%     246444 ± 22%      -4.9%     448749 ± 21%  interrupts.CPU63.CAL:Function_call_interrupts
     39.00 ± 68%     +22.2%      47.67 ± 34%     -11.1%      34.67 ± 88%  interrupts.CPU63.IWI:IRQ_work_interrupts
    406023            -5.3%     384514 ±  4%      -1.7%     399143        interrupts.CPU63.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU63.MCP:Machine_check_polls
     14018 ± 47%      +8.2%      15165 ± 23%     -11.5%      12401 ± 44%  interrupts.CPU63.NMI:Non-maskable_interrupts
     14018 ± 47%      +8.2%      15165 ± 23%     -11.5%      12401 ± 44%  interrupts.CPU63.PMI:Performance_monitoring_interrupts
    554.33 ±  7%     -46.3%     297.67 ± 18%     -23.4%     424.67 ± 36%  interrupts.CPU63.RES:Rescheduling_interrupts
    569765 ± 10%     -45.4%     311100 ± 22%      -3.0%     552440 ± 21%  interrupts.CPU63.TLB:TLB_shootdowns
      1.33 ± 93%    +650.0%      10.00 ±141%     -75.0%       0.33 ±141%  interrupts.CPU64.100:PCI-MSI.31981633-edge.i40e-eth0-TxRx-64
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU64.111:PCI-MSI.31981644-edge.i40e-eth0-TxRx-75
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU64.4:IO-APIC.4-edge.ttyS0
      0.00       +3.3e+101%       0.33 ±141% +3.3e+101%       0.33 ±141%  interrupts.CPU64.63:PCI-MSI.31981596-edge.i40e-eth0-TxRx-27
    443915 ± 15%     -20.8%     351444 ± 20%     +19.7%     531311 ± 20%  interrupts.CPU64.CAL:Function_call_interrupts
     46.67 ± 64%      -5.7%      44.00 ± 40%     -61.4%      18.00 ± 62%  interrupts.CPU64.IWI:IRQ_work_interrupts
    406093            -6.9%     378077 ±  5%      -1.8%     398601 ±  2%  interrupts.CPU64.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU64.MCP:Machine_check_polls
     15752 ± 44%      -5.9%      14823 ± 21%     -39.8%       9478 ± 31%  interrupts.CPU64.NMI:Non-maskable_interrupts
     15752 ± 44%      -5.9%      14823 ± 21%     -39.8%       9478 ± 31%  interrupts.CPU64.PMI:Performance_monitoring_interrupts
    439.33 ± 28%      +8.0%     474.33 ± 21%      +4.6%     459.33 ± 42%  interrupts.CPU64.RES:Rescheduling_interrupts
    536036 ± 14%     -17.1%     444279 ± 21%     +22.7%     657767 ± 20%  interrupts.CPU64.TLB:TLB_shootdowns
      4.33 ± 96%    +207.7%      13.33 ±125%    +192.3%      12.67 ±135%  interrupts.CPU65.101:PCI-MSI.31981634-edge.i40e-eth0-TxRx-65
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        interrupts.CPU65.112:PCI-MSI.31981645-edge.i40e-eth0-TxRx-76
      0.00          -100.0%       0.00       +6.7e+101%       0.67 ± 70%  interrupts.CPU65.64:PCI-MSI.31981597-edge.i40e-eth0-TxRx-28
    533032 ± 18%     -46.1%     287314 ± 37%     -25.6%     396619 ± 49%  interrupts.CPU65.CAL:Function_call_interrupts
     78.67 ±  7%     -34.3%      51.67 ± 37%     -54.7%      35.67 ± 94%  interrupts.CPU65.IWI:IRQ_work_interrupts
    405870            -6.3%     380458 ±  4%      -1.4%     399985        interrupts.CPU65.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU65.MCP:Machine_check_polls
     22141 ± 12%     -23.5%      16942 ± 21%     -44.1%      12386 ± 49%  interrupts.CPU65.NMI:Non-maskable_interrupts
     22141 ± 12%     -23.5%      16942 ± 21%     -44.1%      12386 ± 49%  interrupts.CPU65.PMI:Performance_monitoring_interrupts
    635.33 ± 11%     -16.7%     529.00 ± 41%     -40.1%     380.33 ± 54%  interrupts.CPU65.RES:Rescheduling_interrupts
    643026 ± 17%     -43.8%     361112 ± 37%     -24.0%     488687 ± 50%  interrupts.CPU65.TLB:TLB_shootdowns
     58.00 ±129%     -89.7%       6.00 ±141%     -84.5%       9.00 ± 74%  interrupts.CPU66.102:PCI-MSI.31981635-edge.i40e-eth0-TxRx-66
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU66.113:PCI-MSI.31981646-edge.i40e-eth0-TxRx-77
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU66.65:PCI-MSI.31981598-edge.i40e-eth0-TxRx-29
    492020 ±  4%     -46.6%     262891 ±  6%     -12.9%     428659 ± 27%  interrupts.CPU66.CAL:Function_call_interrupts
     67.33 ± 33%     -46.5%      36.00 ± 65%     -86.6%       9.00 ±109%  interrupts.CPU66.IWI:IRQ_work_interrupts
    405977            -4.7%     387080 ±  3%      -1.6%     399352        interrupts.CPU66.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU66.MCP:Machine_check_polls
     19988 ± 22%     -33.2%      13360 ± 33%     -63.8%       7229 ± 41%  interrupts.CPU66.NMI:Non-maskable_interrupts
     19988 ± 22%     -33.2%      13360 ± 33%     -63.8%       7229 ± 41%  interrupts.CPU66.PMI:Performance_monitoring_interrupts
    560.33 ± 22%     -31.5%     384.00 ± 37%     -30.5%     389.33 ± 47%  interrupts.CPU66.RES:Rescheduling_interrupts
    594329 ±  4%     -44.2%     331741 ±  7%     -11.2%     527935 ± 26%  interrupts.CPU66.TLB:TLB_shootdowns
    530.00 ±141%     -99.9%       0.33 ±141%     -94.5%      29.00 ±122%  interrupts.CPU67.103:PCI-MSI.31981636-edge.i40e-eth0-TxRx-67
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        interrupts.CPU67.114:PCI-MSI.31981647-edge.i40e-eth0-TxRx-78
      0.33 ±141%      +0.0%       0.33 ±141%      +0.0%       0.33 ±141%  interrupts.CPU67.66:PCI-MSI.31981599-edge.i40e-eth0-TxRx-30
    333633 ± 12%     -45.2%     182938 ± 43%      +7.7%     359197 ± 19%  interrupts.CPU67.CAL:Function_call_interrupts
     22.00 ±125%     -34.8%      14.33 ±111%     +92.4%      42.33 ± 76%  interrupts.CPU67.IWI:IRQ_work_interrupts
    406352            -4.0%     389991 ±  2%      -1.4%     400652        interrupts.CPU67.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU67.MCP:Machine_check_polls
     10126 ± 62%     -13.3%       8777 ± 49%     +40.1%      14188 ± 54%  interrupts.CPU67.NMI:Non-maskable_interrupts
     10126 ± 62%     -13.3%       8777 ± 49%     +40.1%      14188 ± 54%  interrupts.CPU67.PMI:Performance_monitoring_interrupts
    487.00 ±  2%     -23.6%     372.00 ± 35%     -33.6%     323.33 ± 57%  interrupts.CPU67.RES:Rescheduling_interrupts
    403225 ± 13%     -43.0%     230032 ± 42%     +10.3%     444640 ± 18%  interrupts.CPU67.TLB:TLB_shootdowns
      0.33 ±141%  +27900.0%      93.33 ±141%   +1000.0%       3.67 ±141%  interrupts.CPU68.104:PCI-MSI.31981637-edge.i40e-eth0-TxRx-68
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        interrupts.CPU68.115:PCI-MSI.31981648-edge.i40e-eth0-TxRx-79
      0.33 ±141%    -100.0%       0.00          -100.0%       0.00        interrupts.CPU68.67:PCI-MSI.31981600-edge.i40e-eth0-TxRx-31
    410521 ± 13%     -40.3%     244977 ± 13%      -2.7%     399283 ± 21%  interrupts.CPU68.CAL:Function_call_interrupts
     39.67 ± 51%     -49.6%      20.00 ±116%     -88.2%       4.67 ± 66%  interrupts.CPU68.IWI:IRQ_work_interrupts
    406071            -4.1%     389539 ±  2%      -1.5%     400176        interrupts.CPU68.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU68.MCP:Machine_check_polls
     13584 ± 33%     -29.8%       9541 ± 53%     -32.4%       9185 ± 49%  interrupts.CPU68.NMI:Non-maskable_interrupts
     13584 ± 33%     -29.8%       9541 ± 53%     -32.4%       9185 ± 49%  interrupts.CPU68.PMI:Performance_monitoring_interrupts
    579.67 ± 16%     -38.2%     358.33 ± 12%     -37.5%     362.33 ± 49%  interrupts.CPU68.RES:Rescheduling_interrupts
    495148 ± 13%     -37.5%     309667 ± 14%      -0.7%     491466 ± 21%  interrupts.CPU68.TLB:TLB_shootdowns
      2.33 ± 88%     -71.4%       0.67 ± 70%    -100.0%       0.00        interrupts.CPU69.105:PCI-MSI.31981638-edge.i40e-eth0-TxRx-69
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU69.116:PCI-MSI.31981649-edge.i40e-eth0-TxRx-80
      0.33 ±141%    -100.0%       0.00            +0.0%       0.33 ±141%  interrupts.CPU69.68:PCI-MSI.31981601-edge.i40e-eth0-TxRx-32
    551559 ± 11%     -44.9%     304007 ± 24%     -43.6%     311264 ± 35%  interrupts.CPU69.CAL:Function_call_interrupts
     54.67 ± 41%     -60.4%      21.67 ± 79%     -95.7%       2.33 ± 53%  interrupts.CPU69.IWI:IRQ_work_interrupts
    406054            -5.3%     384622 ±  3%      -1.1%     401528        interrupts.CPU69.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU69.MCP:Machine_check_polls
     17307 ± 29%     -42.1%      10018 ± 33%     -61.3%       6698 ± 28%  interrupts.CPU69.NMI:Non-maskable_interrupts
     17307 ± 29%     -42.1%      10018 ± 33%     -61.3%       6698 ± 28%  interrupts.CPU69.PMI:Performance_monitoring_interrupts
    665.33 ± 11%     -30.9%     459.67 ± 39%     -59.8%     267.67 ± 39%  interrupts.CPU69.RES:Rescheduling_interrupts
    663646 ± 12%     -41.7%     386944 ± 23%     -42.3%     382741 ± 35%  interrupts.CPU69.TLB:TLB_shootdowns
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        interrupts.CPU7.126:PCI-MSI.31981659-edge.i40e-eth0-TxRx-90
    254.33 ±  2%      +0.7%     256.00            +8.0%     274.67 ±  4%  interrupts.CPU7.35:PCI-MSI.31981568-edge.i40e-0000:3d:00.0:misc
      0.00       +1.3e+102%       1.33 ±141% +1.7e+103%      17.00 ±141%  interrupts.CPU7.43:PCI-MSI.31981576-edge.i40e-eth0-TxRx-7
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU7.78:PCI-MSI.31981611-edge.i40e-eth0-TxRx-42
    371965 ± 23%     -28.6%     265737 ± 24%     +29.7%     482488 ± 24%  interrupts.CPU7.CAL:Function_call_interrupts
     37.67 ± 53%     -30.1%      26.33 ±114%     +53.1%      57.67 ± 68%  interrupts.CPU7.IWI:IRQ_work_interrupts
    406037            -5.2%     384735 ±  5%      -1.2%     401178        interrupts.CPU7.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU7.MCP:Machine_check_polls
     14657 ± 22%     -16.1%      12291 ± 55%     +16.4%      17059 ± 45%  interrupts.CPU7.NMI:Non-maskable_interrupts
     14657 ± 22%     -16.1%      12291 ± 55%     +16.4%      17059 ± 45%  interrupts.CPU7.PMI:Performance_monitoring_interrupts
    500.33 ± 18%     -26.1%     369.67 ± 49%     -21.8%     391.33 ± 12%  interrupts.CPU7.RES:Rescheduling_interrupts
    449389 ± 22%     -24.9%     337335 ± 24%     +32.0%     593038 ± 25%  interrupts.CPU7.TLB:TLB_shootdowns
      1.00 ± 81%    -100.0%       0.00           -66.7%       0.33 ±141%  interrupts.CPU70.106:PCI-MSI.31981639-edge.i40e-eth0-TxRx-70
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        interrupts.CPU70.117:PCI-MSI.31981650-edge.i40e-eth0-TxRx-81
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU70.298:PCI-MSI.69632-edge.ioat-msix
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU70.69:PCI-MSI.31981602-edge.i40e-eth0-TxRx-33
    537913 ± 17%     -50.6%     265635 ± 27%     -21.3%     423367 ± 41%  interrupts.CPU70.CAL:Function_call_interrupts
     32.67 ± 14%     -50.0%      16.33 ±119%     -60.2%      13.00 ±119%  interrupts.CPU70.IWI:IRQ_work_interrupts
    405918            -4.0%     389625 ±  2%      -1.5%     400006        interrupts.CPU70.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU70.MCP:Machine_check_polls
     12582 ± 15%     -31.1%       8670 ± 41%     -37.3%       7892 ± 38%  interrupts.CPU70.NMI:Non-maskable_interrupts
     12582 ± 15%     -31.1%       8670 ± 41%     -37.3%       7892 ± 38%  interrupts.CPU70.PMI:Performance_monitoring_interrupts
    566.33 ± 18%     -42.4%     326.33 ± 21%     -25.7%     420.67 ± 49%  interrupts.CPU70.RES:Rescheduling_interrupts
    649429 ± 18%     -48.1%     337251 ± 27%     -19.8%     520634 ± 41%  interrupts.CPU70.TLB:TLB_shootdowns
      0.00       +1.3e+103%      12.67 ±141% +6.7e+101%       0.67 ±141%  interrupts.CPU71.107:PCI-MSI.31981640-edge.i40e-eth0-TxRx-71
      0.00          -100.0%       0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU71.118:PCI-MSI.31981651-edge.i40e-eth0-TxRx-82
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU71.298:PCI-MSI.69632-edge.ioat-msix
      0.33 ±141%    -100.0%       0.00          +100.0%       0.67 ± 70%  interrupts.CPU71.70:PCI-MSI.31981603-edge.i40e-eth0-TxRx-34
    401512 ±  6%     -28.0%     289239 ± 28%      -1.9%     393791 ± 18%  interrupts.CPU71.CAL:Function_call_interrupts
     57.00 ± 66%     -12.9%      49.67 ± 53%     -40.9%      33.67 ±105%  interrupts.CPU71.IWI:IRQ_work_interrupts
    406066            -4.6%     387349 ±  2%      -1.2%     401210        interrupts.CPU71.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU71.MCP:Machine_check_polls
     17401 ± 50%      -8.0%      16015 ± 36%     -33.7%      11537 ± 67%  interrupts.CPU71.NMI:Non-maskable_interrupts
     17401 ± 50%      -8.0%      16015 ± 36%     -33.7%      11537 ± 67%  interrupts.CPU71.PMI:Performance_monitoring_interrupts
    497.00 ± 13%      -7.6%     459.00 ± 41%     -28.2%     357.00 ± 17%  interrupts.CPU71.RES:Rescheduling_interrupts
    483544 ±  7%     -24.5%     365284 ± 29%      +0.4%     485325 ± 18%  interrupts.CPU71.TLB:TLB_shootdowns
      0.00          -100.0%       0.00       +1.3e+102%       1.33 ± 70%  interrupts.CPU72.108:PCI-MSI.31981641-edge.i40e-eth0-TxRx-72
    391767 ± 19%     -35.1%     254141 ± 23%      -5.6%     369998 ± 15%  interrupts.CPU72.CAL:Function_call_interrupts
     39.67 ± 97%     -66.4%      13.33 ± 96%      +0.0%      39.67 ± 63%  interrupts.CPU72.IWI:IRQ_work_interrupts
    406216            -3.8%     390895 ±  2%      -1.0%     402170        interrupts.CPU72.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU72.MCP:Machine_check_polls
     13818 ± 59%     -42.1%       7994 ± 40%      +7.8%      14895 ± 38%  interrupts.CPU72.NMI:Non-maskable_interrupts
     13818 ± 59%     -42.1%       7994 ± 40%      +7.8%      14895 ± 38%  interrupts.CPU72.PMI:Performance_monitoring_interrupts
    353.33 ± 22%     -13.6%     305.33 ± 22%     -14.6%     301.67 ± 13%  interrupts.CPU72.RES:Rescheduling_interrupts
    464879 ± 20%     -30.8%     321539 ± 23%      -2.8%     452067 ± 16%  interrupts.CPU72.TLB:TLB_shootdowns
      0.00         +1e+102%       1.00 ±141% +3.3e+101%       0.33 ±141%  interrupts.CPU73.109:PCI-MSI.31981642-edge.i40e-eth0-TxRx-73
    375098 ± 26%     -30.8%     259461 ± 25%      +7.1%     401679 ± 10%  interrupts.CPU73.CAL:Function_call_interrupts
     26.33 ±128%     +43.0%      37.67 ± 78%     -49.4%      13.33 ± 53%  interrupts.CPU73.IWI:IRQ_work_interrupts
    406872            -4.4%     388793 ±  4%      -1.3%     401459        interrupts.CPU73.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU73.MCP:Machine_check_polls
     11366 ± 62%     +17.2%      13324 ± 51%      -6.3%      10645 ± 27%  interrupts.CPU73.NMI:Non-maskable_interrupts
     11366 ± 62%     +17.2%      13324 ± 51%      -6.3%      10645 ± 27%  interrupts.CPU73.PMI:Performance_monitoring_interrupts
    313.67 ± 34%      +5.7%     331.67 ± 31%     +16.0%     364.00 ±  2%  interrupts.CPU73.RES:Rescheduling_interrupts
    445257 ± 27%     -25.4%     332038 ± 25%      +9.8%     488679 ± 11%  interrupts.CPU73.TLB:TLB_shootdowns
      0.33 ±141%  +19200.0%      64.33 ±140%    +100.0%       0.67 ± 70%  interrupts.CPU74.110:PCI-MSI.31981643-edge.i40e-eth0-TxRx-74
    367896 ± 11%     -29.7%     258694 ± 29%      +7.4%     395003 ± 15%  interrupts.CPU74.CAL:Function_call_interrupts
     62.00 ± 54%     -14.5%      53.00 ± 37%     -65.6%      21.33 ± 79%  interrupts.CPU74.IWI:IRQ_work_interrupts
    406270            -3.7%     391131 ±  2%      -1.2%     401293        interrupts.CPU74.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU74.MCP:Machine_check_polls
     18187 ± 35%      -9.9%      16381 ± 25%     -41.5%      10643 ± 23%  interrupts.CPU74.NMI:Non-maskable_interrupts
     18187 ± 35%      -9.9%      16381 ± 25%     -41.5%      10643 ± 23%  interrupts.CPU74.PMI:Performance_monitoring_interrupts
    403.33 ± 32%     -14.3%     345.67 ± 35%     -25.6%     300.00 ± 12%  interrupts.CPU74.RES:Rescheduling_interrupts
    436412 ± 11%     -24.6%     329016 ± 29%     +10.4%     481854 ± 15%  interrupts.CPU74.TLB:TLB_shootdowns
      1250 ±141%    -100.0%       0.00           -99.8%       3.00 ±118%  interrupts.CPU75.111:PCI-MSI.31981644-edge.i40e-eth0-TxRx-75
    339144 ± 19%     -21.2%     267312 ±  6%     +12.4%     381364 ± 22%  interrupts.CPU75.CAL:Function_call_interrupts
     16.00 ±123%     +35.4%      21.67 ± 72%    +141.7%      38.67 ± 48%  interrupts.CPU75.IWI:IRQ_work_interrupts
    406125            -4.9%     386289 ±  3%      -0.9%     402607        interrupts.CPU75.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU75.MCP:Machine_check_polls
      9006 ± 50%      +4.6%       9420 ± 40%     +64.1%      14780 ± 25%  interrupts.CPU75.NMI:Non-maskable_interrupts
      9006 ± 50%      +4.6%       9420 ± 40%     +64.1%      14780 ± 25%  interrupts.CPU75.PMI:Performance_monitoring_interrupts
    283.00 ± 27%     +10.2%     312.00 ± 18%     -15.1%     240.33 ± 10%  interrupts.CPU75.RES:Rescheduling_interrupts
    402100 ± 19%     -16.0%     337918 ±  5%     +15.8%     465564 ± 22%  interrupts.CPU75.TLB:TLB_shootdowns
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        interrupts.CPU76.112:PCI-MSI.31981645-edge.i40e-eth0-TxRx-76
    309381 ±  6%     -29.2%     218922           +59.0%     491921 ± 27%  interrupts.CPU76.CAL:Function_call_interrupts
      7.33 ± 75%    +445.5%      40.00 ± 58%    +345.5%      32.67 ±104%  interrupts.CPU76.IWI:IRQ_work_interrupts
    406164            -4.2%     389164 ±  3%      -1.0%     402212        interrupts.CPU76.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU76.MCP:Machine_check_polls
      6704 ± 22%     +99.6%      13381 ± 43%     +93.9%      13001 ± 63%  interrupts.CPU76.NMI:Non-maskable_interrupts
      6704 ± 22%     +99.6%      13381 ± 43%     +93.9%      13001 ± 63%  interrupts.CPU76.PMI:Performance_monitoring_interrupts
    257.00 ± 18%     +24.9%     321.00 ±  9%     +42.4%     366.00 ± 12%  interrupts.CPU76.RES:Rescheduling_interrupts
    367450 ±  5%     -24.3%     278039           +63.9%     602166 ± 28%  interrupts.CPU76.TLB:TLB_shootdowns
      0.00       +6.7e+101%       0.67 ±141%    -100.0%       0.00        interrupts.CPU77.113:PCI-MSI.31981646-edge.i40e-eth0-TxRx-77
    334856 ± 38%     -27.1%     243994 ± 21%     +24.4%     416704 ± 15%  interrupts.CPU77.CAL:Function_call_interrupts
     20.33 ± 91%     +73.8%      35.33 ± 89%    +154.1%      51.67 ± 34%  interrupts.CPU77.IWI:IRQ_work_interrupts
    406205            -4.9%     386349 ±  3%      -1.2%     401405        interrupts.CPU77.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU77.MCP:Machine_check_polls
      9580 ± 47%     +29.6%      12415 ± 55%     +67.2%      16016 ± 29%  interrupts.CPU77.NMI:Non-maskable_interrupts
      9580 ± 47%     +29.6%      12415 ± 55%     +67.2%      16016 ± 29%  interrupts.CPU77.PMI:Performance_monitoring_interrupts
    335.00 ± 35%     -10.9%     298.33 ± 28%      +9.0%     365.00 ± 18%  interrupts.CPU77.RES:Rescheduling_interrupts
    395218 ± 38%     -21.5%     310317 ± 20%     +28.8%     509080 ± 15%  interrupts.CPU77.TLB:TLB_shootdowns
      0.00       +6.7e+101%       0.67 ±141% +2.4e+104%     238.00 ±141%  interrupts.CPU78.114:PCI-MSI.31981647-edge.i40e-eth0-TxRx-78
    418010 ± 19%     -33.5%     277840 ± 22%     -19.6%     335933 ± 19%  interrupts.CPU78.CAL:Function_call_interrupts
     42.33 ± 55%     -18.1%      34.67 ± 46%     -66.1%      14.33 ±121%  interrupts.CPU78.IWI:IRQ_work_interrupts
    406365            -5.0%     386138 ±  3%      -1.2%     401325        interrupts.CPU78.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU78.MCP:Machine_check_polls
     15266 ± 25%     -17.8%      12549 ± 24%     -48.0%       7944 ± 37%  interrupts.CPU78.NMI:Non-maskable_interrupts
     15266 ± 25%     -17.8%      12549 ± 24%     -48.0%       7944 ± 37%  interrupts.CPU78.PMI:Performance_monitoring_interrupts
    368.67 ± 21%     +18.7%     437.67 ± 24%     -26.8%     270.00 ± 18%  interrupts.CPU78.RES:Rescheduling_interrupts
    496672 ± 19%     -29.1%     352231 ± 23%     -17.6%     409397 ± 18%  interrupts.CPU78.TLB:TLB_shootdowns
      0.00       +1.7e+102%       1.67 ±101% +3.3e+101%       0.33 ±141%  interrupts.CPU79.115:PCI-MSI.31981648-edge.i40e-eth0-TxRx-79
    244918 ± 55%     +18.5%     290346 ± 28%     +39.3%     341066 ± 52%  interrupts.CPU79.CAL:Function_call_interrupts
     62.00 ± 25%     -89.8%       6.33 ± 96%     -82.3%      11.00 ±115%  interrupts.CPU79.IWI:IRQ_work_interrupts
    406570            -4.9%     386467 ±  3%      -1.0%     402613        interrupts.CPU79.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU79.MCP:Machine_check_polls
     19292 ± 12%     -68.0%       6176 ±  9%     -60.2%       7673 ± 25%  interrupts.CPU79.NMI:Non-maskable_interrupts
     19292 ± 12%     -68.0%       6176 ±  9%     -60.2%       7673 ± 25%  interrupts.CPU79.PMI:Performance_monitoring_interrupts
    298.67 ± 69%     +29.9%     388.00 ± 37%      -2.3%     291.67 ± 39%  interrupts.CPU79.RES:Rescheduling_interrupts
    289855 ± 55%     +27.1%     368288 ± 27%     +42.7%     413528 ± 53%  interrupts.CPU79.TLB:TLB_shootdowns
      0.00       +6.7e+101%       0.67 ± 70% +3.3e+101%       0.33 ±141%  interrupts.CPU8.127:PCI-MSI.31981660-edge.i40e-eth0-TxRx-91
      0.00       +1.8e+104%     175.33 ±141%    -100.0%       0.00        interrupts.CPU8.44:PCI-MSI.31981577-edge.i40e-eth0-TxRx-8
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU8.79:PCI-MSI.31981612-edge.i40e-eth0-TxRx-43
    493612 ±  6%     -32.1%     335243 ± 12%     -12.5%     431711 ±  8%  interrupts.CPU8.CAL:Function_call_interrupts
     83.00           -69.9%      25.00 ± 66%     -24.9%      62.33 ± 16%  interrupts.CPU8.IWI:IRQ_work_interrupts
    405932            -5.4%     383836 ±  3%      -1.5%     400025        interrupts.CPU8.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU8.MCP:Machine_check_polls
     24233           -54.1%      11117 ± 30%     -25.3%      18104 ± 10%  interrupts.CPU8.NMI:Non-maskable_interrupts
     24233           -54.1%      11117 ± 30%     -25.3%      18104 ± 10%  interrupts.CPU8.PMI:Performance_monitoring_interrupts
    572.00 ± 19%      -7.3%     530.33 ± 38%     -33.2%     382.00 ± 20%  interrupts.CPU8.RES:Rescheduling_interrupts
    596825 ±  5%     -28.9%     424179 ± 13%     -11.3%     529365 ±  8%  interrupts.CPU8.TLB:TLB_shootdowns
      0.00          -100.0%       0.00       +1.3e+102%       1.33 ±141%  interrupts.CPU80.116:PCI-MSI.31981649-edge.i40e-eth0-TxRx-80
    359457 ± 18%      +9.6%     394073 ± 14%     +40.4%     504603 ± 18%  interrupts.CPU80.CAL:Function_call_interrupts
     34.33 ± 35%      +3.9%      35.67 ± 59%     +60.2%      55.00 ± 58%  interrupts.CPU80.IWI:IRQ_work_interrupts
    406171            -6.4%     379990 ±  5%      -1.2%     401246        interrupts.CPU80.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU80.MCP:Machine_check_polls
     13284 ± 25%      -3.6%      12803 ± 34%     +27.4%      16927 ± 40%  interrupts.CPU80.NMI:Non-maskable_interrupts
     13284 ± 25%      -3.6%      12803 ± 34%     +27.4%      16927 ± 40%  interrupts.CPU80.PMI:Performance_monitoring_interrupts
    304.33 ± 20%     +78.4%     543.00 ± 13%     +19.1%     362.33 ±  9%  interrupts.CPU80.RES:Rescheduling_interrupts
    426030 ± 17%     +17.4%     500211 ± 14%     +44.7%     616450 ± 18%  interrupts.CPU80.TLB:TLB_shootdowns
      0.00       +2.3e+104%     228.33 ±140%    -100.0%       0.00        interrupts.CPU81.117:PCI-MSI.31981650-edge.i40e-eth0-TxRx-81
    363025 ± 12%     -37.7%     226073 ± 37%     +19.6%     434005 ± 12%  interrupts.CPU81.CAL:Function_call_interrupts
     51.67 ± 57%     -58.1%      21.67 ± 81%     -39.4%      31.33 ± 40%  interrupts.CPU81.IWI:IRQ_work_interrupts
    407309            -5.7%     384208 ±  5%      -1.5%     401143        interrupts.CPU81.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU81.MCP:Machine_check_polls
     16904 ± 36%     -39.4%      10236 ± 38%     -23.6%      12918 ± 18%  interrupts.CPU81.NMI:Non-maskable_interrupts
     16904 ± 36%     -39.4%      10236 ± 38%     -23.6%      12918 ± 18%  interrupts.CPU81.PMI:Performance_monitoring_interrupts
    325.67 ± 25%     +28.9%     419.67 ± 32%     -11.2%     289.33 ±  9%  interrupts.CPU81.RES:Rescheduling_interrupts
    430316 ± 12%     -33.5%     286251 ± 37%     +23.6%     531947 ± 12%  interrupts.CPU81.TLB:TLB_shootdowns
      2.00 ±141%     -66.7%       0.67 ±141%  +18900.0%     380.00 ±141%  interrupts.CPU82.118:PCI-MSI.31981651-edge.i40e-eth0-TxRx-82
    329803 ± 29%      -4.3%     315544 ± 26%     +36.7%     450716 ± 36%  interrupts.CPU82.CAL:Function_call_interrupts
     32.67 ± 66%     -24.5%      24.67 ±113%     +38.8%      45.33 ± 50%  interrupts.CPU82.IWI:IRQ_work_interrupts
    406334            -4.1%     389525 ±  2%      -1.2%     401651        interrupts.CPU82.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU82.MCP:Machine_check_polls
     12303 ± 37%     -21.8%       9623 ± 52%     +23.7%      15214 ± 36%  interrupts.CPU82.NMI:Non-maskable_interrupts
     12303 ± 37%     -21.8%       9623 ± 52%     +23.7%      15214 ± 36%  interrupts.CPU82.PMI:Performance_monitoring_interrupts
    347.67 ± 53%     +31.8%     458.33 ± 20%     +16.2%     404.00 ± 11%  interrupts.CPU82.RES:Rescheduling_interrupts
    390955 ± 29%      +1.2%     395612 ± 27%     +40.8%     550522 ± 36%  interrupts.CPU82.TLB:TLB_shootdowns
    202.67 ±141%    -100.0%       0.00           -95.9%       8.33 ±141%  interrupts.CPU83.119:PCI-MSI.31981652-edge.i40e-eth0-TxRx-83
    342981 ± 68%     -28.3%     246050 ± 38%      +7.7%     369320 ± 11%  interrupts.CPU83.CAL:Function_call_interrupts
     36.67 ±102%      +1.8%      37.33 ± 86%     +10.9%      40.67 ± 66%  interrupts.CPU83.IWI:IRQ_work_interrupts
    406001            -5.6%     383303 ±  5%      -1.2%     401295        interrupts.CPU83.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU83.MCP:Machine_check_polls
     13569 ± 58%      -3.7%      13061 ± 52%      +7.2%      14545 ± 46%  interrupts.CPU83.NMI:Non-maskable_interrupts
     13569 ± 58%      -3.7%      13061 ± 52%      +7.2%      14545 ± 46%  interrupts.CPU83.PMI:Performance_monitoring_interrupts
    294.67 ± 74%     +42.6%     420.33 ± 37%     +22.6%     361.33 ± 11%  interrupts.CPU83.RES:Rescheduling_interrupts
    408140 ± 68%     -24.1%     309953 ± 38%     +10.2%     449932 ± 11%  interrupts.CPU83.TLB:TLB_shootdowns
      5.67 ±141%      -5.9%       5.33 ±141%    -100.0%       0.00        interrupts.CPU84.120:PCI-MSI.31981653-edge.i40e-eth0-TxRx-84
    292903 ± 11%     +29.4%     379037 ± 13%     +38.4%     405511 ± 12%  interrupts.CPU84.CAL:Function_call_interrupts
     17.00 ±108%     -41.2%      10.00 ± 57%    +139.2%      40.67 ± 77%  interrupts.CPU84.IWI:IRQ_work_interrupts
    406118            -6.5%     379889 ±  5%      -1.1%     401482        interrupts.CPU84.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU84.MCP:Machine_check_polls
     11652 ± 31%     -34.8%       7600 ± 16%     +28.0%      14909 ± 50%  interrupts.CPU84.NMI:Non-maskable_interrupts
     11652 ± 31%     -34.8%       7600 ± 16%     +28.0%      14909 ± 50%  interrupts.CPU84.PMI:Performance_monitoring_interrupts
    281.67 ± 28%     +68.4%     474.33 ± 16%      +9.1%     307.33 ± 15%  interrupts.CPU84.RES:Rescheduling_interrupts
    347512 ± 12%     +37.6%     478345 ± 13%     +42.4%     495028 ± 12%  interrupts.CPU84.TLB:TLB_shootdowns
      0.67 ±141%    -100.0%       0.00           -50.0%       0.33 ±141%  interrupts.CPU85.121:PCI-MSI.31981654-edge.i40e-eth0-TxRx-85
    457065 ± 13%     -28.4%     327187 ± 29%      -5.6%     431539 ± 27%  interrupts.CPU85.CAL:Function_call_interrupts
     17.67 ±121%    +288.7%      68.67 ± 10%    +139.6%      42.33 ± 25%  interrupts.CPU85.IWI:IRQ_work_interrupts
    406546            -6.7%     379235 ±  5%      -1.2%     401857        interrupts.CPU85.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU85.MCP:Machine_check_polls
      9749 ± 48%    +108.6%      20335 ±  6%     +57.6%      15365 ± 15%  interrupts.CPU85.NMI:Non-maskable_interrupts
      9749 ± 48%    +108.6%      20335 ±  6%     +57.6%      15365 ± 15%  interrupts.CPU85.PMI:Performance_monitoring_interrupts
    388.67 ± 21%      +3.1%     400.67 ± 33%     -13.2%     337.33 ± 11%  interrupts.CPU85.RES:Rescheduling_interrupts
    542336 ± 13%     -23.3%     415950 ± 28%      -2.8%     527349 ± 27%  interrupts.CPU85.TLB:TLB_shootdowns
      0.00          -100.0%       0.00       +6.4e+104%     644.33 ± 70%  interrupts.CPU86.122:PCI-MSI.31981655-edge.i40e-eth0-TxRx-86
    369748 ± 26%     -55.5%     164535 ± 35%      +2.9%     380379 ± 35%  interrupts.CPU86.CAL:Function_call_interrupts
     48.00 ± 50%     -77.1%      11.00 ± 56%     +21.5%      58.33 ±  8%  interrupts.CPU86.IWI:IRQ_work_interrupts
    406020            -2.9%     394410            -1.2%     401010        interrupts.CPU86.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU86.MCP:Machine_check_polls
     15763 ± 30%     -55.4%       7036 ± 23%     +17.5%      18529 ±  7%  interrupts.CPU86.NMI:Non-maskable_interrupts
     15763 ± 30%     -55.4%       7036 ± 23%     +17.5%      18529 ±  7%  interrupts.CPU86.PMI:Performance_monitoring_interrupts
    361.00 ± 33%     -48.8%     185.00 ± 42%     -16.3%     302.33 ± 18%  interrupts.CPU86.RES:Rescheduling_interrupts
    439179 ± 26%     -52.5%     208563 ± 36%      +5.8%     464700 ± 35%  interrupts.CPU86.TLB:TLB_shootdowns
    107.00 ±141%     +23.1%     131.67 ±141%    -100.0%       0.00        interrupts.CPU87.123:PCI-MSI.31981656-edge.i40e-eth0-TxRx-87
    399866 ± 36%     -35.9%     256137 ± 27%     -14.4%     342431 ± 24%  interrupts.CPU87.CAL:Function_call_interrupts
     56.67 ± 50%     -47.1%      30.00 ± 89%     -40.6%      33.67 ± 51%  interrupts.CPU87.IWI:IRQ_work_interrupts
    405899            -5.3%     384468 ±  5%      -1.1%     401377        interrupts.CPU87.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU87.MCP:Machine_check_polls
     17166 ± 34%     -35.1%      11146 ± 55%     -19.8%      13773 ± 27%  interrupts.CPU87.NMI:Non-maskable_interrupts
     17166 ± 34%     -35.1%      11146 ± 55%     -19.8%      13773 ± 27%  interrupts.CPU87.PMI:Performance_monitoring_interrupts
    416.00 ± 38%     -17.4%     343.67 ± 46%     -39.8%     250.33 ± 16%  interrupts.CPU87.RES:Rescheduling_interrupts
    476792 ± 36%     -31.9%     324893 ± 27%     -13.0%     415013 ± 24%  interrupts.CPU87.TLB:TLB_shootdowns
      0.00       +3.3e+101%       0.33 ±141%    -100.0%       0.00        interrupts.CPU88.124:PCI-MSI.31981657-edge.i40e-eth0-TxRx-88
    320126 ± 49%     -41.1%     188486 ± 35%     +52.9%     489365 ±  9%  interrupts.CPU88.CAL:Function_call_interrupts
     19.67 ±116%     -42.4%      11.33 ± 57%    +186.4%      56.33 ± 17%  interrupts.CPU88.IWI:IRQ_work_interrupts
    406159            -4.4%     388270 ±  3%      -1.3%     400684        interrupts.CPU88.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU88.MCP:Machine_check_polls
      9508 ± 46%     -27.7%       6875 ± 22%     +91.2%      18184 ± 16%  interrupts.CPU88.NMI:Non-maskable_interrupts
      9508 ± 46%     -27.7%       6875 ± 22%     +91.2%      18184 ± 16%  interrupts.CPU88.PMI:Performance_monitoring_interrupts
    292.33 ± 51%     +10.4%     322.67 ± 50%     +24.9%     365.00 ± 13%  interrupts.CPU88.RES:Rescheduling_interrupts
    379181 ± 49%     -37.1%     238446 ± 34%     +57.2%     596224 ±  9%  interrupts.CPU88.TLB:TLB_shootdowns
      2.00 ±141%    -100.0%       0.00          -100.0%       0.00        interrupts.CPU89.125:PCI-MSI.31981658-edge.i40e-eth0-TxRx-89
    294418 ± 13%     -26.0%     217844 ± 48%      -6.3%     275904 ± 19%  interrupts.CPU89.CAL:Function_call_interrupts
     26.00 ±119%     -50.0%      13.00 ±125%     +12.8%      29.33 ±131%  interrupts.CPU89.IWI:IRQ_work_interrupts
    405931            -4.4%     388170 ±  5%      -0.6%     403340        interrupts.CPU89.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU89.MCP:Machine_check_polls
     12075 ± 49%     -33.6%       8022 ± 51%      +0.8%      12177 ± 66%  interrupts.CPU89.NMI:Non-maskable_interrupts
     12075 ± 49%     -33.6%       8022 ± 51%      +0.8%      12177 ± 66%  interrupts.CPU89.PMI:Performance_monitoring_interrupts
    296.67 ± 50%      -7.5%     274.33 ± 28%     -31.6%     203.00 ±  8%  interrupts.CPU89.RES:Rescheduling_interrupts
    348558 ± 13%     -21.0%     275471 ± 48%      -3.6%     335874 ± 19%  interrupts.CPU89.TLB:TLB_shootdowns
      0.67 ± 70%     -50.0%       0.33 ±141%    -100.0%       0.00        interrupts.CPU9.128:PCI-MSI.31981661-edge.i40e-eth0-TxRx-92
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.CPU9.295:PCI-MSI.65536-edge.ioat-msix
     13.33 ±141%     -92.5%       1.00 ±141%    -100.0%       0.00        interrupts.CPU9.45:PCI-MSI.31981578-edge.i40e-eth0-TxRx-9
      0.00       +3.3e+101%       0.33 ±141% +3.3e+101%       0.33 ±141%  interrupts.CPU9.80:PCI-MSI.31981613-edge.i40e-eth0-TxRx-44
    448041 ± 35%     -46.2%     241152 ± 18%     +29.5%     580254 ± 22%  interrupts.CPU9.CAL:Function_call_interrupts
     78.33 ±  7%     -38.7%      48.00 ± 53%      -8.5%      71.67 ± 21%  interrupts.CPU9.IWI:IRQ_work_interrupts
    405915            -4.1%     389299 ±  2%      -1.3%     400804        interrupts.CPU9.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU9.MCP:Machine_check_polls
     22746 ±  9%     -28.0%      16386 ± 32%     -13.8%      19611 ± 17%  interrupts.CPU9.NMI:Non-maskable_interrupts
     22746 ±  9%     -28.0%      16386 ± 32%     -13.8%      19611 ± 17%  interrupts.CPU9.PMI:Performance_monitoring_interrupts
    527.00 ± 51%      +8.7%     572.67 ± 26%     -14.1%     452.67 ±  8%  interrupts.CPU9.RES:Rescheduling_interrupts
    538800 ± 34%     -43.2%     305862 ± 18%     +32.4%     713254 ± 22%  interrupts.CPU9.TLB:TLB_shootdowns
      0.00         +4e+102%       4.00 ± 93%    -100.0%       0.00        interrupts.CPU90.126:PCI-MSI.31981659-edge.i40e-eth0-TxRx-90
    344420 ± 35%     -46.0%     186093 ± 56%     +10.6%     381030 ± 28%  interrupts.CPU90.CAL:Function_call_interrupts
     33.33 ± 68%     +17.0%      39.00 ± 72%     +12.0%      37.33 ± 76%  interrupts.CPU90.IWI:IRQ_work_interrupts
    406207            -4.4%     388530 ±  3%      -1.2%     401139        interrupts.CPU90.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU90.MCP:Machine_check_polls
     13141 ± 36%      -1.9%      12887 ± 48%      +2.0%      13409 ± 48%  interrupts.CPU90.NMI:Non-maskable_interrupts
     13141 ± 36%      -1.9%      12887 ± 48%      +2.0%      13409 ± 48%  interrupts.CPU90.PMI:Performance_monitoring_interrupts
    280.33 ± 20%     +30.7%     366.33 ± 45%     +13.9%     319.33 ± 24%  interrupts.CPU90.RES:Rescheduling_interrupts
    407303 ± 34%     -42.4%     234729 ± 57%     +13.8%     463703 ± 28%  interrupts.CPU90.TLB:TLB_shootdowns
      0.00         +5e+102%       5.00 ±127% +3.3e+101%       0.33 ±141%  interrupts.CPU91.127:PCI-MSI.31981660-edge.i40e-eth0-TxRx-91
    211698 ± 49%     +23.4%     261323 ± 23%     +40.7%     297887 ±  9%  interrupts.CPU91.CAL:Function_call_interrupts
      7.67 ± 65%    +243.5%      26.33 ± 57%    +347.8%      34.33 ± 66%  interrupts.CPU91.IWI:IRQ_work_interrupts
    405917            -5.4%     384110 ±  5%      -0.9%     402253        interrupts.CPU91.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU91.MCP:Machine_check_polls
      6708 ± 21%     +57.8%      10588 ± 38%    +101.1%      13488 ± 35%  interrupts.CPU91.NMI:Non-maskable_interrupts
      6708 ± 21%     +57.8%      10588 ± 38%    +101.1%      13488 ± 35%  interrupts.CPU91.PMI:Performance_monitoring_interrupts
    249.33 ± 53%     +62.3%     404.67 ± 31%     +12.0%     279.33 ± 12%  interrupts.CPU91.RES:Rescheduling_interrupts
    250758 ± 49%     +32.1%     331240 ± 24%     +44.3%     361744 ±  9%  interrupts.CPU91.TLB:TLB_shootdowns
      0.67 ± 70%    +100.0%       1.33 ±141%      +0.0%       0.67 ±141%  interrupts.CPU92.128:PCI-MSI.31981661-edge.i40e-eth0-TxRx-92
    243117 ± 36%      -3.1%     235461 ± 14%     +51.8%     368952 ± 10%  interrupts.CPU92.CAL:Function_call_interrupts
     40.00 ± 81%     +33.3%      53.33 ± 16%     +31.7%      52.67 ± 44%  interrupts.CPU92.IWI:IRQ_work_interrupts
    406198            -4.6%     387672 ±  4%      -1.1%     401909        interrupts.CPU92.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU92.MCP:Machine_check_polls
     14086 ± 46%     +19.5%      16827 ± 15%     +18.4%      16681 ± 35%  interrupts.CPU92.NMI:Non-maskable_interrupts
     14086 ± 46%     +19.5%      16827 ± 15%     +18.4%      16681 ± 35%  interrupts.CPU92.PMI:Performance_monitoring_interrupts
    291.00 ± 28%      -3.4%     281.00 ± 25%     +14.8%     334.00 ± 22%  interrupts.CPU92.RES:Rescheduling_interrupts
    287247 ± 36%      +3.2%     296367 ± 14%     +55.9%     447954 ± 11%  interrupts.CPU92.TLB:TLB_shootdowns
      5.33 ±141%  +13800.0%     741.33 ±141%    +118.7%      11.67 ±141%  interrupts.CPU93.129:PCI-MSI.31981662-edge.i40e-eth0-TxRx-93
    369509 ± 20%     -37.3%     231695 ± 22%     -24.9%     277426 ± 30%  interrupts.CPU93.CAL:Function_call_interrupts
     36.00 ± 67%     -87.0%       4.67 ± 96%     -86.1%       5.00 ± 84%  interrupts.CPU93.IWI:IRQ_work_interrupts
    406247            -4.6%     387582 ±  3%      -0.9%     402466        interrupts.CPU93.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU93.MCP:Machine_check_polls
     12481 ± 36%     -51.1%       6101 ± 12%      -7.7%      11521 ± 61%  interrupts.CPU93.NMI:Non-maskable_interrupts
     12481 ± 36%     -51.1%       6101 ± 12%      -7.7%      11521 ± 61%  interrupts.CPU93.PMI:Performance_monitoring_interrupts
    316.00 ± 32%     -14.2%     271.00 ± 45%      -2.5%     308.00 ± 36%  interrupts.CPU93.RES:Rescheduling_interrupts
    439510 ± 20%     -33.2%     293475 ± 22%     -23.4%     336561 ± 30%  interrupts.CPU93.TLB:TLB_shootdowns
    340416 ± 23%     -47.1%     180155 ± 15%      +5.0%     357354 ± 29%  interrupts.CPU94.CAL:Function_call_interrupts
     41.33 ± 62%     -34.7%      27.00 ±128%     -31.5%      28.33 ± 69%  interrupts.CPU94.IWI:IRQ_work_interrupts
    406340            -3.0%     394315 ±  2%      -0.9%     402600        interrupts.CPU94.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU94.MCP:Machine_check_polls
     13098 ± 36%     -14.7%      11174 ± 72%      -8.5%      11980 ± 35%  interrupts.CPU94.NMI:Non-maskable_interrupts
     13098 ± 36%     -14.7%      11174 ± 72%      -8.5%      11980 ± 35%  interrupts.CPU94.PMI:Performance_monitoring_interrupts
    355.67 ± 20%     -25.7%     264.33 ± 16%     -22.6%     275.33 ± 18%  interrupts.CPU94.RES:Rescheduling_interrupts
    402839 ± 24%     -43.6%     227122 ± 14%      +8.0%     434996 ± 30%  interrupts.CPU94.TLB:TLB_shootdowns
    252892 ± 24%      +0.6%     254444 ± 31%     -15.2%     214354 ± 34%  interrupts.CPU95.CAL:Function_call_interrupts
     22.33 ± 16%      +4.5%      23.33 ± 33%     -28.4%      16.00 ± 97%  interrupts.CPU95.IWI:IRQ_work_interrupts
    406420            -5.3%     384975 ±  4%      -0.7%     403538        interrupts.CPU95.LOC:Local_timer_interrupts
      1.00            +0.0%       1.00            +0.0%       1.00        interrupts.CPU95.MCP:Machine_check_polls
      9491 ± 11%     +16.9%      11094 ± 10%     +19.6%      11351 ± 17%  interrupts.CPU95.NMI:Non-maskable_interrupts
      9491 ± 11%     +16.9%      11094 ± 10%     +19.6%      11351 ± 17%  interrupts.CPU95.PMI:Performance_monitoring_interrupts
    299.00 ± 14%     +74.5%     521.67 ± 43%     -11.4%     265.00 ± 15%  interrupts.CPU95.RES:Rescheduling_interrupts
    300146 ± 24%      +7.0%     321152 ± 31%     -12.4%     262989 ± 34%  interrupts.CPU95.TLB:TLB_shootdowns
      4028 ±  4%     -16.0%       3382 ±  4%      -7.6%       3722 ±  3%  interrupts.IWI:IRQ_work_interrupts
  38985876            -5.5%   36830793 ±  4%      -1.3%   38480217        interrupts.LOC:Local_timer_interrupts
     96.00            +0.0%      96.00            +0.0%      96.00        interrupts.MCP:Machine_check_polls
   1440872 ±  6%     -11.0%    1282701 ±  5%      -7.6%    1330904 ±  4%  interrupts.NMI:Non-maskable_interrupts
   1440872 ±  6%     -11.0%    1282701 ±  5%      -7.6%    1330904 ±  4%  interrupts.PMI:Performance_monitoring_interrupts
     46224 ± 15%     -10.2%      41502 ± 19%     -25.6%      34394 ± 18%  interrupts.RES:Rescheduling_interrupts
      0.00          -100.0%       0.00          -100.0%       0.00        interrupts.RTR:APIC_ICR_read_retries
  53033792 ±  2%     -30.8%   36706926 ±  4%      -4.6%   50586704        interrupts.TLB:TLB_shootdowns

Best Regards,
Rong Chen

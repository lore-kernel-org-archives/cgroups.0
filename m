From: Rong Chen <rong.a.chen@intel.com>
Subject: Re: [PATCH v19 18/20] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Tue, 27 Oct 2020 08:36:54 +0800
Message-ID: <20201027003654.GN31092@shao2-debian>
References: <1600918115-22007-1-git-send-email-alex.shi@linux.alibaba.com>
 <1600918115-22007-19-git-send-email-alex.shi@linux.alibaba.com>
 <ef27dcbd-37fe-c16a-71ee-61709cc135f3@linux.alibaba.com>
 <alpine.LSU.2.11.2010251240030.2287@eggly.anvils>
 <c1f1d964-7a55-8126-36b8-617c546bb536@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c1f1d964-7a55-8126-36b8-617c546bb536@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, Johannes Weiner <hannes@cmpxchg.org>, Yu Zhao <yuzhao@google.com>, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com, aaron.lwe@gmail.com, Michal Hocko <mhocko@kernel.org>, Yang Shi <yang.shi@linux.alibaba.com>, "lkp@linux.intel.com" <lkp@linux.intel.com>

On Mon, Oct 26, 2020 at 09:41:20AM +0800, Alex Shi wrote:
> 
> 
> 在 2020/10/26 上午5:51, Hugh Dickins 写道:
> > [PATCH] mm/lru: minimize workingset_age_nonresident() interference
> > 
> > 1. move_pages_to_lru() batch workingset_age_nonresident() (from Yu Zhao)
> > 2. workingset_age_nonresident() after unlock of lru_lock (from Yu Zhao)
> > 3. lru_note_cost_unlock_irq() to remove an unlock+lock of lru_lock
> > 4. lru_note_cost_unlock_irq() include updates of nonresident_age
> > 5. workingset_refault() use that OR workingset_age_nonresident()
> > 
> > Of those, I expect 1 & 2 (from Yu Zhao) to be the most significant,
> > increasingly so with more cpus, increasingly so with more levels in
> > the memcg hierarchy.
> > 
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> > Cc: Yu Zhao <yuzhao@google.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> 
> Hi Hugh,
> 
> Thanks a lot for checking and patch. I am in traveling today. So
> just can pick and put it as lruv21 branch on my github tree:
> https://github.com/alexshi/linux.git
> 
> Hi Rong,
> 
> We will very appreciate if you could launch testing on the branch
> and it'd better, if you have time to change the test case time as 1k
> second as Hugh wanted. Many thanks!
> 

Hi,

I changed the runtime to 1000s and tested the head two commits of branch lruv21,
there's no obvious performance change.


=========================================================================================
bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase/time_based/ucode:
  2M/gcc-9/performance/2pmem/xfs/mmap/x86_64-rhel-8.3/50%/debian-10.4-x86_64-20200603.cgz/1000s/randread/lkp-csl-2sp6/200G/fio-basic/tb/0x5002f01

commit: 
  5ab44845c5ca2a0611772328fdb38ede01027c8f ("mm/lru: revise the comments of lru_lock")
  82a171cb0bbe461d3864bb3e295a8ddc37115139 ("Hugh's patch")

5ab44845c5ca2a06 82a171cb0bbe461d3864bb3e295 
---------------- --------------------------- 
       fail:runs  %reproduction    fail:runs
           |             |             |    
       2117:3       -23558%        1410:3     dmesg.timestamp:last
       2117:3           43%        2118:3     kmsg.timestamp:last
          0:3            2%           0:3     perf-profile.children.cycles-pp.error_entry
          0:3            1%           0:3     perf-profile.self.cycles-pp.error_entry
         %stddev     %change         %stddev
             \          |                \  
      0.01 ± 70%      +0.0        0.01        fio.latency_1000ms%
      0.11 ± 17%      -0.0        0.10 ±  3%  fio.latency_1000us%
      0.41 ±  2%      +0.0        0.43 ± 20%  fio.latency_100ms%
     48.11            -1.8       46.34        fio.latency_10ms%
      0.01 ± 70%      -0.0        0.00 ±141%  fio.latency_2000ms%
      6.53 ± 12%      +0.9        7.45 ± 10%  fio.latency_20ms%
      0.04 ± 29%      +0.0        0.05 ± 57%  fio.latency_250ms%
      0.01 ±  6%      -0.0        0.01        fio.latency_250us%
      0.02 ± 34%      -0.0        0.01 ± 11%  fio.latency_2ms%
     15.79 ±  2%      +1.7       17.52 ±  7%  fio.latency_4ms%
      0.01            +0.0        0.01 ± 18%  fio.latency_500ms%
      0.40 ±  8%      -0.0        0.38 ±  2%  fio.latency_500us%
     27.73 ±  3%      -0.9       26.86 ±  5%  fio.latency_50ms%
      0.01            +0.0        0.01        fio.latency_750ms%
      0.85            -0.0        0.83        fio.latency_750us%
      0.00 ±141%      +0.0        0.00 ±141%  fio.latency_>=2000ms%
      7495 ±  2%      -0.0%       7495        fio.read_bw_MBps
  26432853 ±  2%      -0.3%   26345472 ±  2%  fio.read_clat_90%_us
  29316437 ±  2%      +0.0%   29316437        fio.read_clat_95%_us
  40108032            +1.7%   40807082 ±  5%  fio.read_clat_99%_us
  12310704 ±  2%      -0.4%   12257079        fio.read_clat_mean_us
  13001646 ± 18%      +3.5%   13462476 ± 21%  fio.read_clat_stddev
      3747 ±  2%      -0.0%       3747        fio.read_iops
      1001            +0.0%       1001        fio.time.elapsed_time
      1001            +0.0%       1001        fio.time.elapsed_time.max
 1.514e+10 ±  2%      +0.0%  1.515e+10        fio.time.file_system_inputs
   2129458           +14.8%    2443796        fio.time.involuntary_context_switches
 1.893e+09 ±  2%      +0.0%  1.893e+09        fio.time.major_page_faults
   1776288 ±  6%      -1.1%    1756372 ±  2%  fio.time.maximum_resident_set_size
     91856 ± 73%     -54.9%      41464 ± 71%  fio.time.minor_page_faults
      4096            +0.0%       4096        fio.time.page_size
      4742            -0.1%       4738        fio.time.percent_of_cpu_this_job_got
     46089            -0.1%      46028        fio.time.system_time
      1400 ±  3%      +2.1%       1429 ±  2%  fio.time.user_time
    112653            +2.5%     115447 ±  2%  fio.time.voluntary_context_switches
   3748168 ±  2%      -0.0%    3747993        fio.workload
      1206            -0.0%       1206        uptime.boot
     65004            -0.1%      64961        uptime.idle
     27.17            -0.1%      27.15        boot-time.boot
     15.64            -0.1%      15.63        boot-time.dhcp
      2245            +0.1%       2248        boot-time.idle
      0.86            -0.0%       0.86        boot-time.smp_boot
     47.86            -0.1%      47.80        iostat.cpu.idle
      0.01 ± 77%     -40.2%       0.01 ±100%  iostat.cpu.iowait
     50.67            +0.1%      50.69        iostat.cpu.system
      1.46 ±  3%      +2.1%       1.50 ±  2%  iostat.cpu.user
     47.76            -0.1       47.71        mpstat.cpu.all.idle%
      0.01 ± 78%      -0.0        0.01 ±100%  mpstat.cpu.all.iowait%
      0.90            +0.0        0.90 ±  2%  mpstat.cpu.all.irq%
      0.04 ±  2%      +0.0        0.04        mpstat.cpu.all.soft%
     49.82            +0.0       49.84        mpstat.cpu.all.sys%
      1.47 ±  3%      +0.0        1.50 ±  2%  mpstat.cpu.all.usr%
   2381530 ± 22%     +16.0%    2762419 ± 16%  cpuidle.C1.time
    147295 ± 13%      -5.6%     139089        cpuidle.C1.usage
 3.274e+10 ± 48%     +16.1%  3.802e+10        cpuidle.C1E.time
  77503135 ± 23%      +8.4%   83999622        cpuidle.C1E.usage
  1.32e+10 ±120%     -40.9%  7.801e+09 ± 10%  cpuidle.C6.time
  15835701 ±115%     -42.3%    9138895        cpuidle.C6.usage
    269540 ±  4%      -6.5%     252055 ±  2%  cpuidle.POLL.time
     86578 ±  4%      -7.3%      80253 ±  3%  cpuidle.POLL.usage
      0.00          -100.0%       0.00        numa-numastat.node0.interleave_hit
 7.231e+08 ±  4%      +0.2%  7.244e+08 ±  3%  numa-numastat.node0.local_node
   2.1e+08 ±  3%      -0.1%  2.098e+08 ±  3%  numa-numastat.node0.numa_foreign
 7.231e+08 ±  4%      +0.2%  7.244e+08 ±  3%  numa-numastat.node0.numa_hit
 2.162e+08 ±  4%      -5.8%  2.037e+08 ±  3%  numa-numastat.node0.numa_miss
 2.163e+08 ±  4%      -5.8%  2.037e+08 ±  3%  numa-numastat.node0.other_node
      0.00          -100.0%       0.00        numa-numastat.node1.interleave_hit
 7.457e+08            +1.6%   7.58e+08 ±  2%  numa-numastat.node1.local_node
 2.162e+08 ±  4%      -5.8%  2.037e+08 ±  3%  numa-numastat.node1.numa_foreign
 7.457e+08            +1.6%   7.58e+08 ±  2%  numa-numastat.node1.numa_hit
   2.1e+08 ±  3%      -0.1%  2.098e+08 ±  3%  numa-numastat.node1.numa_miss
   2.1e+08 ±  3%      -0.1%  2.098e+08 ±  3%  numa-numastat.node1.other_node
      1001            +0.0%       1001        time.elapsed_time
      1001            +0.0%       1001        time.elapsed_time.max
 1.514e+10 ±  2%      +0.0%  1.515e+10        time.file_system_inputs
   2129458           +14.8%    2443796        time.involuntary_context_switches
 1.893e+09 ±  2%      +0.0%  1.893e+09        time.major_page_faults
   1776288 ±  6%      -1.1%    1756372 ±  2%  time.maximum_resident_set_size
     91856 ± 73%     -54.9%      41464 ± 71%  time.minor_page_faults
      4096            +0.0%       4096        time.page_size
      4742            -0.1%       4738        time.percent_of_cpu_this_job_got
     46089            -0.1%      46028        time.system_time
      1400 ±  3%      +2.1%       1429 ±  2%  time.user_time
    112653            +2.5%     115447 ±  2%  time.voluntary_context_switches
     47.33            -0.7%      47.00        vmstat.cpu.id
     50.00            +0.0%      50.00        vmstat.cpu.sy
      1.00            +0.0%       1.00        vmstat.cpu.us
      0.00          -100.0%       0.00        vmstat.cpu.wa
   7531466 ±  2%      +0.1%    7542581        vmstat.io.bi
     10.33 ±  4%      +3.2%      10.67 ±  4%  vmstat.io.bo
      0.00          -100.0%       0.00        vmstat.memory.buff
  43340208            -0.0%   43334775        vmstat.memory.cache
    477452            +6.8%     509884 ±  5%  vmstat.memory.free
      0.00          -100.0%       0.00        vmstat.procs.b
     49.00            +0.0%      49.00        vmstat.procs.r
      6109           +10.4%       6747        vmstat.system.cs
    339248            -3.6%     326966 ±  2%  vmstat.system.in
   2116526            -1.1%    2093850        meminfo.Active
    196886 ±  4%      -3.5%     190029 ±  2%  meminfo.Active(anon)
   1919638            -0.8%    1903820        meminfo.Active(file)
    343278            +0.5%     345049        meminfo.AnonHugePages
    444614 ±  6%      -4.9%     423019 ±  5%  meminfo.AnonPages
      0.00          -100.0%       0.00        meminfo.Buffers
  42942752            -0.0%   42933243        meminfo.Cached
     16232 ± 37%     +98.2%      32164 ± 30%  meminfo.CmaFree
    204800            +0.0%     204800        meminfo.CmaTotal
  24554032            +0.0%   24554032        meminfo.CommitLimit
   6741881            +0.0%    6744732        meminfo.Committed_AS
 2.538e+08            +0.7%  2.555e+08        meminfo.DirectMap1G
  15714986 ±  5%     -11.3%   13942784 ±  3%  meminfo.DirectMap2M
    738069 ±  7%      +3.3%     762645 ±  5%  meminfo.DirectMap4k
      5.00 ± 43%     +73.3%       8.67 ±  5%  meminfo.Dirty
      2048            +0.0%       2048        meminfo.Hugepagesize
  40262123            -0.0%   40254287        meminfo.Inactive
   1578006            -1.3%    1557448        meminfo.Inactive(anon)
  38684117            +0.0%   38696838        meminfo.Inactive(file)
    380179            -0.1%     379931        meminfo.KReclaimable
     15548            -0.0%      15543        meminfo.KernelStack
  41681713            +0.1%   41734197        meminfo.Mapped
  40857814            -0.0%   40843964        meminfo.MemAvailable
    493196            +7.4%     529558 ±  5%  meminfo.MemFree
  49108064            +0.0%   49108064        meminfo.MemTotal
  48614867            -0.1%   48578504        meminfo.Memused
      2230 ±  7%     -10.1%       2004        meminfo.Mlocked
    413143            +0.2%     413857        meminfo.PageTables
     47194            -0.2%      47120        meminfo.Percpu
    380179            -0.1%     379931        meminfo.SReclaimable
    210680            -1.2%     208051        meminfo.SUnreclaim
   1330766            -0.4%    1324924        meminfo.Shmem
    590860            -0.5%     587983        meminfo.Slab
   1002266            -0.0%    1002110        meminfo.Unevictable
 3.436e+10            +0.0%  3.436e+10        meminfo.VmallocTotal
    141540            +0.0%     141586        meminfo.VmallocUsed
      0.33 ±141%    -100.0%       0.00        meminfo.Writeback
     49345            +0.2%      49446        meminfo.max_used_kB
   1004900 ±  2%      -2.0%     984368 ±  2%  numa-meminfo.node0.Active
     47962 ±  7%     -20.4%      38173 ±  8%  numa-meminfo.node0.Active(anon)
    956937 ±  2%      -1.1%     946194 ±  3%  numa-meminfo.node0.Active(file)
    155335 ± 39%     +16.0%     180235 ±  2%  numa-meminfo.node0.AnonHugePages
    202539 ± 30%     +11.4%     225566 ±  7%  numa-meminfo.node0.AnonPages
      1.33 ± 93%    +350.0%       6.00 ± 36%  numa-meminfo.node0.Dirty
  21255962            -0.2%   21213790        numa-meminfo.node0.FilePages
  19943681            -0.0%   19934270        numa-meminfo.node0.Inactive
    580554 ± 83%     +68.8%     980056 ± 56%  numa-meminfo.node0.Inactive(anon)
  19363126 ±  2%      -2.1%   18954212 ±  2%  numa-meminfo.node0.Inactive(file)
    203115 ±  3%      -1.1%     200911 ±  2%  numa-meminfo.node0.KReclaimable
      8273 ±  5%      +7.3%       8879 ±  6%  numa-meminfo.node0.KernelStack
  20670432            -0.1%   20648779        numa-meminfo.node0.Mapped
    288688 ±  5%      +0.0%     288688 ±  7%  numa-meminfo.node0.MemFree
  24375744            +0.0%   24375744        numa-meminfo.node0.MemTotal
  24087054            +0.0%   24087054        numa-meminfo.node0.MemUsed
      1153 ± 12%      -9.0%       1049 ± 13%  numa-meminfo.node0.Mlocked
    219002 ±  9%      +6.4%     232926 ±  2%  numa-meminfo.node0.PageTables
    203115 ±  3%      -1.1%     200911 ±  2%  numa-meminfo.node0.SReclaimable
    107409 ±  6%      +4.3%     111998 ±  7%  numa-meminfo.node0.SUnreclaim
    426256 ±125%     +86.0%     792944 ± 67%  numa-meminfo.node0.Shmem
    310526            +0.8%     312910 ±  2%  numa-meminfo.node0.Slab
    506983 ±  3%      +2.1%     517878        numa-meminfo.node0.Unevictable
      0.00          -100.0%       0.00        numa-meminfo.node0.Writeback
   1111595 ±  3%      -0.1%    1110160 ±  2%  numa-meminfo.node1.Active
    149042 ±  4%      +1.8%     151793 ±  5%  numa-meminfo.node1.Active(anon)
    962552 ±  3%      -0.4%     958366 ±  3%  numa-meminfo.node1.Active(file)
    187949 ± 31%     -12.3%     164813 ±  4%  numa-meminfo.node1.AnonHugePages
    242069 ± 21%     -18.4%     197426 ± 10%  numa-meminfo.node1.AnonPages
      3.33 ±101%     -40.0%       2.00 ±108%  numa-meminfo.node1.Dirty
  21685725            +0.2%   21720795        numa-meminfo.node1.FilePages
  20317717            +0.0%   20320622        numa-meminfo.node1.Inactive
    997352 ± 50%     -42.1%     577386 ± 93%  numa-meminfo.node1.Inactive(anon)
  19320364 ±  2%      +2.2%   19743235 ±  2%  numa-meminfo.node1.Inactive(file)
    176979 ±  4%      +1.1%     178959 ±  2%  numa-meminfo.node1.KReclaimable
      7271 ±  7%      -8.4%       6663 ±  9%  numa-meminfo.node1.KernelStack
  21009777            +0.3%   21073539        numa-meminfo.node1.Mapped
    205643 ± 11%     +17.0%     240617 ±  7%  numa-meminfo.node1.MemFree
  24732320            +0.0%   24732320        numa-meminfo.node1.MemTotal
  24526676            -0.1%   24491701        numa-meminfo.node1.MemUsed
      1077 ± 17%     -11.4%     955.33 ± 14%  numa-meminfo.node1.Mlocked
    194090 ± 10%      -6.9%     180794 ±  2%  numa-meminfo.node1.PageTables
    176979 ±  4%      +1.1%     178959 ±  2%  numa-meminfo.node1.SReclaimable
    103268 ±  6%      -7.0%      96053 ±  9%  numa-meminfo.node1.SUnreclaim
    904534 ± 58%     -41.2%     531937 ±101%  numa-meminfo.node1.Shmem
    280249 ±  2%      -1.9%     275013 ±  2%  numa-meminfo.node1.Slab
    495282 ±  3%      -2.2%     484231        numa-meminfo.node1.Unevictable
      0.00          -100.0%       0.00        numa-meminfo.node1.Writeback
     10.00            +1.2%      10.12 ±  2%  perf-stat.i.MPKI
 9.909e+09            +0.2%  9.928e+09        perf-stat.i.branch-instructions
      0.36            +0.0        0.37        perf-stat.i.branch-miss-rate%
  35992682            +1.4%   36491789        perf-stat.i.branch-misses
     66.00            -0.6       65.38        perf-stat.i.cache-miss-rate%
 3.168e+08            +0.6%  3.188e+08        perf-stat.i.cache-misses
 4.783e+08            +1.7%  4.862e+08        perf-stat.i.cache-references
      6111           +10.4%       6749        perf-stat.i.context-switches
      2.98            +0.3%       2.98        perf-stat.i.cpi
     96004            +0.0%      96006        perf-stat.i.cpu-clock
 1.396e+11            +0.1%  1.397e+11        perf-stat.i.cpu-cycles
    107.73            +0.1%     107.84        perf-stat.i.cpu-migrations
    463.94 ±  2%      +0.5%     466.31 ±  3%  perf-stat.i.cycles-between-cache-misses
      0.36 ±  2%      +0.0        0.36        perf-stat.i.dTLB-load-miss-rate%
  44154472 ±  2%      +0.7%   44454597 ±  2%  perf-stat.i.dTLB-load-misses
   1.2e+10            +0.1%  1.202e+10        perf-stat.i.dTLB-loads
      0.06 ± 13%      -0.0        0.05 ± 12%  perf-stat.i.dTLB-store-miss-rate%
   3458458 ± 15%     -13.9%    2978090 ± 10%  perf-stat.i.dTLB-store-misses
 5.595e+09 ±  2%      +0.1%  5.598e+09        perf-stat.i.dTLB-stores
     88.43            +0.3       88.68        perf-stat.i.iTLB-load-miss-rate%
  18516950 ±  2%      -0.4%   18452098        perf-stat.i.iTLB-load-misses
   2351967            -3.2%    2276210 ±  3%  perf-stat.i.iTLB-loads
 4.757e+10            +0.2%  4.766e+10        perf-stat.i.instructions
      2611 ±  2%      +0.9%       2635        perf-stat.i.instructions-per-iTLB-miss
      0.34            +0.1%       0.34        perf-stat.i.ipc
   1888487 ±  2%      +0.1%    1890563        perf-stat.i.major-faults
      1.45            +0.1%       1.46        perf-stat.i.metric.GHz
      0.10 ±  2%      +6.5%       0.10 ±  3%  perf-stat.i.metric.K/sec
    292.62            +0.2%     293.11        perf-stat.i.metric.M/sec
      2818 ±  2%      -1.8%       2767        perf-stat.i.minor-faults
     60.07 ±  9%      -2.9       57.15 ±  3%  perf-stat.i.node-load-miss-rate%
  15587559 ± 11%      -5.3%   14769098 ±  4%  perf-stat.i.node-load-misses
  10462305 ± 12%      +7.6%   11255055 ±  3%  perf-stat.i.node-loads
     34.30            -0.5       33.80        perf-stat.i.node-store-miss-rate%
  24134386            -1.9%   23678903        perf-stat.i.node-store-misses
  48193903 ±  2%      +1.1%   48737571        perf-stat.i.node-stores
   1891305 ±  2%      +0.1%    1893331        perf-stat.i.page-faults
     96004            +0.0%      96006        perf-stat.i.task-clock
     10.06            +1.5%      10.20 ±  2%  perf-stat.overall.MPKI
      0.36            +0.0        0.37        perf-stat.overall.branch-miss-rate%
     66.24            -0.7       65.58        perf-stat.overall.cache-miss-rate%
      2.94            -0.1%       2.93        perf-stat.overall.cpi
    440.72            -0.5%     438.52        perf-stat.overall.cycles-between-cache-misses
      0.37 ±  2%      +0.0        0.37        perf-stat.overall.dTLB-load-miss-rate%
      0.06 ± 13%      -0.0        0.05 ± 12%  perf-stat.overall.dTLB-store-miss-rate%
     88.72            +0.3       89.02        perf-stat.overall.iTLB-load-miss-rate%
      2570 ±  2%      +0.5%       2583        perf-stat.overall.instructions-per-iTLB-miss
      0.34            +0.0%       0.34        perf-stat.overall.ipc
     59.74 ±  9%      -3.0       56.73 ±  3%  perf-stat.overall.node-load-miss-rate%
     33.38 ±  2%      -0.7       32.71        perf-stat.overall.node-store-miss-rate%
  12713516            +0.1%   12728885        perf-stat.overall.path-length
 9.897e+09            +0.2%  9.915e+09        perf-stat.ps.branch-instructions
  35945816            +1.4%   36441252        perf-stat.ps.branch-misses
 3.164e+08            +0.6%  3.184e+08        perf-stat.ps.cache-misses
 4.777e+08            +1.6%  4.855e+08        perf-stat.ps.cache-references
      6105           +10.4%       6742        perf-stat.ps.context-switches
     95903            +0.0%      95903        perf-stat.ps.cpu-clock
 1.394e+11            +0.1%  1.396e+11        perf-stat.ps.cpu-cycles
    107.66            +0.1%     107.77        perf-stat.ps.cpu-migrations
  44094822 ±  2%      +0.7%   44390837 ±  2%  perf-stat.ps.dTLB-load-misses
 1.199e+10            +0.1%    1.2e+10        perf-stat.ps.dTLB-loads
   3453661 ± 15%     -13.9%    2973891 ± 10%  perf-stat.ps.dTLB-store-misses
 5.588e+09 ±  2%      +0.0%  5.591e+09        perf-stat.ps.dTLB-stores
  18492228 ±  2%      -0.4%   18426219        perf-stat.ps.iTLB-load-misses
   2349163            -3.2%    2273384 ±  3%  perf-stat.ps.iTLB-loads
 4.751e+10            +0.2%  4.759e+10        perf-stat.ps.instructions
   1885948 ±  2%      +0.1%    1887890        perf-stat.ps.major-faults
      2816 ±  2%      -1.8%       2764        perf-stat.ps.minor-faults
  15568897 ± 11%      -5.3%   14750517 ±  4%  perf-stat.ps.node-load-misses
  10447880 ± 12%      +7.6%   11238767 ±  3%  perf-stat.ps.node-loads
  24104368            -1.9%   23650332        perf-stat.ps.node-store-misses
  48128645 ±  2%      +1.1%   48666903        perf-stat.ps.node-stores
   1888764 ±  2%      +0.1%    1890654        perf-stat.ps.page-faults
     95903            +0.0%      95903        perf-stat.ps.task-clock
 4.765e+13            +0.1%  4.771e+13        perf-stat.total.instructions
     11989 ±  7%     -20.3%       9556 ±  8%  numa-vmstat.node0.nr_active_anon
    239216 ±  2%      -1.1%     236607 ±  3%  numa-vmstat.node0.nr_active_file
     50639 ± 30%     +11.4%      56395 ±  7%  numa-vmstat.node0.nr_anon_pages
     75.33 ± 39%     +16.4%      87.67 ±  3%  numa-vmstat.node0.nr_anon_transparent_hugepages
  33816140 ± 68%     +49.3%   50497277 ±  2%  numa-vmstat.node0.nr_dirtied
      0.00       +1.3e+102%       1.33 ± 70%  numa-vmstat.node0.nr_dirty
   5313242            -0.2%    5302912        numa-vmstat.node0.nr_file_pages
     72824 ±  6%      +0.1%      72874 ±  8%  numa-vmstat.node0.nr_free_pages
    145144 ± 83%     +68.8%     245008 ± 56%  numa-vmstat.node0.nr_inactive_anon
   4840025 ±  2%      -2.1%    4737960 ±  2%  numa-vmstat.node0.nr_inactive_file
    158.67 ±  7%     +25.6%     199.33 ±  7%  numa-vmstat.node0.nr_isolated_file
      8274 ±  5%      +7.3%       8878 ±  7%  numa-vmstat.node0.nr_kernel_stack
   5168599            -0.1%    5163354        numa-vmstat.node0.nr_mapped
    288.33 ± 12%      -9.1%     262.00 ± 12%  numa-vmstat.node0.nr_mlock
     54763 ±  9%      +6.4%      58253 ±  2%  numa-vmstat.node0.nr_page_table_pages
    106564 ±125%     +86.0%     198240 ± 67%  numa-vmstat.node0.nr_shmem
     50785 ±  3%      -1.1%      50221 ±  2%  numa-vmstat.node0.nr_slab_reclaimable
     26852 ±  6%      +4.3%      28000 ±  7%  numa-vmstat.node0.nr_slab_unreclaimable
    126745 ±  3%      +2.1%     129469        numa-vmstat.node0.nr_unevictable
     28.67 ±101%    +158.1%      74.00 ± 36%  numa-vmstat.node0.nr_vmscan_immediate_reclaim
      0.00          -100.0%       0.00        numa-vmstat.node0.nr_writeback
  33816139 ± 68%     +49.3%   50497275 ±  2%  numa-vmstat.node0.nr_written
     11989 ±  7%     -20.3%       9557 ±  8%  numa-vmstat.node0.nr_zone_active_anon
    239055 ±  2%      -1.1%     236440 ±  3%  numa-vmstat.node0.nr_zone_active_file
    145174 ± 83%     +68.8%     245032 ± 56%  numa-vmstat.node0.nr_zone_inactive_anon
   4839649 ±  2%      -2.1%    4737625 ±  2%  numa-vmstat.node0.nr_zone_inactive_file
    126745 ±  3%      +2.1%     129469        numa-vmstat.node0.nr_zone_unevictable
      0.00       +1.3e+102%       1.33 ± 70%  numa-vmstat.node0.nr_zone_write_pending
 1.106e+08 ±  4%      -1.6%  1.089e+08 ±  6%  numa-vmstat.node0.numa_foreign
 3.938e+08 ±  6%      +5.3%  4.148e+08 ±  4%  numa-vmstat.node0.numa_hit
    139721            +0.1%     139911        numa-vmstat.node0.numa_interleave
 3.938e+08 ±  6%      +5.3%  4.147e+08 ±  4%  numa-vmstat.node0.numa_local
 1.122e+08 ±  6%      -8.2%   1.03e+08 ±  3%  numa-vmstat.node0.numa_miss
 1.122e+08 ±  6%      -8.2%   1.03e+08 ±  3%  numa-vmstat.node0.numa_other
    798735 ±  5%      -2.6%     777744 ±  6%  numa-vmstat.node0.workingset_activate_file
    168713 ±  3%      -4.7%     160841 ±  2%  numa-vmstat.node0.workingset_nodes
  69574620 ±  6%      -2.7%   67672869 ±  4%  numa-vmstat.node0.workingset_refault_file
     20789 ± 34%     +26.1%      26212 ± 15%  numa-vmstat.node0.workingset_restore_file
     37255 ±  4%      +2.0%      38011 ±  5%  numa-vmstat.node1.nr_active_anon
    240582 ±  3%      -0.4%     239532 ±  2%  numa-vmstat.node1.nr_active_file
     60526 ± 21%     -18.4%      49360 ± 10%  numa-vmstat.node1.nr_anon_pages
     91.00 ± 31%     -12.5%      79.67 ±  4%  numa-vmstat.node1.nr_anon_transparent_hugepages
  18612744 ±123%     -89.6%    1931606 ± 70%  numa-vmstat.node1.nr_dirtied
      0.67 ±141%     -50.0%       0.33 ±141%  numa-vmstat.node1.nr_dirty
   5421155            +0.2%    5429991        numa-vmstat.node1.nr_file_pages
      4101 ± 37%     +96.1%       8044 ± 30%  numa-vmstat.node1.nr_free_cma
     51916 ± 10%     +17.0%      60748 ±  7%  numa-vmstat.node1.nr_free_pages
    249404 ± 50%     -42.1%     144339 ± 93%  numa-vmstat.node1.nr_inactive_anon
   4829812 ±  2%      +2.2%    4935642 ±  2%  numa-vmstat.node1.nr_inactive_file
      0.00          -100.0%       0.00        numa-vmstat.node1.nr_isolated_anon
    150.67 ±  5%     +47.8%     222.67 ±  8%  numa-vmstat.node1.nr_isolated_file
      7272 ±  7%      -8.4%       6661 ±  9%  numa-vmstat.node1.nr_kernel_stack
   5253730            +0.3%    5269746        numa-vmstat.node1.nr_mapped
    269.33 ± 17%     -11.4%     238.67 ± 14%  numa-vmstat.node1.nr_mlock
     48539 ± 10%      -6.9%      45212 ±  2%  numa-vmstat.node1.nr_page_table_pages
    226185 ± 58%     -41.2%     133035 ±101%  numa-vmstat.node1.nr_shmem
     44251 ±  4%      +1.1%      44741 ±  2%  numa-vmstat.node1.nr_slab_reclaimable
     25817 ±  6%      -7.0%      24012 ±  9%  numa-vmstat.node1.nr_slab_unreclaimable
    123820 ±  3%      -2.2%     121057        numa-vmstat.node1.nr_unevictable
     64.33 ± 69%     -35.8%      41.33 ±102%  numa-vmstat.node1.nr_vmscan_immediate_reclaim
      0.00          -100.0%       0.00        numa-vmstat.node1.nr_writeback
  18612743 ±123%     -89.6%    1931605 ± 70%  numa-vmstat.node1.nr_written
     37255 ±  4%      +2.0%      38011 ±  5%  numa-vmstat.node1.nr_zone_active_anon
    240484 ±  3%      -0.4%     239404 ±  2%  numa-vmstat.node1.nr_zone_active_file
    249431 ± 50%     -42.1%     144374 ± 93%  numa-vmstat.node1.nr_zone_inactive_anon
   4829583 ±  2%      +2.2%    4935478 ±  2%  numa-vmstat.node1.nr_zone_inactive_file
    123820 ±  3%      -2.2%     121057        numa-vmstat.node1.nr_zone_unevictable
      0.33 ±141%      +0.0%       0.33 ±141%  numa-vmstat.node1.nr_zone_write_pending
 1.122e+08 ±  6%      -8.2%   1.03e+08 ±  3%  numa-vmstat.node1.numa_foreign
 3.894e+08 ±  6%      -2.4%  3.799e+08 ±  3%  numa-vmstat.node1.numa_hit
    140170            -0.2%     139941        numa-vmstat.node1.numa_interleave
 3.893e+08 ±  6%      -2.4%  3.798e+08 ±  3%  numa-vmstat.node1.numa_local
 1.106e+08 ±  4%      -1.6%  1.089e+08 ±  6%  numa-vmstat.node1.numa_miss
 1.108e+08 ±  4%      -1.6%   1.09e+08 ±  6%  numa-vmstat.node1.numa_other
    830278 ±  4%      +1.4%     842293 ±  4%  numa-vmstat.node1.workingset_activate_file
    140666 ±  4%      +4.7%     147298 ±  2%  numa-vmstat.node1.workingset_nodes
  71513095            +1.4%   72543267 ±  2%  numa-vmstat.node1.workingset_refault_file
     24329 ± 22%     -13.1%      21136 ± 26%  numa-vmstat.node1.workingset_restore_file
   1328293 ±  2%      -0.6%    1320359        proc-vmstat.allocstall_movable
      4213 ±  6%     +20.7%       5084 ± 15%  proc-vmstat.allocstall_normal
   1669423 ± 35%      -1.1%    1650354 ± 37%  proc-vmstat.compact_daemon_free_scanned
   1626775 ±  3%      -3.1%    1575643 ± 12%  proc-vmstat.compact_daemon_migrate_scanned
      6391 ±  7%      -2.0%       6262 ± 12%  proc-vmstat.compact_daemon_wake
    461.67 ±  9%     +37.7%     635.67 ± 24%  proc-vmstat.compact_fail
   1815669 ± 35%      +0.3%    1820877 ± 29%  proc-vmstat.compact_free_scanned
    126044 ± 23%     +20.0%     151299 ± 61%  proc-vmstat.compact_isolated
   1672279 ±  6%      -4.3%    1600778 ± 11%  proc-vmstat.compact_migrate_scanned
    474.00 ± 10%     +37.5%     651.67 ± 24%  proc-vmstat.compact_stall
     12.33 ± 33%     +29.7%      16.00 ± 22%  proc-vmstat.compact_success
     37.67 ± 16%     +18.6%      44.67 ± 27%  proc-vmstat.kswapd_high_wmark_hit_quickly
     16800 ±  5%     -11.2%      14910 ±  8%  proc-vmstat.kswapd_low_wmark_hit_quickly
     49267 ±  4%      -3.5%      47521 ±  2%  proc-vmstat.nr_active_anon
    479759            -0.8%     475967        proc-vmstat.nr_active_file
    111149 ±  6%      -4.9%     105740 ±  5%  proc-vmstat.nr_anon_pages
    167.00            +0.4%     167.67        proc-vmstat.nr_anon_transparent_hugepages
     85.33            -0.8%      84.67        proc-vmstat.nr_dirtied
      1.00 ± 81%    +100.0%       2.00        proc-vmstat.nr_dirty
   1018992            +0.1%    1019764        proc-vmstat.nr_dirty_background_threshold
   2040477            +0.1%    2042024        proc-vmstat.nr_dirty_threshold
  10734329            -0.0%   10732403        proc-vmstat.nr_file_pages
      4100 ± 38%     +95.2%       8004 ± 30%  proc-vmstat.nr_free_cma
    124348            +7.3%     133457 ±  6%  proc-vmstat.nr_free_pages
    394477            -1.3%     389352        proc-vmstat.nr_inactive_anon
   9669876            +0.0%    9673228        proc-vmstat.nr_inactive_file
      0.00          -100.0%       0.00        proc-vmstat.nr_isolated_anon
    310.67           +36.2%     423.00        proc-vmstat.nr_isolated_file
     15546            -0.0%      15544        proc-vmstat.nr_kernel_stack
  10419022            +0.1%   10427348        proc-vmstat.nr_mapped
    557.67 ±  7%     -10.2%     501.00        proc-vmstat.nr_mlock
    103271            +0.2%     103446        proc-vmstat.nr_page_table_pages
    332716            -0.4%     331248        proc-vmstat.nr_shmem
     95048            -0.1%      94992        proc-vmstat.nr_slab_reclaimable
     52669            -1.2%      52013        proc-vmstat.nr_slab_unreclaimable
    250566            -0.0%     250527        proc-vmstat.nr_unevictable
    122.00 ± 20%     +18.9%     145.00 ± 24%  proc-vmstat.nr_vmscan_immediate_reclaim
      0.00          -100.0%       0.00        proc-vmstat.nr_writeback
     84.00            -0.8%      83.33        proc-vmstat.nr_written
     49267 ±  4%      -3.5%      47521 ±  2%  proc-vmstat.nr_zone_active_anon
    479480            -0.8%     475707        proc-vmstat.nr_zone_active_file
    394536            -1.3%     389410        proc-vmstat.nr_zone_inactive_anon
   9669441            +0.0%    9672865        proc-vmstat.nr_zone_inactive_file
    250566            -0.0%     250527        proc-vmstat.nr_zone_unevictable
      1.33 ± 35%     +50.0%       2.00        proc-vmstat.nr_zone_write_pending
 4.262e+08 ±  3%      -3.0%  4.135e+08        proc-vmstat.numa_foreign
     72183 ± 85%     -60.9%      28253 ± 85%  proc-vmstat.numa_hint_faults
     21792 ± 71%     -58.8%       8985 ± 52%  proc-vmstat.numa_hint_faults_local
 1.469e+09 ±  2%      +0.9%  1.482e+09 ±  2%  proc-vmstat.numa_hit
      3539 ±  8%      -3.9%       3399 ±  9%  proc-vmstat.numa_huge_pte_updates
      0.00          -100.0%       0.00        proc-vmstat.numa_interleave
 1.469e+09 ±  2%      +0.9%  1.482e+09 ±  2%  proc-vmstat.numa_local
 4.262e+08 ±  3%      -3.0%  4.135e+08        proc-vmstat.numa_miss
 4.262e+08 ±  3%      -3.0%  4.135e+08        proc-vmstat.numa_other
     36078 ± 10%      -7.7%      33288 ± 38%  proc-vmstat.numa_pages_migrated
   1882435 ± 11%      -6.1%    1768086 ± 10%  proc-vmstat.numa_pte_updates
     16840 ±  5%     -11.2%      14957 ±  8%  proc-vmstat.pageoutrun
  22636558            -2.6%   22058740        proc-vmstat.pgactivate
      0.00          -100.0%       0.00        proc-vmstat.pgalloc_dma
  70612813            +1.5%   71685526        proc-vmstat.pgalloc_dma32
 1.825e+09 ±  2%      -0.0%  1.825e+09        proc-vmstat.pgalloc_normal
  25229094            -2.4%   24631967        proc-vmstat.pgdeactivate
 3.788e+09 ±  2%      +0.0%   3.79e+09        proc-vmstat.pgfault
 1.885e+09 ±  2%      +0.0%  1.886e+09        proc-vmstat.pgfree
 1.892e+09 ±  2%      +0.0%  1.893e+09        proc-vmstat.pgmajfault
     40379 ± 62%     -50.1%      20151 ± 74%  proc-vmstat.pgmigrate_fail
     95356 ± 18%     +10.5%     105340 ± 46%  proc-vmstat.pgmigrate_success
 7.569e+09 ±  2%      +0.0%  7.573e+09        proc-vmstat.pgpgin
    126.67 ± 12%     +10.5%     140.00 ±  8%  proc-vmstat.pgpgout
  25229108            -2.4%   24631987        proc-vmstat.pgrefill
    175459            +1.6%     178350        proc-vmstat.pgreuse
    810.67 ±  9%     +27.6%       1034 ±  3%  proc-vmstat.pgrotated
 3.191e+09 ±  2%      -0.4%   3.18e+09        proc-vmstat.pgscan_direct
    465.33 ±141%    +235.0%       1559 ± 78%  proc-vmstat.pgscan_direct_throttle
 3.789e+09 ±  2%      +0.0%   3.79e+09        proc-vmstat.pgscan_file
 5.976e+08            +2.1%  6.104e+08 ±  2%  proc-vmstat.pgscan_kswapd
 1.692e+09 ±  2%      -0.3%  1.686e+09        proc-vmstat.pgsteal_direct
 1.882e+09 ±  2%      +0.0%  1.883e+09        proc-vmstat.pgsteal_file
 1.907e+08 ±  3%      +3.4%  1.972e+08 ±  4%  proc-vmstat.pgsteal_kswapd
     93123 ± 22%      -1.9%      91356 ±  3%  proc-vmstat.slabs_scanned
      0.33 ±141%      +0.0%       0.33 ±141%  proc-vmstat.thp_collapse_alloc
      0.00       +6.7e+101%       0.67 ± 70%  proc-vmstat.thp_collapse_alloc_failed
     56.33            -0.6%      56.00        proc-vmstat.thp_fault_alloc
      0.00          -100.0%       0.00        proc-vmstat.thp_split_pmd
      0.00          -100.0%       0.00        proc-vmstat.thp_zero_page_alloc
     44.33 ± 90%    +127.1%     100.67        proc-vmstat.unevictable_pgs_culled
    195.33 ±141%    +200.0%     586.00        proc-vmstat.unevictable_pgs_mlocked
   1629023            -0.6%    1618875 ±  3%  proc-vmstat.workingset_activate_file
    309516            -0.4%     308267        proc-vmstat.workingset_nodes
 1.411e+08 ±  2%      -0.7%  1.401e+08        proc-vmstat.workingset_refault_file
     45110 ±  3%      +4.9%      47304 ± 13%  proc-vmstat.workingset_restore_file
    253.01 ± 75%     -54.9%     114.06 ±141%  sched_debug.cfs_rq:/.MIN_vruntime.avg
     20984 ± 71%     -54.1%       9636 ±141%  sched_debug.cfs_rq:/.MIN_vruntime.max
      0.00            +0.0%       0.00        sched_debug.cfs_rq:/.MIN_vruntime.min
      2284 ± 73%     -54.4%       1041 ±141%  sched_debug.cfs_rq:/.MIN_vruntime.stddev
    242278 ±  3%      +2.4%     247984        sched_debug.cfs_rq:/.exec_clock.avg
    368366 ±  3%      -1.6%     362604 ±  4%  sched_debug.cfs_rq:/.exec_clock.max
    115559 ± 14%     +16.3%     134365 ±  7%  sched_debug.cfs_rq:/.exec_clock.min
     53171 ±  7%      -2.1%      52044 ± 16%  sched_debug.cfs_rq:/.exec_clock.stddev
    625415            +3.5%     647073 ±  2%  sched_debug.cfs_rq:/.load.avg
   1132102 ±  6%      -6.8%    1054640 ±  5%  sched_debug.cfs_rq:/.load.max
    476250            -2.5%     464350        sched_debug.cfs_rq:/.load.stddev
    608.03            +4.0%     632.44 ±  2%  sched_debug.cfs_rq:/.load_avg.avg
      1040            -1.0%       1030        sched_debug.cfs_rq:/.load_avg.max
    467.13            -1.7%     459.29        sched_debug.cfs_rq:/.load_avg.stddev
    253.01 ± 75%     -54.9%     114.06 ±141%  sched_debug.cfs_rq:/.max_vruntime.avg
     20984 ± 71%     -54.1%       9636 ±141%  sched_debug.cfs_rq:/.max_vruntime.max
      0.00            +0.0%       0.00        sched_debug.cfs_rq:/.max_vruntime.min
      2284 ± 73%     -54.4%       1041 ±141%  sched_debug.cfs_rq:/.max_vruntime.stddev
    273397 ±  3%      +3.3%     282294        sched_debug.cfs_rq:/.min_vruntime.avg
    407737 ±  2%      -0.4%     405960 ±  3%  sched_debug.cfs_rq:/.min_vruntime.max
    148862 ± 13%     +14.1%     169924 ±  7%  sched_debug.cfs_rq:/.min_vruntime.min
     53656 ±  6%      -2.9%      52125 ± 18%  sched_debug.cfs_rq:/.min_vruntime.stddev
      0.62            +3.4%       0.64 ±  2%  sched_debug.cfs_rq:/.nr_running.avg
      1.10 ±  9%      -5.5%       1.04 ±  5%  sched_debug.cfs_rq:/.nr_running.max
      0.47            -2.0%       0.46        sched_debug.cfs_rq:/.nr_running.stddev
      0.72 ± 10%      -5.2%       0.68 ±  2%  sched_debug.cfs_rq:/.nr_spread_over.avg
      4.17 ± 25%      -3.6%       4.02 ± 20%  sched_debug.cfs_rq:/.nr_spread_over.max
      0.85 ±  7%      +4.0%       0.88 ±  7%  sched_debug.cfs_rq:/.nr_spread_over.stddev
      2.18 ± 65%     -59.9%       0.87 ±141%  sched_debug.cfs_rq:/.removed.load_avg.avg
     60.63 ±  4%     -66.9%      20.08 ±141%  sched_debug.cfs_rq:/.removed.load_avg.max
     10.58 ± 36%     -61.9%       4.03 ±141%  sched_debug.cfs_rq:/.removed.load_avg.stddev
      0.98 ± 81%     -70.4%       0.29 ±141%  sched_debug.cfs_rq:/.removed.runnable_avg.avg
     24.97 ± 26%     -62.2%       9.45 ±141%  sched_debug.cfs_rq:/.removed.runnable_avg.max
      4.49 ± 56%     -68.4%       1.42 ±141%  sched_debug.cfs_rq:/.removed.runnable_avg.stddev
      0.98 ± 81%     -70.4%       0.29 ±141%  sched_debug.cfs_rq:/.removed.util_avg.avg
     24.97 ± 26%     -62.2%       9.45 ±141%  sched_debug.cfs_rq:/.removed.util_avg.max
      4.49 ± 56%     -68.4%       1.42 ±141%  sched_debug.cfs_rq:/.removed.util_avg.stddev
    624.50            +4.1%     650.19 ±  3%  sched_debug.cfs_rq:/.runnable_avg.avg
      1069            -1.5%       1053        sched_debug.cfs_rq:/.runnable_avg.max
    471.87            -1.2%     466.09        sched_debug.cfs_rq:/.runnable_avg.stddev
     -3992          +344.1%     -17730        sched_debug.cfs_rq:/.spread0.avg
    130353 ± 38%     -18.7%     105936 ± 16%  sched_debug.cfs_rq:/.spread0.max
   -128520            +1.2%    -130100        sched_debug.cfs_rq:/.spread0.min
     53657 ±  6%      -2.9%      52125 ± 18%  sched_debug.cfs_rq:/.spread0.stddev
    623.90            +4.1%     649.45 ±  3%  sched_debug.cfs_rq:/.util_avg.avg
      1060            -2.0%       1039        sched_debug.cfs_rq:/.util_avg.max
    471.41            -1.2%     465.65        sched_debug.cfs_rq:/.util_avg.stddev
    590.96            +3.9%     614.13 ±  2%  sched_debug.cfs_rq:/.util_est_enqueued.avg
      1003            -1.1%     993.00        sched_debug.cfs_rq:/.util_est_enqueued.max
    465.44            -1.4%     458.82        sched_debug.cfs_rq:/.util_est_enqueued.stddev
    895285            -1.0%     886431        sched_debug.cpu.avg_idle.avg
   1017734 ±  2%      -1.7%    1000000        sched_debug.cpu.avg_idle.max
    208271 ±  6%     -15.3%     176436 ± 12%  sched_debug.cpu.avg_idle.min
    182123 ±  4%      +8.2%     197027 ±  2%  sched_debug.cpu.avg_idle.stddev
    673375            +1.6%     684119        sched_debug.cpu.clock.avg
    673384            +1.6%     684127        sched_debug.cpu.clock.max
    673366            +1.6%     684110        sched_debug.cpu.clock.min
      5.73 ±  2%      +1.0%       5.79 ± 12%  sched_debug.cpu.clock.stddev
    668803            +1.6%     679444        sched_debug.cpu.clock_task.avg
    669190            +1.6%     679861        sched_debug.cpu.clock_task.max
    663672            +1.6%     674259        sched_debug.cpu.clock_task.min
    621.19 ±  2%      +0.5%     624.30        sched_debug.cpu.clock_task.stddev
      1514            +0.7%       1524        sched_debug.cpu.curr->pid.avg
     14110 ±  2%      +1.3%      14296        sched_debug.cpu.curr->pid.max
      1941            +1.3%       1965        sched_debug.cpu.curr->pid.stddev
    500144            -0.0%     500037        sched_debug.cpu.max_idle_balance_cost.avg
    508648 ±  2%      -1.0%     503634        sched_debug.cpu.max_idle_balance_cost.max
    500000            +0.0%     500000        sched_debug.cpu.max_idle_balance_cost.min
    976.01 ±141%     -62.2%     369.04 ±141%  sched_debug.cpu.max_idle_balance_cost.stddev
      4295            +0.0%       4295        sched_debug.cpu.next_balance.avg
      4295            +0.0%       4295        sched_debug.cpu.next_balance.max
      4295            +0.0%       4295        sched_debug.cpu.next_balance.min
      0.00            -2.1%       0.00        sched_debug.cpu.next_balance.stddev
      0.52            -0.1%       0.51        sched_debug.cpu.nr_running.avg
      1.08 ±  6%      -3.7%       1.04 ±  5%  sched_debug.cpu.nr_running.max
      0.49            -0.6%       0.49        sched_debug.cpu.nr_running.stddev
     86248 ± 13%     +20.4%     103817        sched_debug.cpu.nr_switches.avg
   3331122 ± 55%     -17.4%    2752534 ±  7%  sched_debug.cpu.nr_switches.max
     19837 ±  8%     +12.7%      22363 ±  4%  sched_debug.cpu.nr_switches.min
    352881 ± 49%     -11.8%     311258 ±  7%  sched_debug.cpu.nr_switches.stddev
      0.00 ± 18%      -1.8%       0.00 ± 53%  sched_debug.cpu.nr_uninterruptible.avg
     32.08 ± 54%     +14.3%      36.65 ± 31%  sched_debug.cpu.nr_uninterruptible.max
    -23.37            -6.1%     -21.94        sched_debug.cpu.nr_uninterruptible.min
      7.54 ± 13%      +9.3%       8.24 ±  8%  sched_debug.cpu.nr_uninterruptible.stddev
     30104 ±  4%     +13.0%      34018        sched_debug.cpu.sched_count.avg
     47646 ±  6%     +10.3%      52570 ±  7%  sched_debug.cpu.sched_count.max
     18334 ± 10%     +14.3%      20960 ±  5%  sched_debug.cpu.sched_count.min
      5637 ±  9%      +7.1%       6040 ±  5%  sched_debug.cpu.sched_count.stddev
      4091 ±  3%      +3.4%       4230        sched_debug.cpu.sched_goidle.avg
     13055 ±  5%     +20.9%      15781 ± 21%  sched_debug.cpu.sched_goidle.max
    808.79 ± 11%      +9.2%     883.16 ± 18%  sched_debug.cpu.sched_goidle.min
      2537 ±  3%      +3.5%       2625 ±  6%  sched_debug.cpu.sched_goidle.stddev
     14674 ±  4%     +13.3%      16622        sched_debug.cpu.ttwu_count.avg
     23541 ±  2%     +12.0%      26364 ±  3%  sched_debug.cpu.ttwu_count.max
      8114 ± 18%     +17.7%       9553 ± 10%  sched_debug.cpu.ttwu_count.min
      2790 ±  6%     +12.0%       3123 ±  6%  sched_debug.cpu.ttwu_count.stddev
     12278 ±  4%     +14.1%      14014        sched_debug.cpu.ttwu_local.avg
     18609 ±  3%      +9.2%      20312 ±  3%  sched_debug.cpu.ttwu_local.max
      6654 ± 17%     +20.2%       7997 ± 11%  sched_debug.cpu.ttwu_local.min
      2353 ± 10%      +8.0%       2540 ± 10%  sched_debug.cpu.ttwu_local.stddev
    673366            +1.6%     684110        sched_debug.cpu_clk
    996147            +0.0%     996147        sched_debug.dl_rq:.dl_bw->bw.avg
    996147            +0.0%     996147        sched_debug.dl_rq:.dl_bw->bw.max
    996147            +0.0%     996147        sched_debug.dl_rq:.dl_bw->bw.min
 4.295e+09            +0.0%  4.295e+09        sched_debug.jiffies
    672869            +1.6%     683612        sched_debug.ktime
    950.00            +0.0%     950.00        sched_debug.rt_rq:/.rt_runtime.avg
    950.00            +0.0%     950.00        sched_debug.rt_rq:/.rt_runtime.max
    950.00            +0.0%     950.00        sched_debug.rt_rq:/.rt_runtime.min
      0.00 ±141%    -100.0%       0.00        sched_debug.rt_rq:/.rt_time.avg
      0.02 ±141%    -100.0%       0.00        sched_debug.rt_rq:/.rt_time.max
      0.00 ±141%    -100.0%       0.00        sched_debug.rt_rq:/.rt_time.stddev
    673721            +1.6%     684462        sched_debug.sched_clk
      1.00            +0.0%       1.00        sched_debug.sched_clock_stable()
   4156219            +0.0%    4156219        sched_debug.sysctl_sched.sysctl_sched_features
     24.00            +0.0%      24.00        sched_debug.sysctl_sched.sysctl_sched_latency
      3.00            +0.0%       3.00        sched_debug.sysctl_sched.sysctl_sched_min_granularity
      1.00            +0.0%       1.00        sched_debug.sysctl_sched.sysctl_sched_tunable_scaling
      4.00            +0.0%       4.00        sched_debug.sysctl_sched.sysctl_sched_wakeup_granularity
      3.33 ±141%    -100.0%       0.00        latency_stats.avg.d_alloc_parallel.__lookup_slow.walk_component.path_lookupat.filename_lookup.vfs_statx.__do_sys_newstat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      7907 ±141%    -100.0%       0.00        latency_stats.avg.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.pipe_write.new_sync_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
      7945 ±141%    -100.0%       0.00        latency_stats.avg.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.alloc_pages_vma.shmem_alloc_page.shmem_alloc_and_acct_page.shmem_getpage_gfp.shmem_write_begin.generic_perform_write.__generic_file_write_iter.generic_file_write_iter
      8920 ±141%    -100.0%       0.00        latency_stats.avg.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.pte_alloc_one.__pte_alloc.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     90488 ±130%     -99.8%     195.33 ± 21%  latency_stats.avg.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_access.nfs_do_access.nfs_permission.inode_permission.link_path_walk.path_lookupat.filename_lookup
     17610 ±141%     -99.7%      54.00 ±141%  latency_stats.avg.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_getattr.__nfs_revalidate_inode.nfs_access_get_cached.nfs_do_access.nfs_permission.inode_permission.link_path_walk
     35313 ±141%     -97.2%       1005 ± 92%  latency_stats.avg.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_do_create.nfs3_proc_create.nfs_create.path_openat.do_filp_open.do_sys_openat2.do_sys_open
     71783 ±141%     -94.2%       4174 ±141%  latency_stats.avg.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_access.nfs_do_access.nfs_permission.inode_permission.link_path_walk.path_openat.do_filp_open
     38383 ±141%     -72.2%      10663 ±141%  latency_stats.avg.rwsem_down_write_slowpath.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
   4654660 ± 38%     -64.5%    1653160 ± 72%  latency_stats.avg.nfs_page_group_lock_head.nfs_lock_and_join_requests.nfs_writepage_setup.nfs_updatepage.nfs_write_end.generic_perform_write.nfs_file_write.new_sync_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
   4654660 ± 38%     -64.1%    1672659 ± 70%  latency_stats.avg.max
      5634 ±141%     -42.5%       3240 ±141%  latency_stats.avg.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.alloc_pages_vma.wp_page_copy.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      2612 ± 18%     -31.2%       1798 ± 71%  latency_stats.avg.devkmsg_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
     25.00 ± 52%     -24.0%      19.00 ± 87%  latency_stats.avg.rwsem_down_write_slowpath.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
    521.00 ± 29%     -23.3%     399.67 ± 73%  latency_stats.avg.hrtimer_nanosleep.__x64_sys_nanosleep.do_syscall_64.entry_SYSCALL_64_after_hwframe
    787.33 ±  5%     -20.2%     628.00 ±  8%  latency_stats.avg.ep_poll.do_epoll_wait.__x64_sys_epoll_wait.do_syscall_64.entry_SYSCALL_64_after_hwframe
     13069 ±  9%     -20.1%      10442 ± 23%  latency_stats.avg.lru_add_drain_all.generic_fadvise.ksys_fadvise64_64.__x64_sys_fadvise64.do_syscall_64.entry_SYSCALL_64_after_hwframe
      7.67 ±141%     -17.4%       6.33 ±141%  latency_stats.avg.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      2824 ±  5%     -13.8%       2433 ± 16%  latency_stats.avg.do_syslog.kmsg_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
    933.00 ± 11%     -12.9%     812.33 ±  5%  latency_stats.avg.poll_schedule_timeout.do_sys_poll.__x64_sys_poll.do_syscall_64.entry_SYSCALL_64_after_hwframe
     14.00 ± 15%     -11.9%      12.33 ± 19%  latency_stats.avg.stop_one_cpu.__set_cpus_allowed_ptr.sched_setaffinity.__x64_sys_sched_setaffinity.do_syscall_64.entry_SYSCALL_64_after_hwframe
     22076 ±141%     -10.5%      19758 ±138%  latency_stats.avg.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_lookup.nfs_lookup.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64
      2199 ± 13%      -6.5%       2056 ± 12%  latency_stats.avg.poll_schedule_timeout.do_select.core_sys_select.kern_select.__x64_sys_select.do_syscall_64.entry_SYSCALL_64_after_hwframe
    530.33 ± 16%      -2.8%     515.67 ±  5%  latency_stats.avg.futex_wait_queue_me.futex_wait.do_futex.__x64_sys_futex.do_syscall_64.entry_SYSCALL_64_after_hwframe
    214.67 ±  9%      -2.3%     209.67 ± 16%  latency_stats.avg.wait_woken.__inet_stream_connect.inet_stream_connect.__sys_connect.__x64_sys_connect.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1436 ±  6%      -0.6%       1427        latency_stats.avg.pipe_wait.wait_for_partner.fifo_open.do_dentry_open.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
    121.67            +3.6%     126.00        latency_stats.avg.pipe_read.new_sync_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1343            +3.7%       1392        latency_stats.avg.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
     11385            +3.8%      11822 ±  4%  latency_stats.avg.msleep.cpuinfo_open.do_dentry_open.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
     22915 ±138%      +9.4%      25073 ±135%  latency_stats.avg.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_lookup.nfs_lookup_revalidate_dentry.nfs_do_lookup_revalidate.__nfs_lookup_revalidate.lookup_fast.walk_component.link_path_walk
     29.67 ± 16%     +16.9%      34.67 ± 13%  latency_stats.avg.smp_call_on_cpu.lockup_detector_reconfigure.proc_watchdog_common.proc_sys_call_handler.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.33 ± 70%     +25.0%       1.67 ± 74%  latency_stats.avg.d_alloc_parallel.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
      7194 ± 30%     +26.8%       9119 ±  4%  latency_stats.avg.pipe_write.new_sync_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
     53.33 ± 89%     +28.1%      68.33 ± 65%  latency_stats.avg.down.xfs_buf_lock.[xfs].xfs_buf_find.[xfs].xfs_buf_get_map.[xfs].xfs_buf_read_map.[xfs].xfs_trans_read_buf_map.[xfs].xfs_imap_to_bp.[xfs].xfs_trans_log_inode.[xfs].xfs_vn_update_time.[xfs].touch_atime.xfs_file_mmap.[xfs].mmap_region
    132.00 ±141%     +44.9%     191.33 ±141%  latency_stats.avg.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_get_acl.get_acl.posix_acl_create.nfs3_proc_create.nfs_create.path_openat.do_filp_open.do_sys_openat2
      5.67 ± 79%     +52.9%       8.67 ± 92%  latency_stats.avg.d_alloc_parallel.__lookup_slow.walk_component.link_path_walk.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
     29.67 ±141%     +88.8%      56.00 ± 23%  latency_stats.avg.poll_schedule_timeout.do_sys_poll.__x64_sys_ppoll.do_syscall_64.entry_SYSCALL_64_after_hwframe
     23.00 ± 71%    +105.8%      47.33 ± 73%  latency_stats.avg.do_madvise.__x64_sys_madvise.do_syscall_64.entry_SYSCALL_64_after_hwframe
    369.00 ±141%    +194.1%       1085 ±  2%  latency_stats.avg.tty_wait_until_sent.tty_port_close_start.tty_port_close.tty_release.__fput.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
      7682 ±141%    +206.6%      23550 ±  4%  latency_stats.avg.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.pagecache_get_page.filemap_fault.__xfs_filemap_fault.[xfs].__do_fault.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      4758 ±141%    +230.3%      15719 ± 67%  latency_stats.avg.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.__vmalloc_node_range.copy_process._do_fork.__do_sys_clone.do_syscall_64.entry_SYSCALL_64_after_hwframe
    972.33 ±141%    +234.5%       3252        latency_stats.avg.msleep_interruptible.uart_wait_until_sent.tty_wait_until_sent.tty_port_close_start.tty_port_close.tty_release.__fput.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
     13.33 ± 86%    +297.5%      53.00 ± 83%  latency_stats.avg.do_exit.__x64_sys_exit.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.33 ±141%    +300.0%       1.33 ± 70%  latency_stats.avg.d_alloc_parallel.__lookup_slow.walk_component.path_lookupat.filename_lookup.do_faccessat.do_syscall_64.entry_SYSCALL_64_after_hwframe
    358.33 ±  9%    +376.1%       1706 ± 58%  latency_stats.avg.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_lookup.nfs_lookup.__lookup_slow.walk_component.path_lookupat.filename_lookup.vfs_statx
      0.00       +6.8e+105%       6768 ±141%  latency_stats.avg.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.kmalloc_large_node.__kmalloc_node.kvmalloc_node.single_open_size.do_dentry_open.path_openat.do_filp_open.do_sys_openat2
      0.00       +9.8e+105%       9826 ± 78%  latency_stats.avg.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.alloc_pages_vma.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.33 ±141%    -100.0%       0.00        latency_stats.hits.d_alloc_parallel.__lookup_slow.walk_component.path_lookupat.filename_lookup.vfs_statx.__do_sys_newstat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.33 ±141%    -100.0%       0.00        latency_stats.hits.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.pipe_write.new_sync_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.33 ±141%    -100.0%       0.00        latency_stats.hits.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.alloc_pages_vma.shmem_alloc_page.shmem_alloc_and_acct_page.shmem_getpage_gfp.shmem_write_begin.generic_perform_write.__generic_file_write_iter.generic_file_write_iter
      0.33 ±141%    -100.0%       0.00        latency_stats.hits.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.pte_alloc_one.__pte_alloc.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      6.00 ± 81%     -55.6%       2.67 ± 17%  latency_stats.hits.do_madvise.__x64_sys_madvise.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5.00 ±141%     -46.7%       2.67 ±141%  latency_stats.hits.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_getattr.__nfs_revalidate_inode.nfs_access_get_cached.nfs_do_access.nfs_permission.inode_permission.link_path_walk
      6.33 ± 91%     -36.8%       4.00 ± 88%  latency_stats.hits.do_exit.__x64_sys_exit.do_syscall_64.entry_SYSCALL_64_after_hwframe
      9.00           -29.6%       6.33 ± 59%  latency_stats.hits.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_access.nfs_do_access.nfs_permission.inode_permission.link_path_walk.path_lookupat.filename_lookup
      4.67 ± 70%     -28.6%       3.33 ± 78%  latency_stats.hits.rwsem_down_write_slowpath.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
     19.00 ±  4%     -22.8%      14.67 ± 47%  latency_stats.hits.do_syslog.kmsg_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
     13.00 ±  6%     -15.4%      11.00 ± 12%  latency_stats.hits.stop_one_cpu.__set_cpus_allowed_ptr.sched_setaffinity.__x64_sys_sched_setaffinity.do_syscall_64.entry_SYSCALL_64_after_hwframe
     24.67 ± 13%     -14.9%      21.00 ± 10%  latency_stats.hits.pipe_write.new_sync_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
     13.67 ± 40%      -7.3%      12.67 ± 75%  latency_stats.hits.devkmsg_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
     11.33 ±  4%      -2.9%      11.00 ±  7%  latency_stats.hits.hrtimer_nanosleep.__x64_sys_nanosleep.do_syscall_64.entry_SYSCALL_64_after_hwframe
     15135            -1.8%      14857        latency_stats.hits.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
    190.00            -0.5%     189.00        latency_stats.hits.smp_call_on_cpu.lockup_detector_reconfigure.proc_watchdog_common.proc_sys_call_handler.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
    243925            -0.0%     243902        latency_stats.hits.pipe_read.new_sync_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
    243925            -0.0%     243902        latency_stats.hits.max
      1.00            +0.0%       1.00        latency_stats.hits.msleep.cpuinfo_open.do_dentry_open.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.00            +0.0%       1.00        latency_stats.hits.pipe_wait.wait_for_partner.fifo_open.do_dentry_open.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.33 ± 40%      +0.0%       2.33 ± 40%  latency_stats.hits.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_lookup.nfs_lookup_revalidate_dentry.nfs_do_lookup_revalidate.__nfs_lookup_revalidate.lookup_fast.walk_component.link_path_walk
      0.33 ±141%      +0.0%       0.33 ±141%  latency_stats.hits.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_get_acl.get_acl.posix_acl_create.nfs3_proc_create.nfs_create.path_openat.do_filp_open.do_sys_openat2
      0.33 ±141%      +0.0%       0.33 ±141%  latency_stats.hits.rwsem_down_write_slowpath.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.00            +0.0%       1.00        latency_stats.hits.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_lookup.nfs_lookup.__lookup_slow.walk_component.path_lookupat.filename_lookup.vfs_statx
      1.00            +0.0%       1.00        latency_stats.hits.wait_woken.__inet_stream_connect.inet_stream_connect.__sys_connect.__x64_sys_connect.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.33 ±141%      +0.0%       0.33 ±141%  latency_stats.hits.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     50.33 ±  2%      +0.7%      50.67 ±  3%  latency_stats.hits.lru_add_drain_all.generic_fadvise.ksys_fadvise64_64.__x64_sys_fadvise64.do_syscall_64.entry_SYSCALL_64_after_hwframe
    350.00 ± 12%      +4.2%     364.67 ± 11%  latency_stats.hits.futex_wait_queue_me.futex_wait.do_futex.__x64_sys_futex.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.00 ± 27%     +11.1%       3.33 ±101%  latency_stats.hits.nfs_page_group_lock_head.nfs_lock_and_join_requests.nfs_writepage_setup.nfs_updatepage.nfs_write_end.generic_perform_write.nfs_file_write.new_sync_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
     21.00 ± 43%     +14.3%      24.00 ± 12%  latency_stats.hits.down.xfs_buf_lock.[xfs].xfs_buf_find.[xfs].xfs_buf_get_map.[xfs].xfs_buf_read_map.[xfs].xfs_trans_read_buf_map.[xfs].xfs_imap_to_bp.[xfs].xfs_trans_log_inode.[xfs].xfs_vn_update_time.[xfs].touch_atime.xfs_file_mmap.[xfs].mmap_region
    207.67 ± 15%     +17.5%     244.00 ± 11%  latency_stats.hits.ep_poll.do_epoll_wait.__x64_sys_epoll_wait.do_syscall_64.entry_SYSCALL_64_after_hwframe
     37.00 ± 11%     +18.9%      44.00 ±  3%  latency_stats.hits.poll_schedule_timeout.do_sys_poll.__x64_sys_poll.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.33 ± 88%     +28.6%       3.00 ± 47%  latency_stats.hits.d_alloc_parallel.__lookup_slow.walk_component.link_path_walk.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
    129.00 ± 16%     +48.1%     191.00 ± 11%  latency_stats.hits.poll_schedule_timeout.do_select.core_sys_select.kern_select.__x64_sys_select.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.67 ±141%     +50.0%       1.00 ± 81%  latency_stats.hits.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_lookup.nfs_lookup.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64
      0.67 ±141%     +50.0%       1.00 ± 81%  latency_stats.hits.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_do_create.nfs3_proc_create.nfs_create.path_openat.do_filp_open.do_sys_openat2.do_sys_open
      0.67 ± 70%     +50.0%       1.00 ± 81%  latency_stats.hits.d_alloc_parallel.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.67 ±141%     +50.0%       1.00 ± 81%  latency_stats.hits.d_alloc_parallel.__lookup_slow.walk_component.path_lookupat.filename_lookup.do_faccessat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.00 ±141%    +200.0%       9.00        latency_stats.hits.msleep_interruptible.uart_wait_until_sent.tty_wait_until_sent.tty_port_close_start.tty_port_close.tty_release.__fput.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
      0.33 ±141%    +200.0%       1.00        latency_stats.hits.poll_schedule_timeout.do_sys_poll.__x64_sys_ppoll.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.33 ±141%    +200.0%       1.00        latency_stats.hits.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.__vmalloc_node_range.copy_process._do_fork.__do_sys_clone.do_syscall_64.entry_SYSCALL_64_after_hwframe
     13.00 ±141%    +212.8%      40.67        latency_stats.hits.tty_wait_until_sent.tty_port_close_start.tty_port_close.tty_release.__fput.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
    463.67 ±141%    +235.5%       1555 ± 78%  latency_stats.hits.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.pagecache_get_page.filemap_fault.__xfs_filemap_fault.[xfs].__do_fault.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      0.33 ±141%    +300.0%       1.33 ±141%  latency_stats.hits.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.alloc_pages_vma.wp_page_copy.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.67 ±141%    +800.0%       6.00 ±141%  latency_stats.hits.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_access.nfs_do_access.nfs_permission.inode_permission.link_path_walk.path_openat.do_filp_open
      0.00       +3.3e+101%       0.33 ±141%  latency_stats.hits.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.kmalloc_large_node.__kmalloc_node.kvmalloc_node.single_open_size.do_dentry_open.path_openat.do_filp_open.do_sys_openat2
      0.00       +6.7e+101%       0.67 ± 70%  latency_stats.hits.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.alloc_pages_vma.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      3.33 ±141%    -100.0%       0.00        latency_stats.max.d_alloc_parallel.__lookup_slow.walk_component.path_lookupat.filename_lookup.vfs_statx.__do_sys_newstat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      7907 ±141%    -100.0%       0.00        latency_stats.max.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.pipe_write.new_sync_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
      7945 ±141%    -100.0%       0.00        latency_stats.max.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.alloc_pages_vma.shmem_alloc_page.shmem_alloc_and_acct_page.shmem_getpage_gfp.shmem_write_begin.generic_perform_write.__generic_file_write_iter.generic_file_write_iter
      8920 ±141%    -100.0%       0.00        latency_stats.max.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.pte_alloc_one.__pte_alloc.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
    801537 ±130%    -100.0%     254.00 ± 33%  latency_stats.max.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_access.nfs_do_access.nfs_permission.inode_permission.link_path_walk.path_lookupat.filename_lookup
    128916 ±141%     -99.9%      68.67 ±141%  latency_stats.max.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_getattr.__nfs_revalidate_inode.nfs_access_get_cached.nfs_do_access.nfs_permission.inode_permission.link_path_walk
     63639 ±141%     -98.1%       1185 ± 98%  latency_stats.max.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_do_create.nfs3_proc_create.nfs_create.path_openat.do_filp_open.do_sys_openat2.do_sys_open
    936.00 ±132%     -73.4%     248.67 ± 71%  latency_stats.max.down.xfs_buf_lock.[xfs].xfs_buf_find.[xfs].xfs_buf_get_map.[xfs].xfs_buf_read_map.[xfs].xfs_trans_read_buf_map.[xfs].xfs_imap_to_bp.[xfs].xfs_trans_log_inode.[xfs].xfs_vn_update_time.[xfs].touch_atime.xfs_file_mmap.[xfs].mmap_region
     38383 ±141%     -72.2%      10663 ±141%  latency_stats.max.rwsem_down_write_slowpath.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
     78559 ±141%     -62.5%      29458 ±141%  latency_stats.max.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_access.nfs_do_access.nfs_permission.inode_permission.link_path_walk.path_openat.do_filp_open
  12025318 ± 39%     -58.9%    4943858 ± 88%  latency_stats.max.nfs_page_group_lock_head.nfs_lock_and_join_requests.nfs_writepage_setup.nfs_updatepage.nfs_write_end.generic_perform_write.nfs_file_write.new_sync_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
  12025318 ± 39%     -58.6%    4982801 ± 87%  latency_stats.max.max
    182392 ±126%     -52.7%      86214 ±113%  latency_stats.max.lru_add_drain_all.generic_fadvise.ksys_fadvise64_64.__x64_sys_fadvise64.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4137 ±  5%     -32.7%       2785 ± 70%  latency_stats.max.hrtimer_nanosleep.__x64_sys_nanosleep.do_syscall_64.entry_SYSCALL_64_after_hwframe
     52.67 ± 61%     -27.2%      38.33 ±110%  latency_stats.max.rwsem_down_write_slowpath.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5634 ±141%     -19.4%       4539 ±141%  latency_stats.max.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.alloc_pages_vma.wp_page_copy.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      7.67 ±141%     -17.4%       6.33 ±141%  latency_stats.max.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     19470 ± 49%     -16.5%      16248 ± 23%  latency_stats.max.pipe_read.new_sync_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3914 ± 33%     -15.5%       3308 ± 70%  latency_stats.max.devkmsg_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3090 ± 32%     -10.3%       2772 ±  7%  latency_stats.max.futex_wait_queue_me.futex_wait.do_futex.__x64_sys_futex.do_syscall_64.entry_SYSCALL_64_after_hwframe
     21624 ± 40%      -7.5%      19998 ± 21%  latency_stats.max.pipe_write.new_sync_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4888            -5.6%       4616 ± 10%  latency_stats.max.do_syslog.kmsg_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
    214.67 ±  9%      -2.3%     209.67 ± 16%  latency_stats.max.wait_woken.__inet_stream_connect.inet_stream_connect.__sys_connect.__x64_sys_connect.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1436 ±  6%      -0.6%       1427        latency_stats.max.pipe_wait.wait_for_partner.fifo_open.do_dentry_open.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4931            +0.0%       4932        latency_stats.max.poll_schedule_timeout.do_select.core_sys_select.kern_select.__x64_sys_select.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4906            +0.0%       4907        latency_stats.max.ep_poll.do_epoll_wait.__x64_sys_epoll_wait.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4996            +0.0%       4998        latency_stats.max.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
     37884 ±141%      +3.5%      39202 ±140%  latency_stats.max.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_lookup.nfs_lookup.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64
     11385            +3.8%      11822 ±  4%  latency_stats.max.msleep.cpuinfo_open.do_dentry_open.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
     27.00 ± 13%     +11.1%      30.00 ± 28%  latency_stats.max.stop_one_cpu.__set_cpus_allowed_ptr.sched_setaffinity.__x64_sys_sched_setaffinity.do_syscall_64.entry_SYSCALL_64_after_hwframe
     66723 ±140%     +12.1%      74765 ±136%  latency_stats.max.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_lookup.nfs_lookup_revalidate_dentry.nfs_do_lookup_revalidate.__nfs_lookup_revalidate.lookup_fast.walk_component.link_path_walk
     95.67 ±  6%     +14.6%     109.67 ± 15%  latency_stats.max.smp_call_on_cpu.lockup_detector_reconfigure.proc_watchdog_common.proc_sys_call_handler.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
     13.33 ± 70%     +20.0%      16.00 ± 97%  latency_stats.max.d_alloc_parallel.__lookup_slow.walk_component.link_path_walk.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3147 ± 15%     +32.9%       4183 ± 20%  latency_stats.max.poll_schedule_timeout.do_sys_poll.__x64_sys_poll.do_syscall_64.entry_SYSCALL_64_after_hwframe
     49.33 ± 74%     +39.9%      69.00 ± 63%  latency_stats.max.do_madvise.__x64_sys_madvise.do_syscall_64.entry_SYSCALL_64_after_hwframe
    132.00 ±141%     +44.9%     191.33 ±141%  latency_stats.max.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_get_acl.get_acl.posix_acl_create.nfs3_proc_create.nfs_create.path_openat.do_filp_open.do_sys_openat2
      1.33 ± 70%     +50.0%       2.00 ± 70%  latency_stats.max.d_alloc_parallel.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
     29.67 ±141%     +88.8%      56.00 ± 23%  latency_stats.max.poll_schedule_timeout.do_sys_poll.__x64_sys_ppoll.do_syscall_64.entry_SYSCALL_64_after_hwframe
     28.00 ± 86%    +144.0%      68.33 ± 63%  latency_stats.max.do_exit.__x64_sys_exit.do_syscall_64.entry_SYSCALL_64_after_hwframe
    450.67 ±141%    +218.5%       1435 ±  7%  latency_stats.max.tty_wait_until_sent.tty_port_close_start.tty_port_close.tty_release.__fput.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
      1172 ±141%    +226.7%       3828        latency_stats.max.msleep_interruptible.uart_wait_until_sent.tty_wait_until_sent.tty_port_close_start.tty_port_close.tty_release.__fput.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
      4758 ±141%    +230.3%      15719 ± 67%  latency_stats.max.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.__vmalloc_node_range.copy_process._do_fork.__do_sys_clone.do_syscall_64.entry_SYSCALL_64_after_hwframe
     26079 ±141%    +264.8%      95136 ± 12%  latency_stats.max.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.pagecache_get_page.filemap_fault.__xfs_filemap_fault.[xfs].__do_fault.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      0.33 ±141%    +300.0%       1.33 ± 70%  latency_stats.max.d_alloc_parallel.__lookup_slow.walk_component.path_lookupat.filename_lookup.do_faccessat.do_syscall_64.entry_SYSCALL_64_after_hwframe
    358.33 ±  9%    +376.1%       1706 ± 58%  latency_stats.max.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_lookup.nfs_lookup.__lookup_slow.walk_component.path_lookupat.filename_lookup.vfs_statx
      0.00       +6.8e+105%       6768 ±141%  latency_stats.max.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.kmalloc_large_node.__kmalloc_node.kvmalloc_node.single_open_size.do_dentry_open.path_openat.do_filp_open.do_sys_openat2
      0.00       +9.8e+105%       9826 ± 78%  latency_stats.max.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.alloc_pages_vma.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      3.33 ±141%    -100.0%       0.00        latency_stats.sum.d_alloc_parallel.__lookup_slow.walk_component.path_lookupat.filename_lookup.vfs_statx.__do_sys_newstat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      7907 ±141%    -100.0%       0.00        latency_stats.sum.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.pipe_write.new_sync_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
      7945 ±141%    -100.0%       0.00        latency_stats.sum.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.alloc_pages_vma.shmem_alloc_page.shmem_alloc_and_acct_page.shmem_getpage_gfp.shmem_write_begin.generic_perform_write.__generic_file_write_iter.generic_file_write_iter
      8920 ±141%    -100.0%       0.00        latency_stats.sum.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.pte_alloc_one.__pte_alloc.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
    264160 ±141%     -99.8%     432.00 ±141%  latency_stats.sum.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_getattr.__nfs_revalidate_inode.nfs_access_get_cached.nfs_do_access.nfs_permission.inode_permission.link_path_walk
    814401 ±130%     -99.8%       1337 ± 65%  latency_stats.sum.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_access.nfs_do_access.nfs_permission.inode_permission.link_path_walk.path_lookupat.filename_lookup
     70627 ±141%     -97.5%       1753 ±111%  latency_stats.sum.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_do_create.nfs3_proc_create.nfs_create.path_openat.do_filp_open.do_sys_openat2.do_sys_open
     38383 ±141%     -72.2%      10663 ±141%  latency_stats.sum.rwsem_down_write_slowpath.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
    143566 ±141%     -47.7%      75146 ±141%  latency_stats.sum.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_access.nfs_do_access.nfs_permission.inode_permission.link_path_walk.path_openat.do_filp_open
    203.33 ± 76%     -45.2%     111.33 ± 56%  latency_stats.sum.do_madvise.__x64_sys_madvise.do_syscall_64.entry_SYSCALL_64_after_hwframe
  13879600 ± 50%     -35.7%    8927955 ±109%  latency_stats.sum.nfs_page_group_lock_head.nfs_lock_and_join_requests.nfs_writepage_setup.nfs_updatepage.nfs_write_end.generic_perform_write.nfs_file_write.new_sync_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
     53734 ±  8%     -28.3%      38529 ± 58%  latency_stats.sum.do_syslog.kmsg_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
    185.33 ±  7%     -25.0%     139.00 ±  7%  latency_stats.sum.stop_one_cpu.__set_cpus_allowed_ptr.sched_setaffinity.__x64_sys_sched_setaffinity.do_syscall_64.entry_SYSCALL_64_after_hwframe
    139.33 ± 71%     -24.2%     105.67 ±129%  latency_stats.sum.rwsem_down_write_slowpath.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5981 ± 34%     -22.4%       4642 ± 77%  latency_stats.sum.hrtimer_nanosleep.__x64_sys_nanosleep.do_syscall_64.entry_SYSCALL_64_after_hwframe
    658731 ± 11%     -19.7%     528730 ± 22%  latency_stats.sum.lru_add_drain_all.generic_fadvise.ksys_fadvise64_64.__x64_sys_fadvise64.do_syscall_64.entry_SYSCALL_64_after_hwframe
      7.67 ±141%     -17.4%       6.33 ±141%  latency_stats.sum.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     44153 ±141%     -11.1%      39258 ±140%  latency_stats.sum.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_lookup.nfs_lookup.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64
     38313 ± 50%      -9.6%      34632 ± 78%  latency_stats.sum.devkmsg_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
    162215 ± 10%      -5.1%     153883 ± 15%  latency_stats.sum.ep_poll.do_epoll_wait.__x64_sys_epoll_wait.do_syscall_64.entry_SYSCALL_64_after_hwframe
    214.67 ±  9%      -2.3%     209.67 ± 16%  latency_stats.sum.wait_woken.__inet_stream_connect.inet_stream_connect.__sys_connect.__x64_sys_connect.do_syscall_64.entry_SYSCALL_64_after_hwframe
    155.00 ±114%      -1.7%     152.33 ± 84%  latency_stats.sum.do_exit.__x64_sys_exit.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1436 ±  6%      -0.6%       1427        latency_stats.sum.pipe_wait.wait_for_partner.fifo_open.do_dentry_open.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
  20330143            +1.8%   20697132        latency_stats.sum.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
    182276 ±  8%      +3.1%     187891 ± 11%  latency_stats.sum.futex_wait_queue_me.futex_wait.do_futex.__x64_sys_futex.do_syscall_64.entry_SYSCALL_64_after_hwframe
  29819764            +3.5%   30859144        latency_stats.sum.pipe_read.new_sync_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
     11385            +3.8%      11822 ±  4%  latency_stats.sum.msleep.cpuinfo_open.do_dentry_open.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
     34104            +5.1%      35828 ±  8%  latency_stats.sum.poll_schedule_timeout.do_sys_poll.__x64_sys_poll.do_syscall_64.entry_SYSCALL_64_after_hwframe
    178788 ± 35%      +6.6%     190624 ±  5%  latency_stats.sum.pipe_write.new_sync_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
     68511 ±139%      +9.6%      75106 ±135%  latency_stats.sum.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_lookup.nfs_lookup_revalidate_dentry.nfs_do_lookup_revalidate.__nfs_lookup_revalidate.lookup_fast.walk_component.link_path_walk
      5768 ± 16%     +14.9%       6629 ± 14%  latency_stats.sum.smp_call_on_cpu.lockup_detector_reconfigure.proc_watchdog_common.proc_sys_call_handler.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1503 ±105%     +17.5%       1766 ± 75%  latency_stats.sum.down.xfs_buf_lock.[xfs].xfs_buf_find.[xfs].xfs_buf_get_map.[xfs].xfs_buf_read_map.[xfs].xfs_trans_read_buf_map.[xfs].xfs_imap_to_bp.[xfs].xfs_trans_log_inode.[xfs].xfs_vn_update_time.[xfs].touch_atime.xfs_file_mmap.[xfs].mmap_region
     18.00 ± 73%     +24.1%      22.33 ± 63%  latency_stats.sum.d_alloc_parallel.__lookup_slow.walk_component.link_path_walk.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
    288652 ± 29%     +34.4%     387900 ±  4%  latency_stats.sum.poll_schedule_timeout.do_select.core_sys_select.kern_select.__x64_sys_select.do_syscall_64.entry_SYSCALL_64_after_hwframe
  30436080 ±  3%     +44.7%   44032242 ± 42%  latency_stats.sum.max
    132.00 ±141%     +44.9%     191.33 ±141%  latency_stats.sum.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_get_acl.get_acl.posix_acl_create.nfs3_proc_create.nfs_create.path_openat.do_filp_open.do_sys_openat2
     29.67 ±141%     +88.8%      56.00 ± 23%  latency_stats.sum.poll_schedule_timeout.do_sys_poll.__x64_sys_ppoll.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.33 ± 70%    +100.0%       2.67 ± 77%  latency_stats.sum.d_alloc_parallel.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5634 ±141%    +130.0%      12960 ±141%  latency_stats.sum.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.alloc_pages_vma.wp_page_copy.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.67 ±141%    +200.0%       2.00 ± 81%  latency_stats.sum.d_alloc_parallel.__lookup_slow.walk_component.path_lookupat.filename_lookup.do_faccessat.do_syscall_64.entry_SYSCALL_64_after_hwframe
     14397 ±141%    +206.6%      44146 ±  2%  latency_stats.sum.tty_wait_until_sent.tty_port_close_start.tty_port_close.tty_release.__fput.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
      4758 ±141%    +230.3%      15719 ± 67%  latency_stats.sum.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.__vmalloc_node_range.copy_process._do_fork.__do_sys_clone.do_syscall_64.entry_SYSCALL_64_after_hwframe
  10686074 ±141%    +231.5%   35428527 ± 75%  latency_stats.sum.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.pagecache_get_page.filemap_fault.__xfs_filemap_fault.[xfs].__do_fault.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      8751 ±141%    +234.6%      29280        latency_stats.sum.msleep_interruptible.uart_wait_until_sent.tty_wait_until_sent.tty_port_close_start.tty_port_close.tty_release.__fput.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user_mode.entry_SYSCALL_64_after_hwframe
    358.33 ±  9%    +376.1%       1706 ± 58%  latency_stats.sum.rpc_wait_bit_killable.__rpc_execute.rpc_run_task.rpc_call_sync.nfs3_rpc_wrapper.nfs3_proc_lookup.nfs_lookup.__lookup_slow.walk_component.path_lookupat.filename_lookup.vfs_statx
      0.00       +6.8e+105%       6768 ±141%  latency_stats.sum.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.kmalloc_large_node.__kmalloc_node.kvmalloc_node.single_open_size.do_dentry_open.path_openat.do_filp_open.do_sys_openat2
      0.00       +9.8e+105%       9826 ± 78%  latency_stats.sum.throttle_direct_reclaim.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.alloc_pages_vma.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
    194431            -0.1%     194170        slabinfo.Acpi-Operand.active_objs
      3471            -0.1%       3467        slabinfo.Acpi-Operand.active_slabs
    194431            -0.1%     194170        slabinfo.Acpi-Operand.num_objs
      3471            -0.1%       3467        slabinfo.Acpi-Operand.num_slabs
      1533 ± 14%     -12.7%       1338 ±  5%  slabinfo.Acpi-Parse.active_objs
     21.00 ± 14%     -12.7%      18.33 ±  5%  slabinfo.Acpi-Parse.active_slabs
      1533 ± 14%     -12.7%       1338 ±  5%  slabinfo.Acpi-Parse.num_objs
     21.00 ± 14%     -12.7%      18.33 ±  5%  slabinfo.Acpi-Parse.num_slabs
      4992            -0.1%       4986        slabinfo.Acpi-State.active_objs
     97.00            +0.0%      97.00        slabinfo.Acpi-State.active_slabs
      4992            -0.1%       4986        slabinfo.Acpi-State.num_objs
     97.00            +0.0%      97.00        slabinfo.Acpi-State.num_slabs
      2326 ±  2%      -9.9%       2097 ±  7%  slabinfo.PING.active_objs
     72.33 ±  3%      -9.2%      65.67 ±  7%  slabinfo.PING.active_slabs
      2326 ±  2%      -9.9%       2097 ±  7%  slabinfo.PING.num_objs
     72.33 ±  3%      -9.2%      65.67 ±  7%  slabinfo.PING.num_slabs
    192.00            +0.0%     192.00        slabinfo.RAW.active_objs
      6.00            +0.0%       6.00        slabinfo.RAW.active_slabs
    192.00            +0.0%     192.00        slabinfo.RAW.num_objs
      6.00            +0.0%       6.00        slabinfo.RAW.num_slabs
    112.67 ± 10%      +0.0%     112.67 ± 10%  slabinfo.RAWv6.active_objs
      4.33 ± 10%      +0.0%       4.33 ± 10%  slabinfo.RAWv6.active_slabs
    112.67 ± 10%      +0.0%     112.67 ± 10%  slabinfo.RAWv6.num_objs
      4.33 ± 10%      +0.0%       4.33 ± 10%  slabinfo.RAWv6.num_slabs
     98.00            +0.0%      98.00 ± 11%  slabinfo.TCP.active_objs
      7.00            +0.0%       7.00 ± 11%  slabinfo.TCP.active_slabs
     98.00            +0.0%      98.00 ± 11%  slabinfo.TCP.num_objs
      7.00            +0.0%       7.00 ± 11%  slabinfo.TCP.num_slabs
     65.00            +0.0%      65.00        slabinfo.TCPv6.active_objs
      5.00            +0.0%       5.00        slabinfo.TCPv6.active_slabs
     65.00            +0.0%      65.00        slabinfo.TCPv6.num_objs
      5.00            +0.0%       5.00        slabinfo.TCPv6.num_slabs
    286.33 ±  5%      +1.3%     290.00 ± 10%  slabinfo.UDPv6.active_objs
     11.67 ±  4%      -2.9%      11.33 ± 11%  slabinfo.UDPv6.active_slabs
    286.33 ±  5%      +1.3%     290.00 ± 10%  slabinfo.UDPv6.num_objs
     11.67 ±  4%      -2.9%      11.33 ± 11%  slabinfo.UDPv6.num_slabs
     24299            +2.5%      24914        slabinfo.anon_vma.active_objs
    527.67            +2.5%     541.00        slabinfo.anon_vma.active_slabs
     24299            +2.5%      24914        slabinfo.anon_vma.num_objs
    527.67            +2.5%     541.00        slabinfo.anon_vma.num_slabs
     52675            +1.6%      53498        slabinfo.anon_vma_chain.active_objs
    822.33            +1.6%     835.33        slabinfo.anon_vma_chain.active_slabs
     52675            +1.6%      53498        slabinfo.anon_vma_chain.num_objs
    822.33            +1.6%     835.33        slabinfo.anon_vma_chain.num_slabs
    481.00 ± 13%      -5.4%     455.00 ± 10%  slabinfo.bdev_cache.active_objs
     12.33 ± 13%      -5.4%      11.67 ± 10%  slabinfo.bdev_cache.active_slabs
    481.00 ± 13%      -5.4%     455.00 ± 10%  slabinfo.bdev_cache.num_objs
     12.33 ± 13%      -5.4%      11.67 ± 10%  slabinfo.bdev_cache.num_slabs
    449.33 ±  2%      -4.1%     431.00 ±  9%  slabinfo.biovec-128.active_objs
     27.67            -4.8%      26.33 ±  9%  slabinfo.biovec-128.active_slabs
    449.33 ±  2%      -4.1%     431.00 ±  9%  slabinfo.biovec-128.num_objs
     27.67            -4.8%      26.33 ±  9%  slabinfo.biovec-128.num_slabs
    213.33 ± 14%      -5.0%     202.67 ±  7%  slabinfo.biovec-64.active_objs
      6.67 ± 14%      -5.0%       6.33 ±  7%  slabinfo.biovec-64.active_slabs
    213.33 ± 14%      -5.0%     202.67 ±  7%  slabinfo.biovec-64.num_objs
      6.67 ± 14%      -5.0%       6.33 ±  7%  slabinfo.biovec-64.num_slabs
    588.00 ± 26%      -9.4%     532.67 ± 11%  slabinfo.biovec-max.active_objs
     74.67 ± 24%     -10.7%      66.67 ± 11%  slabinfo.biovec-max.active_slabs
    597.33 ± 24%     -10.7%     533.33 ± 11%  slabinfo.biovec-max.num_objs
     74.67 ± 24%     -10.7%      66.67 ± 11%  slabinfo.biovec-max.num_slabs
      2130            -1.8%       2093 ±  3%  slabinfo.blkdev_ioc.active_objs
     54.33            +1.8%      55.33 ±  2%  slabinfo.blkdev_ioc.active_slabs
      2143            +1.8%       2182 ±  2%  slabinfo.blkdev_ioc.num_objs
     54.33            +1.8%      55.33 ±  2%  slabinfo.blkdev_ioc.num_slabs
    108.00           -16.7%      90.00 ± 14%  slabinfo.btrfs_inode.active_objs
      4.00           -16.7%       3.33 ± 14%  slabinfo.btrfs_inode.active_slabs
    108.00           -16.7%      90.00 ± 14%  slabinfo.btrfs_inode.num_objs
      4.00           -16.7%       3.33 ± 14%  slabinfo.btrfs_inode.num_slabs
    312.00 ± 10%      +4.2%     325.00 ±  5%  slabinfo.buffer_head.active_objs
      8.00 ± 10%      +4.2%       8.33 ±  5%  slabinfo.buffer_head.active_slabs
    312.00 ± 10%      +4.2%     325.00 ±  5%  slabinfo.buffer_head.num_objs
      8.00 ± 10%      +4.2%       8.33 ±  5%  slabinfo.buffer_head.num_slabs
      5457            +0.1%       5465        slabinfo.cred_jar.active_objs
    129.33            +0.0%     129.33        slabinfo.cred_jar.active_slabs
      5457            +0.1%       5465        slabinfo.cred_jar.num_objs
    129.33            +0.0%     129.33        slabinfo.cred_jar.num_slabs
     98.00 ± 20%     +14.3%     112.00 ± 17%  slabinfo.dax_cache.active_objs
      2.33 ± 20%     +14.3%       2.67 ± 17%  slabinfo.dax_cache.active_slabs
     98.00 ± 20%     +14.3%     112.00 ± 17%  slabinfo.dax_cache.num_objs
      2.33 ± 20%     +14.3%       2.67 ± 17%  slabinfo.dax_cache.num_slabs
    105175            -0.9%     104185        slabinfo.dentry.active_objs
      2511            -0.9%       2488        slabinfo.dentry.active_slabs
    105473            -0.9%     104480        slabinfo.dentry.num_objs
      2511            -0.9%       2488        slabinfo.dentry.num_slabs
     30.00            +0.0%      30.00        slabinfo.dmaengine-unmap-128.active_objs
      1.00            +0.0%       1.00        slabinfo.dmaengine-unmap-128.active_slabs
     30.00            +0.0%      30.00        slabinfo.dmaengine-unmap-128.num_objs
      1.00            +0.0%       1.00        slabinfo.dmaengine-unmap-128.num_slabs
      4624 ±  3%      +0.6%       4652 ±  7%  slabinfo.dmaengine-unmap-16.active_objs
    109.67 ±  3%      +0.6%     110.33 ±  7%  slabinfo.dmaengine-unmap-16.active_slabs
      4624 ±  3%      +0.6%       4652 ±  7%  slabinfo.dmaengine-unmap-16.num_objs
    109.67 ±  3%      +0.6%     110.33 ±  7%  slabinfo.dmaengine-unmap-16.num_slabs
     15.00            +0.0%      15.00        slabinfo.dmaengine-unmap-256.active_objs
      1.00            +0.0%       1.00        slabinfo.dmaengine-unmap-256.active_slabs
     15.00            +0.0%      15.00        slabinfo.dmaengine-unmap-256.num_objs
      1.00            +0.0%       1.00        slabinfo.dmaengine-unmap-256.num_slabs
      4934            -6.0%       4638 ±  7%  slabinfo.eventpoll_pwq.active_objs
     87.33            -5.7%      82.33 ±  6%  slabinfo.eventpoll_pwq.active_slabs
      4934            -6.0%       4638 ±  7%  slabinfo.eventpoll_pwq.num_objs
     87.33            -5.7%      82.33 ±  6%  slabinfo.eventpoll_pwq.num_slabs
      1240 ±  3%     -10.0%       1116 ±  9%  slabinfo.file_lock_cache.active_objs
     33.00 ±  2%     -11.1%      29.33 ±  9%  slabinfo.file_lock_cache.active_slabs
      1240 ±  3%     -10.0%       1116 ±  9%  slabinfo.file_lock_cache.num_objs
     33.00 ±  2%     -11.1%      29.33 ±  9%  slabinfo.file_lock_cache.num_slabs
      4690            -0.0%       4689        slabinfo.files_cache.active_objs
    102.33            -0.7%     101.67        slabinfo.files_cache.active_slabs
      4690            -0.0%       4689        slabinfo.files_cache.num_objs
    102.33            -0.7%     101.67        slabinfo.files_cache.num_slabs
     36642            +1.1%      37058        slabinfo.filp.active_objs
      1150            +1.0%       1162        slabinfo.filp.active_slabs
     36808            +1.1%      37205        slabinfo.filp.num_objs
      1150            +1.0%       1162        slabinfo.filp.num_slabs
      3174 ± 11%     -13.4%       2747 ±  9%  slabinfo.fsnotify_mark_connector.active_objs
     24.33 ± 10%     -12.3%      21.33 ±  9%  slabinfo.fsnotify_mark_connector.active_slabs
      3174 ± 11%     -13.4%       2747 ±  9%  slabinfo.fsnotify_mark_connector.num_objs
     24.33 ± 10%     -12.3%      21.33 ±  9%  slabinfo.fsnotify_mark_connector.num_slabs
     32243            -0.2%      32186        slabinfo.ftrace_event_field.active_objs
    379.33            -0.2%     378.67        slabinfo.ftrace_event_field.active_slabs
     32243            -0.2%      32186        slabinfo.ftrace_event_field.num_objs
    379.33            -0.2%     378.67        slabinfo.ftrace_event_field.num_slabs
    104.00            +0.0%     104.00        slabinfo.hugetlbfs_inode_cache.active_objs
      2.00            +0.0%       2.00        slabinfo.hugetlbfs_inode_cache.active_slabs
    104.00            +0.0%     104.00        slabinfo.hugetlbfs_inode_cache.num_objs
      2.00            +0.0%       2.00        slabinfo.hugetlbfs_inode_cache.num_slabs
     53469 ±  2%      -0.2%      53378        slabinfo.inode_cache.active_objs
      1002 ±  2%      +0.2%       1004        slabinfo.inode_cache.active_slabs
     54133 ±  2%      -0.3%      53980        slabinfo.inode_cache.num_objs
      1002 ±  2%      +0.2%       1004        slabinfo.inode_cache.num_slabs
      2251 ±  2%      +1.3%       2279 ±  5%  slabinfo.ip6-frags.active_objs
     50.33 ±  2%      +1.3%      51.00 ±  5%  slabinfo.ip6-frags.active_slabs
      2251 ±  2%      +1.3%       2279 ±  5%  slabinfo.ip6-frags.num_objs
     50.33 ±  2%      +1.3%      51.00 ±  5%  slabinfo.ip6-frags.num_slabs
     83778            -0.0%      83750        slabinfo.kernfs_node_cache.active_objs
      2617            -0.0%       2616        slabinfo.kernfs_node_cache.active_slabs
     83778            -0.0%      83750        slabinfo.kernfs_node_cache.num_objs
      2617            -0.0%       2616        slabinfo.kernfs_node_cache.num_slabs
      1787 ±  6%     -10.7%       1595 ±  6%  slabinfo.khugepaged_mm_slot.active_objs
     48.67 ±  6%     -11.0%      43.33 ±  7%  slabinfo.khugepaged_mm_slot.active_slabs
      1787 ±  6%     -10.7%       1595 ±  6%  slabinfo.khugepaged_mm_slot.num_objs
     48.67 ±  6%     -11.0%      43.33 ±  7%  slabinfo.khugepaged_mm_slot.num_slabs
      5221            +0.3%       5238        slabinfo.kmalloc-128.active_objs
    166.67            +0.8%     168.00        slabinfo.kmalloc-128.active_slabs
      5349            +0.8%       5392        slabinfo.kmalloc-128.num_objs
    166.67            +0.8%     168.00        slabinfo.kmalloc-128.num_slabs
     35242            +0.2%      35328        slabinfo.kmalloc-16.active_objs
    137.67            +0.2%     138.00        slabinfo.kmalloc-16.active_slabs
     35242            +0.2%      35328        slabinfo.kmalloc-16.num_objs
    137.67            +0.2%     138.00        slabinfo.kmalloc-16.num_slabs
      5518            +0.1%       5525        slabinfo.kmalloc-192.active_objs
    132.00            +0.3%     132.33        slabinfo.kmalloc-192.active_slabs
      5572            +0.2%       5583        slabinfo.kmalloc-192.num_objs
    132.00            +0.3%     132.33        slabinfo.kmalloc-192.num_slabs
      6016 ±  3%      -1.0%       5954        slabinfo.kmalloc-1k.active_objs
    192.33 ±  3%      -1.2%     190.00        slabinfo.kmalloc-1k.active_slabs
      6164 ±  3%      -1.0%       6101        slabinfo.kmalloc-1k.num_objs
    192.33 ±  3%      -1.2%     190.00        slabinfo.kmalloc-1k.num_slabs
      7454            +1.0%       7531 ±  2%  slabinfo.kmalloc-256.active_objs
    247.00            +1.1%     249.67        slabinfo.kmalloc-256.active_slabs
      7927            +0.9%       7995        slabinfo.kmalloc-256.num_objs
    247.00            +1.1%     249.67        slabinfo.kmalloc-256.num_slabs
      8937 ±  3%      -3.8%       8597 ±  3%  slabinfo.kmalloc-2k.active_objs
    562.67 ±  3%      -3.9%     541.00 ±  3%  slabinfo.kmalloc-2k.active_slabs
      9008 ±  3%      -3.9%       8661 ±  3%  slabinfo.kmalloc-2k.num_objs
    562.67 ±  3%      -3.9%     541.00 ±  3%  slabinfo.kmalloc-2k.num_slabs
     71082            +0.8%      71679        slabinfo.kmalloc-32.active_objs
    556.00            +1.0%     561.33        slabinfo.kmalloc-32.active_slabs
     71257            +1.0%      71944        slabinfo.kmalloc-32.num_objs
    556.00            +1.0%     561.33        slabinfo.kmalloc-32.num_slabs
      1932            +0.0%       1932        slabinfo.kmalloc-4k.active_objs
    252.33 ±  2%      +0.8%     254.33        slabinfo.kmalloc-4k.active_slabs
      2019 ±  2%      +1.0%       2038        slabinfo.kmalloc-4k.num_objs
    252.33 ±  2%      +0.8%     254.33        slabinfo.kmalloc-4k.num_slabs
     32279            +0.2%      32346        slabinfo.kmalloc-512.active_objs
      1123 ±  2%      -1.1%       1111        slabinfo.kmalloc-512.active_slabs
     35945 ±  2%      -1.1%      35560        slabinfo.kmalloc-512.num_objs
      1123 ±  2%      -1.1%       1111        slabinfo.kmalloc-512.num_slabs
     48501            +0.5%      48734        slabinfo.kmalloc-64.active_objs
    783.00            +1.4%     793.67        slabinfo.kmalloc-64.active_slabs
     50150            +1.4%      50837        slabinfo.kmalloc-64.num_objs
    783.00            +1.4%     793.67        slabinfo.kmalloc-64.num_slabs
     54650            +0.9%      55169        slabinfo.kmalloc-8.active_objs
    121.33 ±  2%      +3.6%     125.67 ±  2%  slabinfo.kmalloc-8.active_slabs
     62253 ±  2%      +3.8%      64603 ±  2%  slabinfo.kmalloc-8.num_objs
    121.33 ±  2%      +3.6%     125.67 ±  2%  slabinfo.kmalloc-8.num_slabs
    787.33            -0.3%     785.00        slabinfo.kmalloc-8k.active_objs
    202.00            -0.3%     201.33        slabinfo.kmalloc-8k.active_slabs
    809.33            -0.3%     806.67        slabinfo.kmalloc-8k.num_objs
    202.00            -0.3%     201.33        slabinfo.kmalloc-8k.num_slabs
     10043 ±  2%      -3.7%       9666 ±  4%  slabinfo.kmalloc-96.active_objs
    242.00 ±  2%      -4.0%     232.33 ±  4%  slabinfo.kmalloc-96.active_slabs
     10193 ±  2%      -4.1%       9775 ±  4%  slabinfo.kmalloc-96.num_objs
    242.00 ±  2%      -4.0%     232.33 ±  4%  slabinfo.kmalloc-96.num_slabs
    608.00           -22.8%     469.33 ± 22%  slabinfo.kmalloc-rcl-128.active_objs
     19.00           -22.8%      14.67 ± 22%  slabinfo.kmalloc-rcl-128.active_slabs
    608.00           -22.8%     469.33 ± 22%  slabinfo.kmalloc-rcl-128.num_objs
     19.00           -22.8%      14.67 ± 22%  slabinfo.kmalloc-rcl-128.num_slabs
     42.00            +0.0%      42.00        slabinfo.kmalloc-rcl-192.active_objs
      1.00            +0.0%       1.00        slabinfo.kmalloc-rcl-192.active_slabs
     42.00            +0.0%      42.00        slabinfo.kmalloc-rcl-192.num_objs
      1.00            +0.0%       1.00        slabinfo.kmalloc-rcl-192.num_slabs
     74.67 ± 20%     -14.3%      64.00        slabinfo.kmalloc-rcl-256.active_objs
      2.33 ± 20%     -14.3%       2.00        slabinfo.kmalloc-rcl-256.active_slabs
     74.67 ± 20%     -14.3%      64.00        slabinfo.kmalloc-rcl-256.num_objs
      2.33 ± 20%     -14.3%       2.00        slabinfo.kmalloc-rcl-256.num_slabs
      1664 ±  8%      -6.2%       1560 ±  2%  slabinfo.kmalloc-rcl-512.active_objs
     51.33 ±  8%      -5.8%      48.33 ±  2%  slabinfo.kmalloc-rcl-512.active_slabs
      1664 ±  8%      -6.2%       1560 ±  2%  slabinfo.kmalloc-rcl-512.num_objs
     51.33 ±  8%      -5.8%      48.33 ±  2%  slabinfo.kmalloc-rcl-512.num_slabs
      4654 ±  6%      -8.3%       4267        slabinfo.kmalloc-rcl-64.active_objs
     72.33 ±  6%      -8.3%      66.33        slabinfo.kmalloc-rcl-64.active_slabs
      4654 ±  6%      -8.3%       4267        slabinfo.kmalloc-rcl-64.num_objs
     72.33 ±  6%      -8.3%      66.33        slabinfo.kmalloc-rcl-64.num_slabs
      2214 ±  3%      -5.3%       2097 ±  6%  slabinfo.kmalloc-rcl-96.active_objs
     52.33 ±  3%      -5.1%      49.67 ±  5%  slabinfo.kmalloc-rcl-96.active_slabs
      2214 ±  3%      -5.3%       2097 ±  6%  slabinfo.kmalloc-rcl-96.num_objs
     52.33 ±  3%      -5.1%      49.67 ±  5%  slabinfo.kmalloc-rcl-96.num_slabs
    448.00 ± 11%      -2.4%     437.33 ±  6%  slabinfo.kmem_cache.active_objs
     14.00 ± 11%      -2.4%      13.67 ±  6%  slabinfo.kmem_cache.active_slabs
    448.00 ± 11%      -2.4%     437.33 ±  6%  slabinfo.kmem_cache.num_objs
     14.00 ± 11%      -2.4%      13.67 ±  6%  slabinfo.kmem_cache.num_slabs
    947.33 ±  8%      +0.0%     947.33 ±  8%  slabinfo.kmem_cache_node.active_objs
     15.33 ±  8%      +0.0%      15.33 ±  8%  slabinfo.kmem_cache_node.active_slabs
    981.33 ±  8%      +0.0%     981.33 ±  8%  slabinfo.kmem_cache_node.num_objs
     15.33 ±  8%      +0.0%      15.33 ±  8%  slabinfo.kmem_cache_node.num_slabs
     17169            +0.7%      17282        slabinfo.lsm_file_cache.active_objs
    100.00            +0.7%     100.67        slabinfo.lsm_file_cache.active_slabs
     17169            +0.7%      17282        slabinfo.lsm_file_cache.num_objs
    100.00            +0.7%     100.67        slabinfo.lsm_file_cache.num_slabs
      3119            +0.5%       3134        slabinfo.mm_struct.active_objs
    103.33            +0.3%     103.67        slabinfo.mm_struct.active_slabs
      3119            +0.5%       3134        slabinfo.mm_struct.num_objs
    103.33            +0.3%     103.67        slabinfo.mm_struct.num_slabs
    833.00 ± 15%      +8.2%     901.00 ±  2%  slabinfo.mnt_cache.active_objs
     16.33 ± 15%      +8.2%      17.67 ±  2%  slabinfo.mnt_cache.active_slabs
    833.00 ± 15%      +8.2%     901.00 ±  2%  slabinfo.mnt_cache.num_objs
     16.33 ± 15%      +8.2%      17.67 ±  2%  slabinfo.mnt_cache.num_slabs
     34.00            +0.0%      34.00        slabinfo.mqueue_inode_cache.active_objs
      1.00            +0.0%       1.00        slabinfo.mqueue_inode_cache.active_slabs
     34.00            +0.0%      34.00        slabinfo.mqueue_inode_cache.num_objs
      1.00            +0.0%       1.00        slabinfo.mqueue_inode_cache.num_slabs
    768.00            +0.0%     768.00        slabinfo.names_cache.active_objs
     96.00            +0.0%      96.00        slabinfo.names_cache.active_slabs
    768.00            +0.0%     768.00        slabinfo.names_cache.num_objs
     96.00            +0.0%      96.00        slabinfo.names_cache.num_slabs
    109.67 ± 12%     -18.5%      89.33 ± 26%  slabinfo.nfs_inode_cache.active_objs
      3.33 ± 14%     -30.0%       2.33 ± 20%  slabinfo.nfs_inode_cache.active_slabs
    109.67 ± 12%     -18.5%      89.33 ± 26%  slabinfo.nfs_inode_cache.num_objs
      3.33 ± 14%     -30.0%       2.33 ± 20%  slabinfo.nfs_inode_cache.num_slabs
    433.33 ±  6%      -9.6%     391.67 ±  7%  slabinfo.nfs_read_data.active_objs
     11.67 ±  8%      -8.6%      10.67 ±  8%  slabinfo.nfs_read_data.active_slabs
    433.33 ±  6%      -9.6%     391.67 ±  7%  slabinfo.nfs_read_data.num_objs
     11.67 ±  8%      -8.6%      10.67 ±  8%  slabinfo.nfs_read_data.num_slabs
      2865 ±  6%      -2.9%       2782        slabinfo.numa_policy.active_objs
     45.33 ±  6%      -2.9%      44.00        slabinfo.numa_policy.active_slabs
      2865 ±  6%      -2.9%       2782        slabinfo.numa_policy.num_objs
     45.33 ±  6%      -2.9%      44.00        slabinfo.numa_policy.num_slabs
      9657            +0.1%       9663        slabinfo.pde_opener.active_objs
     94.00            +0.4%      94.33        slabinfo.pde_opener.active_slabs
      9657            +0.1%       9663        slabinfo.pde_opener.num_objs
     94.00            +0.4%      94.33        slabinfo.pde_opener.num_slabs
      4415            +0.3%       4426        slabinfo.pid.active_objs
    137.00            +0.5%     137.67        slabinfo.pid.active_slabs
      4415            +0.3%       4426        slabinfo.pid.num_objs
    137.00            +0.5%     137.67        slabinfo.pid.num_slabs
     92.67 ± 27%     -19.8%      74.33 ± 34%  slabinfo.pid_namespace.active_objs
      1.00            +0.0%       1.00        slabinfo.pid_namespace.active_slabs
     92.67 ± 27%     -19.8%      74.33 ± 34%  slabinfo.pid_namespace.num_objs
      1.00            +0.0%       1.00        slabinfo.pid_namespace.num_slabs
      3025 ± 20%     -16.8%       2516 ±  8%  slabinfo.pool_workqueue.active_objs
     94.00 ± 20%     -17.0%      78.00 ±  8%  slabinfo.pool_workqueue.active_slabs
      3028 ± 20%     -16.9%       2516 ±  8%  slabinfo.pool_workqueue.num_objs
     94.00 ± 20%     -17.0%      78.00 ±  8%  slabinfo.pool_workqueue.num_slabs
      2884            +2.9%       2968 ±  3%  slabinfo.proc_dir_entry.active_objs
     68.67            +2.9%      70.67 ±  3%  slabinfo.proc_dir_entry.active_slabs
      2884            +2.9%       2968 ±  3%  slabinfo.proc_dir_entry.num_objs
     68.67            +2.9%      70.67 ±  3%  slabinfo.proc_dir_entry.num_slabs
      8047 ±  3%     +33.3%      10727 ±  3%  slabinfo.proc_inode_cache.active_objs
    172.33 ±  3%     +33.8%     230.67 ±  3%  slabinfo.proc_inode_cache.active_slabs
      8291 ±  3%     +33.0%      11027 ±  2%  slabinfo.proc_inode_cache.num_objs
    172.33 ±  3%     +33.8%     230.67 ±  3%  slabinfo.proc_inode_cache.num_slabs
    514122            -0.4%     512228        slabinfo.radix_tree_node.active_objs
      9958            +0.5%      10003        slabinfo.radix_tree_node.active_slabs
    555203            -0.4%     553065        slabinfo.radix_tree_node.num_objs
      9958            +0.5%      10003        slabinfo.radix_tree_node.num_slabs
     50.33 ± 13%      +0.0%      50.33 ± 13%  slabinfo.request_queue.active_objs
      3.67 ± 12%      +0.0%       3.67 ± 12%  slabinfo.request_queue.active_slabs
     55.00 ± 12%      +0.0%      55.00 ± 12%  slabinfo.request_queue.num_objs
      3.67 ± 12%      +0.0%       3.67 ± 12%  slabinfo.request_queue.num_slabs
    102.00           +16.7%     119.00 ± 20%  slabinfo.rpc_inode_cache.active_objs
      2.00           +16.7%       2.33 ± 20%  slabinfo.rpc_inode_cache.active_slabs
    102.00           +16.7%     119.00 ± 20%  slabinfo.rpc_inode_cache.num_objs
      2.00           +16.7%       2.33 ± 20%  slabinfo.rpc_inode_cache.num_slabs
    640.00            +0.0%     640.00        slabinfo.scsi_sense_cache.active_objs
     20.00            +0.0%      20.00        slabinfo.scsi_sense_cache.active_slabs
    640.00            +0.0%     640.00        slabinfo.scsi_sense_cache.num_objs
     20.00            +0.0%      20.00        slabinfo.scsi_sense_cache.num_slabs
      3264            +0.0%       3264        slabinfo.seq_file.active_objs
     96.00            +0.0%      96.00        slabinfo.seq_file.active_slabs
      3264            +0.0%       3264        slabinfo.seq_file.num_objs
     96.00            +0.0%      96.00        slabinfo.seq_file.num_slabs
      5450            -3.7%       5247        slabinfo.shmem_inode_cache.active_objs
    117.67            -3.7%     113.33        slabinfo.shmem_inode_cache.active_slabs
      5450            -3.7%       5247        slabinfo.shmem_inode_cache.num_objs
    117.67            -3.7%     113.33        slabinfo.shmem_inode_cache.num_slabs
      2389            -0.6%       2375        slabinfo.sighand_cache.active_objs
    159.00            -0.6%     158.00        slabinfo.sighand_cache.active_slabs
      2389            -0.6%       2375        slabinfo.sighand_cache.num_objs
    159.00            -0.6%     158.00        slabinfo.sighand_cache.num_slabs
      3843            -1.0%       3803        slabinfo.signal_cache.active_objs
    136.67            -1.0%     135.33 ±  2%  slabinfo.signal_cache.active_slabs
      3843            -1.0%       3803        slabinfo.signal_cache.num_objs
    136.67            -1.0%     135.33 ±  2%  slabinfo.signal_cache.num_slabs
    901.33 ±  4%      -4.8%     858.00 ±  9%  slabinfo.skbuff_fclone_cache.active_objs
     28.00 ±  5%      -2.4%      27.33 ±  9%  slabinfo.skbuff_fclone_cache.active_slabs
    901.33 ±  4%      -4.8%     858.00 ±  9%  slabinfo.skbuff_fclone_cache.num_objs
     28.00 ±  5%      -2.4%      27.33 ±  9%  slabinfo.skbuff_fclone_cache.num_slabs
      4339 ±  4%      -6.6%       4053 ±  3%  slabinfo.skbuff_head_cache.active_objs
    135.33 ±  4%      -6.4%     126.67 ±  3%  slabinfo.skbuff_head_cache.active_slabs
      4339 ±  4%      -6.6%       4053 ±  3%  slabinfo.skbuff_head_cache.num_objs
    135.33 ±  4%      -6.4%     126.67 ±  3%  slabinfo.skbuff_head_cache.num_slabs
      3580 ±  3%      -7.2%       3321 ±  4%  slabinfo.sock_inode_cache.active_objs
     91.33 ±  3%      -6.2%      85.67 ±  4%  slabinfo.sock_inode_cache.active_slabs
      3580 ±  3%      -7.2%       3321 ±  4%  slabinfo.sock_inode_cache.num_objs
     91.33 ±  3%      -6.2%      85.67 ±  4%  slabinfo.sock_inode_cache.num_slabs
      6164            -1.2%       6089        slabinfo.task_delay_info.active_objs
    120.33            -1.1%     119.00        slabinfo.task_delay_info.active_slabs
      6164            -1.2%       6089        slabinfo.task_delay_info.num_objs
    120.33            -1.1%     119.00        slabinfo.task_delay_info.num_slabs
      2648 ±  5%      -7.8%       2441 ± 11%  slabinfo.task_group.active_objs
     62.67 ±  4%      -8.5%      57.33 ± 11%  slabinfo.task_group.active_slabs
      2648 ±  5%      -7.8%       2441 ± 11%  slabinfo.task_group.num_objs
     62.67 ±  4%      -8.5%      57.33 ± 11%  slabinfo.task_group.num_slabs
      1231            +0.1%       1233        slabinfo.task_struct.active_objs
      1237            +0.1%       1239        slabinfo.task_struct.active_slabs
      1237            +0.1%       1239        slabinfo.task_struct.num_objs
      1237            +0.1%       1239        slabinfo.task_struct.num_slabs
    144.67 ± 14%     +10.6%     160.00 ± 23%  slabinfo.taskstats.active_objs
      2.67 ± 17%     +12.5%       3.00 ± 27%  slabinfo.taskstats.active_slabs
    144.67 ± 14%     +10.6%     160.00 ± 23%  slabinfo.taskstats.num_objs
      2.67 ± 17%     +12.5%       3.00 ± 27%  slabinfo.taskstats.num_slabs
      3274 ±  5%      -3.8%       3151        slabinfo.trace_event_file.active_objs
     71.00 ±  5%      -3.8%      68.33        slabinfo.trace_event_file.active_slabs
      3274 ±  5%      -3.8%       3151        slabinfo.trace_event_file.num_objs
     71.00 ±  5%      -3.8%      68.33        slabinfo.trace_event_file.num_slabs
     99.00            +0.0%      99.00        slabinfo.tw_sock_TCP.active_objs
      3.00            +0.0%       3.00        slabinfo.tw_sock_TCP.active_slabs
     99.00            +0.0%      99.00        slabinfo.tw_sock_TCP.num_objs
      3.00            +0.0%       3.00        slabinfo.tw_sock_TCP.num_slabs
     66838 ±  5%      -5.7%      63053 ±  3%  slabinfo.vm_area_struct.active_objs
      1673 ±  5%      -5.6%       1579 ±  3%  slabinfo.vm_area_struct.active_slabs
     66962 ±  5%      -5.7%      63174 ±  3%  slabinfo.vm_area_struct.num_objs
      1673 ±  5%      -5.6%       1579 ±  3%  slabinfo.vm_area_struct.num_slabs
     17716            -1.7%      17418        slabinfo.vmap_area.active_objs
    296.33            -0.6%     294.67        slabinfo.vmap_area.active_slabs
     19001            -0.5%      18903        slabinfo.vmap_area.num_objs
    296.33            -0.6%     294.67        slabinfo.vmap_area.num_slabs
    444.00 ± 61%     -32.4%     300.00 ± 20%  slabinfo.xfs_btree_cur.active_objs
     12.33 ± 61%     -32.4%       8.33 ± 20%  slabinfo.xfs_btree_cur.active_slabs
    444.00 ± 61%     -32.4%     300.00 ± 20%  slabinfo.xfs_btree_cur.num_objs
     12.33 ± 61%     -32.4%       8.33 ± 20%  slabinfo.xfs_btree_cur.num_slabs
    322.00 ± 26%      -4.3%     308.00 ± 23%  slabinfo.xfs_buf.active_objs
      7.67 ± 26%      -4.3%       7.33 ± 23%  slabinfo.xfs_buf.active_slabs
    322.00 ± 26%      -4.3%     308.00 ± 23%  slabinfo.xfs_buf.num_objs
      7.67 ± 26%      -4.3%       7.33 ± 23%  slabinfo.xfs_buf.num_slabs
    462.00 ± 70%     -42.4%     266.00 ± 14%  slabinfo.xfs_ili.active_objs
     11.00 ± 70%     -42.4%       6.33 ± 14%  slabinfo.xfs_ili.active_slabs
    462.00 ± 70%     -42.4%     266.00 ± 14%  slabinfo.xfs_ili.num_objs
     11.00 ± 70%     -42.4%       6.33 ± 14%  slabinfo.xfs_ili.num_slabs
    394.67 ± 61%     -37.8%     245.33 ± 16%  slabinfo.xfs_inode.active_objs
     12.33 ± 61%     -37.8%       7.67 ± 16%  slabinfo.xfs_inode.active_slabs
    394.67 ± 61%     -37.8%     245.33 ± 16%  slabinfo.xfs_inode.num_objs
     12.33 ± 61%     -37.8%       7.67 ± 16%  slabinfo.xfs_inode.num_slabs
      9.01 ± 11%      -9.0        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irq.lru_note_cost.shrink_inactive_list.shrink_lruvec.shrink_node
      8.96 ± 11%      -9.0        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irq.lru_note_cost.shrink_inactive_list.shrink_lruvec
      8.90 ± 10%      -8.9        0.00        perf-profile.calltrace.cycles-pp.lru_note_cost.shrink_inactive_list.shrink_lruvec.shrink_node.do_try_to_free_pages
     30.38 ± 22%      -4.6       25.80        perf-profile.calltrace.cycles-pp.intel_idle.cpuidle_enter_state.cpuidle_enter.do_idle.cpu_startup_entry
     30.47 ± 22%      -4.5       26.02        perf-profile.calltrace.cycles-pp.secondary_startup_64
     30.01 ± 23%      -4.2       25.81        perf-profile.calltrace.cycles-pp.cpuidle_enter.do_idle.cpu_startup_entry.start_secondary.secondary_startup_64
     30.01 ± 23%      -4.2       25.81        perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_secondary.secondary_startup_64
     30.01 ± 23%      -4.2       25.81        perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.start_secondary.secondary_startup_64
     30.01 ± 23%      -4.2       25.81        perf-profile.calltrace.cycles-pp.start_secondary.secondary_startup_64
     30.00 ± 23%      -4.2       25.81        perf-profile.calltrace.cycles-pp.cpuidle_enter_state.cpuidle_enter.do_idle.cpu_startup_entry.start_secondary
      0.39 ± 70%      -0.4        0.00        perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_kernel.secondary_startup_64
      0.39 ± 70%      -0.4        0.00        perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.start_kernel.secondary_startup_64
      0.39 ± 70%      -0.4        0.00        perf-profile.calltrace.cycles-pp.cpuidle_enter.do_idle.cpu_startup_entry.start_kernel.secondary_startup_64
      0.39 ± 70%      -0.4        0.00        perf-profile.calltrace.cycles-pp.cpuidle_enter_state.cpuidle_enter.do_idle.cpu_startup_entry.start_kernel
      0.39 ± 70%      -0.4        0.00        perf-profile.calltrace.cycles-pp.start_kernel.secondary_startup_64
      0.34 ± 70%      -0.3        0.00        perf-profile.calltrace.cycles-pp.lru_note_cost.shrink_inactive_list.shrink_lruvec.shrink_node.balance_pgdat
      0.34 ± 70%      -0.3        0.00        perf-profile.calltrace.cycles-pp.page_referenced_one.rmap_walk_file.page_referenced.shrink_page_list.shrink_inactive_list
      0.17 ±141%      -0.2        0.00        perf-profile.calltrace.cycles-pp.rmqueue.get_page_from_freelist.__alloc_pages_nodemask.pagecache_get_page.filemap_fault
      0.74 ± 10%      +0.0        0.75        perf-profile.calltrace.cycles-pp.rmap_walk_file.page_referenced.shrink_page_list.shrink_inactive_list.shrink_lruvec
      0.84 ± 11%      +0.0        0.86        perf-profile.calltrace.cycles-pp.page_referenced.shrink_page_list.shrink_inactive_list.shrink_lruvec.shrink_node
      0.80 ±  9%      +0.0        0.82        perf-profile.calltrace.cycles-pp.isolate_lru_pages.shrink_inactive_list.shrink_lruvec.shrink_node.do_try_to_free_pages
      0.73 ±  6%      +0.0        0.76 ±  2%  perf-profile.calltrace.cycles-pp.iomap_apply.iomap_readpage.filemap_fault.__xfs_filemap_fault.__do_fault
      0.61 ± 10%      +0.0        0.64 ±  9%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__remove_mapping.shrink_page_list.shrink_inactive_list.shrink_lruvec
      0.65 ±  5%      +0.1        0.71        perf-profile.calltrace.cycles-pp.rmap_walk_file.try_to_unmap.shrink_page_list.shrink_inactive_list.shrink_lruvec
      0.70 ±  5%      +0.1        0.76        perf-profile.calltrace.cycles-pp.try_to_unmap.shrink_page_list.shrink_inactive_list.shrink_lruvec.shrink_node
      0.55 ±  8%      +0.1        0.61 ±  6%  perf-profile.calltrace.cycles-pp.alloc_set_pte.filemap_map_pages.xfs_filemap_map_pages.do_fault.__handle_mm_fault
      3.03 ± 15%      +0.1        3.10 ±  3%  perf-profile.calltrace.cycles-pp.__memcpy_mcsafe.pmem_do_read.pmem_submit_bio.submit_bio_noacct.submit_bio
      3.07 ± 15%      +0.1        3.14 ±  3%  perf-profile.calltrace.cycles-pp.pmem_do_read.pmem_submit_bio.submit_bio_noacct.submit_bio.iomap_readpage
      1.12 ± 12%      +0.1        1.19        perf-profile.calltrace.cycles-pp.__add_to_page_cache_locked.add_to_page_cache_lru.pagecache_get_page.filemap_fault.__xfs_filemap_fault
      3.45 ± 14%      +0.1        3.53 ±  3%  perf-profile.calltrace.cycles-pp.pmem_submit_bio.submit_bio_noacct.submit_bio.iomap_readpage.filemap_fault
      1.46 ± 10%      +0.1        1.56 ±  4%  perf-profile.calltrace.cycles-pp.__remove_mapping.shrink_page_list.shrink_inactive_list.shrink_lruvec.shrink_node
      3.71 ± 14%      +0.1        3.82 ±  3%  perf-profile.calltrace.cycles-pp.submit_bio.iomap_readpage.filemap_fault.__xfs_filemap_fault.__do_fault
      3.70 ± 14%      +0.1        3.81 ±  3%  perf-profile.calltrace.cycles-pp.submit_bio_noacct.submit_bio.iomap_readpage.filemap_fault.__xfs_filemap_fault
      2.87 ± 16%      +0.1        3.00 ±  6%  perf-profile.calltrace.cycles-pp.ret_from_fork
      2.87 ± 16%      +0.1        3.00 ±  6%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork
      4.45 ± 13%      +0.2        4.60 ±  2%  perf-profile.calltrace.cycles-pp.iomap_readpage.filemap_fault.__xfs_filemap_fault.__do_fault.do_fault
      2.75 ± 15%      +0.2        2.91 ±  7%  perf-profile.calltrace.cycles-pp.shrink_inactive_list.shrink_lruvec.shrink_node.balance_pgdat.kswapd
      2.76 ± 15%      +0.2        2.93 ±  7%  perf-profile.calltrace.cycles-pp.shrink_node.balance_pgdat.kswapd.kthread.ret_from_fork
      2.76 ± 15%      +0.2        2.93 ±  7%  perf-profile.calltrace.cycles-pp.kswapd.kthread.ret_from_fork
      2.76 ± 15%      +0.2        2.93 ±  7%  perf-profile.calltrace.cycles-pp.balance_pgdat.kswapd.kthread.ret_from_fork
      0.38 ± 70%      +0.2        0.55 ±  2%  perf-profile.calltrace.cycles-pp.mem_cgroup_charge.__add_to_page_cache_locked.add_to_page_cache_lru.pagecache_get_page.filemap_fault
      2.75 ± 15%      +0.2        2.92 ±  7%  perf-profile.calltrace.cycles-pp.shrink_lruvec.shrink_node.balance_pgdat.kswapd.kthread
      2.88 ± 10%      +0.2        3.06        perf-profile.calltrace.cycles-pp.filemap_map_pages.xfs_filemap_map_pages.do_fault.__handle_mm_fault.handle_mm_fault
      0.44 ± 70%      +0.2        0.62 ±  3%  perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_pages_nodemask.pagecache_get_page.filemap_fault.__xfs_filemap_fault
      1.14 ± 18%      +0.2        1.33 ±  5%  perf-profile.calltrace.cycles-pp.shrink_page_list.shrink_inactive_list.shrink_lruvec.shrink_node.balance_pgdat
      0.41 ± 70%      +0.2        0.60 ±  9%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__remove_mapping.shrink_page_list.shrink_inactive_list
      3.07 ± 10%      +0.2        3.26        perf-profile.calltrace.cycles-pp.xfs_filemap_map_pages.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      0.37 ± 70%      +0.2        0.58 ±  2%  perf-profile.calltrace.cycles-pp.try_to_unmap_one.rmap_walk_file.try_to_unmap.shrink_page_list.shrink_inactive_list
      0.93 ± 13%      +0.4        1.34 ±  9%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irq.shrink_inactive_list.shrink_lruvec.shrink_node.balance_pgdat
     36.95 ± 10%      +0.6       37.57        perf-profile.calltrace.cycles-pp.shrink_inactive_list.shrink_lruvec.shrink_node.do_try_to_free_pages.try_to_free_pages
     37.46 ±  9%      +0.7       38.16        perf-profile.calltrace.cycles-pp.shrink_node.do_try_to_free_pages.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask
     37.48 ±  9%      +0.7       38.18        perf-profile.calltrace.cycles-pp.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.pagecache_get_page.filemap_fault
     37.46 ±  9%      +0.7       38.17        perf-profile.calltrace.cycles-pp.do_try_to_free_pages.try_to_free_pages.__alloc_pages_slowpath.__alloc_pages_nodemask.pagecache_get_page
     37.67 ±  9%      +0.7       38.37        perf-profile.calltrace.cycles-pp.__alloc_pages_slowpath.__alloc_pages_nodemask.pagecache_get_page.filemap_fault.__xfs_filemap_fault
     37.17 ±  9%      +0.7       37.88        perf-profile.calltrace.cycles-pp.shrink_lruvec.shrink_node.do_try_to_free_pages.try_to_free_pages.__alloc_pages_slowpath
     38.35 ±  9%      +0.7       39.07        perf-profile.calltrace.cycles-pp.__alloc_pages_nodemask.pagecache_get_page.filemap_fault.__xfs_filemap_fault.__do_fault
      2.30 ± 25%      +0.7        3.03 ± 21%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.lock_page_lruvec_irqsave.pagevec_lru_move_fn.deactivate_file_page
      2.30 ± 25%      +0.7        3.04 ± 21%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.lock_page_lruvec_irqsave.pagevec_lru_move_fn.deactivate_file_page.invalidate_mapping_pages
      2.31 ± 25%      +0.7        3.05 ± 21%  perf-profile.calltrace.cycles-pp.lock_page_lruvec_irqsave.pagevec_lru_move_fn.deactivate_file_page.invalidate_mapping_pages.generic_fadvise
      2.38 ± 25%      +0.8        3.14 ± 21%  perf-profile.calltrace.cycles-pp.deactivate_file_page.invalidate_mapping_pages.generic_fadvise.ksys_fadvise64_64.__x64_sys_fadvise64
      2.37 ± 25%      +0.8        3.13 ± 21%  perf-profile.calltrace.cycles-pp.pagevec_lru_move_fn.deactivate_file_page.invalidate_mapping_pages.generic_fadvise.ksys_fadvise64_64
      2.72 ± 25%      +0.8        3.49 ± 21%  perf-profile.calltrace.cycles-pp.__x64_sys_fadvise64.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.72 ± 25%      +0.8        3.49 ± 21%  perf-profile.calltrace.cycles-pp.ksys_fadvise64_64.__x64_sys_fadvise64.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.72 ± 25%      +0.8        3.49 ± 21%  perf-profile.calltrace.cycles-pp.generic_fadvise.ksys_fadvise64_64.__x64_sys_fadvise64.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.72 ± 25%      +0.8        3.49 ± 21%  perf-profile.calltrace.cycles-pp.invalidate_mapping_pages.generic_fadvise.ksys_fadvise64_64.__x64_sys_fadvise64.do_syscall_64
      2.75 ± 24%      +0.8        3.53 ± 20%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe
      2.75 ± 24%      +0.8        3.53 ± 20%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.76 ± 15%      +1.3        5.06        perf-profile.calltrace.cycles-pp.smp_call_function_many_cond.on_each_cpu_cond_mask.arch_tlbbatch_flush.try_to_unmap_flush.shrink_page_list
      7.26 ±  9%      +1.3        8.57        perf-profile.calltrace.cycles-pp.shrink_page_list.shrink_inactive_list.shrink_lruvec.shrink_node.do_try_to_free_pages
      3.92 ± 15%      +1.4        5.29        perf-profile.calltrace.cycles-pp.on_each_cpu_cond_mask.arch_tlbbatch_flush.try_to_unmap_flush.shrink_page_list.shrink_inactive_list
      3.92 ± 15%      +1.4        5.29        perf-profile.calltrace.cycles-pp.try_to_unmap_flush.shrink_page_list.shrink_inactive_list.shrink_lruvec.shrink_node
      3.92 ± 15%      +1.4        5.29        perf-profile.calltrace.cycles-pp.arch_tlbbatch_flush.try_to_unmap_flush.shrink_page_list.shrink_inactive_list.shrink_lruvec
     13.07 ± 12%      +2.2       15.29 ±  3%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.lock_page_lruvec_irqsave.__pagevec_lru_add.lru_cache_add
     13.11 ± 12%      +2.2       15.33 ±  3%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.lock_page_lruvec_irqsave.__pagevec_lru_add.lru_cache_add.add_to_page_cache_lru
     13.11 ± 12%      +2.2       15.33 ±  3%  perf-profile.calltrace.cycles-pp.lock_page_lruvec_irqsave.__pagevec_lru_add.lru_cache_add.add_to_page_cache_lru.pagecache_get_page
     13.90 ± 12%      +2.3       16.19 ±  3%  perf-profile.calltrace.cycles-pp.lru_cache_add.add_to_page_cache_lru.pagecache_get_page.filemap_fault.__xfs_filemap_fault
     13.85 ± 12%      +2.3       16.15 ±  3%  perf-profile.calltrace.cycles-pp.__pagevec_lru_add.lru_cache_add.add_to_page_cache_lru.pagecache_get_page.filemap_fault
     15.10 ± 11%      +2.4       17.48 ±  3%  perf-profile.calltrace.cycles-pp.add_to_page_cache_lru.pagecache_get_page.filemap_fault.__xfs_filemap_fault.__do_fault
     53.68 ± 10%      +3.1       56.78        perf-profile.calltrace.cycles-pp.pagecache_get_page.filemap_fault.__xfs_filemap_fault.__do_fault.do_fault
     58.48 ± 10%      +3.2       61.72        perf-profile.calltrace.cycles-pp.filemap_fault.__xfs_filemap_fault.__do_fault.do_fault.__handle_mm_fault
     58.60 ± 10%      +3.2       61.84        perf-profile.calltrace.cycles-pp.__xfs_filemap_fault.__do_fault.do_fault.__handle_mm_fault.handle_mm_fault
     58.62 ± 10%      +3.3       61.88        perf-profile.calltrace.cycles-pp.__do_fault.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
     61.84 ± 10%      +3.4       65.29        perf-profile.calltrace.cycles-pp.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault
     62.08 ± 10%      +3.5       65.54        perf-profile.calltrace.cycles-pp.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     62.56 ± 10%      +3.5       66.03        perf-profile.calltrace.cycles-pp.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     62.90 ± 10%      +3.5       66.37        perf-profile.calltrace.cycles-pp.exc_page_fault.asm_exc_page_fault
     62.95 ± 10%      +3.5       66.42        perf-profile.calltrace.cycles-pp.asm_exc_page_fault
     62.85 ± 10%      +3.5       66.33        perf-profile.calltrace.cycles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     19.43 ± 10%      +8.0       27.47        perf-profile.calltrace.cycles-pp._raw_spin_lock_irq.shrink_inactive_list.shrink_lruvec.shrink_node.do_try_to_free_pages
     20.31 ± 10%      +8.4       28.76        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irq.shrink_inactive_list.shrink_lruvec.shrink_node
      9.42 ± 10%      -9.4        0.00        perf-profile.children.cycles-pp.lru_note_cost
     30.47 ± 22%      -4.5       26.02        perf-profile.children.cycles-pp.secondary_startup_64
     30.47 ± 22%      -4.5       26.02        perf-profile.children.cycles-pp.cpu_startup_entry
     30.47 ± 22%      -4.5       26.02        perf-profile.children.cycles-pp.do_idle
     30.47 ± 22%      -4.5       26.02        perf-profile.children.cycles-pp.cpuidle_enter
     30.47 ± 22%      -4.5       26.02        perf-profile.children.cycles-pp.cpuidle_enter_state
     30.46 ± 22%      -4.5       26.01        perf-profile.children.cycles-pp.intel_idle
     30.01 ± 23%      -4.2       25.81        perf-profile.children.cycles-pp.start_secondary
     30.00 ± 10%      -0.7       29.28        perf-profile.children.cycles-pp._raw_spin_lock_irq
      0.46 ± 35%      -0.3        0.21 ± 79%  perf-profile.children.cycles-pp.start_kernel
      0.07 ± 23%      -0.0        0.03 ±141%  perf-profile.children.cycles-pp.worker_thread
      0.14 ± 34%      -0.0        0.10 ± 25%  perf-profile.children.cycles-pp.kmem_cache_alloc
      0.05 ± 72%      -0.0        0.02 ±141%  perf-profile.children.cycles-pp.__slab_alloc
      0.05 ± 72%      -0.0        0.02 ±141%  perf-profile.children.cycles-pp.___slab_alloc
      0.05 ± 72%      -0.0        0.02 ±141%  perf-profile.children.cycles-pp.allocate_slab
      0.03 ± 70%      -0.0        0.00        perf-profile.children.cycles-pp.ptep_clear_flush_young
      0.05 ± 71%      -0.0        0.02 ±141%  perf-profile.children.cycles-pp.xas_nomem
      0.03 ±141%      -0.0        0.00        perf-profile.children.cycles-pp.__schedule
      0.03 ±141%      -0.0        0.00        perf-profile.children.cycles-pp.schedule
      0.02 ±141%      -0.0        0.00        perf-profile.children.cycles-pp.pick_next_task_fair
      0.02 ±141%      -0.0        0.00        perf-profile.children.cycles-pp.newidle_balance
      0.02 ±141%      -0.0        0.00        perf-profile.children.cycles-pp.load_balance
      0.02 ±141%      -0.0        0.00        perf-profile.children.cycles-pp.find_busiest_group
      0.02 ±141%      -0.0        0.00        perf-profile.children.cycles-pp.update_sd_lb_stats
      0.02 ±141%      -0.0        0.00        perf-profile.children.cycles-pp.schedule_timeout
      0.02 ±141%      -0.0        0.00        perf-profile.children.cycles-pp.rcu_gp_kthread
      0.05 ± 78%      -0.0        0.03 ±141%  perf-profile.children.cycles-pp.process_one_work
      0.03 ± 70%      -0.0        0.02 ±141%  perf-profile.children.cycles-pp.__mod_zone_page_state
      0.02 ±141%      -0.0        0.00        perf-profile.children.cycles-pp.execve
      0.02 ±141%      -0.0        0.00        perf-profile.children.cycles-pp.__x64_sys_execve
      0.02 ±141%      -0.0        0.00        perf-profile.children.cycles-pp.do_execveat_common
      0.10 ± 17%      -0.0        0.08 ± 71%  perf-profile.children.cycles-pp.ksys_write
      0.09 ± 13%      -0.0        0.08 ± 72%  perf-profile.children.cycles-pp.__libc_write
      0.09 ± 13%      -0.0        0.08 ± 72%  perf-profile.children.cycles-pp.generic_file_write_iter
      0.09 ± 13%      -0.0        0.08 ± 72%  perf-profile.children.cycles-pp.__generic_file_write_iter
      0.09 ± 13%      -0.0        0.08 ± 72%  perf-profile.children.cycles-pp.generic_perform_write
      0.09 ± 13%      -0.0        0.08 ± 71%  perf-profile.children.cycles-pp.vfs_write
      0.09 ± 13%      -0.0        0.08 ± 71%  perf-profile.children.cycles-pp.new_sync_write
      0.25 ± 16%      -0.0        0.24 ±  5%  perf-profile.children.cycles-pp.shrink_slab
      0.44 ± 12%      -0.0        0.43 ±  8%  perf-profile.children.cycles-pp._raw_spin_lock
      0.38 ± 14%      -0.0        0.38 ±  4%  perf-profile.children.cycles-pp.rmqueue_bulk
      0.33 ± 10%      -0.0        0.32 ± 10%  perf-profile.children.cycles-pp.free_pcppages_bulk
      0.13 ±  9%      -0.0        0.12        perf-profile.children.cycles-pp.tick_sched_timer
      0.37 ±  9%      -0.0        0.37 ±  5%  perf-profile.children.cycles-pp.xas_load
      0.49 ± 13%      -0.0        0.49        perf-profile.children.cycles-pp.__count_memcg_events
      0.09 ± 14%      -0.0        0.08 ±  5%  perf-profile.children.cycles-pp.lock_page_memcg
      0.06 ± 13%      -0.0        0.06 ±  8%  perf-profile.children.cycles-pp.xas_start
      0.06 ± 13%      -0.0        0.06 ±  8%  perf-profile.children.cycles-pp.task_tick_fair
      0.04 ± 71%      -0.0        0.03 ± 70%  perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.12 ± 10%      -0.0        0.11 ±  4%  perf-profile.children.cycles-pp.tick_sched_handle
      0.12 ± 10%      -0.0        0.11 ±  4%  perf-profile.children.cycles-pp.update_process_times
      0.11 ±  4%      -0.0        0.10 ±  4%  perf-profile.children.cycles-pp.xfs_bmapi_read
      0.11 ± 14%      -0.0        0.11 ±  4%  perf-profile.children.cycles-pp.mempool_alloc
      0.10 ± 22%      -0.0        0.10 ±  8%  perf-profile.children.cycles-pp.down_read_trylock
      0.16 ± 10%      +0.0        0.16 ±  5%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.14 ± 11%      +0.0        0.14 ±  3%  perf-profile.children.cycles-pp.xfs_iunlock
      0.09 ±  9%      +0.0        0.09        perf-profile.children.cycles-pp.do_shrink_slab
      0.07 ± 11%      +0.0        0.07        perf-profile.children.cycles-pp.page_counter_try_charge
      0.10 ± 19%      +0.0        0.10 ± 19%  perf-profile.children.cycles-pp.pagevec_lookup_entries
      0.10 ± 19%      +0.0        0.10 ± 19%  perf-profile.children.cycles-pp.find_get_entries
      0.06 ± 13%      +0.0        0.06        perf-profile.children.cycles-pp.bio_associate_blkg
      0.06 ± 14%      +0.0        0.06 ±  7%  perf-profile.children.cycles-pp.PageHuge
      0.06 ± 13%      +0.0        0.06 ± 72%  perf-profile.children.cycles-pp.shmem_write_begin
      0.06 ± 13%      +0.0        0.06 ± 72%  perf-profile.children.cycles-pp.shmem_getpage_gfp
      0.06 ± 13%      +0.0        0.06        perf-profile.children.cycles-pp.count_shadow_nodes
      0.05            +0.0        0.05        perf-profile.children.cycles-pp._find_next_bit
      0.02 ±141%      +0.0        0.02 ±141%  perf-profile.children.cycles-pp.bio_associate_blkg_from_css
      0.02 ±141%      +0.0        0.02 ±141%  perf-profile.children.cycles-pp.flush_tlb_func_common
      0.03 ±141%      +0.0        0.03 ±141%  perf-profile.children.cycles-pp.drain_local_pages_wq
      0.03 ±141%      +0.0        0.03 ±141%  perf-profile.children.cycles-pp.drain_pages_zone
      0.15 ± 14%      +0.0        0.15 ±  3%  perf-profile.children.cycles-pp.find_get_entry
      0.36 ± 10%      +0.0        0.36 ±  3%  perf-profile.children.cycles-pp.free_unref_page_list
      0.16 ± 10%      +0.0        0.17 ±  7%  perf-profile.children.cycles-pp.bio_alloc_bioset
      0.09 ±  9%      +0.0        0.09 ±  5%  perf-profile.children.cycles-pp.___perf_sw_event
      0.05 ±  8%      +0.0        0.06 ±  8%  perf-profile.children.cycles-pp.xas_clear_mark
      0.02 ±141%      +0.0        0.02 ±141%  perf-profile.children.cycles-pp.drain_pages
      0.09 ± 18%      +0.0        0.10 ±  4%  perf-profile.children.cycles-pp.mem_cgroup_charge_statistics
      0.08 ± 11%      +0.0        0.09 ±  5%  perf-profile.children.cycles-pp.scheduler_tick
      0.08 ± 11%      +0.0        0.09 ±  5%  perf-profile.children.cycles-pp.xfs_ilock_for_iomap
      0.07 ± 11%      +0.0        0.07 ± 12%  perf-profile.children.cycles-pp.workingset_refault
      0.14 ± 15%      +0.0        0.14 ±  3%  perf-profile.children.cycles-pp.__list_add_valid
      0.13 ± 12%      +0.0        0.14 ±  3%  perf-profile.children.cycles-pp.try_charge
      0.51 ±  9%      +0.0        0.51        perf-profile.children.cycles-pp.page_vma_mapped_walk
      0.32 ±  5%      +0.0        0.32        perf-profile.children.cycles-pp.xfs_read_iomap_begin
      0.21 ± 12%      +0.0        0.22 ±  3%  perf-profile.children.cycles-pp.xas_find
      0.07 ±  6%      +0.0        0.08        perf-profile.children.cycles-pp.lru_add_drain
      0.07 ±  6%      +0.0        0.08        perf-profile.children.cycles-pp.lru_add_drain_cpu
      0.12 ± 13%      +0.0        0.13        perf-profile.children.cycles-pp._cond_resched
      0.11 ± 11%      +0.0        0.12 ±  6%  perf-profile.children.cycles-pp.__sysvec_call_function
      0.11 ± 11%      +0.0        0.12 ±  6%  perf-profile.children.cycles-pp.flush_smp_call_function_queue
      0.09 ± 14%      +0.0        0.09 ±  5%  perf-profile.children.cycles-pp.__might_sleep
      0.09 ± 10%      +0.0        0.09 ± 10%  perf-profile.children.cycles-pp.xas_init_marks
      0.06 ± 14%      +0.0        0.07        perf-profile.children.cycles-pp.rcu_all_qs
      0.06 ±  7%      +0.0        0.07        perf-profile.children.cycles-pp.workingset_update_node
      0.06 ±  8%      +0.0        0.06 ±  7%  perf-profile.children.cycles-pp.page_counter_uncharge
      0.06 ±  8%      +0.0        0.06 ±  7%  perf-profile.children.cycles-pp.page_counter_cancel
      0.19 ± 12%      +0.0        0.20        perf-profile.children.cycles-pp.iomap_read_end_io
      0.16 ± 10%      +0.0        0.17        perf-profile.children.cycles-pp.___might_sleep
      0.12 ± 10%      +0.0        0.12 ±  3%  perf-profile.children.cycles-pp.__perf_sw_event
      0.14 ± 10%      +0.0        0.15 ±  3%  perf-profile.children.cycles-pp._raw_spin_unlock_irqrestore
      0.60 ± 13%      +0.0        0.61 ±  3%  perf-profile.children.cycles-pp.rmqueue
      0.29 ± 12%      +0.0        0.30        perf-profile.children.cycles-pp.up_read
      0.14 ± 15%      +0.0        0.15 ±  6%  perf-profile.children.cycles-pp.workingset_age_nonresident
      0.13 ± 12%      +0.0        0.14        perf-profile.children.cycles-pp.iomap_set_range_uptodate
      0.13 ±  9%      +0.0        0.14 ±  3%  perf-profile.children.cycles-pp.sysvec_call_function
      0.12 ± 11%      +0.0        0.13 ±  6%  perf-profile.children.cycles-pp.__mod_node_page_state
      0.09 ±  9%      +0.0        0.10        perf-profile.children.cycles-pp.mem_cgroup_uncharge_list
      0.07 ±  7%      +0.0        0.08 ±  6%  perf-profile.children.cycles-pp.uncharge_batch
      0.22 ± 13%      +0.0        0.23        perf-profile.children.cycles-pp.xas_create
      0.19 ±  8%      +0.0        0.21 ±  2%  perf-profile.children.cycles-pp.xfs_ilock
      0.10 ±  9%      +0.0        0.12 ±  4%  perf-profile.children.cycles-pp.page_mapping
      0.18 ±  9%      +0.0        0.19 ±  2%  perf-profile.children.cycles-pp.asm_sysvec_call_function
      0.15 ±  8%      +0.0        0.16 ±  5%  perf-profile.children.cycles-pp.__mod_lruvec_state
      0.08 ± 17%      +0.0        0.09 ±  5%  perf-profile.children.cycles-pp.blk_throtl_bio
      0.18 ± 14%      +0.0        0.19 ±  4%  perf-profile.children.cycles-pp.get_mem_cgroup_from_mm
      0.77 ± 13%      +0.0        0.79 ±  3%  perf-profile.children.cycles-pp.get_page_from_freelist
      0.28 ± 10%      +0.0        0.29 ±  3%  perf-profile.children.cycles-pp.__mod_memcg_state
      0.56 ± 11%      +0.0        0.58        perf-profile.children.cycles-pp.unlock_page
      0.36 ±  6%      +0.0        0.37 ±  3%  perf-profile.children.cycles-pp.iomap_readpage_actor
      0.24 ± 12%      +0.0        0.26        perf-profile.children.cycles-pp.sync_regs
      0.07 ± 11%      +0.0        0.09 ± 10%  perf-profile.children.cycles-pp.release_pages
      0.79 ± 11%      +0.0        0.81        perf-profile.children.cycles-pp.__list_del_entry_valid
      0.46 ± 12%      +0.0        0.48 ±  2%  perf-profile.children.cycles-pp.native_irq_return_iret
      0.28 ±  8%      +0.0        0.30 ±  2%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.02 ±141%      +0.0        0.04 ± 71%  perf-profile.children.cycles-pp.__libc_fork
      0.02 ±141%      +0.0        0.04 ± 71%  perf-profile.children.cycles-pp.__do_sys_clone
      0.02 ±141%      +0.0        0.04 ± 71%  perf-profile.children.cycles-pp._do_fork
      0.02 ±141%      +0.0        0.04 ± 71%  perf-profile.children.cycles-pp.copy_process
      0.58 ± 10%      +0.0        0.60        perf-profile.children.cycles-pp.page_referenced_one
      0.53 ± 13%      +0.0        0.55 ±  2%  perf-profile.children.cycles-pp.mem_cgroup_charge
      0.41 ±  9%      +0.0        0.43 ±  4%  perf-profile.children.cycles-pp.xas_store
      0.22 ±  7%      +0.0        0.24        perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.04 ± 71%      +0.0        0.06 ± 13%  perf-profile.children.cycles-pp.read_tsc
      0.03 ± 70%      +0.0        0.06 ± 16%  perf-profile.children.cycles-pp.kmem_cache_free
      0.12            +0.0        0.14 ± 14%  perf-profile.children.cycles-pp.unaccount_page_cache_page
      0.21 ±  9%      +0.0        0.24        perf-profile.children.cycles-pp.hrtimer_interrupt
      0.24 ±  9%      +0.0        0.27        perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.20 ± 11%      +0.0        0.23 ±  5%  perf-profile.children.cycles-pp.submit_bio_checks
      0.16 ±  2%      +0.0        0.19 ± 12%  perf-profile.children.cycles-pp.page_remove_rmap
      0.08 ± 14%      +0.0        0.11 ±  8%  perf-profile.children.cycles-pp.ktime_get
      0.73 ±  6%      +0.0        0.76 ±  2%  perf-profile.children.cycles-pp.iomap_apply
      0.54 ± 11%      +0.0        0.57        perf-profile.children.cycles-pp.down_read
      0.36 ± 10%      +0.0        0.39 ±  2%  perf-profile.children.cycles-pp.asm_call_sysvec_on_stack
      0.00            +0.0        0.03 ± 70%  perf-profile.children.cycles-pp.mem_cgroup_update_lru_size
      0.94 ± 10%      +0.0        0.98        perf-profile.children.cycles-pp.isolate_lru_pages
      0.00            +0.0        0.04 ± 71%  perf-profile.children.cycles-pp.clockevents_program_event
      0.26 ± 16%      +0.0        0.29 ±  7%  perf-profile.children.cycles-pp.workingset_eviction
      1.02 ± 11%      +0.0        1.06        perf-profile.children.cycles-pp.page_referenced
      0.45 ±  8%      +0.0        0.50 ±  5%  perf-profile.children.cycles-pp.__delete_from_page_cache
      0.33 ±  6%      +0.0        0.38 ±  9%  perf-profile.children.cycles-pp.page_add_file_rmap
      0.40 ±  8%      +0.1        0.45 ±  2%  perf-profile.children.cycles-pp.move_pages_to_lru
      0.16 ± 13%      +0.1        0.22 ±  5%  perf-profile.children.cycles-pp.smp_call_function_single
      0.62 ±  6%      +0.1        0.68 ±  3%  perf-profile.children.cycles-pp.try_to_unmap_one
      0.56 ±  8%      +0.1        0.62 ±  5%  perf-profile.children.cycles-pp.alloc_set_pte
      3.07 ± 15%      +0.1        3.14 ±  3%  perf-profile.children.cycles-pp.pmem_do_read
      0.81 ±  7%      +0.1        0.88 ±  3%  perf-profile.children.cycles-pp.try_to_unmap
      3.04 ± 15%      +0.1        3.11 ±  3%  perf-profile.children.cycles-pp.__memcpy_mcsafe
      1.12 ± 12%      +0.1        1.19        perf-profile.children.cycles-pp.__add_to_page_cache_locked
      3.45 ± 14%      +0.1        3.53 ±  3%  perf-profile.children.cycles-pp.pmem_submit_bio
      1.66 ±  9%      +0.1        1.75        perf-profile.children.cycles-pp.rmap_walk_file
      3.71 ± 14%      +0.1        3.82 ±  3%  perf-profile.children.cycles-pp.submit_bio
      3.70 ± 14%      +0.1        3.81 ±  3%  perf-profile.children.cycles-pp.submit_bio_noacct
      0.18 ± 28%      +0.1        0.29 ± 19%  perf-profile.children.cycles-pp.shrink_active_list
      0.58 ±  4%      +0.1        0.69 ±  9%  perf-profile.children.cycles-pp.__mod_memcg_lruvec_state
      1.61 ± 11%      +0.1        1.74 ±  4%  perf-profile.children.cycles-pp.__remove_mapping
      2.87 ± 16%      +0.1        3.00 ±  6%  perf-profile.children.cycles-pp.ret_from_fork
      2.87 ± 16%      +0.1        3.00 ±  6%  perf-profile.children.cycles-pp.kthread
      4.46 ± 13%      +0.1        4.60 ±  2%  perf-profile.children.cycles-pp.iomap_readpage
      0.00            +0.2        0.16 ±  7%  perf-profile.children.cycles-pp.lru_note_cost_unlock_irq
      2.76 ± 15%      +0.2        2.93 ±  7%  perf-profile.children.cycles-pp.kswapd
      2.76 ± 15%      +0.2        2.93 ±  7%  perf-profile.children.cycles-pp.balance_pgdat
      2.92 ± 10%      +0.2        3.10        perf-profile.children.cycles-pp.filemap_map_pages
      3.07 ± 10%      +0.2        3.26        perf-profile.children.cycles-pp.xfs_filemap_map_pages
     37.62 ±  9%      +0.7       38.31        perf-profile.children.cycles-pp.try_to_free_pages
     37.81 ±  9%      +0.7       38.50        perf-profile.children.cycles-pp.__alloc_pages_slowpath
     37.61 ±  9%      +0.7       38.30        perf-profile.children.cycles-pp.do_try_to_free_pages
     38.50 ± 10%      +0.7       39.21        perf-profile.children.cycles-pp.__alloc_pages_nodemask
     39.87 ± 10%      +0.8       40.62        perf-profile.children.cycles-pp.shrink_inactive_list
      2.38 ± 25%      +0.8        3.14 ± 21%  perf-profile.children.cycles-pp.deactivate_file_page
      2.37 ± 25%      +0.8        3.13 ± 21%  perf-profile.children.cycles-pp.pagevec_lru_move_fn
      2.72 ± 25%      +0.8        3.49 ± 21%  perf-profile.children.cycles-pp.__x64_sys_fadvise64
      2.72 ± 25%      +0.8        3.49 ± 21%  perf-profile.children.cycles-pp.ksys_fadvise64_64
      2.72 ± 25%      +0.8        3.49 ± 21%  perf-profile.children.cycles-pp.generic_fadvise
      2.72 ± 25%      +0.8        3.49 ± 21%  perf-profile.children.cycles-pp.invalidate_mapping_pages
      2.96 ± 23%      +0.8        3.74 ± 18%  perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
      2.96 ± 23%      +0.8        3.74 ± 18%  perf-profile.children.cycles-pp.do_syscall_64
     40.37 ± 10%      +0.9       41.22        perf-profile.children.cycles-pp.shrink_node
     40.07 ± 10%      +0.9       40.93        perf-profile.children.cycles-pp.shrink_lruvec
      3.92 ± 10%      +1.2        5.09        perf-profile.children.cycles-pp.smp_call_function_many_cond
      4.08 ± 10%      +1.2        5.31        perf-profile.children.cycles-pp.try_to_unmap_flush
      4.08 ± 10%      +1.2        5.31        perf-profile.children.cycles-pp.arch_tlbbatch_flush
      4.07 ± 10%      +1.2        5.30        perf-profile.children.cycles-pp.on_each_cpu_cond_mask
      8.45 ± 10%      +1.5        9.95        perf-profile.children.cycles-pp.shrink_page_list
     46.18 ±  9%      +2.3       48.47        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     13.95 ± 11%      +2.3       16.26 ±  3%  perf-profile.children.cycles-pp.lru_cache_add
     13.97 ± 11%      +2.3       16.29 ±  3%  perf-profile.children.cycles-pp.__pagevec_lru_add
     15.10 ± 11%      +2.4       17.48 ±  3%  perf-profile.children.cycles-pp.add_to_page_cache_lru
     15.55 ±  8%      +3.0       18.53        perf-profile.children.cycles-pp.lock_page_lruvec_irqsave
     16.20 ±  8%      +3.0       19.21        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     53.68 ± 10%      +3.1       56.78        perf-profile.children.cycles-pp.pagecache_get_page
     58.49 ± 10%      +3.2       61.72        perf-profile.children.cycles-pp.filemap_fault
     58.60 ± 10%      +3.2       61.84        perf-profile.children.cycles-pp.__xfs_filemap_fault
     58.63 ± 10%      +3.3       61.88        perf-profile.children.cycles-pp.__do_fault
     61.85 ± 10%      +3.5       65.30        perf-profile.children.cycles-pp.do_fault
     62.59 ± 10%      +3.5       66.05        perf-profile.children.cycles-pp.handle_mm_fault
     62.09 ± 10%      +3.5       65.56        perf-profile.children.cycles-pp.__handle_mm_fault
     62.91 ± 10%      +3.5       66.38        perf-profile.children.cycles-pp.exc_page_fault
     62.88 ± 10%      +3.5       66.35        perf-profile.children.cycles-pp.do_user_addr_fault
     62.97 ± 10%      +3.5       66.45        perf-profile.children.cycles-pp.asm_exc_page_fault
     30.46 ± 22%      -4.5       26.01        perf-profile.self.cycles-pp.intel_idle
      0.03 ± 70%      -0.0        0.00        perf-profile.self.cycles-pp.ptep_clear_flush_young
      0.02 ±141%      -0.0        0.00        perf-profile.self.cycles-pp.update_sd_lb_stats
      0.16 ± 10%      -0.0        0.14 ±  5%  perf-profile.self.cycles-pp._raw_spin_lock_irq
      0.03 ± 70%      -0.0        0.02 ±141%  perf-profile.self.cycles-pp.lru_cache_add
      0.03 ± 70%      -0.0        0.02 ±141%  perf-profile.self.cycles-pp.xfs_iunlock
      0.03 ± 70%      -0.0        0.02 ±141%  perf-profile.self.cycles-pp.__mod_zone_page_state
      0.02 ±141%      -0.0        0.00        perf-profile.self.cycles-pp.count_shadow_nodes
      0.07 ± 11%      -0.0        0.06        perf-profile.self.cycles-pp.kmem_cache_alloc
      0.49 ± 13%      -0.0        0.49        perf-profile.self.cycles-pp.__count_memcg_events
      0.06 ± 16%      -0.0        0.05        perf-profile.self.cycles-pp.xas_start
      0.32 ±  9%      -0.0        0.31 ±  5%  perf-profile.self.cycles-pp.xas_load
      0.14 ± 15%      -0.0        0.13 ±  3%  perf-profile.self.cycles-pp.__list_add_valid
      0.09 ± 14%      -0.0        0.08 ±  5%  perf-profile.self.cycles-pp.lock_page_memcg
      0.04 ± 71%      -0.0        0.03 ± 70%  perf-profile.self.cycles-pp.percpu_counter_add_batch
      0.18 ±  9%      -0.0        0.18 ±  4%  perf-profile.self.cycles-pp.filemap_fault
      0.16 ± 10%      +0.0        0.16 ±  5%  perf-profile.self.cycles-pp.free_pcppages_bulk
      0.06 ± 13%      +0.0        0.06 ± 13%  perf-profile.self.cycles-pp.do_user_addr_fault
      0.06 ± 14%      +0.0        0.06 ±  7%  perf-profile.self.cycles-pp.xfs_read_iomap_begin
      0.05 ±  8%      +0.0        0.05 ±  8%  perf-profile.self.cycles-pp.__alloc_pages_nodemask
      0.03 ± 70%      +0.0        0.03 ± 70%  perf-profile.self.cycles-pp.shrink_slab
      0.02 ±141%      +0.0        0.02 ±141%  perf-profile.self.cycles-pp.flush_smp_call_function_queue
      0.02 ±141%      +0.0        0.02 ±141%  perf-profile.self.cycles-pp.bio_associate_blkg_from_css
      0.02 ±141%      +0.0        0.02 ±141%  perf-profile.self.cycles-pp.invalidate_mapping_pages
      0.07 ± 12%      +0.0        0.07 ±  6%  perf-profile.self.cycles-pp.___perf_sw_event
      0.10 ± 21%      +0.0        0.10 ±  8%  perf-profile.self.cycles-pp.down_read_trylock
      0.15 ± 16%      +0.0        0.16 ±  6%  perf-profile.self.cycles-pp.get_page_from_freelist
      0.06 ±  7%      +0.0        0.07 ±  7%  perf-profile.self.cycles-pp.page_counter_try_charge
      0.05 ±  8%      +0.0        0.06 ±  8%  perf-profile.self.cycles-pp._raw_spin_unlock_irqrestore
      0.08 ± 16%      +0.0        0.08        perf-profile.self.cycles-pp.rmap_walk_file
      0.07 ±  7%      +0.0        0.07        perf-profile.self.cycles-pp.do_fault
      0.32 ± 10%      +0.0        0.32        perf-profile.self.cycles-pp.page_vma_mapped_walk
      0.19 ± 11%      +0.0        0.20 ±  2%  perf-profile.self.cycles-pp._raw_spin_lock
      0.10 ±  8%      +0.0        0.11 ±  4%  perf-profile.self.cycles-pp.page_mapping
      0.05 ±  8%      +0.0        0.06        perf-profile.self.cycles-pp.xas_find
      0.08 ± 16%      +0.0        0.08 ±  5%  perf-profile.self.cycles-pp.__might_sleep
      0.07 ± 11%      +0.0        0.08 ±  6%  perf-profile.self.cycles-pp.rmqueue
      0.06 ± 13%      +0.0        0.07 ±  7%  perf-profile.self.cycles-pp.pmem_submit_bio
      0.07            +0.0        0.08 ±  6%  perf-profile.self.cycles-pp.iomap_readpage_actor
      0.06 ± 14%      +0.0        0.07        perf-profile.self.cycles-pp.try_charge
      0.20 ± 14%      +0.0        0.20 ±  2%  perf-profile.self.cycles-pp.xas_create
      0.08 ±  5%      +0.0        0.09 ±  9%  perf-profile.self.cycles-pp.xas_store
      0.08 ± 24%      +0.0        0.09 ± 18%  perf-profile.self.cycles-pp.find_get_entries
      0.15 ± 14%      +0.0        0.16 ±  3%  perf-profile.self.cycles-pp.handle_mm_fault
      0.29 ± 12%      +0.0        0.30        perf-profile.self.cycles-pp.up_read
      0.16 ± 13%      +0.0        0.17 ±  2%  perf-profile.self.cycles-pp.alloc_set_pte
      0.16 ± 13%      +0.0        0.17 ±  2%  perf-profile.self.cycles-pp.___might_sleep
      0.14 ± 15%      +0.0        0.15 ±  6%  perf-profile.self.cycles-pp.workingset_age_nonresident
      0.14 ± 10%      +0.0        0.15        perf-profile.self.cycles-pp.page_referenced_one
      0.13 ±  9%      +0.0        0.14 ±  3%  perf-profile.self.cycles-pp.iomap_set_range_uptodate
      0.11 ± 14%      +0.0        0.12 ±  3%  perf-profile.self.cycles-pp.mem_cgroup_charge
      0.09 ± 10%      +0.0        0.10 ±  4%  perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.12 ± 10%      +0.0        0.13 ±  3%  perf-profile.self.cycles-pp.__mod_node_page_state
      0.24 ± 12%      +0.0        0.25        perf-profile.self.cycles-pp.sync_regs
      0.06 ±  7%      +0.0        0.08 ± 16%  perf-profile.self.cycles-pp.page_remove_rmap
      0.04 ± 71%      +0.0        0.05        perf-profile.self.cycles-pp._cond_resched
      0.20 ± 14%      +0.0        0.21 ±  2%  perf-profile.self.cycles-pp.__remove_mapping
      0.18 ± 14%      +0.0        0.19 ±  4%  perf-profile.self.cycles-pp.get_mem_cgroup_from_mm
      0.27 ± 10%      +0.0        0.28 ±  3%  perf-profile.self.cycles-pp.__mod_memcg_state
      0.04 ± 70%      +0.0        0.06 ±  8%  perf-profile.self.cycles-pp.iomap_apply
      0.04 ± 70%      +0.0        0.06 ±  8%  perf-profile.self.cycles-pp.PageHuge
      0.04 ± 70%      +0.0        0.06 ±  8%  perf-profile.self.cycles-pp.page_counter_cancel
      0.02 ±141%      +0.0        0.03 ± 70%  perf-profile.self.cycles-pp._find_next_bit
      0.00            +0.0        0.02 ±141%  perf-profile.self.cycles-pp.lru_note_cost_unlock_irq
      0.00            +0.0        0.02 ±141%  perf-profile.self.cycles-pp.blk_throtl_bio
      0.00            +0.0        0.02 ±141%  perf-profile.self.cycles-pp.xfs_bmapi_read
      0.04 ± 71%      +0.0        0.05 ±  8%  perf-profile.self.cycles-pp.xas_clear_mark
      0.03 ± 70%      +0.0        0.05        perf-profile.self.cycles-pp.rcu_all_qs
      0.54 ± 11%      +0.0        0.56        perf-profile.self.cycles-pp.unlock_page
      0.27 ± 12%      +0.0        0.28        perf-profile.self.cycles-pp.try_to_unmap_one
      0.53 ±  9%      +0.0        0.55 ±  2%  perf-profile.self.cycles-pp.isolate_lru_pages
      0.30 ± 11%      +0.0        0.32        perf-profile.self.cycles-pp.shrink_page_list
      0.03 ± 70%      +0.0        0.05 ±  8%  perf-profile.self.cycles-pp.unaccount_page_cache_page
      0.21 ±  9%      +0.0        0.23 ±  3%  perf-profile.self.cycles-pp.__handle_mm_fault
      0.04 ± 71%      +0.0        0.06 ± 13%  perf-profile.self.cycles-pp.read_tsc
      0.13 ± 16%      +0.0        0.15 ±  8%  perf-profile.self.cycles-pp.workingset_eviction
      0.46 ± 13%      +0.0        0.48 ±  2%  perf-profile.self.cycles-pp.native_irq_return_iret
      0.38 ± 11%      +0.0        0.40        perf-profile.self.cycles-pp.down_read
      0.78 ± 12%      +0.0        0.80        perf-profile.self.cycles-pp.__list_del_entry_valid
      0.11 ±  7%      +0.0        0.14 ± 13%  perf-profile.self.cycles-pp.page_add_file_rmap
      0.00            +0.0        0.03 ± 70%  perf-profile.self.cycles-pp.mem_cgroup_update_lru_size
      0.02 ±141%      +0.0        0.05 ±  8%  perf-profile.self.cycles-pp.release_pages
      0.17 ±  2%      +0.0        0.21 ±  6%  perf-profile.self.cycles-pp.__add_to_page_cache_locked
      0.00            +0.0        0.04 ± 73%  perf-profile.self.cycles-pp.ktime_get
      0.25 ±  9%      +0.0        0.30        perf-profile.self.cycles-pp.move_pages_to_lru
      0.39 ±  8%      +0.1        0.44        perf-profile.self.cycles-pp.__pagevec_lru_add
      0.15 ± 16%      +0.1        0.21 ±  5%  perf-profile.self.cycles-pp.smp_call_function_single
      3.01 ± 15%      +0.1        3.08 ±  3%  perf-profile.self.cycles-pp.__memcpy_mcsafe
      1.76 ± 10%      +0.1        1.86        perf-profile.self.cycles-pp.filemap_map_pages
      0.30 ±  5%      +0.1        0.40 ± 16%  perf-profile.self.cycles-pp.__mod_memcg_lruvec_state
      3.81 ± 10%      +1.2        4.97        perf-profile.self.cycles-pp.smp_call_function_many_cond
     46.18 ±  9%      +2.3       48.47        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
    352.67            -0.2%     352.00        softirqs.BLOCK
      0.00       +1.6e+103%      16.00 ± 93%  softirqs.CPU0.BLOCK
      1.00            +0.0%       1.00        softirqs.CPU0.HI
      8.67 ± 73%     +34.6%      11.67 ±123%  softirqs.CPU0.NET_RX
     43.00 ±139%      -1.6%      42.33 ±139%  softirqs.CPU0.NET_TX
     32687 ± 21%     +16.5%      38080 ± 11%  softirqs.CPU0.RCU
     88801 ±  2%      +6.5%      94558 ±  3%  softirqs.CPU0.SCHED
    108.33 ±  4%      -1.5%     106.67 ±  2%  softirqs.CPU0.TASKLET
      6472 ± 20%      -8.3%       5933 ±  4%  softirqs.CPU0.TIMER
      0.00       +4.7e+102%       4.67 ±112%  softirqs.CPU1.BLOCK
    545.67 ±140%     -99.5%       3.00 ± 72%  softirqs.CPU1.NET_RX
      0.67 ±141%     +50.0%       1.00        softirqs.CPU1.NET_TX
     29769 ± 18%      +2.0%      30356 ±  7%  softirqs.CPU1.RCU
     71268 ±  5%     +23.7%      88185 ±  4%  softirqs.CPU1.SCHED
      6.67 ±141%     -90.0%       0.67 ± 70%  softirqs.CPU1.TASKLET
      1701 ± 19%     +18.1%       2008 ± 14%  softirqs.CPU1.TIMER
      4.00 ±141%    +250.0%      14.00 ±141%  softirqs.CPU10.BLOCK
      1.33 ± 35%     -25.0%       1.00        softirqs.CPU10.HI
      4.00 ± 93%    -100.0%       0.00        softirqs.CPU10.NET_RX
      1.00 ± 81%    -100.0%       0.00        softirqs.CPU10.NET_TX
     22360 ±  2%     +10.9%      24800        softirqs.CPU10.RCU
     60048 ±  6%      -1.3%      59269 ± 25%  softirqs.CPU10.SCHED
     37.00 ±  3%      -2.7%      36.00        softirqs.CPU10.TASKLET
      1332 ± 36%    +119.9%       2930 ± 74%  softirqs.CPU10.TIMER
      4.67 ±141%     -92.9%       0.33 ±141%  softirqs.CPU11.BLOCK
     54.33 ±107%     -11.0%      48.33 ±132%  softirqs.CPU11.NET_RX
      1.33 ± 93%     -50.0%       0.67 ± 70%  softirqs.CPU11.NET_TX
     22011 ±  2%      +2.4%      22549 ±  2%  softirqs.CPU11.RCU
     69178 ± 15%      -9.5%      62640 ± 11%  softirqs.CPU11.SCHED
      2.00           -33.3%       1.33 ± 70%  softirqs.CPU11.TASKLET
      4545 ±104%     -29.3%       3213 ± 32%  softirqs.CPU11.TIMER
     14.33 ±136%    -100.0%       0.00        softirqs.CPU12.NET_RX
      0.00          -100.0%       0.00        softirqs.CPU12.NET_TX
     22928 ±  8%      -2.1%      22439 ±  4%  softirqs.CPU12.RCU
     59151 ± 14%     +10.0%      65088 ±  7%  softirqs.CPU12.SCHED
      2.00            +0.0%       2.00        softirqs.CPU12.TASKLET
      1219 ±  6%     -14.3%       1044 ± 27%  softirqs.CPU12.TIMER
      0.00       +2.7e+102%       2.67 ±141%  softirqs.CPU13.BLOCK
      2.33 ± 20%     +14.3%       2.67 ± 93%  softirqs.CPU13.NET_RX
      1.00            +0.0%       1.00 ±141%  softirqs.CPU13.NET_TX
     22275 ±  6%      +1.2%      22541 ±  3%  softirqs.CPU13.RCU
     63055 ±  9%     +10.3%      69535 ± 12%  softirqs.CPU13.SCHED
      2.33 ± 20%     +14.3%       2.67 ± 35%  softirqs.CPU13.TASKLET
      2398 ± 53%      -4.8%       2284 ± 83%  softirqs.CPU13.TIMER
     13.33 ± 86%     -95.0%       0.67 ±141%  softirqs.CPU14.BLOCK
      3.67 ± 34%     -27.3%       2.67 ± 77%  softirqs.CPU14.NET_RX
      1.00           +33.3%       1.33 ± 70%  softirqs.CPU14.NET_TX
     21091 ±  5%      +5.7%      22302 ±  5%  softirqs.CPU14.RCU
     71609 ± 11%     -16.9%      59516 ± 19%  softirqs.CPU14.SCHED
      1.33 ± 70%    +125.0%       3.00 ± 27%  softirqs.CPU14.TASKLET
      1833 ± 34%     -22.4%       1422 ± 80%  softirqs.CPU14.TIMER
      2.67 ±141%    -100.0%       0.00        softirqs.CPU15.BLOCK
      5.00 ± 43%     +80.0%       9.00 ± 65%  softirqs.CPU15.NET_RX
      1.33 ± 93%     -50.0%       0.67 ±141%  softirqs.CPU15.NET_TX
     21562 ±  8%      -0.7%      21418 ±  3%  softirqs.CPU15.RCU
     62199 ± 15%     +22.0%      75862 ±  8%  softirqs.CPU15.SCHED
      2.33 ± 20%      +0.0%       2.33 ± 20%  softirqs.CPU15.TASKLET
      1772 ± 24%     +10.5%       1959 ± 13%  softirqs.CPU15.TIMER
      9.33 ±141%    -100.0%       0.00        softirqs.CPU16.BLOCK
      1.67 ±101%     +40.0%       2.33 ±112%  softirqs.CPU16.NET_RX
      1.00 ± 81%     -33.3%       0.67 ±141%  softirqs.CPU16.NET_TX
     20327            +8.2%      21999 ±  6%  softirqs.CPU16.RCU
     68518 ±  8%      +2.5%      70202 ± 17%  softirqs.CPU16.SCHED
      2.00           -33.3%       1.33 ± 70%  softirqs.CPU16.TASKLET
      2310 ± 27%     -30.8%       1598 ± 25%  softirqs.CPU16.TIMER
     66.00 ± 91%     -53.0%      31.00 ±141%  softirqs.CPU17.BLOCK
      4.00 ± 70%    +775.0%      35.00 ±135%  softirqs.CPU17.NET_RX
      1.00 ± 81%      +0.0%       1.00 ± 81%  softirqs.CPU17.NET_TX
     21046 ±  3%      +5.3%      22169 ±  2%  softirqs.CPU17.RCU
     65866            -1.7%      64752 ±  5%  softirqs.CPU17.SCHED
      1.67 ± 74%     -40.0%       1.00 ±141%  softirqs.CPU17.TASKLET
      1087 ±  4%     +95.6%       2127 ± 40%  softirqs.CPU17.TIMER
     38.00 ±141%      +4.4%      39.67 ±141%  softirqs.CPU18.BLOCK
      2.67 ± 46%  +3.2e+05%       8647 ±141%  softirqs.CPU18.NET_RX
      1.00 ± 81%     +33.3%       1.33 ± 70%  softirqs.CPU18.NET_TX
     21598 ±  5%     +15.3%      24902 ± 10%  softirqs.CPU18.RCU
     76140 ±  9%     -13.9%      65570 ±  8%  softirqs.CPU18.SCHED
      0.67 ±141%      +0.0%       0.67 ± 70%  softirqs.CPU18.TASKLET
      1821 ± 15%     +66.2%       3026 ± 99%  softirqs.CPU18.TIMER
     49.67 ±141%     -60.4%      19.67 ±141%  softirqs.CPU19.BLOCK
      9.00 ± 94%     -88.9%       1.00 ±141%  softirqs.CPU19.NET_RX
      1.67 ± 74%     -80.0%       0.33 ±141%  softirqs.CPU19.NET_TX
     21110 ±  7%      +6.6%      22495 ±  6%  softirqs.CPU19.RCU
     61449 ± 15%      -0.5%      61131 ± 12%  softirqs.CPU19.SCHED
      0.00       +6.7e+101%       0.67 ±141%  softirqs.CPU19.TASKLET
      2216 ± 55%      -8.0%       2038 ± 16%  softirqs.CPU19.TIMER
      3.00 ± 94%   +1555.6%      49.67 ±127%  softirqs.CPU2.NET_RX
      0.33 ±141%    +300.0%       1.33 ± 35%  softirqs.CPU2.NET_TX
     21181 ±  5%     +10.4%      23388 ±  4%  softirqs.CPU2.RCU
     79565 ± 11%      -8.5%      72784 ±  7%  softirqs.CPU2.SCHED
      0.67 ±141%    -100.0%       0.00        softirqs.CPU2.TASKLET
      2333 ± 40%     -40.6%       1387 ± 66%  softirqs.CPU2.TIMER
      2.67 ±141%    -100.0%       0.00        softirqs.CPU20.BLOCK
      1.67 ± 56%     -20.0%       1.33 ± 35%  softirqs.CPU20.NET_RX
      1.00 ± 81%     -66.7%       0.33 ±141%  softirqs.CPU20.NET_TX
     22783 ±  4%      +1.5%      23127 ±  2%  softirqs.CPU20.RCU
     55917 ±  7%     +10.7%      61927 ±  6%  softirqs.CPU20.SCHED
      0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU20.TASKLET
      1043 ± 46%    +217.3%       3311 ± 61%  softirqs.CPU20.TIMER
      5.67 ± 54%   +1817.6%     108.67 ±139%  softirqs.CPU21.NET_RX
      0.67 ± 70%     +50.0%       1.00 ±141%  softirqs.CPU21.NET_TX
     22790            +1.4%      23101        softirqs.CPU21.RCU
     50528 ±  4%     +20.8%      61018 ±  9%  softirqs.CPU21.SCHED
      0.67 ±141%    -100.0%       0.00        softirqs.CPU21.TASKLET
      1175 ± 44%     +69.0%       1985 ± 46%  softirqs.CPU21.TIMER
      2.00 ± 70%   +3433.3%      70.67 ±111%  softirqs.CPU22.NET_RX
      0.67 ± 70%     +50.0%       1.00 ± 81%  softirqs.CPU22.NET_TX
     22012 ±  4%      +6.7%      23479 ±  4%  softirqs.CPU22.RCU
     57664 ±  7%      +6.9%      61668 ± 12%  softirqs.CPU22.SCHED
      0.33 ±141%    +400.0%       1.67 ± 74%  softirqs.CPU22.TASKLET
      1590 ± 21%     +13.4%       1804 ± 43%  softirqs.CPU22.TIMER
      0.00       +5.3e+102%       5.33 ± 70%  softirqs.CPU23.BLOCK
      2.00         +2316.7%      48.33 ±132%  softirqs.CPU23.NET_RX
      0.67 ± 70%    +150.0%       1.67 ± 56%  softirqs.CPU23.NET_TX
     24711 ± 10%      -4.6%      23562 ±  7%  softirqs.CPU23.RCU
     54407 ±  6%      +4.9%      57051 ± 14%  softirqs.CPU23.SCHED
      0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU23.TASKLET
      1844 ± 58%     +37.1%       2527 ±  6%  softirqs.CPU23.TIMER
      1.00 ±141%    -100.0%       0.00        softirqs.CPU24.BLOCK
     38.33 ±132%    +422.6%     200.33 ± 78%  softirqs.CPU24.NET_RX
      1.33 ±141%     +75.0%       2.33 ± 72%  softirqs.CPU24.NET_TX
     22937 ±  6%      -3.2%      22196 ±  7%  softirqs.CPU24.RCU
     72769 ±  4%      +7.9%      78514 ± 20%  softirqs.CPU24.SCHED
      0.33 ±141%    +900.0%       3.33 ±141%  softirqs.CPU24.TASKLET
      3419 ± 76%     +45.4%       4972 ±100%  softirqs.CPU24.TIMER
      9.00 ±141%    -100.0%       0.00        softirqs.CPU25.BLOCK
      8739 ±138%     -99.8%      14.33 ±122%  softirqs.CPU25.NET_RX
      0.33 ±141%    +100.0%       0.67 ± 70%  softirqs.CPU25.NET_TX
     23915 ±  4%      -1.0%      23678 ±  7%  softirqs.CPU25.RCU
     72022 ± 15%      -7.1%      66891 ±  6%  softirqs.CPU25.SCHED
      0.33 ±141%    -100.0%       0.00        softirqs.CPU25.TASKLET
      1338 ± 50%     +35.4%       1811 ± 73%  softirqs.CPU25.TIMER
      8.33 ± 70%    -100.0%       0.00        softirqs.CPU26.BLOCK
      0.00         +4e+102%       4.00 ±124%  softirqs.CPU26.NET_RX
      0.00       +6.7e+101%       0.67 ±141%  softirqs.CPU26.NET_TX
     21745 ±  6%      +1.0%      21973        softirqs.CPU26.RCU
     68345 ± 23%      +7.0%      73098 ± 10%  softirqs.CPU26.SCHED
      3.00 ± 47%    +144.4%       7.33 ±102%  softirqs.CPU26.TASKLET
      1877 ± 56%      +8.7%       2041 ± 16%  softirqs.CPU26.TIMER
      5.00 ±141%    -100.0%       0.00        softirqs.CPU27.BLOCK
     71.67 ±138%     -97.2%       2.00 ± 40%  softirqs.CPU27.NET_RX
      1.00 ± 81%     -66.7%       0.33 ±141%  softirqs.CPU27.NET_TX
     22462 ±  5%      +0.8%      22637 ±  6%  softirqs.CPU27.RCU
     79157 ± 10%     -17.9%      65014 ±  9%  softirqs.CPU27.SCHED
      2.00          +133.3%       4.67 ± 66%  softirqs.CPU27.TASKLET
      1107 ± 17%     +30.1%       1441 ±  3%  softirqs.CPU27.TIMER
      8.00 ±115%     -87.5%       1.00 ± 81%  softirqs.CPU28.NET_RX
      0.00          -100.0%       0.00        softirqs.CPU28.NET_TX
     21787 ±  7%      +4.1%      22675 ±  2%  softirqs.CPU28.RCU
     79977 ±  4%     -13.7%      69049        softirqs.CPU28.SCHED
      3.00 ± 47%    +311.1%      12.33 ±118%  softirqs.CPU28.TASKLET
      2135 ± 39%     -18.5%       1739 ± 39%  softirqs.CPU28.TIMER
     12.33 ± 53%     -78.4%       2.67 ± 88%  softirqs.CPU29.NET_RX
     42.67 ±138%     -98.4%       0.67 ± 70%  softirqs.CPU29.NET_TX
     22178 ±  6%      +4.7%      23223 ±  6%  softirqs.CPU29.RCU
     78116 ±  8%     -25.4%      58242 ± 15%  softirqs.CPU29.SCHED
      1.33 ± 70%     +50.0%       2.00        softirqs.CPU29.TASKLET
      4898 ±120%     -71.9%       1376 ± 34%  softirqs.CPU29.TIMER
      2.33 ± 53%  +7.1e+05%      16483 ±141%  softirqs.CPU3.NET_RX
      0.67 ± 70%    -100.0%       0.00        softirqs.CPU3.NET_TX
     21693 ±  4%      +4.0%      22565 ±  4%  softirqs.CPU3.RCU
     70992 ±  6%     +11.3%      79042 ±  8%  softirqs.CPU3.SCHED
      3184 ± 26%     -67.0%       1050 ± 44%  softirqs.CPU3.TIMER
      0.67 ±141%    +500.0%       4.00 ±141%  softirqs.CPU30.BLOCK
      3.33 ±141%     -60.0%       1.33 ± 93%  softirqs.CPU30.NET_RX
      0.00          -100.0%       0.00        softirqs.CPU30.NET_TX
     20992 ±  5%      +6.0%      22260 ±  4%  softirqs.CPU30.RCU
     76231 ±  7%      -8.6%      69647 ± 14%  softirqs.CPU30.SCHED
      1.33 ± 70%      +0.0%       1.33 ± 70%  softirqs.CPU30.TASKLET
      1950 ± 47%     +31.5%       2563 ± 40%  softirqs.CPU30.TIMER
      0.33 ±141%    +400.0%       1.67 ± 74%  softirqs.CPU31.NET_RX
      0.33 ±141%      +0.0%       0.33 ±141%  softirqs.CPU31.NET_TX
     24092 ±  3%      -0.9%      23885 ±  5%  softirqs.CPU31.RCU
     47562 ±  7%     +30.6%      62125 ± 10%  softirqs.CPU31.SCHED
      2.00          +100.0%       4.00 ± 70%  softirqs.CPU31.TASKLET
      1119 ±  7%     +73.9%       1946 ± 63%  softirqs.CPU31.TIMER
      8.67 ±141%    -100.0%       0.00        softirqs.CPU32.BLOCK
      4423 ±141%    -100.0%       1.67 ± 74%  softirqs.CPU32.NET_RX
      0.00          -100.0%       0.00        softirqs.CPU32.NET_TX
     23500 ±  6%      +2.7%      24138 ±  2%  softirqs.CPU32.RCU
     59614            -9.2%      54138 ±  3%  softirqs.CPU32.SCHED
      2.33 ± 20%     -14.3%       2.00        softirqs.CPU32.TASKLET
      1947 ± 89%     -37.4%       1218 ± 36%  softirqs.CPU32.TIMER
      4.00 ±141%    -100.0%       0.00        softirqs.CPU33.BLOCK
      0.67 ±141%  +87100.0%     581.33 ±141%  softirqs.CPU33.NET_RX
      0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU33.NET_TX
     21958            +4.2%      22882        softirqs.CPU33.RCU
     62720 ±  9%      -2.7%      61004 ± 17%  softirqs.CPU33.SCHED
      3.33 ± 56%    +240.0%      11.33 ±129%  softirqs.CPU33.TASKLET
      1701 ± 36%     +35.3%       2301 ± 85%  softirqs.CPU33.TIMER
      4.00 ±141%     -83.3%       0.67 ±141%  softirqs.CPU34.NET_RX
     42.00 ±141%     -99.2%       0.33 ±141%  softirqs.CPU34.NET_TX
     23176 ±  3%      -0.2%      23123 ±  7%  softirqs.CPU34.RCU
     66882 ±  5%     -13.7%      57686 ± 12%  softirqs.CPU34.SCHED
      0.67 ±141%    +100.0%       1.33 ± 70%  softirqs.CPU34.TASKLET
      1437 ± 52%     +45.7%       2094 ± 56%  softirqs.CPU34.TIMER
      2.00 ± 70%     -50.0%       1.00 ± 81%  softirqs.CPU35.NET_RX
      0.00          -100.0%       0.00        softirqs.CPU35.NET_TX
     22195 ±  4%      +8.4%      24068 ±  2%  softirqs.CPU35.RCU
     62312 ±  5%     -19.4%      50217 ± 10%  softirqs.CPU35.SCHED
      1.00 ± 81%    -100.0%       0.00        softirqs.CPU35.TASKLET
      1622 ± 63%     -55.5%     721.33 ± 23%  softirqs.CPU35.TIMER
      3.00 ± 81%     -22.2%       2.33 ±141%  softirqs.CPU36.NET_RX
      1.33 ± 93%     -50.0%       0.67 ±141%  softirqs.CPU36.NET_TX
     22423 ±  4%      +2.5%      22978 ±  3%  softirqs.CPU36.RCU
     57070 ± 21%     +17.4%      67020 ±  3%  softirqs.CPU36.SCHED
      0.00          -100.0%       0.00        softirqs.CPU36.TASKLET
    915.67 ± 21%     +84.8%       1692 ± 58%  softirqs.CPU36.TIMER
      0.00         +1e+102%       1.00 ±141%  softirqs.CPU37.NET_RX
      0.00          -100.0%       0.00        softirqs.CPU37.NET_TX
     22657 ±  8%      -0.4%      22564 ±  3%  softirqs.CPU37.RCU
     61516 ± 21%      -0.0%      61486 ±  7%  softirqs.CPU37.SCHED
      1959 ± 52%     -33.9%       1295 ± 47%  softirqs.CPU37.TIMER
      0.67 ±141%     +50.0%       1.00 ±141%  softirqs.CPU38.NET_RX
      0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU38.NET_TX
     21523 ± 10%      +9.4%      23557 ±  2%  softirqs.CPU38.RCU
     68089 ± 24%     -14.5%      58220 ±  2%  softirqs.CPU38.SCHED
      1495 ± 40%     +21.4%       1815 ± 30%  softirqs.CPU38.TIMER
      0.00         +9e+102%       9.00 ±141%  softirqs.CPU39.BLOCK
      0.67 ± 70%  +88050.0%     587.67 ±141%  softirqs.CPU39.NET_RX
      0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU39.NET_TX
     22456 ±  6%      +7.4%      24114 ±  5%  softirqs.CPU39.RCU
     63262 ±  9%     -15.1%      53690 ± 14%  softirqs.CPU39.SCHED
      2215 ± 34%     -48.6%       1138 ± 47%  softirqs.CPU39.TIMER
      4.00 ±141%    -100.0%       0.00        softirqs.CPU4.BLOCK
      1.67 ± 56%      +0.0%       1.67 ± 28%  softirqs.CPU4.NET_RX
      0.67 ± 70%    -100.0%       0.00        softirqs.CPU4.NET_TX
     20911 ±  6%      +8.9%      22781 ±  4%  softirqs.CPU4.RCU
     81029 ±  6%     -28.9%      57637 ±  6%  softirqs.CPU4.SCHED
      0.00         +1e+102%       1.00 ± 81%  softirqs.CPU4.TASKLET
      3961 ± 25%     -64.0%       1427 ± 60%  softirqs.CPU4.TIMER
      0.00       +2.4e+103%      23.67 ±135%  softirqs.CPU40.BLOCK
      0.67 ±141%   +2050.0%      14.33 ±141%  softirqs.CPU40.NET_RX
      0.00          -100.0%       0.00        softirqs.CPU40.NET_TX
     22518 ±  7%      +8.1%      24353 ± 10%  softirqs.CPU40.RCU
     64781 ±  6%      -8.5%      59264 ± 15%  softirqs.CPU40.SCHED
      2601 ± 39%     -24.3%       1968 ± 32%  softirqs.CPU40.TIMER
     22723 ±  3%      -2.7%      22099        softirqs.CPU41.RCU
     62167 ± 10%      -6.7%      58013 ± 10%  softirqs.CPU41.SCHED
      1333 ± 34%     +13.6%       1514 ± 37%  softirqs.CPU41.TIMER
      0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU42.NET_RX
      0.00          -100.0%       0.00        softirqs.CPU42.NET_TX
     20783 ±  6%      +9.5%      22762 ±  5%  softirqs.CPU42.RCU
     62686 ±  7%      -1.8%      61533 ± 13%  softirqs.CPU42.SCHED
      0.33 ±141%    -100.0%       0.00        softirqs.CPU42.TASKLET
      1978 ± 29%      -0.6%       1966 ± 72%  softirqs.CPU42.TIMER
     14.33 ±141%    -100.0%       0.00        softirqs.CPU43.BLOCK
      0.00       +6.7e+101%       0.67 ±141%  softirqs.CPU43.NET_RX
      0.00          -100.0%       0.00        softirqs.CPU43.NET_TX
     21743 ±  7%      +5.9%      23036 ±  4%  softirqs.CPU43.RCU
     61037 ±  3%      -3.0%      59210 ±  4%  softirqs.CPU43.SCHED
      1.67 ±141%    -100.0%       0.00        softirqs.CPU43.TASKLET
      1105 ± 10%     +17.5%       1298 ± 18%  softirqs.CPU43.TIMER
     37.00 ±141%    -100.0%       0.00        softirqs.CPU44.NET_RX
     22781 ±  2%      +5.6%      24066        softirqs.CPU44.RCU
     56105 ± 13%      -9.4%      50830 ±  3%  softirqs.CPU44.SCHED
      3.67 ±141%    -100.0%       0.00        softirqs.CPU44.TASKLET
    881.00 ± 44%    +112.4%       1871 ± 52%  softirqs.CPU44.TIMER
      0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU45.NET_RX
      0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU45.NET_TX
     22253 ±  5%      +8.1%      24054 ±  2%  softirqs.CPU45.RCU
     54797 ±  3%      -5.8%      51616 ±  8%  softirqs.CPU45.SCHED
      1252 ± 56%     +50.5%       1884 ± 35%  softirqs.CPU45.TIMER
     75.67 ±141%     -98.2%       1.33 ± 93%  softirqs.CPU46.NET_RX
      1.33 ±141%    -100.0%       0.00        softirqs.CPU46.NET_TX
     23611 ±  3%      +1.5%      23976        softirqs.CPU46.RCU
     54081 ± 11%      +0.2%      54189        softirqs.CPU46.SCHED
      1.00 ± 81%    +100.0%       2.00 ±141%  softirqs.CPU46.TASKLET
      1378 ± 31%      -9.5%       1247 ± 19%  softirqs.CPU46.TIMER
      0.00       +3.1e+105%       3106 ±141%  softirqs.CPU47.NET_RX
      0.00          -100.0%       0.00        softirqs.CPU47.NET_TX
     23807 ±  6%      -4.0%      22849 ±  4%  softirqs.CPU47.RCU
     50994 ±  7%     +18.0%      60159 ± 10%  softirqs.CPU47.SCHED
      0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU47.TASKLET
    743.00 ± 24%    +102.6%       1505 ± 17%  softirqs.CPU47.TIMER
     47.67 ±135%     -95.8%       2.00 ± 70%  softirqs.CPU48.NET_RX
      0.67 ± 70%    -100.0%       0.00        softirqs.CPU48.NET_TX
     22887 ±  7%      +4.5%      23917 ±  2%  softirqs.CPU48.RCU
     53357 ±  6%      -9.3%      48379 ±  8%  softirqs.CPU48.SCHED
      0.00       +1.3e+102%       1.33 ± 93%  softirqs.CPU48.TASKLET
      3294 ± 35%     -65.7%       1130 ± 23%  softirqs.CPU48.TIMER
     72.33 ±130%     -92.2%       5.67 ±129%  softirqs.CPU49.NET_RX
      0.00       +1.7e+102%       1.67 ±101%  softirqs.CPU49.NET_TX
     22613 ±  4%      +5.6%      23878 ±  3%  softirqs.CPU49.RCU
     60848 ± 13%     -18.9%      49376 ±  9%  softirqs.CPU49.SCHED
      0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU49.TASKLET
      2120 ± 20%     +17.9%       2500 ± 70%  softirqs.CPU49.TIMER
      3.33 ± 61%    +160.0%       8.67 ±133%  softirqs.CPU5.NET_RX
      0.67 ± 70%      +0.0%       0.67 ±141%  softirqs.CPU5.NET_TX
     22447 ±  7%      +0.7%      22596 ±  4%  softirqs.CPU5.RCU
     68255 ± 15%      -7.3%      63251 ±  7%  softirqs.CPU5.SCHED
      1959 ± 71%     -16.3%       1639 ± 78%  softirqs.CPU5.TIMER
      3222 ±141%     -99.9%       4.33 ± 66%  softirqs.CPU50.NET_RX
      0.67 ± 70%     +50.0%       1.00        softirqs.CPU50.NET_TX
     24347 ±  3%      -3.1%      23600 ±  2%  softirqs.CPU50.RCU
     49624 ± 11%     +13.2%      56156 ± 14%  softirqs.CPU50.SCHED
      0.33 ±141%    +100.0%       0.67 ±141%  softirqs.CPU50.TASKLET
      3388 ± 45%     -62.8%       1260 ± 27%  softirqs.CPU50.TIMER
      2.67 ±141%    -100.0%       0.00        softirqs.CPU51.BLOCK
      1.33 ± 35%     -50.0%       0.67 ± 70%  softirqs.CPU51.NET_RX
      0.33 ±141%      +0.0%       0.33 ±141%  softirqs.CPU51.NET_TX
     23707            +2.9%      24401        softirqs.CPU51.RCU
     56464 ± 13%     -17.7%      46463 ± 11%  softirqs.CPU51.SCHED
      0.67 ±141%      +0.0%       0.67 ± 70%  softirqs.CPU51.TASKLET
      2563 ± 28%     -73.1%     689.67 ± 28%  softirqs.CPU51.TIMER
      3.00 ± 47%    +300.0%      12.00 ±129%  softirqs.CPU52.NET_RX
      1.33 ± 35%     +25.0%       1.67 ±101%  softirqs.CPU52.NET_TX
     23518 ±  3%      -5.2%      22284 ±  3%  softirqs.CPU52.RCU
     45486 ± 19%     +47.7%      67185 ±  4%  softirqs.CPU52.SCHED
      0.00       +1.7e+102%       1.67 ± 74%  softirqs.CPU52.TASKLET
      1324 ± 44%     -32.9%     889.33 ± 41%  softirqs.CPU52.TIMER
     10.67 ± 93%     -75.0%       2.67 ±141%  softirqs.CPU53.BLOCK
      2.33 ± 20%     -42.9%       1.33 ± 35%  softirqs.CPU53.NET_RX
      2.00 ± 40%     -83.3%       0.33 ±141%  softirqs.CPU53.NET_TX
     22553 ±  8%      -1.8%      22138 ±  3%  softirqs.CPU53.RCU
     58468 ± 20%      +3.5%      60543 ±  7%  softirqs.CPU53.SCHED
      0.00       +6.7e+101%       0.67 ± 70%  softirqs.CPU53.TASKLET
      1432 ± 58%     +35.2%       1937 ± 48%  softirqs.CPU53.TIMER
      1.00 ± 81%    +766.7%       8.67 ±141%  softirqs.CPU54.BLOCK
    141.67 ±138%     -99.3%       1.00 ± 81%  softirqs.CPU54.NET_RX
      1.00          -100.0%       0.00        softirqs.CPU54.NET_TX
     22157 ±  9%      +3.5%      22934 ±  3%  softirqs.CPU54.RCU
     54355 ± 21%      +9.1%      59277 ± 12%  softirqs.CPU54.SCHED
      0.33 ±141%    +100.0%       0.67 ±141%  softirqs.CPU54.TASKLET
      2532 ± 67%     -49.7%       1272 ± 62%  softirqs.CPU54.TIMER
      2.67 ±141%    -100.0%       0.00        softirqs.CPU55.BLOCK
      2.00 ± 40%    +200.0%       6.00 ± 82%  softirqs.CPU55.NET_RX
      1.00            +0.0%       1.00        softirqs.CPU55.NET_TX
     22879 ±  2%      -2.2%      22383 ±  2%  softirqs.CPU55.RCU
     54998 ±  4%      +3.5%      56917 ±  6%  softirqs.CPU55.SCHED
      0.00         +2e+102%       2.00 ± 81%  softirqs.CPU55.TASKLET
      3573 ± 23%     -59.2%       1459 ± 28%  softirqs.CPU55.TIMER
      0.00         +8e+102%       8.00 ±141%  softirqs.CPU56.BLOCK
     10.67 ± 88%     -90.6%       1.00 ± 81%  softirqs.CPU56.NET_RX
      0.67 ± 70%     -50.0%       0.33 ±141%  softirqs.CPU56.NET_TX
     20559 ±  3%      +9.5%      22509 ±  7%  softirqs.CPU56.RCU
     70517 ±  3%      -7.0%      65562 ± 18%  softirqs.CPU56.SCHED
      0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU56.TASKLET
      2116 ± 25%     +29.9%       2749 ± 18%  softirqs.CPU56.TIMER
     76.33 ±136%      -6.1%      71.67 ±134%  softirqs.CPU57.NET_RX
      2.00 ± 81%     -16.7%       1.67 ±141%  softirqs.CPU57.NET_TX
     22553 ± 12%      +2.2%      23040 ±  3%  softirqs.CPU57.RCU
     63432 ± 18%     -12.5%      55507 ± 14%  softirqs.CPU57.SCHED
      0.33 ±141%      +0.0%       0.33 ±141%  softirqs.CPU57.TASKLET
      2040 ± 35%     -58.4%     848.67 ± 16%  softirqs.CPU57.TIMER
      0.33 ±141%    -100.0%       0.00        softirqs.CPU58.BLOCK
      3.67 ± 64%     -27.3%       2.67 ± 63%  softirqs.CPU58.NET_RX
      1.00 ± 81%     +33.3%       1.33 ± 35%  softirqs.CPU58.NET_TX
     21470 ±  3%      +1.6%      21815 ±  9%  softirqs.CPU58.RCU
     66477 ±  2%      +2.4%      68063 ± 21%  softirqs.CPU58.SCHED
      0.00       +1.3e+102%       1.33 ± 93%  softirqs.CPU58.TASKLET
      2465 ±  3%     -51.2%       1203 ± 56%  softirqs.CPU58.TIMER
      3.33 ±120%   +1410.0%      50.33 ±138%  softirqs.CPU59.NET_RX
      1.33 ± 93%      +0.0%       1.33 ± 93%  softirqs.CPU59.NET_TX
     22027 ±  5%      +4.9%      23111        softirqs.CPU59.RCU
     58512 ± 11%      +8.5%      63491 ±  8%  softirqs.CPU59.SCHED
      0.00         +1e+103%      10.00 ±134%  softirqs.CPU59.TASKLET
      1199 ± 59%     +44.3%       1731 ± 29%  softirqs.CPU59.TIMER
      5.00 ±127%    -100.0%       0.00        softirqs.CPU6.BLOCK
      4.00 ± 70%     -41.7%       2.33 ± 80%  softirqs.CPU6.NET_RX
      0.67 ± 70%     -50.0%       0.33 ±141%  softirqs.CPU6.NET_TX
     21567 ±  2%      +3.8%      22394 ±  3%  softirqs.CPU6.RCU
     71047 ± 14%      -8.3%      65155 ±  8%  softirqs.CPU6.SCHED
      0.00         +1e+102%       1.00 ±141%  softirqs.CPU6.TASKLET
      1604 ± 22%     +13.1%       1815 ± 16%  softirqs.CPU6.TIMER
     15.67 ±127%     -42.6%       9.00 ± 79%  softirqs.CPU60.NET_RX
      0.67 ± 70%    +200.0%       2.00 ± 40%  softirqs.CPU60.NET_TX
     21190 ±  4%      +6.8%      22629 ±  2%  softirqs.CPU60.RCU
     65318 ± 18%      -7.9%      60164 ±  9%  softirqs.CPU60.SCHED
      0.00       +4.7e+102%       4.67 ± 70%  softirqs.CPU60.TASKLET
      1147 ± 22%     +58.6%       1819 ± 47%  softirqs.CPU60.TIMER
     18.00 ±107%     -81.5%       3.33 ± 98%  softirqs.CPU61.NET_RX
      1.00 ± 81%      +0.0%       1.00 ± 81%  softirqs.CPU61.NET_TX
     20522            +6.1%      21766 ±  3%  softirqs.CPU61.RCU
     62797 ±  6%     -11.7%      55422 ± 10%  softirqs.CPU61.SCHED
      0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU61.TASKLET
    984.67 ± 13%     +76.4%       1736 ± 23%  softirqs.CPU61.TIMER
      8.00 ±141%     -41.7%       4.67 ±141%  softirqs.CPU62.BLOCK
      1.33 ± 70%    +125.0%       3.00 ± 54%  softirqs.CPU62.NET_RX
      0.33 ±141%    +100.0%       0.67 ± 70%  softirqs.CPU62.NET_TX
     22767 ±  3%      -3.4%      21992 ±  8%  softirqs.CPU62.RCU
     54663 ± 13%     +13.8%      62187 ± 21%  softirqs.CPU62.SCHED
      0.00       +6.7e+101%       0.67 ± 70%  softirqs.CPU62.TASKLET
      1650 ± 14%      -3.1%       1599 ± 14%  softirqs.CPU62.TIMER
     11.67 ± 93%    +580.0%      79.33 ±136%  softirqs.CPU63.NET_RX
      1.67 ± 56%     -40.0%       1.00 ± 81%  softirqs.CPU63.NET_TX
     20882 ±  3%     +15.1%      24029 ±  2%  softirqs.CPU63.RCU
     64097 ±  8%     -22.0%      50025 ± 10%  softirqs.CPU63.SCHED
      0.00       +2.7e+102%       2.67 ± 77%  softirqs.CPU63.TASKLET
      1214 ± 20%     +16.1%       1409 ± 47%  softirqs.CPU63.TIMER
      0.00         +6e+102%       6.00 ±141%  softirqs.CPU64.BLOCK
     37.00 ±124%     -54.1%      17.00 ±112%  softirqs.CPU64.NET_RX
      1.00            +0.0%       1.00 ± 81%  softirqs.CPU64.NET_TX
     22074 ±  3%     +11.2%      24536 ± 13%  softirqs.CPU64.RCU
     55954 ± 20%      +5.6%      59106 ± 20%  softirqs.CPU64.SCHED
     14.33 ±141%     -97.7%       0.33 ±141%  softirqs.CPU64.TASKLET
      2854 ± 30%     -46.9%       1517 ± 46%  softirqs.CPU64.TIMER
      4.67 ±141%    -100.0%       0.00        softirqs.CPU65.BLOCK
      3.33 ±120%    +970.0%      35.67 ±137%  softirqs.CPU65.NET_RX
      0.33 ±141%    +200.0%       1.00 ± 81%  softirqs.CPU65.NET_TX
     22638 ±  3%      +5.3%      23828 ±  3%  softirqs.CPU65.RCU
     60505 ±  6%      +0.3%      60698 ±  5%  softirqs.CPU65.SCHED
      0.67 ±141%    -100.0%       0.00        softirqs.CPU65.TASKLET
      1418 ± 50%     +92.3%       2727 ± 46%  softirqs.CPU65.TIMER
      0.00       +5.3e+102%       5.33 ±141%  softirqs.CPU66.BLOCK
      6.67 ± 88%     -60.0%       2.67 ± 63%  softirqs.CPU66.NET_RX
      2.00 ± 40%     -50.0%       1.00        softirqs.CPU66.NET_TX
     23949            -9.8%      21614 ±  4%  softirqs.CPU66.RCU
     49792 ± 11%     +31.3%      65388 ±  7%  softirqs.CPU66.SCHED
      0.00       +6.7e+101%       0.67 ±141%  softirqs.CPU66.TASKLET
      1020 ± 40%     +98.0%       2021 ±  6%  softirqs.CPU66.TIMER
      0.67 ±141%   +1450.0%      10.33 ±134%  softirqs.CPU67.BLOCK
     43.00 ±139%     -96.9%       1.33 ± 70%  softirqs.CPU67.NET_RX
      2.00 ±141%     -83.3%       0.33 ±141%  softirqs.CPU67.NET_TX
     21580 ±  6%      +5.3%      22726 ±  4%  softirqs.CPU67.RCU
     64054 ± 19%      -8.8%      58412 ± 18%  softirqs.CPU67.SCHED
      0.67 ±141%    +100.0%       1.33 ±141%  softirqs.CPU67.TASKLET
      1585 ± 47%     -23.6%       1211 ± 34%  softirqs.CPU67.TIMER
      1.00 ± 81%     +33.3%       1.33 ± 35%  softirqs.CPU68.NET_RX
      0.33 ±141%    +100.0%       0.67 ± 70%  softirqs.CPU68.NET_TX
     21076 ±  4%      +9.9%      23167 ±  9%  softirqs.CPU68.RCU
     70434 ± 12%     -11.3%      62492 ± 10%  softirqs.CPU68.SCHED
      0.67 ±141%     -50.0%       0.33 ±141%  softirqs.CPU68.TASKLET
      1632 ± 50%     +78.8%       2919 ± 30%  softirqs.CPU68.TIMER
    859.67 ±140%    +570.8%       5767 ±141%  softirqs.CPU69.NET_RX
      0.67 ± 70%      +0.0%       0.67 ±141%  softirqs.CPU69.NET_TX
     20945 ±  4%     +17.5%      24605 ± 12%  softirqs.CPU69.RCU
     75220 ±  8%      -8.1%      69114 ± 19%  softirqs.CPU69.SCHED
      0.00         +1e+102%       1.00 ±141%  softirqs.CPU69.TASKLET
      1339 ± 14%    +307.4%       5457 ± 67%  softirqs.CPU69.TIMER
      2.67 ± 63%     +25.0%       3.33 ± 50%  softirqs.CPU7.NET_RX
      1.00            +0.0%       1.00        softirqs.CPU7.NET_TX
     22142            +2.4%      22671 ±  5%  softirqs.CPU7.RCU
     70413            -2.1%      68903 ±  6%  softirqs.CPU7.SCHED
      2088 ± 53%     -22.1%       1627 ± 30%  softirqs.CPU7.TIMER
      0.00       +6.7e+101%       0.67 ±141%  softirqs.CPU70.BLOCK
      2.33 ± 20%     +42.9%       3.33 ± 98%  softirqs.CPU70.NET_RX
      0.67 ± 70%    -100.0%       0.00        softirqs.CPU70.NET_TX
     20984 ±  4%      +7.3%      22516 ±  5%  softirqs.CPU70.RCU
     69373 ±  5%      -8.5%      63448 ± 14%  softirqs.CPU70.SCHED
      0.00       +6.7e+101%       0.67 ±141%  softirqs.CPU70.TASKLET
      1874 ± 27%      -8.9%       1707 ± 14%  softirqs.CPU70.TIMER
      2.67 ±141%    -100.0%       0.00        softirqs.CPU71.BLOCK
      1.33 ± 35%  +79000.0%       1054 ±141%  softirqs.CPU71.NET_RX
      1.00 ± 81%    -100.0%       0.00        softirqs.CPU71.NET_TX
     20381 ±  3%      +7.1%      21835 ±  5%  softirqs.CPU71.RCU
     68348 ±  9%      +4.6%      71485 ± 10%  softirqs.CPU71.SCHED
      0.67 ±141%    -100.0%       0.00        softirqs.CPU71.TASKLET
      1565 ± 31%      +8.7%       1702 ± 29%  softirqs.CPU71.TIMER
     10.33 ±141%    -100.0%       0.00        softirqs.CPU72.BLOCK
      0.33 ±141%    +300.0%       1.33 ±141%  softirqs.CPU72.NET_RX
      0.33 ±141%      +0.0%       0.33 ±141%  softirqs.CPU72.NET_TX
     22366 ±  7%      +4.7%      23424        softirqs.CPU72.RCU
     58299 ± 10%      -6.8%      54357 ± 18%  softirqs.CPU72.SCHED
      0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU72.TASKLET
      1141 ± 50%     +81.6%       2073 ± 63%  softirqs.CPU72.TIMER
      2.33 ± 80%     -57.1%       1.00 ± 81%  softirqs.CPU73.NET_RX
      0.00          -100.0%       0.00        softirqs.CPU73.NET_TX
     23711 ±  5%      -2.6%      23086 ±  4%  softirqs.CPU73.RCU
     57497 ± 19%      +4.4%      60035 ±  6%  softirqs.CPU73.SCHED
      1142          +185.5%       3261 ± 85%  softirqs.CPU73.TIMER
      4.67 ±141%    -100.0%       0.00        softirqs.CPU74.BLOCK
      8.67 ±117%     +30.8%      11.33 ± 82%  softirqs.CPU74.NET_RX
      0.67 ±141%   +6300.0%      42.67 ±138%  softirqs.CPU74.NET_TX
     22381 ±  6%      +7.7%      24100 ±  6%  softirqs.CPU74.RCU
     64133 ± 32%     -13.2%      55647 ± 11%  softirqs.CPU74.SCHED
      1692 ± 77%      -3.0%       1641 ± 18%  softirqs.CPU74.TIMER
      4.67 ±141%    -100.0%       0.00        softirqs.CPU75.BLOCK
     37.33 ±141%     -95.5%       1.67 ± 74%  softirqs.CPU75.NET_RX
      0.33 ±141%    -100.0%       0.00        softirqs.CPU75.NET_TX
     22754 ±  4%      +0.1%      22785 ±  4%  softirqs.CPU75.RCU
     50023 ± 17%     +26.0%      63022 ± 11%  softirqs.CPU75.SCHED
      1492 ± 55%     -39.4%     904.33 ± 42%  softirqs.CPU75.TIMER
      1.00 ±141%   +2266.7%      23.67 ±141%  softirqs.CPU76.BLOCK
     45.67 ±141%     -98.5%       0.67 ± 70%  softirqs.CPU76.NET_RX
      0.00       +6.7e+101%       0.67 ± 70%  softirqs.CPU76.NET_TX
     23177 ±  4%      -1.9%      22739 ±  8%  softirqs.CPU76.RCU
     48812 ± 15%     +21.0%      59045 ±  5%  softirqs.CPU76.SCHED
    761.67 ±  9%    +185.7%       2176 ± 61%  softirqs.CPU76.TIMER
      0.00       +3.3e+102%       3.33 ±141%  softirqs.CPU77.BLOCK
      7979 ±141%     -99.9%       4.67 ± 96%  softirqs.CPU77.NET_RX
      0.33 ±141%  +12500.0%      42.00 ±141%  softirqs.CPU77.NET_TX
     23705 ±  2%      -4.9%      22542 ±  5%  softirqs.CPU77.RCU
     57151 ± 17%     +20.0%      68579 ±  7%  softirqs.CPU77.SCHED
      1626 ± 33%      -9.9%       1465 ± 41%  softirqs.CPU77.TIMER
      0.00       +9.3e+102%       9.33 ±141%  softirqs.CPU78.BLOCK
      5.33 ± 93%     -43.8%       3.00 ± 81%  softirqs.CPU78.NET_RX
      1.00 ± 81%     -66.7%       0.33 ±141%  softirqs.CPU78.NET_TX
     22582 ±  7%      +3.6%      23396 ±  4%  softirqs.CPU78.RCU
     51854 ± 16%     +16.7%      60490 ± 13%  softirqs.CPU78.SCHED
      1764 ± 20%     +74.0%       3069 ± 81%  softirqs.CPU78.TIMER
      0.00       +9.3e+102%       9.33 ±141%  softirqs.CPU79.BLOCK
      0.33 ±141%    +700.0%       2.67 ± 46%  softirqs.CPU79.NET_RX
      0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU79.NET_TX
     20048            +7.0%      21452 ±  2%  softirqs.CPU79.RCU
     80114 ±  5%     -15.9%      67391 ± 11%  softirqs.CPU79.SCHED
      1289 ± 36%     +69.0%       2180 ± 32%  softirqs.CPU79.TIMER
      0.00       +4.7e+102%       4.67 ±141%  softirqs.CPU8.BLOCK
      3.67 ± 56%     -45.5%       2.00 ± 40%  softirqs.CPU8.NET_RX
      0.33 ±141%      +0.0%       0.33 ±141%  softirqs.CPU8.NET_TX
     22698 ±  2%      +0.2%      22737 ±  6%  softirqs.CPU8.RCU
     56494 ±  2%      +7.0%      60446 ± 17%  softirqs.CPU8.SCHED
    639.33 ± 11%    +221.6%       2056 ± 54%  softirqs.CPU8.TIMER
      0.00       +2.3e+103%      23.00 ±141%  softirqs.CPU80.BLOCK
      0.00       +2.5e+103%      25.33 ±138%  softirqs.CPU80.NET_RX
      0.00       +1.7e+102%       1.67 ±141%  softirqs.CPU80.NET_TX
     21338 ±  2%      +1.4%      21628        softirqs.CPU80.RCU
     67863 ±  9%      +8.9%      73889 ±  5%  softirqs.CPU80.SCHED
      0.33 ±141%      +0.0%       0.33 ±141%  softirqs.CPU80.TASKLET
      1148 ± 44%      +9.5%       1258 ± 16%  softirqs.CPU80.TIMER
      3.33 ±141%     +40.0%       4.67 ±141%  softirqs.CPU81.BLOCK
     31.67 ±141%     -98.9%       0.33 ±141%  softirqs.CPU81.NET_RX
     22495 ±  2%      +0.6%      22635 ±  4%  softirqs.CPU81.RCU
     66479 ±  6%      +0.6%      66908 ± 11%  softirqs.CPU81.SCHED
      6.67 ±141%    -100.0%       0.00        softirqs.CPU81.TASKLET
      1325 ± 15%     +22.0%       1616 ± 29%  softirqs.CPU81.TIMER
      0.00       +6.7e+101%       0.67 ±141%  softirqs.CPU82.BLOCK
      9.00 ± 86%     +66.7%      15.00 ±141%  softirqs.CPU82.NET_RX
      0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU82.NET_TX
     22393            -2.8%      21772 ±  5%  softirqs.CPU82.RCU
     62623 ± 12%     +13.0%      70783 ±  8%  softirqs.CPU82.SCHED
      0.67 ±141%    -100.0%       0.00        softirqs.CPU82.TASKLET
      2318 ± 48%     -10.9%       2065 ± 33%  softirqs.CPU82.TIMER
      1.33 ±141%     +50.0%       2.00 ± 81%  softirqs.CPU83.NET_RX
      0.67 ±141%    -100.0%       0.00        softirqs.CPU83.NET_TX
     22326 ±  3%      -6.7%      20824 ±  2%  softirqs.CPU83.RCU
     67444 ±  6%     +17.1%      78997 ±  7%  softirqs.CPU83.SCHED
      0.00       +6.7e+101%       0.67 ± 70%  softirqs.CPU83.TASKLET
      2190 ± 37%     +26.0%       2759 ± 29%  softirqs.CPU83.TIMER
     24.00 ±141%     -47.2%      12.67 ± 80%  softirqs.CPU84.BLOCK
      1796 ±141%     -99.8%       3.00 ± 81%  softirqs.CPU84.NET_RX
      0.33 ±141%      +0.0%       0.33 ±141%  softirqs.CPU84.NET_TX
     21584 ±  7%      +5.7%      22816 ±  3%  softirqs.CPU84.RCU
     76430 ±  9%     -22.0%      59601 ±  5%  softirqs.CPU84.SCHED
      6724 ±101%     -73.6%       1774 ±  8%  softirqs.CPU84.TIMER
      1.67 ±141%   +4060.0%      69.33 ±134%  softirqs.CPU85.NET_RX
      0.00         +1e+102%       1.00 ± 81%  softirqs.CPU85.NET_TX
     21261 ±  6%      +5.2%      22360 ±  3%  softirqs.CPU85.RCU
     65095 ± 22%      +4.9%      68261 ±  9%  softirqs.CPU85.SCHED
      1760 ± 50%     +91.9%       3377 ± 56%  softirqs.CPU85.TIMER
      0.00       +6.7e+101%       0.67 ±141%  softirqs.CPU86.BLOCK
      0.33 ±141%  +10400.0%      35.00 ±133%  softirqs.CPU86.NET_RX
      0.00          -100.0%       0.00        softirqs.CPU86.NET_TX
     22224 ± 11%      -2.2%      21732 ±  5%  softirqs.CPU86.RCU
     61315 ± 23%     +16.2%      71242 ±  5%  softirqs.CPU86.SCHED
      0.00         +3e+102%       3.00 ±118%  softirqs.CPU86.TASKLET
      1469 ± 39%     +67.4%       2459 ± 27%  softirqs.CPU86.TIMER
      0.33 ±141%  +1.2e+05%     387.67 ±140%  softirqs.CPU87.NET_RX
      0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU87.NET_TX
     21997 ±  4%      -2.3%      21484        softirqs.CPU87.RCU
     67095 ± 11%     +13.1%      75893 ± 12%  softirqs.CPU87.SCHED
      0.00       +6.7e+101%       0.67 ±141%  softirqs.CPU87.TASKLET
      1440 ± 69%     +61.4%       2325 ± 44%  softirqs.CPU87.TIMER
      6.00 ±118%    -100.0%       0.00        softirqs.CPU88.BLOCK
     69.00 ±133%     -98.6%       1.00 ± 81%  softirqs.CPU88.NET_RX
      1.00 ± 81%     -66.7%       0.33 ±141%  softirqs.CPU88.NET_TX
     22312 ±  5%      -2.1%      21852 ±  9%  softirqs.CPU88.RCU
     63281 ± 12%      +7.2%      67824 ± 13%  softirqs.CPU88.SCHED
      1345 ± 30%     +31.5%       1768 ± 39%  softirqs.CPU88.TIMER
      4.33 ± 78%     -76.9%       1.00 ± 81%  softirqs.CPU89.NET_RX
      1.00 ± 81%    -100.0%       0.00        softirqs.CPU89.NET_TX
     21573 ±  4%      +1.5%      21906 ±  6%  softirqs.CPU89.RCU
     66546 ± 14%      +5.1%      69960 ± 13%  softirqs.CPU89.SCHED
      0.33 ±141%    +600.0%       2.33 ±141%  softirqs.CPU89.TASKLET
      1040 ± 40%     +72.1%       1791 ± 20%  softirqs.CPU89.TIMER
      2.00 ± 70%      +0.0%       2.00 ±108%  softirqs.CPU9.NET_RX
      0.00       +3.3e+101%       0.33 ±141%  softirqs.CPU9.NET_TX
     21515 ±  3%      +6.3%      22867 ±  5%  softirqs.CPU9.RCU
     63076 ± 14%     +12.8%      71161 ± 10%  softirqs.CPU9.SCHED
      1831 ± 17%      +0.0%       1832 ± 23%  softirqs.CPU9.TIMER
      5.33 ±128%    -100.0%       0.00        softirqs.CPU90.NET_RX
      0.00          -100.0%       0.00        softirqs.CPU90.NET_TX
     22135            -1.9%      21717 ±  4%  softirqs.CPU90.RCU
     64291 ±  8%      +4.4%      67124 ± 11%  softirqs.CPU90.SCHED
      0.67 ±141%    -100.0%       0.00        softirqs.CPU90.TASKLET
      1428 ±  6%     +79.4%       2561 ± 31%  softirqs.CPU90.TIMER
      0.67 ±141%     +50.0%       1.00 ± 81%  softirqs.CPU91.BLOCK
      0.67 ± 70%    +150.0%       1.67 ±141%  softirqs.CPU91.NET_RX
      0.33 ±141%      +0.0%       0.33 ±141%  softirqs.CPU91.NET_TX
     22339            +2.0%      22780        softirqs.CPU91.RCU
     66812 ± 10%      +2.7%      68632 ±  4%  softirqs.CPU91.SCHED
      0.33 ±141%    +500.0%       2.00 ±141%  softirqs.CPU91.TASKLET
      1211 ± 25%     +23.2%       1492 ± 30%  softirqs.CPU91.TIMER
     10.33 ±141%      -9.7%       9.33 ±141%  softirqs.CPU92.BLOCK
      0.67 ±141%    +100.0%       1.33 ±141%  softirqs.CPU92.NET_RX
     21483 ±  3%      -3.5%      20729        softirqs.CPU92.RCU
     71070 ±  8%      +6.7%      75809 ±  4%  softirqs.CPU92.SCHED
      2.00 ±141%    -100.0%       0.00        softirqs.CPU92.TASKLET
      1313 ± 50%    +109.2%       2747 ± 40%  softirqs.CPU92.TIMER
      3.33 ±141%    +170.0%       9.00 ±141%  softirqs.CPU93.BLOCK
      5.33 ±104%     -87.5%       0.67 ±141%  softirqs.CPU93.NET_RX
      0.67 ±141%    -100.0%       0.00        softirqs.CPU93.NET_TX
     20984 ±  4%      +0.9%      21162 ±  4%  softirqs.CPU93.RCU
     72302 ±  2%      +5.9%      76593 ± 10%  softirqs.CPU93.SCHED
      0.33 ±141%    -100.0%       0.00        softirqs.CPU93.TASKLET
      1222 ± 10%     +10.4%       1348 ± 25%  softirqs.CPU93.TIMER
      0.00       +2.4e+103%      23.67 ±141%  softirqs.CPU94.BLOCK
      0.67 ±141%    -100.0%       0.00        softirqs.CPU94.NET_RX
     21564 ±  3%      +2.2%      22041 ±  2%  softirqs.CPU94.RCU
     76560 ± 13%      -1.9%      75129 ±  5%  softirqs.CPU94.SCHED
      1.67 ±141%     -80.0%       0.33 ±141%  softirqs.CPU94.TASKLET
      1993 ± 51%     -25.3%       1489 ± 79%  softirqs.CPU94.TIMER
      0.67 ±141%    -100.0%       0.00        softirqs.CPU95.BLOCK
      0.00          -100.0%       0.00        softirqs.CPU95.NET_TX
     21727 ±  4%      +4.4%      22687 ±  2%  softirqs.CPU95.RCU
     74850 ±  5%      -6.5%      70001 ± 12%  softirqs.CPU95.SCHED
     11.33 ±141%     -97.1%       0.33 ±141%  softirqs.CPU95.TASKLET
      1300 ± 54%      -9.8%       1172 ±  8%  softirqs.CPU95.TIMER
      2.33 ± 20%     -14.3%       2.00        softirqs.HI
     28720 ± 65%     +31.6%      37796 ± 46%  softirqs.NET_RX
    195.33 ±  3%      -1.7%     192.00 ±  3%  softirqs.NET_TX
   2146202            +3.1%    2213420        softirqs.RCU
   6150050            -0.2%    6137341        softirqs.SCHED
    239.67 ±  5%      +8.3%     259.67        softirqs.TASKLET
    180878 ±  2%      +3.8%     187774 ±  3%  softirqs.TIMER
      0.00          -100.0%       0.00        interrupts.0:IO-APIC.2-edge.timer
      5.33 ± 77%    +231.3%      17.67 ±141%  interrupts.100:PCI-MSI.31981633-edge.i40e-eth0-TxRx-64
      0.67 ±141%   +7800.0%      52.67 ±137%  interrupts.101:PCI-MSI.31981634-edge.i40e-eth0-TxRx-65
      3.00 ± 72%    -100.0%       0.00        interrupts.102:PCI-MSI.31981635-edge.i40e-eth0-TxRx-66
     69.33 ±141%     -99.0%       0.67 ±141%  interrupts.103:PCI-MSI.31981636-edge.i40e-eth0-TxRx-67
      1.00 ±141%     +66.7%       1.67 ±141%  interrupts.104:PCI-MSI.31981637-edge.i40e-eth0-TxRx-68
      1697 ±140%    +111.9%       3597 ±141%  interrupts.105:PCI-MSI.31981638-edge.i40e-eth0-TxRx-69
      4.00 ± 20%     +33.3%       5.33 ±128%  interrupts.106:PCI-MSI.31981639-edge.i40e-eth0-TxRx-70
      1.33 ± 70%  +1.4e+05%       1852 ±141%  interrupts.107:PCI-MSI.31981640-edge.i40e-eth0-TxRx-71
      0.00       +3.7e+102%       3.67 ±105%  interrupts.108:PCI-MSI.31981641-edge.i40e-eth0-TxRx-72
      2.00 ±141%     -33.3%       1.33 ±141%  interrupts.109:PCI-MSI.31981642-edge.i40e-eth0-TxRx-73
      0.33 ±141%    +400.0%       1.67 ± 74%  interrupts.110:PCI-MSI.31981643-edge.i40e-eth0-TxRx-74
     62.67 ±141%     -96.8%       2.00 ± 81%  interrupts.111:PCI-MSI.31981644-edge.i40e-eth0-TxRx-75
     66.67 ±141%     -98.5%       1.00 ±141%  interrupts.112:PCI-MSI.31981645-edge.i40e-eth0-TxRx-76
     15573 ±141%    -100.0%       2.33 ± 88%  interrupts.113:PCI-MSI.31981646-edge.i40e-eth0-TxRx-77
      3.67 ±105%     +36.4%       5.00 ± 90%  interrupts.114:PCI-MSI.31981647-edge.i40e-eth0-TxRx-78
      0.00         +7e+102%       7.00 ± 42%  interrupts.115:PCI-MSI.31981648-edge.i40e-eth0-TxRx-79
      1.33 ± 70%   +2875.0%      39.67 ±134%  interrupts.116:PCI-MSI.31981649-edge.i40e-eth0-TxRx-80
     48.33 ±138%     -99.3%       0.33 ±141%  interrupts.117:PCI-MSI.31981650-edge.i40e-eth0-TxRx-81
      6.33 ±119%    +215.8%      20.00 ±137%  interrupts.118:PCI-MSI.31981651-edge.i40e-eth0-TxRx-82
      1.00 ±141%    +333.3%       4.33 ± 96%  interrupts.119:PCI-MSI.31981652-edge.i40e-eth0-TxRx-83
      2655 ±141%     -99.9%       3.33 ±101%  interrupts.120:PCI-MSI.31981653-edge.i40e-eth0-TxRx-84
      4.00 ±124%   +2400.0%     100.00 ±132%  interrupts.121:PCI-MSI.31981654-edge.i40e-eth0-TxRx-85
      1.00 ± 81%   +4766.7%      48.67 ±127%  interrupts.122:PCI-MSI.31981655-edge.i40e-eth0-TxRx-86
      1.00 ±141%  +70500.0%     706.00 ±140%  interrupts.123:PCI-MSI.31981656-edge.i40e-eth0-TxRx-87
     95.67 ±141%     -97.2%       2.67 ± 70%  interrupts.124:PCI-MSI.31981657-edge.i40e-eth0-TxRx-88
      6.33 ±119%     -52.6%       3.00 ± 72%  interrupts.125:PCI-MSI.31981658-edge.i40e-eth0-TxRx-89
      6.67 ±141%     -90.0%       0.67 ±141%  interrupts.126:PCI-MSI.31981659-edge.i40e-eth0-TxRx-90
      2.00 ± 81%     -16.7%       1.67 ±101%  interrupts.127:PCI-MSI.31981660-edge.i40e-eth0-TxRx-91
      2.67 ± 93%     +25.0%       3.33 ±120%  interrupts.128:PCI-MSI.31981661-edge.i40e-eth0-TxRx-92
      2.33 ±141%     -14.3%       2.00 ±141%  interrupts.129:PCI-MSI.31981662-edge.i40e-eth0-TxRx-93
      0.00          -100.0%       0.00        interrupts.293:PCI-MSI.327680-edge.xhci_hcd
      0.00          -100.0%       0.00        interrupts.295:PCI-MSI.65536-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.297:PCI-MSI.67584-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.298:PCI-MSI.67584-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.298:PCI-MSI.69632-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.299:PCI-MSI.69632-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.299:PCI-MSI.71680-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.300:PCI-MSI.71680-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.300:PCI-MSI.73728-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.301:PCI-MSI.73728-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.301:PCI-MSI.75776-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.302:PCI-MSI.75776-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.302:PCI-MSI.77824-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.303:PCI-MSI.77824-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.303:PCI-MSI.79872-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.304:PCI-MSI.79872-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.305:PCI-MSI.67174400-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.306:PCI-MSI.67174400-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.307:PCI-MSI.67176448-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.308:PCI-MSI.67176448-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.308:PCI-MSI.67178496-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.309:PCI-MSI.67178496-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.309:PCI-MSI.67180544-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.310:PCI-MSI.67180544-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.310:PCI-MSI.67182592-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.311:PCI-MSI.67182592-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.311:PCI-MSI.67184640-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.312:PCI-MSI.376832-edge.ahci[0000:00:17.0]
      0.00          -100.0%       0.00        interrupts.312:PCI-MSI.67184640-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.313:PCI-MSI.67184640-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.313:PCI-MSI.67186688-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.314:PCI-MSI.67186688-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.314:PCI-MSI.67188736-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.315:PCI-MSI.376832-edge.ahci[0000:00:17.0]
      0.00          -100.0%       0.00        interrupts.315:PCI-MSI.67188736-edge.ioat-msix
      1332            +2.1%       1360 ±  3%  interrupts.35:PCI-MSI.31981568-edge.i40e-0000:3d:00.0:misc
      7.33 ±103%     -86.4%       1.00 ±141%  interrupts.36:PCI-MSI.31981569-edge.i40e-eth0-TxRx-0
    638.00 ±140%     -99.9%       0.67 ±141%  interrupts.37:PCI-MSI.31981570-edge.i40e-eth0-TxRx-1
      6.00 ±106%   +1038.9%      68.33 ±136%  interrupts.38:PCI-MSI.31981571-edge.i40e-eth0-TxRx-2
      1.33 ±141%  +9.9e+05%      13207 ±141%  interrupts.39:PCI-MSI.31981572-edge.i40e-eth0-TxRx-3
      0.00          -100.0%       0.00        interrupts.3:IO-APIC.3-edge
      2.33 ± 88%     +14.3%       2.67 ± 63%  interrupts.40:PCI-MSI.31981573-edge.i40e-eth0-TxRx-4
      4.67 ± 70%     -92.9%       0.33 ±141%  interrupts.41:PCI-MSI.31981574-edge.i40e-eth0-TxRx-5
      6.33 ± 73%     -63.2%       2.33 ± 88%  interrupts.42:PCI-MSI.31981575-edge.i40e-eth0-TxRx-6
      3.33 ±141%     +20.0%       4.00 ± 93%  interrupts.43:PCI-MSI.31981576-edge.i40e-eth0-TxRx-7
      5.33 ± 31%     -62.5%       2.00 ± 81%  interrupts.44:PCI-MSI.31981577-edge.i40e-eth0-TxRx-8
      3.00 ±118%     +22.2%       3.67 ±141%  interrupts.45:PCI-MSI.31981578-edge.i40e-eth0-TxRx-9
      6.67 ±120%    -100.0%       0.00        interrupts.46:PCI-MSI.31981579-edge.i40e-eth0-TxRx-10
     71.33 ±130%      -4.2%      68.33 ±139%  interrupts.47:PCI-MSI.31981580-edge.i40e-eth0-TxRx-11
     17.67 ±141%     -96.2%       0.67 ±141%  interrupts.48:PCI-MSI.31981581-edge.i40e-eth0-TxRx-12
      3.67 ± 12%     +27.3%       4.67 ± 88%  interrupts.49:PCI-MSI.31981582-edge.i40e-eth0-TxRx-13
     17.00 ±141%    +229.4%      56.00 ± 11%  interrupts.4:IO-APIC.4-edge.ttyS0
      1.33 ± 70%     +50.0%       2.00 ± 81%  interrupts.50:PCI-MSI.31981583-edge.i40e-eth0-TxRx-14
      4.00 ± 20%     +41.7%       5.67 ±141%  interrupts.51:PCI-MSI.31981584-edge.i40e-eth0-TxRx-15
      2.33 ± 20%     +57.1%       3.67 ±122%  interrupts.52:PCI-MSI.31981585-edge.i40e-eth0-TxRx-16
      6.67 ± 88%    +660.0%      50.67 ±133%  interrupts.53:PCI-MSI.31981586-edge.i40e-eth0-TxRx-17
      1.00 ±141%  +1.3e+06%      13326 ±141%  interrupts.54:PCI-MSI.31981587-edge.i40e-eth0-TxRx-18
     13.00 ±103%     -89.7%       1.33 ±141%  interrupts.55:PCI-MSI.31981588-edge.i40e-eth0-TxRx-19
      2.00 ±108%     -33.3%       1.33 ± 70%  interrupts.56:PCI-MSI.31981589-edge.i40e-eth0-TxRx-20
      7.33 ± 65%   +1590.9%     124.00 ±140%  interrupts.57:PCI-MSI.31981590-edge.i40e-eth0-TxRx-21
      2.67 ±115%   +4612.5%     125.67 ±133%  interrupts.58:PCI-MSI.31981591-edge.i40e-eth0-TxRx-22
      1.67 ±141%   +4040.0%      69.00 ±140%  interrupts.59:PCI-MSI.31981592-edge.i40e-eth0-TxRx-23
     13.67 ± 87%   +1529.3%     222.67 ± 80%  interrupts.60:PCI-MSI.31981593-edge.i40e-eth0-TxRx-24
     14740 ±137%    -100.0%       4.33 ± 84%  interrupts.61:PCI-MSI.31981594-edge.i40e-eth0-TxRx-25
      1.00 ± 81%    +133.3%       2.33 ± 72%  interrupts.62:PCI-MSI.31981595-edge.i40e-eth0-TxRx-26
    100.67 ±137%     -94.4%       5.67 ± 29%  interrupts.63:PCI-MSI.31981596-edge.i40e-eth0-TxRx-27
      4.33 ± 71%     -30.8%       3.00 ± 72%  interrupts.64:PCI-MSI.31981597-edge.i40e-eth0-TxRx-28
      2.33 ± 72%      +0.0%       2.33 ± 20%  interrupts.65:PCI-MSI.31981598-edge.i40e-eth0-TxRx-29
      2.67 ± 93%     -37.5%       1.67 ±101%  interrupts.66:PCI-MSI.31981599-edge.i40e-eth0-TxRx-30
      0.67 ±141%    +550.0%       4.33 ± 76%  interrupts.67:PCI-MSI.31981600-edge.i40e-eth0-TxRx-31
      4574 ±141%     -99.9%       3.33 ± 70%  interrupts.68:PCI-MSI.31981601-edge.i40e-eth0-TxRx-32
      1.67 ±141%  +19380.0%     324.67 ±139%  interrupts.69:PCI-MSI.31981602-edge.i40e-eth0-TxRx-33
      1.33 ± 93%     +75.0%       2.33 ± 88%  interrupts.70:PCI-MSI.31981603-edge.i40e-eth0-TxRx-34
      0.00       +2.3e+102%       2.33 ± 88%  interrupts.71:PCI-MSI.31981604-edge.i40e-eth0-TxRx-35
      2.00 ± 81%     +33.3%       2.67 ± 93%  interrupts.72:PCI-MSI.31981605-edge.i40e-eth0-TxRx-36
      0.00         +3e+102%       3.00 ± 98%  interrupts.73:PCI-MSI.31981606-edge.i40e-eth0-TxRx-37
      2.00 ± 81%     +16.7%       2.33 ±141%  interrupts.74:PCI-MSI.31981607-edge.i40e-eth0-TxRx-38
      1.33 ±141%  +87875.0%       1173 ±141%  interrupts.75:PCI-MSI.31981608-edge.i40e-eth0-TxRx-39
      1.67 ±141%   +1020.0%      18.67 ±133%  interrupts.76:PCI-MSI.31981609-edge.i40e-eth0-TxRx-40
      0.00       +3.3e+101%       0.33 ±141%  interrupts.77:PCI-MSI.31981610-edge.i40e-eth0-TxRx-41
      0.67 ±141%    +150.0%       1.67 ± 74%  interrupts.78:PCI-MSI.31981611-edge.i40e-eth0-TxRx-42
      0.00       +2.3e+102%       2.33 ±112%  interrupts.79:PCI-MSI.31981612-edge.i40e-eth0-TxRx-43
     54.33 ±138%    -100.0%       0.00        interrupts.80:PCI-MSI.31981613-edge.i40e-eth0-TxRx-44
      0.00       +1.3e+102%       1.33 ±141%  interrupts.81:PCI-MSI.31981614-edge.i40e-eth0-TxRx-45
    111.67 ±141%     -97.9%       2.33 ±141%  interrupts.82:PCI-MSI.31981615-edge.i40e-eth0-TxRx-46
      0.33 ±141%  +1.9e+06%       6213 ±141%  interrupts.83:PCI-MSI.31981616-edge.i40e-eth0-TxRx-47
     68.67 ±136%     -95.1%       3.33 ±101%  interrupts.84:PCI-MSI.31981617-edge.i40e-eth0-TxRx-48
    142.00 ±132%     -98.1%       2.67 ±141%  interrupts.85:PCI-MSI.31981618-edge.i40e-eth0-TxRx-49
      5581 ±141%     -99.9%       8.33 ± 59%  interrupts.86:PCI-MSI.31981619-edge.i40e-eth0-TxRx-50
      1.33 ± 70%     -50.0%       0.67 ±141%  interrupts.87:PCI-MSI.31981620-edge.i40e-eth0-TxRx-51
      1.67 ±101%     -40.0%       1.00 ±141%  interrupts.88:PCI-MSI.31981621-edge.i40e-eth0-TxRx-52
      1.00 ± 81%    -100.0%       0.00        interrupts.89:PCI-MSI.31981622-edge.i40e-eth0-TxRx-53
      0.00          -100.0%       0.00        interrupts.8:IO-APIC.8-edge.rtc0
     49.67 ±137%     -98.7%       0.67 ±141%  interrupts.90:PCI-MSI.31981623-edge.i40e-eth0-TxRx-54
      1.67 ± 74%     -60.0%       0.67 ±141%  interrupts.91:PCI-MSI.31981624-edge.i40e-eth0-TxRx-55
      7.67 ± 22%     -91.3%       0.67 ±141%  interrupts.92:PCI-MSI.31981625-edge.i40e-eth0-TxRx-56
     99.33 ±138%     -20.1%      79.33 ±128%  interrupts.93:PCI-MSI.31981626-edge.i40e-eth0-TxRx-57
      4.33 ± 76%     -76.9%       1.00        interrupts.94:PCI-MSI.31981627-edge.i40e-eth0-TxRx-58
      2.67 ± 93%   +2450.0%      68.00 ±141%  interrupts.95:PCI-MSI.31981628-edge.i40e-eth0-TxRx-59
     19.67 ±123%     -76.3%       4.67 ± 80%  interrupts.96:PCI-MSI.31981629-edge.i40e-eth0-TxRx-60
     19.33 ±130%     -79.3%       4.00 ±141%  interrupts.97:PCI-MSI.31981630-edge.i40e-eth0-TxRx-61
      0.00         +5e+102%       5.00 ± 71%  interrupts.98:PCI-MSI.31981631-edge.i40e-eth0-TxRx-62
      3.67 ±105%   +3172.7%     120.00 ±136%  interrupts.99:PCI-MSI.31981632-edge.i40e-eth0-TxRx-63
 1.485e+08 ±  2%      -2.3%  1.451e+08        interrupts.CAL:Function_call_interrupts
      0.00          -100.0%       0.00        interrupts.CPU0.0:IO-APIC.2-edge.timer
      0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU0.119:PCI-MSI.31981652-edge.i40e-eth0-TxRx-83
      7.00 ±112%     -85.7%       1.00 ±141%  interrupts.CPU0.36:PCI-MSI.31981569-edge.i40e-eth0-TxRx-0
      0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU0.71:PCI-MSI.31981604-edge.i40e-eth0-TxRx-35
   1283224 ±  6%     -15.1%    1088946 ±  6%  interrupts.CPU0.CAL:Function_call_interrupts
      1.67 ± 74%    +480.0%       9.67 ± 21%  interrupts.CPU0.IWI:IRQ_work_interrupts
   1994188            -3.8%    1918506 ±  2%  interrupts.CPU0.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU0.MCP:Machine_check_polls
      3245 ±  7%     +47.6%       4789 ± 16%  interrupts.CPU0.NMI:Non-maskable_interrupts
      3245 ±  7%     +47.6%       4789 ± 16%  interrupts.CPU0.PMI:Performance_monitoring_interrupts
    981.00 ±  5%      -4.0%     941.67 ±  5%  interrupts.CPU0.RES:Rescheduling_interrupts
      0.00          -100.0%       0.00        interrupts.CPU0.RTR:APIC_ICR_read_retries
   1647458 ±  6%     -12.9%    1434640 ±  6%  interrupts.CPU0.TLB:TLB_shootdowns
      0.00       +6.7e+101%       0.67 ± 70%  interrupts.CPU1.120:PCI-MSI.31981653-edge.i40e-eth0-TxRx-84
    637.33 ±140%     -99.9%       0.67 ±141%  interrupts.CPU1.37:PCI-MSI.31981570-edge.i40e-eth0-TxRx-1
      0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU1.72:PCI-MSI.31981605-edge.i40e-eth0-TxRx-36
   1441294 ± 10%     -23.5%    1102827 ± 15%  interrupts.CPU1.CAL:Function_call_interrupts
      5.33 ±104%     -12.5%       4.67 ±112%  interrupts.CPU1.IWI:IRQ_work_interrupts
   1994402            -3.7%    1921568 ±  2%  interrupts.CPU1.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU1.MCP:Machine_check_polls
      4412 ± 43%      -0.4%       4393 ± 37%  interrupts.CPU1.NMI:Non-maskable_interrupts
      4412 ± 43%      -0.4%       4393 ± 37%  interrupts.CPU1.PMI:Performance_monitoring_interrupts
      1144 ±  4%      -6.2%       1073 ± 21%  interrupts.CPU1.RES:Rescheduling_interrupts
   1850166 ± 11%     -21.6%    1450742 ± 15%  interrupts.CPU1.TLB:TLB_shootdowns
      0.33 ±141%      +0.0%       0.33 ±141%  interrupts.CPU10.129:PCI-MSI.31981662-edge.i40e-eth0-TxRx-93
      0.00          -100.0%       0.00        interrupts.CPU10.293:PCI-MSI.327680-edge.xhci_hcd
      6.33 ±119%    -100.0%       0.00        interrupts.CPU10.46:PCI-MSI.31981579-edge.i40e-eth0-TxRx-10
      0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU10.81:PCI-MSI.31981614-edge.i40e-eth0-TxRx-45
   1625671 ±  7%      +0.9%    1640988 ± 22%  interrupts.CPU10.CAL:Function_call_interrupts
      5.00 ±127%      +6.7%       5.33 ± 70%  interrupts.CPU10.IWI:IRQ_work_interrupts
   1989033            -5.2%    1885937 ±  4%  interrupts.CPU10.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU10.MCP:Machine_check_polls
      5423 ± 36%     -30.1%       3789 ± 49%  interrupts.CPU10.NMI:Non-maskable_interrupts
      5423 ± 36%     -30.1%       3789 ± 49%  interrupts.CPU10.PMI:Performance_monitoring_interrupts
      1207 ± 10%     +21.1%       1461 ± 26%  interrupts.CPU10.RES:Rescheduling_interrupts
   2094627 ±  6%      +3.6%    2170903 ± 22%  interrupts.CPU10.TLB:TLB_shootdowns
      0.00          -100.0%       0.00        interrupts.CPU11.297:PCI-MSI.67584-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU11.298:PCI-MSI.69632-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU11.299:PCI-MSI.69632-edge.ioat-msix
     71.33 ±130%      -4.7%      68.00 ±140%  interrupts.CPU11.47:PCI-MSI.31981580-edge.i40e-eth0-TxRx-11
      0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU11.82:PCI-MSI.31981615-edge.i40e-eth0-TxRx-46
      0.00          -100.0%       0.00        interrupts.CPU11.8:IO-APIC.8-edge.rtc0
   1395041 ±  8%      +4.6%    1459208 ± 12%  interrupts.CPU11.CAL:Function_call_interrupts
      9.00 ± 56%     -25.9%       6.67 ± 74%  interrupts.CPU11.IWI:IRQ_work_interrupts
   1993458            -4.6%    1901666 ±  3%  interrupts.CPU11.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU11.MCP:Machine_check_polls
      5832 ± 36%      -6.5%       5453 ± 36%  interrupts.CPU11.NMI:Non-maskable_interrupts
      5832 ± 36%      -6.5%       5453 ± 36%  interrupts.CPU11.PMI:Performance_monitoring_interrupts
      1049 ± 10%     +25.6%       1317 ± 25%  interrupts.CPU11.RES:Rescheduling_interrupts
   1792099 ±  8%      +7.8%    1932201 ± 11%  interrupts.CPU11.TLB:TLB_shootdowns
      0.00          -100.0%       0.00        interrupts.CPU12.298:PCI-MSI.69632-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU12.299:PCI-MSI.71680-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU12.300:PCI-MSI.71680-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU12.300:PCI-MSI.73728-edge.ioat-msix
     17.67 ±141%     -98.1%       0.33 ±141%  interrupts.CPU12.48:PCI-MSI.31981581-edge.i40e-eth0-TxRx-12
      0.33 ±141%      +0.0%       0.33 ±141%  interrupts.CPU12.83:PCI-MSI.31981616-edge.i40e-eth0-TxRx-47
   1618248 ± 19%     -14.1%    1390301 ± 10%  interrupts.CPU12.CAL:Function_call_interrupts
      7.33 ± 78%      -4.5%       7.00 ± 95%  interrupts.CPU12.IWI:IRQ_work_interrupts
   1990725            -4.4%    1903734 ±  3%  interrupts.CPU12.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU12.MCP:Machine_check_polls
      4849 ± 43%      +2.8%       4983 ± 41%  interrupts.CPU12.NMI:Non-maskable_interrupts
      4849 ± 43%      +2.8%       4983 ± 41%  interrupts.CPU12.PMI:Performance_monitoring_interrupts
      1150 ± 10%      +2.7%       1180 ± 17%  interrupts.CPU12.RES:Rescheduling_interrupts
   2081751 ± 19%     -11.7%    1837981 ±  9%  interrupts.CPU12.TLB:TLB_shootdowns
      0.00          -100.0%       0.00        interrupts.CPU13.295:PCI-MSI.65536-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU13.299:PCI-MSI.71680-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU13.300:PCI-MSI.73728-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU13.301:PCI-MSI.73728-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU13.301:PCI-MSI.75776-edge.ioat-msix
      0.33 ±141%    -100.0%       0.00        interrupts.CPU13.36:PCI-MSI.31981569-edge.i40e-eth0-TxRx-0
      2.67 ± 17%     +50.0%       4.00 ± 93%  interrupts.CPU13.49:PCI-MSI.31981582-edge.i40e-eth0-TxRx-13
      0.00          -100.0%       0.00        interrupts.CPU13.4:IO-APIC.4-edge.ttyS0
      0.33 ±141%    +100.0%       0.67 ± 70%  interrupts.CPU13.84:PCI-MSI.31981617-edge.i40e-eth0-TxRx-48
   1537516 ± 12%     -12.8%    1340073 ± 14%  interrupts.CPU13.CAL:Function_call_interrupts
      8.00 ± 46%     -16.7%       6.67 ±101%  interrupts.CPU13.IWI:IRQ_work_interrupts
   1989768            -3.8%    1915141 ±  2%  interrupts.CPU13.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU13.MCP:Machine_check_polls
      6201 ± 14%      -3.4%       5987 ± 36%  interrupts.CPU13.NMI:Non-maskable_interrupts
      6201 ± 14%      -3.4%       5987 ± 36%  interrupts.CPU13.PMI:Performance_monitoring_interrupts
      1124 ± 16%      +4.0%       1169 ± 23%  interrupts.CPU13.RES:Rescheduling_interrupts
   1976342 ± 12%     -10.5%    1769190 ± 14%  interrupts.CPU13.TLB:TLB_shootdowns
      0.00          -100.0%       0.00        interrupts.CPU14.297:PCI-MSI.67584-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU14.300:PCI-MSI.73728-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU14.301:PCI-MSI.75776-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU14.302:PCI-MSI.75776-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU14.302:PCI-MSI.77824-edge.ioat-msix
      0.67 ± 70%    -100.0%       0.00        interrupts.CPU14.37:PCI-MSI.31981570-edge.i40e-eth0-TxRx-1
      0.00          -100.0%       0.00        interrupts.CPU14.3:IO-APIC.3-edge
      0.00       +1.7e+103%      17.00 ±141%  interrupts.CPU14.4:IO-APIC.4-edge.ttyS0
      1.33 ± 70%     +25.0%       1.67 ± 74%  interrupts.CPU14.50:PCI-MSI.31981583-edge.i40e-eth0-TxRx-14
      0.67 ± 70%    -100.0%       0.00        interrupts.CPU14.85:PCI-MSI.31981618-edge.i40e-eth0-TxRx-49
   1296970 ± 18%     +18.2%    1533485 ± 24%  interrupts.CPU14.CAL:Function_call_interrupts
      5.00 ±141%    +120.0%      11.00 ± 51%  interrupts.CPU14.IWI:IRQ_work_interrupts
   1992017            -5.2%    1888723 ±  4%  interrupts.CPU14.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU14.MCP:Machine_check_polls
      4535 ± 50%     +42.0%       6438 ± 28%  interrupts.CPU14.NMI:Non-maskable_interrupts
      4535 ± 50%     +42.0%       6438 ± 28%  interrupts.CPU14.PMI:Performance_monitoring_interrupts
    967.33 ± 21%     +30.9%       1266 ± 20%  interrupts.CPU14.RES:Rescheduling_interrupts
   1668585 ± 18%     +21.6%    2029594 ± 23%  interrupts.CPU14.TLB:TLB_shootdowns
      0.00          -100.0%       0.00        interrupts.CPU15.301:PCI-MSI.73728-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU15.301:PCI-MSI.75776-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU15.302:PCI-MSI.77824-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU15.303:PCI-MSI.77824-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU15.303:PCI-MSI.79872-edge.ioat-msix
      1.00           -66.7%       0.33 ±141%  interrupts.CPU15.38:PCI-MSI.31981571-edge.i40e-eth0-TxRx-2
     17.00 ±141%    -100.0%       0.00        interrupts.CPU15.4:IO-APIC.4-edge.ttyS0
      3.67 ± 34%     +54.5%       5.67 ±141%  interrupts.CPU15.51:PCI-MSI.31981584-edge.i40e-eth0-TxRx-15
      0.33 ±141%    +200.0%       1.00        interrupts.CPU15.86:PCI-MSI.31981619-edge.i40e-eth0-TxRx-50
   1620707 ± 15%     -27.7%    1171309 ±  9%  interrupts.CPU15.CAL:Function_call_interrupts
      7.67 ± 79%     -56.5%       3.33 ±101%  interrupts.CPU15.IWI:IRQ_work_interrupts
   1989328            -3.6%    1917458 ±  2%  interrupts.CPU15.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU15.MCP:Machine_check_polls
      4826 ± 42%      -6.3%       4521 ± 26%  interrupts.CPU15.NMI:Non-maskable_interrupts
      4826 ± 42%      -6.3%       4521 ± 26%  interrupts.CPU15.PMI:Performance_monitoring_interrupts
      1178 ± 17%      -9.5%       1066 ± 16%  interrupts.CPU15.RES:Rescheduling_interrupts
   2083846 ± 15%     -25.8%    1546396 ±  9%  interrupts.CPU15.TLB:TLB_shootdowns
      0.00          -100.0%       0.00        interrupts.CPU16.302:PCI-MSI.75776-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU16.302:PCI-MSI.77824-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU16.303:PCI-MSI.79872-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU16.304:PCI-MSI.79872-edge.ioat-msix
      0.33 ±141%    +100.0%       0.67 ± 70%  interrupts.CPU16.39:PCI-MSI.31981572-edge.i40e-eth0-TxRx-3
      1.67 ± 56%    +100.0%       3.33 ±141%  interrupts.CPU16.52:PCI-MSI.31981585-edge.i40e-eth0-TxRx-16
      0.67 ± 70%     -50.0%       0.33 ±141%  interrupts.CPU16.87:PCI-MSI.31981620-edge.i40e-eth0-TxRx-51
   1338190 ± 15%      -6.0%    1257595 ± 30%  interrupts.CPU16.CAL:Function_call_interrupts
      6.67 ± 78%     -60.0%       2.67 ±115%  interrupts.CPU16.IWI:IRQ_work_interrupts
   1995772            -3.7%    1922250 ±  2%  interrupts.CPU16.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU16.MCP:Machine_check_polls
      5845 ± 26%     -45.2%       3201 ± 41%  interrupts.CPU16.NMI:Non-maskable_interrupts
      5845 ± 26%     -45.2%       3201 ± 41%  interrupts.CPU16.PMI:Performance_monitoring_interrupts
      1030 ± 11%     +25.6%       1293 ± 24%  interrupts.CPU16.RES:Rescheduling_interrupts
   1719649 ± 15%      -3.4%    1661282 ± 30%  interrupts.CPU16.TLB:TLB_shootdowns
      0.00          -100.0%       0.00        interrupts.CPU17.295:PCI-MSI.65536-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU17.303:PCI-MSI.77824-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU17.303:PCI-MSI.79872-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU17.312:PCI-MSI.376832-edge.ahci[0000:00:17.0]
      0.00          -100.0%       0.00        interrupts.CPU17.315:PCI-MSI.376832-edge.ahci[0000:00:17.0]
      0.33 ±141%    +200.0%       1.00        interrupts.CPU17.40:PCI-MSI.31981573-edge.i40e-eth0-TxRx-4
      6.00 ±106%    +733.3%      50.00 ±135%  interrupts.CPU17.53:PCI-MSI.31981586-edge.i40e-eth0-TxRx-17
      0.33 ±141%    -100.0%       0.00        interrupts.CPU17.88:PCI-MSI.31981621-edge.i40e-eth0-TxRx-52
   1444496 ±  4%      -3.8%    1389394 ±  8%  interrupts.CPU17.CAL:Function_call_interrupts
     11.67 ± 42%     -54.3%       5.33 ±141%  interrupts.CPU17.IWI:IRQ_work_interrupts
   1993115            -4.7%    1898483 ±  3%  interrupts.CPU17.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU17.MCP:Machine_check_polls
      6333 ± 17%     -26.5%       4657 ± 47%  interrupts.CPU17.NMI:Non-maskable_interrupts
      6333 ± 17%     -26.5%       4657 ± 47%  interrupts.CPU17.PMI:Performance_monitoring_interrupts
      1045 ±  8%     +14.4%       1196 ±  7%  interrupts.CPU17.RES:Rescheduling_interrupts
   1857647 ±  4%      -1.4%    1832203 ±  8%  interrupts.CPU17.TLB:TLB_shootdowns
      0.00          -100.0%       0.00        interrupts.CPU18.304:PCI-MSI.79872-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU18.315:PCI-MSI.376832-edge.ahci[0000:00:17.0]
      0.00          -100.0%       0.00        interrupts.CPU18.41:PCI-MSI.31981574-edge.i40e-eth0-TxRx-5
      0.67 ±141%    +2e+06%      13326 ±141%  interrupts.CPU18.54:PCI-MSI.31981587-edge.i40e-eth0-TxRx-18
      0.33 ±141%    -100.0%       0.00        interrupts.CPU18.89:PCI-MSI.31981622-edge.i40e-eth0-TxRx-53
   1177104 ± 15%     +34.7%    1585576 ±  7%  interrupts.CPU18.CAL:Function_call_interrupts
      4.67 ± 78%    +100.0%       9.33 ± 70%  interrupts.CPU18.IWI:IRQ_work_interrupts
   1993097            -5.5%    1882740 ±  4%  interrupts.CPU18.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU18.MCP:Machine_check_polls
      4919 ± 29%     +20.8%       5942 ± 37%  interrupts.CPU18.NMI:Non-maskable_interrupts
      4919 ± 29%     +20.8%       5942 ± 37%  interrupts.CPU18.PMI:Performance_monitoring_interrupts
    882.67 ± 10%     +49.8%       1322 ± 16%  interrupts.CPU18.RES:Rescheduling_interrupts
   1514086 ± 15%     +38.1%    2090275 ±  7%  interrupts.CPU18.TLB:TLB_shootdowns
      0.00          -100.0%       0.00        interrupts.CPU19.315:PCI-MSI.376832-edge.ahci[0000:00:17.0]
      0.00          -100.0%       0.00        interrupts.CPU19.3:IO-APIC.3-edge
      0.33 ±141%      +0.0%       0.33 ±141%  interrupts.CPU19.42:PCI-MSI.31981575-edge.i40e-eth0-TxRx-6
     12.67 ±108%     -92.1%       1.00 ±141%  interrupts.CPU19.55:PCI-MSI.31981588-edge.i40e-eth0-TxRx-19
      0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU19.90:PCI-MSI.31981623-edge.i40e-eth0-TxRx-54
   1561977 ± 18%      -7.2%    1449390 ± 18%  interrupts.CPU19.CAL:Function_call_interrupts
     14.33 ± 16%     -65.1%       5.00 ±114%  interrupts.CPU19.IWI:IRQ_work_interrupts
   1993851            -4.9%    1896679 ±  3%  interrupts.CPU19.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU19.MCP:Machine_check_polls
      7425 ±  6%     -39.0%       4529 ± 44%  interrupts.CPU19.NMI:Non-maskable_interrupts
      7425 ±  6%     -39.0%       4529 ± 44%  interrupts.CPU19.PMI:Performance_monitoring_interrupts
      1145 ± 13%     +21.0%       1385 ± 23%  interrupts.CPU19.RES:Rescheduling_interrupts
   2008922 ± 18%      -4.7%    1913691 ± 18%  interrupts.CPU19.TLB:TLB_shootdowns
      0.33 ±141%      +0.0%       0.33 ±141%  interrupts.CPU2.121:PCI-MSI.31981654-edge.i40e-eth0-TxRx-85
      5.00 ±127%   +1260.0%      68.00 ±137%  interrupts.CPU2.38:PCI-MSI.31981571-edge.i40e-eth0-TxRx-2
      0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU2.73:PCI-MSI.31981606-edge.i40e-eth0-TxRx-37
   1147375 ± 20%     +11.1%    1274389 ± 13%  interrupts.CPU2.CAL:Function_call_interrupts
      1.67 ±141%    +280.0%       6.33 ± 77%  interrupts.CPU2.IWI:IRQ_work_interrupts
   1997979            -4.7%    1903836 ±  3%  interrupts.CPU2.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU2.MCP:Machine_check_polls
      3377 ± 21%     +32.7%       4481 ± 36%  interrupts.CPU2.NMI:Non-maskable_interrupts
      3377 ± 21%     +32.7%       4481 ± 36%  interrupts.CPU2.PMI:Performance_monitoring_interrupts
    858.67 ± 19%     +26.5%       1086 ± 14%  interrupts.CPU2.RES:Rescheduling_interrupts
   1474507 ± 20%     +13.9%    1678829 ± 13%  interrupts.CPU2.TLB:TLB_shootdowns
      0.00          -100.0%       0.00        interrupts.CPU20.3:IO-APIC.3-edge
      0.33 ±141%      +0.0%       0.33 ±141%  interrupts.CPU20.43:PCI-MSI.31981576-edge.i40e-eth0-TxRx-7
      1.67 ±141%     -60.0%       0.67 ± 70%  interrupts.CPU20.56:PCI-MSI.31981589-edge.i40e-eth0-TxRx-20
      0.33 ±141%    -100.0%       0.00        interrupts.CPU20.91:PCI-MSI.31981624-edge.i40e-eth0-TxRx-55
   1691403 ± 10%     -11.8%    1492098 ± 10%  interrupts.CPU20.CAL:Function_call_interrupts
      8.33 ± 73%     +40.0%      11.67 ± 14%  interrupts.CPU20.IWI:IRQ_work_interrupts
   1991561            -5.3%    1886034 ±  4%  interrupts.CPU20.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU20.MCP:Machine_check_polls
      5837 ± 27%     +18.1%       6892 ±  9%  interrupts.CPU20.NMI:Non-maskable_interrupts
      5837 ± 27%     +18.1%       6892 ±  9%  interrupts.CPU20.PMI:Performance_monitoring_interrupts
      1258 ±  5%      +5.4%       1326 ± 15%  interrupts.CPU20.RES:Rescheduling_interrupts
   2178393 ± 10%      -9.4%    1974448 ± 10%  interrupts.CPU20.TLB:TLB_shootdowns
      0.00          -100.0%       0.00        interrupts.CPU21.295:PCI-MSI.65536-edge.ioat-msix
      0.67 ± 70%     -50.0%       0.33 ±141%  interrupts.CPU21.44:PCI-MSI.31981577-edge.i40e-eth0-TxRx-8
      7.33 ± 65%   +1590.9%     124.00 ±140%  interrupts.CPU21.57:PCI-MSI.31981590-edge.i40e-eth0-TxRx-21
      0.67 ± 70%     -50.0%       0.33 ±141%  interrupts.CPU21.92:PCI-MSI.31981625-edge.i40e-eth0-TxRx-56
   1830276 ±  6%     -17.1%    1516390 ±  7%  interrupts.CPU21.CAL:Function_call_interrupts
      3.67 ± 78%      +9.1%       4.00 ± 93%  interrupts.CPU21.IWI:IRQ_work_interrupts
   1989018            -4.7%    1894771 ±  3%  interrupts.CPU21.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU21.MCP:Machine_check_polls
      4101 ± 51%     +10.3%       4524 ± 26%  interrupts.CPU21.NMI:Non-maskable_interrupts
      4101 ± 51%     +10.3%       4524 ± 26%  interrupts.CPU21.PMI:Performance_monitoring_interrupts
      1308 ±  4%      +7.1%       1402 ± 18%  interrupts.CPU21.RES:Rescheduling_interrupts
   2354242 ±  6%     -15.0%    2000536 ±  7%  interrupts.CPU21.TLB:TLB_shootdowns
      0.67 ± 70%     -50.0%       0.33 ±141%  interrupts.CPU22.45:PCI-MSI.31981578-edge.i40e-eth0-TxRx-9
      2.00 ±141%   +6150.0%     125.00 ±133%  interrupts.CPU22.58:PCI-MSI.31981591-edge.i40e-eth0-TxRx-22
      0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU22.93:PCI-MSI.31981626-edge.i40e-eth0-TxRx-57
   1675054 ±  7%      -9.9%    1508895 ± 14%  interrupts.CPU22.CAL:Function_call_interrupts
      8.00 ± 77%     -37.5%       5.00 ±114%  interrupts.CPU22.IWI:IRQ_work_interrupts
   1988457            -4.8%    1893025 ±  4%  interrupts.CPU22.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU22.MCP:Machine_check_polls
      6157 ± 19%     -32.9%       4133 ± 60%  interrupts.CPU22.NMI:Non-maskable_interrupts
      6157 ± 19%     -32.9%       4133 ± 60%  interrupts.CPU22.PMI:Performance_monitoring_interrupts
      1262 ± 11%      +0.3%       1265 ± 23%  interrupts.CPU22.RES:Rescheduling_interrupts
   2152987 ±  6%      -7.3%    1995588 ± 14%  interrupts.CPU22.TLB:TLB_shootdowns
      0.33 ±141%    -100.0%       0.00        interrupts.CPU23.46:PCI-MSI.31981579-edge.i40e-eth0-TxRx-10
      1.33 ±141%   +5075.0%      69.00 ±140%  interrupts.CPU23.59:PCI-MSI.31981592-edge.i40e-eth0-TxRx-23
      0.67 ± 70%      +0.0%       0.67 ± 70%  interrupts.CPU23.94:PCI-MSI.31981627-edge.i40e-eth0-TxRx-58
   1696874 ± 11%      -2.7%    1650487 ± 13%  interrupts.CPU23.CAL:Function_call_interrupts
      4.67 ±141%    +228.6%      15.33 ±  6%  interrupts.CPU23.IWI:IRQ_work_interrupts
   1988736            -5.1%    1888060 ±  3%  interrupts.CPU23.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU23.MCP:Machine_check_polls
      4509 ± 51%     +72.9%       7795        interrupts.CPU23.NMI:Non-maskable_interrupts
      4509 ± 51%     +72.9%       7795        interrupts.CPU23.PMI:Performance_monitoring_interrupts
      1280 ± 12%      +5.2%       1347 ± 19%  interrupts.CPU23.RES:Rescheduling_interrupts
   2183128 ± 11%      +0.0%    2183294 ± 13%  interrupts.CPU23.TLB:TLB_shootdowns
     13.33 ± 91%   +1570.0%     222.67 ± 80%  interrupts.CPU24.60:PCI-MSI.31981593-edge.i40e-eth0-TxRx-24
   1463182 ± 13%      -9.0%    1331815 ± 19%  interrupts.CPU24.CAL:Function_call_interrupts
      5.00 ±127%    -100.0%       0.00        interrupts.CPU24.IWI:IRQ_work_interrupts
   1991001            -4.3%    1905975 ±  3%  interrupts.CPU24.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU24.MCP:Machine_check_polls
      5482 ± 36%     -44.4%       3046 ±  7%  interrupts.CPU24.NMI:Non-maskable_interrupts
      5482 ± 36%     -44.4%       3046 ±  7%  interrupts.CPU24.PMI:Performance_monitoring_interrupts
    975.33 ± 14%     +10.9%       1081 ±  6%  interrupts.CPU24.RES:Rescheduling_interrupts
   1874140 ± 13%      -6.8%    1746145 ± 20%  interrupts.CPU24.TLB:TLB_shootdowns
     14740 ±137%    -100.0%       4.00 ± 81%  interrupts.CPU25.61:PCI-MSI.31981594-edge.i40e-eth0-TxRx-25
   1468546 ± 22%      +2.0%    1498192 ± 10%  interrupts.CPU25.CAL:Function_call_interrupts
      9.33 ± 35%     +10.7%      10.33 ± 50%  interrupts.CPU25.IWI:IRQ_work_interrupts
   1990968            -4.6%    1899327 ±  3%  interrupts.CPU25.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU25.MCP:Machine_check_polls
      6012 ± 21%      +7.4%       6454 ± 29%  interrupts.CPU25.NMI:Non-maskable_interrupts
      6012 ± 21%      +7.4%       6454 ± 29%  interrupts.CPU25.PMI:Performance_monitoring_interrupts
      1057 ± 24%      +1.8%       1076 ± 11%  interrupts.CPU25.RES:Rescheduling_interrupts
   1886599 ± 22%      +4.1%    1963140 ± 10%  interrupts.CPU25.TLB:TLB_shootdowns
      0.00          -100.0%       0.00        interrupts.CPU26.305:PCI-MSI.67174400-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU26.306:PCI-MSI.67174400-edge.ioat-msix
      0.33 ±141%    +500.0%       2.00 ± 70%  interrupts.CPU26.62:PCI-MSI.31981595-edge.i40e-eth0-TxRx-26
   1502439 ± 30%      -9.8%    1354664 ± 14%  interrupts.CPU26.CAL:Function_call_interrupts
      4.33 ± 71%    +123.1%       9.67 ± 70%  interrupts.CPU26.IWI:IRQ_work_interrupts
   1986642            -3.7%    1912869 ±  3%  interrupts.CPU26.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU26.MCP:Machine_check_polls
      4252 ± 50%     +44.7%       6150 ± 37%  interrupts.CPU26.NMI:Non-maskable_interrupts
      4252 ± 50%     +44.7%       6150 ± 37%  interrupts.CPU26.PMI:Performance_monitoring_interrupts
      1049 ± 26%      +0.1%       1050 ± 22%  interrupts.CPU26.RES:Rescheduling_interrupts
   1926881 ± 30%      -8.0%    1771893 ± 14%  interrupts.CPU26.TLB:TLB_shootdowns
      0.00          -100.0%       0.00        interrupts.CPU27.307:PCI-MSI.67176448-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU27.308:PCI-MSI.67176448-edge.ioat-msix
    100.33 ±138%     -95.3%       4.67 ± 36%  interrupts.CPU27.63:PCI-MSI.31981596-edge.i40e-eth0-TxRx-27
   1237723 ± 20%     +25.3%    1550313 ± 10%  interrupts.CPU27.CAL:Function_call_interrupts
      9.67 ± 46%      -3.4%       9.33 ± 70%  interrupts.CPU27.IWI:IRQ_work_interrupts
   1992540            -4.8%    1896087 ±  3%  interrupts.CPU27.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU27.MCP:Machine_check_polls
      6119 ± 19%      -2.9%       5939 ± 36%  interrupts.CPU27.NMI:Non-maskable_interrupts
      6119 ± 19%      -2.9%       5939 ± 36%  interrupts.CPU27.PMI:Performance_monitoring_interrupts
    921.33 ± 11%     +28.3%       1181 ±  8%  interrupts.CPU27.RES:Rescheduling_interrupts
   1587131 ± 20%     +28.3%    2036749 ± 10%  interrupts.CPU27.TLB:TLB_shootdowns
      0.00          -100.0%       0.00        interrupts.CPU28.308:PCI-MSI.67178496-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU28.309:PCI-MSI.67178496-edge.ioat-msix
      4.00 ± 70%     -41.7%       2.33 ± 72%  interrupts.CPU28.64:PCI-MSI.31981597-edge.i40e-eth0-TxRx-28
   1240423 ± 12%     +15.5%    1432419 ±  2%  interrupts.CPU28.CAL:Function_call_interrupts
      9.67 ± 70%     -44.8%       5.33 ±141%  interrupts.CPU28.IWI:IRQ_work_interrupts
   1993926            -4.4%    1906611 ±  3%  interrupts.CPU28.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU28.MCP:Machine_check_polls
      5792 ± 36%     -22.2%       4507 ± 51%  interrupts.CPU28.NMI:Non-maskable_interrupts
      5792 ± 36%     -22.2%       4507 ± 51%  interrupts.CPU28.PMI:Performance_monitoring_interrupts
    848.33 ±  6%     +25.2%       1062 ±  9%  interrupts.CPU28.RES:Rescheduling_interrupts
   1590102 ± 12%     +18.2%    1880052 ±  2%  interrupts.CPU28.TLB:TLB_shootdowns
      0.00          -100.0%       0.00        interrupts.CPU29.309:PCI-MSI.67180544-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU29.310:PCI-MSI.67180544-edge.ioat-msix
      2.33 ± 72%      +0.0%       2.33 ± 20%  interrupts.CPU29.65:PCI-MSI.31981598-edge.i40e-eth0-TxRx-29
   1344495 ± 16%     +30.0%    1748149 ± 13%  interrupts.CPU29.CAL:Function_call_interrupts
      9.33 ± 66%     +10.7%      10.33 ± 70%  interrupts.CPU29.IWI:IRQ_work_interrupts
   1993317            -5.4%    1885368 ±  4%  interrupts.CPU29.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU29.MCP:Machine_check_polls
      6714 ± 12%      -8.9%       6119 ± 34%  interrupts.CPU29.NMI:Non-maskable_interrupts
      6714 ± 12%      -8.9%       6119 ± 34%  interrupts.CPU29.PMI:Performance_monitoring_interrupts
      1002 ± 16%     +30.1%       1304 ± 21%  interrupts.CPU29.RES:Rescheduling_interrupts
   1722844 ± 16%     +33.0%    2291363 ± 12%  interrupts.CPU29.TLB:TLB_shootdowns
      0.33 ±141%      +0.0%       0.33 ±141%  interrupts.CPU3.122:PCI-MSI.31981655-edge.i40e-eth0-TxRx-86
      1.00 ±141%  +1.3e+06%      13206 ±141%  interrupts.CPU3.39:PCI-MSI.31981572-edge.i40e-eth0-TxRx-3
      0.33 ±141%    -100.0%       0.00        interrupts.CPU3.74:PCI-MSI.31981607-edge.i40e-eth0-TxRx-38
   1335983 ± 14%     -20.1%    1067579 ± 15%  interrupts.CPU3.CAL:Function_call_interrupts
     10.33 ± 38%      -6.5%       9.67 ± 65%  interrupts.CPU3.IWI:IRQ_work_interrupts
   1995119            -3.4%    1927081 ±  2%  interrupts.CPU3.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU3.MCP:Machine_check_polls
      6055 ± 29%      +2.5%       6203 ± 24%  interrupts.CPU3.NMI:Non-maskable_interrupts
      6055 ± 29%      +2.5%       6203 ± 24%  interrupts.CPU3.PMI:Performance_monitoring_interrupts
    995.00 ± 11%      -1.6%     978.67 ± 29%  interrupts.CPU3.RES:Rescheduling_interrupts
   1721781 ± 14%     -18.1%    1409480 ± 15%  interrupts.CPU3.TLB:TLB_shootdowns
      0.00          -100.0%       0.00        interrupts.CPU30.310:PCI-MSI.67182592-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU30.311:PCI-MSI.67182592-edge.ioat-msix
      2.33 ±112%     -28.6%       1.67 ±101%  interrupts.CPU30.66:PCI-MSI.31981599-edge.i40e-eth0-TxRx-30
   1286556 ± 17%     +12.0%    1440688 ± 15%  interrupts.CPU30.CAL:Function_call_interrupts
     12.67 ± 26%    -100.0%       0.00        interrupts.CPU30.IWI:IRQ_work_interrupts
   1992654            -3.9%    1915837 ±  2%  interrupts.CPU30.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU30.MCP:Machine_check_polls
      7066 ± 14%     -66.4%       2377 ± 28%  interrupts.CPU30.NMI:Non-maskable_interrupts
      7066 ± 14%     -66.4%       2377 ± 28%  interrupts.CPU30.PMI:Performance_monitoring_interrupts
    952.67 ± 14%     +18.2%       1125 ± 27%  interrupts.CPU30.RES:Rescheduling_interrupts
   1647271 ± 17%     +14.6%    1887415 ± 15%  interrupts.CPU30.TLB:TLB_shootdowns
      0.00          -100.0%       0.00        interrupts.CPU31.310:PCI-MSI.67180544-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU31.311:PCI-MSI.67182592-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU31.311:PCI-MSI.67184640-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU31.312:PCI-MSI.67184640-edge.ioat-msix
      0.33 ±141%   +1000.0%       3.67 ± 78%  interrupts.CPU31.67:PCI-MSI.31981600-edge.i40e-eth0-TxRx-31
   2057353 ±  5%     -21.6%    1612737 ± 13%  interrupts.CPU31.CAL:Function_call_interrupts
     16.00           -56.2%       7.00 ± 72%  interrupts.CPU31.IWI:IRQ_work_interrupts
   1988101            -4.9%    1889733 ±  4%  interrupts.CPU31.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU31.MCP:Machine_check_polls
      7791           -32.8%       5238 ± 35%  interrupts.CPU31.NMI:Non-maskable_interrupts
      7791           -32.8%       5238 ± 35%  interrupts.CPU31.PMI:Performance_monitoring_interrupts
      1323 ±  2%      -6.6%       1236 ± 15%  interrupts.CPU31.RES:Rescheduling_interrupts
   2637037 ±  5%     -19.8%    2114244 ± 13%  interrupts.CPU31.TLB:TLB_shootdowns
      0.00          -100.0%       0.00        interrupts.CPU32.311:PCI-MSI.67182592-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU32.312:PCI-MSI.67184640-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU32.313:PCI-MSI.67186688-edge.ioat-msix
      4574 ±141%     -99.9%       3.00 ± 72%  interrupts.CPU32.68:PCI-MSI.31981601-edge.i40e-eth0-TxRx-32
   1725454 ±  6%      +7.3%    1852009 ±  3%  interrupts.CPU32.CAL:Function_call_interrupts
     16.00           -62.5%       6.00 ± 72%  interrupts.CPU32.IWI:IRQ_work_interrupts
   1990490            -5.6%    1879138 ±  4%  interrupts.CPU32.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU32.MCP:Machine_check_polls
      7791           -38.6%       4781 ± 28%  interrupts.CPU32.NMI:Non-maskable_interrupts
      7791           -38.6%       4781 ± 28%  interrupts.CPU32.PMI:Performance_monitoring_interrupts
      1192 ±  6%     +12.0%       1336 ±  9%  interrupts.CPU32.RES:Rescheduling_interrupts
   2213826 ±  6%      +9.7%    2429118 ±  3%  interrupts.CPU32.TLB:TLB_shootdowns
      0.00          -100.0%       0.00        interrupts.CPU33.313:PCI-MSI.67184640-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU33.313:PCI-MSI.67186688-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU33.314:PCI-MSI.67188736-edge.ioat-msix
      1.33 ±141%  +24200.0%     324.00 ±140%  interrupts.CPU33.69:PCI-MSI.31981602-edge.i40e-eth0-TxRx-33
   1644554 ±  7%      +1.7%    1672276 ± 13%  interrupts.CPU33.CAL:Function_call_interrupts
      8.67 ± 66%      -7.7%       8.00 ± 66%  interrupts.CPU33.IWI:IRQ_work_interrupts
   1994828            -4.8%    1898886 ±  3%  interrupts.CPU33.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU33.MCP:Machine_check_polls
      5463 ± 44%      -7.0%       5083 ± 48%  interrupts.CPU33.NMI:Non-maskable_interrupts
      5463 ± 44%      -7.0%       5083 ± 48%  interrupts.CPU33.PMI:Performance_monitoring_interrupts
      1087 ±  4%     +19.9%       1303 ± 24%  interrupts.CPU33.RES:Rescheduling_interrupts
   2110273 ±  6%      +3.7%    2188459 ± 13%  interrupts.CPU33.TLB:TLB_shootdowns
      0.00          -100.0%       0.00        interrupts.CPU34.314:PCI-MSI.67186688-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU34.314:PCI-MSI.67188736-edge.ioat-msix
      1.00 ±141%     +66.7%       1.67 ±101%  interrupts.CPU34.70:PCI-MSI.31981603-edge.i40e-eth0-TxRx-34
   1527781 ± 11%     +10.3%    1684904 ± 13%  interrupts.CPU34.CAL:Function_call_interrupts
      3.67 ± 68%     +45.5%       5.33 ±141%  interrupts.CPU34.IWI:IRQ_work_interrupts
   1990610            -5.2%    1887747 ±  4%  interrupts.CPU34.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU34.MCP:Machine_check_polls
      4974 ± 14%     -18.1%       4076 ± 66%  interrupts.CPU34.NMI:Non-maskable_interrupts
      4974 ± 14%     -18.1%       4076 ± 66%  interrupts.CPU34.PMI:Performance_monitoring_interrupts
      1075 ± 14%     +26.9%       1364 ± 25%  interrupts.CPU34.RES:Rescheduling_interrupts
   1958180 ± 12%     +12.7%    2206294 ± 13%  interrupts.CPU34.TLB:TLB_shootdowns
      0.00          -100.0%       0.00        interrupts.CPU35.315:PCI-MSI.67188736-edge.ioat-msix
      0.00         +2e+102%       2.00 ± 81%  interrupts.CPU35.71:PCI-MSI.31981604-edge.i40e-eth0-TxRx-35
   1662564 ±  7%     +16.8%    1941183 ±  7%  interrupts.CPU35.CAL:Function_call_interrupts
     11.33 ± 58%     -11.8%      10.00 ± 45%  interrupts.CPU35.IWI:IRQ_work_interrupts
   1990589            -6.1%    1868728 ±  4%  interrupts.CPU35.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU35.MCP:Machine_check_polls
      7079 ± 14%     -14.6%       6045 ± 25%  interrupts.CPU35.NMI:Non-maskable_interrupts
      7079 ± 14%     -14.6%       6045 ± 25%  interrupts.CPU35.PMI:Performance_monitoring_interrupts
      1096 ±  8%     +26.1%       1383 ± 14%  interrupts.CPU35.RES:Rescheduling_interrupts
   2128713 ±  7%     +19.7%    2548542 ±  7%  interrupts.CPU35.TLB:TLB_shootdowns
      2.00 ± 81%     +16.7%       2.33 ±112%  interrupts.CPU36.72:PCI-MSI.31981605-edge.i40e-eth0-TxRx-36
   1767839 ± 20%     -17.6%    1457064 ±  7%  interrupts.CPU36.CAL:Function_call_interrupts
      7.67 ± 74%      -4.3%       7.33 ± 75%  interrupts.CPU36.IWI:IRQ_work_interrupts
   1990955            -4.5%    1900896 ±  3%  interrupts.CPU36.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU36.MCP:Machine_check_polls
      6227 ± 15%     -23.1%       4791 ± 47%  interrupts.CPU36.NMI:Non-maskable_interrupts
      6227 ± 15%     -23.1%       4791 ± 47%  interrupts.CPU36.PMI:Performance_monitoring_interrupts
      1126 ± 18%      +4.2%       1173 ± 12%  interrupts.CPU36.RES:Rescheduling_interrupts
   2270173 ± 21%     -16.0%    1906743 ±  7%  interrupts.CPU36.TLB:TLB_shootdowns
      0.00       +2.7e+102%       2.67 ±115%  interrupts.CPU37.73:PCI-MSI.31981606-edge.i40e-eth0-TxRx-37
   1643441 ± 22%      +1.3%    1664414 ±  9%  interrupts.CPU37.CAL:Function_call_interrupts
      9.00 ± 74%     -85.2%       1.33 ±141%  interrupts.CPU37.IWI:IRQ_work_interrupts
   1989272            -5.0%    1888923 ±  3%  interrupts.CPU37.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU37.MCP:Machine_check_polls
      5801 ± 33%     -43.4%       3281 ± 17%  interrupts.CPU37.NMI:Non-maskable_interrupts
      5801 ± 33%     -43.4%       3281 ± 17%  interrupts.CPU37.PMI:Performance_monitoring_interrupts
      1104 ± 18%     +19.2%       1316 ± 13%  interrupts.CPU37.RES:Rescheduling_interrupts
   2106730 ± 22%      +3.6%    2183317 ±  9%  interrupts.CPU37.TLB:TLB_shootdowns
      1.67 ±101%     +40.0%       2.33 ±141%  interrupts.CPU38.74:PCI-MSI.31981607-edge.i40e-eth0-TxRx-38
   1505266 ± 26%     +14.5%    1723663 ±  3%  interrupts.CPU38.CAL:Function_call_interrupts
      6.00 ± 95%     +94.4%      11.67 ± 28%  interrupts.CPU38.IWI:IRQ_work_interrupts
   1991279            -5.2%    1887924 ±  3%  interrupts.CPU38.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU38.MCP:Machine_check_polls
      5178 ± 36%     +27.9%       6623 ± 12%  interrupts.CPU38.NMI:Non-maskable_interrupts
      5178 ± 36%     +27.9%       6623 ± 12%  interrupts.CPU38.PMI:Performance_monitoring_interrupts
    999.33 ± 23%     +30.3%       1302 ± 17%  interrupts.CPU38.RES:Rescheduling_interrupts
   1929390 ± 26%     +17.3%    2263185 ±  3%  interrupts.CPU38.TLB:TLB_shootdowns
      1.00 ±141%  +1.2e+05%       1172 ±141%  interrupts.CPU39.75:PCI-MSI.31981608-edge.i40e-eth0-TxRx-39
   1633753 ± 13%     +13.1%    1847040 ± 11%  interrupts.CPU39.CAL:Function_call_interrupts
      8.00 ± 81%     -58.3%       3.33 ± 74%  interrupts.CPU39.IWI:IRQ_work_interrupts
   1989619            -5.1%    1887275 ±  3%  interrupts.CPU39.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU39.MCP:Machine_check_polls
      4845 ± 53%     -24.7%       3647 ± 43%  interrupts.CPU39.NMI:Non-maskable_interrupts
      4845 ± 53%     -24.7%       3647 ± 43%  interrupts.CPU39.PMI:Performance_monitoring_interrupts
      1098 ± 10%     +26.0%       1383 ± 22%  interrupts.CPU39.RES:Rescheduling_interrupts
   2097391 ± 13%     +15.5%    2423173 ± 11%  interrupts.CPU39.TLB:TLB_shootdowns
      0.33 ±141%    +100.0%       0.67 ± 70%  interrupts.CPU4.123:PCI-MSI.31981656-edge.i40e-eth0-TxRx-87
      0.00          -100.0%       0.00        interrupts.CPU4.297:PCI-MSI.67584-edge.ioat-msix
      2.00 ±108%     -16.7%       1.67 ±101%  interrupts.CPU4.40:PCI-MSI.31981573-edge.i40e-eth0-TxRx-4
      0.33 ±141%      +0.0%       0.33 ±141%  interrupts.CPU4.75:PCI-MSI.31981608-edge.i40e-eth0-TxRx-39
   1077374 ± 21%     +48.8%    1603060        interrupts.CPU4.CAL:Function_call_interrupts
      2.33 ± 72%    +471.4%      13.33 ± 28%  interrupts.CPU4.IWI:IRQ_work_interrupts
   1998250            -5.9%    1879625 ±  3%  interrupts.CPU4.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU4.MCP:Machine_check_polls
      4172 ± 30%     +55.7%       6495 ± 28%  interrupts.CPU4.NMI:Non-maskable_interrupts
      4172 ± 30%     +55.7%       6495 ± 28%  interrupts.CPU4.PMI:Performance_monitoring_interrupts
    859.33 ± 13%     +57.3%       1351 ± 19%  interrupts.CPU4.RES:Rescheduling_interrupts
   1386214 ± 21%     +52.6%    2114757        interrupts.CPU4.TLB:TLB_shootdowns
      1.33 ±141%   +1275.0%      18.33 ±137%  interrupts.CPU40.76:PCI-MSI.31981609-edge.i40e-eth0-TxRx-40
   1568390 ± 12%      +7.7%    1688730 ± 14%  interrupts.CPU40.CAL:Function_call_interrupts
      8.33 ± 65%     -36.0%       5.33 ±128%  interrupts.CPU40.IWI:IRQ_work_interrupts
   1990487            -5.4%    1882230 ±  4%  interrupts.CPU40.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU40.MCP:Machine_check_polls
      6466 ± 12%     -28.9%       4596 ± 47%  interrupts.CPU40.NMI:Non-maskable_interrupts
      6466 ± 12%     -28.9%       4596 ± 47%  interrupts.CPU40.PMI:Performance_monitoring_interrupts
      1079 ± 14%     +14.5%       1235 ± 12%  interrupts.CPU40.RES:Rescheduling_interrupts
   2011469 ± 12%     +10.3%    2219108 ± 14%  interrupts.CPU40.TLB:TLB_shootdowns
   1618803 ± 13%      +6.6%    1725687 ±  9%  interrupts.CPU41.CAL:Function_call_interrupts
     10.67 ± 70%     +15.6%      12.33 ± 36%  interrupts.CPU41.IWI:IRQ_work_interrupts
   1988954            -5.1%    1888087 ±  3%  interrupts.CPU41.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU41.MCP:Machine_check_polls
      6146 ± 37%      +8.7%       6680 ± 21%  interrupts.CPU41.NMI:Non-maskable_interrupts
      6146 ± 37%      +8.7%       6680 ± 21%  interrupts.CPU41.PMI:Performance_monitoring_interrupts
      1149 ± 13%      +9.5%       1257 ± 11%  interrupts.CPU41.RES:Rescheduling_interrupts
   2077013 ± 13%      +9.0%    2262977 ±  9%  interrupts.CPU41.TLB:TLB_shootdowns
      0.33 ±141%    +200.0%       1.00 ± 81%  interrupts.CPU42.78:PCI-MSI.31981611-edge.i40e-eth0-TxRx-42
   1627649 ±  8%      -0.6%    1618093 ± 11%  interrupts.CPU42.CAL:Function_call_interrupts
      8.67 ± 66%     -69.2%       2.67 ±141%  interrupts.CPU42.IWI:IRQ_work_interrupts
   1991940            -4.6%    1901174 ±  2%  interrupts.CPU42.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU42.MCP:Machine_check_polls
      5457 ± 33%     -41.1%       3216 ± 14%  interrupts.CPU42.NMI:Non-maskable_interrupts
      5457 ± 33%     -41.1%       3216 ± 14%  interrupts.CPU42.PMI:Performance_monitoring_interrupts
      1127 ±  4%      +9.6%       1235 ± 25%  interrupts.CPU42.RES:Rescheduling_interrupts
   2082468 ±  8%      +1.9%    2121689 ± 11%  interrupts.CPU42.TLB:TLB_shootdowns
      0.00       +1.7e+102%       1.67 ±141%  interrupts.CPU43.79:PCI-MSI.31981612-edge.i40e-eth0-TxRx-43
   1644748 ±  4%      +2.1%    1678906 ±  7%  interrupts.CPU43.CAL:Function_call_interrupts
      4.67 ± 72%     +21.4%       5.67 ± 71%  interrupts.CPU43.IWI:IRQ_work_interrupts
   1990667            -5.2%    1887499 ±  4%  interrupts.CPU43.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU43.MCP:Machine_check_polls
      3993 ± 53%     +30.6%       5215 ± 37%  interrupts.CPU43.NMI:Non-maskable_interrupts
      3993 ± 53%     +30.6%       5215 ± 37%  interrupts.CPU43.PMI:Performance_monitoring_interrupts
      1140 ±  7%     +13.4%       1294 ± 15%  interrupts.CPU43.RES:Rescheduling_interrupts
   2107486 ±  4%      +4.6%    2204759 ±  7%  interrupts.CPU43.TLB:TLB_shootdowns
     54.00 ±140%    -100.0%       0.00        interrupts.CPU44.80:PCI-MSI.31981613-edge.i40e-eth0-TxRx-44
   1795845 ± 12%      +3.8%    1864364 ±  2%  interrupts.CPU44.CAL:Function_call_interrupts
      2.00 ± 40%    +400.0%      10.00 ± 63%  interrupts.CPU44.IWI:IRQ_work_interrupts
   1990784            -5.8%    1874542 ±  4%  interrupts.CPU44.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU44.MCP:Machine_check_polls
      3810 ± 52%     +57.6%       6006 ± 31%  interrupts.CPU44.NMI:Non-maskable_interrupts
      3810 ± 52%     +57.6%       6006 ± 31%  interrupts.CPU44.PMI:Performance_monitoring_interrupts
      1188 ±  9%     +16.5%       1385 ± 13%  interrupts.CPU44.RES:Rescheduling_interrupts
   2306580 ± 12%      +6.1%    2447879 ±  2%  interrupts.CPU44.TLB:TLB_shootdowns
      0.00         +1e+102%       1.00 ±141%  interrupts.CPU45.81:PCI-MSI.31981614-edge.i40e-eth0-TxRx-45
   1851022 ±  2%      +4.0%    1924428 ±  4%  interrupts.CPU45.CAL:Function_call_interrupts
     10.33 ± 25%     -32.3%       7.00 ± 88%  interrupts.CPU45.IWI:IRQ_work_interrupts
   1990639            -5.9%    1873605 ±  4%  interrupts.CPU45.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU45.MCP:Machine_check_polls
      6169 ± 17%     -17.2%       5105 ± 39%  interrupts.CPU45.NMI:Non-maskable_interrupts
      6169 ± 17%     -17.2%       5105 ± 39%  interrupts.CPU45.PMI:Performance_monitoring_interrupts
      1222 ±  5%     +13.6%       1388 ±  8%  interrupts.CPU45.RES:Rescheduling_interrupts
   2377566 ±  2%      +6.3%    2527078 ±  4%  interrupts.CPU45.TLB:TLB_shootdowns
    111.67 ±141%     -98.2%       2.00 ±141%  interrupts.CPU46.82:PCI-MSI.31981615-edge.i40e-eth0-TxRx-46
   1855562 ± 14%      -2.9%    1801318 ±  3%  interrupts.CPU46.CAL:Function_call_interrupts
      9.00 ± 68%      +0.0%       9.00 ± 70%  interrupts.CPU46.IWI:IRQ_work_interrupts
   1987637            -5.4%    1880667 ±  4%  interrupts.CPU46.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU46.MCP:Machine_check_polls
      6558 ± 13%      -7.9%       6037 ± 37%  interrupts.CPU46.NMI:Non-maskable_interrupts
      6558 ± 13%      -7.9%       6037 ± 37%  interrupts.CPU46.PMI:Performance_monitoring_interrupts
      1218 ±  9%     +10.4%       1345 ± 11%  interrupts.CPU46.RES:Rescheduling_interrupts
   2381071 ± 14%      -0.6%    2367883 ±  3%  interrupts.CPU46.TLB:TLB_shootdowns
      0.00       +6.2e+105%       6212 ±141%  interrupts.CPU47.83:PCI-MSI.31981616-edge.i40e-eth0-TxRx-47
   1888209 ±  2%     -12.4%    1654759 ± 10%  interrupts.CPU47.CAL:Function_call_interrupts
      8.00 ± 54%     -16.7%       6.67 ± 67%  interrupts.CPU47.IWI:IRQ_work_interrupts
   1990332            -4.9%    1893311 ±  3%  interrupts.CPU47.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU47.MCP:Machine_check_polls
      5052 ± 36%     -12.0%       4445 ± 35%  interrupts.CPU47.NMI:Non-maskable_interrupts
      5052 ± 36%     -12.0%       4445 ± 35%  interrupts.CPU47.PMI:Performance_monitoring_interrupts
      1261 ±  3%      +0.5%       1267 ± 14%  interrupts.CPU47.RES:Rescheduling_interrupts
   2421573 ±  2%     -10.4%    2170145 ± 10%  interrupts.CPU47.TLB:TLB_shootdowns
      0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU48.47:PCI-MSI.31981580-edge.i40e-eth0-TxRx-11
     68.33 ±137%     -96.1%       2.67 ±115%  interrupts.CPU48.84:PCI-MSI.31981617-edge.i40e-eth0-TxRx-48
      0.33 ±141%    -100.0%       0.00        interrupts.CPU48.95:PCI-MSI.31981628-edge.i40e-eth0-TxRx-59
   1772004 ± 11%      +1.9%    1805371 ±  6%  interrupts.CPU48.CAL:Function_call_interrupts
     12.33 ± 19%     -64.9%       4.33 ±125%  interrupts.CPU48.IWI:IRQ_work_interrupts
   1989127            -5.9%    1871684 ±  4%  interrupts.CPU48.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU48.MCP:Machine_check_polls
      7269 ±  5%     -30.5%       5050 ± 31%  interrupts.CPU48.NMI:Non-maskable_interrupts
      7269 ±  5%     -30.5%       5050 ± 31%  interrupts.CPU48.PMI:Performance_monitoring_interrupts
      1274 ±  7%     +19.0%       1516 ± 19%  interrupts.CPU48.RES:Rescheduling_interrupts
   2276860 ± 11%      +4.9%    2387584 ±  6%  interrupts.CPU48.TLB:TLB_shootdowns
      0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU49.48:PCI-MSI.31981581-edge.i40e-eth0-TxRx-12
    141.33 ±133%     -98.1%       2.67 ±141%  interrupts.CPU49.85:PCI-MSI.31981618-edge.i40e-eth0-TxRx-49
      0.33 ±141%      +0.0%       0.33 ±141%  interrupts.CPU49.96:PCI-MSI.31981629-edge.i40e-eth0-TxRx-60
   1565131 ± 15%     +20.0%    1878765 ±  6%  interrupts.CPU49.CAL:Function_call_interrupts
      8.67 ± 57%     +30.8%      11.33 ± 46%  interrupts.CPU49.IWI:IRQ_work_interrupts
   1988653            -6.1%    1866654 ±  4%  interrupts.CPU49.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU49.MCP:Machine_check_polls
      5648 ± 43%     +11.3%       6287 ± 26%  interrupts.CPU49.NMI:Non-maskable_interrupts
      5648 ± 43%     +11.3%       6287 ± 26%  interrupts.CPU49.PMI:Performance_monitoring_interrupts
      1171 ±  9%     +19.8%       1402 ± 13%  interrupts.CPU49.RES:Rescheduling_interrupts
   2015187 ± 15%     +23.4%    2486969 ±  6%  interrupts.CPU49.TLB:TLB_shootdowns
      0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU5.124:PCI-MSI.31981657-edge.i40e-eth0-TxRx-88
      4.67 ± 70%     -92.9%       0.33 ±141%  interrupts.CPU5.41:PCI-MSI.31981574-edge.i40e-eth0-TxRx-5
      0.33 ±141%      +0.0%       0.33 ±141%  interrupts.CPU5.76:PCI-MSI.31981609-edge.i40e-eth0-TxRx-40
   1416243 ± 24%      +1.1%    1431285 ±  7%  interrupts.CPU5.CAL:Function_call_interrupts
     14.33 ± 16%    -100.0%       0.00        interrupts.CPU5.IWI:IRQ_work_interrupts
   1994770            -5.1%    1893179 ±  3%  interrupts.CPU5.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU5.MCP:Machine_check_polls
      7308 ±  9%     -60.6%       2877        interrupts.CPU5.NMI:Non-maskable_interrupts
      7308 ±  9%     -60.6%       2877        interrupts.CPU5.PMI:Performance_monitoring_interrupts
      1113 ± 24%     +14.6%       1275 ± 11%  interrupts.CPU5.RES:Rescheduling_interrupts
   1821547 ± 24%      +3.7%    1889355 ±  7%  interrupts.CPU5.TLB:TLB_shootdowns
      1.00           -33.3%       0.67 ± 70%  interrupts.CPU50.49:PCI-MSI.31981582-edge.i40e-eth0-TxRx-13
      5580 ±141%     -99.9%       7.33 ± 67%  interrupts.CPU50.86:PCI-MSI.31981619-edge.i40e-eth0-TxRx-50
      0.00          -100.0%       0.00        interrupts.CPU50.97:PCI-MSI.31981630-edge.i40e-eth0-TxRx-61
   1881287 ±  5%     -10.9%    1676765 ± 11%  interrupts.CPU50.CAL:Function_call_interrupts
     13.33 ±  7%     -50.0%       6.67 ±101%  interrupts.CPU50.IWI:IRQ_work_interrupts
   1985701            -5.0%    1887101 ±  3%  interrupts.CPU50.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU50.MCP:Machine_check_polls
      7392 ±  7%     -40.6%       4394 ± 59%  interrupts.CPU50.NMI:Non-maskable_interrupts
      7392 ±  7%     -40.6%       4394 ± 59%  interrupts.CPU50.PMI:Performance_monitoring_interrupts
      1408 ± 14%      -6.2%       1322 ± 21%  interrupts.CPU50.RES:Rescheduling_interrupts
   2418647 ±  5%      -8.2%    2221010 ± 11%  interrupts.CPU50.TLB:TLB_shootdowns
      0.00          -100.0%       0.00        interrupts.CPU51.3:IO-APIC.3-edge
      0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU51.50:PCI-MSI.31981583-edge.i40e-eth0-TxRx-14
      0.67 ± 70%     -50.0%       0.33 ±141%  interrupts.CPU51.87:PCI-MSI.31981620-edge.i40e-eth0-TxRx-51
      0.00       +6.7e+101%       0.67 ± 70%  interrupts.CPU51.98:PCI-MSI.31981631-edge.i40e-eth0-TxRx-62
   1707928 ±  9%     +11.5%    1904613 ±  4%  interrupts.CPU51.CAL:Function_call_interrupts
      8.00 ± 87%     -16.7%       6.67 ±101%  interrupts.CPU51.IWI:IRQ_work_interrupts
   1987380            -6.4%    1859794 ±  4%  interrupts.CPU51.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU51.MCP:Machine_check_polls
      5738 ± 36%     -23.5%       4389 ± 59%  interrupts.CPU51.NMI:Non-maskable_interrupts
      5738 ± 36%     -23.5%       4389 ± 59%  interrupts.CPU51.PMI:Performance_monitoring_interrupts
      1239 ± 15%     +20.7%       1495 ±  4%  interrupts.CPU51.RES:Rescheduling_interrupts
   2197586 ±  9%     +14.6%    2519494 ±  5%  interrupts.CPU51.TLB:TLB_shootdowns
      0.33 ±141%    -100.0%       0.00        interrupts.CPU52.51:PCI-MSI.31981584-edge.i40e-eth0-TxRx-15
      1.33 ± 93%     -25.0%       1.00 ±141%  interrupts.CPU52.88:PCI-MSI.31981621-edge.i40e-eth0-TxRx-52
      0.67 ± 70%     -50.0%       0.33 ±141%  interrupts.CPU52.99:PCI-MSI.31981632-edge.i40e-eth0-TxRx-63
   1951868 ±  9%     -31.6%    1335127 ±  6%  interrupts.CPU52.CAL:Function_call_interrupts
     11.00 ± 37%    -100.0%       0.00        interrupts.CPU52.IWI:IRQ_work_interrupts
   1984053            -3.9%    1905842 ±  3%  interrupts.CPU52.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU52.MCP:Machine_check_polls
      6104 ± 30%     -68.7%       1909 ± 35%  interrupts.CPU52.NMI:Non-maskable_interrupts
      6104 ± 30%     -68.7%       1909 ± 35%  interrupts.CPU52.PMI:Performance_monitoring_interrupts
      1400 ± 16%     -18.6%       1139 ±  4%  interrupts.CPU52.RES:Rescheduling_interrupts
   2510848 ±  9%     -29.8%    1762600 ±  6%  interrupts.CPU52.TLB:TLB_shootdowns
      0.33 ±141%    -100.0%       0.00        interrupts.CPU53.100:PCI-MSI.31981633-edge.i40e-eth0-TxRx-64
      0.67 ± 70%     -50.0%       0.33 ±141%  interrupts.CPU53.52:PCI-MSI.31981585-edge.i40e-eth0-TxRx-16
      0.67 ± 70%    -100.0%       0.00        interrupts.CPU53.89:PCI-MSI.31981622-edge.i40e-eth0-TxRx-53
   1665531 ± 14%     -10.1%    1497069 ±  9%  interrupts.CPU53.CAL:Function_call_interrupts
      5.67 ±129%    +158.8%      14.67 ±  6%  interrupts.CPU53.IWI:IRQ_work_interrupts
   1988491            -4.7%    1895183 ±  3%  interrupts.CPU53.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU53.MCP:Machine_check_polls
      5442 ± 36%     +43.2%       7793        interrupts.CPU53.NMI:Non-maskable_interrupts
      5442 ± 36%     +43.2%       7793        interrupts.CPU53.PMI:Performance_monitoring_interrupts
      1204 ± 21%      +4.8%       1262 ± 15%  interrupts.CPU53.RES:Rescheduling_interrupts
   2142103 ± 14%      -7.6%    1979081 ±  9%  interrupts.CPU53.TLB:TLB_shootdowns
      0.33 ±141%      +0.0%       0.33 ±141%  interrupts.CPU54.101:PCI-MSI.31981634-edge.i40e-eth0-TxRx-65
      0.67 ± 70%      +0.0%       0.67 ± 70%  interrupts.CPU54.53:PCI-MSI.31981586-edge.i40e-eth0-TxRx-17
     49.67 ±137%     -99.3%       0.33 ±141%  interrupts.CPU54.90:PCI-MSI.31981623-edge.i40e-eth0-TxRx-54
   1739173 ± 19%     -12.7%    1517479 ±  9%  interrupts.CPU54.CAL:Function_call_interrupts
      6.33 ± 96%     +84.2%      11.67 ± 47%  interrupts.CPU54.IWI:IRQ_work_interrupts
   1985944            -4.7%    1893171 ±  3%  interrupts.CPU54.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU54.MCP:Machine_check_polls
      4291 ± 58%     +51.8%       6513 ± 27%  interrupts.CPU54.NMI:Non-maskable_interrupts
      4291 ± 58%     +51.8%       6513 ± 27%  interrupts.CPU54.PMI:Performance_monitoring_interrupts
      1286 ± 25%      -0.4%       1281 ± 12%  interrupts.CPU54.RES:Rescheduling_interrupts
   2235542 ± 19%     -10.0%    2011666 ±  9%  interrupts.CPU54.TLB:TLB_shootdowns
      0.67 ± 70%    -100.0%       0.00        interrupts.CPU55.102:PCI-MSI.31981635-edge.i40e-eth0-TxRx-66
      0.00          -100.0%       0.00        interrupts.CPU55.298:PCI-MSI.69632-edge.ioat-msix
      0.33 ±141%    -100.0%       0.00        interrupts.CPU55.54:PCI-MSI.31981587-edge.i40e-eth0-TxRx-18
      1.33 ± 70%     -50.0%       0.67 ±141%  interrupts.CPU55.91:PCI-MSI.31981624-edge.i40e-eth0-TxRx-55
   1697032 ±  4%      -2.8%    1650239 ±  7%  interrupts.CPU55.CAL:Function_call_interrupts
      3.67 ± 89%    +127.3%       8.33 ± 70%  interrupts.CPU55.IWI:IRQ_work_interrupts
   1988525            -5.4%    1881925 ±  4%  interrupts.CPU55.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU55.MCP:Machine_check_polls
      4343 ± 33%     +31.2%       5696 ± 35%  interrupts.CPU55.NMI:Non-maskable_interrupts
      4343 ± 33%     +31.2%       5696 ± 35%  interrupts.CPU55.PMI:Performance_monitoring_interrupts
      1227 ±  5%      +5.1%       1289 ± 12%  interrupts.CPU55.RES:Rescheduling_interrupts
   2182447 ±  4%      -0.1%    2179254 ±  7%  interrupts.CPU55.TLB:TLB_shootdowns
      0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU56.103:PCI-MSI.31981636-edge.i40e-eth0-TxRx-67
      0.33 ±141%      +0.0%       0.33 ±141%  interrupts.CPU56.55:PCI-MSI.31981588-edge.i40e-eth0-TxRx-19
      7.00 ± 30%     -95.2%       0.33 ±141%  interrupts.CPU56.92:PCI-MSI.31981625-edge.i40e-eth0-TxRx-56
   1347182 ±  3%      +5.6%    1422355 ± 21%  interrupts.CPU56.CAL:Function_call_interrupts
      4.33 ±141%     +30.8%       5.67 ± 73%  interrupts.CPU56.IWI:IRQ_work_interrupts
   1992404            -4.3%    1907688 ±  3%  interrupts.CPU56.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU56.MCP:Machine_check_polls
      3955 ± 65%     +18.7%       4694 ± 29%  interrupts.CPU56.NMI:Non-maskable_interrupts
      3955 ± 65%     +18.7%       4694 ± 29%  interrupts.CPU56.PMI:Performance_monitoring_interrupts
      1036 ± 13%      +7.1%       1109 ± 24%  interrupts.CPU56.RES:Rescheduling_interrupts
   1731707 ±  3%      +8.6%    1880374 ± 21%  interrupts.CPU56.TLB:TLB_shootdowns
      0.33 ±141%      +0.0%       0.33 ±141%  interrupts.CPU57.104:PCI-MSI.31981637-edge.i40e-eth0-TxRx-68
      0.33 ±141%    +100.0%       0.67 ± 70%  interrupts.CPU57.56:PCI-MSI.31981589-edge.i40e-eth0-TxRx-20
     99.33 ±138%     -20.5%      79.00 ±129%  interrupts.CPU57.93:PCI-MSI.31981626-edge.i40e-eth0-TxRx-57
   1524315 ± 19%      +7.1%    1632324 ± 11%  interrupts.CPU57.CAL:Function_call_interrupts
      0.33 ±141%   +1400.0%       5.00 ±141%  interrupts.CPU57.IWI:IRQ_work_interrupts
   1986609            -5.6%    1874378 ±  4%  interrupts.CPU57.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU57.MCP:Machine_check_polls
      3863 ± 35%     +16.5%       4501 ± 51%  interrupts.CPU57.NMI:Non-maskable_interrupts
      3863 ± 35%     +16.5%       4501 ± 51%  interrupts.CPU57.PMI:Performance_monitoring_interrupts
      1110 ± 22%     +13.0%       1254 ±  5%  interrupts.CPU57.RES:Rescheduling_interrupts
   1961817 ± 19%     +10.1%    2160652 ± 11%  interrupts.CPU57.TLB:TLB_shootdowns
      0.67 ± 70%    -100.0%       0.00        interrupts.CPU58.105:PCI-MSI.31981638-edge.i40e-eth0-TxRx-69
      0.00          -100.0%       0.00        interrupts.CPU58.57:PCI-MSI.31981590-edge.i40e-eth0-TxRx-21
      3.67 ±102%     -90.9%       0.33 ±141%  interrupts.CPU58.94:PCI-MSI.31981627-edge.i40e-eth0-TxRx-58
   1420152 ±  6%      -7.5%    1313862 ± 26%  interrupts.CPU58.CAL:Function_call_interrupts
      9.67 ± 70%     -24.1%       7.33 ± 83%  interrupts.CPU58.IWI:IRQ_work_interrupts
   1993604            -4.4%    1904903 ±  3%  interrupts.CPU58.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU58.MCP:Machine_check_polls
      6106 ± 37%     -13.8%       5264 ± 37%  interrupts.CPU58.NMI:Non-maskable_interrupts
      6106 ± 37%     -13.8%       5264 ± 37%  interrupts.CPU58.PMI:Performance_monitoring_interrupts
      1093 ±  6%      -5.4%       1034 ± 18%  interrupts.CPU58.RES:Rescheduling_interrupts
   1827186 ±  6%      -4.9%    1737722 ± 27%  interrupts.CPU58.TLB:TLB_shootdowns
      1.00           -33.3%       0.67 ± 70%  interrupts.CPU59.106:PCI-MSI.31981639-edge.i40e-eth0-TxRx-70
      0.67 ± 70%      +0.0%       0.67 ± 70%  interrupts.CPU59.58:PCI-MSI.31981591-edge.i40e-eth0-TxRx-22
      2.33 ±112%   +2814.3%      68.00 ±141%  interrupts.CPU59.95:PCI-MSI.31981628-edge.i40e-eth0-TxRx-59
   1626244 ± 14%     -10.5%    1455439 ±  7%  interrupts.CPU59.CAL:Function_call_interrupts
      3.33 ± 61%    +120.0%       7.33 ± 65%  interrupts.CPU59.IWI:IRQ_work_interrupts
   1990254            -5.0%    1890811 ±  3%  interrupts.CPU59.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU59.MCP:Machine_check_polls
      4361 ± 30%     +21.8%       5309 ± 33%  interrupts.CPU59.NMI:Non-maskable_interrupts
      4361 ± 30%     +21.8%       5309 ± 33%  interrupts.CPU59.PMI:Performance_monitoring_interrupts
      1214 ±  9%      +0.7%       1223 ±  6%  interrupts.CPU59.RES:Rescheduling_interrupts
   2092260 ± 14%      -8.1%    1923117 ±  7%  interrupts.CPU59.TLB:TLB_shootdowns
      0.33 ±141%    +100.0%       0.67 ± 70%  interrupts.CPU6.125:PCI-MSI.31981658-edge.i40e-eth0-TxRx-89
      6.00 ± 72%     -66.7%       2.00 ±108%  interrupts.CPU6.42:PCI-MSI.31981575-edge.i40e-eth0-TxRx-6
      0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU6.77:PCI-MSI.31981610-edge.i40e-eth0-TxRx-41
   1304275 ± 17%      +8.4%    1413391 ± 14%  interrupts.CPU6.CAL:Function_call_interrupts
      7.00 ± 72%     +19.0%       8.33 ± 70%  interrupts.CPU6.IWI:IRQ_work_interrupts
   1996479            -5.1%    1894730 ±  3%  interrupts.CPU6.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU6.MCP:Machine_check_polls
      5417 ± 33%      -8.0%       4986 ± 31%  interrupts.CPU6.NMI:Non-maskable_interrupts
      5417 ± 33%      -8.0%       4986 ± 31%  interrupts.CPU6.PMI:Performance_monitoring_interrupts
    989.33 ± 16%     +29.8%       1283 ± 20%  interrupts.CPU6.RES:Rescheduling_interrupts
   1674991 ± 17%     +11.1%    1860964 ± 14%  interrupts.CPU6.TLB:TLB_shootdowns
      0.67 ± 70%     -50.0%       0.33 ±141%  interrupts.CPU60.107:PCI-MSI.31981640-edge.i40e-eth0-TxRx-71
      0.33 ±141%    -100.0%       0.00        interrupts.CPU60.59:PCI-MSI.31981592-edge.i40e-eth0-TxRx-23
     19.33 ±127%     -77.6%       4.33 ± 76%  interrupts.CPU60.96:PCI-MSI.31981629-edge.i40e-eth0-TxRx-60
   1448317 ± 14%      +5.1%    1522493 ±  7%  interrupts.CPU60.CAL:Function_call_interrupts
      6.00 ± 94%     +55.6%       9.33 ± 72%  interrupts.CPU60.IWI:IRQ_work_interrupts
   1989734            -5.3%    1884400 ±  4%  interrupts.CPU60.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU60.MCP:Machine_check_polls
      5660 ± 32%      +2.1%       5777 ± 36%  interrupts.CPU60.NMI:Non-maskable_interrupts
      5660 ± 32%      +2.1%       5777 ± 36%  interrupts.CPU60.PMI:Performance_monitoring_interrupts
      1139 ± 18%     +13.0%       1288 ±  8%  interrupts.CPU60.RES:Rescheduling_interrupts
   1861801 ± 14%      +7.9%    2008779 ±  8%  interrupts.CPU60.TLB:TLB_shootdowns
      0.00       +6.7e+101%       0.67 ± 70%  interrupts.CPU61.108:PCI-MSI.31981641-edge.i40e-eth0-TxRx-72
      0.33 ±141%    -100.0%       0.00        interrupts.CPU61.60:PCI-MSI.31981593-edge.i40e-eth0-TxRx-24
     19.33 ±130%     -79.3%       4.00 ±141%  interrupts.CPU61.97:PCI-MSI.31981630-edge.i40e-eth0-TxRx-61
   1506234 ±  4%      +7.4%    1618239 ± 10%  interrupts.CPU61.CAL:Function_call_interrupts
      4.67 ±111%     +35.7%       6.33 ± 73%  interrupts.CPU61.IWI:IRQ_work_interrupts
   1993170            -5.8%    1877071 ±  4%  interrupts.CPU61.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU61.MCP:Machine_check_polls
      5799 ± 17%     -24.5%       4376 ± 33%  interrupts.CPU61.NMI:Non-maskable_interrupts
      5799 ± 17%     -24.5%       4376 ± 33%  interrupts.CPU61.PMI:Performance_monitoring_interrupts
      1154 ±  4%     +11.8%       1291 ±  6%  interrupts.CPU61.RES:Rescheduling_interrupts
   1937605 ±  5%     +10.2%    2135377 ± 10%  interrupts.CPU61.TLB:TLB_shootdowns
      0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU62.109:PCI-MSI.31981642-edge.i40e-eth0-TxRx-73
      0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU62.61:PCI-MSI.31981594-edge.i40e-eth0-TxRx-25
      0.00       +4.3e+102%       4.33 ± 71%  interrupts.CPU62.98:PCI-MSI.31981631-edge.i40e-eth0-TxRx-62
   1718088 ±  7%     -17.8%    1411772 ± 26%  interrupts.CPU62.CAL:Function_call_interrupts
     11.00 ± 64%     -75.8%       2.67 ± 93%  interrupts.CPU62.IWI:IRQ_work_interrupts
   1990645            -4.7%    1897068 ±  3%  interrupts.CPU62.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU62.MCP:Machine_check_polls
      7119 ± 13%     -54.5%       3242 ±  9%  interrupts.CPU62.NMI:Non-maskable_interrupts
      7119 ± 13%     -54.5%       3242 ±  9%  interrupts.CPU62.PMI:Performance_monitoring_interrupts
      1287 ±  3%      -2.7%       1252 ± 16%  interrupts.CPU62.RES:Rescheduling_interrupts
   2210870 ±  7%     -15.8%    1862361 ± 26%  interrupts.CPU62.TLB:TLB_shootdowns
      0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU63.110:PCI-MSI.31981643-edge.i40e-eth0-TxRx-74
      0.67 ± 70%     -50.0%       0.33 ±141%  interrupts.CPU63.62:PCI-MSI.31981595-edge.i40e-eth0-TxRx-26
      3.00 ±118%   +3888.9%     119.67 ±137%  interrupts.CPU63.99:PCI-MSI.31981632-edge.i40e-eth0-TxRx-63
   1444706 ±  6%     +26.2%    1823494 ±  8%  interrupts.CPU63.CAL:Function_call_interrupts
      5.67 ±129%    +100.0%      11.33 ± 27%  interrupts.CPU63.IWI:IRQ_work_interrupts
   1992010            -6.2%    1869127 ±  4%  interrupts.CPU63.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU63.MCP:Machine_check_polls
      5440 ± 37%     +11.2%       6052 ± 26%  interrupts.CPU63.NMI:Non-maskable_interrupts
      5440 ± 37%     +11.2%       6052 ± 26%  interrupts.CPU63.PMI:Performance_monitoring_interrupts
      1140 ±  5%     +21.7%       1387 ± 14%  interrupts.CPU63.RES:Rescheduling_interrupts
   1861023 ±  6%     +29.6%    2411566 ±  8%  interrupts.CPU63.TLB:TLB_shootdowns
      5.00 ± 74%    +253.3%      17.67 ±141%  interrupts.CPU64.100:PCI-MSI.31981633-edge.i40e-eth0-TxRx-64
      0.00          -100.0%       0.00        interrupts.CPU64.111:PCI-MSI.31981644-edge.i40e-eth0-TxRx-75
      0.00       +2.2e+103%      21.67 ±141%  interrupts.CPU64.4:IO-APIC.4-edge.ttyS0
      0.33 ±141%    +200.0%       1.00        interrupts.CPU64.63:PCI-MSI.31981596-edge.i40e-eth0-TxRx-27
   1656048 ± 15%      +2.1%    1690357 ± 17%  interrupts.CPU64.CAL:Function_call_interrupts
      8.33 ± 72%     +20.0%      10.00 ± 42%  interrupts.CPU64.IWI:IRQ_work_interrupts
   1985853            -6.1%    1865618 ±  4%  interrupts.CPU64.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU64.MCP:Machine_check_polls
      5301 ± 49%      +5.9%       5612 ± 30%  interrupts.CPU64.NMI:Non-maskable_interrupts
      5301 ± 49%      +5.9%       5612 ± 30%  interrupts.CPU64.PMI:Performance_monitoring_interrupts
      1262 ± 21%      +2.6%       1294 ±  9%  interrupts.CPU64.RES:Rescheduling_interrupts
   2131295 ± 15%      +5.0%    2238706 ± 18%  interrupts.CPU64.TLB:TLB_shootdowns
      0.33 ±141%  +15600.0%      52.33 ±138%  interrupts.CPU65.101:PCI-MSI.31981634-edge.i40e-eth0-TxRx-65
      0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU65.112:PCI-MSI.31981645-edge.i40e-eth0-TxRx-76
      0.00       +1.7e+103%      17.33 ±141%  interrupts.CPU65.4:IO-APIC.4-edge.ttyS0
      0.33 ±141%    +100.0%       0.67 ± 70%  interrupts.CPU65.64:PCI-MSI.31981597-edge.i40e-eth0-TxRx-28
   1609735 ±  5%      -2.1%    1575604 ±  5%  interrupts.CPU65.CAL:Function_call_interrupts
      5.67 ± 44%     +41.2%       8.00 ± 81%  interrupts.CPU65.IWI:IRQ_work_interrupts
   1988636            -5.1%    1886938 ±  3%  interrupts.CPU65.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU65.MCP:Machine_check_polls
      5467 ±  9%     -11.3%       4851 ± 43%  interrupts.CPU65.NMI:Non-maskable_interrupts
      5467 ±  9%     -11.3%       4851 ± 43%  interrupts.CPU65.PMI:Performance_monitoring_interrupts
      1218 ± 16%      +9.9%       1339 ± 18%  interrupts.CPU65.RES:Rescheduling_interrupts
   2072400 ±  5%      +0.5%    2083033 ±  5%  interrupts.CPU65.TLB:TLB_shootdowns
      2.33 ± 80%    -100.0%       0.00        interrupts.CPU66.102:PCI-MSI.31981635-edge.i40e-eth0-TxRx-66
      0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU66.113:PCI-MSI.31981646-edge.i40e-eth0-TxRx-77
      0.00          -100.0%       0.00        interrupts.CPU66.295:PCI-MSI.65536-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU66.3:IO-APIC.3-edge
      0.00          -100.0%       0.00        interrupts.CPU66.65:PCI-MSI.31981598-edge.i40e-eth0-TxRx-29
   1850434 ±  2%     -24.5%    1396653 ±  9%  interrupts.CPU66.CAL:Function_call_interrupts
     12.67 ±  9%     -57.9%       5.33 ±128%  interrupts.CPU66.IWI:IRQ_work_interrupts
   1989034            -4.3%    1903537 ±  2%  interrupts.CPU66.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU66.MCP:Machine_check_polls
      7494 ±  2%     -52.2%       3583 ± 78%  interrupts.CPU66.NMI:Non-maskable_interrupts
      7494 ±  2%     -52.2%       3583 ± 78%  interrupts.CPU66.PMI:Performance_monitoring_interrupts
      1372 ±  7%     -13.1%       1192 ± 13%  interrupts.CPU66.RES:Rescheduling_interrupts
   2377993 ±  3%     -22.3%    1847264 ±  9%  interrupts.CPU66.TLB:TLB_shootdowns
     69.33 ±141%     -99.5%       0.33 ±141%  interrupts.CPU67.103:PCI-MSI.31981636-edge.i40e-eth0-TxRx-67
      0.00          -100.0%       0.00        interrupts.CPU67.114:PCI-MSI.31981647-edge.i40e-eth0-TxRx-78
      0.00          -100.0%       0.00        interrupts.CPU67.295:PCI-MSI.65536-edge.ioat-msix
      0.00          -100.0%       0.00        interrupts.CPU67.298:PCI-MSI.67584-edge.ioat-msix
      0.33 ±141%    -100.0%       0.00        interrupts.CPU67.66:PCI-MSI.31981599-edge.i40e-eth0-TxRx-30
   1435568 ± 21%      +5.4%    1512991 ± 11%  interrupts.CPU67.CAL:Function_call_interrupts
      0.67 ± 70%   +1100.0%       8.00 ± 77%  interrupts.CPU67.IWI:IRQ_work_interrupts
   1987002            -4.9%    1888746 ±  3%  interrupts.CPU67.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU67.MCP:Machine_check_polls
      4477 ± 26%      +9.6%       4909 ± 41%  interrupts.CPU67.NMI:Non-maskable_interrupts
      4477 ± 26%      +9.6%       4909 ± 41%  interrupts.CPU67.PMI:Performance_monitoring_interrupts
      1081 ± 26%     +10.6%       1195 ± 14%  interrupts.CPU67.RES:Rescheduling_interrupts
   1842392 ± 21%      +8.4%    1997208 ± 10%  interrupts.CPU67.TLB:TLB_shootdowns
      0.67 ±141%    +100.0%       1.33 ±141%  interrupts.CPU68.104:PCI-MSI.31981637-edge.i40e-eth0-TxRx-68
      0.00         +1e+102%       1.00        interrupts.CPU68.115:PCI-MSI.31981648-edge.i40e-eth0-TxRx-79
      0.00          -100.0%       0.00        interrupts.CPU68.295:PCI-MSI.65536-edge.ioat-msix
      0.33 ±141%    +100.0%       0.67 ± 70%  interrupts.CPU68.67:PCI-MSI.31981600-edge.i40e-eth0-TxRx-31
   1340238 ± 13%     +10.5%    1480768 ± 11%  interrupts.CPU68.CAL:Function_call_interrupts
      5.33 ±141%     -56.2%       2.33 ± 72%  interrupts.CPU68.IWI:IRQ_work_interrupts
   1989988            -4.4%    1902719 ±  2%  interrupts.CPU68.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU68.MCP:Machine_check_polls
      4045 ± 67%      -8.5%       3701 ± 16%  interrupts.CPU68.NMI:Non-maskable_interrupts
      4045 ± 67%      -8.5%       3701 ± 16%  interrupts.CPU68.PMI:Performance_monitoring_interrupts
    984.67 ± 22%     +14.8%       1130 ± 12%  interrupts.CPU68.RES:Rescheduling_interrupts
   1725006 ± 13%     +13.5%    1957457 ± 11%  interrupts.CPU68.TLB:TLB_shootdowns
      1697 ±140%    +112.0%       3597 ±141%  interrupts.CPU69.105:PCI-MSI.31981638-edge.i40e-eth0-TxRx-69
      0.67 ± 70%     -50.0%       0.33 ±141%  interrupts.CPU69.116:PCI-MSI.31981649-edge.i40e-eth0-TxRx-80
      0.33 ±141%      +0.0%       0.33 ±141%  interrupts.CPU69.68:PCI-MSI.31981601-edge.i40e-eth0-TxRx-32
   1233321 ± 10%     +22.0%    1505117 ±  6%  interrupts.CPU69.CAL:Function_call_interrupts
     11.67 ± 26%      -5.7%      11.00 ± 51%  interrupts.CPU69.IWI:IRQ_work_interrupts
   1993381            -5.4%    1885918 ±  3%  interrupts.CPU69.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU69.MCP:Machine_check_polls
      6971 ±  9%     -16.8%       5797 ± 41%  interrupts.CPU69.NMI:Non-maskable_interrupts
      6971 ±  9%     -16.8%       5797 ± 41%  interrupts.CPU69.PMI:Performance_monitoring_interrupts
    934.00 ± 19%     +24.0%       1158 ±  2%  interrupts.CPU69.RES:Rescheduling_interrupts
   1589896 ± 10%     +25.0%    1987282 ±  6%  interrupts.CPU69.TLB:TLB_shootdowns
      0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU7.126:PCI-MSI.31981659-edge.i40e-eth0-TxRx-90
      1332            +2.1%       1360 ±  3%  interrupts.CPU7.35:PCI-MSI.31981568-edge.i40e-0000:3d:00.0:misc
      3.00 ±141%     +22.2%       3.67 ± 89%  interrupts.CPU7.43:PCI-MSI.31981576-edge.i40e-eth0-TxRx-7
      0.33 ±141%    +100.0%       0.67 ± 70%  interrupts.CPU7.78:PCI-MSI.31981611-edge.i40e-eth0-TxRx-42
   1352572 ±  5%      -3.4%    1306327 ±  4%  interrupts.CPU7.CAL:Function_call_interrupts
      7.33 ± 89%     +22.7%       9.00 ± 63%  interrupts.CPU7.IWI:IRQ_work_interrupts
   1994785            -4.3%    1908020 ±  2%  interrupts.CPU7.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU7.MCP:Machine_check_polls
      4718 ± 46%     +20.8%       5701 ± 29%  interrupts.CPU7.NMI:Non-maskable_interrupts
      4718 ± 46%     +20.8%       5701 ± 29%  interrupts.CPU7.PMI:Performance_monitoring_interrupts
      1043 ±  7%     +13.5%       1184 ± 18%  interrupts.CPU7.RES:Rescheduling_interrupts
   1740346 ±  5%      -0.9%    1725223 ±  3%  interrupts.CPU7.TLB:TLB_shootdowns
      3.00 ± 27%     +55.6%       4.67 ±141%  interrupts.CPU70.106:PCI-MSI.31981639-edge.i40e-eth0-TxRx-70
      0.33 ±141%      +0.0%       0.33 ±141%  interrupts.CPU70.117:PCI-MSI.31981650-edge.i40e-eth0-TxRx-81
      0.00          -100.0%       0.00        interrupts.CPU70.299:PCI-MSI.71680-edge.ioat-msix
      0.33 ±141%    +100.0%       0.67 ± 70%  interrupts.CPU70.69:PCI-MSI.31981602-edge.i40e-eth0-TxRx-33
   1342525 ± 10%      +9.7%    1472356 ± 13%  interrupts.CPU70.CAL:Function_call_interrupts
      8.33 ± 78%      -8.0%       7.67 ± 85%  interrupts.CPU70.IWI:IRQ_work_interrupts
   1994078            -4.8%    1897450 ±  3%  interrupts.CPU70.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU70.MCP:Machine_check_polls
      5411 ± 36%     -12.1%       4756 ± 45%  interrupts.CPU70.NMI:Non-maskable_interrupts
      5411 ± 36%     -12.1%       4756 ± 45%  interrupts.CPU70.PMI:Performance_monitoring_interrupts
      1019 ±  7%     +24.7%       1270 ± 15%  interrupts.CPU70.RES:Rescheduling_interrupts
   1728567 ± 10%     +12.4%    1942269 ± 13%  interrupts.CPU70.TLB:TLB_shootdowns
      0.67 ± 70%  +2.8e+05%       1852 ±141%  interrupts.CPU71.107:PCI-MSI.31981640-edge.i40e-eth0-TxRx-71
      0.00       +3.3e+101%       0.33 ±141%  interrupts.CPU71.118:PCI-MSI.31981651-edge.i40e-eth0-TxRx-82
      0.00          -100.0%       0.00        interrupts.CPU71.297:PCI-MSI.67584-edge.ioat-msix
      0.33 ±141%    +100.0%       0.67 ± 70%  interrupts.CPU71.70:PCI-MSI.31981603-edge.i40e-eth0-TxRx-34
   1316357 ±  9%      -1.8%    1292152 ± 15%  interrupts.CPU71.CAL:Function_call_interrupts
     10.67 ± 70%    -100.0%       0.00        interrupts.CPU71.IWI:IRQ_work_interrupts
   1992286            -4.6%    1899979 ±  3%  interrupts.CPU71.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU71.MCP:Machine_check_polls
      6145 ± 37%     -53.1%       2882        interrupts.CPU71.NMI:Non-maskable_interrupts
      6145 ± 37%     -53.1%       2882        interrupts.CPU71.PMI:Performance_monitoring_interrupts
      1028 ± 13%     +11.3%       1144 ± 17%  interrupts.CPU71.RES:Rescheduling_interrupts
   1690792 ±  9%      +0.7%    1702712 ± 14%  interrupts.CPU71.TLB:TLB_shootdowns
      0.00         +3e+102%       3.00 ±118%  interrupts.CPU72.108:PCI-MSI.31981641-edge.i40e-eth0-TxRx-72
   1626843 ± 11%      +4.8%    1704121 ± 12%  interrupts.CPU72.CAL:Function_call_interrupts
      7.33 ± 78%     +68.2%      12.33 ± 25%  interrupts.CPU72.IWI:IRQ_work_interrupts
   1993580            -5.2%    1890802 ±  3%  interrupts.CPU72.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU72.MCP:Machine_check_polls
      4847 ± 43%     +33.7%       6482 ± 28%  interrupts.CPU72.NMI:Non-maskable_interrupts
      4847 ± 43%     +33.7%       6482 ± 28%  interrupts.CPU72.PMI:Performance_monitoring_interrupts
      1182 ±  4%      +7.2%       1267 ± 20%  interrupts.CPU72.RES:Rescheduling_interrupts
   2083105 ± 11%      +7.4%    2237698 ± 12%  interrupts.CPU72.TLB:TLB_shootdowns
      2.00 ±141%     -50.0%       1.00 ±141%  interrupts.CPU73.109:PCI-MSI.31981642-edge.i40e-eth0-TxRx-73
   1768492 ± 16%      -9.3%    1603296 ± 12%  interrupts.CPU73.CAL:Function_call_interrupts
      4.33 ± 78%     -61.5%       1.67 ±141%  interrupts.CPU73.IWI:IRQ_work_interrupts
   1994198            -4.8%    1899180 ±  3%  interrupts.CPU73.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU73.MCP:Machine_check_polls
      5564 ±  2%     -45.2%       3052 ±  8%  interrupts.CPU73.NMI:Non-maskable_interrupts
      5564 ±  2%     -45.2%       3052 ±  8%  interrupts.CPU73.PMI:Performance_monitoring_interrupts
      1189 ± 16%      +5.0%       1248 ± 16%  interrupts.CPU73.RES:Rescheduling_interrupts
   2269340 ± 16%      -7.2%    2105564 ± 13%  interrupts.CPU73.TLB:TLB_shootdowns
      0.33 ±141%    +300.0%       1.33 ± 93%  interrupts.CPU74.110:PCI-MSI.31981643-edge.i40e-eth0-TxRx-74
   1662997 ± 26%      +5.5%    1754378 ±  8%  interrupts.CPU74.CAL:Function_call_interrupts
      8.33 ± 73%     -68.0%       2.67 ±141%  interrupts.CPU74.IWI:IRQ_work_interrupts
   1996584            -5.5%    1885933 ±  3%  interrupts.CPU74.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU74.MCP:Machine_check_polls
      6882 ±  9%     -60.5%       2721 ± 36%  interrupts.CPU74.NMI:Non-maskable_interrupts
      6882 ±  9%     -60.5%       2721 ± 36%  interrupts.CPU74.PMI:Performance_monitoring_interrupts
      1209 ± 12%      +7.6%       1301 ± 12%  interrupts.CPU74.RES:Rescheduling_interrupts
   2133946 ± 27%      +8.1%    2307065 ±  8%  interrupts.CPU74.TLB:TLB_shootdowns
     62.67 ±141%     -96.8%       2.00 ± 81%  interrupts.CPU75.111:PCI-MSI.31981644-edge.i40e-eth0-TxRx-75
   1938717 ± 13%     -18.6%    1579075 ± 14%  interrupts.CPU75.CAL:Function_call_interrupts
      4.33 ± 78%     +38.5%       6.00 ±118%  interrupts.CPU75.IWI:IRQ_work_interrupts
   1991512            -4.6%    1900583 ±  3%  interrupts.CPU75.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU75.MCP:Machine_check_polls
      4630 ± 31%      +1.0%       4677 ± 47%  interrupts.CPU75.NMI:Non-maskable_interrupts
      4630 ± 31%      +1.0%       4677 ± 47%  interrupts.CPU75.PMI:Performance_monitoring_interrupts
      1307 ±  7%      -4.9%       1243 ± 30%  interrupts.CPU75.RES:Rescheduling_interrupts
   2488418 ± 13%     -16.7%    2073013 ± 14%  interrupts.CPU75.TLB:TLB_shootdowns
     66.67 ±141%     -99.0%       0.67 ±141%  interrupts.CPU76.112:PCI-MSI.31981645-edge.i40e-eth0-TxRx-76
   1964044 ±  9%     -16.5%    1640313 ±  4%  interrupts.CPU76.CAL:Function_call_interrupts
      9.33 ± 66%     -28.6%       6.67 ± 79%  interrupts.CPU76.IWI:IRQ_work_interrupts
   1990673            -5.0%    1891339 ±  3%  interrupts.CPU76.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU76.MCP:Machine_check_polls
      6392 ± 15%     -25.9%       4739 ± 41%  interrupts.CPU76.NMI:Non-maskable_interrupts
      6392 ± 15%     -25.9%       4739 ± 41%  interrupts.CPU76.PMI:Performance_monitoring_interrupts
      1326 ±  2%      -4.7%       1263 ± 18%  interrupts.CPU76.RES:Rescheduling_interrupts
   2519550 ±  9%     -14.3%    2159066 ±  4%  interrupts.CPU76.TLB:TLB_shootdowns
     15573 ±141%    -100.0%       2.00 ± 81%  interrupts.CPU77.113:PCI-MSI.31981646-edge.i40e-eth0-TxRx-77
   1822826 ± 12%     -23.2%    1399502 ± 17%  interrupts.CPU77.CAL:Function_call_interrupts
      5.67 ±106%      -5.9%       5.33 ±141%  interrupts.CPU77.IWI:IRQ_work_interrupts
   1992466            -4.2%    1908509 ±  2%  interrupts.CPU77.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU77.MCP:Machine_check_polls
      4889 ± 43%      -8.5%       4475 ± 52%  interrupts.CPU77.NMI:Non-maskable_interrupts
      4889 ± 43%      -8.5%       4475 ± 52%  interrupts.CPU77.PMI:Performance_monitoring_interrupts
      1212 ±  6%      -9.6%       1096 ± 16%  interrupts.CPU77.RES:Rescheduling_interrupts
   2337249 ± 12%     -21.3%    1839786 ± 17%  interrupts.CPU77.TLB:TLB_shootdowns
      3.67 ±105%     +36.4%       5.00 ± 90%  interrupts.CPU78.114:PCI-MSI.31981647-edge.i40e-eth0-TxRx-78
   1845588 ± 15%      -8.1%    1696223 ± 14%  interrupts.CPU78.CAL:Function_call_interrupts
      3.00 ±118%    +322.2%      12.67 ± 37%  interrupts.CPU78.IWI:IRQ_work_interrupts
   1993324            -5.7%    1879316 ±  4%  interrupts.CPU78.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU78.MCP:Machine_check_polls
      4615 ± 26%     +40.1%       6468 ± 29%  interrupts.CPU78.NMI:Non-maskable_interrupts
      4615 ± 26%     +40.1%       6468 ± 29%  interrupts.CPU78.PMI:Performance_monitoring_interrupts
      1230 ±  5%      -0.0%       1230 ±  6%  interrupts.CPU78.RES:Rescheduling_interrupts
   2367244 ± 15%      -5.9%    2228282 ± 14%  interrupts.CPU78.TLB:TLB_shootdowns
      0.00         +6e+102%       6.00 ± 49%  interrupts.CPU79.115:PCI-MSI.31981648-edge.i40e-eth0-TxRx-79
   1115671 ±  9%     +22.0%    1361253 ± 12%  interrupts.CPU79.CAL:Function_call_interrupts
      0.33 ±141%   +2600.0%       9.00 ± 74%  interrupts.CPU79.IWI:IRQ_work_interrupts
   1998129            -4.2%    1913218 ±  2%  interrupts.CPU79.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU79.MCP:Machine_check_polls
      3823 ± 34%     +52.0%       5811 ± 36%  interrupts.CPU79.NMI:Non-maskable_interrupts
      3823 ± 34%     +52.0%       5811 ± 36%  interrupts.CPU79.PMI:Performance_monitoring_interrupts
    838.33 ±  5%     +36.8%       1146 ± 18%  interrupts.CPU79.RES:Rescheduling_interrupts
   1432491 ±  9%     +24.9%    1788814 ± 12%  interrupts.CPU79.TLB:TLB_shootdowns
      0.67 ± 70%     -50.0%       0.33 ±141%  interrupts.CPU8.127:PCI-MSI.31981660-edge.i40e-eth0-TxRx-91
      4.67 ± 40%     -64.3%       1.67 ±101%  interrupts.CPU8.44:PCI-MSI.31981577-edge.i40e-eth0-TxRx-8
      0.00       +6.7e+101%       0.67 ± 70%  interrupts.CPU8.79:PCI-MSI.31981612-edge.i40e-eth0-TxRx-43
   1692194 ±  4%      -7.5%    1564685 ± 16%  interrupts.CPU8.CAL:Function_call_interrupts
     10.67 ± 50%      -9.4%       9.67 ± 50%  interrupts.CPU8.IWI:IRQ_work_interrupts
   1990830            -5.6%    1880106 ±  3%  interrupts.CPU8.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU8.MCP:Machine_check_polls
      7184 ± 11%     -16.9%       5967 ± 22%  interrupts.CPU8.NMI:Non-maskable_interrupts
      7184 ± 11%     -16.9%       5967 ± 22%  interrupts.CPU8.PMI:Performance_monitoring_interrupts
      1191 ±  3%     +14.2%       1361 ±  8%  interrupts.CPU8.RES:Rescheduling_interrupts
   2178171 ±  4%      -5.2%    2064613 ± 16%  interrupts.CPU8.TLB:TLB_shootdowns
      0.67 ± 70%   +5800.0%      39.33 ±136%  interrupts.CPU80.116:PCI-MSI.31981649-edge.i40e-eth0-TxRx-80
   1466419 ±  9%     -12.9%    1277068 ±  6%  interrupts.CPU80.CAL:Function_call_interrupts
      0.33 ±141%   +1900.0%       6.67 ± 99%  interrupts.CPU80.IWI:IRQ_work_interrupts
   1995234            -3.8%    1919686 ±  2%  interrupts.CPU80.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU80.MCP:Machine_check_polls
      3819 ± 35%     +32.4%       5054 ± 43%  interrupts.CPU80.NMI:Non-maskable_interrupts
      3819 ± 35%     +32.4%       5054 ± 43%  interrupts.CPU80.PMI:Performance_monitoring_interrupts
    963.33 ±  7%      +6.9%       1030 ± 25%  interrupts.CPU80.RES:Rescheduling_interrupts
   1884158 ±  9%     -10.7%    1682683 ±  6%  interrupts.CPU80.TLB:TLB_shootdowns
     48.00 ±139%    -100.0%       0.00        interrupts.CPU81.117:PCI-MSI.31981650-edge.i40e-eth0-TxRx-81
   1522480 ±  5%      -6.1%    1429709 ± 11%  interrupts.CPU81.CAL:Function_call_interrupts
      9.00 ± 72%     -33.3%       6.00 ± 98%  interrupts.CPU81.IWI:IRQ_work_interrupts
   1990965            -4.6%    1898917 ±  3%  interrupts.CPU81.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU81.MCP:Machine_check_polls
      5734 ± 35%      -1.7%       5634 ± 36%  interrupts.CPU81.NMI:Non-maskable_interrupts
      5734 ± 35%      -1.7%       5634 ± 36%  interrupts.CPU81.PMI:Performance_monitoring_interrupts
      1125 ±  7%      -8.9%       1025 ±  6%  interrupts.CPU81.RES:Rescheduling_interrupts
   1951989 ±  5%      -3.6%    1881563 ± 11%  interrupts.CPU81.TLB:TLB_shootdowns
      6.33 ±119%    +210.5%      19.67 ±141%  interrupts.CPU82.118:PCI-MSI.31981651-edge.i40e-eth0-TxRx-82
   1583902 ± 12%     -17.0%    1314628 ± 11%  interrupts.CPU82.CAL:Function_call_interrupts
     11.67 ± 46%     -14.3%      10.00 ± 71%  interrupts.CPU82.IWI:IRQ_work_interrupts
   1995233            -4.1%    1913521 ±  2%  interrupts.CPU82.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU82.MCP:Machine_check_polls
      6003 ± 40%      +2.4%       6147 ± 37%  interrupts.CPU82.NMI:Non-maskable_interrupts
      6003 ± 40%      +2.4%       6147 ± 37%  interrupts.CPU82.PMI:Performance_monitoring_interrupts
      1139 ± 10%     -17.9%     935.00 ± 12%  interrupts.CPU82.RES:Rescheduling_interrupts
   2032459 ± 12%     -15.0%    1727431 ± 11%  interrupts.CPU82.TLB:TLB_shootdowns
      1.00 ±141%    +300.0%       4.00 ± 93%  interrupts.CPU83.119:PCI-MSI.31981652-edge.i40e-eth0-TxRx-83
   1470273 ±  3%     -25.5%    1095804 ± 13%  interrupts.CPU83.CAL:Function_call_interrupts
      4.33 ±141%      +0.0%       4.33 ±125%  interrupts.CPU83.IWI:IRQ_work_interrupts
   1993907            -3.1%    1932309 ±  2%  interrupts.CPU83.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU83.MCP:Machine_check_polls
      4452 ± 45%      +1.1%       4500 ± 34%  interrupts.CPU83.NMI:Non-maskable_interrupts
      4452 ± 45%      +1.1%       4500 ± 34%  interrupts.CPU83.PMI:Performance_monitoring_interrupts
      1081 ± 11%     -15.4%     915.33 ± 22%  interrupts.CPU83.RES:Rescheduling_interrupts
   1882092 ±  4%     -23.6%    1437424 ± 13%  interrupts.CPU83.TLB:TLB_shootdowns
      2655 ±141%     -99.9%       2.67 ±115%  interrupts.CPU84.120:PCI-MSI.31981653-edge.i40e-eth0-TxRx-84
   1366827 ± 23%     +23.1%    1682339 ±  4%  interrupts.CPU84.CAL:Function_call_interrupts
      6.00 ±108%     -61.1%       2.33 ±112%  interrupts.CPU84.IWI:IRQ_work_interrupts
   1995590            -5.1%    1893737 ±  3%  interrupts.CPU84.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU84.MCP:Machine_check_polls
      3874 ± 70%      +5.7%       4095 ± 36%  interrupts.CPU84.NMI:Non-maskable_interrupts
      3874 ± 70%      +5.7%       4095 ± 36%  interrupts.CPU84.PMI:Performance_monitoring_interrupts
    991.33 ± 15%     +21.4%       1203 ± 13%  interrupts.CPU84.RES:Rescheduling_interrupts
   1753368 ± 23%     +26.2%    2212594 ±  4%  interrupts.CPU84.TLB:TLB_shootdowns
      3.67 ±122%   +2618.2%      99.67 ±133%  interrupts.CPU85.121:PCI-MSI.31981654-edge.i40e-eth0-TxRx-85
   1421551 ± 27%      +4.8%    1489842 ± 11%  interrupts.CPU85.CAL:Function_call_interrupts
      7.00 ± 92%    +109.5%      14.67 ± 12%  interrupts.CPU85.IWI:IRQ_work_interrupts
   1997326            -4.3%    1911432 ±  3%  interrupts.CPU85.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU85.MCP:Machine_check_polls
      5916 ± 24%     +24.8%       7385 ±  7%  interrupts.CPU85.NMI:Non-maskable_interrupts
      5916 ± 24%     +24.8%       7385 ±  7%  interrupts.CPU85.PMI:Performance_monitoring_interrupts
      1042 ± 19%      -0.9%       1032 ± 16%  interrupts.CPU85.RES:Rescheduling_interrupts
   1823928 ± 27%      +7.6%    1961658 ± 11%  interrupts.CPU85.TLB:TLB_shootdowns
      0.67 ±141%   +7150.0%      48.33 ±128%  interrupts.CPU86.122:PCI-MSI.31981655-edge.i40e-eth0-TxRx-86
   1649788 ± 22%     -14.1%    1416926 ±  7%  interrupts.CPU86.CAL:Function_call_interrupts
      7.67 ± 79%      -4.3%       7.33 ± 89%  interrupts.CPU86.IWI:IRQ_work_interrupts
   1993103            -4.2%    1908908 ±  3%  interrupts.CPU86.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU86.MCP:Machine_check_polls
      5487 ± 34%      -6.9%       5105 ± 39%  interrupts.CPU86.NMI:Non-maskable_interrupts
      5487 ± 34%      -6.9%       5105 ± 39%  interrupts.CPU86.PMI:Performance_monitoring_interrupts
      1100 ± 24%      -7.2%       1020 ± 13%  interrupts.CPU86.RES:Rescheduling_interrupts
   2119077 ± 22%     -12.1%    1863687 ±  7%  interrupts.CPU86.TLB:TLB_shootdowns
      0.67 ±141%  +1.1e+05%     705.33 ±140%  interrupts.CPU87.123:PCI-MSI.31981656-edge.i40e-eth0-TxRx-87
   1543288 ± 12%     -24.6%    1162893 ±  7%  interrupts.CPU87.CAL:Function_call_interrupts
      8.33 ± 73%     +28.0%      10.67 ± 30%  interrupts.CPU87.IWI:IRQ_work_interrupts
   1995446            -4.0%    1914999 ±  3%  interrupts.CPU87.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU87.MCP:Machine_check_polls
      6320 ± 16%      +0.3%       6342 ± 13%  interrupts.CPU87.NMI:Non-maskable_interrupts
      6320 ± 16%      +0.3%       6342 ± 13%  interrupts.CPU87.PMI:Performance_monitoring_interrupts
      1047 ± 10%     -17.0%     868.67 ± 15%  interrupts.CPU87.RES:Rescheduling_interrupts
   1981925 ± 12%     -22.8%    1529267 ±  7%  interrupts.CPU87.TLB:TLB_shootdowns
     95.67 ±141%     -97.6%       2.33 ± 72%  interrupts.CPU88.124:PCI-MSI.31981657-edge.i40e-eth0-TxRx-88
   1624770 ± 12%     -15.2%    1377338 ± 20%  interrupts.CPU88.CAL:Function_call_interrupts
      7.00 ± 95%      +9.5%       7.67 ± 85%  interrupts.CPU88.IWI:IRQ_work_interrupts
   1995347            -3.9%    1916975 ±  2%  interrupts.CPU88.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU88.MCP:Machine_check_polls
      4523 ± 57%      +6.7%       4824 ± 44%  interrupts.CPU88.NMI:Non-maskable_interrupts
      4523 ± 57%      +6.7%       4824 ± 44%  interrupts.CPU88.PMI:Performance_monitoring_interrupts
      1083 ± 10%      +3.3%       1119 ± 24%  interrupts.CPU88.RES:Rescheduling_interrupts
   2087318 ± 12%     -13.3%    1809967 ± 20%  interrupts.CPU88.TLB:TLB_shootdowns
      6.00 ±129%     -61.1%       2.33 ± 72%  interrupts.CPU89.125:PCI-MSI.31981658-edge.i40e-eth0-TxRx-89
   1481606 ± 22%      -7.1%    1376917 ± 19%  interrupts.CPU89.CAL:Function_call_interrupts
      3.00 ±118%     -88.9%       0.33 ±141%  interrupts.CPU89.IWI:IRQ_work_interrupts
   1998901            -4.6%    1906160 ±  3%  interrupts.CPU89.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU89.MCP:Machine_check_polls
      4186 ± 27%     -28.2%       3006 ±  7%  interrupts.CPU89.NMI:Non-maskable_interrupts
      4186 ± 27%     -28.2%       3006 ±  7%  interrupts.CPU89.PMI:Performance_monitoring_interrupts
      1020 ±  7%      +7.4%       1095 ± 24%  interrupts.CPU89.RES:Rescheduling_interrupts
   1899438 ± 22%      -4.8%    1807856 ± 19%  interrupts.CPU89.TLB:TLB_shootdowns
      0.67 ± 70%      +0.0%       0.67 ± 70%  interrupts.CPU9.128:PCI-MSI.31981661-edge.i40e-eth0-TxRx-92
      2.33 ±141%     +42.9%       3.33 ±141%  interrupts.CPU9.45:PCI-MSI.31981578-edge.i40e-eth0-TxRx-9
      0.33 ±141%    -100.0%       0.00        interrupts.CPU9.80:PCI-MSI.31981613-edge.i40e-eth0-TxRx-44
   1521854 ± 16%     -15.0%    1293417 ± 16%  interrupts.CPU9.CAL:Function_call_interrupts
     13.00 ± 27%     -23.1%      10.00 ± 71%  interrupts.CPU9.IWI:IRQ_work_interrupts
   1995275            -4.0%    1915569 ±  2%  interrupts.CPU9.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU9.MCP:Machine_check_polls
      6492 ± 28%      -5.6%       6128 ± 37%  interrupts.CPU9.NMI:Non-maskable_interrupts
      6492 ± 28%      -5.6%       6128 ± 37%  interrupts.CPU9.PMI:Performance_monitoring_interrupts
      1165 ±  8%      +4.5%       1218 ± 24%  interrupts.CPU9.RES:Rescheduling_interrupts
   1958387 ± 17%     -12.6%    1711409 ± 16%  interrupts.CPU9.TLB:TLB_shootdowns
      6.67 ±141%     -95.0%       0.33 ±141%  interrupts.CPU90.126:PCI-MSI.31981659-edge.i40e-eth0-TxRx-90
   1419100 ±  6%      +3.9%    1474450 ± 16%  interrupts.CPU90.CAL:Function_call_interrupts
      2.67 ±115%    +275.0%      10.00 ± 70%  interrupts.CPU90.IWI:IRQ_work_interrupts
   1994124            -4.7%    1900006 ±  3%  interrupts.CPU90.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU90.MCP:Machine_check_polls
      5082 ± 33%     +20.1%       6105 ± 37%  interrupts.CPU90.NMI:Non-maskable_interrupts
      5082 ± 33%     +20.1%       6105 ± 37%  interrupts.CPU90.PMI:Performance_monitoring_interrupts
      1020 ±  2%      +4.3%       1064 ± 14%  interrupts.CPU90.RES:Rescheduling_interrupts
   1823165 ±  6%      +6.4%    1940759 ± 16%  interrupts.CPU90.TLB:TLB_shootdowns
      1.33 ± 93%      +0.0%       1.33 ±141%  interrupts.CPU91.127:PCI-MSI.31981660-edge.i40e-eth0-TxRx-91
   1508920 ± 12%      -4.9%    1434710 ±  4%  interrupts.CPU91.CAL:Function_call_interrupts
      6.33 ±109%      +5.3%       6.67 ± 74%  interrupts.CPU91.IWI:IRQ_work_interrupts
   1995137            -4.3%    1909670 ±  2%  interrupts.CPU91.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU91.MCP:Machine_check_polls
      5776 ± 36%     -23.8%       4401 ± 58%  interrupts.CPU91.NMI:Non-maskable_interrupts
      5776 ± 36%     -23.8%       4401 ± 58%  interrupts.CPU91.PMI:Performance_monitoring_interrupts
      1063 ±  7%      -1.8%       1044 ± 21%  interrupts.CPU91.RES:Rescheduling_interrupts
   1937394 ± 12%      -2.6%    1887820 ±  4%  interrupts.CPU91.TLB:TLB_shootdowns
      2.00 ±108%     +33.3%       2.67 ±141%  interrupts.CPU92.128:PCI-MSI.31981661-edge.i40e-eth0-TxRx-92
   1309595 ± 19%      -3.8%    1259916 ±  9%  interrupts.CPU92.CAL:Function_call_interrupts
      9.00 ± 32%     -37.0%       5.67 ±104%  interrupts.CPU92.IWI:IRQ_work_interrupts
   1993503            -3.6%    1921571 ±  2%  interrupts.CPU92.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU92.MCP:Machine_check_polls
      5514 ± 31%     -17.4%       4555 ± 38%  interrupts.CPU92.NMI:Non-maskable_interrupts
      5514 ± 31%     -17.4%       4555 ± 38%  interrupts.CPU92.PMI:Performance_monitoring_interrupts
    983.67 ±  6%      +1.8%       1001 ± 22%  interrupts.CPU92.RES:Rescheduling_interrupts
   1679709 ± 19%      -1.5%    1654983 ±  9%  interrupts.CPU92.TLB:TLB_shootdowns
      2.00 ±141%     -16.7%       1.67 ±141%  interrupts.CPU93.129:PCI-MSI.31981662-edge.i40e-eth0-TxRx-93
   1358155 ±  2%      -7.7%    1254119 ± 16%  interrupts.CPU93.CAL:Function_call_interrupts
      4.00 ± 73%    +108.3%       8.33 ± 74%  interrupts.CPU93.IWI:IRQ_work_interrupts
   1996033            -3.8%    1920095 ±  3%  interrupts.CPU93.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU93.MCP:Machine_check_polls
      4559 ± 32%     +20.3%       5485 ± 36%  interrupts.CPU93.NMI:Non-maskable_interrupts
      4559 ± 32%     +20.3%       5485 ± 36%  interrupts.CPU93.PMI:Performance_monitoring_interrupts
    995.67 ± 12%      -6.4%     932.00 ± 17%  interrupts.CPU93.RES:Rescheduling_interrupts
   1741282 ±  2%      -5.3%    1648816 ± 16%  interrupts.CPU93.TLB:TLB_shootdowns
   1273916 ± 17%      +0.7%    1282571 ± 10%  interrupts.CPU94.CAL:Function_call_interrupts
      6.67 ±101%     -25.0%       5.00 ±141%  interrupts.CPU94.IWI:IRQ_work_interrupts
   1998510            -3.9%    1920039 ±  2%  interrupts.CPU94.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU94.MCP:Machine_check_polls
      4580 ± 56%     -10.2%       4112 ± 64%  interrupts.CPU94.NMI:Non-maskable_interrupts
      4580 ± 56%     -10.2%       4112 ± 64%  interrupts.CPU94.PMI:Performance_monitoring_interrupts
    932.33 ± 12%      +3.2%     962.00 ± 23%  interrupts.CPU94.RES:Rescheduling_interrupts
   1634267 ± 17%      +3.2%    1685930 ±  9%  interrupts.CPU94.TLB:TLB_shootdowns
   1293402 ±  5%      +0.4%    1298616 ± 13%  interrupts.CPU95.CAL:Function_call_interrupts
      8.33 ± 63%     -68.0%       2.67 ±115%  interrupts.CPU95.IWI:IRQ_work_interrupts
   2000316            -4.5%    1910356 ±  3%  interrupts.CPU95.LOC:Local_timer_interrupts
      3.00            +0.0%       3.00        interrupts.CPU95.MCP:Machine_check_polls
      6121 ± 29%     -40.8%       3623 ±  3%  interrupts.CPU95.NMI:Non-maskable_interrupts
      6121 ± 29%     -40.8%       3623 ±  3%  interrupts.CPU95.PMI:Performance_monitoring_interrupts
      1042 ± 14%     +10.3%       1149 ± 22%  interrupts.CPU95.RES:Rescheduling_interrupts
   1658511 ±  5%      +3.2%    1711315 ± 13%  interrupts.CPU95.TLB:TLB_shootdowns
    707.00 ±  5%      -4.1%     678.33 ±  2%  interrupts.IWI:IRQ_work_interrupts
 1.912e+08            -4.8%  1.821e+08 ±  3%  interrupts.LOC:Local_timer_interrupts
    288.00            +0.0%     288.00        interrupts.MCP:Machine_check_polls
    526867 ± 13%      -8.8%     480494 ±  2%  interrupts.NMI:Non-maskable_interrupts
    526867 ± 13%      -8.8%     480494 ±  2%  interrupts.PMI:Performance_monitoring_interrupts
    106938 ±  5%      +8.8%     116314 ± 13%  interrupts.RES:Rescheduling_interrupts
      0.00          -100.0%       0.00        interrupts.RTR:APIC_ICR_read_retries
 1.907e+08 ±  2%      +0.2%   1.91e+08        interrupts.TLB:TLB_shootdowns

Best Regards,
Rong Chen

From: kernel test robot <rong.a.chen@intel.com>
Subject: [block] 54529aac98: fsmark.files_per_sec -13.6% regression
Date: Wed, 29 Jul 2020 16:57:58 +0800
Message-ID: <20200729085757.GJ23458@shao2-debian>
References: <20200726150333.305527-8-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="VSaCG/zfRnOiPJtU"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200726150333.305527-8-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Johannes Thumshirn <johannes.thumshirn@wdc.com>, 0day robot <lkp@intel.com>, lkp@lists.01.org


--VSaCG/zfRnOiPJtU
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Greeting,

FYI, we noticed a -13.6% regression of fsmark.files_per_sec due to commit:


commit: 54529aac984de8d3928810c85b575efac0f9d616 ("[PATCH 07/14] block: make QUEUE_SYSFS_BIT_FNS a little more useful")
url: https://github.com/0day-ci/linux/commits/Christoph-Hellwig/fs-remove-the-unused-SB_I_MULTIROOT-flag/20200727-000342
base: https://git.kernel.org/cgit/linux/kernel/git/axboe/linux-block.git for-next

in testcase: fsmark
on test machine: 192 threads Cooper Lake with 128G memory
with following parameters:

	iterations: 1x
	nr_threads: 1t
	disk: 1BRD_32G
	fs: btrfs
	filesize: 4K
	test_size: 4G
	sync_method: fsyncBeforeClose
	nr_files_per_directory: 1fpd
	cpufreq_governor: performance
	ucode: 0x86000017

test-description: The fsmark is a file system benchmark to test synchronous write workloads, for example, mail servers workload.
test-url: https://sourceforge.net/projects/fsmark/

In addition to that, the commit also has significant impact on the following tests:

+------------------+-------------------------------------------------------------+
| testcase: change | fio-basic: fio.write_iops 993.0% improvement                |
| test machine     | 192 threads Intel(R) Xeon(R) CPU @ 2.20GHz with 192G memory |
| test parameters  | bs=4k                                                       |
|                  | cpufreq_governor=performance                                |
|                  | disk=1SSD                                                   |
|                  | fs=btrfs                                                    |
|                  | ioengine=sync                                               |
|                  | nr_task=8                                                   |
|                  | runtime=300s                                                |
|                  | rw=randwrite                                                |
|                  | test_size=512g                                              |
|                  | ucode=0x4002f01                                             |
+------------------+-------------------------------------------------------------+


If you fix the issue, kindly add following tag
Reported-by: kernel test robot <rong.a.chen@intel.com>


Details are as below:
-------------------------------------------------------------------------------------------------->


To reproduce:

        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        bin/lkp install job.yaml  # job file is attached in this email
        bin/lkp run     job.yaml

=========================================================================================
compiler/cpufreq_governor/disk/filesize/fs/iterations/kconfig/nr_files_per_directory/nr_threads/rootfs/sync_method/tbox_group/test_size/testcase/ucode:
  gcc-9/performance/1BRD_32G/4K/btrfs/1x/x86_64-rhel-8.3/1fpd/1t/debian-10.4-x86_64-20200603.cgz/fsyncBeforeClose/lkp-cpx-4s1/4G/fsmark/0x86000017

commit: 
  f8d6c28b2a ("block: lift setting the readahead size into the block layer")
  54529aac98 ("block: make QUEUE_SYSFS_BIT_FNS a little more useful")

f8d6c28b2a8e1156 54529aac984de8d3928810c85b5 
---------------- --------------------------- 
       fail:runs  %reproduction    fail:runs
           |             |             |    
          0:4           -1%           0:4     perf-profile.children.cycles-pp.error_entry
         %stddev     %change         %stddev
             \          |                \  
  17751926            +8.9%   19337948        fsmark.app_overhead
      6346           -13.6%       5483        fsmark.files_per_sec
    165.15           +14.7%     189.42        fsmark.time.elapsed_time
    165.15           +14.7%     189.42        fsmark.time.elapsed_time.max
     24782 ±  2%     +16.3%      28832        fsmark.time.involuntary_context_switches
    151.13           +15.2%     174.14        fsmark.time.system_time
   1147770           +11.2%    1276761        fsmark.time.voluntary_context_switches
     26.68            -1.8%      26.20        boot-time.dhcp
      1094 ± 37%     -48.7%     561.25 ± 50%  numa-meminfo.node2.PageTables
  47861180            -9.2%   43467411        meminfo.MemFree
  17734610           +24.8%   22128380 ±  3%  meminfo.Memused
    500290           +66.6%     833499        vmstat.io.bo
  47896231            -9.2%   43485212        vmstat.memory.free
     48955           +21.0%      59253        vmstat.system.cs
    100261           +18.1%     118396        slabinfo.radix_tree_node.active_objs
      1798           +18.0%       2122        slabinfo.radix_tree_node.active_slabs
    100759           +18.0%     118876        slabinfo.radix_tree_node.num_objs
      1798           +18.0%       2122        slabinfo.radix_tree_node.num_slabs
  38615161           +89.9%   73314982 ±  2%  cpuidle.C1.time
   3109557           +58.2%    4920768        cpuidle.C1.usage
 3.027e+10           +14.3%  3.459e+10        cpuidle.C1E.time
  64384612           +14.0%   73424957        cpuidle.C1E.usage
    420763 ±  7%     +23.8%     521103 ± 11%  cpuidle.POLL.time
   1001776            +4.1%    1042639        proc-vmstat.nr_active_file
     12993            +1.9%      13240        proc-vmstat.nr_dirty
   1343494            -8.2%    1233140        proc-vmstat.nr_dirty_background_threshold
   2690273            -8.2%    2469297        proc-vmstat.nr_dirty_threshold
  11965705            -9.2%   10868385        proc-vmstat.nr_free_pages
   1001776            +4.1%    1042640        proc-vmstat.nr_zone_active_file
     13032            +2.0%      13297        proc-vmstat.nr_zone_write_pending
   1940119 ±  2%     +72.5%    3346705 ±  9%  proc-vmstat.numa_foreign
   4131750           +10.3%    4559084 ±  6%  proc-vmstat.numa_hit
   4038575           +10.6%    4465938 ±  6%  proc-vmstat.numa_local
   1940119 ±  2%     +72.5%    3346705 ±  9%  proc-vmstat.numa_miss
   2033294 ±  2%     +69.2%    3439851 ±  9%  proc-vmstat.numa_other
    950436            +6.2%    1009835 ±  6%  proc-vmstat.pgactivate
   6711546 ±  2%     +28.4%    8614751 ±  2%  proc-vmstat.pgalloc_normal
    665913           +14.7%     764043        proc-vmstat.pgfault
  83920002           +91.2%  1.604e+08        proc-vmstat.pgpgout
      9.16            +7.3%       9.82        perf-stat.i.MPKI
  1.25e+09            -6.7%  1.167e+09        perf-stat.i.branch-instructions
  11477332            -5.2%   10880556 ±  2%  perf-stat.i.branch-misses
     49712           +21.0%      60163        perf-stat.i.context-switches
      2.95            +7.3%       3.17 ±  2%  perf-stat.i.cpi
 1.615e+09            -4.9%  1.536e+09        perf-stat.i.dTLB-loads
 8.427e+08            -5.4%  7.973e+08        perf-stat.i.dTLB-stores
 6.372e+09            -6.9%   5.93e+09        perf-stat.i.instructions
      1516            -6.2%       1422        perf-stat.i.instructions-per-iTLB-miss
      0.34            -6.9%       0.32 ±  2%  perf-stat.i.ipc
     19.67            -5.5%      18.59        perf-stat.i.metric.M/sec
     63.85            +4.9       68.72 ±  3%  perf-stat.i.node-load-miss-rate%
    930657 ±  5%     -14.6%     795230 ± 12%  perf-stat.i.node-loads
    472374 ±  2%     +31.6%     621845 ±  9%  perf-stat.i.node-store-misses
    972412 ±  3%      +9.0%    1060090 ±  6%  perf-stat.i.node-stores
      8.97            +7.5%       9.64        perf-stat.overall.MPKI
      2.90            +7.4%       3.12 ±  2%  perf-stat.overall.cpi
      1515            -6.3%       1419        perf-stat.overall.instructions-per-iTLB-miss
      0.34            -6.8%       0.32 ±  2%  perf-stat.overall.ipc
 1.243e+09            -6.6%   1.16e+09        perf-stat.ps.branch-instructions
  11419074            -5.2%   10822847 ±  2%  perf-stat.ps.branch-misses
     49384           +21.1%      59799        perf-stat.ps.context-switches
 1.606e+09            -4.8%  1.528e+09        perf-stat.ps.dTLB-loads
 8.377e+08            -5.3%  7.931e+08        perf-stat.ps.dTLB-stores
 6.334e+09            -6.9%  5.898e+09        perf-stat.ps.instructions
    924849 ±  5%     -14.5%     790976 ± 12%  perf-stat.ps.node-loads
    469241 ±  2%     +31.8%     618470 ±  9%  perf-stat.ps.node-store-misses
    966794 ±  3%      +9.1%    1054708 ±  6%  perf-stat.ps.node-stores
  1.05e+12            +6.9%  1.123e+12        perf-stat.total.instructions
     11038 ± 22%     +25.7%      13880 ± 23%  sched_debug.cfs_rq:/.load.avg
    230.71 ± 20%     -42.7%     132.22 ± 10%  sched_debug.cfs_rq:/.load_avg.avg
     21506 ± 20%     -51.5%      10427 ±  6%  sched_debug.cfs_rq:/.load_avg.max
      2086 ± 20%     -49.5%       1052 ±  8%  sched_debug.cfs_rq:/.load_avg.stddev
     93248 ± 14%     +39.6%     130209        sched_debug.cpu.clock.avg
     93261 ± 14%     +39.6%     130221        sched_debug.cpu.clock.max
     93235 ± 14%     +39.6%     130198        sched_debug.cpu.clock.min
     92126 ± 14%     +39.2%     128251        sched_debug.cpu.clock_task.avg
     92856 ± 14%     +39.5%     129536        sched_debug.cpu.clock_task.max
     83568 ± 15%     +42.4%     119014        sched_debug.cpu.clock_task.min
    797.56 ±  7%     +27.5%       1016 ±  4%  sched_debug.cpu.clock_task.stddev
      5007 ±  8%     +23.4%       6180        sched_debug.cpu.curr->pid.max
    562.64 ±  2%      +7.9%     607.19 ±  4%  sched_debug.cpu.curr->pid.stddev
     13542 ± 25%    +122.7%      30158        sched_debug.cpu.nr_switches.avg
    525933 ± 27%     +49.2%     784862 ±  9%  sched_debug.cpu.nr_switches.max
    848.29 ± 32%     +40.3%       1190 ± 15%  sched_debug.cpu.nr_switches.min
     48875 ± 24%     +81.5%      88697 ±  5%  sched_debug.cpu.nr_switches.stddev
     11890 ± 28%    +139.7%      28500        sched_debug.cpu.sched_count.avg
    519219 ± 28%     +50.2%     779702 ± 10%  sched_debug.cpu.sched_count.max
    222.04 ± 23%     +69.1%     375.56 ±  6%  sched_debug.cpu.sched_count.min
     48367 ± 24%     +82.7%      88372 ±  6%  sched_debug.cpu.sched_count.stddev
      5870 ± 28%    +140.5%      14121        sched_debug.cpu.sched_goidle.avg
    253647 ± 28%     +50.3%     381213 ± 10%  sched_debug.cpu.sched_goidle.max
     83.21 ± 22%     +70.5%     141.88 ±  7%  sched_debug.cpu.sched_goidle.min
     23845 ± 24%     +83.4%      43739 ±  6%  sched_debug.cpu.sched_goidle.stddev
      5911 ± 28%    +140.1%      14194        sched_debug.cpu.ttwu_count.avg
    373905 ± 29%    +112.3%     793765 ± 10%  sched_debug.cpu.ttwu_count.max
     84.08 ± 25%     +74.2%     146.50 ±  7%  sched_debug.cpu.ttwu_count.min
     29382 ± 28%    +123.8%      65763 ±  7%  sched_debug.cpu.ttwu_count.stddev
    204.86 ± 25%     +68.6%     345.39        sched_debug.cpu.ttwu_local.avg
      6318 ± 28%     +44.3%       9115 ±  5%  sched_debug.cpu.ttwu_local.max
     76.42 ± 24%     +67.7%     128.19 ±  4%  sched_debug.cpu.ttwu_local.min
    451.44 ± 28%     +46.2%     660.22 ±  4%  sched_debug.cpu.ttwu_local.stddev
     93236 ± 14%     +39.6%     130198        sched_debug.cpu_clk
     92489 ± 14%     +40.0%     129450        sched_debug.ktime
     93635 ± 14%     +39.5%     130601        sched_debug.sched_clk
    332710           +14.6%     381386        interrupts.CPU0.LOC:Local_timer_interrupts
    332760           +14.6%     381375        interrupts.CPU1.LOC:Local_timer_interrupts
    332744           +14.6%     381431        interrupts.CPU10.LOC:Local_timer_interrupts
    332675           +14.6%     381345        interrupts.CPU100.LOC:Local_timer_interrupts
    332711           +14.6%     381337        interrupts.CPU101.LOC:Local_timer_interrupts
    332687           +14.6%     381338        interrupts.CPU102.LOC:Local_timer_interrupts
    332686           +14.6%     381306        interrupts.CPU103.LOC:Local_timer_interrupts
    332673           +14.6%     381359        interrupts.CPU104.LOC:Local_timer_interrupts
    332692           +14.6%     381284        interrupts.CPU105.LOC:Local_timer_interrupts
    332672           +14.6%     381322        interrupts.CPU106.LOC:Local_timer_interrupts
    332662           +14.6%     381373        interrupts.CPU107.LOC:Local_timer_interrupts
    332692           +14.6%     381320        interrupts.CPU108.LOC:Local_timer_interrupts
    332660           +14.6%     381331        interrupts.CPU109.LOC:Local_timer_interrupts
    332696           +14.6%     381321        interrupts.CPU11.LOC:Local_timer_interrupts
     95.00 ±109%     -72.4%      26.25 ±135%  interrupts.CPU11.RES:Rescheduling_interrupts
    332674           +14.6%     381351        interrupts.CPU110.LOC:Local_timer_interrupts
    332712           +14.6%     381322        interrupts.CPU111.LOC:Local_timer_interrupts
    332671           +14.6%     381355        interrupts.CPU112.LOC:Local_timer_interrupts
    332660           +14.6%     381389        interrupts.CPU113.LOC:Local_timer_interrupts
    332658           +14.6%     381317        interrupts.CPU114.LOC:Local_timer_interrupts
    332659           +14.6%     381322        interrupts.CPU115.LOC:Local_timer_interrupts
    332659           +14.6%     381304        interrupts.CPU116.LOC:Local_timer_interrupts
    332636           +14.6%     381350        interrupts.CPU117.LOC:Local_timer_interrupts
    332644           +14.6%     381353        interrupts.CPU118.LOC:Local_timer_interrupts
    332658           +14.6%     381306        interrupts.CPU119.LOC:Local_timer_interrupts
    332608           +14.6%     381178        interrupts.CPU12.LOC:Local_timer_interrupts
    332661           +14.6%     381292        interrupts.CPU120.LOC:Local_timer_interrupts
    332697           +14.6%     381360        interrupts.CPU121.LOC:Local_timer_interrupts
    332680           +14.6%     381351        interrupts.CPU122.LOC:Local_timer_interrupts
    332663           +14.6%     381299        interrupts.CPU123.LOC:Local_timer_interrupts
    332668           +14.6%     381367        interrupts.CPU124.LOC:Local_timer_interrupts
    332675           +14.6%     381272        interrupts.CPU125.LOC:Local_timer_interrupts
    332663           +14.6%     381267        interrupts.CPU126.LOC:Local_timer_interrupts
    332671           +14.6%     381311        interrupts.CPU127.LOC:Local_timer_interrupts
    332734           +14.6%     381284        interrupts.CPU128.LOC:Local_timer_interrupts
    332665           +14.6%     381279        interrupts.CPU129.LOC:Local_timer_interrupts
    332720           +14.6%     381445        interrupts.CPU13.LOC:Local_timer_interrupts
    332666           +14.6%     381276        interrupts.CPU130.LOC:Local_timer_interrupts
    332642           +14.6%     381277        interrupts.CPU131.LOC:Local_timer_interrupts
    332671           +14.6%     381297        interrupts.CPU132.LOC:Local_timer_interrupts
    332664           +14.6%     381276        interrupts.CPU133.LOC:Local_timer_interrupts
    332691           +14.6%     381296        interrupts.CPU134.LOC:Local_timer_interrupts
    332689           +14.6%     381270        interrupts.CPU135.LOC:Local_timer_interrupts
    332573           +14.6%     381248        interrupts.CPU136.LOC:Local_timer_interrupts
      9.50 ± 49%    +381.6%      45.75 ±103%  interrupts.CPU136.RES:Rescheduling_interrupts
    332643           +14.6%     381263        interrupts.CPU137.LOC:Local_timer_interrupts
    332654           +14.6%     381233        interrupts.CPU138.LOC:Local_timer_interrupts
    332657           +14.6%     381274        interrupts.CPU139.LOC:Local_timer_interrupts
    332653           +14.7%     381411        interrupts.CPU14.LOC:Local_timer_interrupts
    332673           +14.6%     381277        interrupts.CPU140.LOC:Local_timer_interrupts
    332655           +14.6%     381276        interrupts.CPU141.LOC:Local_timer_interrupts
    332548           +14.7%     381277        interrupts.CPU142.LOC:Local_timer_interrupts
    332658           +14.6%     381277        interrupts.CPU143.LOC:Local_timer_interrupts
    332701           +14.6%     381360        interrupts.CPU144.LOC:Local_timer_interrupts
    332698           +14.6%     381314        interrupts.CPU145.LOC:Local_timer_interrupts
    332696           +14.6%     381314        interrupts.CPU146.LOC:Local_timer_interrupts
    332711           +14.6%     381362        interrupts.CPU147.LOC:Local_timer_interrupts
    332700           +14.6%     381328        interrupts.CPU148.LOC:Local_timer_interrupts
    332700           +14.6%     381312        interrupts.CPU149.LOC:Local_timer_interrupts
    332727           +14.6%     381299        interrupts.CPU15.LOC:Local_timer_interrupts
    332703           +14.6%     381352        interrupts.CPU150.LOC:Local_timer_interrupts
    332696           +14.6%     381295        interrupts.CPU151.LOC:Local_timer_interrupts
    332800           +14.6%     381300        interrupts.CPU152.LOC:Local_timer_interrupts
    332710           +14.6%     381291        interrupts.CPU153.LOC:Local_timer_interrupts
    332727           +14.6%     381302        interrupts.CPU154.LOC:Local_timer_interrupts
    332711           +14.6%     381291        interrupts.CPU155.LOC:Local_timer_interrupts
    332761           +14.6%     381291        interrupts.CPU156.LOC:Local_timer_interrupts
    332686           +14.6%     381282        interrupts.CPU157.LOC:Local_timer_interrupts
    332681           +14.6%     381299        interrupts.CPU158.LOC:Local_timer_interrupts
    332713           +14.6%     381340        interrupts.CPU159.LOC:Local_timer_interrupts
    332695           +14.6%     381344        interrupts.CPU16.LOC:Local_timer_interrupts
    332720           +14.6%     381292        interrupts.CPU160.LOC:Local_timer_interrupts
    332689           +14.6%     381290        interrupts.CPU161.LOC:Local_timer_interrupts
    332711           +14.6%     381275        interrupts.CPU162.LOC:Local_timer_interrupts
    332691           +14.6%     381276        interrupts.CPU163.LOC:Local_timer_interrupts
    332685           +14.6%     381288        interrupts.CPU164.LOC:Local_timer_interrupts
    332794           +14.6%     381316        interrupts.CPU165.LOC:Local_timer_interrupts
    332691           +14.6%     381274        interrupts.CPU166.LOC:Local_timer_interrupts
    332686           +14.6%     381280        interrupts.CPU167.LOC:Local_timer_interrupts
    332709           +14.6%     381291        interrupts.CPU168.LOC:Local_timer_interrupts
    332683           +14.6%     381304        interrupts.CPU169.LOC:Local_timer_interrupts
    332700           +14.6%     381292        interrupts.CPU17.LOC:Local_timer_interrupts
    332729           +14.6%     381304        interrupts.CPU170.LOC:Local_timer_interrupts
    332745           +14.6%     381315        interrupts.CPU171.LOC:Local_timer_interrupts
    332728           +14.6%     381314        interrupts.CPU172.LOC:Local_timer_interrupts
    332664           +14.6%     381293        interrupts.CPU173.LOC:Local_timer_interrupts
    332721           +14.6%     381283        interrupts.CPU174.LOC:Local_timer_interrupts
    332708           +14.6%     381281        interrupts.CPU175.LOC:Local_timer_interrupts
    332691           +14.6%     381285        interrupts.CPU176.LOC:Local_timer_interrupts
    332675           +14.6%     381292        interrupts.CPU177.LOC:Local_timer_interrupts
    332664           +14.6%     381296        interrupts.CPU178.LOC:Local_timer_interrupts
    332660           +14.6%     381287        interrupts.CPU179.LOC:Local_timer_interrupts
    332652           +14.6%     381318        interrupts.CPU18.LOC:Local_timer_interrupts
    332664           +14.6%     381282        interrupts.CPU180.LOC:Local_timer_interrupts
    332566           +14.7%     381290        interrupts.CPU181.LOC:Local_timer_interrupts
      7.00 ± 17%    +607.1%      49.50 ±105%  interrupts.CPU181.RES:Rescheduling_interrupts
    332645           +14.6%     381288        interrupts.CPU182.LOC:Local_timer_interrupts
    332671           +14.6%     381283        interrupts.CPU183.LOC:Local_timer_interrupts
     10.25 ± 25%    +509.8%      62.50 ±119%  interrupts.CPU183.RES:Rescheduling_interrupts
    332705           +14.6%     381294        interrupts.CPU184.LOC:Local_timer_interrupts
    332699           +14.6%     381334        interrupts.CPU185.LOC:Local_timer_interrupts
    332645           +14.6%     381330        interrupts.CPU186.LOC:Local_timer_interrupts
    332644           +14.6%     381306        interrupts.CPU187.LOC:Local_timer_interrupts
    332655           +14.6%     381268        interrupts.CPU188.LOC:Local_timer_interrupts
    332645           +14.6%     381357        interrupts.CPU189.LOC:Local_timer_interrupts
     13.25 ± 20%    +207.5%      40.75 ± 87%  interrupts.CPU189.RES:Rescheduling_interrupts
    332697           +14.6%     381311        interrupts.CPU19.LOC:Local_timer_interrupts
    332661           +14.6%     381300        interrupts.CPU190.LOC:Local_timer_interrupts
    332826           +14.6%     381443        interrupts.CPU191.LOC:Local_timer_interrupts
    332687           +14.6%     381405        interrupts.CPU2.LOC:Local_timer_interrupts
    332683           +14.6%     381333        interrupts.CPU20.LOC:Local_timer_interrupts
    332671           +14.6%     381325        interrupts.CPU21.LOC:Local_timer_interrupts
    332703           +14.6%     381238        interrupts.CPU22.LOC:Local_timer_interrupts
    332696           +14.6%     381347        interrupts.CPU23.LOC:Local_timer_interrupts
    332653           +14.6%     381286        interrupts.CPU24.LOC:Local_timer_interrupts
    332709           +14.6%     381354        interrupts.CPU25.LOC:Local_timer_interrupts
    332675           +14.6%     381329        interrupts.CPU26.LOC:Local_timer_interrupts
    332742           +14.6%     381338        interrupts.CPU27.LOC:Local_timer_interrupts
    332699           +14.6%     381378        interrupts.CPU28.LOC:Local_timer_interrupts
    332735           +14.6%     381336        interrupts.CPU29.LOC:Local_timer_interrupts
    332595           +14.7%     381338        interrupts.CPU3.LOC:Local_timer_interrupts
    332700           +14.6%     381348        interrupts.CPU30.LOC:Local_timer_interrupts
      8.25 ± 85%    +430.3%      43.75 ± 94%  interrupts.CPU30.RES:Rescheduling_interrupts
    332708           +14.6%     381250        interrupts.CPU31.LOC:Local_timer_interrupts
    332722           +14.6%     381214        interrupts.CPU32.LOC:Local_timer_interrupts
    332682           +14.6%     381300        interrupts.CPU33.LOC:Local_timer_interrupts
    332680           +14.6%     381288        interrupts.CPU34.LOC:Local_timer_interrupts
    332677           +14.6%     381283        interrupts.CPU35.LOC:Local_timer_interrupts
    332731           +14.6%     381287        interrupts.CPU36.LOC:Local_timer_interrupts
    332680           +14.6%     381286        interrupts.CPU37.LOC:Local_timer_interrupts
    332698           +14.6%     381287        interrupts.CPU38.LOC:Local_timer_interrupts
    332690           +14.6%     381287        interrupts.CPU39.LOC:Local_timer_interrupts
    332719           +14.6%     381410        interrupts.CPU4.LOC:Local_timer_interrupts
    332662           +14.6%     381283        interrupts.CPU40.LOC:Local_timer_interrupts
    332695           +14.6%     381286        interrupts.CPU41.LOC:Local_timer_interrupts
    332688           +14.6%     381286        interrupts.CPU42.LOC:Local_timer_interrupts
    332673           +14.6%     381287        interrupts.CPU43.LOC:Local_timer_interrupts
    332705           +14.6%     381305        interrupts.CPU44.LOC:Local_timer_interrupts
    332706           +14.6%     381285        interrupts.CPU45.LOC:Local_timer_interrupts
    332692           +14.6%     381295        interrupts.CPU46.LOC:Local_timer_interrupts
    332697           +14.6%     381368        interrupts.CPU47.LOC:Local_timer_interrupts
    332712           +14.6%     381297        interrupts.CPU48.LOC:Local_timer_interrupts
    332706           +14.6%     381312        interrupts.CPU49.LOC:Local_timer_interrupts
    332709           +14.6%     381387        interrupts.CPU5.LOC:Local_timer_interrupts
    332738           +14.6%     381286        interrupts.CPU50.LOC:Local_timer_interrupts
    332723           +14.6%     381308        interrupts.CPU51.LOC:Local_timer_interrupts
    332698           +14.6%     381319        interrupts.CPU52.LOC:Local_timer_interrupts
    332708           +14.6%     381311        interrupts.CPU53.LOC:Local_timer_interrupts
    332702           +14.6%     381325        interrupts.CPU54.LOC:Local_timer_interrupts
    332699           +14.6%     381305        interrupts.CPU55.LOC:Local_timer_interrupts
    332722           +14.6%     381223        interrupts.CPU56.LOC:Local_timer_interrupts
    332716           +14.6%     381336        interrupts.CPU57.LOC:Local_timer_interrupts
    332711           +14.6%     381322        interrupts.CPU58.LOC:Local_timer_interrupts
    332740           +14.6%     381308        interrupts.CPU59.LOC:Local_timer_interrupts
    332702           +14.6%     381330        interrupts.CPU6.LOC:Local_timer_interrupts
    332720           +14.6%     381313        interrupts.CPU60.LOC:Local_timer_interrupts
    332703           +14.6%     381309        interrupts.CPU61.LOC:Local_timer_interrupts
    332709           +14.6%     381312        interrupts.CPU62.LOC:Local_timer_interrupts
    332705           +14.6%     381319        interrupts.CPU63.LOC:Local_timer_interrupts
    332744           +14.6%     381299        interrupts.CPU64.LOC:Local_timer_interrupts
    332748           +14.6%     381300        interrupts.CPU65.LOC:Local_timer_interrupts
    332751           +14.6%     381297        interrupts.CPU66.LOC:Local_timer_interrupts
    332722           +14.6%     381307        interrupts.CPU67.LOC:Local_timer_interrupts
    332708           +14.6%     381295        interrupts.CPU68.LOC:Local_timer_interrupts
    332721           +14.6%     381322        interrupts.CPU69.LOC:Local_timer_interrupts
    332638           +14.6%     381198        interrupts.CPU7.LOC:Local_timer_interrupts
    332707           +14.6%     381360        interrupts.CPU70.LOC:Local_timer_interrupts
    332703           +14.6%     381334        interrupts.CPU71.LOC:Local_timer_interrupts
    332682           +14.6%     381285        interrupts.CPU72.LOC:Local_timer_interrupts
    332701           +14.6%     381330        interrupts.CPU73.LOC:Local_timer_interrupts
    332671           +14.6%     381332        interrupts.CPU74.LOC:Local_timer_interrupts
    332757           +14.6%     381305        interrupts.CPU75.LOC:Local_timer_interrupts
    332733           +14.6%     381306        interrupts.CPU76.LOC:Local_timer_interrupts
    332665           +14.6%     381317        interrupts.CPU77.LOC:Local_timer_interrupts
    332672           +14.6%     381343        interrupts.CPU78.LOC:Local_timer_interrupts
    332664           +14.6%     381310        interrupts.CPU79.LOC:Local_timer_interrupts
    332715           +14.6%     381404        interrupts.CPU8.LOC:Local_timer_interrupts
    332628           +14.6%     381316        interrupts.CPU80.LOC:Local_timer_interrupts
    332571           +14.7%     381315        interrupts.CPU81.LOC:Local_timer_interrupts
    332668           +14.6%     381303        interrupts.CPU82.LOC:Local_timer_interrupts
      6.25 ± 36%    +492.0%      37.00 ±118%  interrupts.CPU82.RES:Rescheduling_interrupts
    332676           +14.6%     381345        interrupts.CPU83.LOC:Local_timer_interrupts
    332676           +14.6%     381302        interrupts.CPU84.LOC:Local_timer_interrupts
      7.00 ± 17%    +675.0%      54.25 ±127%  interrupts.CPU84.RES:Rescheduling_interrupts
    332689           +14.6%     381314        interrupts.CPU85.LOC:Local_timer_interrupts
    332681           +14.6%     381213        interrupts.CPU86.LOC:Local_timer_interrupts
      9.00 ± 23%    +377.8%      43.00 ±107%  interrupts.CPU86.RES:Rescheduling_interrupts
    332673           +14.6%     381348        interrupts.CPU87.LOC:Local_timer_interrupts
    332669           +14.6%     381382        interrupts.CPU88.LOC:Local_timer_interrupts
    332676           +14.6%     381330        interrupts.CPU89.LOC:Local_timer_interrupts
    332676           +14.6%     381320        interrupts.CPU9.LOC:Local_timer_interrupts
    332677           +14.6%     381337        interrupts.CPU90.LOC:Local_timer_interrupts
      7.00 ± 17%    +760.7%      60.25 ±143%  interrupts.CPU90.RES:Rescheduling_interrupts
    332716           +14.6%     381324        interrupts.CPU91.LOC:Local_timer_interrupts
    332678           +14.6%     381318        interrupts.CPU92.LOC:Local_timer_interrupts
    332679           +14.6%     381313        interrupts.CPU93.LOC:Local_timer_interrupts
    332680           +14.6%     381307        interrupts.CPU94.LOC:Local_timer_interrupts
    332739           +14.6%     381288        interrupts.CPU95.LOC:Local_timer_interrupts
      7.00 ± 22%    +967.9%      74.75 ±138%  interrupts.CPU95.RES:Rescheduling_interrupts
    332660           +14.6%     381292        interrupts.CPU96.LOC:Local_timer_interrupts
    332715           +14.6%     381374        interrupts.CPU97.LOC:Local_timer_interrupts
    332670           +14.6%     381336        interrupts.CPU98.LOC:Local_timer_interrupts
    332669           +14.6%     381401        interrupts.CPU99.LOC:Local_timer_interrupts
  63876342           +14.6%   73212105        interrupts.LOC:Local_timer_interrupts
     15573 ±  4%     +20.6%      18773 ±  3%  interrupts.RES:Rescheduling_interrupts
     17.28 ±  3%      -3.9       13.36 ± 16%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe
     17.26 ±  3%      -3.9       13.34 ± 16%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
     13.39 ±  4%      -2.9       10.50 ± 16%  perf-profile.calltrace.cycles-pp.do_fsync.__x64_sys_fsync.do_syscall_64.entry_SYSCALL_64_after_hwframe
     13.39 ±  4%      -2.9       10.50 ± 16%  perf-profile.calltrace.cycles-pp.__x64_sys_fsync.do_syscall_64.entry_SYSCALL_64_after_hwframe
     13.38 ±  4%      -2.9       10.50 ± 16%  perf-profile.calltrace.cycles-pp.btrfs_sync_file.do_fsync.__x64_sys_fsync.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4.64 ±  2%      -1.3        3.35 ± 18%  perf-profile.calltrace.cycles-pp.btrfs_log_dentry_safe.btrfs_sync_file.do_fsync.__x64_sys_fsync.do_syscall_64
      4.63 ±  2%      -1.3        3.34 ± 18%  perf-profile.calltrace.cycles-pp.btrfs_log_inode_parent.btrfs_log_dentry_safe.btrfs_sync_file.do_fsync.__x64_sys_fsync
      4.56 ±  2%      -1.3        3.30 ± 18%  perf-profile.calltrace.cycles-pp.btrfs_log_inode.btrfs_log_inode_parent.btrfs_log_dentry_safe.btrfs_sync_file.do_fsync
      2.16 ±  5%      -1.2        0.99 ± 19%  perf-profile.calltrace.cycles-pp.btree_csum_one_bio.btree_submit_bio_hook.submit_one_bio.btree_write_cache_pages.do_writepages
      4.36 ±  4%      -1.1        3.27 ± 18%  perf-profile.calltrace.cycles-pp.submit_one_bio.btree_write_cache_pages.do_writepages.__filemap_fdatawrite_range.btrfs_write_marked_extents
      4.35 ±  4%      -1.1        3.27 ± 18%  perf-profile.calltrace.cycles-pp.btree_submit_bio_hook.submit_one_bio.btree_write_cache_pages.do_writepages.__filemap_fdatawrite_range
      1.12 ±  7%      -0.9        0.26 ±100%  perf-profile.calltrace.cycles-pp.btrfs_check_node.btree_csum_one_bio.btree_submit_bio_hook.submit_one_bio.btree_write_cache_pages
      2.02            -0.6        1.45 ± 18%  perf-profile.calltrace.cycles-pp.btrfs_truncate_inode_items.btrfs_log_inode.btrfs_log_inode_parent.btrfs_log_dentry_safe.btrfs_sync_file
      1.99            -0.6        1.44 ± 17%  perf-profile.calltrace.cycles-pp.btrfs_search_slot.btrfs_truncate_inode_items.btrfs_log_inode.btrfs_log_inode_parent.btrfs_log_dentry_safe
      1.89 ±  2%      -0.5        1.38 ± 17%  perf-profile.calltrace.cycles-pp.btrfs_cow_block.btrfs_search_slot.btrfs_truncate_inode_items.btrfs_log_inode.btrfs_log_inode_parent
      0.95 ±  5%      -0.5        0.45 ± 57%  perf-profile.calltrace.cycles-pp.check_leaf.btree_csum_one_bio.btree_submit_bio_hook.submit_one_bio.btree_write_cache_pages
      1.88 ±  2%      -0.5        1.38 ± 17%  perf-profile.calltrace.cycles-pp.__btrfs_cow_block.btrfs_cow_block.btrfs_search_slot.btrfs_truncate_inode_items.btrfs_log_inode
      0.74 ±  8%      -0.4        0.32 ±100%  perf-profile.calltrace.cycles-pp.btrfs_search_slot.btrfs_update_root.btrfs_sync_log.btrfs_sync_file.do_fsync
      0.71 ±  7%      -0.4        0.31 ±100%  perf-profile.calltrace.cycles-pp.btrfs_cow_block.btrfs_search_slot.btrfs_update_root.btrfs_sync_log.btrfs_sync_file
      0.90 ±  2%      -0.4        0.50 ± 59%  perf-profile.calltrace.cycles-pp.copy_extent_buffer_full.__btrfs_cow_block.btrfs_cow_block.btrfs_search_slot.btrfs_truncate_inode_items
      0.71 ±  7%      -0.4        0.31 ±100%  perf-profile.calltrace.cycles-pp.__btrfs_cow_block.btrfs_cow_block.btrfs_search_slot.btrfs_update_root.btrfs_sync_log
      0.90 ±  2%      -0.4        0.50 ± 59%  perf-profile.calltrace.cycles-pp.copy_page.copy_extent_buffer_full.__btrfs_cow_block.btrfs_cow_block.btrfs_search_slot
      1.68 ±  2%      -0.4        1.28 ± 23%  perf-profile.calltrace.cycles-pp.do_mkdirat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.66 ±  5%      -0.4        0.27 ±100%  perf-profile.calltrace.cycles-pp.new_sync_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.22 ±  7%      -0.4        0.85 ± 14%  perf-profile.calltrace.cycles-pp.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.22 ±  7%      -0.4        0.85 ± 14%  perf-profile.calltrace.cycles-pp.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.18 ±  8%      -0.4        0.82 ± 15%  perf-profile.calltrace.cycles-pp.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.18 ±  8%      -0.4        0.82 ± 15%  perf-profile.calltrace.cycles-pp.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64
      0.62 ±  7%      -0.4        0.27 ±100%  perf-profile.calltrace.cycles-pp.btrfs_add_link.btrfs_mkdir.vfs_mkdir.do_mkdirat.do_syscall_64
      0.60 ±  7%      -0.3        0.26 ±100%  perf-profile.calltrace.cycles-pp.btrfs_insert_dir_item.btrfs_add_link.btrfs_mkdir.vfs_mkdir.do_mkdirat
      1.01 ±  7%      -0.3        0.68 ± 13%  perf-profile.calltrace.cycles-pp.start_ordered_ops.btrfs_sync_file.do_fsync.__x64_sys_fsync.do_syscall_64
      1.00 ±  7%      -0.3        0.68 ± 13%  perf-profile.calltrace.cycles-pp.btrfs_fdatawrite_range.start_ordered_ops.btrfs_sync_file.do_fsync.__x64_sys_fsync
      0.99 ±  7%      -0.3        0.67 ± 13%  perf-profile.calltrace.cycles-pp.do_writepages.__filemap_fdatawrite_range.btrfs_fdatawrite_range.start_ordered_ops.btrfs_sync_file
      1.00 ±  7%      -0.3        0.68 ± 13%  perf-profile.calltrace.cycles-pp.__filemap_fdatawrite_range.btrfs_fdatawrite_range.start_ordered_ops.btrfs_sync_file.do_fsync
      0.99 ±  7%      -0.3        0.67 ± 13%  perf-profile.calltrace.cycles-pp.extent_writepages.do_writepages.__filemap_fdatawrite_range.btrfs_fdatawrite_range.start_ordered_ops
      0.79 ±  8%      -0.3        0.47 ± 57%  perf-profile.calltrace.cycles-pp.btrfs_create.path_openat.do_filp_open.do_sys_openat2.do_sys_open
      1.32            -0.3        1.01 ± 24%  perf-profile.calltrace.cycles-pp.vfs_mkdir.do_mkdirat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.75 ±  8%      -0.3        0.45 ± 59%  perf-profile.calltrace.cycles-pp.btrfs_update_root.btrfs_sync_log.btrfs_sync_file.do_fsync.__x64_sys_fsync
      1.30            -0.3        1.00 ± 23%  perf-profile.calltrace.cycles-pp.btrfs_mkdir.vfs_mkdir.do_mkdirat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.30 ±  3%      -0.3        1.01 ± 21%  perf-profile.calltrace.cycles-pp.copy_items.btrfs_log_inode.btrfs_log_inode_parent.btrfs_log_dentry_safe.btrfs_sync_file
      0.83 ±  4%      -0.3        0.54 ± 58%  perf-profile.calltrace.cycles-pp.log_csums.copy_items.btrfs_log_inode.btrfs_log_inode_parent.btrfs_log_dentry_safe
      0.68 ±  5%      -0.3        0.41 ± 58%  perf-profile.calltrace.cycles-pp.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.68 ±  5%      -0.3        0.41 ± 58%  perf-profile.calltrace.cycles-pp.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.84 ±  6%      +0.1        0.94 ±  2%  perf-profile.calltrace.cycles-pp.perf_mux_hrtimer_handler.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_apic_timer_interrupt.asm_call_on_stack
      0.00            +0.7        0.66 ± 15%  perf-profile.calltrace.cycles-pp.btrfs_map_bio.btree_submit_bio_hook.submit_one_bio.submit_extent_page.write_one_eb
      0.68 ±  8%      +1.0        1.73 ± 17%  perf-profile.calltrace.cycles-pp.write_one_eb.btree_write_cache_pages.do_writepages.__filemap_fdatawrite_range.btrfs_write_marked_extents
      0.00            +1.3        1.26 ± 14%  perf-profile.calltrace.cycles-pp.submit_one_bio.submit_extent_page.write_one_eb.btree_write_cache_pages.do_writepages
      0.00            +1.3        1.26 ± 14%  perf-profile.calltrace.cycles-pp.btree_submit_bio_hook.submit_one_bio.submit_extent_page.write_one_eb.btree_write_cache_pages
      0.00            +1.4        1.37 ± 16%  perf-profile.calltrace.cycles-pp.submit_extent_page.write_one_eb.btree_write_cache_pages.do_writepages.__filemap_fdatawrite_range
     80.22            +3.8       83.98 ±  2%  perf-profile.calltrace.cycles-pp.secondary_startup_64
     17.50 ±  3%      -3.9       13.56 ± 16%  perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     17.48 ±  3%      -3.9       13.55 ± 16%  perf-profile.children.cycles-pp.do_syscall_64
     13.39 ±  4%      -2.9       10.50 ± 16%  perf-profile.children.cycles-pp.do_fsync
     13.39 ±  4%      -2.9       10.50 ± 16%  perf-profile.children.cycles-pp.__x64_sys_fsync
     13.38 ±  4%      -2.9       10.50 ± 16%  perf-profile.children.cycles-pp.btrfs_sync_file
      4.64 ±  2%      -1.3        3.35 ± 18%  perf-profile.children.cycles-pp.btrfs_log_dentry_safe
      4.63 ±  2%      -1.3        3.34 ± 18%  perf-profile.children.cycles-pp.btrfs_log_inode_parent
      4.57 ±  2%      -1.3        3.30 ± 18%  perf-profile.children.cycles-pp.btrfs_log_inode
      5.26 ±  2%      -1.2        4.01 ± 17%  perf-profile.children.cycles-pp.btrfs_search_slot
      3.26            -0.8        2.43 ± 18%  perf-profile.children.cycles-pp.btrfs_cow_block
      3.25            -0.8        2.42 ± 18%  perf-profile.children.cycles-pp.__btrfs_cow_block
      1.22 ±  8%      -0.8        0.40 ± 21%  perf-profile.children.cycles-pp.btrfs_commit_transaction
      2.33 ±  6%      -0.7        1.67 ± 17%  perf-profile.children.cycles-pp.btree_csum_one_bio
      0.87 ±  8%      -0.6        0.25 ± 22%  perf-profile.children.cycles-pp.btrfs_finish_extent_commit
      0.86 ±  8%      -0.6        0.24 ± 23%  perf-profile.children.cycles-pp.unpin_extent_range
      0.86 ±  8%      -0.6        0.24 ± 23%  perf-profile.children.cycles-pp.__btrfs_add_free_space
      0.85 ±  8%      -0.6        0.24 ± 23%  perf-profile.children.cycles-pp.steal_from_bitmap
      2.02            -0.6        1.45 ± 18%  perf-profile.children.cycles-pp.btrfs_truncate_inode_items
      1.24 ±  5%      -0.6        0.68 ±  2%  perf-profile.children.cycles-pp._find_next_bit
      1.56            -0.5        1.07 ± 17%  perf-profile.children.cycles-pp.copy_page
      1.56            -0.5        1.07 ± 17%  perf-profile.children.cycles-pp.copy_extent_buffer_full
      1.68 ±  2%      -0.4        1.28 ± 23%  perf-profile.children.cycles-pp.do_mkdirat
      1.23 ±  8%      -0.4        0.86 ± 14%  perf-profile.children.cycles-pp.do_sys_openat2
      1.23 ±  8%      -0.4        0.86 ± 14%  perf-profile.children.cycles-pp.do_sys_open
      1.19 ±  8%      -0.4        0.83 ± 15%  perf-profile.children.cycles-pp.path_openat
      1.19 ±  8%      -0.4        0.84 ± 15%  perf-profile.children.cycles-pp.do_filp_open
      1.14 ±  5%      -0.4        0.79 ± 13%  perf-profile.children.cycles-pp.check_leaf
      1.01 ±  7%      -0.3        0.68 ± 13%  perf-profile.children.cycles-pp.start_ordered_ops
      1.01 ±  7%      -0.3        0.68 ± 13%  perf-profile.children.cycles-pp.btrfs_fdatawrite_range
      0.99 ±  6%      -0.3        0.67 ± 13%  perf-profile.children.cycles-pp.extent_writepages
      1.39 ±  4%      -0.3        1.07 ± 13%  perf-profile.children.cycles-pp.btrfs_insert_empty_items
      1.32            -0.3        1.01 ± 24%  perf-profile.children.cycles-pp.vfs_mkdir
      1.31            -0.3        1.00 ± 23%  perf-profile.children.cycles-pp.btrfs_mkdir
      1.14 ±  7%      -0.3        0.84 ± 20%  perf-profile.children.cycles-pp.btrfs_check_node
      1.40 ±  3%      -0.3        1.11 ±  8%  perf-profile.children.cycles-pp._raw_spin_lock
      1.30 ±  3%      -0.3        1.02 ± 21%  perf-profile.children.cycles-pp.copy_items
      1.04 ±  7%      -0.3        0.77 ± 19%  perf-profile.children.cycles-pp.read_extent_buffer
      0.67 ±  5%      -0.2        0.43 ± 23%  perf-profile.children.cycles-pp.btrfs_new_inode
      0.82 ±  7%      -0.2        0.59 ± 20%  perf-profile.children.cycles-pp.btrfs_add_link
      0.80 ±  8%      -0.2        0.58 ± 15%  perf-profile.children.cycles-pp.btrfs_create
      0.77 ±  7%      -0.2        0.55 ± 22%  perf-profile.children.cycles-pp.btrfs_insert_dir_item
      0.59 ±  9%      -0.2        0.41 ±  8%  perf-profile.children.cycles-pp.btrfs_submit_bio_hook
      0.75 ±  8%      -0.2        0.57 ± 14%  perf-profile.children.cycles-pp.btrfs_update_root
      0.65 ±  4%      -0.2        0.47 ± 18%  perf-profile.children.cycles-pp.btrfs_file_write_iter
      0.49 ±  5%      -0.2        0.31 ± 23%  perf-profile.children.cycles-pp.btrfs_commit_inode_delayed_items
      0.67 ±  5%      -0.2        0.48 ± 18%  perf-profile.children.cycles-pp.new_sync_write
      0.69 ±  5%      -0.2        0.51 ± 18%  perf-profile.children.cycles-pp.ksys_write
      0.69 ±  4%      -0.2        0.51 ± 17%  perf-profile.children.cycles-pp.vfs_write
      0.83 ±  4%      -0.2        0.66 ± 20%  perf-profile.children.cycles-pp.log_csums
      0.62 ±  7%      -0.2        0.46 ± 21%  perf-profile.children.cycles-pp.insert_with_overflow
      0.55 ±  7%      -0.2        0.39 ± 19%  perf-profile.children.cycles-pp.btrfs_buffered_write
      0.47 ±  9%      -0.2        0.32 ± 15%  perf-profile.children.cycles-pp.kmem_cache_alloc
      0.54 ±  3%      -0.1        0.40 ± 12%  perf-profile.children.cycles-pp.btrfs_get_32
      0.73 ±  8%      -0.1        0.58 ± 15%  perf-profile.children.cycles-pp.read_block_for_search
      0.39 ±  3%      -0.1        0.26 ± 20%  perf-profile.children.cycles-pp.extent_write_cache_pages
      0.59 ±  5%      -0.1        0.47 ± 14%  perf-profile.children.cycles-pp.setup_items_for_insert
      0.46 ±  3%      -0.1        0.33 ±  9%  perf-profile.children.cycles-pp.alloc_extent_buffer
      0.34 ±  4%      -0.1        0.22 ± 21%  perf-profile.children.cycles-pp.__extent_writepage
      0.47 ±  6%      -0.1        0.35 ± 23%  perf-profile.children.cycles-pp.__btrfs_btree_balance_dirty
      0.23 ±  8%      -0.1        0.12 ± 21%  perf-profile.children.cycles-pp.btrfs_write_and_wait_transaction
      0.46 ±  5%      -0.1        0.34 ± 13%  perf-profile.children.cycles-pp.generic_bin_search
      0.37 ± 11%      -0.1        0.26 ± 21%  perf-profile.children.cycles-pp.btrfs_get_64
      0.45 ±  7%      -0.1        0.34 ± 22%  perf-profile.children.cycles-pp.__percpu_counter_sum
      0.46 ±  6%      -0.1        0.35 ± 22%  perf-profile.children.cycles-pp.__percpu_counter_compare
      0.56 ±  8%      -0.1        0.46 ± 10%  perf-profile.children.cycles-pp.find_extent_buffer
      0.33 ±  4%      -0.1        0.23 ± 16%  perf-profile.children.cycles-pp.split_leaf
      0.34 ± 10%      -0.1        0.24 ±  7%  perf-profile.children.cycles-pp.pagecache_get_page
      0.29 ± 11%      -0.1        0.20 ± 13%  perf-profile.children.cycles-pp.__set_extent_bit
      0.27 ±  7%      -0.1        0.17 ± 23%  perf-profile.children.cycles-pp.writepage_delalloc
      0.28 ± 14%      -0.1        0.19 ± 24%  perf-profile.children.cycles-pp.btrfs_reserve_extent
      0.17 ± 17%      -0.1        0.09 ± 18%  perf-profile.children.cycles-pp.new_inode
      0.25 ± 10%      -0.1        0.16 ± 23%  perf-profile.children.cycles-pp.set_extent_bit
      0.17 ± 19%      -0.1        0.08 ± 24%  perf-profile.children.cycles-pp.new_inode_pseudo
      0.16 ± 18%      -0.1        0.08 ± 21%  perf-profile.children.cycles-pp.alloc_inode
      0.28 ±  9%      -0.1        0.20 ± 28%  perf-profile.children.cycles-pp.btrfs_check_ref_name_override
      0.20 ±  9%      -0.1        0.12 ± 17%  perf-profile.children.cycles-pp.btrfs_wait_ordered_range
      0.37 ±  2%      -0.1        0.29 ± 11%  perf-profile.children.cycles-pp.btrfs_mark_buffer_dirty
      0.21 ±  9%      -0.1        0.14 ± 16%  perf-profile.children.cycles-pp.btrfs_get_token_32
      0.23 ± 15%      -0.1        0.16 ± 25%  perf-profile.children.cycles-pp.find_free_extent
      0.23 ±  8%      -0.1        0.15 ± 24%  perf-profile.children.cycles-pp.btrfs_run_delalloc_range
      0.19 ± 21%      -0.1        0.12 ± 27%  perf-profile.children.cycles-pp.__slab_alloc
      0.14 ± 21%      -0.1        0.06 ± 20%  perf-profile.children.cycles-pp.btrfs_alloc_inode
      0.21 ±  4%      -0.1        0.14 ± 28%  perf-profile.children.cycles-pp.__test_set_page_writeback
      0.18 ± 22%      -0.1        0.11 ± 24%  perf-profile.children.cycles-pp.___slab_alloc
      0.17 ± 24%      -0.1        0.10 ± 33%  perf-profile.children.cycles-pp.allocate_slab
      0.17 ± 24%      -0.1        0.10 ± 33%  perf-profile.children.cycles-pp.new_slab
      0.22 ±  5%      -0.1        0.15 ± 24%  perf-profile.children.cycles-pp.cow_file_range
      0.27 ± 12%      -0.1        0.20 ± 13%  perf-profile.children.cycles-pp.__alloc_pages_nodemask
      0.19 ±  9%      -0.1        0.12 ± 20%  perf-profile.children.cycles-pp.check_extent_data_item
      0.16 ± 10%      -0.1        0.10 ± 18%  perf-profile.children.cycles-pp.btrfs_start_ordered_extent
      0.09 ± 19%      -0.1        0.03 ±102%  perf-profile.children.cycles-pp.add_to_page_cache_lru
      0.25 ±  7%      -0.1        0.19 ± 20%  perf-profile.children.cycles-pp.btrfs_lookup
      0.25 ±  7%      -0.1        0.19 ± 20%  perf-profile.children.cycles-pp.btrfs_lookup_dentry
      0.17 ±  7%      -0.1        0.11 ± 21%  perf-profile.children.cycles-pp.cpumask_next
      0.16 ±  4%      -0.1        0.10 ± 12%  perf-profile.children.cycles-pp.memzero_extent_buffer
      0.24 ± 11%      -0.1        0.18 ± 14%  perf-profile.children.cycles-pp.get_page_from_freelist
      0.26 ±  5%      -0.1        0.21 ±  5%  perf-profile.children.cycles-pp.end_bio_extent_writepage
      0.33 ±  3%      -0.1        0.27 ± 12%  perf-profile.children.cycles-pp.set_extent_buffer_dirty
      0.17 ± 12%      -0.1        0.11 ± 23%  perf-profile.children.cycles-pp.clear_page_dirty_for_io
      0.10 ± 12%      -0.1        0.05 ± 62%  perf-profile.children.cycles-pp.___might_sleep
      0.11 ± 17%      -0.1        0.06 ± 63%  perf-profile.children.cycles-pp.alloc_extent_state
      0.08 ± 10%      -0.1        0.03 ±100%  perf-profile.children.cycles-pp.__x64_sys_gettimeofday
      0.28 ±  4%      -0.1        0.23 ± 14%  perf-profile.children.cycles-pp.__set_page_dirty_nobuffers
      0.18 ± 15%      -0.1        0.13 ± 14%  perf-profile.children.cycles-pp.btrfs_search_forward
      0.14 ±  9%      -0.1        0.09 ± 12%  perf-profile.children.cycles-pp.push_leaf_right
      0.13 ± 10%      -0.0        0.08 ± 10%  perf-profile.children.cycles-pp.__clear_extent_bit
      0.10 ± 12%      -0.0        0.05 ± 59%  perf-profile.children.cycles-pp.fill_inode_item
      0.09 ±  8%      -0.0        0.05 ± 62%  perf-profile.children.cycles-pp.crc32c_pcl_intel_update
      0.11 ± 10%      -0.0        0.06 ± 58%  perf-profile.children.cycles-pp.__mod_lruvec_state
      0.09 ± 13%      -0.0        0.04 ± 58%  perf-profile.children.cycles-pp.check_inode_key
      0.07 ± 10%      -0.0        0.03 ±100%  perf-profile.children.cycles-pp.inode_tree_add
      0.07 ±  6%      -0.0        0.03 ±100%  perf-profile.children.cycles-pp.__extent_writepage_io
      0.15 ±  7%      -0.0        0.11 ± 15%  perf-profile.children.cycles-pp.btrfs_comp_cpu_keys
      0.23 ±  6%      -0.0        0.19 ±  7%  perf-profile.children.cycles-pp.end_extent_writepage
      0.23 ±  6%      -0.0        0.19 ±  7%  perf-profile.children.cycles-pp.btrfs_writepage_endio_finish_ordered
      0.17 ±  6%      -0.0        0.13 ± 15%  perf-profile.children.cycles-pp.btrfs_set_token_32
      0.07 ±  6%      -0.0        0.03 ±100%  perf-profile.children.cycles-pp.read
      0.08 ± 21%      -0.0        0.04 ± 63%  perf-profile.children.cycles-pp.copy_user_enhanced_fast_string
      0.59 ±  3%      -0.0        0.55 ±  2%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      0.07 ±  7%      -0.0        0.03 ±100%  perf-profile.children.cycles-pp.kernel_fpu_begin
      0.08 ± 15%      -0.0        0.04 ± 58%  perf-profile.children.cycles-pp.clear_extent_bit
      0.11 ± 10%      -0.0        0.07 ± 17%  perf-profile.children.cycles-pp.__push_leaf_right
      0.09 ± 19%      -0.0        0.05 ± 60%  perf-profile.children.cycles-pp.btrfs_free_path
      0.10 ± 12%      -0.0        0.07 ±  6%  perf-profile.children.cycles-pp.btrfs_read_node_slot
      0.09 ± 38%      -0.0        0.05 ±  8%  perf-profile.children.cycles-pp.drop_objectid_items
      0.09 ±  9%      -0.0        0.06 ± 14%  perf-profile.children.cycles-pp.read_tree_block
      0.09 ± 14%      -0.0        0.06 ± 17%  perf-profile.children.cycles-pp.btrfs_log_all_xattrs
      0.10 ±  5%      -0.0        0.07 ± 13%  perf-profile.children.cycles-pp.write_extent_buffer
      0.10 ± 21%      -0.0        0.07 ± 26%  perf-profile.children.cycles-pp.prepare_pages
      0.07 ± 19%      -0.0        0.04 ± 57%  perf-profile.children.cycles-pp.__xa_set_mark
      0.09 ±  7%      -0.0        0.07 ± 16%  perf-profile.children.cycles-pp.__vfs_getxattr
      0.12 ±  7%      -0.0        0.10 ± 11%  perf-profile.children.cycles-pp.clear_page_erms
      0.05 ±  9%      +0.0        0.08 ±  8%  perf-profile.children.cycles-pp.btrfs_block_rsv_release
      0.11 ±  7%      +0.0        0.14 ±  7%  perf-profile.children.cycles-pp.nr_iowait_cpu
      0.08 ± 21%      +0.0        0.11 ±  4%  perf-profile.children.cycles-pp.rcu_eqs_exit
      0.29 ±  7%      +0.0        0.32 ±  5%  perf-profile.children.cycles-pp.schedule
      0.15 ± 20%      +0.1        0.21 ± 19%  perf-profile.children.cycles-pp.start_transaction
      0.13 ± 17%      +0.1        0.20 ± 10%  perf-profile.children.cycles-pp.schedule_idle
      0.43 ±  6%      +0.1        0.52 ±  4%  perf-profile.children.cycles-pp.__sched_text_start
      0.86 ±  6%      +0.1        0.96 ±  2%  perf-profile.children.cycles-pp.perf_mux_hrtimer_handler
      0.23 ±  5%      +0.1        0.34 ± 15%  perf-profile.children.cycles-pp.__queue_work
      0.07 ± 10%      +0.1        0.18 ± 21%  perf-profile.children.cycles-pp.btrfs_use_block_rsv
      0.23 ±  4%      +0.2        0.39 ±  7%  perf-profile.children.cycles-pp.queue_work_on
      0.31 ±  5%      +0.2        0.47 ± 21%  perf-profile.children.cycles-pp.brd_lookup_page
      0.12 ± 33%      +0.2        0.31 ± 20%  perf-profile.children.cycles-pp.btrfs_reserve_metadata_bytes
      0.00            +0.2        0.23 ± 13%  perf-profile.children.cycles-pp.__btrfs_run_delayed_items
      0.13 ± 31%      +0.3        0.45 ± 17%  perf-profile.children.cycles-pp.flush_space
      0.13 ± 31%      +0.3        0.48 ± 17%  perf-profile.children.cycles-pp.btrfs_async_reclaim_metadata_space
      0.69 ±  8%      +1.0        1.73 ± 17%  perf-profile.children.cycles-pp.write_one_eb
      0.19 ± 14%      +1.2        1.39 ± 16%  perf-profile.children.cycles-pp.submit_extent_page
     80.22            +3.8       83.98 ±  2%  perf-profile.children.cycles-pp.secondary_startup_64
     80.22            +3.8       83.98 ±  2%  perf-profile.children.cycles-pp.cpu_startup_entry
     80.22            +3.8       83.98 ±  2%  perf-profile.children.cycles-pp.do_idle
      1.23 ±  5%      -0.6        0.67 ±  3%  perf-profile.self.cycles-pp._find_next_bit
      1.53 ±  2%      -0.5        1.04 ± 20%  perf-profile.self.cycles-pp.copy_page
      1.03 ±  6%      -0.3        0.76 ± 19%  perf-profile.self.cycles-pp.read_extent_buffer
      1.29 ±  3%      -0.2        1.08 ±  8%  perf-profile.self.cycles-pp._raw_spin_lock
      0.45 ±  3%      -0.1        0.30 ± 17%  perf-profile.self.cycles-pp.btrfs_get_32
      0.29 ±  8%      -0.1        0.19 ± 19%  perf-profile.self.cycles-pp.__percpu_counter_sum
      0.29 ± 14%      -0.1        0.19 ± 17%  perf-profile.self.cycles-pp.btrfs_get_64
      0.35 ±  9%      -0.1        0.27 ± 15%  perf-profile.self.cycles-pp.generic_bin_search
      0.23 ±  4%      -0.1        0.17 ± 26%  perf-profile.self.cycles-pp.__btrfs_cow_block
      0.18 ± 11%      -0.1        0.12 ± 15%  perf-profile.self.cycles-pp.btrfs_get_token_32
      0.16 ±  2%      -0.1        0.10 ± 12%  perf-profile.self.cycles-pp.memzero_extent_buffer
      0.10 ±  8%      -0.1        0.04 ± 59%  perf-profile.self.cycles-pp.___might_sleep
      0.17 ±  9%      -0.1        0.12 ± 24%  perf-profile.self.cycles-pp.check_leaf
      0.17 ± 12%      -0.0        0.12 ± 17%  perf-profile.self.cycles-pp.kmem_cache_alloc
      0.08 ± 21%      -0.0        0.04 ± 60%  perf-profile.self.cycles-pp.copy_user_enhanced_fast_string
      0.15 ±  7%      -0.0        0.11 ± 14%  perf-profile.self.cycles-pp.btrfs_comp_cpu_keys
      0.11 ± 11%      -0.0        0.08 ± 10%  perf-profile.self.cycles-pp.hrtimer_interrupt
      0.09 ±  7%      -0.0        0.07 ± 13%  perf-profile.self.cycles-pp.write_extent_buffer
      0.06 ±  6%      +0.0        0.08 ±  5%  perf-profile.self.cycles-pp.__sched_text_start
      0.11 ±  7%      +0.0        0.14 ±  8%  perf-profile.self.cycles-pp.nr_iowait_cpu
      0.00            +0.1        0.07 ± 11%  perf-profile.self.cycles-pp.btrfs_end_bio
      0.17 ±  4%      +0.1        0.27 ± 20%  perf-profile.self.cycles-pp.brd_lookup_page
     23336 ±  4%     +12.3%      26214 ±  2%  softirqs.CPU10.SCHED
     37060 ±  7%     +20.4%      44626 ±  3%  softirqs.CPU100.RCU
     72376 ±  4%     +14.2%      82628 ±  6%  softirqs.CPU100.TIMER
     38158 ±  6%     +15.8%      44173 ±  4%  softirqs.CPU101.RCU
     23419           +12.2%      26282 ±  3%  softirqs.CPU101.SCHED
     72977 ±  3%     +13.2%      82640 ±  6%  softirqs.CPU101.TIMER
     36452 ±  6%     +19.1%      43426 ±  5%  softirqs.CPU102.RCU
     22891           +14.4%      26190 ±  2%  softirqs.CPU102.SCHED
     71951 ±  3%     +14.9%      82691 ±  5%  softirqs.CPU102.TIMER
     36585 ±  7%     +18.9%      43489 ±  4%  softirqs.CPU103.RCU
     22931           +13.7%      26076 ±  3%  softirqs.CPU103.SCHED
     71487 ±  3%     +14.9%      82163 ±  6%  softirqs.CPU103.TIMER
     37494 ±  4%     +16.7%      43759 ±  4%  softirqs.CPU104.RCU
     72362 ±  4%     +12.6%      81512 ±  5%  softirqs.CPU104.TIMER
     36511 ±  7%     +20.3%      43910 ±  3%  softirqs.CPU105.RCU
     72600 ±  4%     +13.9%      82663 ±  6%  softirqs.CPU105.TIMER
     36685 ±  6%     +20.4%      44154 ±  4%  softirqs.CPU106.RCU
     22849 ±  2%     +14.1%      26063 ±  2%  softirqs.CPU106.SCHED
     71776 ±  3%     +14.4%      82085 ±  6%  softirqs.CPU106.TIMER
     37203 ±  6%     +18.7%      44163 ±  3%  softirqs.CPU107.RCU
     20913 ± 18%     +24.9%      26121 ±  3%  softirqs.CPU107.SCHED
     71859 ±  4%     +15.2%      82784 ±  6%  softirqs.CPU107.TIMER
     36749 ±  5%     +18.5%      43545 ±  6%  softirqs.CPU108.RCU
     22983           +13.3%      26051 ±  3%  softirqs.CPU108.SCHED
     71500 ±  3%     +16.2%      83050 ±  7%  softirqs.CPU108.TIMER
     37174 ±  3%     +18.0%      43869 ±  3%  softirqs.CPU109.RCU
     71426 ±  4%     +15.6%      82585 ±  6%  softirqs.CPU109.TIMER
     38693 ±  8%     +18.2%      45720        softirqs.CPU11.RCU
     22879           +11.8%      25589        softirqs.CPU11.SCHED
     36400 ±  8%     +21.7%      44307 ±  3%  softirqs.CPU110.RCU
     23017           +14.3%      26311 ±  3%  softirqs.CPU110.SCHED
     71941 ±  4%     +15.1%      82776 ±  6%  softirqs.CPU110.TIMER
     36644 ±  7%     +18.6%      43477 ±  4%  softirqs.CPU111.RCU
     22935           +13.3%      25995 ±  2%  softirqs.CPU111.SCHED
     71704 ±  4%     +14.8%      82352 ±  5%  softirqs.CPU111.TIMER
     34791 ±  7%     +19.1%      41428 ±  3%  softirqs.CPU112.RCU
     22931           +13.7%      26072 ±  3%  softirqs.CPU112.SCHED
     71843 ±  4%     +14.2%      82016 ±  6%  softirqs.CPU112.TIMER
     35167 ±  6%     +17.6%      41349 ±  3%  softirqs.CPU113.RCU
     23073 ±  2%     +12.9%      26057 ±  3%  softirqs.CPU113.SCHED
     36049 ±  5%     +19.2%      42957        softirqs.CPU114.RCU
     20819 ± 18%     +26.7%      26374 ±  2%  softirqs.CPU114.SCHED
     71628 ±  4%     +15.8%      82917 ±  6%  softirqs.CPU114.TIMER
     34911 ±  7%     +21.0%      42248 ±  2%  softirqs.CPU115.RCU
     70742 ±  5%     +15.8%      81922 ±  5%  softirqs.CPU115.TIMER
     35469 ±  6%     +18.9%      42188        softirqs.CPU116.RCU
     23098           +12.9%      26082 ±  2%  softirqs.CPU116.SCHED
     36436 ±  3%     +13.3%      41297 ±  3%  softirqs.CPU117.RCU
     20572 ± 18%     +29.1%      26559        softirqs.CPU117.SCHED
     72220 ±  3%     +24.7%      90085 ±  8%  softirqs.CPU117.TIMER
     35180 ±  6%     +18.7%      41774 ±  2%  softirqs.CPU118.RCU
     22950 ±  2%     +13.7%      26085 ±  3%  softirqs.CPU118.SCHED
     72136 ±  4%     +13.7%      82032 ±  6%  softirqs.CPU118.TIMER
     34925 ±  6%     +21.6%      42479 ±  5%  softirqs.CPU119.RCU
     22776 ±  2%     +13.7%      25902 ±  2%  softirqs.CPU119.SCHED
     71796 ±  4%     +14.2%      82002 ±  6%  softirqs.CPU119.TIMER
     38918 ±  9%     +17.0%      45550        softirqs.CPU12.RCU
     22765           +13.3%      25791 ±  3%  softirqs.CPU12.SCHED
     36632 ±  4%     +15.0%      42126 ±  2%  softirqs.CPU121.RCU
     23637 ±  3%     +10.9%      26208 ±  2%  softirqs.CPU121.SCHED
     36278 ±  4%     +17.1%      42476 ±  3%  softirqs.CPU122.RCU
     23705            +9.9%      26063 ±  2%  softirqs.CPU122.SCHED
     36158 ±  4%     +14.5%      41387 ±  3%  softirqs.CPU123.RCU
     23593 ±  2%     +10.5%      26059 ±  2%  softirqs.CPU123.SCHED
     36018 ±  4%     +14.9%      41372 ±  3%  softirqs.CPU124.RCU
     21282 ± 20%     +22.4%      26043 ±  2%  softirqs.CPU124.SCHED
     35677 ±  4%     +16.5%      41581 ±  3%  softirqs.CPU125.RCU
     21802 ± 16%     +19.9%      26146 ±  2%  softirqs.CPU125.SCHED
     35555 ±  5%     +17.9%      41903 ±  3%  softirqs.CPU126.RCU
     23628           +10.1%      26006 ±  2%  softirqs.CPU126.SCHED
     35465 ±  4%     +15.4%      40937 ±  5%  softirqs.CPU127.RCU
     23621           +10.8%      26167 ±  2%  softirqs.CPU127.SCHED
     37576 ±  4%     +15.8%      43504 ±  4%  softirqs.CPU128.RCU
     23632           +10.7%      26157 ±  2%  softirqs.CPU128.SCHED
     37710 ±  3%     +14.6%      43203 ±  3%  softirqs.CPU129.RCU
     23662           +10.6%      26178 ±  2%  softirqs.CPU129.SCHED
     39596 ±  7%     +16.8%      46237        softirqs.CPU13.RCU
     22709           +12.1%      25461 ±  2%  softirqs.CPU13.SCHED
     37673 ±  5%     +14.4%      43105 ±  4%  softirqs.CPU130.RCU
     23669            +9.0%      25800 ±  3%  softirqs.CPU130.SCHED
     37396 ±  5%     +15.8%      43323 ±  4%  softirqs.CPU131.RCU
     23551 ±  2%     +10.5%      26027 ±  2%  softirqs.CPU131.SCHED
     37645 ±  3%     +13.6%      42781 ±  4%  softirqs.CPU132.RCU
     23679            +9.6%      25963 ±  2%  softirqs.CPU132.SCHED
     36737 ±  4%     +16.3%      42734 ±  4%  softirqs.CPU133.RCU
     23518 ±  2%     +11.0%      26110 ±  2%  softirqs.CPU133.SCHED
     36985 ±  4%     +18.8%      43939 ±  2%  softirqs.CPU134.RCU
     23471 ±  2%     +11.7%      26218 ±  2%  softirqs.CPU134.SCHED
     37888 ±  2%     +15.1%      43606 ±  4%  softirqs.CPU135.RCU
     23588           +10.3%      26025 ±  2%  softirqs.CPU135.SCHED
     37660 ±  5%     +15.2%      43382 ±  4%  softirqs.CPU136.RCU
     23541 ±  2%     +10.6%      26031 ±  2%  softirqs.CPU136.SCHED
     37788 ±  5%     +16.7%      44099 ±  4%  softirqs.CPU137.RCU
     23576 ±  2%     +10.6%      26085 ±  2%  softirqs.CPU137.SCHED
     37342 ±  5%     +15.9%      43284 ±  4%  softirqs.CPU138.RCU
     23612 ±  2%     +10.5%      26099 ±  2%  softirqs.CPU138.SCHED
     37334 ±  4%     +15.6%      43160        softirqs.CPU139.RCU
     23611 ±  2%     +10.9%      26196 ±  2%  softirqs.CPU139.SCHED
     39043 ± 10%     +16.0%      45285        softirqs.CPU14.RCU
     22623           +12.7%      25501        softirqs.CPU14.SCHED
     37910 ±  3%     +15.6%      43818 ±  3%  softirqs.CPU140.RCU
     23741            +9.9%      26096 ±  2%  softirqs.CPU140.SCHED
     37385 ±  5%     +15.9%      43314 ±  2%  softirqs.CPU141.RCU
     23644           +10.2%      26055 ±  2%  softirqs.CPU141.SCHED
     37687 ±  4%     +14.7%      43214 ±  2%  softirqs.CPU142.RCU
     23584           +10.9%      26146 ±  2%  softirqs.CPU142.SCHED
     37464 ±  4%     +15.4%      43242 ±  3%  softirqs.CPU143.RCU
     23566 ±  2%     +10.3%      25996 ±  2%  softirqs.CPU143.SCHED
     40618 ±  5%     +11.8%      45399 ±  3%  softirqs.CPU144.RCU
     38922           +14.9%      44714 ±  3%  softirqs.CPU145.RCU
     23349 ±  2%     +12.8%      26328 ±  3%  softirqs.CPU145.SCHED
     37845 ±  4%     +18.6%      44899 ±  3%  softirqs.CPU146.RCU
     37671 ±  3%     +15.5%      43498 ±  6%  softirqs.CPU147.RCU
     22851 ±  5%     +14.4%      26151 ±  3%  softirqs.CPU147.SCHED
     37970 ±  2%     +15.0%      43682 ±  5%  softirqs.CPU148.RCU
     23319 ±  2%     +12.3%      26190 ±  3%  softirqs.CPU148.SCHED
     37415 ±  5%     +17.2%      43849 ±  6%  softirqs.CPU149.RCU
     20611 ± 18%     +26.8%      26135 ±  3%  softirqs.CPU149.SCHED
     37987 ±  9%     +19.2%      45267        softirqs.CPU15.RCU
     22407           +13.9%      25527        softirqs.CPU15.SCHED
     37807 ±  4%     +14.6%      43309 ±  6%  softirqs.CPU150.RCU
     23166 ±  3%     +12.2%      26004 ±  3%  softirqs.CPU150.SCHED
     39077 ±  7%     +14.0%      44559 ±  6%  softirqs.CPU151.RCU
     23259 ±  3%     +12.5%      26171 ±  3%  softirqs.CPU151.SCHED
     38494 ±  2%     +15.8%      44559 ±  5%  softirqs.CPU152.RCU
     23514 ±  3%     +11.7%      26263 ±  2%  softirqs.CPU152.SCHED
     38100 ±  2%     +16.3%      44296 ±  4%  softirqs.CPU153.RCU
     23340 ±  3%     +12.4%      26244 ±  2%  softirqs.CPU153.SCHED
     37440 ±  5%     +17.5%      43999 ±  6%  softirqs.CPU154.RCU
     19448 ± 30%     +34.6%      26179 ±  2%  softirqs.CPU154.SCHED
     38227 ±  3%     +15.3%      44062 ±  5%  softirqs.CPU155.RCU
     23320 ±  3%     +12.4%      26201 ±  3%  softirqs.CPU155.SCHED
     37553 ±  5%     +18.3%      44424 ±  5%  softirqs.CPU156.RCU
     23197 ±  2%     +13.1%      26244 ±  2%  softirqs.CPU156.SCHED
     37353 ±  5%     +20.4%      44987 ±  4%  softirqs.CPU157.RCU
     23166 ±  2%     +13.8%      26353        softirqs.CPU157.SCHED
     37654 ±  4%     +17.4%      44190 ±  6%  softirqs.CPU158.RCU
     23158 ±  3%     +13.3%      26250 ±  2%  softirqs.CPU158.SCHED
     38038 ±  2%     +16.8%      44436 ±  4%  softirqs.CPU159.RCU
     23278 ±  2%     +12.9%      26277 ±  2%  softirqs.CPU159.SCHED
     37825 ±  5%     +17.2%      44334 ±  4%  softirqs.CPU16.RCU
     22657 ±  2%     +12.3%      25436        softirqs.CPU16.SCHED
     37508 ±  6%     +16.2%      43574 ±  7%  softirqs.CPU160.RCU
     23213 ±  3%     +12.7%      26153 ±  2%  softirqs.CPU160.SCHED
     38423 ±  2%     +13.1%      43467 ±  7%  softirqs.CPU161.RCU
     23571 ±  3%     +11.0%      26162 ±  2%  softirqs.CPU161.SCHED
     37438 ±  4%     +15.3%      43184 ±  8%  softirqs.CPU162.RCU
     23250 ±  3%     +11.8%      25986 ±  3%  softirqs.CPU162.SCHED
     37704 ±  4%     +15.9%      43713 ±  5%  softirqs.CPU163.RCU
     23230 ±  2%     +12.8%      26202 ±  2%  softirqs.CPU163.SCHED
     37535 ±  5%     +16.0%      43549 ±  6%  softirqs.CPU164.RCU
     37824 ±  5%     +16.0%      43879 ±  6%  softirqs.CPU165.RCU
     23221 ±  2%     +13.1%      26261 ±  2%  softirqs.CPU165.SCHED
     37490 ±  5%     +15.9%      43458 ±  7%  softirqs.CPU166.RCU
     23155 ±  3%     +13.3%      26223 ±  2%  softirqs.CPU166.SCHED
     37588 ±  6%     +15.1%      43267 ±  7%  softirqs.CPU167.RCU
     23221 ±  3%     +12.7%      26170 ±  2%  softirqs.CPU167.SCHED
     35517 ±  2%     +22.4%      43476 ±  5%  softirqs.CPU168.RCU
     23310 ±  2%     +16.1%      27051        softirqs.CPU168.SCHED
     76093 ±  8%     +13.8%      86580        softirqs.CPU168.TIMER
     35691           +18.6%      42316 ±  3%  softirqs.CPU169.RCU
     23288 ±  2%     +15.2%      26818        softirqs.CPU169.SCHED
     76751 ±  8%     +13.0%      86714 ±  2%  softirqs.CPU169.TIMER
     37125 ±  7%     +19.9%      44524 ±  4%  softirqs.CPU17.RCU
     22629           +12.0%      25345        softirqs.CPU17.SCHED
     35606 ±  2%     +17.0%      41656 ±  3%  softirqs.CPU170.RCU
     23461 ±  2%     +13.3%      26582        softirqs.CPU170.SCHED
     35976           +16.4%      41875 ±  3%  softirqs.CPU171.RCU
     23419 ±  2%     +14.1%      26718        softirqs.CPU171.SCHED
     35525 ±  2%     +17.7%      41829 ±  3%  softirqs.CPU172.RCU
     23331 ±  2%     +13.8%      26555        softirqs.CPU172.SCHED
     35040 ±  2%     +17.2%      41052 ±  5%  softirqs.CPU173.RCU
     23809 ±  2%     +11.0%      26433 ±  2%  softirqs.CPU173.SCHED
     35464 ±  2%     +16.0%      41153 ±  4%  softirqs.CPU174.RCU
     23458 ±  3%     +12.6%      26412        softirqs.CPU174.SCHED
     35984 ±  3%     +13.7%      40924 ±  5%  softirqs.CPU175.RCU
     23623 ±  2%     +11.5%      26343 ±  2%  softirqs.CPU175.SCHED
     23485 ±  2%     +12.5%      26417 ±  2%  softirqs.CPU176.SCHED
     37325           +13.8%      42467 ±  6%  softirqs.CPU177.RCU
     23422 ±  2%     +13.0%      26459 ±  2%  softirqs.CPU177.SCHED
     37252           +15.8%      43134 ±  5%  softirqs.CPU178.RCU
     23362 ±  2%     +13.4%      26497        softirqs.CPU178.SCHED
     23398 ±  2%     +13.0%      26438 ±  2%  softirqs.CPU179.SCHED
     77017 ±  9%     +11.9%      86217 ±  2%  softirqs.CPU179.TIMER
     38417 ±  6%     +16.0%      44570 ±  4%  softirqs.CPU18.RCU
     22927 ±  3%     +11.1%      25465        softirqs.CPU18.SCHED
     37203           +14.4%      42565 ±  6%  softirqs.CPU180.RCU
     23461 ±  2%     +13.1%      26536        softirqs.CPU180.SCHED
     36948           +16.0%      42862 ±  4%  softirqs.CPU181.RCU
     20978 ± 20%     +26.3%      26496        softirqs.CPU181.SCHED
     76051 ±  8%     +15.5%      87850 ±  2%  softirqs.CPU181.TIMER
     37023           +15.8%      42889 ±  4%  softirqs.CPU182.RCU
     23354 ±  2%     +13.8%      26573        softirqs.CPU182.SCHED
     37052           +15.3%      42710 ±  5%  softirqs.CPU183.RCU
     23340 ±  2%     +13.2%      26425 ±  2%  softirqs.CPU183.SCHED
     37500 ±  2%     +15.3%      43245 ±  4%  softirqs.CPU184.RCU
     23303 ±  2%     +13.9%      26547        softirqs.CPU184.SCHED
     37722 ±  2%     +14.2%      43089 ±  5%  softirqs.CPU185.RCU
     23411 ±  2%     +12.8%      26415 ±  2%  softirqs.CPU185.SCHED
     37432 ±  3%     +13.4%      42436 ±  5%  softirqs.CPU186.RCU
     23261 ±  2%     +13.8%      26466        softirqs.CPU186.SCHED
     37440 ±  2%     +16.2%      43509 ±  7%  softirqs.CPU187.RCU
     23350 ±  2%     +13.5%      26513        softirqs.CPU187.SCHED
     77139 ±  8%     +12.4%      86739        softirqs.CPU187.TIMER
     37036           +15.5%      42762 ±  5%  softirqs.CPU188.RCU
     23398 ±  2%     +13.2%      26478 ±  2%  softirqs.CPU188.SCHED
     37092           +15.5%      42852 ±  6%  softirqs.CPU189.RCU
     23406 ±  2%     +13.5%      26562 ±  2%  softirqs.CPU189.SCHED
     76788 ±  9%     +13.0%      86780 ±  2%  softirqs.CPU189.TIMER
     37797 ±  6%     +20.8%      45658 ±  4%  softirqs.CPU19.RCU
     37235           +17.3%      43659 ±  8%  softirqs.CPU190.RCU
     23416 ±  2%     +13.1%      26484 ±  2%  softirqs.CPU190.SCHED
     76806 ±  9%     +12.9%      86678        softirqs.CPU190.TIMER
     37436           +15.0%      43044 ±  6%  softirqs.CPU191.RCU
     23377 ±  2%     +12.9%      26404 ±  2%  softirqs.CPU191.SCHED
     76873 ±  8%     +13.1%      86951        softirqs.CPU191.TIMER
     24154 ±  4%     +11.6%      26960 ±  5%  softirqs.CPU2.SCHED
     37715 ±  4%     +18.5%      44682 ±  4%  softirqs.CPU20.RCU
     37334 ±  7%     +20.6%      45015 ±  3%  softirqs.CPU21.RCU
     22774           +12.6%      25636 ±  2%  softirqs.CPU21.SCHED
     37209 ±  7%     +18.6%      44117 ±  3%  softirqs.CPU22.RCU
     22842           +11.1%      25385        softirqs.CPU22.SCHED
     36989 ±  8%     +20.4%      44542 ±  3%  softirqs.CPU23.RCU
     22408           +13.4%      25414 ±  2%  softirqs.CPU23.SCHED
     38552 ±  7%     +16.4%      44873 ±  4%  softirqs.CPU27.RCU
     38113 ±  5%     +16.2%      44294 ±  4%  softirqs.CPU28.RCU
     36818 ±  4%     +21.1%      44594 ±  3%  softirqs.CPU29.RCU
     21560 ± 21%     +21.5%      26203 ±  4%  softirqs.CPU3.SCHED
     37247 ±  4%     +18.8%      44250 ±  4%  softirqs.CPU30.RCU
     37095 ±  4%     +17.3%      43501 ±  8%  softirqs.CPU31.RCU
     23029 ±  2%     +12.5%      25914 ±  2%  softirqs.CPU31.SCHED
     41431 ±  3%     +14.9%      47594 ±  2%  softirqs.CPU32.RCU
     39993           +19.4%      47763        softirqs.CPU33.RCU
     40773 ±  2%     +15.9%      47242        softirqs.CPU34.RCU
     40747 ±  2%     +16.5%      47480        softirqs.CPU35.RCU
     41402           +15.3%      47742        softirqs.CPU36.RCU
     41868 ±  3%     +14.4%      47901        softirqs.CPU37.RCU
     40723           +17.7%      47935        softirqs.CPU38.RCU
     41219 ±  2%     +15.3%      47544        softirqs.CPU39.RCU
     41121 ±  4%     +10.4%      45417        softirqs.CPU4.RCU
     23445 ±  4%      +9.5%      25678        softirqs.CPU4.SCHED
     40413           +17.1%      47316        softirqs.CPU40.RCU
     40777 ±  2%     +17.0%      47714        softirqs.CPU41.RCU
     41548 ±  2%     +15.2%      47866        softirqs.CPU42.RCU
     41292           +16.0%      47893        softirqs.CPU43.RCU
     41525 ±  3%     +13.3%      47055        softirqs.CPU44.RCU
     40733 ±  2%     +15.7%      47132        softirqs.CPU45.RCU
     40454           +17.5%      47527        softirqs.CPU46.RCU
     40582           +15.7%      46961        softirqs.CPU47.RCU
     74808 ±  6%      +7.6%      80484 ±  4%  softirqs.CPU48.TIMER
     39358 ±  8%     +17.4%      46210        softirqs.CPU5.RCU
     22888 ±  2%     +11.7%      25577 ±  2%  softirqs.CPU5.SCHED
     42157 ±  4%     +19.9%      50540 ± 11%  softirqs.CPU50.RCU
     42221 ±  4%     +15.0%      48568 ±  4%  softirqs.CPU51.RCU
     41570 ±  2%     +16.5%      48416 ±  2%  softirqs.CPU52.RCU
     23013 ±  2%     +11.5%      25653 ±  2%  softirqs.CPU52.SCHED
     41498           +16.0%      48155 ±  2%  softirqs.CPU53.RCU
     22925 ±  2%     +11.5%      25566        softirqs.CPU53.SCHED
     40689 ±  2%     +20.3%      48965 ±  5%  softirqs.CPU54.RCU
     22868 ±  2%     +12.8%      25793 ±  2%  softirqs.CPU54.SCHED
     40553           +18.6%      48079 ±  2%  softirqs.CPU55.RCU
     22865 ±  2%     +12.1%      25628 ±  2%  softirqs.CPU55.SCHED
     40568           +19.2%      48339 ±  3%  softirqs.CPU56.RCU
     22890 ±  2%     +12.3%      25697        softirqs.CPU56.SCHED
     41044           +16.8%      47944 ±  2%  softirqs.CPU57.RCU
     22986 ±  2%     +11.2%      25565        softirqs.CPU57.SCHED
     40776           +19.7%      48815        softirqs.CPU58.RCU
     22916 ±  2%     +11.5%      25559        softirqs.CPU58.SCHED
     41186           +17.6%      48451 ±  2%  softirqs.CPU59.RCU
     22939 ±  2%     +11.5%      25583        softirqs.CPU59.SCHED
     38904 ±  8%     +19.0%      46315        softirqs.CPU6.RCU
     22878 ±  2%     +11.7%      25564 ±  3%  softirqs.CPU6.SCHED
     39689           +19.8%      47555 ±  2%  softirqs.CPU60.RCU
     22936 ±  2%     +11.5%      25585        softirqs.CPU60.SCHED
     40190           +18.9%      47783 ±  2%  softirqs.CPU61.RCU
     40331           +18.5%      47778 ±  2%  softirqs.CPU62.RCU
     22847 ±  2%     +11.9%      25561        softirqs.CPU62.SCHED
     40616           +18.2%      48015 ±  2%  softirqs.CPU63.RCU
     22895 ±  2%     +12.1%      25668        softirqs.CPU63.SCHED
     39812 ±  2%     +15.3%      45906 ±  3%  softirqs.CPU64.RCU
     22938 ±  2%     +11.6%      25605        softirqs.CPU64.SCHED
     40162 ±  3%     +15.6%      46409 ±  4%  softirqs.CPU65.RCU
     22949 ±  2%     +11.3%      25536        softirqs.CPU65.SCHED
     39068 ±  5%     +17.0%      45717 ±  4%  softirqs.CPU66.RCU
     22966 ±  2%     +12.0%      25732 ±  2%  softirqs.CPU66.SCHED
     39653 ±  3%     +17.2%      46480 ±  3%  softirqs.CPU67.RCU
     22857 ±  2%     +12.6%      25739 ±  2%  softirqs.CPU67.SCHED
     39752 ±  2%     +15.2%      45788 ±  3%  softirqs.CPU68.RCU
     22960 ±  2%     +11.4%      25582        softirqs.CPU68.SCHED
     40083           +14.3%      45820 ±  3%  softirqs.CPU69.RCU
     23027 ±  2%     +11.1%      25587        softirqs.CPU69.SCHED
     39790 ± 12%     +19.6%      47584 ±  2%  softirqs.CPU7.RCU
     39400 ±  4%     +18.4%      46646 ±  3%  softirqs.CPU70.RCU
     22875 ±  2%     +12.5%      25729        softirqs.CPU70.SCHED
     40221 ±  3%     +15.2%      46339 ±  3%  softirqs.CPU71.RCU
     23196 ±  2%     +10.3%      25579        softirqs.CPU71.SCHED
     38088 ±  2%    +104.1%      77745 ± 74%  softirqs.CPU72.RCU
     22775 ±  2%     +43.9%      32770 ± 39%  softirqs.CPU72.SCHED
     37394 ±  2%     +33.9%      50070 ± 21%  softirqs.CPU73.RCU
     22540 ±  2%     +20.3%      27124 ± 10%  softirqs.CPU73.SCHED
     37147 ±  2%     +20.5%      44764 ±  3%  softirqs.CPU74.RCU
     22567 ±  3%     +14.8%      25902 ±  3%  softirqs.CPU74.SCHED
     37254 ±  3%     +18.5%      44164 ±  2%  softirqs.CPU75.RCU
     22518 ±  2%     +14.7%      25838 ±  3%  softirqs.CPU75.SCHED
     37196 ±  2%     +16.9%      43495 ±  2%  softirqs.CPU76.RCU
     22474 ±  2%     +13.9%      25605        softirqs.CPU76.SCHED
     37634 ±  3%     +15.1%      43319 ±  3%  softirqs.CPU77.RCU
     20355 ± 19%     +25.2%      25491        softirqs.CPU77.SCHED
     37561 ±  2%     +15.6%      43428 ±  3%  softirqs.CPU78.RCU
     37383 ±  3%     +17.5%      43937        softirqs.CPU79.RCU
     22520 ±  2%     +13.6%      25577        softirqs.CPU79.SCHED
     38851 ±  8%     +17.7%      45730        softirqs.CPU8.RCU
     22688           +12.5%      25532        softirqs.CPU8.SCHED
     38049           +16.3%      44269 ±  3%  softirqs.CPU80.RCU
     22511 ±  2%     +14.0%      25651        softirqs.CPU80.SCHED
     38445           +16.3%      44698 ±  2%  softirqs.CPU81.RCU
     22534 ±  2%     +13.7%      25626        softirqs.CPU81.SCHED
     38367           +18.0%      45261        softirqs.CPU82.RCU
     22543 ±  2%     +13.6%      25608        softirqs.CPU82.SCHED
     38628           +16.9%      45158 ±  2%  softirqs.CPU83.RCU
     22497 ±  2%     +13.2%      25462        softirqs.CPU83.SCHED
     38136           +18.2%      45067        softirqs.CPU84.RCU
     22189 ±  3%     +15.8%      25692        softirqs.CPU84.SCHED
     38459           +16.2%      44671 ±  3%  softirqs.CPU85.RCU
     22578 ±  2%     +13.3%      25572        softirqs.CPU85.SCHED
     38472 ±  2%     +15.5%      44432 ±  3%  softirqs.CPU86.RCU
     22668 ±  2%     +12.5%      25512        softirqs.CPU86.SCHED
     38427           +15.8%      44517 ±  2%  softirqs.CPU87.RCU
     22511 ±  2%     +13.0%      25431        softirqs.CPU87.SCHED
     38795 ±  2%     +15.9%      44976        softirqs.CPU88.RCU
     22446 ±  2%     +14.2%      25629        softirqs.CPU88.SCHED
     39034           +17.1%      45723        softirqs.CPU89.RCU
     22422 ±  2%     +14.0%      25569        softirqs.CPU89.SCHED
     39295 ±  5%     +16.6%      45827 ±  2%  softirqs.CPU9.RCU
     22890 ±  2%     +11.4%      25508        softirqs.CPU9.SCHED
     38748           +17.1%      45365        softirqs.CPU90.RCU
     22384 ±  2%     +15.4%      25822        softirqs.CPU90.SCHED
     38370           +16.7%      44793        softirqs.CPU91.RCU
     22412 ±  2%     +13.7%      25493        softirqs.CPU91.SCHED
     38256           +16.0%      44386 ±  2%  softirqs.CPU92.RCU
     22484 ±  2%     +13.5%      25510        softirqs.CPU92.SCHED
     38592 ±  2%     +15.2%      44446 ±  3%  softirqs.CPU93.RCU
     22485 ±  2%     +12.9%      25388        softirqs.CPU93.SCHED
     38636           +15.8%      44729 ±  3%  softirqs.CPU94.RCU
     22631 ±  2%     +12.4%      25427        softirqs.CPU94.SCHED
     39104           +14.7%      44866 ±  5%  softirqs.CPU95.RCU
     39894 ±  3%     +13.4%      45224 ±  5%  softirqs.CPU96.RCU
     39210 ±  2%     +15.8%      45419 ±  5%  softirqs.CPU97.RCU
     23501 ±  3%     +12.9%      26539 ±  3%  softirqs.CPU97.SCHED
     70819 ±  4%     +15.5%      81767 ±  5%  softirqs.CPU97.TIMER
     37452 ±  3%     +17.9%      44143 ±  2%  softirqs.CPU98.RCU
     23119 ±  2%     +13.6%      26253 ±  3%  softirqs.CPU98.SCHED
     71306 ±  2%     +15.7%      82467 ±  6%  softirqs.CPU98.TIMER
     37239 ±  4%     +17.6%      43794 ±  2%  softirqs.CPU99.RCU
     23219 ±  2%     +12.8%      26190 ±  2%  softirqs.CPU99.SCHED
     72423 ±  3%     +13.9%      82474 ±  6%  softirqs.CPU99.TIMER
   7528698           +16.2%    8745025        softirqs.RCU
   4441833           +11.8%    4964631        softirqs.SCHED
  14417750 ±  4%      +9.3%   15759607        softirqs.TIMER


                                                                                
                              fsmark.time.system_time                           
                                                                                
  180 +---------------------------------------------------------------------+   
      | O         O O O  O                               O                  |   
  175 |-+  O O O             O  O   O  O O O  O      O O                    |   
      |                                                                     |   
  170 |-+                         O             O O                         |   
      |                                                                     |   
  165 |-+                                                                   |   
      |                                                                     |   
  160 |-+                                                                   |   
      |                                                                     |   
  155 |-+           +        +..                                            |   
      | +..+.+.    + +      :   +.+.+..+.+.  .+.+.+.. .+.  .+.+.         .+.|   
  150 |++      +..+   +..+. :              +.        +   +.     +..+.+.+.   |   
      |                    +                                                |   
  145 +---------------------------------------------------------------------+   
                                                                                
                                                                                                                                                                
                             fsmark.time.elapsed_time                           
                                                                                
  200 +---------------------------------------------------------------------+   
      |                    O                                                |   
  195 |-+         O                                                         |   
  190 |-O    O O      O  O   O                O          O                  |   
      |    O        O           O   O  O O O         O O                    |   
  185 |-+                                       O O                         |   
      |                           O                                         |   
  180 |-+                                                                   |   
      |                                                                     |   
  175 |-+                                                                   |   
  170 |-+                                                                   |   
      | +..         +        +..                                            |   
  165 |:+  +.+.+.. + +  .+  :   +.+.+..+.+.  .+.+.+..+.+.  .+.+.  .+. .+..+.|   
      |:          +   +.  + :              +.            +.     +.   +      |   
  160 +---------------------------------------------------------------------+   
                                                                                
                                                                                                                                                                
                           fsmark.time.elapsed_time.max                         
                                                                                
  200 +---------------------------------------------------------------------+   
      |                    O                                                |   
  195 |-+         O                                                         |   
  190 |-O    O O      O  O   O                O          O                  |   
      |    O        O           O   O  O O O         O O                    |   
  185 |-+                                       O O                         |   
      |                           O                                         |   
  180 |-+                                                                   |   
      |                                                                     |   
  175 |-+                                                                   |   
  170 |-+                                                                   |   
      | +..         +        +..                                            |   
  165 |:+  +.+.+.. + +  .+  :   +.+.+..+.+.  .+.+.+..+.+.  .+.+.  .+. .+..+.|   
      |:          +   +.  + :              +.            +.     +.   +      |   
  160 +---------------------------------------------------------------------+   
                                                                                
                                                                                                                                                                
                        fsmark.time.voluntary_context_switches                  
                                                                                
   1.3e+06 +----------------------------------------------------------------+   
           | O    O O          O O                                          |   
  1.28e+06 |-+ O      O O            O O O  O O   O O    O O                |   
  1.26e+06 |-+            O O      O            O     O                     |   
           |                                                                |   
  1.24e+06 |-+                                                              |   
           |                                                                |   
  1.22e+06 |-+                                                              |   
           |                                                                |   
   1.2e+06 |-+                                                              |   
  1.18e+06 |-+                                                              |   
           |                                                                |   
  1.16e+06 |-+                                      +.                      |   
           |.+.+..+. .+.+. .+..+.+.+.+.+.+..+. .+. +  +..+.+.+.+.+.+.. .+.+.|   
  1.14e+06 +----------------------------------------------------------------+   
                                                                                
                                                                                                                                                                
                               fsmark.files_per_sec                             
                                                                                
  6600 +--------------------------------------------------------------------+   
       |:                                                                   |   
  6400 |:+        .+   +.  .+.             .+.        .+..+.    .+.+.+.+..  |   
       | +..+.+.+.  + +  +.   +.+..+.+.+..+   +.+..+.+      +.+.          +.|   
  6200 |-+           +                                                      |   
       |                                                                    |   
  6000 |-+                                                                  |   
       |                                                                    |   
  5800 |-+                                                                  |   
       |                                                                    |   
  5600 |-+                         O                                        |   
       |    O O O    O        O O    O O  O O O O  O O O                    |   
  5400 |-O         O   O O                                O                 |   
       |                    O                                               |   
  5200 +--------------------------------------------------------------------+   
                                                                                
                                                                                
[*] bisect-good sample
[O] bisect-bad  sample

***************************************************************************************************
lkp-csl-2ap1: 192 threads Intel(R) Xeon(R) CPU @ 2.20GHz with 192G memory
=========================================================================================
bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase/ucode:
  4k/gcc-9/performance/1SSD/btrfs/sync/x86_64-rhel-8.3/8/debian-10.4-x86_64-20200603.cgz/300s/randwrite/lkp-csl-2ap1/512g/fio-basic/0x4002f01

commit: 
  f8d6c28b2a ("block: lift setting the readahead size into the block layer")
  54529aac98 ("block: make QUEUE_SYSFS_BIT_FNS a little more useful")

f8d6c28b2a8e1156 54529aac984de8d3928810c85b5 
---------------- --------------------------- 
       fail:runs  %reproduction    fail:runs
           |             |             |    
           :4           25%           1:4     kmsg.ACPI_Error
           :4            8%           0:4     perf-profile.children.cycles-pp.error_entry
           :4            5%           0:4     perf-profile.self.cycles-pp.error_entry
         %stddev     %change         %stddev
             \          |                \  
      0.01 ± 58%     +10.6       10.63 ±  9%  fio.latency_100us%
     51.65 ±  6%     -51.1        0.58 ±  4%  fio.latency_10ms%
      0.02 ± 87%      +0.8        0.86 ±  7%  fio.latency_10us%
     32.23 ± 11%     -32.1        0.16 ±  7%  fio.latency_20ms%
      0.00 ±173%      +3.1        3.14 ± 56%  fio.latency_20us%
      0.00 ±173%      +2.8        2.83 ±  3%  fio.latency_250us%
      0.02 ± 82%      +0.2        0.23 ±  7%  fio.latency_2ms%
     12.31 ±  7%     -12.2        0.12 ± 12%  fio.latency_50ms%
      0.02 ± 28%     +78.8       78.79        fio.latency_50us%
     23.52 ±  3%   +1179.5%     300.87        fio.time.elapsed_time
     23.52 ±  3%   +1179.5%     300.87        fio.time.elapsed_time.max
      8.00          -100.0%       0.00        fio.time.exit_status
    132284        +14274.3%   19014850 ±  2%  fio.time.file_system_outputs
    142.50 ±  5%     -82.1%      25.50 ±  4%  fio.time.percent_of_cpu_this_job_got
      0.68 ±  4%   +6643.4%      45.86 ±  2%  fio.time.system_time
     19211        +11893.5%    2304104 ±  4%  fio.time.voluntary_context_switches
     16460        +14337.0%    2376400 ±  2%  fio.workload
      2.83 ±  3%    +993.7%      30.93 ±  2%  fio.write_bw_MBps
  20840448 ±  2%     -99.7%      61056        fio.write_clat_90%_us
  23068672 ±  2%     -99.1%     196608        fio.write_clat_95%_us
  26411008           -75.1%    6586368 ±  6%  fio.write_clat_99%_us
  11056088 ±  3%     -90.9%    1010419 ±  2%  fio.write_clat_mean_us
   5848402 ±  3%    +119.9%   12862343 ±  3%  fio.write_clat_stddev
    724.45 ±  3%    +993.0%       7918 ±  2%  fio.write_iops
      1.88 ±  2%     +43.6%       2.70 ±  8%  iostat.cpu.system
    107585 ± 15%    +348.6%     482655 ±  3%  vmstat.io.bo
   1649211          +424.5%    8650204        vmstat.memory.cache
     14676 ±  8%    +554.5%      96054 ±  2%  vmstat.system.cs
   8012640 ± 10%   +4267.8%    3.5e+08 ± 11%  cpuidle.C1.time
     64455 ±  8%  +22724.8%   14711844 ± 10%  cpuidle.C1.usage
    171217 ±  6%   +9942.7%   17194801 ±153%  cpuidle.POLL.time
     42308 ±  6%   +5631.7%    2424981 ±136%  cpuidle.POLL.usage
      0.01 ± 22%      -0.0        0.00 ±173%  mpstat.cpu.all.iowait%
      1.49            +0.3        1.77 ± 12%  mpstat.cpu.all.irq%
      0.21            -0.0        0.17 ±  2%  mpstat.cpu.all.soft%
      0.21 ±  8%      +0.6        0.77        mpstat.cpu.all.sys%
      0.85 ±  5%      -0.8        0.08 ±  7%  mpstat.cpu.all.usr%
    167858 ± 67%   +1154.4%    2105580 ± 67%  numa-numastat.node0.local_node
    183324 ± 55%   +1054.5%    2116435 ± 67%  numa-numastat.node0.numa_hit
     30888 ± 39%   +2842.5%     908884 ±107%  numa-numastat.node1.local_node
     57286 ± 16%   +1527.4%     932306 ±103%  numa-numastat.node1.numa_hit
     19238 ± 78%   +4941.8%     969971 ±112%  numa-numastat.node2.local_node
     42546 ± 18%   +2245.6%     997984 ±109%  numa-numastat.node2.numa_hit
      9.50 ±110%  +52163.2%       4965 ± 58%  numa-vmstat.node0.nr_dirty
     11440 ± 92%   +6398.6%     743442 ± 87%  numa-vmstat.node0.nr_inactive_file
     30062 ± 14%    +237.3%     101404 ± 59%  numa-vmstat.node0.nr_slab_unreclaimable
     11440 ± 92%   +6398.6%     743442 ± 87%  numa-vmstat.node0.nr_zone_inactive_file
     11.50 ±120%  +46078.3%       5310 ± 59%  numa-vmstat.node0.nr_zone_write_pending
    454661 ± 14%    +106.9%     940779 ± 57%  numa-vmstat.node1.numa_hit
     60255          +581.0%     410314 ±127%  numa-vmstat.node2.nr_file_pages
     48974 ± 96%     -96.0%       1947 ± 33%  numa-vmstat.node3.nr_mapped
     55.75 ± 97%  +35017.5%      19578 ± 58%  numa-meminfo.node0.Dirty
     45683 ± 92%   +6408.1%    2973075 ± 87%  numa-meminfo.node0.Inactive(file)
    120285 ± 14%    +237.2%     405548 ± 59%  numa-meminfo.node0.SUnreclaim
    167194 ± 18%    +352.7%     756837 ± 68%  numa-meminfo.node0.Slab
     88.50 ±116%    +946.6%     926.25 ± 75%  numa-meminfo.node0.Writeback
    241015          +581.0%    1641234 ±127%  numa-meminfo.node2.FilePages
      4900 ± 94%  +27922.1%    1373152 ±150%  numa-meminfo.node2.Inactive
    126.75 ±138%  +42075.7%      53457 ± 73%  numa-meminfo.node3.AnonHugePages
    195556 ± 96%     -96.0%       7800 ± 33%  numa-meminfo.node3.Mapped
    391075 ±  2%    +242.7%    1340070        meminfo.Active
    383506 ±  2%     -16.0%     322083        meminfo.Active(anon)
      7568 ±  8%  +13350.8%    1017986        meminfo.Active(file)
     84823 ±  7%    +150.7%     212623        meminfo.AnonHugePages
    382110 ±  2%     -17.5%     315194        meminfo.AnonPages
   1533425          +418.0%    7943860        meminfo.Cached
    127.25 ± 85%  +21697.4%      27737 ±  3%  meminfo.Dirty
    541161          +996.8%    5935426 ±  2%  meminfo.Inactive
    151550         +3539.4%    5515485 ±  2%  meminfo.Inactive(file)
    131567          +424.9%     690598        meminfo.KReclaimable
   4029450          +177.4%   11177188        meminfo.Memused
      7554 ±  3%     -38.9%       4617        meminfo.PageTables
    131567          +424.9%     690598        meminfo.SReclaimable
    347533          +148.4%     863208        meminfo.SUnreclaim
    479100          +224.3%    1553806        meminfo.Slab
    233.75 ± 72%    +544.3%       1506 ±  3%  meminfo.Writeback
    178754 ±  3%     -70.9%      52052 ±  2%  meminfo.max_used_kB
     95883 ±  2%     -16.0%      80513        proc-vmstat.nr_active_anon
      1891 ±  8%  +13355.1%     254502        proc-vmstat.nr_active_file
     95539 ±  2%     -17.5%      78789        proc-vmstat.nr_anon_pages
     40.75 ±  8%    +153.4%     103.25        proc-vmstat.nr_anon_transparent_hugepages
    662355 ± 13%   +2858.1%   19592962 ±  3%  proc-vmstat.nr_dirtied
     32.00 ± 85%  +21068.0%       6773 ±  4%  proc-vmstat.nr_dirty
    383376          +418.2%    1986627        proc-vmstat.nr_file_pages
  48424268            -3.7%   46636528        proc-vmstat.nr_free_pages
     97409            +7.4%     104645        proc-vmstat.nr_inactive_anon
     37888         +3541.9%    1379854 ±  2%  proc-vmstat.nr_inactive_file
    102723            +6.8%     109689        proc-vmstat.nr_mapped
      1889 ±  3%     -38.8%       1156        proc-vmstat.nr_page_table_pages
     97886            +8.8%     106528        proc-vmstat.nr_shmem
     32895          +425.0%     172714        proc-vmstat.nr_slab_reclaimable
     86888          +148.4%     215854        proc-vmstat.nr_slab_unreclaimable
     56.75 ± 71%    +625.1%     411.50 ±  2%  proc-vmstat.nr_writeback
    662685 ± 13%   +2847.8%   19534416 ±  3%  proc-vmstat.nr_written
     95883 ±  2%     -16.0%      80513        proc-vmstat.nr_zone_active_anon
      1891 ±  8%  +13355.1%     254502        proc-vmstat.nr_zone_active_file
     97409            +7.4%     104645        proc-vmstat.nr_zone_inactive_anon
     37888         +3541.9%    1379854 ±  2%  proc-vmstat.nr_zone_inactive_file
     24.75 ± 88%  +29648.5%       7362 ±  3%  proc-vmstat.nr_zone_write_pending
    504181 ±  3%    +749.5%    4283048 ±  2%  proc-vmstat.numa_hit
    411017 ±  3%    +919.3%    4189581 ±  2%  proc-vmstat.numa_local
    114824 ± 17%     +86.5%     214154 ±  3%  proc-vmstat.pgactivate
    496476 ±  3%    +870.7%    4819481        proc-vmstat.pgalloc_normal
    322549          +320.6%    1356514        proc-vmstat.pgfault
    404143 ±  4%    +361.1%    1863546        proc-vmstat.pgfree
   2727761 ± 13%   +5274.4%  1.466e+08 ±  3%  proc-vmstat.pgpgout
 9.336e+08 ±  3%     +83.8%  1.716e+09 ±  5%  perf-stat.i.branch-instructions
   9432178           +80.2%   16996652 ± 15%  perf-stat.i.cache-misses
  39024949 ±  2%    +123.4%   87179267 ± 45%  perf-stat.i.cache-references
     14747 ±  7%    +555.9%      96725 ±  2%  perf-stat.i.context-switches
      4.26 ±  2%     -53.8%       1.97 ± 12%  perf-stat.i.cpi
    266.31           -21.3%     209.72        perf-stat.i.cpu-migrations
      1928 ±  3%     -46.7%       1027 ±  4%  perf-stat.i.cycles-between-cache-misses
      0.01 ± 13%      +0.1        0.09 ± 66%  perf-stat.i.dTLB-load-miss-rate%
    134104 ± 14%   +1375.2%    1978299 ± 61%  perf-stat.i.dTLB-load-misses
 1.115e+09 ±  5%     +99.2%  2.222e+09 ±  4%  perf-stat.i.dTLB-loads
 5.321e+08 ±  5%    +109.0%  1.112e+09 ±  4%  perf-stat.i.dTLB-stores
  4.63e+09 ±  3%     +89.1%  8.758e+09 ±  5%  perf-stat.i.instructions
    998.21 ±  4%     +71.7%       1714 ± 19%  perf-stat.i.instructions-per-iTLB-miss
      0.26 ±  3%     +97.5%       0.52 ± 14%  perf-stat.i.ipc
      1.53 ±  7%     -32.6%       1.03 ±  5%  perf-stat.i.metric.K/sec
     13.68 ±  4%     +95.9%      26.81 ±  4%  perf-stat.i.metric.M/sec
      8800           -54.0%       4048        perf-stat.i.minor-faults
     90.77           -39.9       50.90 ± 45%  perf-stat.i.node-load-miss-rate%
    153794 ± 19%   +1166.2%    1947374 ± 54%  perf-stat.i.node-loads
     80.08 ±  3%     -40.1       39.98 ± 56%  perf-stat.i.node-store-miss-rate%
     62705 ± 13%    +474.6%     360324 ± 39%  perf-stat.i.node-stores
      8800           -54.0%       4048        perf-stat.i.page-faults
      2.22 ±  3%      -1.1        1.08 ± 51%  perf-stat.overall.branch-miss-rate%
      4.29 ±  3%     -53.8%       1.98 ± 11%  perf-stat.overall.cpi
      2106 ±  3%     -51.2%       1027 ±  4%  perf-stat.overall.cycles-between-cache-misses
      0.01 ± 11%      +0.1        0.09 ± 65%  perf-stat.overall.dTLB-load-miss-rate%
    999.21 ±  4%     +71.5%       1713 ± 19%  perf-stat.overall.instructions-per-iTLB-miss
      0.23 ±  3%    +119.7%       0.51 ± 13%  perf-stat.overall.ipc
     90.45           -39.7       50.76 ± 45%  perf-stat.overall.node-load-miss-rate%
     75.99 ±  2%     -35.9       40.08 ± 55%  perf-stat.overall.node-store-miss-rate%
   6517909           -83.0%    1107486 ±  3%  perf-stat.overall.path-length
 8.955e+08 ±  3%     +91.0%   1.71e+09 ±  5%  perf-stat.ps.branch-instructions
   9042845           +87.3%   16939980 ± 15%  perf-stat.ps.cache-misses
  37409555 ±  2%    +132.3%   86888536 ± 45%  perf-stat.ps.cache-references
     14129 ±  7%    +582.3%      96408 ±  2%  perf-stat.ps.context-switches
    183945            +4.0%     191354        perf-stat.ps.cpu-clock
    255.33           -18.1%     209.10        perf-stat.ps.cpu-migrations
    128676 ± 14%   +1432.2%    1971598 ± 61%  perf-stat.ps.dTLB-load-misses
  1.07e+09 ±  4%    +107.1%  2.215e+09 ±  4%  perf-stat.ps.dTLB-loads
 5.101e+08 ±  5%    +117.3%  1.109e+09 ±  4%  perf-stat.ps.dTLB-stores
 4.441e+09 ±  3%     +96.5%  8.729e+09 ±  5%  perf-stat.ps.instructions
      8474           -52.3%       4038        perf-stat.ps.minor-faults
    147537 ± 18%   +1215.4%    1940671 ± 54%  perf-stat.ps.node-loads
     60290 ± 13%    +495.7%     359127 ± 39%  perf-stat.ps.node-stores
      8474           -52.3%       4038        perf-stat.ps.page-faults
    183945            +4.0%     191354        perf-stat.ps.task-clock
 1.073e+11         +2354.7%  2.634e+12 ±  5%  perf-stat.total.instructions
      0.70 ± 34%  +2.8e+05%       1981 ± 15%  sched_debug.cfs_rq:/.exec_clock.avg
     28.37 ± 37%  +36569.2%      10403 ± 14%  sched_debug.cfs_rq:/.exec_clock.max
      3.22 ± 25%  +76913.6%       2476 ± 12%  sched_debug.cfs_rq:/.exec_clock.stddev
      1670 ± 28%   +1670.3%      29569 ± 18%  sched_debug.cfs_rq:/.load.avg
     49868 ± 22%   +1631.4%     863438        sched_debug.cfs_rq:/.load.max
      6915 ± 10%   +1859.9%     135538 ±  8%  sched_debug.cfs_rq:/.load.stddev
     59795 ±  3%     +42.9%      85423 ±  2%  sched_debug.cfs_rq:/.min_vruntime.avg
     82225 ±  4%     +25.6%     103292        sched_debug.cfs_rq:/.min_vruntime.max
     33527 ± 27%     +76.6%      59221 ± 19%  sched_debug.cfs_rq:/.min_vruntime.min
    141.33 ± 30%     -66.2%      47.79 ±  6%  sched_debug.cfs_rq:/.runnable_avg.avg
      1120 ± 14%     -38.5%     689.36 ±  4%  sched_debug.cfs_rq:/.runnable_avg.max
    235.83 ± 14%     -50.2%     117.37 ±  3%  sched_debug.cfs_rq:/.runnable_avg.stddev
    140.81 ± 30%     -66.1%      47.70 ±  6%  sched_debug.cfs_rq:/.util_avg.avg
      1119 ± 14%     -38.4%     689.27 ±  4%  sched_debug.cfs_rq:/.util_avg.max
    235.51 ± 14%     -50.2%     117.31 ±  3%  sched_debug.cfs_rq:/.util_avg.stddev
    829.50           -48.8%     424.72 ± 32%  sched_debug.cfs_rq:/.util_est_enqueued.max
     86.99 ± 14%     -45.6%      47.32 ± 30%  sched_debug.cfs_rq:/.util_est_enqueued.stddev
   2530164 ± 48%     -52.4%    1204917 ±  8%  sched_debug.cpu.avg_idle.max
      2063 ±  6%   +2333.0%      50205 ± 92%  sched_debug.cpu.avg_idle.min
    328400 ± 29%     -32.6%     221320 ± 11%  sched_debug.cpu.avg_idle.stddev
     43166          +312.4%     178032 ±  8%  sched_debug.cpu.clock.avg
     43190          +312.2%     178045 ±  8%  sched_debug.cpu.clock.max
     43140          +312.7%     178019 ±  8%  sched_debug.cpu.clock.min
     14.81 ± 21%     -48.4%       7.64 ±  7%  sched_debug.cpu.clock.stddev
     43018          +307.5%     175286 ±  8%  sched_debug.cpu.clock_task.avg
     43162          +309.7%     176824 ±  8%  sched_debug.cpu.clock_task.max
     35239          +374.5%     167206 ±  7%  sched_debug.cpu.clock_task.min
    733.52 ±  3%     +53.5%       1126 ± 20%  sched_debug.cpu.clock_task.stddev
      3600          +120.5%       7939 ±  6%  sched_debug.cpu.curr->pid.max
   1860093 ± 49%     -60.7%     731047 ± 15%  sched_debug.cpu.max_idle_balance_cost.max
    176803 ± 87%     -85.0%      26544 ± 55%  sched_debug.cpu.max_idle_balance_cost.stddev
      0.00 ± 15%     -49.0%       0.00 ±  3%  sched_debug.cpu.next_balance.stddev
      0.04 ± 25%     -51.7%       0.02 ± 16%  sched_debug.cpu.nr_running.avg
      0.20 ± 13%     -31.0%       0.14 ±  6%  sched_debug.cpu.nr_running.stddev
      1655         +4610.3%      77993 ±  6%  sched_debug.cpu.nr_switches.avg
     11537 ± 15%   +5972.4%     700592 ±  9%  sched_debug.cpu.nr_switches.max
    512.25 ± 25%    +205.8%       1566 ±  7%  sched_debug.cpu.nr_switches.min
      1163 ±  6%  +11814.6%     138586 ±  7%  sched_debug.cpu.nr_switches.stddev
      0.01 ±122%    +693.3%       0.04 ±  4%  sched_debug.cpu.nr_uninterruptible.avg
    -56.00           -47.4%     -29.45        sched_debug.cpu.nr_uninterruptible.min
     23.40 ± 71%  +3.3e+05%      76414 ±  6%  sched_debug.cpu.sched_count.avg
      3461 ± 72%  +20056.5%     697668 ±  9%  sched_debug.cpu.sched_count.max
    262.10 ± 73%  +52693.5%     138370 ±  7%  sched_debug.cpu.sched_count.stddev
     11.70 ± 71%  +3.3e+05%      38143 ±  6%  sched_debug.cpu.sched_goidle.avg
      1731 ± 72%  +20028.3%     348570 ±  9%  sched_debug.cpu.sched_goidle.max
    131.13 ± 73%  +52628.4%      69142 ±  7%  sched_debug.cpu.sched_goidle.stddev
     17.01 ± 85%  +2.2e+05%      38124 ±  6%  sched_debug.cpu.ttwu_count.avg
      1939 ± 74%  +17590.0%     343054 ±  9%  sched_debug.cpu.ttwu_count.max
    162.46 ± 78%  +42822.7%      69733 ±  6%  sched_debug.cpu.ttwu_count.stddev
      0.13 ± 59%  +2.5e+06%       3222 ± 11%  sched_debug.cpu.ttwu_local.avg
      9.50 ± 82%  +4.1e+05%      39215 ± 16%  sched_debug.cpu.ttwu_local.max
      0.83 ± 68%  +8.1e+05%       6746 ±  7%  sched_debug.cpu.ttwu_local.stddev
     43145          +312.6%     178019 ±  8%  sched_debug.cpu_clk
     42272          +319.1%     177145 ±  8%  sched_debug.ktime
     43503          +310.0%     178377 ±  8%  sched_debug.sched_clk
     20452 ±  4%   +6489.8%    1347781 ±  2%  slabinfo.Acpi-State.active_objs
    400.75 ±  4%   +6501.8%      26456 ±  2%  slabinfo.Acpi-State.active_slabs
     20462 ±  4%   +6494.0%    1349317 ±  2%  slabinfo.Acpi-State.num_objs
    400.75 ±  4%   +6501.8%      26456 ±  2%  slabinfo.Acpi-State.num_slabs
    542.50 ±  7%     +91.9%       1041 ± 22%  slabinfo.biovec-max.active_objs
    566.75 ±  8%     +91.3%       1084 ± 23%  slabinfo.biovec-max.num_objs
      1627 ±  4%    +300.8%       6520 ± 26%  slabinfo.blkdev_ioc.active_objs
     42.00 ±  5%    +323.2%     177.75 ± 26%  slabinfo.blkdev_ioc.active_slabs
      1648 ±  4%    +322.0%       6956 ± 26%  slabinfo.blkdev_ioc.num_objs
     42.00 ±  5%    +323.2%     177.75 ± 26%  slabinfo.blkdev_ioc.num_slabs
      1198 ±  7%   +1193.1%      15501 ± 27%  slabinfo.btrfs_ordered_extent.active_objs
     30.50 ±  7%   +1208.2%     399.00 ± 27%  slabinfo.btrfs_ordered_extent.active_slabs
      1198 ±  7%   +1200.0%      15584 ± 27%  slabinfo.btrfs_ordered_extent.num_objs
     30.50 ±  7%   +1208.2%     399.00 ± 27%  slabinfo.btrfs_ordered_extent.num_slabs
      2770           +44.8%       4012 ± 19%  slabinfo.buffer_head.active_objs
      2926           +38.1%       4041 ± 19%  slabinfo.buffer_head.num_objs
      2121 ±  2%     +66.3%       3527 ± 14%  slabinfo.dmaengine-unmap-16.active_objs
      2121 ±  2%     +66.3%       3527 ± 14%  slabinfo.dmaengine-unmap-16.num_objs
    916.75 ±  6%     +12.6%       1032 ±  3%  slabinfo.file_lock_cache.active_objs
    916.75 ±  6%     +12.6%       1032 ±  3%  slabinfo.file_lock_cache.num_objs
      6444 ±  4%    +191.6%      18791 ± 23%  slabinfo.fsnotify_mark_connector.active_objs
     50.00 ±  4%    +195.5%     147.75 ± 23%  slabinfo.fsnotify_mark_connector.active_slabs
      6444 ±  4%    +194.4%      18975 ± 22%  slabinfo.fsnotify_mark_connector.num_objs
     50.00 ±  4%    +195.5%     147.75 ± 23%  slabinfo.fsnotify_mark_connector.num_slabs
      2831 ±  6%    +198.2%       8444 ± 26%  slabinfo.khugepaged_mm_slot.active_objs
     81.00 ±  5%    +193.8%     238.00 ± 26%  slabinfo.khugepaged_mm_slot.active_slabs
      2933 ±  5%    +192.8%       8590 ± 26%  slabinfo.khugepaged_mm_slot.num_objs
     81.00 ±  5%    +193.8%     238.00 ± 26%  slabinfo.khugepaged_mm_slot.num_slabs
     13293 ±  2%     +38.2%      18373 ±  5%  slabinfo.kmalloc-1k.active_objs
    417.50 ±  2%     +39.4%     582.00 ±  5%  slabinfo.kmalloc-1k.active_slabs
     13381 ±  2%     +39.3%      18646 ±  5%  slabinfo.kmalloc-1k.num_objs
    417.50 ±  2%     +39.4%     582.00 ±  5%  slabinfo.kmalloc-1k.num_slabs
      5546 ±  4%      +5.1%       5829 ±  2%  slabinfo.kmalloc-rcl-64.active_objs
      5546 ±  4%      +5.1%       5829 ±  2%  slabinfo.kmalloc-rcl-64.num_objs
      2413 ±  4%     +99.5%       4813 ± 13%  slabinfo.mnt_cache.active_objs
      2413 ±  4%     +99.5%       4814 ± 13%  slabinfo.mnt_cache.num_objs
     63.00          +207.1%     193.50 ± 16%  slabinfo.nfs_read_data.active_objs
     63.00          +207.1%     193.50 ± 16%  slabinfo.nfs_read_data.num_objs
      7194 ± 19%    +477.8%      41568 ± 15%  slabinfo.numa_policy.active_objs
    115.75 ± 19%    +494.6%     688.25 ± 15%  slabinfo.numa_policy.active_slabs
      7210 ± 19%    +492.3%      42712 ± 15%  slabinfo.numa_policy.num_objs
    115.75 ± 19%    +494.6%     688.25 ± 15%  slabinfo.numa_policy.num_slabs
     27102 ±  2%   +9805.3%    2684621 ±  2%  slabinfo.pid_namespace.active_objs
    486.25 ±  2%   +9760.2%      47945 ±  2%  slabinfo.pid_namespace.active_slabs
     27261 ±  2%   +9749.0%    2684951 ±  2%  slabinfo.pid_namespace.num_objs
    486.25 ±  2%   +9760.2%      47945 ±  2%  slabinfo.pid_namespace.num_slabs
     44107         +2207.4%    1017721        slabinfo.radix_tree_node.active_objs
    787.25         +2209.0%      18177        slabinfo.radix_tree_node.active_slabs
     44119         +2207.3%    1017966        slabinfo.radix_tree_node.num_objs
    787.25         +2209.0%      18177        slabinfo.radix_tree_node.num_slabs
    688.75 ±  9%     +46.1%       1006 ±  8%  slabinfo.skbuff_fclone_cache.active_objs
    688.75 ±  9%     +46.1%       1006 ±  8%  slabinfo.skbuff_fclone_cache.num_objs
     18421           +43.2%      26371        slabinfo.vmap_area.active_objs
    288.00           +43.3%     412.75        slabinfo.vmap_area.active_slabs
     18480           +43.1%      26451        slabinfo.vmap_area.num_objs
    288.00           +43.3%     412.75        slabinfo.vmap_area.num_slabs
     75.50 ± 51%   +1125.2%     925.00 ± 84%  interrupts.31:PCI-MSI.524289-edge.eth0-TxRx-0
    104.25 ± 27%   +6685.4%       7073 ±151%  interrupts.33:PCI-MSI.524291-edge.eth0-TxRx-2
     76.00 ± 51%   +3560.9%       2782 ±131%  interrupts.34:PCI-MSI.524292-edge.eth0-TxRx-3
     49.00 ±  4%   +1132.7%     604.00        interrupts.9:IO-APIC.9-fasteoi.acpi
    179254 ±  2%    +133.6%     418691 ± 13%  interrupts.CAL:Function_call_interrupts
      1147 ± 23%    +202.5%       3469 ± 61%  interrupts.CPU0.CAL:Function_call_interrupts
     49381 ±  3%    +987.1%     536845 ± 21%  interrupts.CPU0.LOC:Local_timer_interrupts
      1.50 ±173%  +18650.0%     281.25 ± 40%  interrupts.CPU0.NMI:Non-maskable_interrupts
      1.50 ±173%  +18650.0%     281.25 ± 40%  interrupts.CPU0.PMI:Performance_monitoring_interrupts
     16.50 ± 64%   +1804.5%     314.25 ± 89%  interrupts.CPU0.RES:Rescheduling_interrupts
     49.00 ±  4%   +1132.7%     604.00        interrupts.CPU1.9:IO-APIC.9-fasteoi.acpi
      1280 ± 55%    +435.2%       6854 ± 55%  interrupts.CPU1.CAL:Function_call_interrupts
     49635 ±  3%    +981.4%     536765 ± 21%  interrupts.CPU1.LOC:Local_timer_interrupts
      1.00 ±100%  +45525.0%     456.25 ± 65%  interrupts.CPU1.NMI:Non-maskable_interrupts
      1.00 ±100%  +45525.0%     456.25 ± 65%  interrupts.CPU1.PMI:Performance_monitoring_interrupts
     18.00 ±110%   +5736.1%       1050 ± 91%  interrupts.CPU1.RES:Rescheduling_interrupts
     75.50 ± 51%   +1125.2%     925.00 ± 84%  interrupts.CPU10.31:PCI-MSI.524289-edge.eth0-TxRx-0
     49206 ±  3%    +992.3%     537492 ± 21%  interrupts.CPU10.LOC:Local_timer_interrupts
    858.75          +514.8%       5279 ± 80%  interrupts.CPU100.CAL:Function_call_interrupts
     49478 ±  3%    +983.3%     535977 ± 22%  interrupts.CPU100.LOC:Local_timer_interrupts
      8.00 ±137%  +58053.1%       4652 ± 98%  interrupts.CPU100.RES:Rescheduling_interrupts
    859.25          +274.4%       3217 ± 42%  interrupts.CPU101.CAL:Function_call_interrupts
     49288 ±  3%    +988.3%     536385 ± 21%  interrupts.CPU101.LOC:Local_timer_interrupts
      9.50 ±144%  +26613.2%       2537 ± 74%  interrupts.CPU101.RES:Rescheduling_interrupts
    857.75          +343.3%       3802 ± 78%  interrupts.CPU102.CAL:Function_call_interrupts
     49294 ±  3%    +986.2%     535457 ± 22%  interrupts.CPU102.LOC:Local_timer_interrupts
      9.25 ± 74%  +38713.5%       3590 ±103%  interrupts.CPU102.RES:Rescheduling_interrupts
    875.75          +410.6%       4471 ± 80%  interrupts.CPU103.CAL:Function_call_interrupts
     49184 ±  3%    +989.9%     536056 ± 22%  interrupts.CPU103.LOC:Local_timer_interrupts
     55.75 ±116%   +7516.1%       4246 ±101%  interrupts.CPU103.RES:Rescheduling_interrupts
    871.75 ±  4%    +541.6%       5592 ± 79%  interrupts.CPU104.CAL:Function_call_interrupts
     49253 ±  3%    +987.7%     535737 ± 22%  interrupts.CPU104.LOC:Local_timer_interrupts
     17.75 ±144%  +32245.1%       5741 ± 95%  interrupts.CPU104.RES:Rescheduling_interrupts
     49276 ±  3%    +988.2%     536221 ± 22%  interrupts.CPU105.LOC:Local_timer_interrupts
    879.75 ±  4%    +267.6%       3234 ± 73%  interrupts.CPU106.CAL:Function_call_interrupts
     49261 ±  3%    +989.7%     536797 ± 21%  interrupts.CPU106.LOC:Local_timer_interrupts
     26.75 ± 99%  +10216.8%       2759 ±108%  interrupts.CPU106.RES:Rescheduling_interrupts
    899.00 ±  6%    +335.4%       3914 ± 68%  interrupts.CPU107.CAL:Function_call_interrupts
     49265 ±  3%    +988.4%     536200 ± 21%  interrupts.CPU107.LOC:Local_timer_interrupts
    871.25 ±  7%    +350.8%       3927 ± 55%  interrupts.CPU108.CAL:Function_call_interrupts
     49259 ±  3%    +987.2%     535540 ± 22%  interrupts.CPU108.LOC:Local_timer_interrupts
     34.75 ±163%  +11149.6%       3909 ± 81%  interrupts.CPU108.RES:Rescheduling_interrupts
     49268 ±  3%    +988.4%     536234 ± 22%  interrupts.CPU109.LOC:Local_timer_interrupts
      0.25 ±173%  +2.5e+05%     614.00 ± 38%  interrupts.CPU109.NMI:Non-maskable_interrupts
      0.25 ±173%  +2.5e+05%     614.00 ± 38%  interrupts.CPU109.PMI:Performance_monitoring_interrupts
     85.75 ±164%   +2859.5%       2537 ± 98%  interrupts.CPU109.RES:Rescheduling_interrupts
      1232 ± 50%    +101.6%       2483 ± 59%  interrupts.CPU11.CAL:Function_call_interrupts
     49302 ±  3%    +990.5%     537634 ± 21%  interrupts.CPU11.LOC:Local_timer_interrupts
      0.75 ±110%  +56766.7%     426.50 ± 58%  interrupts.CPU11.NMI:Non-maskable_interrupts
      0.75 ±110%  +56766.7%     426.50 ± 58%  interrupts.CPU11.PMI:Performance_monitoring_interrupts
      7.00 ±109%   +9578.6%     677.50 ± 99%  interrupts.CPU11.RES:Rescheduling_interrupts
    878.75 ±  5%    +314.1%       3638 ± 71%  interrupts.CPU110.CAL:Function_call_interrupts
     49271 ±  3%    +988.4%     536248 ± 21%  interrupts.CPU110.LOC:Local_timer_interrupts
     28.50 ±105%  +12543.9%       3603 ±108%  interrupts.CPU110.RES:Rescheduling_interrupts
    899.75 ±  4%    +255.2%       3196 ± 46%  interrupts.CPU111.CAL:Function_call_interrupts
     49271 ±  3%    +986.9%     535521 ± 22%  interrupts.CPU111.LOC:Local_timer_interrupts
     66.50 ±151%   +3644.0%       2489 ± 82%  interrupts.CPU111.RES:Rescheduling_interrupts
    902.00 ±  4%    +225.4%       2935 ± 40%  interrupts.CPU112.CAL:Function_call_interrupts
     49268 ±  3%    +987.5%     535818 ± 22%  interrupts.CPU112.LOC:Local_timer_interrupts
    120.75 ±155%   +1744.1%       2226 ± 79%  interrupts.CPU112.RES:Rescheduling_interrupts
    909.00 ± 11%    +227.9%       2980 ± 72%  interrupts.CPU113.CAL:Function_call_interrupts
     49270 ±  3%    +988.6%     536338 ± 21%  interrupts.CPU113.LOC:Local_timer_interrupts
    143.50 ±171%   +1817.2%       2751 ±103%  interrupts.CPU113.RES:Rescheduling_interrupts
    867.50 ±  4%    +159.9%       2254 ± 55%  interrupts.CPU114.CAL:Function_call_interrupts
     49289 ±  3%    +987.4%     535968 ± 22%  interrupts.CPU114.LOC:Local_timer_interrupts
      2.00 ±106%  +86737.5%       1736 ±107%  interrupts.CPU114.RES:Rescheduling_interrupts
    891.00 ±  6%    +197.1%       2647 ± 57%  interrupts.CPU115.CAL:Function_call_interrupts
     49260 ±  3%    +988.6%     536235 ± 21%  interrupts.CPU115.LOC:Local_timer_interrupts
     45.50 ±138%   +3636.8%       1700 ± 92%  interrupts.CPU115.RES:Rescheduling_interrupts
    871.50 ±  4%    +230.5%       2880 ± 78%  interrupts.CPU116.CAL:Function_call_interrupts
     49265 ±  3%    +989.0%     536484 ± 21%  interrupts.CPU116.LOC:Local_timer_interrupts
      1.50 ± 74%  +1.7e+05%       2600 ±116%  interrupts.CPU116.RES:Rescheduling_interrupts
    869.25 ±  4%    +337.2%       3800 ± 74%  interrupts.CPU117.CAL:Function_call_interrupts
     49274 ±  3%    +986.5%     535378 ± 22%  interrupts.CPU117.LOC:Local_timer_interrupts
      0.25 ±173%  +2.2e+05%     561.75 ± 83%  interrupts.CPU117.NMI:Non-maskable_interrupts
      0.25 ±173%  +2.2e+05%     561.75 ± 83%  interrupts.CPU117.PMI:Performance_monitoring_interrupts
    896.50 ±  7%    +375.8%       4265 ± 79%  interrupts.CPU118.CAL:Function_call_interrupts
     49275 ±  3%    +988.4%     536312 ± 21%  interrupts.CPU118.LOC:Local_timer_interrupts
     17.00 ±163%  +17627.9%       3013 ±122%  interrupts.CPU118.RES:Rescheduling_interrupts
    873.00 ±  6%    +292.3%       3424 ± 99%  interrupts.CPU119.CAL:Function_call_interrupts
     49264 ±  3%    +988.6%     536311 ± 21%  interrupts.CPU119.LOC:Local_timer_interrupts
      1.50 ±173%  +23416.7%     352.75 ± 65%  interrupts.CPU119.NMI:Non-maskable_interrupts
      1.50 ±173%  +23416.7%     352.75 ± 65%  interrupts.CPU119.PMI:Performance_monitoring_interrupts
      2.00 ± 61%  +1.5e+05%       3040 ±134%  interrupts.CPU119.RES:Rescheduling_interrupts
    104.25 ± 27%   +6685.4%       7073 ±151%  interrupts.CPU12.33:PCI-MSI.524291-edge.eth0-TxRx-2
     49217 ±  3%    +990.1%     536526 ± 21%  interrupts.CPU12.LOC:Local_timer_interrupts
     49259 ±  3%   +1092.8%     587552 ±  4%  interrupts.CPU120.LOC:Local_timer_interrupts
      0.75 ± 57%  +1.1e+05%     812.00 ±171%  interrupts.CPU120.RES:Rescheduling_interrupts
     49258 ±  3%   +1099.9%     591035 ±  3%  interrupts.CPU121.LOC:Local_timer_interrupts
      0.25 ±173%  +2.4e+05%     604.25 ±171%  interrupts.CPU121.RES:Rescheduling_interrupts
     49250 ±  3%   +1100.0%     590986 ±  3%  interrupts.CPU122.LOC:Local_timer_interrupts
      0.50 ±173%  +34600.0%     173.50 ± 34%  interrupts.CPU122.NMI:Non-maskable_interrupts
      0.50 ±173%  +34600.0%     173.50 ± 34%  interrupts.CPU122.PMI:Performance_monitoring_interrupts
      0.75 ±173%    +1e+05%     762.50 ±170%  interrupts.CPU122.RES:Rescheduling_interrupts
     49270 ±  3%   +1097.6%     590043 ±  4%  interrupts.CPU123.LOC:Local_timer_interrupts
      1.00 ± 70%  +75425.0%     755.25 ±170%  interrupts.CPU123.RES:Rescheduling_interrupts
     49146 ±  2%   +1101.2%     590359 ±  4%  interrupts.CPU124.LOC:Local_timer_interrupts
      0.25 ±173%  +54900.0%     137.50 ± 42%  interrupts.CPU124.NMI:Non-maskable_interrupts
      0.25 ±173%  +54900.0%     137.50 ± 42%  interrupts.CPU124.PMI:Performance_monitoring_interrupts
    853.50           +62.1%       1383 ± 58%  interrupts.CPU125.CAL:Function_call_interrupts
     49248 ±  3%   +1095.0%     588506 ±  4%  interrupts.CPU125.LOC:Local_timer_interrupts
      1.75 ± 47%  +23000.0%     404.25 ±170%  interrupts.CPU125.RES:Rescheduling_interrupts
    839.00 ±  3%    +138.3%       1999 ± 73%  interrupts.CPU126.CAL:Function_call_interrupts
     49235 ±  3%   +1095.9%     588790 ±  4%  interrupts.CPU126.LOC:Local_timer_interrupts
      1.75 ± 62%  +44085.7%     773.25 ±171%  interrupts.CPU126.RES:Rescheduling_interrupts
    847.75          +129.3%       1943 ± 59%  interrupts.CPU127.CAL:Function_call_interrupts
     49233 ±  3%   +1092.1%     586903 ±  5%  interrupts.CPU127.LOC:Local_timer_interrupts
      1.50 ± 74%  +21533.3%     324.50 ±165%  interrupts.CPU127.RES:Rescheduling_interrupts
     49238 ±  3%   +1089.3%     585574 ±  5%  interrupts.CPU128.LOC:Local_timer_interrupts
     49155 ±  3%   +1096.4%     588084 ±  4%  interrupts.CPU129.LOC:Local_timer_interrupts
     76.00 ± 51%   +3560.9%       2782 ±131%  interrupts.CPU13.34:PCI-MSI.524292-edge.eth0-TxRx-3
     49321 ±  3%    +991.3%     538223 ± 22%  interrupts.CPU13.LOC:Local_timer_interrupts
     17.75 ±101%   +4026.8%     732.50 ± 83%  interrupts.CPU13.RES:Rescheduling_interrupts
    849.75 ±  2%     +63.2%       1386 ± 59%  interrupts.CPU130.CAL:Function_call_interrupts
     49248 ±  3%   +1094.3%     588155 ±  4%  interrupts.CPU130.LOC:Local_timer_interrupts
     49233 ±  3%   +1098.6%     590125 ±  4%  interrupts.CPU131.LOC:Local_timer_interrupts
      1.75 ± 74%  +65700.0%       1151 ±171%  interrupts.CPU131.RES:Rescheduling_interrupts
     49232 ±  3%   +1094.0%     587826 ±  4%  interrupts.CPU132.LOC:Local_timer_interrupts
    842.75 ±  2%    +172.7%       2298 ±104%  interrupts.CPU133.CAL:Function_call_interrupts
     49233 ±  3%   +1100.3%     590953 ±  3%  interrupts.CPU133.LOC:Local_timer_interrupts
      1.50 ± 57%  +74066.7%       1112 ±171%  interrupts.CPU133.RES:Rescheduling_interrupts
    862.75          +109.0%       1803 ± 85%  interrupts.CPU134.CAL:Function_call_interrupts
     49237 ±  3%   +1099.6%     590629 ±  3%  interrupts.CPU134.LOC:Local_timer_interrupts
    850.00 ±  2%    +205.9%       2599 ± 68%  interrupts.CPU135.CAL:Function_call_interrupts
     49233 ±  3%   +1096.3%     588961 ±  4%  interrupts.CPU135.LOC:Local_timer_interrupts
      1.50 ± 74%  +63083.3%     947.75 ±169%  interrupts.CPU135.RES:Rescheduling_interrupts
    852.50           +94.8%       1660 ± 76%  interrupts.CPU136.CAL:Function_call_interrupts
     49223 ±  3%   +1097.2%     589295 ±  4%  interrupts.CPU136.LOC:Local_timer_interrupts
      1.25 ± 87%  +48480.0%     607.25 ±169%  interrupts.CPU136.RES:Rescheduling_interrupts
     49237 ±  3%   +1093.0%     587396 ±  4%  interrupts.CPU137.LOC:Local_timer_interrupts
      1.75 ± 24%  +10814.3%     191.00 ±166%  interrupts.CPU137.RES:Rescheduling_interrupts
    848.25 ±  2%    +116.7%       1838 ± 55%  interrupts.CPU138.CAL:Function_call_interrupts
     49234 ±  3%   +1092.7%     587201 ±  5%  interrupts.CPU138.LOC:Local_timer_interrupts
      1.50 ± 74%  +48583.3%     730.25 ±105%  interrupts.CPU138.RES:Rescheduling_interrupts
    847.75 ±  2%     +54.2%       1307 ± 52%  interrupts.CPU139.CAL:Function_call_interrupts
     49225 ±  3%   +1091.9%     586707 ±  5%  interrupts.CPU139.LOC:Local_timer_interrupts
      3.75 ± 22%   +8800.0%     333.75 ±168%  interrupts.CPU139.RES:Rescheduling_interrupts
      1226 ± 37%    +167.1%       3275 ± 57%  interrupts.CPU14.CAL:Function_call_interrupts
     49381 ±  3%    +986.7%     536610 ± 21%  interrupts.CPU14.LOC:Local_timer_interrupts
      0.50 ±100%  +94550.0%     473.25 ± 60%  interrupts.CPU14.NMI:Non-maskable_interrupts
      0.50 ±100%  +94550.0%     473.25 ± 60%  interrupts.CPU14.PMI:Performance_monitoring_interrupts
      8.75 ± 79%   +9505.7%     840.50 ± 82%  interrupts.CPU14.RES:Rescheduling_interrupts
     49230 ±  3%   +1096.2%     588919 ±  4%  interrupts.CPU140.LOC:Local_timer_interrupts
     49249 ±  3%   +1098.5%     590271 ±  4%  interrupts.CPU141.LOC:Local_timer_interrupts
      1.50 ±137%  +38050.0%     572.25 ±170%  interrupts.CPU141.RES:Rescheduling_interrupts
     49235 ±  3%   +1093.6%     587678 ±  4%  interrupts.CPU142.LOC:Local_timer_interrupts
      3.00 ± 33%  +21441.7%     646.25 ±170%  interrupts.CPU142.RES:Rescheduling_interrupts
     49232 ±  3%   +1095.9%     588791 ±  4%  interrupts.CPU143.LOC:Local_timer_interrupts
      0.75 ±110%  +1.3e+05%     939.50 ±171%  interrupts.CPU143.RES:Rescheduling_interrupts
    858.00 ±  3%     +69.4%       1453 ± 65%  interrupts.CPU144.CAL:Function_call_interrupts
     49259 ±  3%    +975.2%     529624 ± 24%  interrupts.CPU144.LOC:Local_timer_interrupts
      0.25 ±173%  +1.5e+05%     382.00 ±118%  interrupts.CPU144.NMI:Non-maskable_interrupts
      0.25 ±173%  +1.5e+05%     382.00 ±118%  interrupts.CPU144.PMI:Performance_monitoring_interrupts
      2.50 ± 91%  +29930.0%     750.75 ±170%  interrupts.CPU144.RES:Rescheduling_interrupts
    853.25 ±  4%     +73.1%       1476 ± 66%  interrupts.CPU145.CAL:Function_call_interrupts
     49240 ±  3%    +976.4%     530009 ± 24%  interrupts.CPU145.LOC:Local_timer_interrupts
      1.00 ± 70%  +65025.0%     651.25 ±170%  interrupts.CPU145.RES:Rescheduling_interrupts
     49234 ±  3%    +976.3%     529907 ± 24%  interrupts.CPU146.LOC:Local_timer_interrupts
      1.75 ± 74%  +57600.0%       1009 ±171%  interrupts.CPU146.RES:Rescheduling_interrupts
     49231 ±  3%    +976.5%     529979 ± 24%  interrupts.CPU147.LOC:Local_timer_interrupts
      1.75 ± 84%  +23085.7%     405.75 ±161%  interrupts.CPU147.RES:Rescheduling_interrupts
    849.75 ±  4%     +97.5%       1678 ± 79%  interrupts.CPU148.CAL:Function_call_interrupts
     49231 ±  3%    +977.0%     530203 ± 24%  interrupts.CPU148.LOC:Local_timer_interrupts
      2.00 ± 61%  +45387.5%     909.75 ±167%  interrupts.CPU148.RES:Rescheduling_interrupts
    861.00 ±  2%     +72.4%       1484 ± 65%  interrupts.CPU149.CAL:Function_call_interrupts
     49230 ±  3%    +976.8%     530110 ± 24%  interrupts.CPU149.LOC:Local_timer_interrupts
      1.75 ± 47%  +33414.3%     586.50 ±168%  interrupts.CPU149.RES:Rescheduling_interrupts
     49385 ±  3%    +984.8%     535734 ± 22%  interrupts.CPU15.LOC:Local_timer_interrupts
      0.25 ±173%  +1.6e+05%     392.00 ± 91%  interrupts.CPU15.NMI:Non-maskable_interrupts
      0.25 ±173%  +1.6e+05%     392.00 ± 91%  interrupts.CPU15.PMI:Performance_monitoring_interrupts
     49233 ±  3%    +976.8%     530160 ± 24%  interrupts.CPU150.LOC:Local_timer_interrupts
      1.75 ± 47%  +44571.4%     781.75 ±167%  interrupts.CPU150.RES:Rescheduling_interrupts
     49234 ±  3%    +977.4%     530438 ± 24%  interrupts.CPU151.LOC:Local_timer_interrupts
      2.00 ± 79%  +36600.0%     734.00 ±166%  interrupts.CPU151.RES:Rescheduling_interrupts
    859.75 ±  3%    +139.2%       2056 ± 70%  interrupts.CPU152.CAL:Function_call_interrupts
     49244 ±  3%    +977.2%     530471 ± 24%  interrupts.CPU152.LOC:Local_timer_interrupts
      1.75 ± 74%  +58214.3%       1020 ±169%  interrupts.CPU152.RES:Rescheduling_interrupts
     49242 ±  3%    +976.2%     529944 ± 24%  interrupts.CPU153.LOC:Local_timer_interrupts
     49231 ±  3%    +976.3%     529853 ± 24%  interrupts.CPU154.LOC:Local_timer_interrupts
    861.50 ±  3%     +99.8%       1721 ± 81%  interrupts.CPU155.CAL:Function_call_interrupts
     49232 ±  3%    +976.2%     529830 ± 24%  interrupts.CPU155.LOC:Local_timer_interrupts
      2.00 ± 61%  +41700.0%     836.00 ±170%  interrupts.CPU155.RES:Rescheduling_interrupts
    846.50 ±  3%    +136.5%       2002 ± 95%  interrupts.CPU156.CAL:Function_call_interrupts
     49230 ±  3%    +977.4%     530387 ± 24%  interrupts.CPU156.LOC:Local_timer_interrupts
      2.25 ±110%  +57455.6%       1295 ±172%  interrupts.CPU156.RES:Rescheduling_interrupts
     49229 ±  3%    +977.1%     530266 ± 24%  interrupts.CPU157.LOC:Local_timer_interrupts
      1.50 ±137%  +97883.3%       1469 ±171%  interrupts.CPU157.RES:Rescheduling_interrupts
     49230 ±  3%    +976.5%     529955 ± 24%  interrupts.CPU158.LOC:Local_timer_interrupts
      1.50 ±100%    +1e+05%       1546 ±171%  interrupts.CPU158.RES:Rescheduling_interrupts
     49242 ±  3%    +976.6%     530162 ± 24%  interrupts.CPU159.LOC:Local_timer_interrupts
      1.25 ± 66%  +1.2e+05%       1515 ±172%  interrupts.CPU159.RES:Rescheduling_interrupts
    834.75 ±  2%    +240.9%       2845 ± 54%  interrupts.CPU16.CAL:Function_call_interrupts
     49318 ±  3%    +985.0%     535107 ± 22%  interrupts.CPU16.LOC:Local_timer_interrupts
      1.50 ± 57%  +1.7e+05%       2587 ± 86%  interrupts.CPU16.RES:Rescheduling_interrupts
    854.00 ±  3%     +69.0%       1443 ± 64%  interrupts.CPU160.CAL:Function_call_interrupts
     49229 ±  3%    +977.1%     530250 ± 24%  interrupts.CPU160.LOC:Local_timer_interrupts
      0.75 ± 57%  +76633.3%     575.50 ±171%  interrupts.CPU160.RES:Rescheduling_interrupts
    865.00 ±  4%    +191.4%       2520 ±110%  interrupts.CPU161.CAL:Function_call_interrupts
     49229 ±  3%    +977.0%     530180 ± 24%  interrupts.CPU161.LOC:Local_timer_interrupts
      1.75 ± 62%  +95642.9%       1675 ±172%  interrupts.CPU161.RES:Rescheduling_interrupts
     49231 ±  3%    +976.4%     529906 ± 24%  interrupts.CPU162.LOC:Local_timer_interrupts
     49737 ±  4%    +965.5%     529926 ± 24%  interrupts.CPU163.LOC:Local_timer_interrupts
      2.00 ± 35%  +55175.0%       1105 ±172%  interrupts.CPU163.RES:Rescheduling_interrupts
     49232 ±  3%    +976.8%     530140 ± 24%  interrupts.CPU164.LOC:Local_timer_interrupts
     49231 ±  3%    +976.8%     530124 ± 24%  interrupts.CPU165.LOC:Local_timer_interrupts
      0.25 ±173%  +8.5e+05%       2134 ±172%  interrupts.CPU165.RES:Rescheduling_interrupts
    867.25 ±  3%    +138.7%       2070 ± 61%  interrupts.CPU166.CAL:Function_call_interrupts
     49229 ±  3%    +977.3%     530338 ± 24%  interrupts.CPU166.LOC:Local_timer_interrupts
      0.50 ±173%  +29000.0%     145.50 ± 26%  interrupts.CPU166.NMI:Non-maskable_interrupts
      0.50 ±173%  +29000.0%     145.50 ± 26%  interrupts.CPU166.PMI:Performance_monitoring_interrupts
      1.75 ± 47%  +63400.0%       1111 ±126%  interrupts.CPU166.RES:Rescheduling_interrupts
    846.25 ±  4%     +15.2%     974.75 ± 13%  interrupts.CPU167.CAL:Function_call_interrupts
     49230 ±  3%    +976.9%     530156 ± 24%  interrupts.CPU167.LOC:Local_timer_interrupts
      1.25 ± 66%   +7940.0%     100.50 ±150%  interrupts.CPU167.RES:Rescheduling_interrupts
     49280 ±  3%    +977.0%     530766 ± 23%  interrupts.CPU168.LOC:Local_timer_interrupts
     49295 ±  3%    +977.3%     531046 ± 23%  interrupts.CPU169.LOC:Local_timer_interrupts
    838.75          +383.2%       4053 ± 68%  interrupts.CPU17.CAL:Function_call_interrupts
     49310 ±  3%    +986.6%     535789 ± 22%  interrupts.CPU17.LOC:Local_timer_interrupts
      1.75 ± 47%  +1.9e+05%       3398 ±104%  interrupts.CPU17.RES:Rescheduling_interrupts
     49318 ±  3%    +985.5%     535352 ± 22%  interrupts.CPU170.LOC:Local_timer_interrupts
     49299 ±  3%    +977.7%     531310 ± 23%  interrupts.CPU171.LOC:Local_timer_interrupts
     49316 ±  3%    +976.6%     530933 ± 23%  interrupts.CPU172.LOC:Local_timer_interrupts
     49258 ±  3%    +977.8%     530893 ± 23%  interrupts.CPU173.LOC:Local_timer_interrupts
     49244 ±  3%    +977.8%     530761 ± 23%  interrupts.CPU174.LOC:Local_timer_interrupts
     49249 ±  3%    +983.5%     533635 ± 22%  interrupts.CPU175.LOC:Local_timer_interrupts
      1.75 ±173%  +10557.1%     186.50 ± 20%  interrupts.CPU175.NMI:Non-maskable_interrupts
      1.75 ±173%  +10557.1%     186.50 ± 20%  interrupts.CPU175.PMI:Performance_monitoring_interrupts
     49251 ±  3%    +978.1%     530997 ± 23%  interrupts.CPU176.LOC:Local_timer_interrupts
     49280 ±  3%    +977.6%     531024 ± 23%  interrupts.CPU177.LOC:Local_timer_interrupts
     49257 ±  3%    +978.0%     530974 ± 23%  interrupts.CPU178.LOC:Local_timer_interrupts
     49262 ±  3%    +977.7%     530914 ± 23%  interrupts.CPU179.LOC:Local_timer_interrupts
    817.75 ±  2%    +338.9%       3589 ±104%  interrupts.CPU18.CAL:Function_call_interrupts
     49319 ±  3%    +986.4%     535796 ± 22%  interrupts.CPU18.LOC:Local_timer_interrupts
     49258 ±  3%    +977.9%     530945 ± 23%  interrupts.CPU180.LOC:Local_timer_interrupts
     49265 ±  3%    +977.4%     530813 ± 23%  interrupts.CPU181.LOC:Local_timer_interrupts
      0.75 ±173%  +24666.7%     185.75 ± 21%  interrupts.CPU181.NMI:Non-maskable_interrupts
      1.00 ±173%  +18475.0%     185.75 ± 21%  interrupts.CPU181.PMI:Performance_monitoring_interrupts
     49255 ±  3%    +976.8%     530355 ± 24%  interrupts.CPU182.LOC:Local_timer_interrupts
      0.25 ±173%  +41200.0%     103.25 ±163%  interrupts.CPU182.RES:Rescheduling_interrupts
     49261 ±  3%    +977.8%     530924 ± 23%  interrupts.CPU183.LOC:Local_timer_interrupts
     49261 ±  3%    +976.9%     530468 ± 24%  interrupts.CPU184.LOC:Local_timer_interrupts
     49256 ±  3%    +977.2%     530580 ± 24%  interrupts.CPU185.LOC:Local_timer_interrupts
     49239 ±  3%    +976.7%     530145 ± 24%  interrupts.CPU186.LOC:Local_timer_interrupts
     49253 ±  3%    +976.7%     530291 ± 24%  interrupts.CPU187.LOC:Local_timer_interrupts
      0.75 ±173%  +17800.0%     134.25 ± 36%  interrupts.CPU187.NMI:Non-maskable_interrupts
      0.75 ±173%  +17800.0%     134.25 ± 36%  interrupts.CPU187.PMI:Performance_monitoring_interrupts
    201.25 ± 21%     -49.7%     101.25 ± 53%  interrupts.CPU187.TLB:TLB_shootdowns
     49258 ±  3%    +975.9%     529965 ± 24%  interrupts.CPU188.LOC:Local_timer_interrupts
     49243 ±  3%    +976.4%     530057 ± 24%  interrupts.CPU189.LOC:Local_timer_interrupts
    845.00 ±  2%    +373.0%       3997 ± 77%  interrupts.CPU19.CAL:Function_call_interrupts
     49293 ±  3%    +986.8%     535726 ± 22%  interrupts.CPU19.LOC:Local_timer_interrupts
      0.50 ±173%  +62850.0%     314.75 ± 56%  interrupts.CPU19.NMI:Non-maskable_interrupts
      0.50 ±173%  +62850.0%     314.75 ± 56%  interrupts.CPU19.PMI:Performance_monitoring_interrupts
     49253 ±  3%    +977.3%     530619 ± 23%  interrupts.CPU190.LOC:Local_timer_interrupts
      4.25 ± 73%   +1882.4%      84.25 ±150%  interrupts.CPU190.RES:Rescheduling_interrupts
     49292 ±  3%    +976.9%     530802 ± 24%  interrupts.CPU191.LOC:Local_timer_interrupts
      1.00        +10875.0%     109.75 ± 10%  interrupts.CPU191.NMI:Non-maskable_interrupts
      1.00        +10875.0%     109.75 ± 10%  interrupts.CPU191.PMI:Performance_monitoring_interrupts
     49407 ±  3%    +986.3%     536729 ± 21%  interrupts.CPU2.LOC:Local_timer_interrupts
     15.75 ± 83%   +2901.6%     472.75 ±128%  interrupts.CPU2.RES:Rescheduling_interrupts
    880.50 ± 12%    +327.7%       3766 ± 46%  interrupts.CPU20.CAL:Function_call_interrupts
     49280 ±  3%    +989.2%     536784 ± 21%  interrupts.CPU20.LOC:Local_timer_interrupts
      2.50 ± 44%  +1.3e+05%       3186 ± 74%  interrupts.CPU20.RES:Rescheduling_interrupts
    840.25 ±  3%    +449.4%       4616 ± 52%  interrupts.CPU21.CAL:Function_call_interrupts
     49301 ±  3%    +988.3%     536547 ± 21%  interrupts.CPU21.LOC:Local_timer_interrupts
      0.25 ±173%  +3.1e+05%     771.25 ± 94%  interrupts.CPU21.NMI:Non-maskable_interrupts
      0.25 ±173%  +3.1e+05%     771.25 ± 94%  interrupts.CPU21.PMI:Performance_monitoring_interrupts
      3.50 ±111%  +96621.4%       3385 ±102%  interrupts.CPU21.RES:Rescheduling_interrupts
     49349 ±  3%    +984.7%     535289 ± 22%  interrupts.CPU22.LOC:Local_timer_interrupts
      1.75 ± 74%  +1.9e+05%       3255 ± 87%  interrupts.CPU22.RES:Rescheduling_interrupts
    830.75 ±  2%    +289.2%       3233 ± 60%  interrupts.CPU23.CAL:Function_call_interrupts
     49327 ±  3%    +987.0%     536170 ± 21%  interrupts.CPU23.LOC:Local_timer_interrupts
      0.25 ±173%  +1.7e+05%     435.75 ± 95%  interrupts.CPU23.NMI:Non-maskable_interrupts
      0.25 ±173%  +1.7e+05%     435.75 ± 95%  interrupts.CPU23.PMI:Performance_monitoring_interrupts
      3.25 ± 70%  +94638.5%       3079 ± 90%  interrupts.CPU23.RES:Rescheduling_interrupts
     49319 ±  3%   +1101.4%     592500 ±  3%  interrupts.CPU24.LOC:Local_timer_interrupts
      2.25 ± 48%  +15066.7%     341.25 ±167%  interrupts.CPU24.RES:Rescheduling_interrupts
     49277 ±  3%   +1103.6%     593107 ±  3%  interrupts.CPU25.LOC:Local_timer_interrupts
      0.50 ±100%  +25600.0%     128.50 ±157%  interrupts.CPU25.RES:Rescheduling_interrupts
    810.75 ±  2%    +769.0%       7045 ±147%  interrupts.CPU26.CAL:Function_call_interrupts
     49295 ±  3%   +1102.1%     592559 ±  3%  interrupts.CPU26.LOC:Local_timer_interrupts
      0.00       +1.9e+104%     189.00 ± 33%  interrupts.CPU26.NMI:Non-maskable_interrupts
      0.00       +1.9e+104%     189.00 ± 33%  interrupts.CPU26.PMI:Performance_monitoring_interrupts
      0.75 ±110%  +20766.7%     156.50 ±162%  interrupts.CPU26.RES:Rescheduling_interrupts
    876.25 ± 10%   +1298.6%      12255 ±143%  interrupts.CPU27.CAL:Function_call_interrupts
     49253 ±  3%   +1102.4%     592217 ±  3%  interrupts.CPU27.LOC:Local_timer_interrupts
      0.00       +1.7e+104%     172.50 ± 37%  interrupts.CPU27.NMI:Non-maskable_interrupts
      0.00       +1.7e+104%     172.50 ± 37%  interrupts.CPU27.PMI:Performance_monitoring_interrupts
      2.25 ± 72%   +9722.2%     221.00 ±160%  interrupts.CPU27.RES:Rescheduling_interrupts
     49252 ±  3%   +1100.1%     591086 ±  3%  interrupts.CPU28.LOC:Local_timer_interrupts
      0.50 ±100%  +35800.0%     179.50 ±165%  interrupts.CPU28.RES:Rescheduling_interrupts
     49288 ±  3%   +1099.7%     591292 ±  3%  interrupts.CPU29.LOC:Local_timer_interrupts
      1.25 ±103%   +9940.0%     125.50 ±161%  interrupts.CPU29.RES:Rescheduling_interrupts
     49318 ±  3%    +990.2%     537664 ± 22%  interrupts.CPU3.LOC:Local_timer_interrupts
      0.25 ±173%  +2.5e+05%     628.25 ± 66%  interrupts.CPU3.NMI:Non-maskable_interrupts
      0.25 ±173%  +2.5e+05%     628.25 ± 66%  interrupts.CPU3.PMI:Performance_monitoring_interrupts
     13.75 ± 78%   +5141.8%     720.75 ± 93%  interrupts.CPU3.RES:Rescheduling_interrupts
     49291 ±  3%   +1101.3%     592123 ±  3%  interrupts.CPU30.LOC:Local_timer_interrupts
      0.25 ±173%  +81200.0%     203.25 ±165%  interrupts.CPU30.RES:Rescheduling_interrupts
     49290 ±  3%   +1102.1%     592509 ±  3%  interrupts.CPU31.LOC:Local_timer_interrupts
      0.25 ±173%  +70300.0%     176.00 ± 19%  interrupts.CPU31.NMI:Non-maskable_interrupts
      0.25 ±173%  +70300.0%     176.00 ± 19%  interrupts.CPU31.PMI:Performance_monitoring_interrupts
      0.25 ±173%  +96300.0%     241.00 ±167%  interrupts.CPU31.RES:Rescheduling_interrupts
     49275 ±  3%   +1100.9%     591757 ±  3%  interrupts.CPU32.LOC:Local_timer_interrupts
    829.00           +82.7%       1514 ± 66%  interrupts.CPU33.CAL:Function_call_interrupts
     49261 ±  3%   +1096.7%     589490 ±  4%  interrupts.CPU33.LOC:Local_timer_interrupts
      0.25 ±173%  +70500.0%     176.50 ± 20%  interrupts.CPU33.NMI:Non-maskable_interrupts
      0.25 ±173%  +70500.0%     176.50 ± 20%  interrupts.CPU33.PMI:Performance_monitoring_interrupts
      1.00 ± 70%  +11100.0%     112.00 ±144%  interrupts.CPU33.RES:Rescheduling_interrupts
     49275 ±  3%   +1096.4%     589503 ±  4%  interrupts.CPU34.LOC:Local_timer_interrupts
      3.00 ±122%   +2333.3%      73.00 ±147%  interrupts.CPU34.RES:Rescheduling_interrupts
    816.00 ±  2%    +120.3%       1798 ± 87%  interrupts.CPU35.CAL:Function_call_interrupts
     49277 ±  3%   +1099.3%     590974 ±  3%  interrupts.CPU35.LOC:Local_timer_interrupts
      1.25 ± 87%  +12140.0%     153.00 ±155%  interrupts.CPU35.RES:Rescheduling_interrupts
     50.00 ± 90%    +548.5%     324.25 ±115%  interrupts.CPU35.TLB:TLB_shootdowns
     49271 ±  3%   +1094.2%     588423 ±  4%  interrupts.CPU36.LOC:Local_timer_interrupts
      0.75 ±110%  +28466.7%     214.25 ±159%  interrupts.CPU36.RES:Rescheduling_interrupts
     49275 ±  3%   +1100.6%     591617 ±  3%  interrupts.CPU37.LOC:Local_timer_interrupts
      1.50 ±100%   +8150.0%     123.75 ±162%  interrupts.CPU37.RES:Rescheduling_interrupts
    830.00 ±  2%    +121.1%       1835 ± 87%  interrupts.CPU38.CAL:Function_call_interrupts
     49271 ±  3%   +1100.3%     591415 ±  3%  interrupts.CPU38.LOC:Local_timer_interrupts
      0.75 ±173%  +25933.3%     195.25 ±165%  interrupts.CPU38.RES:Rescheduling_interrupts
     49257 ±  3%   +1099.4%     590788 ±  3%  interrupts.CPU39.LOC:Local_timer_interrupts
      1.50 ±100%  +17783.3%     268.25 ±167%  interrupts.CPU39.RES:Rescheduling_interrupts
     49326 ±  3%    +989.1%     537216 ± 21%  interrupts.CPU4.LOC:Local_timer_interrupts
      9.75 ± 74%  +11100.0%       1092 ± 98%  interrupts.CPU4.RES:Rescheduling_interrupts
     49270 ±  3%   +1103.2%     592804 ±  3%  interrupts.CPU40.LOC:Local_timer_interrupts
      2.00 ±117%  +86125.0%       1724 ±172%  interrupts.CPU40.RES:Rescheduling_interrupts
    833.75 ±  2%    +108.8%       1741 ± 83%  interrupts.CPU41.CAL:Function_call_interrupts
     49275 ±  3%   +1097.8%     590204 ±  4%  interrupts.CPU41.LOC:Local_timer_interrupts
     49276 ±  3%   +1099.1%     590869 ±  3%  interrupts.CPU42.LOC:Local_timer_interrupts
     49273 ±  3%   +1101.7%     592123 ±  3%  interrupts.CPU43.LOC:Local_timer_interrupts
      0.25 ±173%    +2e+05%     491.50 ±171%  interrupts.CPU43.RES:Rescheduling_interrupts
     49301 ±  3%   +1094.9%     589108 ±  4%  interrupts.CPU44.LOC:Local_timer_interrupts
     49291 ±  3%   +1097.1%     590062 ±  4%  interrupts.CPU45.LOC:Local_timer_interrupts
      0.75 ± 57%  +1.1e+05%     852.75 ±172%  interrupts.CPU45.RES:Rescheduling_interrupts
    831.25          +132.2%       1930 ± 92%  interrupts.CPU46.CAL:Function_call_interrupts
     49293 ±  3%   +1095.6%     589326 ±  4%  interrupts.CPU46.LOC:Local_timer_interrupts
     49281 ±  3%   +1098.3%     590561 ±  3%  interrupts.CPU47.LOC:Local_timer_interrupts
      1.50 ±110%  +33666.7%     506.50 ±170%  interrupts.CPU47.RES:Rescheduling_interrupts
    824.75 ±  3%     +67.5%       1381 ± 60%  interrupts.CPU48.CAL:Function_call_interrupts
     49218 ±  3%    +987.0%     534997 ± 24%  interrupts.CPU48.LOC:Local_timer_interrupts
      3.00 ± 62%  +10675.0%     323.25 ±162%  interrupts.CPU48.RES:Rescheduling_interrupts
     49268 ±  3%    +976.0%     530106 ± 24%  interrupts.CPU49.LOC:Local_timer_interrupts
      1.25 ±103%   +9880.0%     124.75 ±150%  interrupts.CPU49.RES:Rescheduling_interrupts
     49370 ±  3%    +986.9%     536578 ± 21%  interrupts.CPU5.LOC:Local_timer_interrupts
      0.25 ±173%  +1.2e+05%     301.25 ± 28%  interrupts.CPU5.NMI:Non-maskable_interrupts
      0.25 ±173%  +1.2e+05%     301.25 ± 28%  interrupts.CPU5.PMI:Performance_monitoring_interrupts
     12.25 ±114%   +5344.9%     667.00 ± 92%  interrupts.CPU5.RES:Rescheduling_interrupts
     49249 ±  3%    +976.2%     530004 ± 24%  interrupts.CPU50.LOC:Local_timer_interrupts
      1.50 ± 74%  +57133.3%     858.50 ±170%  interrupts.CPU50.RES:Rescheduling_interrupts
    816.00          +121.5%       1807 ± 89%  interrupts.CPU51.CAL:Function_call_interrupts
     49248 ±  3%    +976.5%     530166 ± 24%  interrupts.CPU51.LOC:Local_timer_interrupts
      1.25 ± 34%  +30040.0%     376.75 ±167%  interrupts.CPU51.RES:Rescheduling_interrupts
    820.25 ±  2%     +82.7%       1498 ± 70%  interrupts.CPU52.CAL:Function_call_interrupts
     49250 ±  3%    +976.4%     530138 ± 24%  interrupts.CPU52.LOC:Local_timer_interrupts
      0.25 ±173%  +54600.0%     136.75 ± 29%  interrupts.CPU52.NMI:Non-maskable_interrupts
      0.25 ±173%  +54600.0%     136.75 ± 29%  interrupts.CPU52.PMI:Performance_monitoring_interrupts
      1.50 ± 57%  +12666.7%     191.50 ±160%  interrupts.CPU52.RES:Rescheduling_interrupts
     49249 ±  3%    +976.6%     530214 ± 24%  interrupts.CPU53.LOC:Local_timer_interrupts
      1.00 ± 70%  +44050.0%     441.50 ±167%  interrupts.CPU53.RES:Rescheduling_interrupts
    815.25 ±  2%     +88.4%       1536 ± 74%  interrupts.CPU54.CAL:Function_call_interrupts
     49268 ±  3%    +976.4%     530302 ± 24%  interrupts.CPU54.LOC:Local_timer_interrupts
      1.75 ± 47%  +11771.4%     207.75 ±163%  interrupts.CPU54.RES:Rescheduling_interrupts
    821.25          +155.8%       2100 ±100%  interrupts.CPU55.CAL:Function_call_interrupts
     49247 ±  3%    +977.2%     530483 ± 24%  interrupts.CPU55.LOC:Local_timer_interrupts
      1.75 ± 47%  +21528.6%     378.50 ±167%  interrupts.CPU55.RES:Rescheduling_interrupts
     49230 ±  3%    +977.6%     530504 ± 24%  interrupts.CPU56.LOC:Local_timer_interrupts
      1.25 ± 66%  +29400.0%     368.75 ±168%  interrupts.CPU56.RES:Rescheduling_interrupts
    819.50          +180.4%       2298 ±106%  interrupts.CPU57.CAL:Function_call_interrupts
     49244 ±  3%    +976.7%     530203 ± 24%  interrupts.CPU57.LOC:Local_timer_interrupts
      0.25 ±173%  +94600.0%     236.75 ± 70%  interrupts.CPU57.NMI:Non-maskable_interrupts
      0.25 ±173%  +94600.0%     236.75 ± 70%  interrupts.CPU57.PMI:Performance_monitoring_interrupts
      1.50 ± 74%  +32066.7%     482.50 ±169%  interrupts.CPU57.RES:Rescheduling_interrupts
     49308 ±  3%    +975.0%     530051 ± 24%  interrupts.CPU58.LOC:Local_timer_interrupts
      0.25 ±173%    +1e+05%     256.50 ± 79%  interrupts.CPU58.NMI:Non-maskable_interrupts
      0.25 ±173%    +1e+05%     256.50 ± 79%  interrupts.CPU58.PMI:Performance_monitoring_interrupts
      3.50 ± 84%  +12007.1%     423.75 ±167%  interrupts.CPU58.RES:Rescheduling_interrupts
    817.50          +103.4%       1663 ± 79%  interrupts.CPU59.CAL:Function_call_interrupts
     49266 ±  3%    +975.9%     530043 ± 24%  interrupts.CPU59.LOC:Local_timer_interrupts
      2.00 ± 35%  +14050.0%     283.00 ±158%  interrupts.CPU59.RES:Rescheduling_interrupts
     49309 ±  3%    +988.0%     536501 ± 21%  interrupts.CPU6.LOC:Local_timer_interrupts
      8.25 ± 95%   +9421.2%     785.50 ± 95%  interrupts.CPU6.RES:Rescheduling_interrupts
    826.75 ±  4%    +137.0%       1959 ± 94%  interrupts.CPU60.CAL:Function_call_interrupts
     49247 ±  3%    +977.2%     530470 ± 24%  interrupts.CPU60.LOC:Local_timer_interrupts
      2.25 ±148%  +19777.8%     447.25 ±159%  interrupts.CPU60.RES:Rescheduling_interrupts
     49247 ±  3%    +976.9%     530345 ± 24%  interrupts.CPU61.LOC:Local_timer_interrupts
      1.50 ± 33%  +10083.3%     152.75 ±163%  interrupts.CPU61.RES:Rescheduling_interrupts
    824.50 ±  3%    +107.1%       1707 ± 82%  interrupts.CPU62.CAL:Function_call_interrupts
     49247 ±  3%    +976.6%     530191 ± 24%  interrupts.CPU62.LOC:Local_timer_interrupts
      0.25 ±173%  +77000.0%     192.75 ± 49%  interrupts.CPU62.NMI:Non-maskable_interrupts
      0.25 ±173%  +77000.0%     192.75 ± 49%  interrupts.CPU62.PMI:Performance_monitoring_interrupts
      1.50 ±100%  +17050.0%     257.25 ±162%  interrupts.CPU62.RES:Rescheduling_interrupts
    819.50 ±  2%    +121.9%       1818 ± 78%  interrupts.CPU63.CAL:Function_call_interrupts
     49245 ±  3%    +976.9%     530307 ± 24%  interrupts.CPU63.LOC:Local_timer_interrupts
      0.25 ±173%  +1.3e+05%     335.25 ±158%  interrupts.CPU63.RES:Rescheduling_interrupts
    811.25          +100.0%       1622 ± 78%  interrupts.CPU64.CAL:Function_call_interrupts
     49168 ±  3%    +979.1%     530566 ± 24%  interrupts.CPU64.LOC:Local_timer_interrupts
      1.50 ±110%  +47833.3%     719.00 ±168%  interrupts.CPU64.RES:Rescheduling_interrupts
    846.50 ±  3%     +56.6%       1326 ± 54%  interrupts.CPU65.CAL:Function_call_interrupts
     49257 ±  3%    +976.8%     530382 ± 24%  interrupts.CPU65.LOC:Local_timer_interrupts
    811.75           +96.9%       1598 ± 43%  interrupts.CPU66.CAL:Function_call_interrupts
     49255 ±  3%    +976.3%     530149 ± 24%  interrupts.CPU66.LOC:Local_timer_interrupts
    820.75 ±  3%     +77.7%       1458 ± 37%  interrupts.CPU67.CAL:Function_call_interrupts
     49265 ±  3%    +976.1%     530131 ± 24%  interrupts.CPU67.LOC:Local_timer_interrupts
      3.00 ±122%  +10550.0%     319.50 ±165%  interrupts.CPU67.RES:Rescheduling_interrupts
    805.25           +63.9%       1319 ± 57%  interrupts.CPU68.CAL:Function_call_interrupts
     49248 ±  3%    +976.8%     530330 ± 24%  interrupts.CPU68.LOC:Local_timer_interrupts
      1.75 ± 84%  +24000.0%     421.75 ±159%  interrupts.CPU68.RES:Rescheduling_interrupts
    830.00 ±  3%     +49.3%       1239 ± 47%  interrupts.CPU69.CAL:Function_call_interrupts
     49270 ±  3%    +976.2%     530235 ± 24%  interrupts.CPU69.LOC:Local_timer_interrupts
      1.00 ± 70%  +32800.0%     329.00 ±166%  interrupts.CPU69.RES:Rescheduling_interrupts
     49299 ±  3%    +998.3%     541453 ± 22%  interrupts.CPU7.LOC:Local_timer_interrupts
     11.75 ± 87%   +4563.8%     548.00 ± 95%  interrupts.CPU7.RES:Rescheduling_interrupts
    836.50           +79.2%       1499 ± 70%  interrupts.CPU70.CAL:Function_call_interrupts
     49154 ±  3%    +979.2%     530495 ± 24%  interrupts.CPU70.LOC:Local_timer_interrupts
      1.25 ±131%  +48500.0%     607.50 ±169%  interrupts.CPU70.RES:Rescheduling_interrupts
    815.75 ±  2%     +51.0%       1232 ± 47%  interrupts.CPU71.CAL:Function_call_interrupts
     49318 ±  3%    +975.3%     530324 ± 24%  interrupts.CPU71.LOC:Local_timer_interrupts
      1.75 ± 84%  +18185.7%     320.00 ±166%  interrupts.CPU71.RES:Rescheduling_interrupts
     49174 ±  3%    +979.5%     530831 ± 23%  interrupts.CPU72.LOC:Local_timer_interrupts
     49328 ±  3%    +976.8%     531165 ± 23%  interrupts.CPU73.LOC:Local_timer_interrupts
     49291 ±  3%    +977.2%     530967 ± 23%  interrupts.CPU74.LOC:Local_timer_interrupts
     49322 ±  3%    +975.3%     530368 ± 24%  interrupts.CPU75.LOC:Local_timer_interrupts
    144.50 ± 26%     -58.0%      60.75 ± 63%  interrupts.CPU75.TLB:TLB_shootdowns
     49584 ±  2%    +969.9%     530478 ± 24%  interrupts.CPU76.LOC:Local_timer_interrupts
     49412 ±  2%    +974.6%     530972 ± 23%  interrupts.CPU77.LOC:Local_timer_interrupts
     49307 ±  3%    +977.0%     531020 ± 23%  interrupts.CPU78.LOC:Local_timer_interrupts
     49278 ±  3%    +975.8%     530161 ± 24%  interrupts.CPU79.LOC:Local_timer_interrupts
     49364 ±  3%    +987.4%     536767 ± 21%  interrupts.CPU8.LOC:Local_timer_interrupts
     11.00 ±133%   +5561.4%     622.75 ± 88%  interrupts.CPU8.RES:Rescheduling_interrupts
     49281 ±  3%    +977.3%     530889 ± 23%  interrupts.CPU80.LOC:Local_timer_interrupts
     49273 ±  3%    +977.7%     531031 ± 23%  interrupts.CPU81.LOC:Local_timer_interrupts
    157.50 ± 16%     -57.9%      66.25 ± 74%  interrupts.CPU81.TLB:TLB_shootdowns
     49277 ±  3%    +977.1%     530767 ± 23%  interrupts.CPU82.LOC:Local_timer_interrupts
     49260 ±  3%    +977.9%     530978 ± 23%  interrupts.CPU83.LOC:Local_timer_interrupts
    140.50 ± 26%     -42.9%      80.25 ± 40%  interrupts.CPU83.TLB:TLB_shootdowns
     49277 ±  3%    +977.5%     530986 ± 23%  interrupts.CPU84.LOC:Local_timer_interrupts
     49276 ±  3%    +977.1%     530739 ± 23%  interrupts.CPU85.LOC:Local_timer_interrupts
     49275 ±  3%    +976.3%     530357 ± 24%  interrupts.CPU86.LOC:Local_timer_interrupts
     49271 ±  3%    +976.2%     530266 ± 24%  interrupts.CPU87.LOC:Local_timer_interrupts
     49286 ±  3%    +976.2%     530422 ± 24%  interrupts.CPU88.LOC:Local_timer_interrupts
     49277 ±  3%    +975.9%     530159 ± 24%  interrupts.CPU89.LOC:Local_timer_interrupts
     49337 ±  3%    +989.1%     537342 ± 21%  interrupts.CPU9.LOC:Local_timer_interrupts
     20.75 ± 99%   +3696.4%     787.75 ± 85%  interrupts.CPU9.RES:Rescheduling_interrupts
     49269 ±  3%    +976.4%     530355 ± 24%  interrupts.CPU90.LOC:Local_timer_interrupts
     49279 ±  3%    +977.8%     531115 ± 23%  interrupts.CPU91.LOC:Local_timer_interrupts
      0.25 ±173%  +74400.0%     186.25 ± 18%  interrupts.CPU91.NMI:Non-maskable_interrupts
      0.25 ±173%  +74400.0%     186.25 ± 18%  interrupts.CPU91.PMI:Performance_monitoring_interrupts
    148.00 ± 28%     -76.9%      34.25 ± 23%  interrupts.CPU91.TLB:TLB_shootdowns
     49272 ±  3%    +977.3%     530826 ± 23%  interrupts.CPU92.LOC:Local_timer_interrupts
     49273 ±  3%    +976.4%     530359 ± 24%  interrupts.CPU93.LOC:Local_timer_interrupts
     49289 ±  3%    +976.2%     530443 ± 24%  interrupts.CPU94.LOC:Local_timer_interrupts
     49305 ±  3%    +976.6%     530812 ± 23%  interrupts.CPU95.LOC:Local_timer_interrupts
     49303 ±  3%    +986.8%     535801 ± 22%  interrupts.CPU96.LOC:Local_timer_interrupts
      0.25 ±173%  +1.1e+05%     275.50 ± 54%  interrupts.CPU96.NMI:Non-maskable_interrupts
      0.25 ±173%  +1.1e+05%     275.50 ± 54%  interrupts.CPU96.PMI:Performance_monitoring_interrupts
     15.25 ±150%  +15845.9%       2431 ±106%  interrupts.CPU96.RES:Rescheduling_interrupts
    895.25 ±  5%    +310.1%       3671 ± 77%  interrupts.CPU97.CAL:Function_call_interrupts
     49280 ±  3%    +987.5%     535931 ± 22%  interrupts.CPU97.LOC:Local_timer_interrupts
      0.75 ±110%  +67700.0%     508.50 ± 81%  interrupts.CPU97.NMI:Non-maskable_interrupts
      0.75 ±110%  +67700.0%     508.50 ± 81%  interrupts.CPU97.PMI:Performance_monitoring_interrupts
     98.25 ±166%   +3216.8%       3258 ± 99%  interrupts.CPU97.RES:Rescheduling_interrupts
    872.75 ±  4%    +323.6%       3697 ± 74%  interrupts.CPU98.CAL:Function_call_interrupts
     49223 ±  3%    +988.5%     535800 ± 22%  interrupts.CPU98.LOC:Local_timer_interrupts
      0.25 ±173%    +2e+05%     495.75 ± 80%  interrupts.CPU98.NMI:Non-maskable_interrupts
      0.25 ±173%    +2e+05%     495.75 ± 80%  interrupts.CPU98.PMI:Performance_monitoring_interrupts
      7.25 ±126%  +50834.5%       3692 ± 97%  interrupts.CPU98.RES:Rescheduling_interrupts
    859.50          +385.8%       4175 ± 65%  interrupts.CPU99.CAL:Function_call_interrupts
     49463 ±  3%    +991.5%     539879 ± 22%  interrupts.CPU99.LOC:Local_timer_interrupts
      0.25 ±173%  +2.3e+05%     580.50 ± 62%  interrupts.CPU99.NMI:Non-maskable_interrupts
      0.25 ±173%  +2.3e+05%     580.50 ± 62%  interrupts.CPU99.PMI:Performance_monitoring_interrupts
   9460816 ±  3%   +1009.9%   1.05e+08 ± 18%  interrupts.LOC:Local_timer_interrupts
      0.00       +1.9e+104%     192.00        interrupts.MCP:Machine_check_polls
     16.50 ± 15%  +3.1e+05%      50541 ± 17%  interrupts.NMI:Non-maskable_interrupts
     16.75 ± 16%    +3e+05%      50541 ± 17%  interrupts.PMI:Performance_monitoring_interrupts
      2453 ± 10%   +7214.2%     179472 ± 23%  interrupts.RES:Rescheduling_interrupts
     28.86 ± 54%     -28.9        0.00        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe
     28.86 ± 54%     -28.9        0.00        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
     50.00 ± 23%     -15.4       34.64 ± 13%  perf-profile.calltrace.cycles-pp.intel_idle.cpuidle_enter_state.cpuidle_enter.do_idle.cpu_startup_entry
     11.82 ± 31%     -11.8        0.00        perf-profile.calltrace.cycles-pp.__libc_start_main
     11.82 ± 31%     -11.8        0.00        perf-profile.calltrace.cycles-pp.main.__libc_start_main
     11.82 ± 31%     -11.8        0.00        perf-profile.calltrace.cycles-pp.run_builtin.main.__libc_start_main
     11.82 ± 31%     -11.8        0.00        perf-profile.calltrace.cycles-pp.cmd_record.run_builtin.main.__libc_start_main
     11.82 ± 31%     -11.8        0.00        perf-profile.calltrace.cycles-pp.perf_mmap__read_head.perf_mmap__push.record__mmap_read_evlist.cmd_record.run_builtin
     11.59 ±128%     -11.6        0.00        perf-profile.calltrace.cycles-pp.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
     11.59 ±128%     -11.6        0.00        perf-profile.calltrace.cycles-pp.proc_reg_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
     11.59 ±128%     -11.6        0.00        perf-profile.calltrace.cycles-pp.seq_read.proc_reg_read.vfs_read.ksys_read.do_syscall_64
     11.59 ±128%     -11.6        0.00        perf-profile.calltrace.cycles-pp.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
     10.00 ±100%     -10.0        0.00        perf-profile.calltrace.cycles-pp.__prepare_exit_to_usermode.do_syscall_64.entry_SYSCALL_64_after_hwframe
     10.00 ±100%     -10.0        0.00        perf-profile.calltrace.cycles-pp.do_signal.__prepare_exit_to_usermode.do_syscall_64.entry_SYSCALL_64_after_hwframe
     10.00 ±100%     -10.0        0.00        perf-profile.calltrace.cycles-pp.get_signal.do_signal.__prepare_exit_to_usermode.do_syscall_64.entry_SYSCALL_64_after_hwframe
     10.00 ±100%     -10.0        0.00        perf-profile.calltrace.cycles-pp.do_group_exit.get_signal.do_signal.__prepare_exit_to_usermode.do_syscall_64
     10.00 ±100%     -10.0        0.00        perf-profile.calltrace.cycles-pp.do_exit.do_group_exit.get_signal.do_signal.__prepare_exit_to_usermode
      9.54 ±  4%      -9.5        0.00        perf-profile.calltrace.cycles-pp.record__mmap_read_evlist.cmd_record.run_builtin.main.__libc_start_main
      9.54 ±  4%      -9.5        0.00        perf-profile.calltrace.cycles-pp.perf_mmap__push.record__mmap_read_evlist.cmd_record.run_builtin.main
      9.54 ± 67%      -9.5        0.00        perf-profile.calltrace.cycles-pp.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      9.54 ±100%      -9.5        0.00        perf-profile.calltrace.cycles-pp.step_into.walk_component.link_path_walk.path_openat.do_filp_open
      7.50 ±110%      -7.5        0.00        perf-profile.calltrace.cycles-pp.mmput.do_exit.do_group_exit.get_signal.do_signal
      7.50 ±110%      -7.5        0.00        perf-profile.calltrace.cycles-pp.exit_mmap.mmput.do_exit.do_group_exit.get_signal
      7.27 ± 57%      -7.3        0.00        perf-profile.calltrace.cycles-pp.asm_exc_page_fault.perf_mmap__read_head.perf_mmap__push.record__mmap_read_evlist.cmd_record
      7.27 ± 57%      -7.3        0.00        perf-profile.calltrace.cycles-pp.exc_page_fault.asm_exc_page_fault.perf_mmap__read_head.perf_mmap__push.record__mmap_read_evlist
      7.27 ± 57%      -7.3        0.00        perf-profile.calltrace.cycles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.perf_mmap__read_head.perf_mmap__push
      7.27 ± 57%      -7.3        0.00        perf-profile.calltrace.cycles-pp.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.perf_mmap__read_head
      7.27 ±113%      -7.3        0.00        perf-profile.calltrace.cycles-pp.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
      7.27 ±113%      -7.3        0.00        perf-profile.calltrace.cycles-pp.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64
      7.27 ±113%      -7.3        0.00        perf-profile.calltrace.cycles-pp.link_path_walk.path_openat.do_filp_open.do_sys_openat2.do_sys_open
      7.27 ±113%      -7.3        0.00        perf-profile.calltrace.cycles-pp.walk_component.link_path_walk.path_openat.do_filp_open.do_sys_openat2
      5.00 ±100%      -5.0        0.00        perf-profile.calltrace.cycles-pp.tlb_finish_mmu.exit_mmap.mmput.do_exit.do_group_exit
      5.00 ±100%      -5.0        0.00        perf-profile.calltrace.cycles-pp.tlb_flush_mmu.tlb_finish_mmu.exit_mmap.mmput.do_exit
      5.00 ±100%      -5.0        0.00        perf-profile.calltrace.cycles-pp.release_pages.tlb_flush_mmu.tlb_finish_mmu.exit_mmap.mmput
      4.77 ±100%      -4.8        0.00        perf-profile.calltrace.cycles-pp.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault
      4.77 ±100%      -4.8        0.00        perf-profile.calltrace.cycles-pp.__do_fault.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      0.00            +0.6        0.59 ± 12%  perf-profile.calltrace.cycles-pp.btrfs_reserve_metadata_bytes.btrfs_delalloc_reserve_metadata.btrfs_buffered_write.btrfs_file_write_iter.new_sync_write
      0.00            +0.6        0.61 ± 12%  perf-profile.calltrace.cycles-pp.btrfs_delalloc_reserve_metadata.btrfs_buffered_write.btrfs_file_write_iter.new_sync_write.vfs_write
      0.00            +0.6        0.65 ± 12%  perf-profile.calltrace.cycles-pp.ktime_get.tick_irq_enter.irq_enter_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      0.00            +0.7        0.67 ± 20%  perf-profile.calltrace.cycles-pp.setup_leaf_for_split.btrfs_duplicate_item.btrfs_mark_extent_written.btrfs_finish_ordered_io.btrfs_work_helper
      0.00            +0.7        0.68 ± 18%  perf-profile.calltrace.cycles-pp.read_extent_buffer.check_leaf.btree_csum_one_bio.btree_submit_bio_hook.submit_one_bio
      0.00            +0.7        0.68 ±  8%  perf-profile.calltrace.cycles-pp.__next_timer_interrupt.get_next_timer_interrupt.tick_nohz_next_event.tick_nohz_get_sleep_length.menu_select
      0.00            +0.7        0.71 ± 14%  perf-profile.calltrace.cycles-pp.perf_mux_hrtimer_handler.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_apic_timer_interrupt.asm_call_on_stack
      0.00            +0.7        0.74 ± 26%  perf-profile.calltrace.cycles-pp.btrfs_cow_block.btrfs_search_slot.btrfs_lookup_csum.btrfs_csum_file_blocks.add_pending_csums
      0.00            +0.7        0.74 ± 26%  perf-profile.calltrace.cycles-pp.__btrfs_cow_block.btrfs_cow_block.btrfs_search_slot.btrfs_lookup_csum.btrfs_csum_file_blocks
      0.00            +0.8        0.83 ± 44%  perf-profile.calltrace.cycles-pp.scheduler_tick.update_process_times.tick_sched_handle.tick_sched_timer.__hrtimer_run_queues
      0.00            +0.9        0.88 ± 27%  perf-profile.calltrace.cycles-pp.btrfs_insert_empty_items.btrfs_csum_file_blocks.add_pending_csums.btrfs_finish_ordered_io.btrfs_work_helper
      0.00            +0.9        0.89 ± 21%  perf-profile.calltrace.cycles-pp.tick_irq_enter.irq_enter_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state
      0.00            +1.0        1.04 ± 10%  perf-profile.calltrace.cycles-pp.get_next_timer_interrupt.tick_nohz_next_event.tick_nohz_get_sleep_length.menu_select.do_idle
      0.00            +1.1        1.06 ± 25%  perf-profile.calltrace.cycles-pp.btrfs_search_slot.btrfs_lookup_file_extent.__btrfs_drop_extents.insert_reserved_file_extent.btrfs_finish_ordered_io
      0.00            +1.1        1.06 ± 25%  perf-profile.calltrace.cycles-pp.btrfs_lookup_file_extent.__btrfs_drop_extents.insert_reserved_file_extent.btrfs_finish_ordered_io.btrfs_work_helper
      0.00            +1.1        1.06 ± 34%  perf-profile.calltrace.cycles-pp.btrfs_cow_block.btrfs_search_slot.btrfs_mark_extent_written.btrfs_finish_ordered_io.btrfs_work_helper
      0.00            +1.1        1.06 ± 34%  perf-profile.calltrace.cycles-pp.__btrfs_cow_block.btrfs_cow_block.btrfs_search_slot.btrfs_mark_extent_written.btrfs_finish_ordered_io
      0.00            +1.1        1.08 ± 21%  perf-profile.calltrace.cycles-pp.btrfs_duplicate_item.btrfs_mark_extent_written.btrfs_finish_ordered_io.btrfs_work_helper.process_one_work
      0.00            +1.1        1.08 ± 23%  perf-profile.calltrace.cycles-pp.btrfs_search_slot.btrfs_lookup_csum.btrfs_csum_file_blocks.add_pending_csums.btrfs_finish_ordered_io
      0.00            +1.1        1.09 ± 23%  perf-profile.calltrace.cycles-pp.btrfs_lookup_csum.btrfs_csum_file_blocks.add_pending_csums.btrfs_finish_ordered_io.btrfs_work_helper
      0.00            +1.1        1.13 ±  7%  perf-profile.calltrace.cycles-pp.rebalance_domains.__softirqentry_text_start.asm_call_on_stack.do_softirq_own_stack.irq_exit_rcu
      0.00            +1.2        1.20 ± 21%  perf-profile.calltrace.cycles-pp.run_delalloc_nocow.btrfs_run_delalloc_range.writepage_delalloc.__extent_writepage.extent_write_cache_pages
      0.00            +1.2        1.22 ± 18%  perf-profile.calltrace.cycles-pp.irq_enter_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state.cpuidle_enter
      0.00            +1.3        1.34 ± 20%  perf-profile.calltrace.cycles-pp.btrfs_get_64.check_extent_data_item.check_leaf.btree_csum_one_bio.btree_submit_bio_hook
      0.00            +1.3        1.34 ± 24%  perf-profile.calltrace.cycles-pp.__btrfs_drop_extents.insert_reserved_file_extent.btrfs_finish_ordered_io.btrfs_work_helper.process_one_work
      0.00            +1.4        1.39 ± 34%  perf-profile.calltrace.cycles-pp.btrfs_run_delayed_refs_for_head.__btrfs_run_delayed_refs.btrfs_run_delayed_refs.flush_space.btrfs_async_reclaim_metadata_space
      0.00            +1.4        1.39 ± 24%  perf-profile.calltrace.cycles-pp.insert_reserved_file_extent.btrfs_finish_ordered_io.btrfs_work_helper.process_one_work.worker_thread
      0.00            +1.4        1.40 ± 30%  perf-profile.calltrace.cycles-pp.clockevents_program_event.hrtimer_interrupt.__sysvec_apic_timer_interrupt.asm_call_on_stack.sysvec_apic_timer_interrupt
      0.00            +1.7        1.70 ± 27%  perf-profile.calltrace.cycles-pp.btrfs_search_slot.btrfs_mark_extent_written.btrfs_finish_ordered_io.btrfs_work_helper.process_one_work
      0.00            +1.7        1.72 ± 23%  perf-profile.calltrace.cycles-pp.btrfs_buffered_write.btrfs_file_write_iter.new_sync_write.vfs_write.ksys_write
      0.00            +1.7        1.72 ± 21%  perf-profile.calltrace.cycles-pp.btrfs_run_delalloc_range.writepage_delalloc.__extent_writepage.extent_write_cache_pages.extent_writepages
      0.00            +1.7        1.73 ± 23%  perf-profile.calltrace.cycles-pp.new_sync_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +1.7        1.73 ± 23%  perf-profile.calltrace.cycles-pp.btrfs_file_write_iter.new_sync_write.vfs_write.ksys_write.do_syscall_64
      0.00            +1.7        1.74 ± 33%  perf-profile.calltrace.cycles-pp.btrfs_run_delayed_refs.flush_space.btrfs_async_reclaim_metadata_space.process_one_work.worker_thread
      0.00            +1.7        1.74 ± 33%  perf-profile.calltrace.cycles-pp.__btrfs_run_delayed_refs.btrfs_run_delayed_refs.flush_space.btrfs_async_reclaim_metadata_space.process_one_work
      0.00            +1.8        1.75 ± 23%  perf-profile.calltrace.cycles-pp.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_write
      0.00            +1.8        1.75 ± 23%  perf-profile.calltrace.cycles-pp.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_write
      0.00            +1.8        1.76 ± 23%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_write
      0.00            +1.8        1.77 ± 23%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__libc_write
      0.00            +1.8        1.79 ± 23%  perf-profile.calltrace.cycles-pp.__libc_write
      0.00            +1.8        1.84 ± 20%  perf-profile.calltrace.cycles-pp.btrfs_get_32.check_leaf.btree_csum_one_bio.btree_submit_bio_hook.submit_one_bio
      0.00            +1.9        1.87 ± 21%  perf-profile.calltrace.cycles-pp.writepage_delalloc.__extent_writepage.extent_write_cache_pages.extent_writepages.do_writepages
      0.00            +1.9        1.90 ± 56%  perf-profile.calltrace.cycles-pp.update_process_times.tick_sched_handle.tick_sched_timer.__hrtimer_run_queues.hrtimer_interrupt
      0.00            +2.0        2.01 ± 58%  perf-profile.calltrace.cycles-pp.tick_sched_handle.tick_sched_timer.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_apic_timer_interrupt
      0.00            +2.0        2.03 ± 24%  perf-profile.calltrace.cycles-pp.add_pending_csums.btrfs_finish_ordered_io.btrfs_work_helper.process_one_work.worker_thread
      0.00            +2.0        2.03 ± 24%  perf-profile.calltrace.cycles-pp.btrfs_csum_file_blocks.add_pending_csums.btrfs_finish_ordered_io.btrfs_work_helper.process_one_work
      0.00            +2.1        2.10 ± 21%  perf-profile.calltrace.cycles-pp.__extent_writepage.extent_write_cache_pages.extent_writepages.do_writepages.__writeback_single_inode
      0.00            +2.1        2.11 ± 13%  perf-profile.calltrace.cycles-pp.tick_nohz_next_event.tick_nohz_get_sleep_length.menu_select.do_idle.cpu_startup_entry
      0.00            +2.2        2.19 ± 21%  perf-profile.calltrace.cycles-pp.extent_writepages.do_writepages.__writeback_single_inode.writeback_sb_inodes.wb_writeback
      0.00            +2.2        2.19 ± 21%  perf-profile.calltrace.cycles-pp.extent_write_cache_pages.extent_writepages.do_writepages.__writeback_single_inode.writeback_sb_inodes
      0.00            +2.3        2.35 ±  9%  perf-profile.calltrace.cycles-pp.__softirqentry_text_start.asm_call_on_stack.do_softirq_own_stack.irq_exit_rcu.sysvec_apic_timer_interrupt
      0.00            +2.4        2.35 ±  9%  perf-profile.calltrace.cycles-pp.asm_call_on_stack.do_softirq_own_stack.irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      0.00            +2.4        2.38 ± 10%  perf-profile.calltrace.cycles-pp.do_softirq_own_stack.irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state
      0.00            +2.4        2.40 ± 20%  perf-profile.calltrace.cycles-pp.check_extent_data_item.check_leaf.btree_csum_one_bio.btree_submit_bio_hook.submit_one_bio
      0.00            +2.4        2.45 ± 46%  perf-profile.calltrace.cycles-pp.tick_sched_timer.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_apic_timer_interrupt.asm_call_on_stack
      0.00            +2.5        2.46 ±  8%  perf-profile.calltrace.cycles-pp.tick_nohz_get_sleep_length.menu_select.do_idle.cpu_startup_entry.start_secondary
      0.00            +2.5        2.48 ± 32%  perf-profile.calltrace.cycles-pp.flush_space.btrfs_async_reclaim_metadata_space.process_one_work.worker_thread.kthread
      0.00            +2.5        2.48 ± 33%  perf-profile.calltrace.cycles-pp.btrfs_async_reclaim_metadata_space.process_one_work.worker_thread.kthread.ret_from_fork
      0.00            +2.8        2.79 ± 10%  perf-profile.calltrace.cycles-pp.irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state.cpuidle_enter
      0.00            +2.9        2.94 ± 25%  perf-profile.calltrace.cycles-pp.btrfs_mark_extent_written.btrfs_finish_ordered_io.btrfs_work_helper.process_one_work.worker_thread
      0.00            +3.8        3.80 ± 42%  perf-profile.calltrace.cycles-pp.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_apic_timer_interrupt.asm_call_on_stack.sysvec_apic_timer_interrupt
      0.00            +6.1        6.10 ± 20%  perf-profile.calltrace.cycles-pp.hrtimer_interrupt.__sysvec_apic_timer_interrupt.asm_call_on_stack.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      0.00            +6.2        6.25 ± 21%  perf-profile.calltrace.cycles-pp.__sysvec_apic_timer_interrupt.asm_call_on_stack.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state
      0.00            +6.3        6.30 ± 22%  perf-profile.calltrace.cycles-pp.asm_call_on_stack.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state.cpuidle_enter
      0.00            +6.6        6.60 ± 18%  perf-profile.calltrace.cycles-pp.check_leaf.btree_csum_one_bio.btree_submit_bio_hook.submit_one_bio.submit_extent_page
      0.00            +6.7        6.75 ± 19%  perf-profile.calltrace.cycles-pp.btree_csum_one_bio.btree_submit_bio_hook.submit_one_bio.submit_extent_page.write_one_eb
      0.00            +6.8        6.82 ± 19%  perf-profile.calltrace.cycles-pp.submit_extent_page.write_one_eb.btree_write_cache_pages.do_writepages.__writeback_single_inode
      0.00            +6.8        6.84 ± 24%  perf-profile.calltrace.cycles-pp.btrfs_finish_ordered_io.btrfs_work_helper.process_one_work.worker_thread.kthread
      0.00            +6.9        6.93 ± 19%  perf-profile.calltrace.cycles-pp.btree_submit_bio_hook.submit_one_bio.submit_extent_page.write_one_eb.btree_write_cache_pages
      0.00            +6.9        6.93 ± 19%  perf-profile.calltrace.cycles-pp.submit_one_bio.submit_extent_page.write_one_eb.btree_write_cache_pages.do_writepages
      0.00            +7.1        7.06 ± 24%  perf-profile.calltrace.cycles-pp.btrfs_work_helper.process_one_work.worker_thread.kthread.ret_from_fork
      0.00            +7.1        7.10 ± 19%  perf-profile.calltrace.cycles-pp.write_one_eb.btree_write_cache_pages.do_writepages.__writeback_single_inode.writeback_sb_inodes
      0.00            +7.2        7.21 ± 19%  perf-profile.calltrace.cycles-pp.btree_write_cache_pages.do_writepages.__writeback_single_inode.writeback_sb_inodes.wb_writeback
      0.00            +9.4        9.41 ± 20%  perf-profile.calltrace.cycles-pp.do_writepages.__writeback_single_inode.writeback_sb_inodes.wb_writeback.wb_workfn
      0.00            +9.4        9.41 ± 20%  perf-profile.calltrace.cycles-pp.writeback_sb_inodes.wb_writeback.wb_workfn.process_one_work.worker_thread
      0.00            +9.4        9.41 ± 20%  perf-profile.calltrace.cycles-pp.__writeback_single_inode.writeback_sb_inodes.wb_writeback.wb_workfn.process_one_work
      0.00            +9.4        9.45 ± 20%  perf-profile.calltrace.cycles-pp.wb_writeback.wb_workfn.process_one_work.worker_thread.kthread
      0.00            +9.5        9.45 ± 20%  perf-profile.calltrace.cycles-pp.wb_workfn.process_one_work.worker_thread.kthread.ret_from_fork
      0.00           +11.2       11.24 ± 15%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state.cpuidle_enter.do_idle
      0.00           +15.9       15.94 ± 43%  perf-profile.calltrace.cycles-pp.menu_select.do_idle.cpu_startup_entry.start_secondary.secondary_startup_64
      0.00           +19.1       19.14 ± 22%  perf-profile.calltrace.cycles-pp.process_one_work.worker_thread.kthread.ret_from_fork
      0.00           +19.3       19.29 ± 22%  perf-profile.calltrace.cycles-pp.worker_thread.kthread.ret_from_fork
      0.00           +19.4       19.36 ± 22%  perf-profile.calltrace.cycles-pp.ret_from_fork
      0.00           +19.4       19.36 ± 22%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork
      0.00           +20.9       20.93 ± 18%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state.cpuidle_enter.do_idle.cpu_startup_entry
     50.00 ± 23%     +27.1       77.09 ±  6%  perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.start_secondary.secondary_startup_64
     50.00 ± 23%     +27.1       77.12 ±  6%  perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_secondary.secondary_startup_64
     50.00 ± 23%     +27.1       77.12 ±  6%  perf-profile.calltrace.cycles-pp.start_secondary.secondary_startup_64
     50.00 ± 23%     +27.6       77.61 ±  6%  perf-profile.calltrace.cycles-pp.secondary_startup_64
     35.91 ± 50%     -33.8        2.08 ± 23%  perf-profile.children.cycles-pp.do_syscall_64
     35.91 ± 50%     -33.8        2.09 ± 23%  perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     50.00 ± 23%     -15.2       34.85 ± 13%  perf-profile.children.cycles-pp.intel_idle
     14.09 ± 95%     -14.1        0.01 ±173%  perf-profile.children.cycles-pp.seq_read
     11.82 ± 31%     -11.8        0.00        perf-profile.children.cycles-pp.cmd_record
     11.82 ± 31%     -11.8        0.02 ±173%  perf-profile.children.cycles-pp.__libc_start_main
     11.82 ± 31%     -11.8        0.02 ±173%  perf-profile.children.cycles-pp.main
     11.82 ± 31%     -11.8        0.02 ±173%  perf-profile.children.cycles-pp.run_builtin
     11.59 ±128%     -11.6        0.00        perf-profile.children.cycles-pp.proc_reg_read
     10.00 ±100%     -10.0        0.00        perf-profile.children.cycles-pp.__prepare_exit_to_usermode
     10.00 ±100%     -10.0        0.00        perf-profile.children.cycles-pp.do_signal
     10.00 ±100%     -10.0        0.00        perf-profile.children.cycles-pp.get_signal
     10.00 ±100%     -10.0        0.00        perf-profile.children.cycles-pp.do_group_exit
     10.00 ±100%     -10.0        0.00        perf-profile.children.cycles-pp.do_exit
      9.54 ±  4%      -9.5        0.00        perf-profile.children.cycles-pp.record__mmap_read_evlist
      9.54 ±  4%      -9.5        0.00        perf-profile.children.cycles-pp.perf_mmap__push
      9.54 ±  4%      -9.5        0.00        perf-profile.children.cycles-pp.perf_mmap__read_head
      7.50 ±110%      -7.5        0.01 ±173%  perf-profile.children.cycles-pp.mmput
      7.50 ±110%      -7.5        0.01 ±173%  perf-profile.children.cycles-pp.exit_mmap
      7.27 ±113%      -7.3        0.00        perf-profile.children.cycles-pp.dput
      7.27 ±113%      -7.3        0.00        perf-profile.children.cycles-pp.do_sys_open
      7.27 ±113%      -7.3        0.00        perf-profile.children.cycles-pp.do_sys_openat2
      7.27 ±113%      -7.3        0.00        perf-profile.children.cycles-pp.do_filp_open
      7.27 ±113%      -7.3        0.00        perf-profile.children.cycles-pp.path_openat
      7.27 ±113%      -7.3        0.00        perf-profile.children.cycles-pp.link_path_walk
      7.27 ±113%      -7.3        0.00        perf-profile.children.cycles-pp.walk_component
      7.27 ±113%      -7.3        0.00        perf-profile.children.cycles-pp.step_into
      5.00 ±100%      -5.0        0.00        perf-profile.children.cycles-pp.tlb_finish_mmu
      5.00 ±100%      -5.0        0.00        perf-profile.children.cycles-pp.tlb_flush_mmu
      5.00 ±100%      -5.0        0.00        perf-profile.children.cycles-pp.release_pages
      4.77 ±100%      -4.8        0.00        perf-profile.children.cycles-pp.seq_printf
      4.77 ±100%      -4.8        0.00        perf-profile.children.cycles-pp.seq_vprintf
      4.77 ±100%      -4.8        0.00        perf-profile.children.cycles-pp.vsnprintf
      4.77 ±100%      -4.8        0.00        perf-profile.children.cycles-pp.__do_fault
      4.77 ±100%      -4.8        0.02 ±173%  perf-profile.children.cycles-pp.do_fault
      0.00            +0.1        0.05 ±  8%  perf-profile.children.cycles-pp.find_ref_head
      0.00            +0.1        0.06 ± 14%  perf-profile.children.cycles-pp.memzero_extent_buffer
      0.00            +0.1        0.06 ± 16%  perf-profile.children.cycles-pp.btrfs_release_extent_buffer_pages
      0.00            +0.1        0.06 ± 13%  perf-profile.children.cycles-pp.btrfs_get_block_group
      0.00            +0.1        0.07 ± 26%  perf-profile.children.cycles-pp.__update_load_avg_cfs_rq
      0.00            +0.1        0.07 ± 26%  perf-profile.children.cycles-pp.__switch_to_asm
      0.00            +0.1        0.07 ± 26%  perf-profile.children.cycles-pp.check_committed_ref
      0.00            +0.1        0.07 ± 31%  perf-profile.children.cycles-pp.pagevec_lookup_range_tag
      0.00            +0.1        0.07 ± 31%  perf-profile.children.cycles-pp.find_get_pages_range_tag
      0.00            +0.1        0.07 ± 17%  perf-profile.children.cycles-pp.btrfs_free_path
      0.00            +0.1        0.07 ± 22%  perf-profile.children.cycles-pp.btrfs_bio_fits_in_stripe
      0.00            +0.1        0.07 ± 30%  perf-profile.children.cycles-pp.btrfs_check_node
      0.00            +0.1        0.07 ± 38%  perf-profile.children.cycles-pp.__slab_free
      0.00            +0.1        0.08 ± 14%  perf-profile.children.cycles-pp.set_next_entity
      0.00            +0.1        0.08 ± 21%  perf-profile.children.cycles-pp.__switch_to
      0.00            +0.1        0.08 ± 32%  perf-profile.children.cycles-pp.mark_page_accessed
      0.00            +0.1        0.08 ± 40%  perf-profile.children.cycles-pp.xas_find_marked
      0.00            +0.1        0.08 ± 26%  perf-profile.children.cycles-pp.__module_address
      0.00            +0.1        0.08 ±  8%  perf-profile.children.cycles-pp.dequeue_entity
      0.00            +0.1        0.08 ± 19%  perf-profile.children.cycles-pp.btrfs_get_chunk_map
      0.00            +0.1        0.08 ± 31%  perf-profile.children.cycles-pp.kernel_text_address
      0.00            +0.1        0.08 ± 27%  perf-profile.children.cycles-pp.block_group_cache_tree_search
      0.00            +0.1        0.09 ± 28%  perf-profile.children.cycles-pp.__blk_mq_try_issue_directly
      0.00            +0.1        0.09 ± 14%  perf-profile.children.cycles-pp.check_extent_item
      0.00            +0.1        0.09 ± 30%  perf-profile.children.cycles-pp.___slab_alloc
      0.00            +0.1        0.09 ± 29%  perf-profile.children.cycles-pp.free_extent_buffer
      0.00            +0.1        0.09 ± 23%  perf-profile.children.cycles-pp.mark_extent_buffer_accessed
      0.00            +0.1        0.09 ± 36%  perf-profile.children.cycles-pp.btrfs_inc_extent_ref
      0.00            +0.1        0.09 ± 17%  perf-profile.children.cycles-pp.select_task_rq_fair
      0.00            +0.1        0.09 ± 27%  perf-profile.children.cycles-pp.find_next_bit
      0.00            +0.1        0.09 ± 27%  perf-profile.children.cycles-pp.__kernel_text_address
      0.00            +0.1        0.09 ± 29%  perf-profile.children.cycles-pp.crc_128
      0.00            +0.1        0.10 ± 18%  perf-profile.children.cycles-pp.note_gp_changes
      0.00            +0.1        0.10 ±  5%  perf-profile.children.cycles-pp.update_load_avg
      0.00            +0.1        0.10 ± 30%  perf-profile.children.cycles-pp.__slab_alloc
      0.00            +0.1        0.10 ± 11%  perf-profile.children.cycles-pp.btrfs_super_csum_size
      0.00            +0.1        0.10 ± 26%  perf-profile.children.cycles-pp.push_leaf_left
      0.00            +0.1        0.10 ± 39%  perf-profile.children.cycles-pp.cpumask_next_and
      0.00            +0.1        0.10 ± 29%  perf-profile.children.cycles-pp.rcu_nmi_exit
      0.00            +0.1        0.10 ± 15%  perf-profile.children.cycles-pp.dequeue_task_fair
      0.00            +0.1        0.10 ± 32%  perf-profile.children.cycles-pp.unwind_get_return_address
      0.00            +0.1        0.10 ± 24%  perf-profile.children.cycles-pp.btrfs_get_io_geometry
      0.00            +0.1        0.10 ± 27%  perf-profile.children.cycles-pp.idle_cpu
      0.00            +0.1        0.10 ± 39%  perf-profile.children.cycles-pp.calc_global_load_tick
      0.00            +0.1        0.10 ± 44%  perf-profile.children.cycles-pp.memcpy_erms
      0.00            +0.1        0.10 ± 35%  perf-profile.children.cycles-pp.btrfs_add_delayed_data_ref
      0.00            +0.1        0.11 ± 10%  perf-profile.children.cycles-pp.call_cpuidle
      0.00            +0.1        0.11 ± 35%  perf-profile.children.cycles-pp.__percpu_counter_sum
      0.00            +0.1        0.11 ± 35%  perf-profile.children.cycles-pp.__percpu_counter_compare
      0.00            +0.1        0.11 ± 23%  perf-profile.children.cycles-pp.rcu_eqs_enter
      0.00            +0.1        0.11 ± 28%  perf-profile.children.cycles-pp.insert_state
      0.00            +0.1        0.11 ± 39%  perf-profile.children.cycles-pp.__btrfs_btree_balance_dirty
      0.00            +0.1        0.11 ± 20%  perf-profile.children.cycles-pp.prepare_pages
      0.00            +0.1        0.11 ± 17%  perf-profile.children.cycles-pp.rcu_dynticks_eqs_exit
      0.00            +0.1        0.11 ± 27%  perf-profile.children.cycles-pp.memcpy_extent_buffer
      0.00            +0.1        0.12 ± 42%  perf-profile.children.cycles-pp.rb_erase
      0.00            +0.1        0.12 ± 38%  perf-profile.children.cycles-pp.idtentry_exit_cond_rcu
      0.00            +0.1        0.12 ± 13%  perf-profile.children.cycles-pp.rcu_dynticks_eqs_enter
      0.00            +0.1        0.12 ± 20%  perf-profile.children.cycles-pp.account_process_tick
      0.00            +0.1        0.12 ± 16%  perf-profile.children.cycles-pp.btrfs_cross_ref_exist
      0.00            +0.1        0.12 ± 15%  perf-profile.children.cycles-pp.__test_set_page_writeback
      0.00            +0.1        0.12 ± 18%  perf-profile.children.cycles-pp.rcu_eqs_exit
      0.00            +0.1        0.12 ± 21%  perf-profile.children.cycles-pp.___might_sleep
      0.00            +0.1        0.12 ±  6%  perf-profile.children.cycles-pp.end_extent_writepage
      0.00            +0.1        0.12 ±  6%  perf-profile.children.cycles-pp.btrfs_writepage_endio_finish_ordered
      0.00            +0.1        0.12 ± 29%  perf-profile.children.cycles-pp.btrfs_try_tree_write_lock
      0.00            +0.1        0.13 ± 27%  perf-profile.children.cycles-pp.__clear_extent_bit
      0.00            +0.1        0.13 ± 17%  perf-profile.children.cycles-pp.end_bio_extent_buffer_writepage
      0.00            +0.1        0.13 ± 14%  perf-profile.children.cycles-pp.clear_page_dirty_for_io
      0.00            +0.1        0.13 ± 31%  perf-profile.children.cycles-pp.unpin_extent_range
      0.00            +0.1        0.13 ± 29%  perf-profile.children.cycles-pp.release_extent_buffer
      0.00            +0.1        0.13 ± 21%  perf-profile.children.cycles-pp.btrfs_wq_submit_bio
      0.00            +0.1        0.13 ± 38%  perf-profile.children.cycles-pp.btrfs_find_delalloc_range
      0.00            +0.1        0.13 ± 94%  perf-profile.children.cycles-pp.timerqueue_add
      0.00            +0.1        0.14 ± 25%  perf-profile.children.cycles-pp.run_one_async_done
      0.00            +0.1        0.14 ± 19%  perf-profile.children.cycles-pp.btrfs_submit_bio_hook
      0.00            +0.1        0.14 ± 38%  perf-profile.children.cycles-pp.unpin_extent_cache
      0.00            +0.1        0.14 ± 13%  perf-profile.children.cycles-pp.pick_next_task_fair
      0.00            +0.1        0.14 ± 91%  perf-profile.children.cycles-pp.update_ts_time_stats
      0.00            +0.1        0.14 ± 72%  perf-profile.children.cycles-pp.rb_next
      0.00            +0.1        0.14 ± 35%  perf-profile.children.cycles-pp.btrfs_finish_extent_commit
      0.00            +0.1        0.14 ± 52%  perf-profile.children.cycles-pp.rcu_nmi_enter
      0.00            +0.1        0.14 ± 32%  perf-profile.children.cycles-pp.tsc_verify_tsc_adjust
      0.00            +0.1        0.15 ± 65%  perf-profile.children.cycles-pp.nr_iowait_cpu
      0.00            +0.1        0.15 ± 31%  perf-profile.children.cycles-pp.arch_cpu_idle_enter
      0.00            +0.1        0.15 ± 51%  perf-profile.children.cycles-pp.rb_insert_color
      0.00            +0.1        0.15 ± 34%  perf-profile.children.cycles-pp.find_lock_delalloc_range
      0.00            +0.2        0.15 ± 86%  perf-profile.children.cycles-pp.enqueue_hrtimer
      0.00            +0.2        0.16 ± 62%  perf-profile.children.cycles-pp.cpuidle_governor_latency_req
      0.00            +0.2        0.16 ± 19%  perf-profile.children.cycles-pp.btrfs_comp_cpu_keys
      0.00            +0.2        0.16 ±  2%  perf-profile.children.cycles-pp.hrtimer_get_next_event
      0.00            +0.2        0.16 ± 35%  perf-profile.children.cycles-pp.btrfs_update_block_group
      0.00            +0.2        0.17 ± 25%  perf-profile.children.cycles-pp.queued_write_lock_slowpath
      0.00            +0.2        0.17 ± 19%  perf-profile.children.cycles-pp.finish_wait
      0.00            +0.2        0.17 ± 21%  perf-profile.children.cycles-pp.test_clear_page_writeback
      0.00            +0.2        0.17 ± 36%  perf-profile.children.cycles-pp.kmem_cache_free
      0.00            +0.2        0.17 ± 26%  perf-profile.children.cycles-pp.down_read
      0.00            +0.2        0.17 ± 27%  perf-profile.children.cycles-pp.__orc_find
      0.00            +0.2        0.17 ± 27%  perf-profile.children.cycles-pp.__radix_tree_lookup
      0.00            +0.2        0.17 ± 59%  perf-profile.children.cycles-pp.idtentry_enter_cond_rcu
      0.00            +0.2        0.17 ± 21%  perf-profile.children.cycles-pp.end_page_writeback
      0.00            +0.2        0.17 ± 14%  perf-profile.children.cycles-pp.rcu_idle_exit
      0.00            +0.2        0.17 ± 22%  perf-profile.children.cycles-pp._raw_spin_lock_irq
      0.00            +0.2        0.17 ± 45%  perf-profile.children.cycles-pp.update_irq_load_avg
      0.00            +0.2        0.18 ± 16%  perf-profile.children.cycles-pp.run_local_timers
      0.00            +0.2        0.18 ± 40%  perf-profile.children.cycles-pp.find_get_entry
      0.00            +0.2        0.18 ± 21%  perf-profile.children.cycles-pp.xas_load
      0.00            +0.2        0.18 ± 28%  perf-profile.children.cycles-pp.memmove_extent_buffer
      0.00            +0.2        0.18 ± 16%  perf-profile.children.cycles-pp.end_bio_extent_writepage
      0.00            +0.2        0.18 ± 32%  perf-profile.children.cycles-pp.__set_page_dirty_nobuffers
      0.00            +0.2        0.18 ± 72%  perf-profile.children.cycles-pp.timerqueue_del
      0.00            +0.2        0.18 ± 18%  perf-profile.children.cycles-pp.btrfs_free_tree_block
      0.00            +0.2        0.19 ± 21%  perf-profile.children.cycles-pp.blk_mq_submit_bio
      0.00            +0.2        0.20 ± 27%  perf-profile.children.cycles-pp.btrfs_release_path
      0.00            +0.2        0.20 ± 32%  perf-profile.children.cycles-pp.set_extent_buffer_dirty
      0.00            +0.2        0.20 ± 38%  perf-profile.children.cycles-pp.run_timer_softirq
      0.00            +0.2        0.20 ± 25%  perf-profile.children.cycles-pp.orc_find
      0.00            +0.2        0.20 ± 21%  perf-profile.children.cycles-pp.btrfs_unlock_up_safe
      0.00            +0.2        0.20 ± 29%  perf-profile.children.cycles-pp.arch_scale_freq_tick
      0.00            +0.2        0.20 ± 38%  perf-profile.children.cycles-pp.__hrtimer_next_event_base
      0.00            +0.2        0.21 ± 25%  perf-profile.children.cycles-pp.__push_leaf_right
      0.00            +0.2        0.21 ± 44%  perf-profile.children.cycles-pp.lock_and_cleanup_extent_if_need
      0.00            +0.2        0.21 ± 55%  perf-profile.children.cycles-pp.io_serial_in
      0.00            +0.2        0.21 ± 19%  perf-profile.children.cycles-pp.__queue_work
      0.00            +0.2        0.21 ± 48%  perf-profile.children.cycles-pp.btrfs_get_extent
      0.00            +0.2        0.22 ± 25%  perf-profile.children.cycles-pp.memmove
      0.00            +0.2        0.22 ± 17%  perf-profile.children.cycles-pp.queue_work_on
      0.00            +0.2        0.22 ± 25%  perf-profile.children.cycles-pp.submit_bio_noacct
      0.00            +0.2        0.22 ± 22%  perf-profile.children.cycles-pp.btrfs_delayed_refs_rsv_release
      0.00            +0.2        0.22 ± 15%  perf-profile.children.cycles-pp.__extent_writepage_io
      0.00            +0.2        0.22 ± 36%  perf-profile.children.cycles-pp.run_rebalance_domains
      0.00            +0.2        0.23 ± 25%  perf-profile.children.cycles-pp.submit_bio
      0.00            +0.2        0.23 ± 33%  perf-profile.children.cycles-pp.btrfs_mark_buffer_dirty
      0.00            +0.2        0.23 ± 16%  perf-profile.children.cycles-pp.schedule_idle
      0.00            +0.2        0.24 ± 17%  perf-profile.children.cycles-pp.add_delayed_ref_head
      0.00            +0.2        0.24 ± 21%  perf-profile.children.cycles-pp.csum_exist_in_range
      0.00            +0.2        0.24 ± 21%  perf-profile.children.cycles-pp.btrfs_lookup_csums_range
      0.00            +0.2        0.24 ± 79%  perf-profile.children.cycles-pp.__remove_hrtimer
      0.00            +0.2        0.24 ± 57%  perf-profile.children.cycles-pp.update_blocked_averages
      0.00            +0.2        0.25 ± 47%  perf-profile.children.cycles-pp.serial8250_console_putchar
      0.00            +0.2        0.25 ±  5%  perf-profile.children.cycles-pp.__intel_pmu_enable_all
      0.00            +0.2        0.25 ± 48%  perf-profile.children.cycles-pp.uart_console_write
      0.00            +0.3        0.25 ± 14%  perf-profile.children.cycles-pp.kmem_cache_alloc
      0.00            +0.3        0.25 ± 45%  perf-profile.children.cycles-pp.wait_for_xmitr
      0.00            +0.3        0.26 ± 45%  perf-profile.children.cycles-pp.serial8250_console_write
      0.00            +0.3        0.26 ± 32%  perf-profile.children.cycles-pp.set_extent_bit
      0.00            +0.3        0.27 ± 14%  perf-profile.children.cycles-pp.btrfs_try_granting_tickets
      0.00            +0.3        0.27 ± 33%  perf-profile.children.cycles-pp.create_io_em
      0.00            +0.3        0.27 ± 33%  perf-profile.children.cycles-pp.pagecache_get_page
      0.00            +0.3        0.27 ± 44%  perf-profile.children.cycles-pp.asm_sysvec_irq_work
      0.00            +0.3        0.27 ± 44%  perf-profile.children.cycles-pp.sysvec_irq_work
      0.00            +0.3        0.27 ± 44%  perf-profile.children.cycles-pp.__sysvec_irq_work
      0.00            +0.3        0.27 ± 44%  perf-profile.children.cycles-pp.irq_work_run
      0.00            +0.3        0.27 ± 44%  perf-profile.children.cycles-pp.irq_work_single
      0.00            +0.3        0.27 ± 44%  perf-profile.children.cycles-pp.printk
      0.00            +0.3        0.27 ± 44%  perf-profile.children.cycles-pp.vprintk_emit
      0.00            +0.3        0.27 ± 44%  perf-profile.children.cycles-pp.console_unlock
      0.00            +0.3        0.27 ± 36%  perf-profile.children.cycles-pp.btrfs_drop_extent_cache
      0.00            +0.3        0.28 ± 13%  perf-profile.children.cycles-pp.rcu_core
      0.00            +0.3        0.28 ± 45%  perf-profile.children.cycles-pp.btrfs_dirty_pages
      0.00            +0.3        0.29 ± 48%  perf-profile.children.cycles-pp.irq_work_run_list
      0.00            +0.3        0.29 ±  8%  perf-profile.children.cycles-pp.btrfs_inode_rsv_release
      0.00            +0.3        0.29 ± 15%  perf-profile.children.cycles-pp.hrtimer_next_event_without
      0.00            +0.3        0.29 ± 38%  perf-profile.children.cycles-pp.alloc_extent_buffer
      0.00            +0.3        0.30 ± 40%  perf-profile.children.cycles-pp.lookup_inline_extent_backref
      0.00            +0.3        0.31 ± 13%  perf-profile.children.cycles-pp.btrfs_add_delayed_tree_ref
      0.00            +0.3        0.32 ± 23%  perf-profile.children.cycles-pp.btrfs_map_bio
      0.00            +0.3        0.33 ± 32%  perf-profile.children.cycles-pp.lock_extent_bits
      0.00            +0.3        0.33 ± 35%  perf-profile.children.cycles-pp.generic_bin_search
      0.00            +0.3        0.34 ± 26%  perf-profile.children.cycles-pp.schedule
      0.00            +0.4        0.36 ± 16%  perf-profile.children.cycles-pp.btrfs_end_bio
      0.00            +0.4        0.37 ± 27%  perf-profile.children.cycles-pp.find_extent_buffer
      0.00            +0.4        0.38 ± 14%  perf-profile.children.cycles-pp.blk_update_request
      0.00            +0.4        0.39 ± 34%  perf-profile.children.cycles-pp.btrfs_del_items
      0.00            +0.4        0.39 ± 13%  perf-profile.children.cycles-pp.__lock_text_start
      0.00            +0.4        0.39 ± 15%  perf-profile.children.cycles-pp.blk_mq_end_request
      0.00            +0.4        0.40 ± 44%  perf-profile.children.cycles-pp.update_rq_clock
      0.00            +0.4        0.42 ± 19%  perf-profile.children.cycles-pp.update_sd_lb_stats
      0.00            +0.4        0.44 ± 21%  perf-profile.children.cycles-pp.find_busiest_group
      0.00            +0.4        0.44 ± 16%  perf-profile.children.cycles-pp.native_sched_clock
      0.00            +0.4        0.45 ± 13%  perf-profile.children.cycles-pp.unlock_up
      0.00            +0.5        0.45 ± 23%  perf-profile.children.cycles-pp.btrfs_get_8
      0.00            +0.5        0.45 ± 13%  perf-profile.children.cycles-pp.nvme_irq
      0.00            +0.5        0.46 ± 21%  perf-profile.children.cycles-pp.unwind_next_frame
      0.00            +0.5        0.46 ± 13%  perf-profile.children.cycles-pp.__handle_irq_event_percpu
      0.00            +0.5        0.46 ±  8%  perf-profile.children.cycles-pp.read_tsc
      0.00            +0.5        0.46 ± 15%  perf-profile.children.cycles-pp.sched_clock
      0.00            +0.5        0.47 ± 13%  perf-profile.children.cycles-pp.handle_irq_event_percpu
      0.00            +0.5        0.47 ± 83%  perf-profile.children.cycles-pp.__filemap_fdatawrite_range
      0.00            +0.5        0.48 ± 16%  perf-profile.children.cycles-pp.start_kernel
      0.00            +0.5        0.48 ± 82%  perf-profile.children.cycles-pp.btrfs_write_marked_extents
      0.00            +0.5        0.49 ± 13%  perf-profile.children.cycles-pp.handle_irq_event
      0.00            +0.5        0.49 ± 30%  perf-profile.children.cycles-pp.read_block_for_search
      0.00            +0.5        0.49 ± 10%  perf-profile.children.cycles-pp.lapic_next_deadline
      0.00            +0.5        0.49 ± 80%  perf-profile.children.cycles-pp.btrfs_write_and_wait_transaction
      0.00            +0.5        0.50 ± 14%  perf-profile.children.cycles-pp.handle_edge_irq
      0.00            +0.5        0.51 ± 11%  perf-profile.children.cycles-pp.ktime_get_update_offsets_now
      0.00            +0.5        0.51 ± 14%  perf-profile.children.cycles-pp.btrfs_block_rsv_release
      0.00            +0.5        0.52 ± 41%  perf-profile.children.cycles-pp.__lookup_extent_mapping
      0.00            +0.5        0.52 ± 39%  perf-profile.children.cycles-pp._raw_spin_trylock
      0.00            +0.5        0.52 ± 38%  perf-profile.children.cycles-pp.__etree_search
      0.00            +0.5        0.53 ± 12%  perf-profile.children.cycles-pp.common_interrupt
      0.00            +0.5        0.53 ± 20%  perf-profile.children.cycles-pp.cow_file_range
      0.00            +0.5        0.53 ± 13%  perf-profile.children.cycles-pp.asm_common_interrupt
      0.00            +0.5        0.55 ± 23%  perf-profile.children.cycles-pp.btrfs_set_token_32
      0.00            +0.6        0.55 ± 20%  perf-profile.children.cycles-pp.__sched_text_start
      0.00            +0.6        0.56 ± 98%  perf-profile.children.cycles-pp.rcu_sched_clock_irq
      0.00            +0.6        0.58 ± 28%  perf-profile.children.cycles-pp.sched_clock_cpu
      0.00            +0.6        0.59 ± 31%  perf-profile.children.cycles-pp.__set_extent_bit
      0.00            +0.6        0.59 ± 12%  perf-profile.children.cycles-pp.btrfs_reserve_metadata_bytes
      0.00            +0.6        0.60 ± 34%  perf-profile.children.cycles-pp.btrfs_get_token_32
      0.00            +0.6        0.60 ± 25%  perf-profile.children.cycles-pp.load_balance
      0.00            +0.6        0.61 ± 12%  perf-profile.children.cycles-pp.btrfs_delalloc_reserve_metadata
      0.00            +0.6        0.63 ± 19%  perf-profile.children.cycles-pp.arch_stack_walk
      0.00            +0.6        0.64 ± 22%  perf-profile.children.cycles-pp.find_free_extent
      0.00            +0.6        0.64 ± 20%  perf-profile.children.cycles-pp.btrfs_read_lock_root_node
      0.00            +0.7        0.66 ± 49%  perf-profile.children.cycles-pp.timekeeping_max_deferment
      0.00            +0.7        0.67 ± 40%  perf-profile.children.cycles-pp.tick_nohz_irq_exit
      0.00            +0.7        0.67 ± 21%  perf-profile.children.cycles-pp.btrfs_reserve_extent
      0.00            +0.7        0.68 ± 20%  perf-profile.children.cycles-pp.btrfs_tree_read_lock
      0.00            +0.7        0.68 ± 18%  perf-profile.children.cycles-pp.stack_trace_save_tsk
      0.00            +0.7        0.70 ± 30%  perf-profile.children.cycles-pp.push_leaf_right
      0.00            +0.7        0.72 ± 72%  perf-profile.children.cycles-pp.btrfs_commit_transaction
      0.00            +0.7        0.74 ± 17%  perf-profile.children.cycles-pp.perf_mux_hrtimer_handler
      0.00            +0.7        0.75 ±  9%  perf-profile.children.cycles-pp.__next_timer_interrupt
      0.00            +0.8        0.77 ± 22%  perf-profile.children.cycles-pp.btrfs_lock_root_node
      0.00            +0.8        0.78 ± 17%  perf-profile.children.cycles-pp.__account_scheduler_latency
      0.00            +0.8        0.81 ± 36%  perf-profile.children.cycles-pp.__btrfs_free_extent
      0.00            +0.8        0.81 ± 21%  perf-profile.children.cycles-pp.btrfs_tree_lock
      0.00            +0.8        0.81 ± 29%  perf-profile.children.cycles-pp.split_leaf
      0.00            +0.8        0.85 ± 24%  perf-profile.children.cycles-pp.btrfs_alloc_tree_block
      0.00            +0.9        0.85 ± 10%  perf-profile.children.cycles-pp.irqtime_account_irq
      0.00            +0.9        0.85 ± 24%  perf-profile.children.cycles-pp.alloc_tree_block_no_bg_flush
      0.00            +0.9        0.86 ± 42%  perf-profile.children.cycles-pp.scheduler_tick
      0.00            +0.9        0.87 ± 18%  perf-profile.children.cycles-pp.read_extent_buffer
      0.00            +0.9        0.89 ± 20%  perf-profile.children.cycles-pp.setup_leaf_for_split
      0.00            +0.9        0.90 ± 18%  perf-profile.children.cycles-pp.enqueue_entity
      0.00            +0.9        0.90 ± 22%  perf-profile.children.cycles-pp.tick_irq_enter
      0.00            +0.9        0.92 ± 18%  perf-profile.children.cycles-pp.enqueue_task_fair
      0.00            +0.9        0.93 ± 18%  perf-profile.children.cycles-pp.ttwu_do_activate
      0.00            +1.0        0.99 ± 21%  perf-profile.children.cycles-pp.prepare_to_wait_event
      0.00            +1.0        1.02 ± 17%  perf-profile.children.cycles-pp.autoremove_wake_function
      0.00            +1.0        1.04 ± 16%  perf-profile.children.cycles-pp.__wake_up_common
      0.00            +1.1        1.05 ± 10%  perf-profile.children.cycles-pp.get_next_timer_interrupt
      0.00            +1.1        1.09 ± 23%  perf-profile.children.cycles-pp.btrfs_lookup_csum
      0.00            +1.1        1.09 ± 16%  perf-profile.children.cycles-pp.__wake_up_common_lock
      0.00            +1.1        1.12 ± 44%  perf-profile.children.cycles-pp.copy_extent_buffer_full
      0.00            +1.1        1.12 ± 44%  perf-profile.children.cycles-pp.copy_page
      0.00            +1.2        1.16 ± 25%  perf-profile.children.cycles-pp.setup_items_for_insert
      0.00            +1.2        1.17 ±  5%  perf-profile.children.cycles-pp.rebalance_domains
      0.00            +1.2        1.22 ± 17%  perf-profile.children.cycles-pp.try_to_wake_up
      0.00            +1.2        1.22 ± 21%  perf-profile.children.cycles-pp.run_delalloc_nocow
      0.00            +1.3        1.25 ± 19%  perf-profile.children.cycles-pp.irq_enter_rcu
      0.00            +1.3        1.31 ± 23%  perf-profile.children.cycles-pp.check_setget_bounds
      0.00            +1.3        1.34 ± 26%  perf-profile.children.cycles-pp.btrfs_insert_empty_items
      0.00            +1.3        1.34 ± 24%  perf-profile.children.cycles-pp.__btrfs_drop_extents
      0.00            +1.3        1.35 ± 21%  perf-profile.children.cycles-pp.btrfs_duplicate_item
      0.00            +1.4        1.39 ± 24%  perf-profile.children.cycles-pp.insert_reserved_file_extent
      0.00            +1.4        1.43 ± 32%  perf-profile.children.cycles-pp.btrfs_run_delayed_refs_for_head
      0.00            +1.4        1.45 ± 28%  perf-profile.children.cycles-pp.clockevents_program_event
      0.00            +1.5        1.49 ± 24%  perf-profile.children.cycles-pp.btrfs_lookup_file_extent
      0.00            +1.6        1.56 ± 21%  perf-profile.children.cycles-pp.btrfs_get_64
      0.00            +1.7        1.72 ± 23%  perf-profile.children.cycles-pp.btrfs_buffered_write
      0.00            +1.7        1.73 ± 23%  perf-profile.children.cycles-pp.btrfs_file_write_iter
      0.00            +1.8        1.75 ± 21%  perf-profile.children.cycles-pp.btrfs_run_delalloc_range
      0.00            +1.8        1.76 ± 23%  perf-profile.children.cycles-pp.new_sync_write
      0.00            +1.8        1.78 ± 23%  perf-profile.children.cycles-pp.ksys_write
      0.00            +1.8        1.78 ± 23%  perf-profile.children.cycles-pp.vfs_write
      0.00            +1.8        1.79 ± 23%  perf-profile.children.cycles-pp.__libc_write
      0.00            +1.8        1.80 ± 31%  perf-profile.children.cycles-pp.btrfs_run_delayed_refs
      0.00            +1.8        1.80 ± 31%  perf-profile.children.cycles-pp.__btrfs_run_delayed_refs
      0.00            +1.9        1.91 ± 21%  perf-profile.children.cycles-pp.writepage_delalloc
      0.00            +1.9        1.95 ± 55%  perf-profile.children.cycles-pp.update_process_times
      0.00            +2.0        1.97 ± 16%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
      0.00            +2.0        2.03 ± 24%  perf-profile.children.cycles-pp.add_pending_csums
      0.00            +2.0        2.03 ± 24%  perf-profile.children.cycles-pp.btrfs_csum_file_blocks
      0.00            +2.0        2.04 ± 57%  perf-profile.children.cycles-pp.tick_sched_handle
      0.00            +2.1        2.14 ± 21%  perf-profile.children.cycles-pp.__extent_writepage
      0.00            +2.1        2.15 ± 12%  perf-profile.children.cycles-pp.tick_nohz_next_event
      0.00            +2.2        2.23 ± 21%  perf-profile.children.cycles-pp.extent_writepages
      0.00            +2.2        2.23 ± 21%  perf-profile.children.cycles-pp.extent_write_cache_pages
      0.00            +2.5        2.46 ± 11%  perf-profile.children.cycles-pp.__softirqentry_text_start
      0.00            +2.5        2.48 ± 32%  perf-profile.children.cycles-pp.flush_space
      0.00            +2.5        2.48 ± 13%  perf-profile.children.cycles-pp.do_softirq_own_stack
      0.00            +2.5        2.48 ± 33%  perf-profile.children.cycles-pp.btrfs_async_reclaim_metadata_space
      0.00            +2.5        2.49 ±  8%  perf-profile.children.cycles-pp.tick_nohz_get_sleep_length
      0.00            +2.5        2.50 ± 45%  perf-profile.children.cycles-pp.tick_sched_timer
      0.00            +2.5        2.54 ± 31%  perf-profile.children.cycles-pp.__btrfs_cow_block
      0.00            +2.5        2.55 ± 32%  perf-profile.children.cycles-pp.btrfs_cow_block
      0.00            +2.6        2.60 ± 20%  perf-profile.children.cycles-pp.check_extent_data_item
      0.00            +2.6        2.63 ± 28%  perf-profile.children.cycles-pp.ktime_get
      0.00            +2.6        2.65 ± 19%  perf-profile.children.cycles-pp.btrfs_get_32
      0.00            +2.9        2.92 ± 12%  perf-profile.children.cycles-pp.irq_exit_rcu
      0.00            +2.9        2.94 ± 25%  perf-profile.children.cycles-pp.btrfs_mark_extent_written
      0.00            +3.9        3.89 ± 43%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.00            +5.7        5.72 ± 24%  perf-profile.children.cycles-pp.btrfs_search_slot
      0.00            +6.3        6.26 ± 21%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.00            +6.4        6.41 ± 22%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.00            +6.8        6.84 ± 24%  perf-profile.children.cycles-pp.btrfs_finish_ordered_io
      0.00            +6.9        6.90 ± 19%  perf-profile.children.cycles-pp.check_leaf
      0.00            +7.0        7.00 ± 19%  perf-profile.children.cycles-pp.btree_csum_one_bio
      0.00            +7.1        7.06 ± 24%  perf-profile.children.cycles-pp.btrfs_work_helper
      0.00            +7.2        7.19 ± 19%  perf-profile.children.cycles-pp.btree_submit_bio_hook
      0.00            +7.3        7.29 ± 19%  perf-profile.children.cycles-pp.submit_extent_page
      0.00            +7.3        7.33 ± 19%  perf-profile.children.cycles-pp.submit_one_bio
      0.00            +7.4        7.41 ± 19%  perf-profile.children.cycles-pp.write_one_eb
      0.00            +7.7        7.68 ± 19%  perf-profile.children.cycles-pp.btree_write_cache_pages
      0.00            +9.4        9.45 ± 20%  perf-profile.children.cycles-pp.__writeback_single_inode
      0.00            +9.4        9.45 ± 20%  perf-profile.children.cycles-pp.wb_writeback
      0.00            +9.4        9.45 ± 20%  perf-profile.children.cycles-pp.writeback_sb_inodes
      0.00            +9.5        9.45 ± 20%  perf-profile.children.cycles-pp.wb_workfn
      0.00            +9.6        9.63 ± 20%  perf-profile.children.cycles-pp.asm_call_on_stack
      0.00            +9.9        9.92 ± 19%  perf-profile.children.cycles-pp.do_writepages
      0.00           +11.6       11.55 ± 16%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.00           +16.1       16.05 ± 43%  perf-profile.children.cycles-pp.menu_select
      0.00           +16.6       16.56 ±  8%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.00           +19.1       19.14 ± 22%  perf-profile.children.cycles-pp.process_one_work
      0.00           +19.3       19.29 ± 22%  perf-profile.children.cycles-pp.worker_thread
      0.00           +19.4       19.36 ± 22%  perf-profile.children.cycles-pp.kthread
      0.00           +19.4       19.36 ± 22%  perf-profile.children.cycles-pp.ret_from_fork
     50.00 ± 23%     +27.1       77.12 ±  6%  perf-profile.children.cycles-pp.start_secondary
     50.00 ± 23%     +27.6       77.60 ±  6%  perf-profile.children.cycles-pp.do_idle
     50.00 ± 23%     +27.6       77.61 ±  6%  perf-profile.children.cycles-pp.secondary_startup_64
     50.00 ± 23%     +27.6       77.61 ±  6%  perf-profile.children.cycles-pp.cpu_startup_entry
     50.00 ± 23%     -15.2       34.80 ± 13%  perf-profile.self.cycles-pp.intel_idle
      4.77 ±100%      -4.8        0.00        perf-profile.self.cycles-pp.__handle_mm_fault
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.find_ref_head
      0.00            +0.1        0.06 ± 14%  perf-profile.self.cycles-pp.memzero_extent_buffer
      0.00            +0.1        0.06 ± 28%  perf-profile.self.cycles-pp.clockevents_program_event
      0.00            +0.1        0.06 ± 11%  perf-profile.self.cycles-pp.rcu_idle_exit
      0.00            +0.1        0.07 ± 26%  perf-profile.self.cycles-pp.__switch_to_asm
      0.00            +0.1        0.07 ± 33%  perf-profile.self.cycles-pp.mark_page_accessed
      0.00            +0.1        0.07 ± 31%  perf-profile.self.cycles-pp.__btrfs_cow_block
      0.00            +0.1        0.07 ± 35%  perf-profile.self.cycles-pp.__sysvec_apic_timer_interrupt
      0.00            +0.1        0.07 ± 38%  perf-profile.self.cycles-pp.__slab_free
      0.00            +0.1        0.08 ± 21%  perf-profile.self.cycles-pp.__switch_to
      0.00            +0.1        0.08 ± 23%  perf-profile.self.cycles-pp.__module_address
      0.00            +0.1        0.08 ± 32%  perf-profile.self.cycles-pp.get_next_timer_interrupt
      0.00            +0.1        0.08 ± 40%  perf-profile.self.cycles-pp.xas_find_marked
      0.00            +0.1        0.08 ± 17%  perf-profile.self.cycles-pp.btrfs_super_csum_size
      0.00            +0.1        0.08 ± 13%  perf-profile.self.cycles-pp.btrfs_search_slot
      0.00            +0.1        0.08 ± 15%  perf-profile.self.cycles-pp.clear_page_dirty_for_io
      0.00            +0.1        0.09 ± 35%  perf-profile.self.cycles-pp.crc_128
      0.00            +0.1        0.09 ± 34%  perf-profile.self.cycles-pp.kmem_cache_free
      0.00            +0.1        0.09 ±  8%  perf-profile.self.cycles-pp.kmem_cache_alloc
      0.00            +0.1        0.09 ± 25%  perf-profile.self.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.00            +0.1        0.10 ± 15%  perf-profile.self.cycles-pp.tick_sched_timer
      0.00            +0.1        0.10 ± 46%  perf-profile.self.cycles-pp.load_balance
      0.00            +0.1        0.10 ± 33%  perf-profile.self.cycles-pp.idle_cpu
      0.00            +0.1        0.10 ± 39%  perf-profile.self.cycles-pp.calc_global_load_tick
      0.00            +0.1        0.10 ± 44%  perf-profile.self.cycles-pp.memcpy_erms
      0.00            +0.1        0.11 ± 10%  perf-profile.self.cycles-pp.call_cpuidle
      0.00            +0.1        0.11 ± 87%  perf-profile.self.cycles-pp.sched_clock_cpu
      0.00            +0.1        0.11 ± 39%  perf-profile.self.cycles-pp.rb_erase
      0.00            +0.1        0.11 ± 14%  perf-profile.self.cycles-pp.rcu_dynticks_eqs_exit
      0.00            +0.1        0.11 ± 27%  perf-profile.self.cycles-pp.find_extent_buffer
      0.00            +0.1        0.11 ± 21%  perf-profile.self.cycles-pp.setup_items_for_insert
      0.00            +0.1        0.11 ± 14%  perf-profile.self.cycles-pp.rcu_dynticks_eqs_enter
      0.00            +0.1        0.11 ± 19%  perf-profile.self.cycles-pp.hrtimer_interrupt
      0.00            +0.1        0.12 ± 25%  perf-profile.self.cycles-pp.___might_sleep
      0.00            +0.1        0.12 ± 20%  perf-profile.self.cycles-pp.account_process_tick
      0.00            +0.1        0.12 ± 25%  perf-profile.self.cycles-pp.down_read
      0.00            +0.1        0.12 ± 21%  perf-profile.self.cycles-pp.__sched_text_start
      0.00            +0.1        0.12 ± 19%  perf-profile.self.cycles-pp.tsc_verify_tsc_adjust
      0.00            +0.1        0.12 ± 48%  perf-profile.self.cycles-pp.__hrtimer_run_queues
      0.00            +0.1        0.13 ± 23%  perf-profile.self.cycles-pp.rebalance_domains
      0.00            +0.1        0.13 ± 78%  perf-profile.self.cycles-pp.rb_next
      0.00            +0.1        0.13 ± 49%  perf-profile.self.cycles-pp.run_timer_softirq
      0.00            +0.1        0.14 ± 23%  perf-profile.self.cycles-pp.queued_write_lock_slowpath
      0.00            +0.1        0.14 ± 26%  perf-profile.self.cycles-pp.find_free_extent
      0.00            +0.1        0.14 ± 64%  perf-profile.self.cycles-pp.nr_iowait_cpu
      0.00            +0.1        0.15 ± 51%  perf-profile.self.cycles-pp.rb_insert_color
      0.00            +0.2        0.15 ± 48%  perf-profile.self.cycles-pp.update_rq_clock
      0.00            +0.2        0.15 ± 17%  perf-profile.self.cycles-pp.btrfs_comp_cpu_keys
      0.00            +0.2        0.15 ± 26%  perf-profile.self.cycles-pp.__hrtimer_next_event_base
      0.00            +0.2        0.16 ± 24%  perf-profile.self.cycles-pp._raw_spin_lock_irq
      0.00            +0.2        0.17 ± 19%  perf-profile.self.cycles-pp.run_local_timers
      0.00            +0.2        0.17 ± 27%  perf-profile.self.cycles-pp.xas_load
      0.00            +0.2        0.17 ± 28%  perf-profile.self.cycles-pp.__radix_tree_lookup
      0.00            +0.2        0.17 ± 27%  perf-profile.self.cycles-pp.__orc_find
      0.00            +0.2        0.17 ± 43%  perf-profile.self.cycles-pp.update_irq_load_avg
      0.00            +0.2        0.18 ± 18%  perf-profile.self.cycles-pp.add_delayed_ref_head
      0.00            +0.2        0.20 ±  9%  perf-profile.self.cycles-pp.__softirqentry_text_start
      0.00            +0.2        0.20 ±  4%  perf-profile.self.cycles-pp.perf_mux_hrtimer_handler
      0.00            +0.2        0.20 ± 29%  perf-profile.self.cycles-pp.arch_scale_freq_tick
      0.00            +0.2        0.21 ± 17%  perf-profile.self.cycles-pp.unwind_next_frame
      0.00            +0.2        0.21 ± 55%  perf-profile.self.cycles-pp.io_serial_in
      0.00            +0.2        0.22 ± 25%  perf-profile.self.cycles-pp.memmove
      0.00            +0.2        0.25 ±  5%  perf-profile.self.cycles-pp.__intel_pmu_enable_all
      0.00            +0.3        0.27 ± 15%  perf-profile.self.cycles-pp.__next_timer_interrupt
      0.00            +0.3        0.27 ± 39%  perf-profile.self.cycles-pp.generic_bin_search
      0.00            +0.3        0.29 ±  8%  perf-profile.self.cycles-pp.update_sd_lb_stats
      0.00            +0.3        0.30 ± 14%  perf-profile.self.cycles-pp.do_idle
      0.00            +0.3        0.30 ± 24%  perf-profile.self.cycles-pp.btrfs_get_8
      0.00            +0.3        0.33 ± 21%  perf-profile.self.cycles-pp.check_extent_data_item
      0.00            +0.4        0.36 ± 30%  perf-profile.self.cycles-pp.tick_nohz_next_event
      0.00            +0.4        0.36 ± 12%  perf-profile.self.cycles-pp.__lock_text_start
      0.00            +0.4        0.37 ± 23%  perf-profile.self.cycles-pp.btrfs_set_token_32
      0.00            +0.4        0.42 ± 13%  perf-profile.self.cycles-pp.native_sched_clock
      0.00            +0.4        0.42 ± 16%  perf-profile.self.cycles-pp.ktime_get_update_offsets_now
      0.00            +0.4        0.44 ±  7%  perf-profile.self.cycles-pp.read_tsc
      0.00            +0.5        0.46 ± 34%  perf-profile.self.cycles-pp.btrfs_get_token_32
      0.00            +0.5        0.47 ±106%  perf-profile.self.cycles-pp.rcu_sched_clock_irq
      0.00            +0.5        0.49 ± 10%  perf-profile.self.cycles-pp.lapic_next_deadline
      0.00            +0.5        0.51 ± 41%  perf-profile.self.cycles-pp._raw_spin_trylock
      0.00            +0.5        0.51 ± 38%  perf-profile.self.cycles-pp.__etree_search
      0.00            +0.5        0.52 ± 41%  perf-profile.self.cycles-pp.__lookup_extent_mapping
      0.00            +0.6        0.65 ± 17%  perf-profile.self.cycles-pp.irqtime_account_irq
      0.00            +0.7        0.65 ± 51%  perf-profile.self.cycles-pp.timekeeping_max_deferment
      0.00            +0.8        0.84 ± 19%  perf-profile.self.cycles-pp.read_extent_buffer
      0.00            +1.1        1.12 ± 44%  perf-profile.self.cycles-pp.copy_page
      0.00            +1.1        1.13 ± 23%  perf-profile.self.cycles-pp.check_setget_bounds
      0.00            +1.2        1.16 ± 22%  perf-profile.self.cycles-pp.check_leaf
      0.00            +1.2        1.22 ± 20%  perf-profile.self.cycles-pp.btrfs_get_64
      0.00            +2.0        1.96 ± 16%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      0.00            +2.0        2.04 ± 18%  perf-profile.self.cycles-pp.btrfs_get_32
      0.00            +2.2        2.23 ± 34%  perf-profile.self.cycles-pp.ktime_get
      0.00           +11.6       11.63 ± 50%  perf-profile.self.cycles-pp.cpuidle_enter_state
      0.00           +13.3       13.34 ± 51%  perf-profile.self.cycles-pp.menu_select
      9929 ± 19%    +275.1%      37243 ±  8%  softirqs.CPU0.RCU
      7725 ±  4%    +446.9%      42252 ±  4%  softirqs.CPU0.SCHED
     24234 ±  2%    +480.7%     140715 ± 10%  softirqs.CPU0.TIMER
      7563 ±  7%    +376.2%      36020 ±  8%  softirqs.CPU1.RCU
      5632 ±  3%    +592.5%      39000 ± 12%  softirqs.CPU1.SCHED
     19850          +585.1%     136004 ±  9%  softirqs.CPU1.TIMER
      7338 ±  5%    +385.9%      35657 ± 12%  softirqs.CPU10.RCU
      4924 ± 10%    +664.1%      37626 ±  9%  softirqs.CPU10.SCHED
     18937 ±  3%    +605.7%     133629 ± 10%  softirqs.CPU10.TIMER
      6745 ±  6%    +435.1%      36096 ± 16%  softirqs.CPU100.RCU
      5306 ±  2%    +567.5%      35423 ± 20%  softirqs.CPU100.SCHED
     18790 ±  4%    +586.9%     129065 ± 11%  softirqs.CPU100.TIMER
      6804 ±  7%    +432.2%      36211 ± 16%  softirqs.CPU101.RCU
      5317 ±  3%    +644.8%      39603 ±  2%  softirqs.CPU101.SCHED
     19083 ±  4%    +579.8%     129734 ± 11%  softirqs.CPU101.TIMER
      7404 ± 11%    +349.3%      33265 ±  3%  softirqs.CPU102.RCU
      5550 ±  7%    +580.5%      37773 ±  4%  softirqs.CPU102.SCHED
     18967 ±  3%    +577.1%     128424 ± 10%  softirqs.CPU102.TIMER
      6864 ±  5%    +422.2%      35845 ± 14%  softirqs.CPU103.RCU
      5330 ±  4%    +635.8%      39220 ±  2%  softirqs.CPU103.SCHED
     18679 ±  5%    +594.3%     129694 ± 10%  softirqs.CPU103.TIMER
      6945 ±  6%    +393.1%      34249 ±  6%  softirqs.CPU104.RCU
      5287 ±  4%    +645.7%      39430        softirqs.CPU104.SCHED
     18858 ±  2%    +586.2%     129410 ± 10%  softirqs.CPU104.TIMER
      6717 ±  4%    +440.1%      36280 ± 15%  softirqs.CPU105.RCU
      4916 ± 10%    +697.7%      39221        softirqs.CPU105.SCHED
     18633 ±  2%    +600.2%     130475 ± 10%  softirqs.CPU105.TIMER
      6933 ±  5%    +421.7%      36171 ± 18%  softirqs.CPU106.RCU
      4959 ±  8%    +707.5%      40046 ±  4%  softirqs.CPU106.SCHED
     18385 ±  2%    +611.4%     130796 ± 12%  softirqs.CPU106.TIMER
      6815 ±  4%    +424.8%      35766 ± 14%  softirqs.CPU107.RCU
      5342 ±  2%    +639.0%      39480 ±  2%  softirqs.CPU107.SCHED
     18823 ±  2%    +587.4%     129388 ± 11%  softirqs.CPU107.TIMER
      6677 ±  4%    +429.1%      35335 ± 12%  softirqs.CPU108.RCU
      5081 ±  9%    +676.4%      39454        softirqs.CPU108.SCHED
     18551 ±  2%    +594.5%     128846 ± 10%  softirqs.CPU108.TIMER
      6563 ±  3%    +429.7%      34768 ± 12%  softirqs.CPU109.RCU
      5297 ±  2%    +609.6%      37590 ±  8%  softirqs.CPU109.SCHED
     18539 ±  2%    +604.9%     130674 ±  9%  softirqs.CPU109.TIMER
      7671 ±  8%    +360.1%      35292 ± 11%  softirqs.CPU11.RCU
      5481 ±  5%    +603.4%      38557 ±  5%  softirqs.CPU11.SCHED
     19914 ±  5%    +565.8%     132592 ± 11%  softirqs.CPU11.TIMER
      6707 ±  4%    +426.4%      35310 ± 13%  softirqs.CPU110.RCU
      4972 ± 11%    +703.5%      39953 ±  2%  softirqs.CPU110.SCHED
     18639 ±  2%    +603.4%     131105 ± 10%  softirqs.CPU110.TIMER
      6526 ±  3%    +435.8%      34964 ± 15%  softirqs.CPU111.RCU
      5261 ±  2%    +648.7%      39393        softirqs.CPU111.SCHED
     18487 ±  2%    +604.9%     130317 ± 10%  softirqs.CPU111.TIMER
      6375 ±  6%    +402.7%      32049 ±  7%  softirqs.CPU112.RCU
      5288 ±  3%    +644.6%      39379 ±  2%  softirqs.CPU112.SCHED
     18429 ±  3%    +596.5%     128361 ± 11%  softirqs.CPU112.TIMER
      6376 ±  5%    +407.6%      32366 ±  7%  softirqs.CPU113.RCU
      5106 ±  7%    +670.7%      39354        softirqs.CPU113.SCHED
     18514 ±  2%    +598.1%     129257 ± 11%  softirqs.CPU113.TIMER
      6447 ±  3%    +413.3%      33093 ± 11%  softirqs.CPU114.RCU
      5258 ±  2%    +646.2%      39240 ±  2%  softirqs.CPU114.SCHED
     18546 ±  2%    +601.2%     130050 ± 11%  softirqs.CPU114.TIMER
      6361 ±  4%    +418.0%      32950 ± 11%  softirqs.CPU115.RCU
      5268 ±  2%    +644.8%      39237 ±  2%  softirqs.CPU115.SCHED
     18389 ±  3%    +607.5%     130112 ± 11%  softirqs.CPU115.TIMER
      6377 ±  4%    +404.8%      32196 ±  8%  softirqs.CPU116.RCU
      4865 ± 14%    +712.1%      39510 ±  2%  softirqs.CPU116.SCHED
     18637 ±  3%    +600.1%     130485 ± 12%  softirqs.CPU116.TIMER
      6664 ±  9%    +381.7%      32102 ±  8%  softirqs.CPU117.RCU
      5246 ±  3%    +524.5%      32764 ± 32%  softirqs.CPU117.SCHED
     19461 ±  8%    +565.4%     129501 ± 10%  softirqs.CPU117.TIMER
      6405 ±  4%    +410.6%      32705 ± 10%  softirqs.CPU118.RCU
      5297 ±  2%    +650.9%      39781 ±  2%  softirqs.CPU118.SCHED
     18629 ±  2%    +601.0%     130592 ± 11%  softirqs.CPU118.TIMER
      6370 ±  6%    +406.1%      32240 ±  8%  softirqs.CPU119.RCU
      5270 ±  3%    +643.2%      39170        softirqs.CPU119.SCHED
     18376 ±  2%    +603.0%     129194 ± 11%  softirqs.CPU119.TIMER
    158.25 ± 15%   +2643.0%       4340 ±150%  softirqs.CPU12.NET_RX
      7430 ±  4%    +384.3%      35986 ± 10%  softirqs.CPU12.RCU
      4872 ± 11%    +702.9%      39119 ±  3%  softirqs.CPU12.SCHED
     19056 ±  2%    +603.6%     134089 ± 11%  softirqs.CPU12.TIMER
      6417 ±  3%    +390.5%      31473 ±  5%  softirqs.CPU120.RCU
      5418          +603.9%      38137 ±  9%  softirqs.CPU120.SCHED
     19298 ±  3%    +563.0%     127952 ±  8%  softirqs.CPU120.TIMER
      6483 ±  4%    +389.2%      31716 ±  5%  softirqs.CPU121.RCU
      5080 ±  9%    +666.6%      38946 ±  4%  softirqs.CPU121.SCHED
     19017 ±  3%    +565.5%     126565 ± 11%  softirqs.CPU121.TIMER
      6424 ±  3%    +398.1%      31998 ±  6%  softirqs.CPU122.RCU
      5288 ±  4%    +644.3%      39362 ±  2%  softirqs.CPU122.SCHED
     18685 ±  4%    +582.5%     127527 ± 11%  softirqs.CPU122.TIMER
      7462 ± 27%    +321.6%      31461 ±  6%  softirqs.CPU123.RCU
      5454 ±  3%    +612.9%      38887 ±  4%  softirqs.CPU123.SCHED
     20044 ± 10%    +529.7%     126218 ± 11%  softirqs.CPU123.TIMER
      6664 ±  7%    +384.0%      32255 ±  6%  softirqs.CPU124.RCU
      5807 ±  8%    +571.2%      38979 ±  5%  softirqs.CPU124.SCHED
     19465 ±  3%    +556.5%     127800 ± 10%  softirqs.CPU124.TIMER
      6528 ±  3%    +385.6%      31705 ±  6%  softirqs.CPU125.RCU
      5413 ±  2%    +616.6%      38791 ±  7%  softirqs.CPU125.SCHED
     18994          +569.8%     127225 ±  9%  softirqs.CPU125.TIMER
      6753 ±  3%    +370.0%      31740 ±  6%  softirqs.CPU126.RCU
      5406          +606.8%      38212 ±  8%  softirqs.CPU126.SCHED
     19088          +559.9%     125967 ± 10%  softirqs.CPU126.TIMER
      6823 ± 10%    +359.2%      31335 ±  5%  softirqs.CPU127.RCU
      5385          +593.8%      37364 ± 12%  softirqs.CPU127.SCHED
     18756          +566.3%     124972 ±  9%  softirqs.CPU127.TIMER
      6561 ±  3%    +423.1%      34321 ±  7%  softirqs.CPU128.RCU
      5362          +595.0%      37267 ± 12%  softirqs.CPU128.SCHED
     18749          +562.2%     124165 ±  8%  softirqs.CPU128.TIMER
      6607 ±  3%    +420.0%      34358 ± 12%  softirqs.CPU129.RCU
      5371 ±  2%    +609.2%      38092 ±  8%  softirqs.CPU129.SCHED
     18808          +572.1%     126407 ± 12%  softirqs.CPU129.TIMER
      7340 ±  4%    +378.8%      35147 ± 10%  softirqs.CPU13.RCU
      5315 ±  2%    +640.0%      39332 ±  2%  softirqs.CPU13.SCHED
     19274 ±  4%    +598.9%     134712 ± 10%  softirqs.CPU13.TIMER
      6551 ±  2%    +422.0%      34203 ±  7%  softirqs.CPU130.RCU
      5058 ± 13%    +651.7%      38026 ±  9%  softirqs.CPU130.SCHED
     18805          +571.1%     126203 ±  9%  softirqs.CPU130.TIMER
      6971 ± 11%    +406.9%      35337 ± 13%  softirqs.CPU131.RCU
      5407 ±  2%    +633.0%      39635 ±  2%  softirqs.CPU131.SCHED
     19024          +574.8%     128382 ± 10%  softirqs.CPU131.TIMER
      6523 ±  2%    +422.6%      34092 ± 10%  softirqs.CPU132.RCU
      5393          +531.7%      34068 ± 20%  softirqs.CPU132.SCHED
     18699          +576.7%     126544 ±  9%  softirqs.CPU132.TIMER
      6872 ±  7%    +407.9%      34906 ± 10%  softirqs.CPU133.RCU
      5390          +627.2%      39197 ±  3%  softirqs.CPU133.SCHED
     18833          +573.1%     126762 ± 11%  softirqs.CPU133.TIMER
      6599 ±  3%    +423.6%      34554 ±  9%  softirqs.CPU134.RCU
      5405 ±  2%    +631.6%      39549        softirqs.CPU134.SCHED
     18731          +571.7%     125829 ± 11%  softirqs.CPU134.TIMER
      6543 ±  3%    +427.1%      34491 ±  9%  softirqs.CPU135.RCU
      5466 ±  2%    +568.6%      36548 ± 16%  softirqs.CPU135.SCHED
     18926 ±  2%    +565.2%     125886 ± 10%  softirqs.CPU135.TIMER
      6535 ±  3%    +435.1%      34966 ± 10%  softirqs.CPU136.RCU
      5380 ±  2%    +611.0%      38254 ±  8%  softirqs.CPU136.SCHED
     18901 ±  3%    +569.8%     126604 ± 10%  softirqs.CPU136.TIMER
      6585 ±  3%    +426.6%      34680 ±  7%  softirqs.CPU137.RCU
      5429 ±  2%    +594.1%      37684 ± 11%  softirqs.CPU137.SCHED
     18988 ±  2%    +562.2%     125741 ±  9%  softirqs.CPU137.TIMER
      6567 ±  3%    +428.7%      34720 ±  8%  softirqs.CPU138.RCU
      5415 ±  2%    +605.1%      38183 ±  9%  softirqs.CPU138.SCHED
     18872 ±  2%    +572.8%     126980 ±  8%  softirqs.CPU138.TIMER
      7237 ±  9%    +382.5%      34920 ±  8%  softirqs.CPU139.RCU
      5319 ±  3%    +611.6%      37855 ±  9%  softirqs.CPU139.SCHED
     19559 ±  6%    +539.8%     125130 ±  8%  softirqs.CPU139.TIMER
      7400 ±  4%    +380.9%      35586 ± 11%  softirqs.CPU14.RCU
      5214          +654.4%      39333 ±  2%  softirqs.CPU14.SCHED
     19159 ±  3%    +604.4%     134951 ± 10%  softirqs.CPU14.TIMER
      6535 ±  3%    +431.8%      34757 ± 10%  softirqs.CPU140.RCU
      5424 ±  2%    +606.8%      38340 ±  7%  softirqs.CPU140.SCHED
     18805          +568.7%     125746 ± 10%  softirqs.CPU140.TIMER
      6632          +421.9%      34613 ±  9%  softirqs.CPU141.RCU
      5461 ±  2%    +607.2%      38619 ±  6%  softirqs.CPU141.SCHED
     18835 ±  2%    +572.5%     126669 ± 11%  softirqs.CPU141.TIMER
      6607 ±  3%    +418.0%      34228 ±  8%  softirqs.CPU142.RCU
      5410          +603.0%      38037 ±  9%  softirqs.CPU142.SCHED
     19045          +565.3%     126713 ±  9%  softirqs.CPU142.TIMER
      6552 ±  3%    +427.9%      34593 ± 10%  softirqs.CPU143.RCU
      5408          +616.1%      38733 ±  5%  softirqs.CPU143.SCHED
     18719 ±  2%    +571.1%     125618 ± 10%  softirqs.CPU143.TIMER
      6889 ±  8%    +407.1%      34934 ±  8%  softirqs.CPU144.RCU
      5369          +540.7%      34401 ± 20%  softirqs.CPU144.SCHED
     18794 ±  2%    +582.6%     128291 ±  8%  softirqs.CPU144.TIMER
      6481 ±  3%    +431.9%      34474 ±  7%  softirqs.CPU145.RCU
      5377 ±  2%    +641.0%      39844        softirqs.CPU145.SCHED
     18616 ±  2%    +578.1%     126234 ± 10%  softirqs.CPU145.TIMER
      6439 ±  3%    +431.8%      34246 ±  7%  softirqs.CPU146.RCU
      5367          +636.2%      39513        softirqs.CPU146.SCHED
     18650 ±  2%    +579.4%     126710 ± 10%  softirqs.CPU146.TIMER
      6489 ±  3%    +437.0%      34847 ± 10%  softirqs.CPU147.RCU
      5353          +644.6%      39859 ±  2%  softirqs.CPU147.SCHED
     18706          +573.9%     126072 ± 10%  softirqs.CPU147.TIMER
      6558 ±  3%    +430.9%      34813 ± 10%  softirqs.CPU148.RCU
      5438          +636.0%      40022        softirqs.CPU148.SCHED
     18809 ±  2%    +579.1%     127744 ± 10%  softirqs.CPU148.TIMER
      6481 ±  2%    +437.3%      34823 ± 10%  softirqs.CPU149.RCU
      5398          +562.0%      35736 ± 20%  softirqs.CPU149.SCHED
     18837          +578.6%     127835 ±  9%  softirqs.CPU149.TIMER
      7192 ±  3%    +385.8%      34937 ± 12%  softirqs.CPU15.RCU
      4933 ± 13%    +692.4%      39093 ±  2%  softirqs.CPU15.SCHED
     19002 ±  2%    +605.3%     134017 ± 10%  softirqs.CPU15.TIMER
      6503 ±  2%    +435.7%      34839 ±  9%  softirqs.CPU150.RCU
      5343          +648.6%      39995        softirqs.CPU150.SCHED
     18649 ±  2%    +579.3%     126678 ± 10%  softirqs.CPU150.TIMER
      6838 ±  9%    +419.3%      35514 ± 13%  softirqs.CPU151.RCU
      5313 ±  2%    +651.2%      39914        softirqs.CPU151.SCHED
     19167 ±  4%    +567.0%     127856 ± 10%  softirqs.CPU151.TIMER
      6664 ±  3%    +442.0%      36120 ± 12%  softirqs.CPU152.RCU
      5370 ± 15%    +650.9%      40327        softirqs.CPU152.SCHED
     18888 ±  3%    +575.6%     127615 ± 10%  softirqs.CPU152.TIMER
      6779 ±  7%    +418.5%      35152 ± 13%  softirqs.CPU153.RCU
      5505 ±  4%    +622.4%      39770        softirqs.CPU153.SCHED
     19241 ±  6%    +553.3%     125704 ± 10%  softirqs.CPU153.TIMER
      6446 ±  3%    +446.5%      35227 ± 13%  softirqs.CPU154.RCU
      5350          +644.8%      39848        softirqs.CPU154.SCHED
     18631          +576.1%     125962 ± 10%  softirqs.CPU154.TIMER
      6470 ±  2%    +446.0%      35329 ± 13%  softirqs.CPU155.RCU
      5437          +633.9%      39906        softirqs.CPU155.SCHED
     18909 ±  2%    +568.7%     126453 ±  9%  softirqs.CPU155.TIMER
      6486 ±  3%    +448.2%      35554 ± 13%  softirqs.CPU156.RCU
      5395          +642.1%      40035        softirqs.CPU156.SCHED
     18659 ±  2%    +576.5%     126240 ± 10%  softirqs.CPU156.TIMER
      6373 ±  3%    +447.8%      34918 ± 10%  softirqs.CPU157.RCU
      5327          +565.4%      35450 ± 20%  softirqs.CPU157.SCHED
     18452          +585.6%     126513 ±  9%  softirqs.CPU157.TIMER
      6426 ±  3%    +445.7%      35065 ±  9%  softirqs.CPU158.RCU
      5428 ±  2%    +636.3%      39970        softirqs.CPU158.SCHED
     18536          +580.7%     126181 ± 10%  softirqs.CPU158.TIMER
      7106 ± 10%    +389.2%      34765 ±  9%  softirqs.CPU159.RCU
      5371          +646.6%      40107        softirqs.CPU159.SCHED
     19996 ±  7%    +533.6%     126694 ±  9%  softirqs.CPU159.TIMER
      7066 ±  2%    +357.3%      32318 ±  4%  softirqs.CPU16.RCU
      5291 ±  3%    +552.3%      34517 ± 20%  softirqs.CPU16.SCHED
     19126          +583.2%     130671 ± 10%  softirqs.CPU16.TIMER
      6414 ±  4%    +424.5%      33643 ±  7%  softirqs.CPU160.RCU
      5356          +637.7%      39515        softirqs.CPU160.SCHED
     18510          +579.2%     125728 ± 10%  softirqs.CPU160.TIMER
      6753 ±  6%    +422.3%      35271 ± 12%  softirqs.CPU161.RCU
      5530 ±  4%    +622.5%      39956        softirqs.CPU161.SCHED
     18837          +566.6%     125572 ± 10%  softirqs.CPU161.TIMER
      6398 ±  4%    +451.6%      35291 ± 11%  softirqs.CPU162.RCU
      5365 ±  2%    +645.9%      40019        softirqs.CPU162.SCHED
     18641          +579.4%     126643 ±  9%  softirqs.CPU162.TIMER
      6386 ±  3%    +451.9%      35245 ± 11%  softirqs.CPU163.RCU
      5312 ±  2%    +648.6%      39766        softirqs.CPU163.SCHED
     18426          +584.7%     126169 ± 10%  softirqs.CPU163.TIMER
      6368 ±  3%    +458.9%      35594 ± 11%  softirqs.CPU164.RCU
      5369          +644.0%      39951        softirqs.CPU164.SCHED
     18559 ±  2%    +577.3%     125695 ± 10%  softirqs.CPU164.TIMER
      6574 ±  5%    +434.4%      35133 ± 10%  softirqs.CPU165.RCU
      5481 ±  5%    +629.5%      39986        softirqs.CPU165.SCHED
     18637 ±  2%    +575.6%     125918 ± 10%  softirqs.CPU165.TIMER
      6582 ±  2%    +426.9%      34681 ± 10%  softirqs.CPU166.RCU
      5463          +631.9%      39988        softirqs.CPU166.SCHED
     18982 ±  2%    +568.0%     126810 ±  9%  softirqs.CPU166.TIMER
      6459 ±  3%    +427.7%      34084 ± 10%  softirqs.CPU167.RCU
      5475 ±  2%    +628.5%      39891 ±  2%  softirqs.CPU167.SCHED
     18716 ±  2%    +570.7%     125523 ± 10%  softirqs.CPU167.TIMER
      6286 ±  2%    +437.8%      33808 ± 10%  softirqs.CPU168.RCU
      5320          +494.8%      31643 ± 26%  softirqs.CPU168.SCHED
     18449          +596.5%     128501 ±  9%  softirqs.CPU168.TIMER
      6145 ±  4%    +427.7%      32430 ±  6%  softirqs.CPU169.RCU
      5326 ±  2%    +654.2%      40176        softirqs.CPU169.SCHED
     18200 ±  3%    +600.8%     127549 ±  9%  softirqs.CPU169.TIMER
      7028 ±  2%    +373.9%      33305 ±  5%  softirqs.CPU17.RCU
      5303 ±  4%    +631.0%      38765        softirqs.CPU17.SCHED
     18849          +597.6%     131488 ± 11%  softirqs.CPU17.TIMER
      6537 ±  6%    +395.2%      32373 ±  7%  softirqs.CPU170.RCU
      5383          +609.7%      38202 ±  9%  softirqs.CPU170.SCHED
     18379          +587.9%     126439 ±  7%  softirqs.CPU170.TIMER
      6064 ±  4%    +450.9%      33409 ± 12%  softirqs.CPU171.RCU
      5359          +653.0%      40355        softirqs.CPU171.SCHED
     18159 ±  2%    +606.6%     128309 ± 10%  softirqs.CPU171.TIMER
      6120 ±  5%    +446.2%      33434 ± 12%  softirqs.CPU172.RCU
      5077 ± 11%    +695.6%      40394        softirqs.CPU172.SCHED
     18276 ±  2%    +600.4%     128011 ± 10%  softirqs.CPU172.TIMER
      6183 ±  4%    +448.1%      33889 ± 12%  softirqs.CPU173.RCU
      5391          +592.0%      37306 ± 14%  softirqs.CPU173.SCHED
     18435 ±  2%    +601.3%     129282 ± 10%  softirqs.CPU173.TIMER
      6546 ± 15%    +407.8%      33243 ± 12%  softirqs.CPU174.RCU
      5379          +648.1%      40246        softirqs.CPU174.SCHED
     18359 ±  2%    +598.5%     128239 ± 10%  softirqs.CPU174.TIMER
      6245 ±  5%    +426.1%      32855 ±  9%  softirqs.CPU175.RCU
      5040 ± 12%    +696.7%      40155        softirqs.CPU175.SCHED
     18342 ±  2%    +585.9%     125800 ±  9%  softirqs.CPU175.TIMER
      6294 ±  7%    +430.5%      33386 ±  9%  softirqs.CPU176.RCU
      5377 ±  2%    +646.6%      40152        softirqs.CPU176.SCHED
     18322 ±  2%    +594.7%     127276 ± 10%  softirqs.CPU176.TIMER
      6226 ±  7%    +439.2%      33572 ±  7%  softirqs.CPU177.RCU
      5373 ±  2%    +649.5%      40276        softirqs.CPU177.SCHED
     18166 ±  4%    +601.1%     127367 ± 10%  softirqs.CPU177.TIMER
      6550 ± 12%    +423.0%      34261 ±  8%  softirqs.CPU178.RCU
      5384 ±  2%    +572.9%      36234 ± 21%  softirqs.CPU178.SCHED
     18267 ±  2%    +604.0%     128610 ± 10%  softirqs.CPU178.TIMER
      6185 ±  6%    +463.1%      34826 ± 13%  softirqs.CPU179.RCU
      5360 ±  2%    +652.0%      40311        softirqs.CPU179.SCHED
     18141 ±  3%    +600.4%     127053 ± 10%  softirqs.CPU179.TIMER
      7371          +359.3%      33855 ±  7%  softirqs.CPU18.RCU
      5200 ±  2%    +642.0%      38581 ±  2%  softirqs.CPU18.SCHED
     19031          +592.7%     131837 ± 11%  softirqs.CPU18.TIMER
      6486 ±  7%    +431.1%      34452 ± 11%  softirqs.CPU180.RCU
      5294          +660.6%      40270        softirqs.CPU180.SCHED
     18554 ±  4%    +583.9%     126890 ±  9%  softirqs.CPU180.TIMER
      6203 ±  6%    +467.8%      35224 ± 12%  softirqs.CPU181.RCU
      5347 ±  2%    +647.3%      39959        softirqs.CPU181.SCHED
     18030 ±  3%    +605.8%     127252 ±  9%  softirqs.CPU181.TIMER
      6192 ±  6%    +460.3%      34699 ± 14%  softirqs.CPU182.RCU
      5368 ±  2%    +648.7%      40196        softirqs.CPU182.SCHED
     18378 ±  3%    +593.5%     127450 ± 10%  softirqs.CPU182.TIMER
      6173 ±  6%    +464.0%      34817 ± 13%  softirqs.CPU183.RCU
      5338 ±  2%    +652.1%      40144        softirqs.CPU183.SCHED
     18127          +599.2%     126746 ± 10%  softirqs.CPU183.TIMER
      7264 ± 21%    +385.9%      35293 ± 14%  softirqs.CPU184.RCU
      5241 ±  5%    +666.4%      40170        softirqs.CPU184.SCHED
     19299 ±  7%    +558.9%     127161 ± 10%  softirqs.CPU184.TIMER
      6283 ±  3%    +468.2%      35700 ± 14%  softirqs.CPU185.RCU
      5384          +651.3%      40451        softirqs.CPU185.SCHED
     18454          +602.1%     129562 ±  9%  softirqs.CPU185.TIMER
      6214 ±  6%    +453.4%      34389 ± 10%  softirqs.CPU186.RCU
      5344 ±  2%    +650.9%      40128        softirqs.CPU186.SCHED
     18212 ±  3%    +594.7%     126516 ± 11%  softirqs.CPU186.TIMER
      6293 ±  3%    +468.0%      35747 ± 15%  softirqs.CPU187.RCU
      5431          +644.0%      40413        softirqs.CPU187.SCHED
     18195 ±  3%    +598.3%     127060 ± 10%  softirqs.CPU187.TIMER
      6437 ±  6%    +438.7%      34679 ± 15%  softirqs.CPU188.RCU
      5504 ±  2%    +628.9%      40124        softirqs.CPU188.SCHED
     18667 ±  4%    +578.5%     126653 ± 10%  softirqs.CPU188.TIMER
      6336 ±  8%    +451.9%      34968 ± 13%  softirqs.CPU189.RCU
      5117 ± 14%    +684.3%      40137        softirqs.CPU189.SCHED
     18430 ±  5%    +587.5%     126708 ± 10%  softirqs.CPU189.TIMER
      6964 ±  3%    +380.5%      33463 ±  5%  softirqs.CPU19.RCU
      5029 ±  4%    +667.7%      38614        softirqs.CPU19.SCHED
     18684 ±  3%    +604.9%     131704 ± 10%  softirqs.CPU19.TIMER
      6346 ±  7%    +436.3%      34033 ±  7%  softirqs.CPU190.RCU
      5459 ±  4%    +643.2%      40576        softirqs.CPU190.SCHED
     18874 ±  4%    +596.8%     131509 ±  8%  softirqs.CPU190.TIMER
      6163 ±  5%    +453.2%      34093 ±  8%  softirqs.CPU191.RCU
      5375          +648.7%      40245        softirqs.CPU191.SCHED
     18150          +600.9%     127220 ± 10%  softirqs.CPU191.TIMER
      7507 ±  7%    +385.5%      36444 ±  7%  softirqs.CPU2.RCU
      5009 ± 12%    +682.2%      39187 ±  3%  softirqs.CPU2.SCHED
     19156 ±  3%    +599.4%     133988 ± 10%  softirqs.CPU2.TIMER
      7041 ±  4%    +367.9%      32946 ±  6%  softirqs.CPU20.RCU
      5121          +663.2%      39085 ±  2%  softirqs.CPU20.SCHED
     18825 ±  2%    +604.8%     132679 ± 10%  softirqs.CPU20.TIMER
      6890 ±  5%    +381.1%      33151 ±  6%  softirqs.CPU21.RCU
      5120 ±  3%    +664.5%      39146        softirqs.CPU21.SCHED
     18735 ±  3%    +617.9%     134493 ± 10%  softirqs.CPU21.TIMER
      7314 ±  8%    +354.1%      33212 ±  7%  softirqs.CPU22.RCU
      5151 ±  2%    +659.4%      39123        softirqs.CPU22.SCHED
     19722 ±  5%    +574.1%     132956 ±  9%  softirqs.CPU22.TIMER
      7556 ± 13%    +342.6%      33446 ±  6%  softirqs.CPU23.RCU
      5106 ±  3%    +658.3%      38718        softirqs.CPU23.SCHED
     19588 ±  5%    +581.4%     133477 ± 10%  softirqs.CPU23.TIMER
      6818          +381.5%      32828 ±  7%  softirqs.CPU24.RCU
      5272 ±  2%    +681.0%      41175 ± 10%  softirqs.CPU24.SCHED
     19857 ± 10%    +511.9%     121506 ± 16%  softirqs.CPU24.TIMER
      6943 ±  2%    +367.1%      32433 ±  4%  softirqs.CPU25.RCU
      5259          +673.5%      40679 ±  9%  softirqs.CPU25.SCHED
     18748          +543.6%     120658 ± 17%  softirqs.CPU25.TIMER
      6986 ±  3%    +363.3%      32369 ±  6%  softirqs.CPU26.RCU
      3439 ± 32%   +1067.5%      40149 ± 13%  softirqs.CPU26.SCHED
     15431 ± 12%    +663.2%     117776 ± 18%  softirqs.CPU26.TIMER
      6893 ±  3%    +372.8%      32594 ±  6%  softirqs.CPU27.RCU
      4837 ± 16%    +777.4%      42444 ± 17%  softirqs.CPU27.SCHED
     17406 ± 13%    +591.6%     120379 ± 16%  softirqs.CPU27.TIMER
      6818 ±  3%    +370.9%      32110 ±  6%  softirqs.CPU28.RCU
      4980 ±  7%    +692.5%      39468 ±  5%  softirqs.CPU28.SCHED
     18791          +537.9%     119870 ± 16%  softirqs.CPU28.TIMER
      6883 ±  3%    +371.9%      32480 ±  5%  softirqs.CPU29.RCU
      5198          +653.0%      39145 ±  3%  softirqs.CPU29.SCHED
     18484          +548.4%     119852 ± 16%  softirqs.CPU29.TIMER
      7446 ±  5%    +383.3%      35992 ± 14%  softirqs.CPU3.RCU
      4851 ±  9%    +707.3%      39166 ±  4%  softirqs.CPU3.SCHED
     19043 ±  2%    +592.4%     131862 ± 12%  softirqs.CPU3.TIMER
      7467 ± 14%    +335.1%      32491 ±  5%  softirqs.CPU30.RCU
      5471 ±  8%    +615.1%      39125 ±  2%  softirqs.CPU30.SCHED
     19625 ±  9%    +515.5%     120800 ± 16%  softirqs.CPU30.TIMER
      6878 ±  2%    +383.4%      33248 ±  6%  softirqs.CPU31.RCU
      5193          +651.4%      39026 ±  2%  softirqs.CPU31.SCHED
     18574          +552.9%     121262 ± 18%  softirqs.CPU31.TIMER
      7160 ±  2%    +405.9%      36226 ±  7%  softirqs.CPU32.RCU
      5187          +649.5%      38874 ±  2%  softirqs.CPU32.SCHED
     18474          +557.3%     121434 ± 15%  softirqs.CPU32.TIMER
      7455 ±  6%    +349.4%      33503 ± 11%  softirqs.CPU33.RCU
      5261          +562.3%      34843 ± 23%  softirqs.CPU33.SCHED
     19872 ± 10%    +569.1%     132966 ± 17%  softirqs.CPU33.TIMER
      7114 ±  2%    +388.6%      34758 ±  7%  softirqs.CPU34.RCU
      5246          +613.5%      37434 ±  3%  softirqs.CPU34.SCHED
     18812 ±  2%    +534.3%     119321 ± 15%  softirqs.CPU34.TIMER
      7154 ±  2%    +388.6%      34957 ±  8%  softirqs.CPU35.RCU
      5283          +634.7%      38811 ±  2%  softirqs.CPU35.SCHED
     18712          +540.0%     119754 ± 16%  softirqs.CPU35.TIMER
      7044 ±  2%    +382.8%      34011 ± 12%  softirqs.CPU36.RCU
      5187          +644.3%      38609 ±  5%  softirqs.CPU36.SCHED
     18426          +616.8%     132080 ± 17%  softirqs.CPU36.TIMER
      7089 ±  3%    +393.7%      35003 ±  9%  softirqs.CPU37.RCU
      5205          +625.3%      37755 ±  2%  softirqs.CPU37.SCHED
     18508          +544.0%     119194 ± 17%  softirqs.CPU37.TIMER
      7023 ±  2%    +398.7%      35023 ±  9%  softirqs.CPU38.RCU
      5223          +630.5%      38159        softirqs.CPU38.SCHED
     18580          +548.7%     120538 ± 15%  softirqs.CPU38.TIMER
      7070 ±  3%    +398.8%      35266 ± 10%  softirqs.CPU39.RCU
      5129          +642.9%      38104        softirqs.CPU39.SCHED
     18485          +547.4%     119677 ± 16%  softirqs.CPU39.TIMER
      7348 ±  6%    +394.6%      36341 ± 13%  softirqs.CPU4.RCU
      5319 ±  3%    +636.0%      39151 ±  3%  softirqs.CPU4.SCHED
     19085 ±  2%    +590.6%     131807 ± 11%  softirqs.CPU4.TIMER
      7004 ±  2%    +408.9%      35644 ± 11%  softirqs.CPU40.RCU
      5194          +646.1%      38756 ±  2%  softirqs.CPU40.SCHED
     18435          +554.0%     120559 ± 17%  softirqs.CPU40.TIMER
      7292 ±  5%    +382.1%      35157 ±  8%  softirqs.CPU41.RCU
      5185 ±  3%    +646.8%      38726        softirqs.CPU41.SCHED
     19538 ±  6%    +512.3%     119632 ± 15%  softirqs.CPU41.TIMER
      6998 ±  2%    +404.5%      35310 ±  9%  softirqs.CPU42.RCU
      5232          +562.1%      34648 ± 20%  softirqs.CPU42.SCHED
     18573 ±  2%    +544.9%     119768 ± 16%  softirqs.CPU42.TIMER
      7116 ±  3%    +402.2%      35739 ±  9%  softirqs.CPU43.RCU
      5170          +647.5%      38644        softirqs.CPU43.SCHED
     18410          +552.6%     120139 ± 17%  softirqs.CPU43.TIMER
      7471 ± 11%    +368.1%      34978 ±  9%  softirqs.CPU44.RCU
      5249          +618.2%      37697 ±  3%  softirqs.CPU44.SCHED
     18597          +538.6%     118761 ± 15%  softirqs.CPU44.TIMER
      6995 ±  3%    +398.0%      34833 ±  8%  softirqs.CPU45.RCU
      5191          +635.2%      38167        softirqs.CPU45.SCHED
     18439          +547.3%     119356 ± 15%  softirqs.CPU45.TIMER
      7331 ± 11%    +373.5%      34718 ±  9%  softirqs.CPU46.RCU
      5314 ±  3%    +619.3%      38226 ±  2%  softirqs.CPU46.SCHED
     19745 ± 10%    +508.5%     120149 ± 14%  softirqs.CPU46.TIMER
      6900 ±  2%    +408.3%      35073 ±  9%  softirqs.CPU47.RCU
      5149          +562.4%      34113 ± 19%  softirqs.CPU47.SCHED
     18375          +551.3%     119683 ± 15%  softirqs.CPU47.TIMER
      7198 ±  3%    +407.5%      36527 ± 12%  softirqs.CPU48.RCU
      5221          +662.4%      39807        softirqs.CPU48.SCHED
     18427          +596.8%     128396 ± 13%  softirqs.CPU48.TIMER
      7248 ±  2%    +398.1%      36107 ±  9%  softirqs.CPU49.RCU
      5321 ±  3%    +634.1%      39065 ±  2%  softirqs.CPU49.SCHED
     18799 ±  4%    +572.8%     126478 ± 15%  softirqs.CPU49.TIMER
      7486 ±  9%    +387.1%      36467 ± 13%  softirqs.CPU5.RCU
      5495 ±  5%    +607.0%      38851 ±  3%  softirqs.CPU5.SCHED
     20673 ±  7%    +537.7%     131828 ± 11%  softirqs.CPU5.TIMER
      7071 ±  2%    +419.5%      36731 ±  9%  softirqs.CPU50.RCU
      5236          +643.2%      38915        softirqs.CPU50.SCHED
     18433 ±  2%    +583.4%     125966 ± 15%  softirqs.CPU50.TIMER
      7195 ±  3%    +405.2%      36353 ± 10%  softirqs.CPU51.RCU
      5322 ±  2%    +636.1%      39178 ±  2%  softirqs.CPU51.SCHED
     18960 ±  3%    +560.2%     125181 ± 14%  softirqs.CPU51.TIMER
      6997 ±  2%    +421.7%      36501 ± 10%  softirqs.CPU52.RCU
      5322          +640.4%      39404 ±  2%  softirqs.CPU52.SCHED
     18851          +573.4%     126948 ± 15%  softirqs.CPU52.TIMER
      6943 ±  3%    +428.5%      36693 ± 10%  softirqs.CPU53.RCU
      5286          +643.6%      39310 ±  2%  softirqs.CPU53.SCHED
     18709          +576.0%     126481 ± 15%  softirqs.CPU53.TIMER
      7009 ±  2%    +426.8%      36927 ±  9%  softirqs.CPU54.RCU
      5189          +648.7%      38854        softirqs.CPU54.SCHED
     18335          +590.2%     126541 ± 15%  softirqs.CPU54.TIMER
      7287 ±  9%    +411.8%      37301 ± 12%  softirqs.CPU55.RCU
      5172          +661.6%      39388 ±  2%  softirqs.CPU55.SCHED
     19102 ±  7%    +564.0%     126831 ± 16%  softirqs.CPU55.TIMER
      7061 ±  2%    +423.2%      36947 ± 10%  softirqs.CPU56.RCU
      5249          +562.7%      34790 ± 19%  softirqs.CPU56.SCHED
     18566 ±  2%    +583.8%     126964 ± 15%  softirqs.CPU56.TIMER
      7629 ± 12%    +385.0%      37001 ± 10%  softirqs.CPU57.RCU
      5282 ±  2%    +644.6%      39331 ±  2%  softirqs.CPU57.SCHED
     19675 ±  6%    +539.1%     125734 ± 14%  softirqs.CPU57.TIMER
      7975 ± 21%    +365.8%      37150 ± 12%  softirqs.CPU58.RCU
      5017 ± 10%    +686.5%      39466 ±  2%  softirqs.CPU58.SCHED
     20555 ± 15%    +515.3%     126483 ± 15%  softirqs.CPU58.TIMER
      7401 ±  5%    +397.4%      36813 ± 12%  softirqs.CPU59.RCU
      5555 ±  8%    +605.6%      39199 ±  2%  softirqs.CPU59.SCHED
     18748          +571.3%     125861 ± 15%  softirqs.CPU59.TIMER
      7303 ±  3%    +360.3%      33615 ±  3%  softirqs.CPU6.RCU
      5233 ±  2%    +634.8%      38451 ±  4%  softirqs.CPU6.SCHED
     19087 ±  2%    +594.9%     132637 ± 10%  softirqs.CPU6.TIMER
      6999 ±  3%    +427.1%      36891 ± 11%  softirqs.CPU60.RCU
      5261 ±  2%    +646.8%      39290 ±  2%  softirqs.CPU60.SCHED
     18444 ±  2%    +583.1%     125991 ± 15%  softirqs.CPU60.TIMER
      6913 ±  3%    +422.2%      36101 ±  8%  softirqs.CPU61.RCU
      5222 ±  2%    +648.2%      39072 ±  2%  softirqs.CPU61.SCHED
     18391 ±  2%    +585.6%     126094 ± 15%  softirqs.CPU61.TIMER
      6922 ±  2%    +407.4%      35121 ±  4%  softirqs.CPU62.RCU
      5193          +647.5%      38824        softirqs.CPU62.SCHED
     18255          +591.5%     126235 ± 15%  softirqs.CPU62.TIMER
      6941 ±  2%    +412.8%      35596 ±  5%  softirqs.CPU63.RCU
      5221 ±  2%    +607.7%      36951 ± 11%  softirqs.CPU63.SCHED
     18317 ±  2%    +586.8%     125808 ± 15%  softirqs.CPU63.TIMER
      6975 ±  4%    +397.8%      34722 ±  4%  softirqs.CPU64.RCU
      5185          +655.1%      39154 ±  2%  softirqs.CPU64.SCHED
     18105          +591.9%     125278 ± 15%  softirqs.CPU64.TIMER
      6980 ±  5%    +411.2%      35689 ± 11%  softirqs.CPU65.RCU
      5259          +644.0%      39125 ±  2%  softirqs.CPU65.SCHED
     18289          +586.4%     125541 ± 15%  softirqs.CPU65.TIMER
      6963 ±  3%    +417.0%      36002 ± 11%  softirqs.CPU66.RCU
      5241          +646.0%      39105        softirqs.CPU66.SCHED
     18198 ±  2%    +585.8%     124796 ± 14%  softirqs.CPU66.TIMER
      6961 ±  3%    +415.7%      35897 ± 11%  softirqs.CPU67.RCU
      5215          +651.5%      39188 ±  2%  softirqs.CPU67.SCHED
     18260 ±  2%    +588.1%     125653 ± 15%  softirqs.CPU67.TIMER
      7021 ±  5%    +410.8%      35861 ± 10%  softirqs.CPU68.RCU
      5228          +646.3%      39020 ±  2%  softirqs.CPU68.SCHED
     18242 ±  2%    +585.0%     124958 ± 15%  softirqs.CPU68.TIMER
      6989 ±  4%    +408.6%      35549 ±  9%  softirqs.CPU69.RCU
      5238 ±  2%    +642.8%      38909        softirqs.CPU69.SCHED
     18308 ±  2%    +586.0%     125595 ± 15%  softirqs.CPU69.TIMER
      7279 ±  3%    +387.2%      35462 ± 13%  softirqs.CPU7.RCU
      4828 ±  9%    +710.4%      39130 ±  3%  softirqs.CPU7.SCHED
     19112 ±  2%    +599.6%     133702 ± 10%  softirqs.CPU7.TIMER
      6870 ±  3%    +412.2%      35187 ±  7%  softirqs.CPU70.RCU
      5262          +643.7%      39141 ±  2%  softirqs.CPU70.SCHED
     18395 ±  2%    +582.2%     125500 ± 14%  softirqs.CPU70.TIMER
      6886 ±  4%    +405.7%      34825 ±  6%  softirqs.CPU71.RCU
      5249 ±  2%    +640.9%      38895 ±  2%  softirqs.CPU71.SCHED
     18181          +591.2%     125664 ± 15%  softirqs.CPU71.TIMER
      6828 ±  3%    +397.7%      33985 ±  9%  softirqs.CPU72.RCU
      5204 ±  2%    +649.5%      39004 ±  2%  softirqs.CPU72.SCHED
     18047 ±  3%    +561.9%     119452 ± 14%  softirqs.CPU72.TIMER
      6745 ±  3%    +402.2%      33874 ±  8%  softirqs.CPU73.RCU
      5268          +635.7%      38763 ±  3%  softirqs.CPU73.SCHED
     18249 ±  2%    +550.8%     118765 ± 14%  softirqs.CPU73.TIMER
      6708 ±  3%    +390.6%      32907 ±  4%  softirqs.CPU74.RCU
      5246          +635.3%      38576 ±  2%  softirqs.CPU74.SCHED
     18174 ±  2%    +543.2%     116900 ± 12%  softirqs.CPU74.TIMER
      6831 ±  3%    +402.3%      34314 ± 10%  softirqs.CPU75.RCU
      5359 ±  2%    +621.6%      38672 ±  2%  softirqs.CPU75.SCHED
     18384 ±  2%    +545.8%     118734 ± 15%  softirqs.CPU75.TIMER
      6913 ±  6%    +398.6%      34466 ± 10%  softirqs.CPU76.RCU
      4941 ± 12%    +681.9%      38637 ±  2%  softirqs.CPU76.SCHED
     18146 ±  2%    +560.3%     119817 ± 15%  softirqs.CPU76.TIMER
      6707 ±  3%    +406.0%      33936 ± 12%  softirqs.CPU77.RCU
      5487 ±  5%    +611.3%      39033 ±  2%  softirqs.CPU77.SCHED
     18877 ±  6%    +538.9%     120609 ± 14%  softirqs.CPU77.TIMER
      6824 ±  5%    +396.7%      33895 ± 11%  softirqs.CPU78.RCU
      5315          +566.7%      35436 ± 21%  softirqs.CPU78.SCHED
     19213 ±  7%    +589.8%     132542 ± 18%  softirqs.CPU78.TIMER
      6708 ±  4%    +397.5%      33372 ±  6%  softirqs.CPU79.RCU
      5237 ±  2%    +637.1%      38609 ±  2%  softirqs.CPU79.SCHED
     18173 ±  2%    +547.3%     117633 ± 13%  softirqs.CPU79.TIMER
      7620 ±  6%    +352.5%      34482 ±  7%  softirqs.CPU8.RCU
      5351 ±  5%    +558.1%      35220 ± 21%  softirqs.CPU8.SCHED
     19298 ±  2%    +590.4%     133242 ± 10%  softirqs.CPU8.TIMER
      6646 ±  4%    +410.4%      33919 ± 10%  softirqs.CPU80.RCU
      5213 ±  2%    +640.6%      38613 ±  3%  softirqs.CPU80.SCHED
     18279 ±  3%    +553.7%     119493 ± 15%  softirqs.CPU80.TIMER
      6671 ±  4%    +419.3%      34643 ±  9%  softirqs.CPU81.RCU
      5180 ±  2%    +650.2%      38862 ±  2%  softirqs.CPU81.SCHED
     18178 ±  3%    +560.2%     120009 ± 14%  softirqs.CPU81.TIMER
      6669 ±  4%    +418.4%      34571 ± 11%  softirqs.CPU82.RCU
      5192          +646.3%      38752 ±  3%  softirqs.CPU82.SCHED
     18039 ±  2%    +563.6%     119710 ± 15%  softirqs.CPU82.TIMER
      6677 ±  5%    +419.3%      34671 ± 12%  softirqs.CPU83.RCU
      4875 ± 11%    +689.8%      38503 ±  2%  softirqs.CPU83.SCHED
     18180 ±  3%    +556.8%     119397 ± 15%  softirqs.CPU83.TIMER
      6670 ±  4%    +408.2%      33899 ±  8%  softirqs.CPU84.RCU
      5149 ±  2%    +650.3%      38636 ±  3%  softirqs.CPU84.SCHED
     18130 ±  2%    +553.7%     118527 ± 14%  softirqs.CPU84.TIMER
      6656 ±  4%    +423.3%      34831 ± 12%  softirqs.CPU85.RCU
      5162          +646.8%      38549 ±  3%  softirqs.CPU85.SCHED
     18116 ±  2%    +556.6%     118947 ± 14%  softirqs.CPU85.TIMER
      6622 ±  3%    +428.3%      34987 ± 14%  softirqs.CPU86.RCU
      5187          +644.7%      38630 ±  2%  softirqs.CPU86.SCHED
     18211 ±  2%    +557.2%     119680 ± 15%  softirqs.CPU86.TIMER
      6718 ±  4%    +416.6%      34707 ± 12%  softirqs.CPU87.RCU
      5244 ±  2%    +635.9%      38593 ±  3%  softirqs.CPU87.SCHED
     18225 ±  3%    +551.8%     118792 ± 14%  softirqs.CPU87.TIMER
      6677 ±  3%    +429.1%      35330 ± 15%  softirqs.CPU88.RCU
      5196          +635.7%      38234        softirqs.CPU88.SCHED
     18176          +556.6%     119354 ± 15%  softirqs.CPU88.TIMER
      6743 ±  2%    +424.0%      35336 ± 15%  softirqs.CPU89.RCU
      5204          +638.9%      38455 ±  2%  softirqs.CPU89.SCHED
     18042 ±  2%    +559.7%     119015 ± 15%  softirqs.CPU89.TIMER
      7417 ±  5%    +383.6%      35865 ± 13%  softirqs.CPU9.RCU
      4984 ± 11%    +687.6%      39257 ±  3%  softirqs.CPU9.SCHED
     19419 ±  2%    +593.1%     134592 ± 10%  softirqs.CPU9.TIMER
      6678 ±  3%    +411.1%      34131 ±  9%  softirqs.CPU90.RCU
      5188 ±  2%    +644.6%      38635 ±  2%  softirqs.CPU90.SCHED
     18061 ±  2%    +557.0%     118655 ± 13%  softirqs.CPU90.TIMER
      6699          +430.3%      35524 ± 15%  softirqs.CPU91.RCU
      5154          +648.4%      38571 ±  3%  softirqs.CPU91.SCHED
     18054          +557.9%     118780 ± 15%  softirqs.CPU91.TIMER
      6545 ±  4%    +436.3%      35100 ± 15%  softirqs.CPU92.RCU
      5183 ±  2%    +640.6%      38391        softirqs.CPU92.SCHED
     18097 ±  3%    +561.2%     119656 ± 15%  softirqs.CPU92.TIMER
      6649 ±  2%    +423.6%      34819 ± 13%  softirqs.CPU93.RCU
      5210          +642.1%      38671 ±  2%  softirqs.CPU93.SCHED
     18095 ±  2%    +557.9%     119046 ± 14%  softirqs.CPU93.TIMER
      6759          +392.2%      33267 ±  9%  softirqs.CPU94.RCU
      5210          +653.1%      39241 ±  2%  softirqs.CPU94.SCHED
     18143 ±  2%    +573.4%     122174 ± 13%  softirqs.CPU94.TIMER
      6677 ±  2%    +414.8%      34374 ± 10%  softirqs.CPU95.RCU
      5172 ±  2%    +418.0%      26794 ± 11%  softirqs.CPU95.SCHED
     18063 ±  2%    +559.7%     119167 ± 15%  softirqs.CPU95.TIMER
      6785 ± 10%    +382.8%      32757 ±  6%  softirqs.CPU96.RCU
      5193 ± 20%    +576.9%      35154 ± 17%  softirqs.CPU96.SCHED
     18836 ±  6%    +602.7%     132354 ± 10%  softirqs.CPU96.TIMER
      6724 ±  7%    +417.1%      34773 ± 10%  softirqs.CPU97.RCU
      5270 ±  3%    +640.4%      39023        softirqs.CPU97.SCHED
     18469 ±  4%    +597.1%     128754 ±  9%  softirqs.CPU97.TIMER
      6657 ±  5%    +428.6%      35189 ± 13%  softirqs.CPU98.RCU
      5282 ±  3%    +642.8%      39237        softirqs.CPU98.SCHED
     18584 ±  3%    +594.1%     129004 ± 10%  softirqs.CPU98.TIMER
      6905 ±  8%    +422.5%      36081 ± 16%  softirqs.CPU99.RCU
      5308 ±  2%    +648.2%      39719 ±  2%  softirqs.CPU99.SCHED
     18905 ±  3%    +581.1%     128757 ± 11%  softirqs.CPU99.TIMER
    697.00 ± 38%   +1367.1%      10226 ± 62%  softirqs.NET_RX
   1309285 ±  3%    +407.1%    6639778 ±  9%  softirqs.RCU
   1012468          +634.4%    7435362        softirqs.SCHED
   3593340          +575.0%   24256691 ± 11%  softirqs.TIMER





Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


Thanks,
Rong Chen


--VSaCG/zfRnOiPJtU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-5.8.0-rc6-00354-g54529aac984de"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 5.8.0-rc6 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="gcc-9 (Debian 9.3.0-14) 9.3.0"
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=90300
CONFIG_LD_VERSION=234000000
CONFIG_CLANG_VERSION=0
CONFIG_CC_CAN_LINK=y
CONFIG_CC_CAN_LINK_STATIC=y
CONFIG_CC_HAS_ASM_GOTO=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_TABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_BUILD_SALT=""
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_INIT=""
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_WATCH_QUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_GENERIC_IRQ_INJECTION=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
CONFIG_IRQ_MSI_IOMMU=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
# end of IRQ subsystem

CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_INIT=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
# end of Timers subsystem

# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_SCHED_AVG_IRQ=y
# CONFIG_SCHED_THERMAL_PRESSURE is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_PSI is not set
# end of CPU/Task time and stats accounting

CONFIG_CPU_ISOLATION=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU_GENERIC=y
CONFIG_TASKS_RCU=y
CONFIG_TASKS_RUDE_RCU=y
CONFIG_TASKS_TRACE_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_NOCB_CPU=y
# end of RCU Subsystem

CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
# CONFIG_IKHEADERS is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y

#
# Scheduler features
#
# CONFIG_UCLAMP_TASK is not set
# end of Scheduler features

CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CC_HAS_INT128=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_KMEM=y
CONFIG_BLK_CGROUP=y
CONFIG_CGROUP_WRITEBACK=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_BPF=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_TIME_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
# CONFIG_BOOT_CONFIG is not set
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_IO_URING=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_HAVE_ARCH_USERFAULTFD_WP=y
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
# CONFIG_BPF_LSM is not set
CONFIG_BPF_SYSCALL=y
CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y
CONFIG_BPF_JIT_ALWAYS_ON=y
CONFIG_BPF_JIT_DEFAULT_ON=y
CONFIG_USERFAULTFD=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_RSEQ=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# end of Kernel Performance Events And Counters

CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_SLAB_MERGE_DEFAULT=y
CONFIG_SLAB_FREELIST_RANDOM=y
# CONFIG_SLAB_FREELIST_HARDENED is not set
CONFIG_SHUFFLE_PAGE_ALLOCATOR=y
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_SYSTEM_DATA_VERIFICATION=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# end of General setup

CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_FILTER_PGPROT=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DYNAMIC_PHYSICAL_MASK=y
CONFIG_PGTABLE_LEVELS=5
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_GOLDFISH is not set
CONFIG_RETPOLINE=y
CONFIG_X86_CPU_RESCTRL=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_MID is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_AMD_PLATFORM_DEVICE=y
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_X86_HV_CALLBACK_VECTOR=y
CONFIG_XEN=y
# CONFIG_XEN_PV is not set
CONFIG_XEN_PVHVM=y
CONFIG_XEN_PVHVM_SMP=y
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
# CONFIG_XEN_PVH is not set
CONFIG_KVM_GUEST=y
CONFIG_ARCH_CPUIDLE_HALTPOLL=y
# CONFIG_PVH is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
# CONFIG_ACRN_GUEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_IA32_FEAT_CTL=y
CONFIG_X86_VMX_FEATURE_NAMES=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_HYGON=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_ZHAOXIN=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
CONFIG_MAXSMP=y
CONFIG_NR_CPUS_RANGE_BEGIN=8192
CONFIG_NR_CPUS_RANGE_END=8192
CONFIG_NR_CPUS_DEFAULT=8192
CONFIG_NR_CPUS=8192
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_MC_PRIO=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCELOG_LEGACY=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=m
CONFIG_PERF_EVENTS_INTEL_RAPL=m
CONFIG_PERF_EVENTS_INTEL_CSTATE=m
CONFIG_PERF_EVENTS_AMD_POWER=m
# end of Performance monitoring

CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_X86_IOPL_IOPERM=y
CONFIG_I8K=m
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_5LEVEL=y
CONFIG_X86_DIRECT_GBPAGES=y
# CONFIG_X86_CPA_STATISTICS is not set
CONFIG_AMD_MEM_ENCRYPT=y
# CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT is not set
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
# CONFIG_ARCH_MEMORY_PROBE is not set
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=m
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_X86_UMIP=y
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
CONFIG_X86_INTEL_TSX_MODE_OFF=y
# CONFIG_X86_INTEL_TSX_MODE_ON is not set
# CONFIG_X86_INTEL_TSX_MODE_AUTO is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_MIXED=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
CONFIG_ARCH_HAS_KEXEC_PURGATORY=y
# CONFIG_KEXEC_SIG is not set
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_DYNAMIC_MEMORY_LAYOUT=y
CONFIG_RANDOMIZE_MEMORY=y
CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=0xa
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
CONFIG_LEGACY_VSYSCALL_EMULATE=y
# CONFIG_LEGACY_VSYSCALL_XONLY is not set
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
CONFIG_HAVE_LIVEPATCH=y
CONFIG_LIVEPATCH=y
# end of Processor type and features

CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_ARCH_ENABLE_THP_MIGRATION=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_HIBERNATION_SNAPSHOT_DEV=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
# CONFIG_ENERGY_MODEL is not set
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_TAD=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_CPPC_LIB=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=y
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_NFIT=m
# CONFIG_NFIT_SECURITY_DEBUG is not set
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_HMAT is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=m
CONFIG_ACPI_APEI_ERST_DEBUG=y
CONFIG_DPTF_POWER=m
CONFIG_ACPI_WATCHDOG=y
CONFIG_ACPI_EXTLOG=m
CONFIG_ACPI_ADXL=y
CONFIG_PMIC_OPREGION=y
# CONFIG_ACPI_CONFIGFS is not set
CONFIG_X86_PM_TIMER=y
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_AMD_FREQ_SENSITIVITY=m
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
# end of CPU Frequency scaling

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_CPU_IDLE_GOV_TEO is not set
# CONFIG_CPU_IDLE_GOV_HALTPOLL is not set
CONFIG_HALTPOLL_CPUIDLE=y
# end of CPU Idle

CONFIG_INTEL_IDLE=y
# end of Power management and ACPI options

#
# Bus options (PCI etc.)
#
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_MMCONF_FAM10H=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_X86_SYSFB is not set
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
CONFIG_IA32_EMULATION=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
# end of Binary Emulations

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT is not set
CONFIG_FW_CFG_SYSFS=y
# CONFIG_FW_CFG_SYSFS_CMDLINE is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_ESRT=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_EFI_RUNTIME_MAP=y
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_RUNTIME_WRAPPERS=y
CONFIG_EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
CONFIG_APPLE_PROPERTIES=y
# CONFIG_RESET_ATTACK_MITIGATION is not set
# CONFIG_EFI_RCI2_TABLE is not set
# CONFIG_EFI_DISABLE_PCI_DMA is not set
# end of EFI (Extensible Firmware Interface) Support

CONFIG_UEFI_CPER=y
CONFIG_UEFI_CPER_X86=y
CONFIG_EFI_DEV_PATH_PARSER=y
CONFIG_EFI_EARLYCON=y
CONFIG_EFI_CUSTOM_SSDT_OVERLAYS=y

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM_COMPAT=y
CONFIG_HAVE_KVM_IRQ_BYPASS=y
CONFIG_HAVE_KVM_NO_POLL=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
CONFIG_KVM_AMD_SEV=y
CONFIG_KVM_MMU_AUDIT=y
CONFIG_AS_AVX512=y
CONFIG_AS_SHA1_NI=y
CONFIG_AS_SHA256_NI=y
CONFIG_AS_TPAUSE=y

#
# General architecture-dependent options
#
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_HOTPLUG_SMT=y
CONFIG_OPROFILE=m
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_HAS_SET_DIRECT_MAP=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_HAVE_ASM_MODVERSIONS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
CONFIG_MMU_GATHER_TABLE_FREE=y
CONFIG_MMU_GATHER_RCU_TABLE_FREE=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_CC_HAS_STACKPROTECTOR_NONE=y
CONFIG_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR_STRONG=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_HAVE_COPY_THREAD_TLS=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
CONFIG_ARCH_USE_MEMREMAP_PROT=y
# CONFIG_LOCK_EVENT_COUNTS is not set
CONFIG_ARCH_HAS_MEM_ENCRYPT=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_HAVE_GCC_PLUGINS=y
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULE_SIG_FORMAT=y
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
CONFIG_MODULE_SIG_SHA256=y
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha256"
# CONFIG_MODULE_COMPRESS is not set
# CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLK_SCSI_REQUEST=y
CONFIG_BLK_CGROUP_RWSTAT=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_INTEGRITY_T10=m
CONFIG_BLK_DEV_ZONED=y
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_DEV_THROTTLING_LOW is not set
# CONFIG_BLK_CMDLINE_PARSER is not set
CONFIG_BLK_WBT=y
# CONFIG_BLK_CGROUP_IOLATENCY is not set
# CONFIG_BLK_CGROUP_IOCOST is not set
CONFIG_BLK_WBT_MQ=y
CONFIG_BLK_DEBUG_FS=y
CONFIG_BLK_DEBUG_FS_ZONED=y
# CONFIG_BLK_SED_OPAL is not set
# CONFIG_BLK_INLINE_ENCRYPTION is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
# end of Partition Types

CONFIG_BLOCK_COMPAT=y
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y
CONFIG_BLK_MQ_RDMA=y
CONFIG_BLK_PM=y

#
# IO Schedulers
#
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=y
CONFIG_IOSCHED_BFQ=y
CONFIG_BFQ_GROUP_IOSCHED=y
# CONFIG_BFQ_CGROUP_DEBUG is not set
# end of IO Schedulers

CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
# end of Executable file formats

#
# Memory Management options
#
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_FAST_GUP=y
CONFIG_NUMA_KEEP_MEMINFO=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_PAGE_REPORTING=y
CONFIG_MIGRATION=y
CONFIG_CONTIG_ALLOC=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_THP_SWAP=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_CMA_DEBUGFS is not set
CONFIG_CMA_AREAS=7
CONFIG_ZSWAP=y
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_DEFLATE is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZO=y
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_842 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4HC is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT="lzo"
CONFIG_ZSWAP_ZPOOL_DEFAULT_ZBUD=y
# CONFIG_ZSWAP_ZPOOL_DEFAULT_Z3FOLD is not set
# CONFIG_ZSWAP_ZPOOL_DEFAULT_ZSMALLOC is not set
CONFIG_ZSWAP_ZPOOL_DEFAULT="zbud"
# CONFIG_ZSWAP_DEFAULT_ON is not set
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
# CONFIG_Z3FOLD is not set
CONFIG_ZSMALLOC=y
# CONFIG_ZSMALLOC_PGTABLE_MAPPING is not set
CONFIG_ZSMALLOC_STAT=y
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_PTE_DEVMAP=y
CONFIG_ZONE_DEVICE=y
CONFIG_DEV_PAGEMAP_OPS=y
CONFIG_DEVICE_PRIVATE=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
# CONFIG_PERCPU_STATS is not set
# CONFIG_GUP_BENCHMARK is not set
# CONFIG_READ_ONLY_THP_FOR_FS is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_MAPPING_DIRTY_HELPERS=y
# end of Memory Management options

CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y
CONFIG_NET_INGRESS=y
CONFIG_NET_EGRESS=y
CONFIG_SKB_EXTENSIONS=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_SCM=y
CONFIG_UNIX_DIAG=m
CONFIG_TLS=m
CONFIG_TLS_DEVICE=y
# CONFIG_TLS_TOE is not set
CONFIG_XFRM=y
CONFIG_XFRM_OFFLOAD=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_INTERFACE is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_AH=m
CONFIG_XFRM_ESP=m
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_SMC is not set
CONFIG_XDP_SOCKETS=y
# CONFIG_XDP_SOCKETS_DIAG is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE_COMMON=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=m
# CONFIG_NET_FOU is not set
# CONFIG_NET_FOU_IP_TUNNELS is not set
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_ESP_OFFLOAD=m
# CONFIG_INET_ESPINTCP is not set
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
CONFIG_INET_RAW_DIAG=m
# CONFIG_INET_DIAG_DESTROY is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_NV=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_TCP_CONG_DCTCP=m
# CONFIG_TCP_CONG_CDG is not set
CONFIG_TCP_CONG_BBR=m
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_ESP_OFFLOAD=m
# CONFIG_INET6_ESPINTCP is not set
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
# CONFIG_IPV6_ILA is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_GRE=m
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_IPV6_SEG6_LWTUNNEL is not set
# CONFIG_IPV6_SEG6_HMAC is not set
# CONFIG_IPV6_RPL_LWTUNNEL is not set
CONFIG_NETLABEL=y
# CONFIG_MPTCP is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=m

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_FAMILY_BRIDGE=y
CONFIG_NETFILTER_FAMILY_ARP=y
# CONFIG_NETFILTER_NETLINK_ACCT is not set
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NETFILTER_NETLINK_OSF=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_LOG_COMMON=m
CONFIG_NF_LOG_NETDEV=m
CONFIG_NETFILTER_CONNCOUNT=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMEOUT=y
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NF_CT_NETLINK_TIMEOUT=m
CONFIG_NF_CT_NETLINK_HELPER=m
CONFIG_NETFILTER_NETLINK_GLUE_CT=y
CONFIG_NF_NAT=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_SIP=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_REDIRECT=y
CONFIG_NF_NAT_MASQUERADE=y
CONFIG_NETFILTER_SYNPROXY=m
CONFIG_NF_TABLES=m
CONFIG_NF_TABLES_INET=y
CONFIG_NF_TABLES_NETDEV=y
CONFIG_NFT_NUMGEN=m
CONFIG_NFT_CT=m
CONFIG_NFT_COUNTER=m
CONFIG_NFT_CONNLIMIT=m
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
CONFIG_NFT_MASQ=m
CONFIG_NFT_REDIR=m
CONFIG_NFT_NAT=m
# CONFIG_NFT_TUNNEL is not set
CONFIG_NFT_OBJREF=m
CONFIG_NFT_QUEUE=m
CONFIG_NFT_QUOTA=m
CONFIG_NFT_REJECT=m
CONFIG_NFT_REJECT_INET=m
CONFIG_NFT_COMPAT=m
CONFIG_NFT_HASH=m
CONFIG_NFT_FIB=m
CONFIG_NFT_FIB_INET=m
# CONFIG_NFT_XFRM is not set
CONFIG_NFT_SOCKET=m
# CONFIG_NFT_OSF is not set
# CONFIG_NFT_TPROXY is not set
# CONFIG_NFT_SYNPROXY is not set
CONFIG_NF_DUP_NETDEV=m
CONFIG_NFT_DUP_NETDEV=m
CONFIG_NFT_FWD_NETDEV=m
CONFIG_NFT_FIB_NETDEV=m
# CONFIG_NF_FLOW_TABLE is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_NAT=m
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_MASQUERADE=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
CONFIG_NETFILTER_XT_MATCH_CGROUP=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
# CONFIG_NETFILTER_XT_MATCH_L2TP is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# end of Core Netfilter Configuration

CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPMARK=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_IPMAC=m
CONFIG_IP_SET_HASH_MAC=m
CONFIG_IP_SET_HASH_NETPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETNET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_FO=m
CONFIG_IP_VS_OVF=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
# CONFIG_IP_VS_MH is not set
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS MH scheduler
#
CONFIG_IP_VS_MH_TAB_INDEX=12

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_SOCKET_IPV4=m
CONFIG_NF_TPROXY_IPV4=m
CONFIG_NF_TABLES_IPV4=y
CONFIG_NFT_REJECT_IPV4=m
CONFIG_NFT_DUP_IPV4=m
CONFIG_NFT_FIB_IPV4=m
CONFIG_NF_TABLES_ARP=y
CONFIG_NF_DUP_IPV4=m
CONFIG_NF_LOG_ARP=m
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_REJECT_IPV4=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_SYNPROXY=m
CONFIG_IP_NF_NAT=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_MANGLE=m
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
# end of IP: Netfilter Configuration

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_SOCKET_IPV6=m
CONFIG_NF_TPROXY_IPV6=m
CONFIG_NF_TABLES_IPV6=y
CONFIG_NFT_REJECT_IPV6=m
CONFIG_NFT_DUP_IPV6=m
CONFIG_NFT_FIB_IPV6=m
CONFIG_NF_DUP_IPV6=m
CONFIG_NF_REJECT_IPV6=m
CONFIG_NF_LOG_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
# CONFIG_IP6_NF_MATCH_SRH is not set
# CONFIG_IP6_NF_TARGET_HL is not set
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_TARGET_SYNPROXY=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
CONFIG_IP6_NF_NAT=m
CONFIG_IP6_NF_TARGET_MASQUERADE=m
CONFIG_IP6_NF_TARGET_NPT=m
# end of IPv6: Netfilter Configuration

CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_TABLES_BRIDGE=m
# CONFIG_NFT_BRIDGE_META is not set
CONFIG_NFT_BRIDGE_REJECT=m
CONFIG_NF_LOG_BRIDGE=m
# CONFIG_NF_CONNTRACK_BRIDGE is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
# CONFIG_BPFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_INET_SCTP_DIAG=m
# CONFIG_RDS is not set
CONFIG_TIPC=m
# CONFIG_TIPC_MEDIA_IB is not set
CONFIG_TIPC_MEDIA_UDP=y
CONFIG_TIPC_CRYPTO=y
CONFIG_TIPC_DIAG=m
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
# CONFIG_BRIDGE_MRP is not set
CONFIG_HAVE_NET_DSA=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
CONFIG_6LOWPAN=m
# CONFIG_6LOWPAN_DEBUGFS is not set
# CONFIG_6LOWPAN_NHC is not set
CONFIG_IEEE802154=m
# CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set
CONFIG_IEEE802154_SOCKET=m
CONFIG_IEEE802154_6LOWPAN=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
# CONFIG_NET_SCH_CBS is not set
# CONFIG_NET_SCH_ETF is not set
# CONFIG_NET_SCH_TAPRIO is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
# CONFIG_NET_SCH_SKBPRIO is not set
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=y
# CONFIG_NET_SCH_CAKE is not set
CONFIG_NET_SCH_FQ=m
CONFIG_NET_SCH_HHF=m
CONFIG_NET_SCH_PIE=m
# CONFIG_NET_SCH_FQ_PIE is not set
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_SCH_PLUG=m
# CONFIG_NET_SCH_ETS is not set
CONFIG_NET_SCH_DEFAULT=y
# CONFIG_DEFAULT_FQ is not set
# CONFIG_DEFAULT_CODEL is not set
CONFIG_DEFAULT_FQ_CODEL=y
# CONFIG_DEFAULT_SFQ is not set
# CONFIG_DEFAULT_PFIFO_FAST is not set
CONFIG_DEFAULT_NET_SCH="fq_codel"

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=m
CONFIG_NET_CLS_FLOWER=m
CONFIG_NET_CLS_MATCHALL=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
# CONFIG_NET_EMATCH_CANID is not set
CONFIG_NET_EMATCH_IPSET=m
# CONFIG_NET_EMATCH_IPT is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_SAMPLE=m
# CONFIG_NET_ACT_IPT is not set
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
# CONFIG_NET_ACT_MPLS is not set
CONFIG_NET_ACT_VLAN=m
CONFIG_NET_ACT_BPF=m
# CONFIG_NET_ACT_CONNMARK is not set
# CONFIG_NET_ACT_CTINFO is not set
CONFIG_NET_ACT_SKBMOD=m
# CONFIG_NET_ACT_IFE is not set
CONFIG_NET_ACT_TUNNEL_KEY=m
# CONFIG_NET_ACT_GATE is not set
# CONFIG_NET_TC_SKB_EXT is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_GRE=m
CONFIG_VSOCKETS=m
CONFIG_VSOCKETS_DIAG=m
CONFIG_VSOCKETS_LOOPBACK=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS_COMMON=m
CONFIG_HYPERV_VSOCKETS=m
CONFIG_NETLINK_DIAG=m
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=y
CONFIG_MPLS_ROUTING=m
CONFIG_MPLS_IPTUNNEL=m
CONFIG_NET_NSH=y
# CONFIG_HSR is not set
CONFIG_NET_SWITCHDEV=y
CONFIG_NET_L3_MASTER_DEV=y
# CONFIG_QRTR is not set
# CONFIG_NET_NCSI is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_JIT=y
CONFIG_BPF_STREAM_PARSER=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_DROP_MONITOR=y
# end of Network testing
# end of Networking options

# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m
# CONFIG_CAN_J1939 is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_VXCAN is not set
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_KVASER_PCIEFD is not set
CONFIG_CAN_C_CAN=m
CONFIG_CAN_C_CAN_PLATFORM=m
CONFIG_CAN_C_CAN_PCI=m
CONFIG_CAN_CC770=m
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=m
# CONFIG_CAN_IFI_CANFD is not set
# CONFIG_CAN_M_CAN is not set
# CONFIG_CAN_PEAK_PCIEFD is not set
CONFIG_CAN_SJA1000=m
CONFIG_CAN_EMS_PCI=m
# CONFIG_CAN_F81601 is not set
CONFIG_CAN_KVASER_PCI=m
CONFIG_CAN_PEAK_PCI=m
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_PLX_PCI=m
# CONFIG_CAN_SJA1000_ISA is not set
CONFIG_CAN_SJA1000_PLATFORM=m
CONFIG_CAN_SOFTING=m

#
# CAN SPI interfaces
#
# CONFIG_CAN_HI311X is not set
# CONFIG_CAN_MCP251X is not set
# end of CAN SPI interfaces

#
# CAN USB interfaces
#
# CONFIG_CAN_8DEV_USB is not set
# CONFIG_CAN_EMS_USB is not set
# CONFIG_CAN_ESD_USB2 is not set
# CONFIG_CAN_GS_USB is not set
# CONFIG_CAN_KVASER_USB is not set
# CONFIG_CAN_MCBA_USB is not set
# CONFIG_CAN_PEAK_USB is not set
# CONFIG_CAN_UCAN is not set
# end of CAN USB interfaces

# CONFIG_CAN_DEBUG_DEVICES is not set
# end of CAN Device Drivers

CONFIG_BT=m
CONFIG_BT_BREDR=y
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m
CONFIG_BT_HS=y
CONFIG_BT_LE=y
# CONFIG_BT_6LOWPAN is not set
# CONFIG_BT_LEDS is not set
# CONFIG_BT_MSFTEXT is not set
CONFIG_BT_DEBUGFS=y
# CONFIG_BT_SELFTEST is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
# CONFIG_BT_HCIBTSDIO is not set
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
# CONFIG_BT_HCIUART_INTEL is not set
# CONFIG_BT_HCIUART_AG6XX is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
# CONFIG_BT_MRVL_SDIO is not set
# CONFIG_BT_MTKSDIO is not set
# end of Bluetooth device drivers

# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
CONFIG_STREAM_PARSER=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_CFG80211_CRDA_SUPPORT=y
CONFIG_CFG80211_WEXT=y
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_XEN is not set
# CONFIG_NET_9P_RDMA is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set
CONFIG_PSAMPLE=m
# CONFIG_NET_IFE is not set
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_SOCK_VALIDATE_XMIT=y
CONFIG_NET_SOCK_MSG=y
CONFIG_NET_DEVLINK=y
CONFIG_FAILOVER=m
CONFIG_ETHTOOL_NETLINK=y
CONFIG_HAVE_EBPF_JIT=y

#
# Device Drivers
#
CONFIG_HAVE_EISA=y
# CONFIG_EISA is not set
CONFIG_HAVE_PCI=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIE_ECRC=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCIE_DPC=y
# CONFIG_PCIE_PTM is not set
# CONFIG_PCIE_BW is not set
# CONFIG_PCIE_EDR is not set
CONFIG_PCI_MSI=y
CONFIG_PCI_MSI_IRQ_DOMAIN=y
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_PCI_PF_STUB=m
# CONFIG_XEN_PCIDEV_FRONTEND is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_P2PDMA is not set
CONFIG_PCI_LABEL=y
CONFIG_PCI_HYPERV=m
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# PCI controller drivers
#
CONFIG_VMD=y
CONFIG_PCI_HYPERV_INTERFACE=m

#
# DesignWare PCI Core Support
#
# CONFIG_PCIE_DW_PLAT_HOST is not set
# CONFIG_PCI_MESON is not set
# end of DesignWare PCI Core Support

#
# Mobiveil PCIe Core Support
#
# end of Mobiveil PCIe Core Support

#
# Cadence PCIe controllers support
#
# end of Cadence PCIe controllers support
# end of PCI controller drivers

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set
# end of PCI Endpoint

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
# end of PCI switch controller drivers

# CONFIG_PCCARD is not set
# CONFIG_RAPIDIO is not set

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_FW_LOADER_COMPRESS is not set
CONFIG_FW_CACHE=y
# end of Firmware loader

CONFIG_ALLOW_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_PM_QOS_KUNIT_TEST is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_KUNIT_DRIVER_PE_TEST=y
CONFIG_SYS_HYPERVISOR=y
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=m
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
# end of Generic Driver Options

#
# Bus devices
#
# CONFIG_MHI_BUS is not set
# end of Bus devices

CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_GNSS is not set
# CONFIG_MTD is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_CDROM=m
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
# CONFIG_BLK_DEV_UMEM is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SKD is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=m
CONFIG_VIRTIO_BLK=y
CONFIG_BLK_DEV_RBD=m
# CONFIG_BLK_DEV_RSXX is not set

#
# NVME Support
#
CONFIG_NVME_CORE=m
CONFIG_BLK_DEV_NVME=m
CONFIG_NVME_MULTIPATH=y
# CONFIG_NVME_HWMON is not set
CONFIG_NVME_FABRICS=m
# CONFIG_NVME_RDMA is not set
CONFIG_NVME_FC=m
# CONFIG_NVME_TCP is not set
CONFIG_NVME_TARGET=m
CONFIG_NVME_TARGET_LOOP=m
# CONFIG_NVME_TARGET_RDMA is not set
CONFIG_NVME_TARGET_FC=m
CONFIG_NVME_TARGET_FCLOOP=m
# CONFIG_NVME_TARGET_TCP is not set
# end of NVME Support

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_SGI_XP=m
CONFIG_HP_ILO=m
CONFIG_SGI_GRU=m
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_XILINX_SDFEC is not set
CONFIG_MISC_RTSX=m
CONFIG_PVPANIC=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_EEPROM_IDT_89HPESX is not set
# CONFIG_EEPROM_EE1004 is not set
# end of EEPROM support

CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# end of Texas Instruments shared transport line discipline

CONFIG_SENSORS_LIS3_I2C=m
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=m
CONFIG_INTEL_MEI_ME=m
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_INTEL_MEI_HDCP is not set
CONFIG_VMWARE_VMCI=m

#
# Intel MIC & related support
#
# CONFIG_INTEL_MIC_BUS is not set
# CONFIG_SCIF_BUS is not set
# CONFIG_VOP_BUS is not set
# end of Intel MIC & related support

# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_MISC_ALCOR_PCI is not set
CONFIG_MISC_RTSX_PCI=m
# CONFIG_MISC_RTSX_USB is not set
# CONFIG_HABANA_AI is not set
# CONFIG_UACCE is not set
# end of Misc devices

CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_BLK_DEV_SR=m
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
# end of SCSI Transports

CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_SMARTPQI is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_MYRB is not set
# CONFIG_SCSI_MYRS is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_XEN_SCSI_FRONTEND is not set
CONFIG_HYPERV_STORAGE=m
# CONFIG_LIBFC is not set
# CONFIG_SCSI_SNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_FDOMAIN_PCI is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_WD719X is not set
CONFIG_SCSI_DEBUG=m
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_VIRTIO is not set
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# end of SCSI device support

CONFIG_ATA=m
CONFIG_SATA_HOST=y
CONFIG_PATA_TIMINGS=y
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_FORCE=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_MOBILE_LPM_POLICY=0
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_DWC is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_MD_CLUSTER=m
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
# CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_UNSTRIPED is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_SMQ=m
CONFIG_DM_WRITECACHE=m
# CONFIG_DM_EBS is not set
CONFIG_DM_ERA=m
# CONFIG_DM_CLONE is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
# CONFIG_DM_MULTIPATH_HST is not set
CONFIG_DM_DELAY=m
# CONFIG_DM_DUST is not set
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
# CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG is not set
# CONFIG_DM_VERITY_FEC is not set
CONFIG_DM_SWITCH=m
CONFIG_DM_LOG_WRITES=m
CONFIG_DM_INTEGRITY=m
# CONFIG_DM_ZONED is not set
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_TCM_USER2=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_ISCSI_TARGET=m
# CONFIG_SBP_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
# end of IEEE 1394 (FireWire) support

CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_WIREGUARD is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
# CONFIG_IFB is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_IPVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_GENEVE is not set
# CONFIG_BAREUDP is not set
# CONFIG_GTP is not set
# CONFIG_MACSEC is not set
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_TUN is not set
# CONFIG_TUN_VNET_CROSS_LE is not set
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
# CONFIG_NET_VRF is not set
# CONFIG_VSOCKMON is not set
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
# CONFIG_ATM_TCP is not set
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set

#
# Distributed Switch Architecture drivers
#
# end of Distributed Switch Architecture drivers

CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
CONFIG_NET_VENDOR_ALACRITECH=y
# CONFIG_SLICOSS is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
# CONFIG_ENA_ETHERNET is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
# CONFIG_AMD_XGBE is not set
CONFIG_NET_VENDOR_AQUANTIA=y
# CONFIG_AQTION is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
# CONFIG_NET_VENDOR_AURORA is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BCMGENET is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
CONFIG_TIGON3=y
CONFIG_TIGON3_HWMON=y
# CONFIG_BNX2X is not set
# CONFIG_SYSTEMPORT is not set
# CONFIG_BNXT is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_VENDOR_CADENCE=y
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_CAVIUM=y
# CONFIG_THUNDER_NIC_PF is not set
# CONFIG_THUNDER_NIC_VF is not set
# CONFIG_THUNDER_NIC_BGX is not set
# CONFIG_THUNDER_NIC_RGX is not set
CONFIG_CAVIUM_PTP=y
# CONFIG_LIQUIDIO is not set
# CONFIG_LIQUIDIO_VF is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_NET_VENDOR_CORTINA=y
# CONFIG_CX_ECAT is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EZCHIP=y
CONFIG_NET_VENDOR_GOOGLE=y
# CONFIG_GVE is not set
CONFIG_NET_VENDOR_HUAWEI=y
# CONFIG_HINIC is not set
CONFIG_NET_VENDOR_I825XX=y
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_E1000E_HWTS=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
# CONFIG_IXGBE_DCB is not set
CONFIG_IXGBE_IPSEC=y
# CONFIG_IXGBEVF is not set
CONFIG_I40E=y
# CONFIG_I40E_DCB is not set
# CONFIG_I40EVF is not set
# CONFIG_ICE is not set
# CONFIG_FM10K is not set
# CONFIG_IGC is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
CONFIG_SKGE=y
# CONFIG_SKGE_DEBUG is not set
# CONFIG_SKGE_GENESIS is not set
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_MLXFW is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
# CONFIG_KS8851 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
# CONFIG_ENCX24J600 is not set
# CONFIG_LAN743X is not set
CONFIG_NET_VENDOR_MICROSEMI=y
# CONFIG_MSCC_OCELOT_SWITCH is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_NETERION=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_NETRONOME=y
# CONFIG_NFP is not set
CONFIG_NET_VENDOR_NI=y
# CONFIG_NI_XGE_MANAGEMENT_ENET is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_NE2K_PCI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_ETHOC is not set
CONFIG_NET_VENDOR_PACKET_ENGINES=y
# CONFIG_HAMACHI is not set
CONFIG_YELLOWFIN=m
CONFIG_NET_VENDOR_PENSANDO=y
# CONFIG_IONIC is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_QED is not set
CONFIG_NET_VENDOR_QUALCOMM=y
# CONFIG_QCOM_EMAC is not set
# CONFIG_RMNET is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_ROCKER=y
# CONFIG_ROCKER is not set
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SOLARFLARE=y
# CONFIG_SFC is not set
# CONFIG_SFC_FALCON is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_SOCIONEXT=y
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_SYNOPSYS=y
# CONFIG_DWC_XLGMAC is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TI_CPSW_PHY_SEL is not set
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XILINX=y
# CONFIG_XILINX_AXI_EMAC is not set
# CONFIG_XILINX_LL_TEMAC is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_MDIO_DEVICE=y
CONFIG_MDIO_BUS=y
# CONFIG_MDIO_BCM_UNIMAC is not set
# CONFIG_MDIO_BITBANG is not set
# CONFIG_MDIO_MSCC_MIIM is not set
# CONFIG_MDIO_MVUSB is not set
# CONFIG_MDIO_THUNDER is not set
# CONFIG_MDIO_XPCS is not set
CONFIG_PHYLIB=y
# CONFIG_LED_TRIGGER_PHY is not set

#
# MII PHY device drivers
#
# CONFIG_ADIN_PHY is not set
# CONFIG_AMD_PHY is not set
# CONFIG_AQUANTIA_PHY is not set
# CONFIG_AX88796B_PHY is not set
# CONFIG_BCM7XXX_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM54140_PHY is not set
# CONFIG_BCM84881_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_CORTINA_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_DP83822_PHY is not set
# CONFIG_DP83TC811_PHY is not set
# CONFIG_DP83848_PHY is not set
# CONFIG_DP83867_PHY is not set
# CONFIG_DP83869_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_INTEL_XWAY_PHY is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_MARVELL_10G_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_MICROCHIP_PHY is not set
# CONFIG_MICROCHIP_T1_PHY is not set
# CONFIG_MICROSEMI_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_NXP_TJA11XX_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_REALTEK_PHY=y
# CONFIG_RENESAS_PHY is not set
# CONFIG_ROCKCHIP_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_TERANETICS_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_XILINX_GMII2RGMII is not set
# CONFIG_MICREL_KS8995MA is not set
# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_USB_NET_DRIVERS=y
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
# CONFIG_USB_RTL8152 is not set
# CONFIG_USB_LAN78XX is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
# CONFIG_USB_NET_CDC_MBIM is not set
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET_ENABLE=y
CONFIG_USB_NET_CDC_SUBSET=y
# CONFIG_USB_ALI_M5632 is not set
# CONFIG_USB_AN2720 is not set
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
# CONFIG_USB_EPSON2888 is not set
# CONFIG_USB_KC2190 is not set
CONFIG_USB_NET_ZAURUS=y
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
# CONFIG_USB_HSO is not set
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=y
# CONFIG_USB_VL600 is not set
# CONFIG_USB_NET_CH9200 is not set
# CONFIG_USB_NET_AQC111 is not set
CONFIG_WLAN=y
CONFIG_WLAN_VENDOR_ADMTEK=y
# CONFIG_ADM8211 is not set
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
# CONFIG_ATH9K is not set
# CONFIG_ATH9K_HTC is not set
# CONFIG_CARL9170 is not set
# CONFIG_ATH6KL is not set
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
# CONFIG_ATH10K is not set
# CONFIG_WCN36XX is not set
CONFIG_WLAN_VENDOR_ATMEL=y
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
CONFIG_WLAN_VENDOR_BROADCOM=y
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMSMAC is not set
# CONFIG_BRCMFMAC is not set
CONFIG_WLAN_VENDOR_CISCO=y
# CONFIG_AIRO is not set
CONFIG_WLAN_VENDOR_INTEL=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_IWLWIFI is not set
CONFIG_WLAN_VENDOR_INTERSIL=y
# CONFIG_HOSTAP is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_PRISM54 is not set
CONFIG_WLAN_VENDOR_MARVELL=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_MWIFIEX is not set
# CONFIG_MWL8K is not set
CONFIG_WLAN_VENDOR_MEDIATEK=y
# CONFIG_MT7601U is not set
# CONFIG_MT76x0U is not set
# CONFIG_MT76x0E is not set
# CONFIG_MT76x2E is not set
# CONFIG_MT76x2U is not set
# CONFIG_MT7603E is not set
# CONFIG_MT7615E is not set
# CONFIG_MT7663U is not set
# CONFIG_MT7915E is not set
CONFIG_WLAN_VENDOR_RALINK=y
# CONFIG_RT2X00 is not set
CONFIG_WLAN_VENDOR_REALTEK=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
CONFIG_RTL_CARDS=m
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8723BE is not set
# CONFIG_RTL8188EE is not set
# CONFIG_RTL8192EE is not set
# CONFIG_RTL8821AE is not set
# CONFIG_RTL8192CU is not set
# CONFIG_RTL8XXXU is not set
# CONFIG_RTW88 is not set
CONFIG_WLAN_VENDOR_RSI=y
# CONFIG_RSI_91X is not set
CONFIG_WLAN_VENDOR_ST=y
# CONFIG_CW1200 is not set
CONFIG_WLAN_VENDOR_TI=y
# CONFIG_WL1251 is not set
# CONFIG_WL12XX is not set
# CONFIG_WL18XX is not set
# CONFIG_WLCORE is not set
CONFIG_WLAN_VENDOR_ZYDAS=y
# CONFIG_USB_ZD1201 is not set
# CONFIG_ZD1211RW is not set
CONFIG_WLAN_VENDOR_QUANTENNA=y
# CONFIG_QTNFMAC_PCIE is not set
CONFIG_MAC80211_HWSIM=m
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_VIRT_WIFI is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=m
# CONFIG_IEEE802154_FAKELB is not set
# CONFIG_IEEE802154_AT86RF230 is not set
# CONFIG_IEEE802154_MRF24J40 is not set
# CONFIG_IEEE802154_CC2520 is not set
# CONFIG_IEEE802154_ATUSB is not set
# CONFIG_IEEE802154_ADF7242 is not set
# CONFIG_IEEE802154_CA8210 is not set
# CONFIG_IEEE802154_MCR20A is not set
# CONFIG_IEEE802154_HWSIM is not set
CONFIG_XEN_NETDEV_FRONTEND=y
# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
# CONFIG_HYPERV_NET is not set
CONFIG_NETDEVSIM=m
CONFIG_NET_FAILOVER=m
# CONFIG_ISDN is not set
CONFIG_NVM=y
# CONFIG_NVM_PBLK is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
# CONFIG_KEYBOARD_APPLESPI is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1050 is not set
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_ELANTECH_SMBUS=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
CONFIG_MOUSE_PS2_VMMOUSE=y
CONFIG_MOUSE_PS2_SMBUS=y
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=m
CONFIG_MOUSE_ELAN_I2C=m
CONFIG_MOUSE_ELAN_I2C_I2C=y
CONFIG_MOUSE_ELAN_I2C_SMBUS=y
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set
CONFIG_RMI4_CORE=m
CONFIG_RMI4_I2C=m
CONFIG_RMI4_SPI=m
CONFIG_RMI4_SMB=m
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=m
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
CONFIG_RMI4_F34=y
CONFIG_RMI4_F55=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
CONFIG_HYPERV_KEYBOARD=m
# CONFIG_SERIO_GPIO_PS2 is not set
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_LDISC_AUTOLOAD=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_16550A_VARIANTS is not set
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
CONFIG_SERIAL_8250_NR_UARTS=64
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DWLIB=y
CONFIG_SERIAL_8250_DW=y
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_LANTIQ is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_FSL_LINFLEXUART is not set
# CONFIG_SERIAL_SPRD is not set
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
# CONFIG_ISI is not set
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
CONFIG_NOZOMI=m
# CONFIG_NULL_TTY is not set
# CONFIG_TRACE_SINK is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
# CONFIG_SERIAL_DEV_BUS is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PLAT_DATA=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_SSIF=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_DEVMEM=y
# CONFIG_DEVKMEM is not set
CONFIG_NVRAM=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
CONFIG_DEVPORT=y
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_UV_MMTIMER=m
CONFIG_TCG_TPM=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_SPI is not set
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TCG_XEN is not set
CONFIG_TCG_CRB=y
# CONFIG_TCG_VTPM_PROXY is not set
CONFIG_TCG_TIS_ST33ZP24=m
CONFIG_TCG_TIS_ST33ZP24_I2C=m
# CONFIG_TCG_TIS_ST33ZP24_SPI is not set
CONFIG_TELCLOCK=m
# CONFIG_XILLYBUS is not set
# end of Character devices

# CONFIG_RANDOM_TRUST_CPU is not set
# CONFIG_RANDOM_TRUST_BOOTLOADER is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_LTC4306 is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_MUX_REG is not set
CONFIG_I2C_MUX_MLXCPLD=m
# end of Multiplexer I2C Chip support

CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_AMD_MP2 is not set
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=m
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
CONFIG_I2C_DESIGNWARE_PLATFORM=m
CONFIG_I2C_DESIGNWARE_BAYTRAIL=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EMEV2 is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_MLXCPLD=m
# end of I2C Hardware Bus support

CONFIG_I2C_STUB=m
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

# CONFIG_I3C is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y
# CONFIG_SPI_MEM is not set

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_AXI_SPI_ENGINE is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_CADENCE is not set
# CONFIG_SPI_DESIGNWARE is not set
# CONFIG_SPI_NXP_FLEXSPI is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_ROCKCHIP is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_SIFIVE is not set
# CONFIG_SPI_MXIC is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_ZYNQMP_GQSPI is not set
# CONFIG_SPI_AMD is not set

#
# SPI Multiplexer support
#
# CONFIG_SPI_MUX is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_LOOPBACK_TEST is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPI_SLAVE is not set
# CONFIG_SPMI is not set
# CONFIG_HSI is not set
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
# CONFIG_DP83640_PHY is not set
# CONFIG_PTP_1588_CLOCK_INES is not set
CONFIG_PTP_1588_CLOCK_KVM=m
# CONFIG_PTP_1588_CLOCK_IDT82P33 is not set
# CONFIG_PTP_1588_CLOCK_IDTCM is not set
# CONFIG_PTP_1588_CLOCK_VMW is not set
# end of PTP clock support

CONFIG_PINCTRL=y
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
CONFIG_PINCTRL_AMD=m
# CONFIG_PINCTRL_MCP23S08 is not set
# CONFIG_PINCTRL_SX150X is not set
CONFIG_PINCTRL_BAYTRAIL=y
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_LYNXPOINT is not set
CONFIG_PINCTRL_INTEL=m
CONFIG_PINCTRL_BROXTON=m
CONFIG_PINCTRL_CANNONLAKE=m
CONFIG_PINCTRL_CEDARFORK=m
CONFIG_PINCTRL_DENVERTON=m
CONFIG_PINCTRL_GEMINILAKE=m
# CONFIG_PINCTRL_ICELAKE is not set
# CONFIG_PINCTRL_JASPERLAKE is not set
CONFIG_PINCTRL_LEWISBURG=m
CONFIG_PINCTRL_SUNRISEPOINT=m
# CONFIG_PINCTRL_TIGERLAKE is not set
CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=m

#
# Memory mapped GPIO drivers
#
CONFIG_GPIO_AMDPT=m
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EXAR is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_ICH=m
# CONFIG_GPIO_MB86S7X is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_XILINX is not set
# CONFIG_GPIO_AMD_FCH is not set
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_IT87 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_WINBOND is not set
# CONFIG_GPIO_WS16C48 is not set
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_TPIC2810 is not set
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
# end of MFD GPIO expanders

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
# CONFIG_GPIO_PCIE_IDIO_24 is not set
# CONFIG_GPIO_RDC321X is not set
# end of PCI GPIO expanders

#
# SPI GPIO expanders
#
# CONFIG_GPIO_MAX3191X is not set
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_PISOSR is not set
# CONFIG_GPIO_XRA1403 is not set
# end of SPI GPIO expanders

#
# USB GPIO expanders
#
# end of USB GPIO expanders

# CONFIG_GPIO_AGGREGATOR is not set
# CONFIG_GPIO_MOCKUP is not set
# CONFIG_W1 is not set
# CONFIG_POWER_AVS is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_RESTART is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_POWER_SUPPLY_HWMON=y
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_CW2015 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_CHARGER_SBS is not set
# CONFIG_MANAGER_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_LT3651 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24257 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ25890 is not set
CONFIG_CHARGER_SMB347=m
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_CHARGER_RT9455 is not set
# CONFIG_CHARGER_BD99954 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM1177 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_AS370 is not set
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_AXI_FAN_CONTROL is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
# CONFIG_SENSORS_AMD_ENERGY is not set
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ASPEED is not set
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_DRIVETEMP is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DELL_SMM=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_FTSTEUTATES is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_I5500=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2947_I2C is not set
# CONFIG_SENSORS_LTC2947_SPI is not set
# CONFIG_SENSORS_LTC2990 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX31722 is not set
# CONFIG_SENSORS_MAX31730 is not set
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MAX31790 is not set
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_MLXREG_FAN is not set
# CONFIG_SENSORS_TC654 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_BEL_PFE is not set
# CONFIG_SENSORS_IBM_CFFPS is not set
# CONFIG_SENSORS_INSPUR_IPSPS is not set
# CONFIG_SENSORS_IR35221 is not set
# CONFIG_SENSORS_IR38064 is not set
# CONFIG_SENSORS_IRPS5401 is not set
# CONFIG_SENSORS_ISL68137 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_LTC3815 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX16601 is not set
# CONFIG_SENSORS_MAX20730 is not set
# CONFIG_SENSORS_MAX20751 is not set
# CONFIG_SENSORS_MAX31785 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_PXE1610 is not set
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_TPS53679 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_XDPE122 is not set
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_STTS751 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_TMP513 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
# CONFIG_SENSORS_W83773G is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_XGENE is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=y
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_WRITABLE_TRIPS=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set

#
# Intel thermal drivers
#
CONFIG_INTEL_POWERCLAMP=m
CONFIG_X86_PKG_TEMP_THERMAL=m
CONFIG_INTEL_SOC_DTS_IOSF_CORE=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
CONFIG_INT340X_THERMAL=m
CONFIG_ACPI_THERMAL_REL=m
# CONFIG_INT3406_THERMAL is not set
CONFIG_PROC_THERMAL_MMIO_RAPL=y
# end of ACPI INT340X thermal drivers

CONFIG_INTEL_PCH_THERMAL=m
# end of Intel thermal drivers

CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED=y
CONFIG_WATCHDOG_OPEN_TIMEOUT=0
CONFIG_WATCHDOG_SYSFS=y

#
# Watchdog Pretimeout Governors
#
# CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_WDAT_WDT=m
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_ZIIRAVE_WATCHDOG is not set
# CONFIG_MLX_WDT is not set
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_EBC_C384_WDT is not set
CONFIG_F71808E_WDT=m
CONFIG_SP5100_TCO=m
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=m
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=m
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_TQMX86_WDT is not set
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_INTEL_MEI_WDT=m
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set
# CONFIG_MEN_A21_WDT is not set
CONFIG_XEN_WDT=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_BD9571MWV is not set
# CONFIG_MFD_AXP20X_I2C is not set
# CONFIG_MFD_MADERA is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
# CONFIG_MFD_DLN2 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_MFD_MP2629 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=m
# CONFIG_INTEL_SOC_PMIC_CHTDC_TI is not set
CONFIG_MFD_INTEL_LPSS=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
CONFIG_MFD_INTEL_LPSS_PCI=y
# CONFIG_MFD_INTEL_PMC_BXT is not set
# CONFIG_MFD_IQS62X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6360 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65086 is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TQMX86 is not set
CONFIG_MFD_VX855=m
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# end of Multifunction device drivers

# CONFIG_REGULATOR is not set
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
CONFIG_LIRC=y
CONFIG_RC_DECODERS=y
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_SANYO_DECODER=m
# CONFIG_IR_SHARP_DECODER is not set
CONFIG_IR_MCE_KBD_DECODER=m
# CONFIG_IR_XMP_DECODER is not set
CONFIG_IR_IMON_DECODER=m
# CONFIG_IR_RCMM_DECODER is not set
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
CONFIG_IR_ENE=m
# CONFIG_IR_IMON is not set
# CONFIG_IR_IMON_RAW is not set
# CONFIG_IR_MCEUSB is not set
CONFIG_IR_ITE_CIR=m
CONFIG_IR_FINTEK=m
CONFIG_IR_NUVOTON=m
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
CONFIG_IR_WINBOND_CIR=m
# CONFIG_IR_IGORPLUGUSB is not set
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_TTUSBIR is not set
# CONFIG_RC_LOOPBACK is not set
CONFIG_IR_SERIAL=m
CONFIG_IR_SERIAL_TRANSMITTER=y
CONFIG_IR_SIR=m
# CONFIG_RC_XBOX_DVD is not set
# CONFIG_MEDIA_CEC_SUPPORT is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_INTEL_GTT=m
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=m
CONFIG_DRM_MIPI_DSI=y
CONFIG_DRM_DP_AUX_CHARDEV=y
# CONFIG_DRM_DEBUG_SELFTEST is not set
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
# CONFIG_DRM_DP_CEC is not set
CONFIG_DRM_TTM=m
CONFIG_DRM_TTM_DMA_PAGE_POOL=y
CONFIG_DRM_VRAM_HELPER=m
CONFIG_DRM_TTM_HELPER=m
CONFIG_DRM_GEM_SHMEM_HELPER=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_I2C_NXP_TDA9950 is not set
# end of I2C encoder or helper chips

#
# ARM devices
#
# end of ARM devices

# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=m
CONFIG_DRM_I915_FORCE_PROBE=""
CONFIG_DRM_I915_CAPTURE_ERROR=y
CONFIG_DRM_I915_COMPRESS_ERROR=y
CONFIG_DRM_I915_USERPTR=y
CONFIG_DRM_I915_GVT=y
CONFIG_DRM_I915_GVT_KVMGT=m
CONFIG_DRM_I915_FENCE_TIMEOUT=10000
CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND=250
CONFIG_DRM_I915_HEARTBEAT_INTERVAL=2500
CONFIG_DRM_I915_PREEMPT_TIMEOUT=640
CONFIG_DRM_I915_MAX_REQUEST_BUSYWAIT=8000
CONFIG_DRM_I915_STOP_TIMEOUT=100
CONFIG_DRM_I915_TIMESLICE_DURATION=1
CONFIG_DRM_VGEM=m
# CONFIG_DRM_VKMS is not set
CONFIG_DRM_VMWGFX=m
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=m
CONFIG_DRM_GMA600=y
CONFIG_DRM_GMA3600=y
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=m
CONFIG_DRM_MGAG200=m
CONFIG_DRM_QXL=m
CONFIG_DRM_BOCHS=m
CONFIG_DRM_VIRTIO_GPU=m
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
# end of Display Panels

CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# end of Display Interface Bridges

# CONFIG_DRM_ETNAVIV is not set
CONFIG_DRM_CIRRUS_QEMU=m
# CONFIG_DRM_GM12U320 is not set
# CONFIG_TINYDRM_HX8357D is not set
# CONFIG_TINYDRM_ILI9225 is not set
# CONFIG_TINYDRM_ILI9341 is not set
# CONFIG_TINYDRM_ILI9486 is not set
# CONFIG_TINYDRM_MI0283QT is not set
# CONFIG_TINYDRM_REPAPER is not set
# CONFIG_TINYDRM_ST7586 is not set
# CONFIG_TINYDRM_ST7735R is not set
# CONFIG_DRM_XEN is not set
# CONFIG_DRM_VBOXVIDEO is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y

#
# Frame buffer Devices
#
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_IBM_GXT4500 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_HYPERV=m
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SM712 is not set
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_AMS369FG06 is not set
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
# CONFIG_LCD_OTM3225A is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_QCOM_WLED is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
# end of Backlight & LCD device support

CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
# CONFIG_VGACON_SOFT_SCROLLBACK_PERSISTENT_ENABLE_BY_DEFAULT is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER is not set
# end of Console display driver support

CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# end of Graphics support

# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACCUTOUCH is not set
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_APPLEIR is not set
CONFIG_HID_ASUS=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
# CONFIG_HID_BETOP_FF is not set
# CONFIG_HID_BIGBEN_FF is not set
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
# CONFIG_HID_CORSAIR is not set
# CONFIG_HID_COUGAR is not set
# CONFIG_HID_MACALLY is not set
CONFIG_HID_CMEDIA=m
# CONFIG_HID_CP2112 is not set
# CONFIG_HID_CREATIVE_SB0540 is not set
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELAN is not set
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=m
CONFIG_HID_GEMBIRD=m
CONFIG_HID_GFRM=m
# CONFIG_HID_GLORIOUS is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_GT683R is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=m
# CONFIG_HID_VIEWSONIC is not set
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_ITE=m
CONFIG_HID_JABRA=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LED=m
CONFIG_HID_LENOVO=m
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
CONFIG_HID_LOGITECH_HIDPP=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MALTRON is not set
# CONFIG_HID_MAYFLASH is not set
# CONFIG_HID_REDRAGON is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_NTI=m
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PENMOUNT is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PLANTRONICS=m
CONFIG_HID_PRIMAX=m
# CONFIG_HID_RETRODE is not set
# CONFIG_HID_ROCCAT is not set
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEAM is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_RMI=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_HYPERV_MOUSE=m
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_UDRAW_PS3 is not set
# CONFIG_HID_U2FZERO is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=y
CONFIG_HID_SENSOR_CUSTOM_SENSOR=m
CONFIG_HID_ALPS=m
# CONFIG_HID_MCP2221 is not set
# end of Special HID drivers

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set
# end of USB HID support

#
# I2C HID support
#
CONFIG_I2C_HID=m
# end of I2C HID support

#
# Intel ISH HID support
#
CONFIG_INTEL_ISH_HID=m
# CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER is not set
# end of Intel ISH HID support
# end of HID support

CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_USB_CONN_GPIO is not set
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_LEDS_TRIGGER_USBPORT=y
CONFIG_USB_AUTOSUSPEND_DELAY=2
CONFIG_USB_MON=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_DBGCAP is not set
CONFIG_USB_XHCI_PCI=y
# CONFIG_USB_XHCI_PCI_RENESAS is not set
# CONFIG_USB_XHCI_PLATFORM is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_FSL is not set
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_USB_CDNS3 is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_F8153X is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MXUPORT is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_XSENS_MT is not set
# CONFIG_USB_SERIAL_WISHBONE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_UPD78F0730 is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_APPLE_MFI_FASTCHARGE is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HUB_USB251XB is not set
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_USB_HSIC_USB4604 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set
# CONFIG_USB_CHAOSKEY is not set
# CONFIG_USB_ATM is not set

#
# USB Physical Layer drivers
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
# end of USB Physical Layer drivers

# CONFIG_USB_GADGET is not set
CONFIG_TYPEC=y
# CONFIG_TYPEC_TCPM is not set
CONFIG_TYPEC_UCSI=y
# CONFIG_UCSI_CCG is not set
CONFIG_UCSI_ACPI=y
# CONFIG_TYPEC_TPS6598X is not set

#
# USB Type-C Multiplexer/DeMultiplexer Switch support
#
# CONFIG_TYPEC_MUX_PI3USB30532 is not set
# end of USB Type-C Multiplexer/DeMultiplexer Switch support

#
# USB Type-C Alternate Mode drivers
#
# CONFIG_TYPEC_DP_ALTMODE is not set
# end of USB Type-C Alternate Mode drivers

# CONFIG_USB_ROLE_SWITCH is not set
CONFIG_MMC=m
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_IO_ACCESSORS=y
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_SDHCI_F_SDH30 is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SPI is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
# CONFIG_MMC_USDHI6ROL0 is not set
# CONFIG_MMC_REALTEK_PCI is not set
CONFIG_MMC_CQHCI=m
# CONFIG_MMC_HSQ is not set
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MMC_MTK is not set
# CONFIG_MMC_SDHCI_XENON is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
# CONFIG_LEDS_APU is not set
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3532 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP3952 is not set
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m
CONFIG_LEDS_MLXCPLD=m
# CONFIG_LEDS_MLXREG is not set
# CONFIG_LEDS_USER is not set
# CONFIG_LEDS_NIC78BX is not set
# CONFIG_LEDS_TI_LMU_COMMON is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_DISK is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_ACTIVITY is not set
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
# CONFIG_LEDS_TRIGGER_PATTERN is not set
CONFIG_LEDS_TRIGGER_AUDIO=m
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
# CONFIG_INFINIBAND_EXP_LEGACY_VERBS_NEW_UAPI is not set
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ON_DEMAND_PAGING=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS=y
# CONFIG_INFINIBAND_MTHCA is not set
# CONFIG_INFINIBAND_EFA is not set
# CONFIG_INFINIBAND_I40IW is not set
# CONFIG_MLX4_INFINIBAND is not set
# CONFIG_INFINIBAND_OCRDMA is not set
# CONFIG_INFINIBAND_USNIC is not set
# CONFIG_INFINIBAND_BNXT_RE is not set
# CONFIG_INFINIBAND_RDMAVT is not set
CONFIG_RDMA_RXE=m
CONFIG_RDMA_SIW=m
CONFIG_INFINIBAND_IPOIB=m
# CONFIG_INFINIBAND_IPOIB_CM is not set
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_SRPT=m
# CONFIG_INFINIBAND_ISER is not set
# CONFIG_INFINIBAND_ISERT is not set
# CONFIG_INFINIBAND_RTRS_CLIENT is not set
# CONFIG_INFINIBAND_RTRS_SERVER is not set
# CONFIG_INFINIBAND_OPA_VNIC is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=m
CONFIG_EDAC_GHES=y
CONFIG_EDAC_AMD64=m
# CONFIG_EDAC_AMD64_ERROR_INJECTION is not set
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_IE31200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_EDAC_SBRIDGE=m
CONFIG_EDAC_SKX=m
# CONFIG_EDAC_I10NM is not set
CONFIG_EDAC_PND2=m
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set
CONFIG_RTC_NVMEM=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_ABB5ZES3 is not set
# CONFIG_RTC_DRV_ABEOZ9 is not set
# CONFIG_RTC_DRV_ABX80X is not set
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1307_CENTURY is not set
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1374_WDT is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8523=m
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF85363 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8010 is not set
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV3028 is not set
# CONFIG_RTC_DRV_RV8803 is not set
# CONFIG_RTC_DRV_SD3078 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1302 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1343 is not set
# CONFIG_RTC_DRV_DS1347 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6916 is not set
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RX4581=m
# CONFIG_RTC_DRV_RX6110 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_MCP795 is not set
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_DS3232_HWMON=y
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_RV3029C2=m
# CONFIG_RTC_DRV_RV3029_HWMON is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_FTRTC010 is not set

#
# HID Sensor RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
# CONFIG_ALTERA_MSGDMA is not set
CONFIG_INTEL_IDMA64=m
# CONFIG_INTEL_IDXD is not set
CONFIG_INTEL_IOATDMA=m
# CONFIG_PLX_DMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y
# CONFIG_DW_EDMA is not set
# CONFIG_DW_EDMA_PCIE is not set
CONFIG_HSU_DMA=y
# CONFIG_SF_PDMA is not set

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
# CONFIG_SW_SYNC is not set
# CONFIG_UDMABUF is not set
# CONFIG_DMABUF_MOVE_NOTIFY is not set
# CONFIG_DMABUF_SELFTESTS is not set
# CONFIG_DMABUF_HEAPS is not set
# end of DMABUF options

CONFIG_DCA=m
# CONFIG_AUXDISPLAY is not set
# CONFIG_PANEL is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_PRUSS is not set
# CONFIG_UIO_MF624 is not set
CONFIG_UIO_HV_GENERIC=m
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO_VIRQFD=m
CONFIG_VFIO=m
CONFIG_VFIO_NOIOMMU=y
CONFIG_VFIO_PCI=m
# CONFIG_VFIO_PCI_VGA is not set
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
# CONFIG_VFIO_PCI_IGD is not set
CONFIG_VFIO_MDEV=m
CONFIG_VFIO_MDEV_DEVICE=m
CONFIG_IRQ_BYPASS_MANAGER=m
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_MENU=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_LEGACY=y
# CONFIG_VIRTIO_PMEM is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MEM=m
CONFIG_VIRTIO_INPUT=m
# CONFIG_VIRTIO_MMIO is not set
# CONFIG_VDPA is not set
CONFIG_VHOST_IOTLB=m
CONFIG_VHOST=m
CONFIG_VHOST_MENU=y
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_VSOCK=m
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=m
CONFIG_HYPERV_TIMER=y
CONFIG_HYPERV_UTILS=m
CONFIG_HYPERV_BALLOON=m
# end of Microsoft Hyper-V guest support

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
CONFIG_XEN_DEV_EVTCHN=m
# CONFIG_XEN_BACKEND is not set
CONFIG_XENFS=m
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
# CONFIG_XEN_GRANT_DMA_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
# CONFIG_XEN_PVCALLS_FRONTEND is not set
CONFIG_XEN_PRIVCMD=m
CONFIG_XEN_EFI=y
CONFIG_XEN_AUTO_XLATE=y
CONFIG_XEN_ACPI=y
# end of Xen driver support

# CONFIG_GREYBUS is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACPI_WMI=m
CONFIG_WMI_BMOF=m
# CONFIG_ALIENWARE_WMI is not set
# CONFIG_HUAWEI_WMI is not set
# CONFIG_INTEL_WMI_SBL_FW_UPDATE is not set
CONFIG_INTEL_WMI_THUNDERBOLT=m
CONFIG_MXM_WMI=m
# CONFIG_PEAQ_WMI is not set
# CONFIG_XIAOMI_WMI is not set
CONFIG_ACERHDF=m
# CONFIG_ACER_WIRELESS is not set
CONFIG_ACER_WMI=m
CONFIG_APPLE_GMUX=m
CONFIG_ASUS_LAPTOP=m
# CONFIG_ASUS_WIRELESS is not set
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
CONFIG_EEEPC_LAPTOP=m
CONFIG_EEEPC_WMI=m
CONFIG_DCDBAS=m
CONFIG_DELL_SMBIOS=m
CONFIG_DELL_SMBIOS_WMI=y
# CONFIG_DELL_SMBIOS_SMM is not set
CONFIG_DELL_LAPTOP=m
CONFIG_DELL_RBTN=m
CONFIG_DELL_RBU=m
CONFIG_DELL_SMO8800=m
CONFIG_DELL_WMI=m
CONFIG_DELL_WMI_DESCRIPTOR=m
CONFIG_DELL_WMI_AIO=m
CONFIG_DELL_WMI_LED=m
CONFIG_AMILO_RFKILL=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_TABLET=m
# CONFIG_GPD_POCKET_FAN is not set
CONFIG_HP_ACCEL=m
CONFIG_HP_WIRELESS=m
CONFIG_HP_WMI=m
# CONFIG_IBM_RTL is not set
CONFIG_IDEAPAD_LAPTOP=m
CONFIG_SENSORS_HDAPS=m
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_INTEL_ATOMISP2_PM is not set
CONFIG_INTEL_HID_EVENT=m
# CONFIG_INTEL_INT0002_VGPIO is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_INTEL_OAKTRAIL=m
CONFIG_INTEL_VBTN=m
# CONFIG_SURFACE3_WMI is not set
# CONFIG_SURFACE_3_POWER_OPREGION is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
CONFIG_MSI_LAPTOP=m
CONFIG_MSI_WMI=m
# CONFIG_PCENGINES_APU2 is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_SAMSUNG_Q10=m
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
CONFIG_ACPI_CMPC=m
CONFIG_COMPAL_LAPTOP=m
# CONFIG_LG_LAPTOP is not set
CONFIG_PANASONIC_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
# CONFIG_SYSTEM76_ACPI is not set
CONFIG_TOPSTAR_LAPTOP=m
# CONFIG_I2C_MULTI_INSTANTIATE is not set
CONFIG_MLX_PLATFORM=m
CONFIG_INTEL_IPS=m
CONFIG_INTEL_RST=m
# CONFIG_INTEL_SMARTCONNECT is not set

#
# Intel Speed Select Technology interface support
#
# CONFIG_INTEL_SPEED_SELECT_INTERFACE is not set
# end of Intel Speed Select Technology interface support

CONFIG_INTEL_TURBO_MAX_3=y
# CONFIG_INTEL_UNCORE_FREQ_CONTROL is not set
CONFIG_INTEL_PMC_CORE=m
# CONFIG_INTEL_PUNIT_IPC is not set
# CONFIG_INTEL_SCU_PCI is not set
# CONFIG_INTEL_SCU_PLATFORM is not set
CONFIG_PMC_ATOM=y
# CONFIG_MFD_CROS_EC is not set
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_MELLANOX_PLATFORM=y
CONFIG_MLXREG_HOTPLUG=m
# CONFIG_MLXREG_IO is not set
CONFIG_HAVE_CLK=y
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y
# CONFIG_COMMON_CLK_MAX9485 is not set
# CONFIG_COMMON_CLK_SI5341 is not set
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI544 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_PWM is not set
CONFIG_HWSPINLOCK=y

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# end of Clock Source drivers

CONFIG_MAILBOX=y
CONFIG_PCC=y
# CONFIG_ALTERA_MBOX is not set
CONFIG_IOMMU_IOVA=y
CONFIG_IOASID=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# end of Generic IOMMU Pagetable Support

# CONFIG_IOMMU_DEBUGFS is not set
# CONFIG_IOMMU_DEFAULT_PASSTHROUGH is not set
CONFIG_IOMMU_DMA=y
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_V2=m
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_SVM is not set
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
# CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON is not set
CONFIG_IRQ_REMAP=y
CONFIG_HYPERV_IOMMU=y

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set
# end of Remoteproc drivers

#
# Rpmsg drivers
#
# CONFIG_RPMSG_QCOM_GLINK_RPM is not set
# CONFIG_RPMSG_VIRTIO is not set
# end of Rpmsg drivers

# CONFIG_SOUNDWIRE is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#
# end of Amlogic SoC drivers

#
# Aspeed SoC drivers
#
# end of Aspeed SoC drivers

#
# Broadcom SoC drivers
#
# end of Broadcom SoC drivers

#
# NXP/Freescale QorIQ SoC drivers
#
# end of NXP/Freescale QorIQ SoC drivers

#
# i.MX SoC drivers
#
# end of i.MX SoC drivers

#
# Qualcomm SoC drivers
#
# end of Qualcomm SoC drivers

# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# CONFIG_XILINX_VCU is not set
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_NTB=m
# CONFIG_NTB_MSI is not set
# CONFIG_NTB_AMD is not set
# CONFIG_NTB_IDT is not set
# CONFIG_NTB_INTEL is not set
# CONFIG_NTB_SWITCHTEC is not set
# CONFIG_NTB_PINGPONG is not set
# CONFIG_NTB_TOOL is not set
# CONFIG_NTB_PERF is not set
# CONFIG_NTB_TRANSPORT is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_DEBUG is not set
CONFIG_PWM_LPSS=m
CONFIG_PWM_LPSS_PCI=m
CONFIG_PWM_LPSS_PLATFORM=m
# CONFIG_PWM_PCA9685 is not set

#
# IRQ chip support
#
# end of IRQ chip support

# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_INTEL_EMMC is not set
# end of PHY Subsystem

CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL_CORE=m
CONFIG_INTEL_RAPL=m
# CONFIG_IDLE_INJECT is not set
# CONFIG_MCB is not set

#
# Performance monitor support
#
# end of Performance monitor support

CONFIG_RAS=y
# CONFIG_RAS_CEC is not set
# CONFIG_USB4 is not set

#
# Android
#
# CONFIG_ANDROID is not set
# end of Android

CONFIG_LIBNVDIMM=m
CONFIG_BLK_DEV_PMEM=m
CONFIG_ND_BLK=m
CONFIG_ND_CLAIM=y
CONFIG_ND_BTT=m
CONFIG_BTT=y
CONFIG_ND_PFN=m
CONFIG_NVDIMM_PFN=y
CONFIG_NVDIMM_DAX=y
CONFIG_NVDIMM_KEYS=y
CONFIG_DAX_DRIVER=y
CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_PMEM=m
CONFIG_DEV_DAX_KMEM=m
CONFIG_DEV_DAX_PMEM_COMPAT=m
CONFIG_NVMEM=y
CONFIG_NVMEM_SYSFS=y

#
# HW tracing support
#
CONFIG_STM=m
# CONFIG_STM_PROTO_BASIC is not set
# CONFIG_STM_PROTO_SYS_T is not set
CONFIG_STM_DUMMY=m
CONFIG_STM_SOURCE_CONSOLE=m
CONFIG_STM_SOURCE_HEARTBEAT=m
CONFIG_STM_SOURCE_FTRACE=m
CONFIG_INTEL_TH=m
CONFIG_INTEL_TH_PCI=m
CONFIG_INTEL_TH_ACPI=m
CONFIG_INTEL_TH_GTH=m
CONFIG_INTEL_TH_STH=m
CONFIG_INTEL_TH_MSU=m
CONFIG_INTEL_TH_PTI=m
# CONFIG_INTEL_TH_DEBUG is not set
# end of HW tracing support

# CONFIG_FPGA is not set
# CONFIG_TEE is not set
# CONFIG_UNISYS_VISORBUS is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set
# CONFIG_INTERCONNECT is not set
# CONFIG_COUNTER is not set
# CONFIG_MOST is not set
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_VALIDATE_FS_PARSER is not set
CONFIG_FS_IOMAP=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT2=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_EXT4_KUNIT_TESTS=m
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_ONLINE_SCRUB=y
CONFIG_XFS_ONLINE_REPAIR=y
CONFIG_XFS_DEBUG=y
CONFIG_XFS_ASSERT_FATAL=y
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_BTRFS_FS_REF_VERIFY is not set
# CONFIG_NILFS2_FS is not set
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
CONFIG_F2FS_FS_SECURITY=y
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_F2FS_IO_TRACE is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
# CONFIG_F2FS_FS_COMPRESSION is not set
# CONFIG_ZONEFS_FS is not set
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
CONFIG_MANDATORY_FILE_LOCKING=y
CONFIG_FS_ENCRYPTION=y
CONFIG_FS_ENCRYPTION_ALGS=y
# CONFIG_FS_VERITY is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
# CONFIG_VIRTIO_FS is not set
CONFIG_OVERLAY_FS=m
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
# CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW is not set
# CONFIG_OVERLAY_FS_INDEX is not set
# CONFIG_OVERLAY_FS_XINO_AUTO is not set
# CONFIG_OVERLAY_FS_METACOPY is not set

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set
# end of Caches

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
# end of CD-ROM/DVD Filesystems

#
# DOS/FAT/EXFAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_FAT_DEFAULT_UTF8 is not set
# CONFIG_EXFAT_FS is not set
# CONFIG_NTFS_FS is not set
# end of DOS/FAT/EXFAT/NT Filesystems

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_VMCORE_DEVICE_DUMP=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_PROC_PID_ARCH_STATUS=y
CONFIG_PROC_CPU_RESCTRL=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_MEMFD_CREATE=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
# end of Pseudo filesystems

CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ORANGEFS_FS is not set
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=m
CONFIG_CRAMFS_BLOCKDEV=y
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZ4 is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_ZSTD is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_DEFLATE_COMPRESS=y
# CONFIG_PSTORE_LZO_COMPRESS is not set
# CONFIG_PSTORE_LZ4_COMPRESS is not set
# CONFIG_PSTORE_LZ4HC_COMPRESS is not set
# CONFIG_PSTORE_842_COMPRESS is not set
# CONFIG_PSTORE_ZSTD_COMPRESS is not set
CONFIG_PSTORE_COMPRESS=y
CONFIG_PSTORE_DEFLATE_COMPRESS_DEFAULT=y
CONFIG_PSTORE_COMPRESS_DEFAULT="deflate"
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_PMSG is not set
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
# CONFIG_PSTORE_BLK is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_EROFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_FLEXFILE_LAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
CONFIG_NFS_V4_SECURITY_LABEL=y
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DEBUG=y
CONFIG_NFS_DISABLE_UDP_SUPPORT=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_PNFS=y
# CONFIG_NFSD_BLOCKLAYOUT is not set
CONFIG_NFSD_SCSILAYOUT=y
# CONFIG_NFSD_FLEXFILELAYOUT is not set
# CONFIG_NFSD_V4_2_INTER_SSC is not set
CONFIG_NFSD_V4_SECURITY_LABEL=y
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_SUNRPC_DISABLE_INSECURE_ENCTYPES is not set
CONFIG_SUNRPC_DEBUG=y
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_CEPH_FS=m
# CONFIG_CEPH_FSCACHE is not set
CONFIG_CEPH_FS_POSIX_ACL=y
# CONFIG_CEPH_FS_SECURITY_LABEL is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_SMB_DIRECT is not set
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=y
CONFIG_9P_FS_POSIX_ACL=y
# CONFIG_9P_FS_SECURITY is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y
# CONFIG_UNICODE is not set
CONFIG_IO_WQ=y
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_REQUEST_CACHE is not set
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEY_DH_OPERATIONS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITY_WRITABLE_HOOKS=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_PAGE_TABLE_ISOLATION=y
# CONFIG_SECURITY_INFINIBAND is not set
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_INTEL_TXT=y
CONFIG_LSM_MMAP_MIN_ADDR=65535
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HARDENED_USERCOPY=y
CONFIG_HARDENED_USERCOPY_FALLBACK=y
CONFIG_FORTIFY_SOURCE=y
# CONFIG_STATIC_USERMODEHELPER is not set
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_SECURITY_SELINUX_SIDTAB_HASH_BITS=9
CONFIG_SECURITY_SELINUX_SID2STR_CACHE_SIZE=256
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_HASH=y
CONFIG_SECURITY_APPARMOR_HASH_DEFAULT=y
# CONFIG_SECURITY_APPARMOR_DEBUG is not set
# CONFIG_SECURITY_APPARMOR_KUNIT_TEST is not set
# CONFIG_SECURITY_LOADPIN is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_SAFESETID is not set
# CONFIG_SECURITY_LOCKDOWN_LSM is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
CONFIG_INTEGRITY_TRUSTED_KEYRING=y
# CONFIG_INTEGRITY_PLATFORM_KEYRING is not set
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_LSM_RULES=y
# CONFIG_IMA_TEMPLATE is not set
CONFIG_IMA_NG_TEMPLATE=y
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
# CONFIG_IMA_DEFAULT_HASH_SHA512 is not set
CONFIG_IMA_DEFAULT_HASH="sha1"
# CONFIG_IMA_WRITE_POLICY is not set
# CONFIG_IMA_READ_POLICY is not set
CONFIG_IMA_APPRAISE=y
# CONFIG_IMA_ARCH_POLICY is not set
# CONFIG_IMA_APPRAISE_BUILD_POLICY is not set
CONFIG_IMA_APPRAISE_BOOTPARAM=y
# CONFIG_IMA_APPRAISE_MODSIG is not set
CONFIG_IMA_TRUSTED_KEYRING=y
# CONFIG_IMA_BLACKLIST_KEYRING is not set
# CONFIG_IMA_LOAD_X509 is not set
CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS=y
CONFIG_IMA_QUEUE_EARLY_BOOT_KEYS=y
# CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT is not set
CONFIG_EVM=y
CONFIG_EVM_ATTR_FSUUID=y
# CONFIG_EVM_ADD_XATTRS is not set
# CONFIG_EVM_LOAD_X509 is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_LSM="lockdown,yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor,bpf"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_INIT_STACK_NONE=y
# CONFIG_INIT_ON_ALLOC_DEFAULT_ON is not set
# CONFIG_INIT_ON_FREE_DEFAULT_ON is not set
# end of Memory initialization
# end of Kernel hardening options
# end of Security options

CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_SKCIPHER=y
CONFIG_CRYPTO_SKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=m
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_SIMD=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=m
CONFIG_CRYPTO_ECC=m
CONFIG_CRYPTO_ECDH=m
# CONFIG_CRYPTO_ECRDSA is not set
# CONFIG_CRYPTO_CURVE25519 is not set
# CONFIG_CRYPTO_CURVE25519_X86 is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_CHACHA20POLY1305=m
# CONFIG_CRYPTO_AEGIS128 is not set
# CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CFB=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_OFB is not set
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y
# CONFIG_CRYPTO_KEYWRAP is not set
# CONFIG_CRYPTO_NHPOLY1305_SSE2 is not set
# CONFIG_CRYPTO_NHPOLY1305_AVX2 is not set
# CONFIG_CRYPTO_ADIANTUM is not set
CONFIG_CRYPTO_ESSIV=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_XXHASH=m
CONFIG_CRYPTO_BLAKE2B=m
# CONFIG_CRYPTO_BLAKE2S is not set
# CONFIG_CRYPTO_BLAKE2S_X86 is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_POLY1305=m
CONFIG_CRYPTO_POLY1305_X86_64=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=m
# CONFIG_CRYPTO_SM3 is not set
# CONFIG_CRYPTO_STREEBOG is not set
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_DES3_EDE_X86_64=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_CHACHA20=m
CONFIG_CRYPTO_CHACHA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
# CONFIG_CRYPTO_SM4 is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set
# CONFIG_CRYPTO_ZSTD is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_USER_API_RNG=y
CONFIG_CRYPTO_USER_API_AEAD=y
# CONFIG_CRYPTO_STATS is not set
CONFIG_CRYPTO_HASH_INFO=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_ARC4=m
# CONFIG_CRYPTO_LIB_BLAKE2S is not set
CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA=m
CONFIG_CRYPTO_LIB_CHACHA_GENERIC=m
# CONFIG_CRYPTO_LIB_CHACHA is not set
# CONFIG_CRYPTO_LIB_CURVE25519 is not set
CONFIG_CRYPTO_LIB_DES=m
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=11
CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305=m
CONFIG_CRYPTO_LIB_POLY1305_GENERIC=m
# CONFIG_CRYPTO_LIB_POLY1305 is not set
# CONFIG_CRYPTO_LIB_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_LIB_SHA256=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_ATMEL_ECC is not set
# CONFIG_CRYPTO_DEV_ATMEL_SHA204A is not set
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=y
CONFIG_CRYPTO_DEV_SP_CCP=y
CONFIG_CRYPTO_DEV_CCP_CRYPTO=m
CONFIG_CRYPTO_DEV_SP_PSP=y
# CONFIG_CRYPTO_DEV_CCP_DEBUGFS is not set
CONFIG_CRYPTO_DEV_QAT=m
CONFIG_CRYPTO_DEV_QAT_DH895xCC=m
CONFIG_CRYPTO_DEV_QAT_C3XXX=m
CONFIG_CRYPTO_DEV_QAT_C62X=m
CONFIG_CRYPTO_DEV_QAT_DH895xCCVF=m
CONFIG_CRYPTO_DEV_QAT_C3XXXVF=m
CONFIG_CRYPTO_DEV_QAT_C62XVF=m
CONFIG_CRYPTO_DEV_NITROX=m
CONFIG_CRYPTO_DEV_NITROX_CNN55XX=m
# CONFIG_CRYPTO_DEV_VIRTIO is not set
# CONFIG_CRYPTO_DEV_SAFEXCEL is not set
# CONFIG_CRYPTO_DEV_AMLOGIC_GXL is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
# CONFIG_ASYMMETRIC_TPM_KEY_SUBTYPE is not set
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS8_PRIVATE_KEY_PARSER is not set
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
CONFIG_SIGNED_PE_FILE_VERIFICATION=y

#
# Certificates for signature checking
#
CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
CONFIG_SYSTEM_BLACKLIST_KEYRING=y
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
# end of Certificates for signature checking

CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_RAID6_PQ_BENCHMARK=y
# CONFIG_PACKING is not set
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_CORDIC=m
# CONFIG_PRIME_NUMBERS is not set
CONFIG_RATIONAL=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_ARCH_USE_SYM_ANNOTATIONS=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC64 is not set
# CONFIG_CRC4 is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_XXHASH=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMPRESS=m
CONFIG_ZSTD_DECOMPRESS=m
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_INTERVAL_TREE=y
CONFIG_XARRAY_MULTI=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_ARCH_HAS_FORCE_DMA_UNENCRYPTED=y
CONFIG_DMA_VIRT_OPS=y
CONFIG_SWIOTLB=y
CONFIG_DMA_COHERENT_POOL=y
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=200
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
# CONFIG_DMA_API_DEBUG is not set
CONFIG_SGL_ALLOC=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_DIMLIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_HAVE_GENERIC_VDSO=y
CONFIG_GENERIC_GETTIMEOFDAY=y
CONFIG_GENERIC_VDSO_TIME_NS=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_MEMREGION=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_UACCESS_MCSAFE=y
CONFIG_ARCH_STACKWALK=y
CONFIG_SBITMAP=y
# CONFIG_STRING_SELFTEST is not set
# end of Library routines

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
# CONFIG_PRINTK_CALLER is not set
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DYNAMIC_DEBUG_CORE=y
CONFIG_SYMBOLIC_ERRNAME=y
CONFIG_DEBUG_BUGVERBOSE=y
# end of printk and dmesg options

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_REDUCED=y
# CONFIG_DEBUG_INFO_COMPRESSED is not set
# CONFIG_DEBUG_INFO_SPLIT is not set
CONFIG_DEBUG_INFO_DWARF4=y
# CONFIG_GDB_SCRIPTS is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_HEADERS_INSTALL is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_STACK_VALIDATION=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# end of Compile-time checks and compiler options

#
# Generic Kernel Debugging Instruments
#
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_MAGIC_SYSRQ_SERIAL_SEQUENCE=""
CONFIG_DEBUG_FS=y
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
# CONFIG_UBSAN is not set
# end of Generic Kernel Debugging Instruments

CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_MISC=y

#
# Memory Debugging
#
# CONFIG_PAGE_EXTENSION is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_PAGE_OWNER is not set
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_PAGE_REF is not set
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_ARCH_HAS_DEBUG_WX=y
# CONFIG_DEBUG_WX is not set
CONFIG_GENERIC_PTDUMP=y
# CONFIG_PTDUMP_DEBUGFS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_SCHED_STACK_END_CHECK is not set
CONFIG_ARCH_HAS_DEBUG_VM_PGTABLE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VM_PGTABLE is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
# CONFIG_KASAN is not set
CONFIG_KASAN_STACK=1
# end of Memory Debugging

CONFIG_DEBUG_SHIRQ=y

#
# Debug Oops, Lockups and Hangs
#
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_WQ_WATCHDOG is not set
# CONFIG_TEST_LOCKUP is not set
# end of Debug Oops, Lockups and Hangs

#
# Scheduler Debugging
#
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# end of Scheduler Debugging

# CONFIG_DEBUG_TIMEKEEPING is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_RWSEMS is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=m
# CONFIG_WW_MUTEX_SELFTEST is not set
# end of Lock Debugging (spinlocks, mutexes, etc...)

CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set

#
# Debug kernel data structures
#
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PLIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_BUG_ON_DATA_CORRUPTION=y
# end of Debug kernel data structures

# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_TORTURE_TEST=m
CONFIG_RCU_PERF_TEST=m
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_BOOTTIME_TRACING is not set
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_STACK_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_HWLAT_TRACER=y
# CONFIG_MMIOTRACE is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENTS=y
# CONFIG_KPROBE_EVENTS_ON_NOTRACE is not set
CONFIG_UPROBE_EVENTS=y
CONFIG_BPF_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
# CONFIG_BPF_KPROBE_OVERRIDE is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_TRACING_MAP=y
CONFIG_SYNTH_EVENTS=y
CONFIG_HIST_TRIGGERS=y
# CONFIG_TRACE_EVENT_INJECT is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_TRACE_EVAL_MAP_FILE is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set
# CONFIG_SYNTH_EVENT_GEN_TEST is not set
# CONFIG_KPROBE_EVENT_GEN_TEST is not set
# CONFIG_HIST_TRIGGERS_DEBUG is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KCSAN=y
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set

#
# x86 Debugging
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_USB_XDBC=y
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_FPU is not set
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set
# end of x86 Debugging

#
# Kernel Testing and Coverage
#
CONFIG_KUNIT=y
# CONFIG_KUNIT_DEBUGFS is not set
CONFIG_KUNIT_TEST=m
CONFIG_KUNIT_EXAMPLE_TEST=m
# CONFIG_KUNIT_ALL_TESTS is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_FUTEX is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAIL_FUNCTION is not set
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_KCOV is not set
CONFIG_RUNTIME_TESTING_MENU=y
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_TEST_MIN_HEAP is not set
# CONFIG_TEST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_REED_SOLOMON_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_STRSCPY is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_TEST_PRINTF is not set
# CONFIG_TEST_BITMAP is not set
# CONFIG_TEST_BITFIELD is not set
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_XARRAY is not set
# CONFIG_TEST_OVERFLOW is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_HASH is not set
# CONFIG_TEST_IDA is not set
# CONFIG_TEST_LKM is not set
# CONFIG_TEST_BITOPS is not set
# CONFIG_TEST_VMALLOC is not set
# CONFIG_TEST_USER_COPY is not set
CONFIG_TEST_BPF=m
# CONFIG_TEST_BLACKHOLE_DEV is not set
# CONFIG_FIND_BIT_BENCHMARK is not set
# CONFIG_TEST_FIRMWARE is not set
# CONFIG_TEST_SYSCTL is not set
CONFIG_SYSCTL_KUNIT_TEST=m
CONFIG_LIST_KUNIT_TEST=m
# CONFIG_LINEAR_RANGES_TEST is not set
# CONFIG_TEST_UDELAY is not set
# CONFIG_TEST_STATIC_KEYS is not set
# CONFIG_TEST_KMOD is not set
# CONFIG_TEST_MEMCAT_P is not set
# CONFIG_TEST_LIVEPATCH is not set
# CONFIG_TEST_STACKINIT is not set
# CONFIG_TEST_MEMINIT is not set
# CONFIG_TEST_HMM is not set
# CONFIG_MEMTEST is not set
# CONFIG_HYPERV_TESTING is not set
# end of Kernel Testing and Coverage
# end of Kernel hacking

--VSaCG/zfRnOiPJtU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=job-script

#!/bin/sh

export_top_env()
{
	export suite='fsmark'
	export testcase='fsmark'
	export category='benchmark'
	export iterations=1
	export nr_threads=1
	export need_memory='48G'
	export job_origin='/lkp-src/allot/cyclic:p1:linux-devel:devel-hourly/lkp-cpx-4s1/fsmark-stress-journal-1brd.yaml'
	export queue_cmdline_keys='branch
commit
queue_at_least_once'
	export queue='validate'
	export testbox='lkp-cpx-4s1'
	export tbox_group='lkp-cpx-4s1'
	export kconfig='x86_64-rhel-8.3'
	export submit_id='5f208f64b36a104e2cbcc502'
	export job_file='/lkp/jobs/scheduled/lkp-cpx-4s1/fsmark-performance-1BRD_32G-4K-btrfs-1x-1fpd-1t-fsyncBeforeClose-4G-ucode=0x86000017-debian-10.4-x86_64-20200603.cgz-54529aac984-20200729-20012-hl1syq-3.yaml'
	export id='b2093b1f9bbfdfa04ad88ce92871767bf91b8a4c'
	export queuer_version='/lkp-src'
	export model='Cooper Lake'
	export nr_node=4
	export nr_cpu=192
	export memory='128G'
	export nr_hdd_partitions=
	export nr_ssd_partitions=2
	export hdd_partitions=
	export ssd_partitions='/dev/disk/by-id/nvme-INTEL_SSDPE2KX040T7_PHLF741401H84P0IGN-part4
/dev/disk/by-id/nvme-INTEL_SSDPE2KX040T7_PHLF741401H84P0IGN-part5'
	export swap_partitions=
	export rootfs_partition='/dev/disk/by-id/nvme-INTEL_SSDPE2KX040T7_PHLF741401H84P0IGN-part3'
	export kernel_cmdline_hw='acpi_rsdp=0x693fd014'
	export brand=
	export need_kconfig='CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV=y
CONFIG_BLOCK=y
CONFIG_NFSD
CONFIG_BTRFS_FS'
	export timeout='1h'
	export commit='54529aac984de8d3928810c85b575efac0f9d616'
	export need_kconfig_hw='CONFIG_IGB=y
CONFIG_SATA_AHCI'
	export ucode='0x86000017'
	export enqueue_time='2020-07-29 04:49:41 +0800'
	export _id='5f208f68b36a104e2cbcc503'
	export _rt='/result/fsmark/performance-1BRD_32G-4K-btrfs-1x-1fpd-1t-fsyncBeforeClose-4G-ucode=0x86000017/lkp-cpx-4s1/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3/gcc-9/54529aac984de8d3928810c85b575efac0f9d616'
	export user='lkp'
	export compiler='gcc-9'
	export head_commit='94d09c8f2d7ebdc4ebe6ccd972e2f5153c355b9e'
	export base_commit='92ed301919932f777713b9172e525674157e983d'
	export branch='linux-review/Christoph-Hellwig/fs-remove-the-unused-SB_I_MULTIROOT-flag/20200727-000342'
	export rootfs='debian-10.4-x86_64-20200603.cgz'
	export result_root='/result/fsmark/performance-1BRD_32G-4K-btrfs-1x-1fpd-1t-fsyncBeforeClose-4G-ucode=0x86000017/lkp-cpx-4s1/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3/gcc-9/54529aac984de8d3928810c85b575efac0f9d616/3'
	export scheduler_version='/lkp/lkp/.src-20200728-224826'
	export LKP_SERVER='inn'
	export arch='x86_64'
	export max_uptime=3600
	export initrd='/osimage/debian/debian-10.4-x86_64-20200603.cgz'
	export bootloader_append='root=/dev/ram0
user=lkp
job=/lkp/jobs/scheduled/lkp-cpx-4s1/fsmark-performance-1BRD_32G-4K-btrfs-1x-1fpd-1t-fsyncBeforeClose-4G-ucode=0x86000017-debian-10.4-x86_64-20200603.cgz-54529aac984-20200729-20012-hl1syq-3.yaml
ARCH=x86_64
kconfig=x86_64-rhel-8.3
branch=linux-review/Christoph-Hellwig/fs-remove-the-unused-SB_I_MULTIROOT-flag/20200727-000342
commit=54529aac984de8d3928810c85b575efac0f9d616
BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3/gcc-9/54529aac984de8d3928810c85b575efac0f9d616/vmlinuz-5.8.0-rc6-00354-g54529aac984de
acpi_rsdp=0x693fd014
max_uptime=3600
RESULT_ROOT=/result/fsmark/performance-1BRD_32G-4K-btrfs-1x-1fpd-1t-fsyncBeforeClose-4G-ucode=0x86000017/lkp-cpx-4s1/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3/gcc-9/54529aac984de8d3928810c85b575efac0f9d616/3
LKP_SERVER=inn
nokaslr
selinux=0
debug
apic=debug
sysrq_always_enabled
rcupdate.rcu_cpu_stall_timeout=100
net.ifnames=0
printk.devkmsg=on
panic=-1
softlockup_panic=1
nmi_watchdog=panic
oops=panic
load_ramdisk=2
prompt_ramdisk=0
drbd.minor_count=8
systemd.log_level=err
ignore_loglevel
console=tty0
earlyprintk=ttyS0,115200
console=ttyS0,115200
vga=normal
rw'
	export modules_initrd='/pkg/linux/x86_64-rhel-8.3/gcc-9/54529aac984de8d3928810c85b575efac0f9d616/modules.cgz'
	export bm_initrd='/osimage/deps/debian-10.4-x86_64-20200603.cgz/run-ipconfig_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/lkp_20200709.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/rsync-rootfs_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/perf_20200723.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/perf-x86_64-d15be546031c-1_20200723.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/fs_20200714.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/fs2_20200714.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/fsmark-x86_64-3.3-1_20200619.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/mpstat_20200714.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/sar-x86_64-34c92ae-1_20200702.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/hw_20200715.cgz'
	export ucode_initrd='/osimage/ucode/intel-ucode-20200610.cgz'
	export lkp_initrd='/osimage/user/lkp/lkp-x86_64.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export last_kernel='5.8.0-rc7-06730-g94d09c8f2d7eb'
	export repeat_to=4
	export schedule_notify_address=
	export queue_at_least_once=1
	export kernel='/pkg/linux/x86_64-rhel-8.3/gcc-9/54529aac984de8d3928810c85b575efac0f9d616/vmlinuz-5.8.0-rc6-00354-g54529aac984de'
	export dequeue_time='2020-07-29 04:57:57 +0800'
	export job_initrd='/lkp/jobs/scheduled/lkp-cpx-4s1/fsmark-performance-1BRD_32G-4K-btrfs-1x-1fpd-1t-fsyncBeforeClose-4G-ucode=0x86000017-debian-10.4-x86_64-20200603.cgz-54529aac984-20200729-20012-hl1syq-3.cgz'

	[ -n "$LKP_SRC" ] ||
	export LKP_SRC=/lkp/${user:-lkp}/src
}

run_job()
{
	echo $$ > $TMP/run-job.pid

	. $LKP_SRC/lib/http.sh
	. $LKP_SRC/lib/job.sh
	. $LKP_SRC/lib/env.sh

	export_top_env

	run_setup nr_brd=1 ramdisk_size=34359738368 $LKP_SRC/setup/disk

	run_setup fs='btrfs' $LKP_SRC/setup/fs

	run_setup $LKP_SRC/setup/cpufreq_governor 'performance'

	run_monitor delay=10 $LKP_SRC/monitors/no-stdout/wrapper perf-profile
	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/no-stdout/wrapper boot-time
	run_monitor $LKP_SRC/monitors/wrapper iostat
	run_monitor $LKP_SRC/monitors/wrapper heartbeat
	run_monitor $LKP_SRC/monitors/wrapper vmstat
	run_monitor $LKP_SRC/monitors/wrapper numa-numastat
	run_monitor $LKP_SRC/monitors/wrapper numa-vmstat
	run_monitor $LKP_SRC/monitors/wrapper numa-meminfo
	run_monitor $LKP_SRC/monitors/wrapper proc-vmstat
	run_monitor $LKP_SRC/monitors/wrapper proc-stat
	run_monitor $LKP_SRC/monitors/wrapper meminfo
	run_monitor $LKP_SRC/monitors/wrapper slabinfo
	run_monitor $LKP_SRC/monitors/wrapper interrupts
	run_monitor $LKP_SRC/monitors/wrapper lock_stat
	run_monitor $LKP_SRC/monitors/wrapper latency_stats
	run_monitor $LKP_SRC/monitors/wrapper softirqs
	run_monitor $LKP_SRC/monitors/one-shot/wrapper bdi_dev_mapping
	run_monitor $LKP_SRC/monitors/wrapper diskstats
	run_monitor $LKP_SRC/monitors/wrapper nfsstat
	run_monitor $LKP_SRC/monitors/wrapper cpuidle
	run_monitor $LKP_SRC/monitors/wrapper cpufreq-stats
	run_monitor $LKP_SRC/monitors/wrapper sched_debug
	run_monitor $LKP_SRC/monitors/wrapper perf-stat
	run_monitor $LKP_SRC/monitors/wrapper mpstat
	run_monitor $LKP_SRC/monitors/wrapper oom-killer
	run_monitor $LKP_SRC/monitors/plain/watchdog

	run_test filesize='4K' test_size='4G' sync_method='fsyncBeforeClose' nr_files_per_directory='1fpd' $LKP_SRC/tests/wrapper fsmark
}

extract_stats()
{
	export stats_part_begin=
	export stats_part_end=

	$LKP_SRC/stats/wrapper perf-profile
	$LKP_SRC/stats/wrapper fsmark
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper boot-time
	$LKP_SRC/stats/wrapper iostat
	$LKP_SRC/stats/wrapper vmstat
	$LKP_SRC/stats/wrapper numa-numastat
	$LKP_SRC/stats/wrapper numa-vmstat
	$LKP_SRC/stats/wrapper numa-meminfo
	$LKP_SRC/stats/wrapper proc-vmstat
	$LKP_SRC/stats/wrapper meminfo
	$LKP_SRC/stats/wrapper slabinfo
	$LKP_SRC/stats/wrapper interrupts
	$LKP_SRC/stats/wrapper lock_stat
	$LKP_SRC/stats/wrapper latency_stats
	$LKP_SRC/stats/wrapper softirqs
	$LKP_SRC/stats/wrapper diskstats
	$LKP_SRC/stats/wrapper nfsstat
	$LKP_SRC/stats/wrapper cpuidle
	$LKP_SRC/stats/wrapper sched_debug
	$LKP_SRC/stats/wrapper perf-stat
	$LKP_SRC/stats/wrapper mpstat

	$LKP_SRC/stats/wrapper time fsmark.time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper last_state
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper time
}

"$@"

--VSaCG/zfRnOiPJtU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---

#! jobs/fsmark-stress-journal-1brd.yaml
suite: fsmark
testcase: fsmark
category: benchmark
perf-profile:
  delay: 10
iterations: 1x
nr_threads: 1t
disk: 1BRD_32G
need_memory: 48G
fs: btrfs
fs2: 
fsmark:
  filesize: 4K
  test_size: 4G
  sync_method: fsyncBeforeClose
  nr_files_per_directory: 1fpd
job_origin: "/lkp-src/allot/cyclic:p1:linux-devel:devel-hourly/lkp-cpx-4s1/fsmark-stress-journal-1brd.yaml"

#! queue options
queue_cmdline_keys:
- branch
- commit
- queue_at_least_once
queue: bisect
testbox: lkp-cpx-4s1
tbox_group: lkp-cpx-4s1
kconfig: x86_64-rhel-8.3
submit_id: 5f207e21b36a104c0da2a983
job_file: "/lkp/jobs/scheduled/lkp-cpx-4s1/fsmark-performance-1BRD_32G-4K-btrfs-1x-1fpd-1t-fsyncBeforeClose-4G-ucode=0x86000017-debian-10.4-x86_64-20200603.cgz-54529aac984-20200729-19469-cd51if-1.yaml"
id: cd3df248f9fd01a9f954a9df8738313a625459e2
queuer_version: "/lkp-src"

#! hosts/lkp-cpx-4s1
model: Cooper Lake
nr_node: 4
nr_cpu: 192
memory: 128G
nr_hdd_partitions: 
nr_ssd_partitions: 2
hdd_partitions: 
ssd_partitions:
- "/dev/disk/by-id/nvme-INTEL_SSDPE2KX040T7_PHLF741401H84P0IGN-part4"
- "/dev/disk/by-id/nvme-INTEL_SSDPE2KX040T7_PHLF741401H84P0IGN-part5"
swap_partitions: 
rootfs_partition: "/dev/disk/by-id/nvme-INTEL_SSDPE2KX040T7_PHLF741401H84P0IGN-part3"
kernel_cmdline_hw: acpi_rsdp=0x693fd014
brand: 

#! include/category/benchmark
kmsg: 
boot-time: 
iostat: 
heartbeat: 
vmstat: 
numa-numastat: 
numa-vmstat: 
numa-meminfo: 
proc-vmstat: 
proc-stat: 
meminfo: 
slabinfo: 
interrupts: 
lock_stat: 
latency_stats: 
softirqs: 
bdi_dev_mapping: 
diskstats: 
nfsstat: 
cpuidle: 
cpufreq-stats: 
sched_debug: 
perf-stat: 
mpstat: 

#! include/category/ALL
cpufreq_governor: performance

#! include/disk/nr_brd
need_kconfig:
- CONFIG_BLK_DEV_RAM=m
- CONFIG_BLK_DEV=y
- CONFIG_BLOCK=y
- CONFIG_NFSD
- CONFIG_BTRFS_FS

#! include/fsmark
timeout: 1h

#! include/queue/cyclic
commit: 54529aac984de8d3928810c85b575efac0f9d616

#! include/testbox/lkp-cpx-4s1
need_kconfig_hw:
- CONFIG_IGB=y
- CONFIG_SATA_AHCI
ucode: '0x86000017'

#! include/fs/OTHERS
enqueue_time: 2020-07-29 03:36:02.100926125 +08:00
_id: 5f2082deb36a104c0da2a984
_rt: "/result/fsmark/performance-1BRD_32G-4K-btrfs-1x-1fpd-1t-fsyncBeforeClose-4G-ucode=0x86000017/lkp-cpx-4s1/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3/gcc-9/54529aac984de8d3928810c85b575efac0f9d616"

#! schedule options
user: lkp
compiler: gcc-9
head_commit: 94d09c8f2d7ebdc4ebe6ccd972e2f5153c355b9e
base_commit: 92ed301919932f777713b9172e525674157e983d
branch: linux-devel/devel-hourly-2020072723
rootfs: debian-10.4-x86_64-20200603.cgz
result_root: "/result/fsmark/performance-1BRD_32G-4K-btrfs-1x-1fpd-1t-fsyncBeforeClose-4G-ucode=0x86000017/lkp-cpx-4s1/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3/gcc-9/54529aac984de8d3928810c85b575efac0f9d616/0"
scheduler_version: "/lkp/lkp/.src-20200728-224826"
LKP_SERVER: inn
arch: x86_64
max_uptime: 3600
initrd: "/osimage/debian/debian-10.4-x86_64-20200603.cgz"
bootloader_append:
- root=/dev/ram0
- user=lkp
- job=/lkp/jobs/scheduled/lkp-cpx-4s1/fsmark-performance-1BRD_32G-4K-btrfs-1x-1fpd-1t-fsyncBeforeClose-4G-ucode=0x86000017-debian-10.4-x86_64-20200603.cgz-54529aac984-20200729-19469-cd51if-1.yaml
- ARCH=x86_64
- kconfig=x86_64-rhel-8.3
- branch=linux-devel/devel-hourly-2020072723
- commit=54529aac984de8d3928810c85b575efac0f9d616
- BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3/gcc-9/54529aac984de8d3928810c85b575efac0f9d616/vmlinuz-5.8.0-rc6-00354-g54529aac984de
- acpi_rsdp=0x693fd014
- max_uptime=3600
- RESULT_ROOT=/result/fsmark/performance-1BRD_32G-4K-btrfs-1x-1fpd-1t-fsyncBeforeClose-4G-ucode=0x86000017/lkp-cpx-4s1/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3/gcc-9/54529aac984de8d3928810c85b575efac0f9d616/0
- LKP_SERVER=inn
- nokaslr
- selinux=0
- debug
- apic=debug
- sysrq_always_enabled
- rcupdate.rcu_cpu_stall_timeout=100
- net.ifnames=0
- printk.devkmsg=on
- panic=-1
- softlockup_panic=1
- nmi_watchdog=panic
- oops=panic
- load_ramdisk=2
- prompt_ramdisk=0
- drbd.minor_count=8
- systemd.log_level=err
- ignore_loglevel
- console=tty0
- earlyprintk=ttyS0,115200
- console=ttyS0,115200
- vga=normal
- rw
modules_initrd: "/pkg/linux/x86_64-rhel-8.3/gcc-9/54529aac984de8d3928810c85b575efac0f9d616/modules.cgz"
bm_initrd: "/osimage/deps/debian-10.4-x86_64-20200603.cgz/run-ipconfig_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/lkp_20200709.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/rsync-rootfs_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/perf_20200723.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/perf-x86_64-d15be546031c-1_20200723.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/fs_20200714.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/fs2_20200714.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/fsmark-x86_64-3.3-1_20200619.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/mpstat_20200714.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/sar-x86_64-34c92ae-1_20200702.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/hw_20200715.cgz"
ucode_initrd: "/osimage/ucode/intel-ucode-20200610.cgz"
lkp_initrd: "/osimage/user/lkp/lkp-x86_64.cgz"
site: inn

#! /lkp/lkp/.src-20200727-173812/include/site/inn
LKP_CGI_PORT: 80
LKP_CIFS_PORT: 139
oom-killer: 
watchdog: 

#! runtime status
last_kernel: 5.8.0-rc6-00308-gba47d845d715a
repeat_to: 2
schedule_notify_address: 

#! user overrides
queue_at_least_once: 0
kernel: "/pkg/linux/x86_64-rhel-8.3/gcc-9/54529aac984de8d3928810c85b575efac0f9d616/vmlinuz-5.8.0-rc6-00354-g54529aac984de"
dequeue_time: 2020-07-29 03:59:54.681912402 +08:00

#! /lkp/lkp/.src-20200728-224826/include/site/inn
job_state: finished
loadavg: 1.05 0.78 0.35 1/1402 9319
start_time: '1595966454'
end_time: '1595966640'
version: "/lkp/lkp/.src-20200728-224909:f7a8999f:7646003e2-dirty"

--VSaCG/zfRnOiPJtU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

 "modprobe" "-r" "brd"
 "modprobe" "brd" "rd_nr=1" "rd_size=33554432"
dmsetup remove_all
wipefs -a --force /dev/ram0
mkfs -t btrfs /dev/ram0
mkdir -p /fs/ram0
mount -t btrfs /dev/ram0 /fs/ram0

for cpu_dir in /sys/devices/system/cpu/cpu[0-9]*
do
	online_file="$cpu_dir"/online
	[ -f "$online_file" ] && [ "$(cat "$online_file")" -eq 0 ] && continue

	file="$cpu_dir"/cpufreq/scaling_governor
	[ -f "$file" ] && echo "performance" > "$file"
done

 "fs_mark" "-d" "/fs/ram0/1" "-D" "1000000" "-N" "1" "-n" "1000000" "-L" "1" "-S" "1" "-s" "4096"

--VSaCG/zfRnOiPJtU--

From: kernel test robot <oliver.sang@intel.com>
Subject: [memcg]  cda0d20525:  reaim.jobs_per_min -10.1% regression
Date: Mon, 26 Jul 2021 10:24:21 +0800
Message-ID: <20210726022421.GB21872@xsang-OptiPlex-9020>
References: <20210716212137.1391164-2-shakeelb@google.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="XF85m9dhOBO43t/C"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20210716212137.1391164-2-shakeelb@google.com>
List-ID: <cgroups.vger.kernel.org>
To: Shakeel Butt <shakeelb@google.com>
Cc: 0day robot <lkp@intel.com>, LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org, ying.huang@intel.com, feng.tang@intel.com, zhengjun.xing@linux.intel.com, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <songmuchun@bytedance.com>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <guro@fb.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Hillf Danton <hdanton@sina.com>, Yang Yingliang <yangyingliang@huawei.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>


--XF85m9dhOBO43t/C
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



Greeting,

FYI, we noticed a -10.1% regression of reaim.jobs_per_min due to commit:


commit: cda0d205259a7e7c1f8e296130ac091557134a66 ("[PATCH v5 2/2] memcg: in=
frastructure to flush memcg stats")
url: https://github.com/0day-ci/linux/commits/Shakeel-Butt/memcg-switch-lru=
vec-stats-to-rstat/20210718-103230
base: https://git.kernel.org/cgit/linux/kernel/git/tj/cgroup.git for-next

in testcase: reaim
on test machine: 16 threads 1 sockets Intel(R) Xeon(R) E-2278G CPU @ 3.40GH=
z with 32G memory
with following parameters:

	runtime: 300s
	nr_task: 100%
	test: new_dbase
	cpufreq_governor: performance
	ucode: 0xde

test-description: REAIM is an updated and improved version of AIM 7 benchma=
rk.
test-url: https://sourceforge.net/projects/re-aim-7/

In addition to that, the commit also has significant impact on the followin=
g tests:

+------------------+-------------------------------------------------------=
------------------------------+
| testcase: change | reaim: reaim.jobs_per_min -9.5% regression            =
                              |
| test machine     | 16 threads 1 sockets Intel(R) Xeon(R) E-2278G CPU @ 3.=
40GHz with 32G memory         |
| test parameters  | cpufreq_governor=3Dperformance                        =
                                |
|                  | nr_task=3D100%                                        =
                                |
|                  | runtime=3D300s                                        =
                                |
|                  | test=3Dnew_fserver                                    =
                                |
|                  | ucode=3D0xde                                          =
                                |
+------------------+-------------------------------------------------------=
------------------------------+
| testcase: change | fsmark: fsmark.files_per_sec -6.9% regression         =
                              |
| test machine     | 192 threads 4 sockets Intel(R) Xeon(R) Platinum 9242 C=
PU @ 2.30GHz with 192G memory |
| test parameters  | cpufreq_governor=3Dperformance                        =
                                |
|                  | disk=3D1BRD_48G                                       =
                                |
|                  | filesize=3D4M                                         =
                                |
|                  | fs=3Dbtrfs                                            =
                                |
|                  | iterations=3D1x                                       =
                                |
|                  | nr_threads=3D1t                                       =
                                |
|                  | sync_method=3DfsyncBeforeClose                        =
                                |
|                  | test_size=3D24G                                       =
                                |
|                  | ucode=3D0x5003006                                     =
                                |
+------------------+-------------------------------------------------------=
------------------------------+
| testcase: change | reaim: reaim.jobs_per_min -10.7% regression           =
                              |
| test machine     | 16 threads 1 sockets Intel(R) Xeon(R) E-2278G CPU @ 3.=
40GHz with 32G memory         |
| test parameters  | cpufreq_governor=3Dperformance                        =
                                |
|                  | nr_task=3D100%                                        =
                                |
|                  | runtime=3D300s                                        =
                                |
|                  | test=3Dfive_sec                                       =
                                |
|                  | ucode=3D0xde                                          =
                                |
+------------------+-------------------------------------------------------=
------------------------------+


If you fix the issue, kindly add following tag
Reported-by: kernel test robot <oliver.sang@intel.com>


Details are as below:
---------------------------------------------------------------------------=
----------------------->


To reproduce:

        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        bin/lkp install                job.yaml  # job file is attached in =
this email
        bin/lkp split-job --compatible job.yaml  # generate the yaml file f=
or lkp run
        bin/lkp run                    generated-yaml-file

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
compiler/cpufreq_governor/kconfig/nr_task/rootfs/runtime/tbox_group/test/te=
stcase/ucode:
  gcc-9/performance/x86_64-rhel-8.3/100%/debian-10.4-x86_64-20200603.cgz/30=
0s/lkp-cfl-e1/new_dbase/reaim/0xde

commit:=20
  0c7c5da68b ("memcg: switch lruvec stats to rstat")
  cda0d20525 ("memcg: infrastructure to flush memcg stats")

0c7c5da68b4a09ff cda0d205259a7e7c1f8e296130a=20
---------------- ---------------------------=20
         %stddev     %change         %stddev
             \          |                \ =20
      5.09            +5.8%       5.39        reaim.child_systime
      5.44            -1.3%       5.37        reaim.child_utime
    136122           -10.1%     122315        reaim.jobs_per_min
      8507           -10.1%       7644        reaim.jobs_per_min_child
    140593            -9.5%     127245        reaim.max_jobs_per_min
      0.73           +11.3%       0.81        reaim.parent_time
      1.68           +54.9%       2.61 =B1  2%  reaim.std_dev_percent
      0.01           +82.8%       0.02        reaim.std_dev_time
     62961         +1456.4%     979901        reaim.time.involuntary_contex=
t_switches
     15091            -4.8%      14367        reaim.time.major_page_faults
  30304357            -3.1%   29368128        reaim.time.minor_page_faults
    557.91            +2.5%     571.83        reaim.time.system_time
    589.92            -4.3%     564.56        reaim.time.user_time
    194873            +2.7%     200206        reaim.time.voluntary_context_=
switches
    173333            -3.1%     168000        reaim.workload
   4225548 =B1  3%     +58.6%    6703765 =B1 25%  cpuidle..usage
     12.09            +1.7       13.74        mpstat.cpu.all.sys%
      2487          +700.9%      19922        vmstat.system.cs
     21607           +28.8%      27835 =B1 17%  vmstat.system.in
     36.54            +4.2%      38.08        boot-time.boot
     11.56            +2.9%      11.90 =B1  3%  boot-time.dhcp
    487.32            +4.7%     510.04        boot-time.idle
     20013          +143.0%      48643 =B1  3%  meminfo.Active
     19783          +145.2%      48504 =B1  3%  meminfo.Active(anon)
     28739          +105.6%      59076 =B1  2%  meminfo.Shmem
      1875 =B1  6%     -10.3%       1683 =B1  3%  slabinfo.kmalloc-rcl-256.=
active_objs
      1916 =B1  4%      -9.5%       1734 =B1  2%  slabinfo.kmalloc-rcl-256.=
num_objs
      1089 =B1  4%     -13.1%     946.14 =B1  5%  slabinfo.pid.active_objs
      1089 =B1  4%     -13.1%     946.14 =B1  5%  slabinfo.pid.num_objs
      1127 =B1  5%      -7.9%       1038 =B1  2%  slabinfo.task_delay_info.=
active_objs
      1127 =B1  5%      -7.9%       1038 =B1  2%  slabinfo.task_delay_info.=
num_objs
     32528 =B1 74%   +4337.7%    1443515 =B1 17%  turbostat.C1
      0.02 =B1 44%      +1.0        1.02 =B1 41%  turbostat.C1%
    358034 =B1 38%    +272.8%    1334615 =B1 90%  turbostat.C1E
      0.06 =B1 54%    +694.8%       0.44 =B1 98%  turbostat.CPU%c3
     35.84            +7.3%      38.46        turbostat.CorWatt
   6582740           +28.6%    8467818 =B1 17%  turbostat.IRQ
     11.71 =B1  4%     -11.2%      10.40 =B1  8%  turbostat.Pkg%pc2
     36.27            +7.2%      38.90        turbostat.PkgWatt
      4948          +145.1%      12127 =B1  3%  proc-vmstat.nr_active_anon
    595570            +1.2%     602681        proc-vmstat.nr_file_pages
      7890            +5.5%       8324        proc-vmstat.nr_mapped
      7184          +105.7%      14775 =B1  2%  proc-vmstat.nr_shmem
      4948          +145.1%      12127 =B1  3%  proc-vmstat.nr_zone_active_=
anon
  29299018            -3.0%   28427445        proc-vmstat.numa_hit
  29299018            -3.0%   28427445        proc-vmstat.numa_local
     58688           +30.2%      76398        proc-vmstat.pgactivate
  29590587            -3.0%   28698285        proc-vmstat.pgalloc_normal
  30793164            -3.0%   29863963        proc-vmstat.pgfault
  29571246            -3.1%   28659712        proc-vmstat.pgfree
   1958161            -3.2%    1896449        proc-vmstat.pgreuse
     34.22            -2.6%      33.34        perf-stat.i.MPKI
  4.04e+09            +6.6%  4.306e+09        perf-stat.i.branch-instructio=
ns
      1.34            -0.0        1.30        perf-stat.i.branch-miss-rate%
  31862409            +8.4%   34539247        perf-stat.i.branch-misses
      1.39 =B1  4%      -0.1        1.27        perf-stat.i.cache-miss-rate%
 6.763e+08            +4.6%  7.073e+08        perf-stat.i.cache-references
      2474          +707.5%      19982        perf-stat.i.context-switches
      1.19            -2.4%       1.16        perf-stat.i.cpi
 1.794e+10            +5.8%  1.897e+10        perf-stat.i.cpu-cycles
    312.57           +85.3%     579.14        perf-stat.i.cpu-migrations
      3386 =B1  3%      +8.3%       3665        perf-stat.i.cycles-between-=
cache-misses
      0.07            -0.0        0.06 =B1  2%  perf-stat.i.dTLB-load-miss-=
rate%
 3.903e+09            +9.1%  4.257e+09        perf-stat.i.dTLB-loads
      0.02            -0.0        0.02        perf-stat.i.dTLB-store-miss-r=
ate%
    467914            -2.7%     455349        perf-stat.i.dTLB-store-misses
 2.337e+09            +5.4%  2.463e+09        perf-stat.i.dTLB-stores
     69.23            -3.8       65.41 =B1  4%  perf-stat.i.iTLB-load-miss-=
rate%
    641802            +6.6%     683980 =B1  4%  perf-stat.i.iTLB-load-misses
    344005           +26.1%     433937 =B1  8%  perf-stat.i.iTLB-loads
 1.964e+10            +5.5%  2.073e+10        perf-stat.i.instructions
      0.92            +1.3%       0.93        perf-stat.i.ipc
     50.15            -4.7%      47.78        perf-stat.i.major-faults
      1.12            +5.7%       1.19        perf-stat.i.metric.GHz
    154.74            +2.7%     158.85        perf-stat.i.metric.K/sec
    684.89            +7.1%     733.44        perf-stat.i.metric.M/sec
    101097            -2.9%      98143        perf-stat.i.minor-faults
   1266584            -1.7%    1245496        perf-stat.i.node-stores
    101148            -2.9%      98191        perf-stat.i.page-faults
      0.79            +0.0        0.80        perf-stat.overall.branch-miss=
-rate%
      0.68 =B1  2%      -0.0        0.64        perf-stat.overall.cache-mis=
s-rate%
      3905 =B1  2%      +6.8%       4172        perf-stat.overall.cycles-be=
tween-cache-misses
      0.02            -0.0        0.01 =B1  4%  perf-stat.overall.dTLB-load=
-miss-rate%
      0.02            -0.0        0.02        perf-stat.overall.dTLB-store-=
miss-rate%
     65.10            -3.9       61.22        perf-stat.overall.iTLB-load-m=
iss-rate%
  34168578            +8.8%   37185877        perf-stat.overall.path-length
 4.028e+09            +6.6%  4.293e+09        perf-stat.ps.branch-instructi=
ons
  31761900            +8.4%   34426923        perf-stat.ps.branch-misses
 6.742e+08            +4.6%   7.05e+08        perf-stat.ps.cache-references
      2467          +707.3%      19922        perf-stat.ps.context-switches
 1.789e+10            +5.7%  1.891e+10        perf-stat.ps.cpu-cycles
    311.76           +85.2%     577.51        perf-stat.ps.cpu-migrations
 3.891e+09            +9.1%  4.244e+09        perf-stat.ps.dTLB-loads
    466586            -2.7%     454015        perf-stat.ps.dTLB-store-misses
  2.33e+09            +5.4%  2.456e+09        perf-stat.ps.dTLB-stores
    639845            +6.6%     681843 =B1  4%  perf-stat.ps.iTLB-load-miss=
es
    343006           +26.1%     432660 =B1  8%  perf-stat.ps.iTLB-loads
 1.958e+10            +5.5%  2.067e+10        perf-stat.ps.instructions
     50.01            -4.7%      47.64        perf-stat.ps.major-faults
    100816            -2.9%      97861        perf-stat.ps.minor-faults
   1262741            -1.7%    1241553        perf-stat.ps.node-stores
    100866            -2.9%      97908        perf-stat.ps.page-faults
 5.923e+12            +5.5%  6.247e+12        perf-stat.total.instructions
     20646 =B1  5%    +638.2%     152404        interrupts.CAL:Function_cal=
l_interrupts
      1553 =B1 65%    +524.0%       9695 =B1  8%  interrupts.CPU0.CAL:Funct=
ion_call_interrupts
      1455 =B1  2%   +3654.2%      54636 =B1  6%  interrupts.CPU0.RES:Resch=
eduling_interrupts
      4.00 =B1 77%   +5085.7%     207.43 =B1 10%  interrupts.CPU0.TLB:TLB_s=
hootdowns
      1429 =B1 33%    +535.0%       9077 =B1  4%  interrupts.CPU1.CAL:Funct=
ion_call_interrupts
      3201 =B1  5%     +23.3%       3948 =B1  2%  interrupts.CPU1.NMI:Non-m=
askable_interrupts
      3201 =B1  5%     +23.3%       3948 =B1  2%  interrupts.CPU1.PMI:Perfo=
rmance_monitoring_interrupts
      1427 =B1  2%   +3468.7%      50931 =B1  6%  interrupts.CPU1.RES:Resch=
eduling_interrupts
      4.67 =B1 52%   +4488.8%     214.14 =B1 10%  interrupts.CPU1.TLB:TLB_s=
hootdowns
    843.83 =B1 53%   +1007.6%       9346 =B1  9%  interrupts.CPU10.CAL:Func=
tion_call_interrupts
      1476 =B1  3%   +3642.0%      55231 =B1  5%  interrupts.CPU10.RES:Resc=
heduling_interrupts
      4.00 =B1 40%   +5232.1%     213.29 =B1  8%  interrupts.CPU10.TLB:TLB_=
shootdowns
      1094 =B1 58%    +744.2%       9242 =B1  7%  interrupts.CPU11.CAL:Func=
tion_call_interrupts
      1452 =B1  3%   +3495.2%      52214 =B1  3%  interrupts.CPU11.RES:Resc=
heduling_interrupts
      5.17 =B1 47%   +3978.3%     210.71 =B1  9%  interrupts.CPU11.TLB:TLB_=
shootdowns
      1155 =B1 68%    +769.0%      10036 =B1 11%  interrupts.CPU12.CAL:Func=
tion_call_interrupts
      1502 =B1  4%   +3506.4%      54174 =B1  8%  interrupts.CPU12.RES:Resc=
heduling_interrupts
      4.00 =B1 57%   +5350.0%     218.00 =B1  9%  interrupts.CPU12.TLB:TLB_=
shootdowns
      1530 =B1 58%    +544.1%       9857 =B1 11%  interrupts.CPU13.CAL:Func=
tion_call_interrupts
      1484 =B1  2%   +3436.4%      52509 =B1  2%  interrupts.CPU13.RES:Resc=
heduling_interrupts
      5.17 =B1 26%   +4069.6%     215.43 =B1  8%  interrupts.CPU13.TLB:TLB_=
shootdowns
      1181 =B1 46%    +808.1%      10732 =B1 10%  interrupts.CPU14.CAL:Func=
tion_call_interrupts
      1454 =B1  3%   +3479.2%      52065 =B1  6%  interrupts.CPU14.RES:Resc=
heduling_interrupts
      4.17 =B1 59%   +5073.7%     215.57 =B1  8%  interrupts.CPU14.TLB:TLB_=
shootdowns
      1553 =B1 91%    +507.4%       9435 =B1  6%  interrupts.CPU15.CAL:Func=
tion_call_interrupts
      1462 =B1  3%   +3482.7%      52385 =B1  5%  interrupts.CPU15.RES:Resc=
heduling_interrupts
      5.00 =B1 25%   +4048.6%     207.43 =B1  5%  interrupts.CPU15.TLB:TLB_=
shootdowns
    907.33 =B1 41%    +891.7%       8997 =B1  6%  interrupts.CPU2.CAL:Funct=
ion_call_interrupts
      1453 =B1  2%   +3546.2%      53003 =B1  8%  interrupts.CPU2.RES:Resch=
eduling_interrupts
      6.83 =B1 39%   +2847.7%     201.43 =B1  7%  interrupts.CPU2.TLB:TLB_s=
hootdowns
    835.50 =B1 26%   +1012.7%       9296 =B1  8%  interrupts.CPU3.CAL:Funct=
ion_call_interrupts
      2370 =B1 35%     +64.6%       3901        interrupts.CPU3.NMI:Non-mas=
kable_interrupts
      2370 =B1 35%     +64.6%       3901        interrupts.CPU3.PMI:Perform=
ance_monitoring_interrupts
      1461 =B1  3%   +3520.2%      52921 =B1  4%  interrupts.CPU3.RES:Resch=
eduling_interrupts
      5.00 =B1 40%   +3997.1%     204.86 =B1  7%  interrupts.CPU3.TLB:TLB_s=
hootdowns
      1083 =B1 59%    +770.8%       9437 =B1  6%  interrupts.CPU4.CAL:Funct=
ion_call_interrupts
      1438 =B1  2%   +3735.7%      55182 =B1  4%  interrupts.CPU4.RES:Resch=
eduling_interrupts
      4.83 =B1 46%   +4191.6%     207.43 =B1  4%  interrupts.CPU4.TLB:TLB_s=
hootdowns
      1532 =B1100%    +510.2%       9350 =B1  4%  interrupts.CPU5.CAL:Funct=
ion_call_interrupts
      1455 =B1  2%   +3475.4%      52052 =B1  7%  interrupts.CPU5.RES:Resch=
eduling_interrupts
      5.17 =B1 36%   +3809.7%     202.00 =B1  6%  interrupts.CPU5.TLB:TLB_s=
hootdowns
    822.17 =B1 34%   +1052.6%       9476 =B1  3%  interrupts.CPU6.CAL:Funct=
ion_call_interrupts
      1398         +3703.0%      53172 =B1  3%  interrupts.CPU6.RES:Resched=
uling_interrupts
      3.50 =B1 48%   +6242.9%     222.00 =B1  8%  interrupts.CPU6.TLB:TLB_s=
hootdowns
      1197 =B1 14%    +710.7%       9706 =B1  4%  interrupts.CPU7.CAL:Funct=
ion_call_interrupts
      1605 =B1  3%   +3303.7%      54657 =B1  6%  interrupts.CPU7.RES:Resch=
eduling_interrupts
      5.17 =B1 46%   +4088.9%     216.43 =B1  3%  interrupts.CPU7.TLB:TLB_s=
hootdowns
      2116 =B1 85%    +354.4%       9617 =B1  6%  interrupts.CPU8.CAL:Funct=
ion_call_interrupts
      1453 =B1  3%   +3569.5%      53318 =B1  8%  interrupts.CPU8.RES:Resch=
eduling_interrupts
      4.67 =B1 44%   +4396.9%     209.86 =B1  9%  interrupts.CPU8.TLB:TLB_s=
hootdowns
      1808 =B1 70%    +403.0%       9098 =B1  4%  interrupts.CPU9.CAL:Funct=
ion_call_interrupts
      1452         +3589.8%      53581 =B1  7%  interrupts.CPU9.RES:Resched=
uling_interrupts
      5.00 =B1 69%   +4020.0%     206.00 =B1  3%  interrupts.CPU9.TLB:TLB_s=
hootdowns
     46658 =B1  7%     +22.5%      57148 =B1  2%  interrupts.NMI:Non-maskab=
le_interrupts
     46658 =B1  7%     +22.5%      57148 =B1  2%  interrupts.PMI:Performanc=
e_monitoring_interrupts
     23433         +3535.9%     852037        interrupts.RES:Rescheduling_i=
nterrupts
     76.33 =B1 10%   +4317.5%       3372        interrupts.TLB:TLB_shootdow=
ns
      0.03 =B1  5%     -13.8%       0.03 =B1  5%  perf-sched.sch_delay.avg.=
ms.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.08 =B1  8%     +65.6%       0.13 =B1 13%  perf-sched.sch_delay.avg.=
ms.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group.do_syscall_64
      0.10 =B1  9%    +104.2%       0.20 =B1  6%  perf-sched.sch_delay.avg.=
ms.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64
      0.03 =B1144%     -86.5%       0.00 =B1 59%  perf-sched.sch_delay.avg.=
ms.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_sysvec_reschedu=
le_ipi.[unknown]
      0.11 =B1 68%     -87.6%       0.01 =B1147%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.__dentry=
_kill.dput
      0.20 =B1 31%     -45.1%       0.11 =B1 19%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.filemap_=
map_pages.do_fault
      0.18 =B1 37%     -87.1%       0.02 =B1 34%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.zap_pte_=
range.unmap_page_range
      0.00 =B1223%   +4738.1%       0.15 =B1 76%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.wait=
_task_zombie.do_wait
      0.01 =B1 52%     -88.3%       0.00 =B1119%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.sched_fork.copy_process
      0.01 =B1 45%   +1315.8%       0.20 =B1 28%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_write_unlock_irq.rel=
ease_task.wait_task_zombie
      1.43 =B1 15%     -29.3%       1.01 =B1 16%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk.schedule_tail.ret_from_fo=
rk.[unknown]
      0.15 =B1139%     -94.7%       0.01 =B1 81%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.fs_reclaim_acquire
      0.25 =B1110%     -99.3%       0.00 =B1198%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.kmem_cache_alloc
      0.02 =B1 46%     -65.2%       0.01 =B1121%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.memcg_slab_free_hook
      0.03 =B1139%     -95.8%       0.00 =B1148%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e.kmem_cache_alloc
      0.04 =B1146%     -96.5%       0.00 =B1 68%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.get=
_obj_cgroup_from_current.kmem_cache_alloc
      0.03 =B1 98%     -96.5%       0.00 =B1106%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.kme=
m_cache_alloc.__alloc_file
      0.00 =B1223%   +4308.2%       0.05 =B1131%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.__alloc_file
      0.01 =B1187%   +2343.6%       0.22 =B1118%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.__d_alloc
      0.01 =B1196%    +900.3%       0.14 =B1 95%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.vm_area_alloc
      0.00 =B1223%   +1361.7%       0.05 =B1 86%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.vm_area_dup
      0.01 =B1 29%     -63.5%       0.00 =B1 39%  perf-sched.sch_delay.avg.=
ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_sys_=
poll
      0.42 =B1 73%     -77.3%       0.10 =B1 96%  perf-sched.sch_delay.avg.=
ms.wait_for_partner.fifo_open.do_dentry_open.do_open.isra
      0.02 =B1 18%     -23.9%       0.01 =B1  3%  perf-sched.sch_delay.avg.=
ms.worker_thread.kthread.ret_from_fork
      0.33 =B1215%   +1242.2%       4.44 =B1109%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_read_unlock.wait_tas=
k_zombie.do_wait
      0.37 =B1203%   +1154.6%       4.62 =B1 79%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.do_wp_pa=
ge.__handle_mm_fault
      1.77 =B1 72%    +456.3%       9.84 =B1 52%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.wp_page_=
copy.__handle_mm_fault
      0.00 =B1223%  +74295.2%       2.23 =B1 97%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.wait=
_task_zombie.do_wait
      0.01 =B1 45%   +7769.2%       1.15 =B1 83%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.delete_from_page_cache.truncate_inode_page
      0.03 =B1 76%     -75.0%       0.01 =B1 98%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.sched_fork.copy_process
      0.01 =B1 46%  +54592.7%       7.84 =B1 41%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_write_unlock_irq.rel=
ease_task.wait_task_zombie
      0.04 =B1 13%   +4067.1%       1.85 =B1 70%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.lru_add_drain.unmap_regio=
n.__do_munmap
      0.00 =B1142%  +19789.1%       0.83 =B1223%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__alloc_pag=
es.alloc_pages_vma
      0.01 =B1 88%  +22526.4%       1.47 =B1165%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__handle_mm=
_fault.handle_mm_fault
      3.84 =B1115%    +289.2%      14.94 =B1 43%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.do_user_add=
r_fault.exc_page_fault
      0.02 =B1127%  +12104.3%       2.01 =B1133%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.exit_to_use=
r_mode_prepare.syscall_exit_to_user_mode
      0.29 =B1184%   +1499.9%       4.61 =B1 27%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.handle_mm_f=
ault.do_user_addr_fault
      0.00 =B1223%   +4871.4%       0.06 =B1123%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.get_mem_cgroup_from_mm
      1.75 =B1126%     -88.3%       0.20 =B1208%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.kmem_cache_alloc
      0.00 =B1141%   +5568.6%       0.14 =B1141%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e._copy_from_user
      0.02 =B1116%   +7531.1%       1.74 =B1116%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.rmqueue.get=
_page_from_freelist
      0.01 =B1223%  +63806.9%       3.30 =B1157%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.kmem_cache_free.=
___pmd_free_tlb.free_p4d_range
      0.00 =B1141%   +1968.6%       0.05 =B1 79%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.fil=
emap_map_pages.do_fault
      0.00 =B1223%    +1e+05%       1.22 =B1129%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.__alloc_file
      0.01 =B1187%  +63923.9%       5.87 =B1110%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.__d_alloc
      0.01 =B1102%   +3193.6%       0.26 =B1165%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.anon_vma_fork
      0.01 =B1196%  +24750.1%       3.52 =B1 84%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.vm_area_alloc
      0.00 =B1223%  +78405.3%       2.49 =B1 99%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.vm_area_dup
      0.42 =B1217%   +1802.0%       8.00 =B1 67%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
memcg_slab_free_hook.kmem_cache_free
     12.74 =B1 72%     -81.7%       2.34 =B1140%  perf-sched.sch_delay.max.=
ms.wait_for_partner.fifo_open.do_dentry_open.do_open.isra
      2.94           +99.6%       5.88 =B1 31%  perf-sched.sch_delay.max.ms=
.worker_thread.kthread.ret_from_fork
      0.09 =B1  3%     -60.2%       0.04 =B1  4%  perf-sched.total_sch_dela=
y.average.ms
     50.98           -85.8%       7.23 =B1  3%  perf-sched.total_wait_and_d=
elay.average.ms
     16846          +625.7%     122252 =B1  3%  perf-sched.total_wait_and_d=
elay.count.ms
      7245           -53.2%       3392 =B1 28%  perf-sched.total_wait_and_d=
elay.max.ms
     50.90           -85.9%       7.20 =B1  3%  perf-sched.total_wait_time.=
average.ms
      7245           -53.2%       3392 =B1 28%  perf-sched.total_wait_time.=
max.ms
     15.26 =B1  7%     -24.8%      11.47 =B1  9%  perf-sched.wait_and_delay=
.avg.ms.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64
     11.02 =B1110%     -92.6%       0.82 =B1 42%  perf-sched.wait_and_delay=
.avg.ms.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_sysvec_res=
chedule_ipi.[unknown]
    681.03 =B1  3%     -73.2%     182.59 =B1 11%  perf-sched.wait_and_delay=
.avg.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do=
_sys_poll
    231.38           -16.0%     194.27        perf-sched.wait_and_delay.avg=
.ms.smpboot_thread_fn.kthread.ret_from_fork
    132.26 =B1  2%     -98.4%       2.08 =B1  4%  perf-sched.wait_and_delay=
.avg.ms.worker_thread.kthread.ret_from_fork
    128.00 =B1 12%   +3429.0%       4517 =B1 16%  perf-sched.wait_and_delay=
.count.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_sysvec_resc=
hedule_ipi.[unknown]
    139.00 =B1  6%    +848.6%       1318 =B1  4%  perf-sched.wait_and_delay=
.count.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.file=
map_map_pages.do_fault
    175.83 =B1  7%   +1452.4%       2729 =B1  8%  perf-sched.wait_and_delay=
.count.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.zap_=
pte_range.unmap_page_range
      0.83 =B1223%  +15140.0%     127.00 =B1 33%  perf-sched.wait_and_delay=
.count.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.=
shmem_add_to_page_cache.shmem_getpage_gfp
     26.33 =B1  4%    +139.8%      63.14 =B1  5%  perf-sched.wait_and_delay=
.count.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_=
sys_poll
      1299           +21.2%       1573 =B1  2%  perf-sched.wait_and_delay.c=
ount.smpboot_thread_fn.kthread.ret_from_fork
      1194 =B1  2%   +6800.0%      82420 =B1  3%  perf-sched.wait_and_delay=
.count.worker_thread.kthread.ret_from_fork
     15.11 =B1 45%   +4686.8%     723.15 =B1 61%  perf-sched.wait_and_delay=
.max.ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.zap=
_pte_range.unmap_page_range
     69.89 =B1223%   +2717.9%       1969 =B1 32%  perf-sched.wait_and_delay=
.max.ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq=
.shmem_add_to_page_cache.shmem_getpage_gfp
      7245           -80.2%       1432 =B1 32%  perf-sched.wait_and_delay.m=
ax.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_s=
ys_poll
     15.16 =B1  7%     -25.7%      11.27 =B1  9%  perf-sched.wait_time.avg.=
ms.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64
     10.99 =B1110%     -92.6%       0.82 =B1 42%  perf-sched.wait_time.avg.=
ms.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_sysvec_reschedu=
le_ipi.[unknown]
      3.02 =B1 46%    +216.9%       9.58 =B1 79%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_read_unlock.wait_tas=
k_zombie.do_wait
      0.01 =B1112%    +242.9%       0.02 =B1 56%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.__d_look=
up.lookup_fast
      0.00 =B1223%   +3292.9%       0.07 =B1133%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.__pmd_al=
loc.__handle_mm_fault
      0.00 =B1223%  +8.2e+05%      24.46 =B1238%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.__pmd_al=
loc.copy_page_range
      0.01 =B1223%  +15653.9%       1.16 =B1 95%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.do_s=
igaction.__x64_sys_rt_sigaction
      0.48 =B1223%   +1187.2%       6.13 =B1 20%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.wait=
_task_zombie.do_wait
      0.04 =B1 58%    +428.4%       0.20 =B1 73%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.__wake_up_common_lock.pipe_write
      0.00 =B1223%  +2.6e+05%       7.31 =B1131%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.release_pages.__pagevec_release
      2.11 =B1 54%     -81.6%       0.39 =B1149%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.sched_fork.copy_process
      0.54 =B1223%    +809.0%       4.87 =B1 34%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.thread_group_cputime_adjusted.wait_task_zombie
      0.00 =B1223%  +17141.8%       0.37 =B1234%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.unix_stream_read_generic.unix_stream_recvmsg
      2.45 =B1 53%     -94.2%       0.14 =B1 66%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk.kernel_init_free_pages.pr=
ep_new_page.get_page_from_freelist
      2.71 =B1 80%     -97.4%       0.07 =B1 88%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk.perf_iterate_sb.perf_even=
t_mmap.do_brk_flags
      0.00 =B1223%  +13726.4%       0.30 =B1207%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk.shmem_write_end.generic_p=
erform_write.__generic_file_write_iter
      0.01 =B1 92%  +10275.6%       0.71 =B1145%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__d_lookup_=
rcu.lookup_fast
      0.00 =B1223%    +892.9%       0.02 =B1 38%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__get_user_=
8.get_user_arg_ptr
      0.00 =B1223%   +1422.3%       0.06 =B1115%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__memcg_kme=
m_charge_page.__alloc_pages
      0.00 =B1144%   +4191.6%       0.21 =B1 81%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__might_sle=
ep.__might_fault
      0.00 =B1223%   +1490.5%       0.02 =B1 64%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__rcu_read_=
unlock.memcg_slab_free_hook
      0.00 =B1223%  +15559.3%       0.34 =B1212%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.alloc_pages=
_vma.do_anonymous_page
      0.00 =B1223%   +2156.0%       0.09 =B1 96%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.call_rcu.ta=
sk_work_run
      0.00 =B1223%    +895.9%       0.03 =B1 56%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.cgroup_thro=
ttle_swaprate.do_anonymous_page
      0.00 =B1223%    +538.1%       0.02 =B1 22%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.d_path.perf=
_event_mmap
      0.01 =B1223%   +1628.2%       0.23 =B1 83%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.debug_lockd=
ep_rcu_enabled.___might_sleep
      0.00 =B1223%   +9085.7%       0.18 =B1139%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.down_read_t=
rylock.do_user_addr_fault
      0.03 =B1199%    +843.3%       0.28 =B1 58%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.exit_to_use=
r_mode_prepare
      0.00 =B1223%    +836.7%       0.02 =B1 24%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.fs_reclaim_=
release.__alloc_pages
      0.01 =B1223%   +2452.4%       0.15 =B1150%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.kmem_cache_=
alloc.__d_alloc
      0.02 =B1223%   +9193.2%       2.25 =B1187%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.kmem_cache_=
free.do_sys_openat2
      0.00 =B1150%    +518.6%       0.02 =B1 23%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.kmem_cache_=
free.unlink_anon_vmas
      0.00 =B1223%  +15682.1%       0.21 =B1210%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.link_path_w=
alk.part
      0.00 =B1223%   +1210.9%       0.04 =B1 79%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.load_elf_bi=
nary.exec_binprm
      0.00 =B1223%   +1509.5%       0.02 =B1 62%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.__memcg_kmem_charge_page
      0.00 =B1223%  +19029.4%       0.54 =B1 70%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.aa_file_perm
      0.00 =B1106%   +2440.8%       0.06 =B1121%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.memcg_slab_free_hook
      0.00 =B1223%   +7689.3%       0.10 =B1181%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.mntput_no_expire
      0.04 =B1223%   +4078.3%       1.57 =B1158%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_is_hel=
d_type.xas_start
      0.00 =B1223%   +5391.4%       0.14 =B1165%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e.handle_mm_fault
      0.00 =B1223%  +31278.0%       0.68 =B1 90%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.refill_obj_=
stock.obj_cgroup_charge
      0.04 =B1148%   +1296.7%       0.54 =B1 42%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.set_root.nd=
_jump_root
      0.00 =B1223%  +91500.0%       1.83 =B1117%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.step_into.w=
alk_component
      0.00 =B1223%    +660.0%       0.02 =B1 40%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.uncharge_pa=
ge.mem_cgroup_uncharge_list
      0.00 =B1223%   +1937.4%       0.04 =B1 81%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.vm_area_dup=
.__split_vma
      9.63 =B1179%     -97.1%       0.28 =B1 34%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.__perf_sw_event.=
handle_mm_fault.do_user_addr_fault
      3.30 =B1 44%     -96.7%       0.11 =B1 98%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.__a=
lloc_pages.alloc_pages_vma
      3.10 =B1 78%     -93.5%       0.20 =B1 93%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.get=
_mem_cgroup_from_mm.mem_cgroup_charge
      0.00 =B1223%  +33366.7%       0.50 =B1138%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.kme=
m_cache_alloc.security_file_alloc
      0.00 =B1223%    +602.9%       0.01 =B1 45%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.mnt=
put_no_expire.terminate_walk
      0.01 =B1146%   +1014.3%       0.08 =B1120%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.pre=
pend_path.isra
      0.00 =B1223%   +7828.6%       0.13 =B1215%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.unc=
harge_page.mem_cgroup_uncharge_list
      0.00 =B1223%   +1366.7%       0.04 =B1142%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.unm=
ap_vmas.unmap_region
      0.00 =B1223%  +29440.8%       0.69 =B1154%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.up_=
write.anon_vma_clone
      0.00 =B1223%  +47480.0%       0.79 =B1199%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
memcg_slab_free_hook.kmem_cache_free
    681.02 =B1  3%     -73.2%     182.59 =B1 11%  perf-sched.wait_time.avg.=
ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_sys_=
poll
    231.35           -16.0%     194.25        perf-sched.wait_time.avg.ms.s=
mpboot_thread_fn.kthread.ret_from_fork
    132.25 =B1  2%     -98.4%       2.07 =B1  4%  perf-sched.wait_time.avg.=
ms.worker_thread.kthread.ret_from_fork
      1.08 =B1222%    +633.8%       7.96 =B1 66%  perf-sched.wait_time.max.=
ms.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_exc_page_fault.=
[unknown]
      0.21 =B1191%  +72062.8%     152.74 =B1227%  perf-sched.wait_time.max.=
ms.exit_to_user_mode_prepare.syscall_exit_to_user_mode.do_syscall_64.entry_=
SYSCALL_64_after_hwframe
      3.50 =B1 59%   +4625.6%     165.16 =B1206%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_read_unlock.wait_tas=
k_zombie.do_wait
      0.01 =B1104%    +619.5%       0.05 =B1 98%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.__d_look=
up.lookup_fast
      0.00 =B1223%  +17007.1%       0.68 =B1166%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.__pmd_al=
loc.__handle_mm_fault
      0.00 =B1223%  +4.9e+06%     147.41 =B1237%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.__pmd_al=
loc.copy_page_range
     16.77 =B1 40%   +5900.4%       1006        perf-sched.wait_time.max.ms=
.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.do_anonymo=
us_page.__handle_mm_fault
      5.04 =B1 66%    +227.0%      16.48 =B1 33%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.do_wp_pa=
ge.__handle_mm_fault
      0.08 =B1223%  +63355.5%      48.44 =B1174%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.finish_f=
ault.do_fault
      0.84 =B1 75%  +68794.5%     577.34 =B1 85%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.wp_page_=
copy.__handle_mm_fault
     14.63 =B1 47%   +4838.6%     722.46 =B1 61%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.zap_pte_=
range.unmap_page_range
      0.01 =B1223%  +1.3e+05%       9.24 =B1 62%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.do_s=
igaction.__x64_sys_rt_sigaction
     74.80 =B1206%   +2533.1%       1969 =B1 32%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.shme=
m_add_to_page_cache.shmem_getpage_gfp
      0.48 =B1223%    +330.0%       2.04 =B1 83%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.sign=
al_setup_done.arch_do_signal_or_restart
      1.09 =B1223%    +876.2%      10.59 =B1 74%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.sigp=
rocmask.__x64_sys_rt_sigprocmask
      0.48 =B1223%   +4611.7%      22.44 =B1 27%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.wait=
_task_zombie.do_wait
      6.55 =B1 55%   +2355.2%     160.79 =B1213%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.delete_from_page_cache.truncate_inode_page
      1.40 =B1223%    +781.2%      12.31 =B1 60%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.do_wait.kernel_wait4
      2.33 =B1197%    +592.2%      16.16 =B1 26%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.rcu_preempt_deferred_qs_irqrestore.__rcu_read_unlock
      0.00 =B1223%  +1.1e+07%     297.91 =B1149%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.release_pages.__pagevec_release
      5.53 =B1 50%  +10419.9%     582.14 =B1 83%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.release_pages.tlb_flush_mmu
      0.54 =B1223%   +1856.2%      10.48 =B1 51%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.thread_group_cputime_adjusted.wait_task_zombie
      0.00 =B1223%  +51275.8%       1.11 =B1235%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.unix_stream_read_generic.unix_stream_recvmsg
      6.84 =B1 45%    +288.2%      26.57 =B1 15%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_write_unlock_irq.rel=
ease_task.wait_task_zombie
      4.43 =B1132%    +236.2%      14.88 =B1 37%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.cpu_stop_queue_work.stop_=
one_cpu.sched_exec
      1.13 =B1108%   +1162.3%      14.32 =B1 44%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.lru_add_drain.exit_mmap.m=
mput
      4.43 =B1 70%  +21666.4%     964.76 =B1 61%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.lru_cache_add.shmem_getpa=
ge_gfp.shmem_write_begin
      0.01 =B1143%  +22411.0%       1.31 =B1 84%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.schedule_tail.ret_from_fo=
rk.[unknown]
      0.00 =B1223%  +51236.3%       1.11 =B1224%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.shmem_write_end.generic_p=
erform_write.__generic_file_write_iter
      5.58 =B1 74%   +2113.2%     123.51 =B1210%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.handl=
e_mm_fault.do_user_addr_fault
      0.00 =B1223%   +2078.6%       0.09 =B1 71%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__get_user_=
8.get_user_arg_ptr
      1.22 =B1223%  +12415.0%     152.35 =B1228%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__handle_mm=
_fault.handle_mm_fault
      0.11 =B1175%  +3.5e+05%     400.77 =B1163%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__mem_cgrou=
p_charge.mem_cgroup_charge
      0.00 =B1223%  +10645.1%       0.45 =B1160%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__memcg_kme=
m_charge_page.__alloc_pages
      0.01 =B1144%  +64806.6%       4.44 =B1 96%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__might_sle=
ep.__might_fault
      0.00 =B1223%   +2061.9%       0.06 =B1 87%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__rcu_read_=
unlock.memcg_slab_free_hook
      0.00 =B1223%  +31586.9%       1.32 =B1217%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.alloc_pages=
_vma.do_anonymous_page
      0.01 =B1223%  +12325.1%       1.01 =B1111%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.call_rcu.ta=
sk_work_run
      0.00 =B1223%   +3996.4%       0.16 =B1119%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.cgroup_thro=
ttle_swaprate.do_anonymous_page
      0.00 =B1223%   +6485.7%       0.26 =B1102%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.d_alloc_par=
allel.__lookup_slow
      0.00 =B1223%   +2323.8%       0.07 =B1 41%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.d_path.perf=
_event_mmap
      0.02 =B1223%  +24760.7%       6.05 =B1 84%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.debug_lockd=
ep_rcu_enabled.___might_sleep
      5.79 =B1 45%   +2650.3%     159.25 =B1215%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.do_user_add=
r_fault.exc_page_fault
      0.00 =B1223%  +38532.1%       1.55 =B1163%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.down_read_t=
rylock.do_user_addr_fault
      0.08 =B1214%   +7364.1%       5.98 =B1 65%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.exit_to_use=
r_mode_prepare
      4.99 =B1 59%   +2975.2%     153.54 =B1226%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.exit_to_use=
r_mode_prepare.irqentry_exit_to_user_mode
      1.13 =B1195%   +1365.8%      16.53 =B1 49%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.exit_to_use=
r_mode_prepare.syscall_exit_to_user_mode
      0.01 =B1223%   +1592.0%       0.14 =B1125%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.fs_reclaim_=
acquire.kmem_cache_alloc
      0.00 =B1223%   +5018.4%       0.12 =B1 52%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.fs_reclaim_=
release.__alloc_pages
      1.39 =B1184%   +1210.9%      18.17 =B1 47%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.handle_mm_f=
ault.do_user_addr_fault
      0.00 =B1223%   +3631.1%       0.11 =B1104%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.kmem_cache_=
alloc.__anon_vma_prepare
      0.02 =B1223%  +13668.3%       2.48 =B1158%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.kmem_cache_=
alloc.__d_alloc
      0.01 =B1186%  +18694.4%       2.69 =B1150%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.kmem_cache_=
alloc.anon_vma_fork
      0.07 =B1223%   +6497.8%       4.77 =B1 93%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.kmem_cache_=
free.do_sys_openat2
      0.01 =B1147%   +3742.1%       0.26 =B1 68%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.kmem_cache_=
free.unlink_anon_vmas
      2.35 =B1121%   +6566.9%     156.56 =B1219%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.ktime_get_c=
oarse_real_ts64.current_time
      0.00 =B1223%  +28316.0%       1.18 =B1225%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.link_path_w=
alk.part
      0.00 =B1223%   +4271.4%       0.12 =B1 80%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.load_elf_bi=
nary.exec_binprm
      0.00 =B1223%   +5105.5%       0.23 =B1135%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.__memcg_kmem_charge_page
      0.79 =B1175%  +15699.4%     124.95 =B1209%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.__might_fault
      0.00 =B1223%  +2.5e+05%       7.17 =B1 71%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.aa_file_perm
      0.17 =B1223%   +3438.4%       6.19 =B1 48%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.down_read_trylock
      1.37 =B1170%    +371.7%       6.46 =B1 45%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.down_write
      0.01 =B1188%  +27098.9%       3.54 =B1121%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.get_mem_cgroup_from_objcg
      1.22 =B1220%    +947.0%      12.73 =B1 97%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.handle_mm_fault
      0.01 =B1117%  +37573.5%       3.96 =B1178%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.memcg_slab_free_hook
      0.00 =B1223%  +55391.4%       1.39 =B1206%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.mntput_no_expire
      1.15 =B1223%    +892.5%      11.38 =B1 78%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.pagecache_get_page
      2.42 =B1166%    +452.4%      13.35 =B1 60%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.thread_group_cputime
      1.74 =B1139%    +863.3%      16.77 =B1 46%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_is_hel=
d_type.___might_sleep
      0.07 =B1223%  +25515.2%      19.17 =B1154%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_is_hel=
d_type.xas_start
      0.00 =B1223%  +1.4e+05%       3.51 =B1203%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e.handle_mm_fault
      0.21 =B1112%   +3319.5%       7.11 =B1 70%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e.kmem_cache_alloc
      0.05 =B1223%   +2412.6%       1.37 =B1136%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e.memcg_slab_free_hook
      0.08 =B1223%   +3681.8%       3.08 =B1136%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.mem_cgroup_=
from_task.handle_mm_fault
      0.01 =B1223%   +1502.6%       0.15 =B1 85%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.next_uptoda=
te_page.filemap_map_pages
      0.17 =B1149%   +3739.4%       6.53 =B1153%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.refill_obj_=
stock.memcg_slab_free_hook
      0.00 =B1223%  +1.9e+05%       7.75 =B1101%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.refill_obj_=
stock.obj_cgroup_charge
      0.08 =B1182%  +14050.5%      11.93 =B1 46%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.set_root.nd=
_jump_root
      0.00 =B1223%  +1.5e+05%       6.19 =B1152%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.step_into.w=
alk_component
      2.32 =B1120%   +6531.1%     154.11 =B1224%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.syscall_ent=
er_from_user_mode.do_syscall_64
      1.00 =B1223%    +365.8%       4.66 =B1 93%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.uncharge_ba=
tch.mem_cgroup_uncharge_list
      0.00 =B1223%   +2414.3%       0.06 =B1 88%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.uncharge_pa=
ge.mem_cgroup_uncharge_list
      0.02 =B1223%   +3580.9%       0.76 =B1144%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.unlink_anon=
_vmas.free_pgtables
      0.00 =B1223%   +6717.6%       0.15 =B1102%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.vm_area_dup=
.__split_vma
      1.30 =B1209%    +559.4%       8.60 =B1 73%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.vmacache_fi=
nd.find_vma
      0.01 =B1162%   +3435.1%       0.41 =B1120%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.kfree.perf_event=
_mmap.do_brk_flags
      0.00 =B1223%    +620.0%       0.03 =B1 48%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.get=
_mem_cgroup_from_objcg.uncharge_page
      0.01 =B1141%  +45293.8%       2.42 =B1237%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.get=
_mem_cgroup_from_objcg.obj_cgroup_charge_pages
      2.50 =B1142%    +219.9%       8.00 =B1 71%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.han=
dle_mm_fault.do_user_addr_fault
      0.08 =B1223%   +2018.2%       1.68 =B1135%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.kme=
m_cache_alloc.__d_alloc
      0.00 =B1223%  +84204.8%       2.53 =B1126%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.kme=
m_cache_alloc.security_file_alloc
      0.00 =B1223%   +4519.0%       0.21 =B1101%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.kme=
m_cache_alloc.vm_area_alloc
      0.00 =B1223%    +784.2%       0.03 =B1 61%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.mnt=
put_no_expire.terminate_walk
      0.02 =B1180%   +2149.5%       0.34 =B1134%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.pre=
pend_path.isra
      0.00 =B1223%  +29252.9%       0.98 =B1232%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.unc=
harge_page.mem_cgroup_uncharge_list
      0.00 =B1223%   +3247.6%       0.10 =B1174%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.unm=
ap_vmas.unmap_region
      0.00 =B1223%  +1.3e+05%       2.98 =B1163%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.up_=
write.anon_vma_clone
      1.24 =B1205%  +12646.0%     157.82 =B1219%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.anon_vma_clone
      3.42 =B1 93%   +8491.7%     293.49 =B1152%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.anon_vma_fork
      1.01 =B1222%  +29628.1%     300.90 =B1149%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.vm_area_dup
      0.01 =B1223%    +3e+06%     153.73 =B1225%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
memcg_slab_free_hook.kmem_cache_free
      7245           -80.2%       1432 =B1 32%  perf-sched.wait_time.max.ms=
.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_sys_po=
ll
     17.95            -4.6       13.35        perf-profile.calltrace.cycles=
-pp.sieve
      6.02 =B1  2%      -1.6        4.38 =B1  2%  perf-profile.calltrace.cy=
cles-pp.string_rtns_1
      9.11            -1.2        7.86        perf-profile.calltrace.cycles=
-pp.page_test
      8.75            -1.2        7.55        perf-profile.calltrace.cycles=
-pp.asm_exc_page_fault.page_test
      8.58            -1.1        7.44        perf-profile.calltrace.cycles=
-pp.exc_page_fault.asm_exc_page_fault.page_test
      8.44            -1.1        7.34        perf-profile.calltrace.cycles=
-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.page_test
      7.42            -0.9        6.55        perf-profile.calltrace.cycles=
-pp.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.pa=
ge_test
      3.10 =B1  3%      -0.8        2.30 =B1  2%  perf-profile.calltrace.cy=
cles-pp.add_int.add_int
      6.73 =B1  2%      -0.8        5.93        perf-profile.calltrace.cycl=
es-pp.brk
      3.16 =B1  4%      -0.8        2.36 =B1  2%  perf-profile.calltrace.cy=
cles-pp.__strncat_chk
      3.05 =B1  3%      -0.8        2.25 =B1  3%  perf-profile.calltrace.cy=
cles-pp.add_long.add_long
      6.36 =B1  2%      -0.7        5.62 =B1  2%  perf-profile.calltrace.cy=
cles-pp.entry_SYSCALL_64_after_hwframe.brk
      6.34 =B1  2%      -0.7        5.60 =B1  2%  perf-profile.calltrace.cy=
cles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
      5.95 =B1  2%      -0.6        5.31        perf-profile.calltrace.cycl=
es-pp.__x64_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
      2.23 =B1  2%      -0.6        1.61 =B1  2%  perf-profile.calltrace.cy=
cles-pp.div_long
      2.50 =B1  7%      -0.6        1.91 =B1  9%  perf-profile.calltrace.cy=
cles-pp.write
      2.49 =B1  7%      -0.6        1.90 =B1  9%  perf-profile.calltrace.cy=
cles-pp.entry_SYSCALL_64_after_hwframe.write
      2.48 =B1  7%      -0.6        1.90 =B1  9%  perf-profile.calltrace.cy=
cles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.write
      2.39 =B1  7%      -0.6        1.83 =B1  9%  perf-profile.calltrace.cy=
cles-pp.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe.write
      2.38 =B1  8%      -0.6        1.82 =B1  9%  perf-profile.calltrace.cy=
cles-pp.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe.w=
rite
      2.08 =B1  9%      -0.5        1.59 =B1 10%  perf-profile.calltrace.cy=
cles-pp.new_sync_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_=
after_hwframe
      1.85 =B1  3%      -0.5        1.37 =B1  3%  perf-profile.calltrace.cy=
cles-pp.__strcat_chk
      1.80 =B1  5%      -0.5        1.32 =B1  3%  perf-profile.calltrace.cy=
cles-pp.add_short.add_short
      1.15 =B1 14%      -0.4        0.73 =B1 13%  perf-profile.calltrace.cy=
cles-pp.drm_fb_helper_damage_work.process_one_work.worker_thread.kthread.re=
t_from_fork
      1.12 =B1 14%      -0.4        0.72 =B1 13%  perf-profile.calltrace.cy=
cles-pp.memcpy_toio.drm_fb_helper_damage_work.process_one_work.worker_threa=
d.kthread
      2.62 =B1  9%      -0.4        2.24 =B1 10%  perf-profile.calltrace.cy=
cles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.cpuidle=
_enter_state.cpuidle_enter.do_idle
      2.72 =B1  9%      -0.4        2.35 =B1 10%  perf-profile.calltrace.cy=
cles-pp.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state.cpuidle_enter.d=
o_idle.cpu_startup_entry
      6.14 =B1  2%      -0.4        5.79        perf-profile.calltrace.cycl=
es-pp.entry_SYSCALL_64_after_hwframe.execve
      6.14 =B1  2%      -0.4        5.79        perf-profile.calltrace.cycl=
es-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.execve
      6.14 =B1  2%      -0.3        5.79        perf-profile.calltrace.cycl=
es-pp.__x64_sys_execve.do_syscall_64.entry_SYSCALL_64_after_hwframe.execve
      6.18 =B1  2%      -0.3        5.84        perf-profile.calltrace.cycl=
es-pp.execve
      6.08 =B1  2%      -0.3        5.74        perf-profile.calltrace.cycl=
es-pp.do_execveat_common.__x64_sys_execve.do_syscall_64.entry_SYSCALL_64_af=
ter_hwframe.execve
      1.42 =B1 10%      -0.3        1.10 =B1  5%  perf-profile.calltrace.cy=
cles-pp.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_apic_timer_interrup=
t.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      1.64 =B1  5%      -0.3        1.32 =B1  3%  perf-profile.calltrace.cy=
cles-pp.do_brk_flags.__x64_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwf=
rame.brk
      1.86 =B1 10%      -0.3        1.55 =B1  9%  perf-profile.calltrace.cy=
cles-pp.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysve=
c_apic_timer_interrupt.cpuidle_enter_state.cpuidle_enter
      1.77 =B1 10%      -0.3        1.46 =B1  9%  perf-profile.calltrace.cy=
cles-pp.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_i=
nterrupt.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state
      3.24 =B1  2%      -0.3        2.96 =B1  9%  perf-profile.calltrace.cy=
cles-pp.lock_page_memcg.page_remove_rmap.zap_pte_range.unmap_page_range.unm=
ap_vmas
      0.74 =B1  8%      -0.3        0.48 =B1 41%  perf-profile.calltrace.cy=
cles-pp.tick_sched_timer.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_ap=
ic_timer_interrupt.sysvec_apic_timer_interrupt
      0.65 =B1  7%      -0.3        0.39 =B1 63%  perf-profile.calltrace.cy=
cles-pp.shmem_write_begin.generic_perform_write.__generic_file_write_iter.g=
eneric_file_write_iter.new_sync_write
      0.57 =B1  5%      -0.3        0.31 =B1 86%  perf-profile.calltrace.cy=
cles-pp.vm_mmap_pgoff.elf_map.load_elf_binary.exec_binprm.bprm_execve
      0.65 =B1  7%      -0.3        0.39 =B1 63%  perf-profile.calltrace.cy=
cles-pp.shmem_getpage_gfp.shmem_write_begin.generic_perform_write.__generic=
_file_write_iter.generic_file_write_iter
      0.92 =B1 10%      -0.3        0.67 =B1  8%  perf-profile.calltrace.cy=
cles-pp.div_int
      1.00 =B1  4%      -0.2        0.77 =B1  9%  perf-profile.calltrace.cy=
cles-pp.div_short
      3.74 =B1  2%      -0.2        3.53        perf-profile.calltrace.cycl=
es-pp.__do_munmap.__x64_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwfram=
e.brk
      0.98 =B1  6%      -0.2        0.77 =B1  5%  perf-profile.calltrace.cy=
cles-pp.generic_file_write_iter.new_sync_write.vfs_write.ksys_write.do_sysc=
all_64
      0.95 =B1  4%      -0.2        0.75 =B1  5%  perf-profile.calltrace.cy=
cles-pp.get_mem_cgroup_from_mm.mem_cgroup_charge.do_anonymous_page.__handle=
_mm_fault.handle_mm_fault
      0.87 =B1  6%      -0.2        0.68 =B1  6%  perf-profile.calltrace.cy=
cles-pp.__generic_file_write_iter.generic_file_write_iter.new_sync_write.vf=
s_write.ksys_write
      1.50 =B1  3%      -0.2        1.33 =B1  3%  perf-profile.calltrace.cy=
cles-pp.unmap_page_range.unmap_vmas.exit_mmap.mmput.begin_new_exec
      1.51 =B1  3%      -0.2        1.35 =B1  3%  perf-profile.calltrace.cy=
cles-pp.unmap_vmas.exit_mmap.mmput.begin_new_exec.load_elf_binary
      0.92 =B1  6%      -0.2        0.76 =B1  4%  perf-profile.calltrace.cy=
cles-pp.__xstat64
      0.88 =B1  6%      -0.2        0.73 =B1  4%  perf-profile.calltrace.cy=
cles-pp.entry_SYSCALL_64_after_hwframe.__xstat64
      0.88 =B1  6%      -0.2        0.73 =B1  4%  perf-profile.calltrace.cy=
cles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__xstat64
      0.85 =B1  6%      -0.2        0.70 =B1  3%  perf-profile.calltrace.cy=
cles-pp.__do_sys_newstat.do_syscall_64.entry_SYSCALL_64_after_hwframe.__xst=
at64
      0.82 =B1  5%      -0.2        0.67 =B1  5%  perf-profile.calltrace.cy=
cles-pp.perf_event_mmap.do_brk_flags.__x64_sys_brk.do_syscall_64.entry_SYSC=
ALL_64_after_hwframe
      0.74 =B1  7%      -0.1        0.60 =B1  5%  perf-profile.calltrace.cy=
cles-pp.generic_perform_write.__generic_file_write_iter.generic_file_write_=
iter.new_sync_write.vfs_write
      0.82 =B1  7%      -0.1        0.67 =B1  4%  perf-profile.calltrace.cy=
cles-pp.vfs_statx.__do_sys_newstat.do_syscall_64.entry_SYSCALL_64_after_hwf=
rame.__xstat64
      1.52 =B1  2%      -0.1        1.37 =B1  2%  perf-profile.calltrace.cy=
cles-pp.unmap_vmas.unmap_region.__do_munmap.__x64_sys_brk.do_syscall_64
      1.49 =B1  2%      -0.1        1.35 =B1  2%  perf-profile.calltrace.cy=
cles-pp.unmap_page_range.unmap_vmas.unmap_region.__do_munmap.__x64_sys_brk
      1.46 =B1  2%      -0.1        1.34 =B1  2%  perf-profile.calltrace.cy=
cles-pp.zap_pte_range.unmap_page_range.unmap_vmas.unmap_region.__do_munmap
      1.20 =B1  2%      -0.1        1.12 =B1  2%  perf-profile.calltrace.cy=
cles-pp.page_remove_rmap.zap_pte_range.unmap_page_range.unmap_vmas.unmap_re=
gion
      0.63 =B1  3%      +0.1        0.70 =B1  7%  perf-profile.calltrace.cy=
cles-pp.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_=
hwframe
      1.94 =B1  3%      +0.1        2.07 =B1  3%  perf-profile.calltrace.cy=
cles-pp.filemap_map_pages.do_fault.__handle_mm_fault.handle_mm_fault.do_use=
r_addr_fault
      2.55 =B1  2%      +0.1        2.69        perf-profile.calltrace.cycl=
es-pp.dup_mmap.dup_mm.copy_process.kernel_clone.__do_sys_clone
      2.10 =B1  3%      +0.1        2.24 =B1  2%  perf-profile.calltrace.cy=
cles-pp.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_p=
age_fault
      0.68 =B1  2%      +0.1        0.82 =B1  6%  perf-profile.calltrace.cy=
cles-pp.vfs_statx.__do_sys_newstat.do_syscall_64.entry_SYSCALL_64_after_hwf=
rame
      2.60 =B1  2%      +0.2        2.75 =B1  2%  perf-profile.calltrace.cy=
cles-pp.dup_mm.copy_process.kernel_clone.__do_sys_clone.do_syscall_64
      0.68 =B1  2%      +0.2        0.83 =B1  6%  perf-profile.calltrace.cy=
cles-pp.__do_sys_newstat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.15            +0.2        3.31 =B1  2%  perf-profile.calltrace.cycl=
es-pp.copy_process.kernel_clone.__do_sys_clone.do_syscall_64.entry_SYSCALL_=
64_after_hwframe
      2.11 =B1  2%      +0.2        2.31 =B1  6%  perf-profile.calltrace.cy=
cles-pp.unmap_page_range.unmap_vmas.exit_mmap.mmput.do_exit
      2.12 =B1  2%      +0.2        2.32 =B1  6%  perf-profile.calltrace.cy=
cles-pp.unmap_vmas.exit_mmap.mmput.do_exit.do_group_exit
      2.81            +0.4        3.24 =B1  4%  perf-profile.calltrace.cycl=
es-pp.exit_mmap.mmput.do_exit.do_group_exit.__x64_sys_exit_group
      2.81            +0.4        3.25 =B1  4%  perf-profile.calltrace.cycl=
es-pp.mmput.do_exit.do_group_exit.__x64_sys_exit_group.do_syscall_64
      3.20 =B1  2%      +0.4        3.64 =B1  4%  perf-profile.calltrace.cy=
cles-pp.__x64_sys_exit_group.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.20 =B1  2%      +0.4        3.64 =B1  4%  perf-profile.calltrace.cy=
cles-pp.do_group_exit.__x64_sys_exit_group.do_syscall_64.entry_SYSCALL_64_a=
fter_hwframe
      3.20 =B1  2%      +0.4        3.64 =B1  4%  perf-profile.calltrace.cy=
cles-pp.do_exit.do_group_exit.__x64_sys_exit_group.do_syscall_64.entry_SYSC=
ALL_64_after_hwframe
      2.09 =B1  4%      +0.5        2.57 =B1  3%  perf-profile.calltrace.cy=
cles-pp.mem_cgroup_charge.do_anonymous_page.__handle_mm_fault.handle_mm_fau=
lt.do_user_addr_fault
      0.00            +0.5        0.54 =B1  5%  perf-profile.calltrace.cycl=
es-pp.page_add_new_anon_rmap.do_anonymous_page.__handle_mm_fault.handle_mm_=
fault.do_user_addr_fault
      0.00            +0.6        0.57 =B1  8%  perf-profile.calltrace.cycl=
es-pp.lock_acquire._raw_spin_lock.cgroup_rstat_flush_locked.cgroup_rstat_fl=
ush_irqsafe.mem_cgroup_flush_stats
      4.68 =B1  2%      +0.6        5.26        perf-profile.calltrace.cycl=
es-pp.load_elf_binary.exec_binprm.bprm_execve.do_execveat_common.__x64_sys_=
execve
      0.00            +0.6        0.59 =B1  7%  perf-profile.calltrace.cycl=
es-pp._raw_spin_lock.cgroup_rstat_flush_locked.cgroup_rstat_flush_irqsafe.m=
em_cgroup_flush_stats.process_one_work
      4.91 =B1  2%      +0.6        5.51        perf-profile.calltrace.cycl=
es-pp.bprm_execve.do_execveat_common.__x64_sys_execve.do_syscall_64.entry_S=
YSCALL_64_after_hwframe
      4.71 =B1  2%      +0.6        5.32        perf-profile.calltrace.cycl=
es-pp.exec_binprm.bprm_execve.do_execveat_common.__x64_sys_execve.do_syscal=
l_64
      0.00            +0.7        0.66 =B1  6%  perf-profile.calltrace.cycl=
es-pp.__schedule.schedule.worker_thread.kthread.ret_from_fork
      0.00            +0.7        0.68 =B1  6%  perf-profile.calltrace.cycl=
es-pp.schedule.worker_thread.kthread.ret_from_fork
      0.00            +0.8        0.76 =B1  6%  perf-profile.calltrace.cycl=
es-pp.lock_acquire.cgroup_rstat_flush_locked.cgroup_rstat_flush_irqsafe.mem=
_cgroup_flush_stats.process_one_work
      3.15 =B1  3%      +0.9        4.01        perf-profile.calltrace.cycl=
es-pp.unmap_region.__do_munmap.__x64_sys_brk.do_syscall_64.entry_SYSCALL_64=
_after_hwframe
      6.98            +1.0        7.96 =B1  2%  perf-profile.calltrace.cycl=
es-pp.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_faul=
t.exc_page_fault
      0.00            +1.0        0.98 =B1  3%  perf-profile.calltrace.cycl=
es-pp.do_execveat_common.__x64_sys_execve.do_syscall_64.entry_SYSCALL_64_af=
ter_hwframe
      0.00            +1.0        1.00 =B1  3%  perf-profile.calltrace.cycl=
es-pp.__x64_sys_execve.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +1.1        1.14 =B1  4%  perf-profile.calltrace.cycl=
es-pp.__do_munmap.__x64_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      7.31 =B1  4%      +1.2        8.46 =B1  7%  perf-profile.calltrace.cy=
cles-pp.cpuidle_enter_state.cpuidle_enter.do_idle.cpu_startup_entry.start_s=
econdary
      7.36 =B1  4%      +1.2        8.53 =B1  7%  perf-profile.calltrace.cy=
cles-pp.cpuidle_enter.do_idle.cpu_startup_entry.start_secondary.secondary_s=
tartup_64_no_verify
      9.76            +1.2       10.93        perf-profile.calltrace.cycles=
-pp.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm=
_exc_page_fault
      8.08 =B1  5%      +1.5        9.59 =B1  8%  perf-profile.calltrace.cy=
cles-pp.do_idle.cpu_startup_entry.start_secondary.secondary_startup_64_no_v=
erify
      8.09 =B1  5%      +1.5        9.60 =B1  8%  perf-profile.calltrace.cy=
cles-pp.cpu_startup_entry.start_secondary.secondary_startup_64_no_verify
      8.09 =B1  5%      +1.5        9.60 =B1  8%  perf-profile.calltrace.cy=
cles-pp.start_secondary.secondary_startup_64_no_verify
      0.00            +1.6        1.57 =B1  6%  perf-profile.calltrace.cycl=
es-pp.mem_cgroup_css_rstat_flush.cgroup_rstat_flush_locked.cgroup_rstat_flu=
sh_irqsafe.mem_cgroup_flush_stats.process_one_work
      4.27 =B1  2%      +1.6        5.90 =B1  4%  perf-profile.calltrace.cy=
cles-pp.intel_idle.cpuidle_enter_state.cpuidle_enter.do_idle.cpu_startup_en=
try
      8.61 =B1  3%      +1.7       10.27 =B1  7%  perf-profile.calltrace.cy=
cles-pp.secondary_startup_64_no_verify
      0.00            +1.7        1.69 =B1  2%  perf-profile.calltrace.cycl=
es-pp.__x64_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4.10 =B1  3%      +2.4        6.54        perf-profile.calltrace.cycl=
es-pp.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      4.55 =B1  3%      +2.7        7.26 =B1  2%  perf-profile.calltrace.cy=
cles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      4.60 =B1  3%      +2.8        7.35 =B1  2%  perf-profile.calltrace.cy=
cles-pp.exc_page_fault.asm_exc_page_fault
      4.68 =B1  3%      +2.8        7.47 =B1  2%  perf-profile.calltrace.cy=
cles-pp.asm_exc_page_fault
      0.00            +4.1        4.07 =B1  3%  perf-profile.calltrace.cycl=
es-pp.cgroup_rstat_flush_locked.cgroup_rstat_flush_irqsafe.mem_cgroup_flush=
_stats.process_one_work.worker_thread
      0.00            +4.1        4.12 =B1  3%  perf-profile.calltrace.cycl=
es-pp.cgroup_rstat_flush_irqsafe.mem_cgroup_flush_stats.process_one_work.wo=
rker_thread.kthread
      1.18 =B1 14%      +4.2        5.38 =B1  2%  perf-profile.calltrace.cy=
cles-pp.process_one_work.worker_thread.kthread.ret_from_fork
      0.00            +4.3        4.31 =B1  3%  perf-profile.calltrace.cycl=
es-pp.mem_cgroup_flush_stats.process_one_work.worker_thread.kthread.ret_fro=
m_fork
      9.40            +4.6       13.98        perf-profile.calltrace.cycles=
-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
      9.41            +4.6       13.99        perf-profile.calltrace.cycles=
-pp.entry_SYSCALL_64_after_hwframe
      1.19 =B1 14%      +5.0        6.15 =B1  2%  perf-profile.calltrace.cy=
cles-pp.worker_thread.kthread.ret_from_fork
      1.44 =B1 11%      +5.0        6.45 =B1  2%  perf-profile.calltrace.cy=
cles-pp.kthread.ret_from_fork
      1.45 =B1 11%      +5.0        6.46 =B1  2%  perf-profile.calltrace.cy=
cles-pp.ret_from_fork
     17.96            -4.6       13.36        perf-profile.children.cycles-=
pp.sieve
      6.05 =B1  2%      -1.6        4.40 =B1  2%  perf-profile.children.cyc=
les-pp.string_rtns_1
      9.36            -1.3        8.06        perf-profile.children.cycles-=
pp.page_test
      6.75 =B1  2%      -0.8        5.94        perf-profile.children.cycle=
s-pp.brk
      3.10 =B1  3%      -0.8        2.30 =B1  2%  perf-profile.children.cyc=
les-pp.add_int
      3.17 =B1  4%      -0.8        2.36 =B1  2%  perf-profile.children.cyc=
les-pp.__strncat_chk
      3.05 =B1  3%      -0.8        2.26 =B1  3%  perf-profile.children.cyc=
les-pp.add_long
      2.23 =B1  2%      -0.6        1.61 =B1  2%  perf-profile.children.cyc=
les-pp.div_long
      2.51 =B1  7%      -0.6        1.92 =B1  9%  perf-profile.children.cyc=
les-pp.write
      1.86 =B1  3%      -0.5        1.37 =B1  2%  perf-profile.children.cyc=
les-pp.__strcat_chk
      1.80 =B1  5%      -0.5        1.32 =B1  3%  perf-profile.children.cyc=
les-pp.add_short
      1.15 =B1 14%      -0.4        0.73 =B1 13%  perf-profile.children.cyc=
les-pp.drm_fb_helper_damage_work
      1.14 =B1 14%      -0.4        0.73 =B1 13%  perf-profile.children.cyc=
les-pp.memcpy_toio
      6.19 =B1  2%      -0.3        5.84        perf-profile.children.cycle=
s-pp.execve
      0.93 =B1 10%      -0.3        0.67 =B1  8%  perf-profile.children.cyc=
les-pp.div_int
      2.19 =B1  5%      -0.2        1.96 =B1  4%  perf-profile.children.cyc=
les-pp.__hrtimer_run_queues
      1.00 =B1  4%      -0.2        0.77 =B1  9%  perf-profile.children.cyc=
les-pp.div_short
      2.93 =B1  6%      -0.2        2.72 =B1  5%  perf-profile.children.cyc=
les-pp.__sysvec_apic_timer_interrupt
      2.78 =B1  5%      -0.2        2.58 =B1  4%  perf-profile.children.cyc=
les-pp.hrtimer_interrupt
      0.93 =B1  5%      -0.2        0.76 =B1  4%  perf-profile.children.cyc=
les-pp.__xstat64
      0.44 =B1  9%      -0.1        0.33 =B1  8%  perf-profile.children.cyc=
les-pp.semop
      0.57 =B1  8%      -0.1        0.46 =B1  4%  perf-profile.children.cyc=
les-pp.mem_rtns_1
      0.24 =B1  5%      -0.1        0.19 =B1 11%  perf-profile.children.cyc=
les-pp.rcu_sched_clock_irq
      0.18 =B1 11%      -0.0        0.13 =B1 17%  perf-profile.children.cyc=
les-pp.strnlen_user
      0.21 =B1  4%      -0.0        0.17 =B1  8%  perf-profile.children.cyc=
les-pp.unlink
      0.08 =B1 14%      -0.0        0.04 =B1 64%  perf-profile.children.cyc=
les-pp.load_balance
      0.30 =B1  5%      -0.0        0.26 =B1  4%  perf-profile.children.cyc=
les-pp.count
      0.06 =B1  8%      +0.0        0.07 =B1  6%  perf-profile.children.cyc=
les-pp.__delete_from_page_cache
      0.08 =B1  5%      +0.0        0.10 =B1  9%  perf-profile.children.cyc=
les-pp.truncate_inode_page
      0.08 =B1 10%      +0.0        0.10 =B1  6%  perf-profile.children.cyc=
les-pp.delete_from_page_cache
      0.07 =B1 17%      +0.0        0.09 =B1  9%  perf-profile.children.cyc=
les-pp.wait_task_zombie
      0.23 =B1  5%      +0.0        0.26 =B1  7%  perf-profile.children.cyc=
les-pp.__get_user_pages_remote
      0.06 =B1 11%      +0.0        0.09 =B1 10%  perf-profile.children.cyc=
les-pp.__pagevec_release
      0.06 =B1 11%      +0.0        0.09 =B1 16%  perf-profile.children.cyc=
les-pp.__tlb_remove_page_size
      0.23 =B1  5%      +0.0        0.26 =B1  6%  perf-profile.children.cyc=
les-pp.__get_user_pages
      0.08 =B1 16%      +0.0        0.11 =B1 11%  perf-profile.children.cyc=
les-pp.alloc_bprm
      0.20 =B1  5%      +0.0        0.24 =B1  4%  perf-profile.children.cyc=
les-pp.shmem_truncate_range
      0.23 =B1  4%      +0.0        0.27 =B1  6%  perf-profile.children.cyc=
les-pp.get_arg_page
      0.24 =B1  6%      +0.0        0.27 =B1  5%  perf-profile.children.cyc=
les-pp.shmem_add_to_page_cache
      0.21 =B1  4%      +0.0        0.24 =B1  5%  perf-profile.children.cyc=
les-pp.shmem_evict_inode
      0.10 =B1 13%      +0.0        0.14 =B1  7%  perf-profile.children.cyc=
les-pp.free_p4d_range
      0.21 =B1  4%      +0.0        0.25 =B1  6%  perf-profile.children.cyc=
les-pp.evict
      0.20 =B1  4%      +0.0        0.24 =B1  5%  perf-profile.children.cyc=
les-pp.shmem_undo_range
      0.11 =B1 14%      +0.0        0.15 =B1 11%  perf-profile.children.cyc=
les-pp.update_rq_clock
      0.04 =B1 71%      +0.0        0.07 =B1  9%  perf-profile.children.cyc=
les-pp._raw_spin_trylock
      0.10 =B1 13%      +0.0        0.14 =B1  7%  perf-profile.children.cyc=
les-pp.free_pgd_range
      0.08 =B1 20%      +0.0        0.12 =B1 16%  perf-profile.children.cyc=
les-pp.lock_pin_lock
      0.12 =B1 18%      +0.0        0.16 =B1  5%  perf-profile.children.cyc=
les-pp.shift_arg_pages
      0.12 =B1 14%      +0.0        0.16 =B1 13%  perf-profile.children.cyc=
les-pp.uncharge_batch
      0.24 =B1  5%      +0.0        0.28 =B1  7%  perf-profile.children.cyc=
les-pp.smpboot_thread_fn
      0.02 =B1141%      +0.0        0.06 =B1  8%  perf-profile.children.cyc=
les-pp.unaccount_page_cache_page
      0.14 =B1 12%      +0.0        0.19 =B1  6%  perf-profile.children.cyc=
les-pp.setup_arg_pages
      0.19 =B1  8%      +0.0        0.24 =B1  3%  perf-profile.children.cyc=
les-pp.__put_anon_vma
      0.20 =B1 10%      +0.0        0.24 =B1 10%  perf-profile.children.cyc=
les-pp.preempt_count_add
      0.30 =B1  6%      +0.0        0.35 =B1  6%  perf-profile.children.cyc=
les-pp.debug_smp_processor_id
      0.05 =B1 45%      +0.1        0.10 =B1 11%  perf-profile.children.cyc=
les-pp.do_raw_spin_unlock
      0.02 =B1141%      +0.1        0.07 =B1  8%  perf-profile.children.cyc=
les-pp.newidle_balance
      0.00            +0.1        0.06 =B1 12%  perf-profile.children.cycle=
s-pp.select_idle_sibling
      0.20 =B1 12%      +0.1        0.26 =B1  7%  perf-profile.children.cyc=
les-pp.shmem_file_read_iter
      0.25 =B1  4%      +0.1        0.31 =B1 11%  perf-profile.children.cyc=
les-pp.create_elf_tables
      0.00            +0.1        0.06 =B1 11%  perf-profile.children.cycle=
s-pp.check_preempt_curr
      0.10 =B1 14%      +0.1        0.17 =B1  7%  perf-profile.children.cyc=
les-pp.update_load_avg
      0.58 =B1  4%      +0.1        0.66 =B1  5%  perf-profile.children.cyc=
les-pp.__d_alloc
      0.48 =B1  5%      +0.1        0.55 =B1  7%  perf-profile.children.cyc=
les-pp.vm_area_alloc
      0.00            +0.1        0.08 =B1  8%  perf-profile.children.cycle=
s-pp.rcu_note_context_switch
      0.00            +0.1        0.09 =B1 21%  perf-profile.children.cycle=
s-pp.enqueue_entity
      0.08 =B1  9%      +0.1        0.17 =B1  7%  perf-profile.children.cyc=
les-pp.irqentry_exit
      0.00            +0.1        0.09 =B1  6%  perf-profile.children.cycle=
s-pp.preempt_schedule_irq
      0.00            +0.1        0.09 =B1 10%  perf-profile.children.cycle=
s-pp.ttwu_do_wakeup
      0.00            +0.1        0.09 =B1 13%  perf-profile.children.cycle=
s-pp.perf_tp_event
      0.00            +0.1        0.10 =B1 14%  perf-profile.children.cycle=
s-pp.put_prev_entity
      0.05 =B1 47%      +0.1        0.15 =B1 12%  perf-profile.children.cyc=
les-pp.cpuacct_charge
      0.00            +0.1        0.10 =B1 13%  perf-profile.children.cycle=
s-pp.perf_trace_sched_wakeup_template
      0.71            +0.1        0.82 =B1  5%  perf-profile.children.cycle=
s-pp.rcu_do_batch
      0.79 =B1  2%      +0.1        0.89 =B1  4%  perf-profile.children.cyc=
les-pp.rcu_core
      1.49 =B1  3%      +0.1        1.59 =B1  2%  perf-profile.children.cyc=
les-pp.fs_reclaim_acquire
      1.45 =B1  4%      +0.1        1.56 =B1  2%  perf-profile.children.cyc=
les-pp.mmap_region
      0.82 =B1  4%      +0.1        0.94 =B1  3%  perf-profile.children.cyc=
les-pp.mem_cgroup_uncharge_list
      1.48 =B1  4%      +0.1        1.60 =B1  2%  perf-profile.children.cyc=
les-pp.do_mmap
      1.08 =B1  7%      +0.1        1.20        perf-profile.children.cycle=
s-pp.anon_vma_fork
      1.62 =B1  4%      +0.1        1.74 =B1  3%  perf-profile.children.cyc=
les-pp.vm_mmap_pgoff
      0.00            +0.1        0.12 =B1 12%  perf-profile.children.cycle=
s-pp.preempt_schedule_common
      0.00            +0.1        0.13 =B1 11%  perf-profile.children.cycle=
s-pp.preempt_schedule_thunk
      1.42 =B1  2%      +0.1        1.55 =B1  4%  perf-profile.children.cyc=
les-pp.___perf_sw_event
      2.14 =B1  2%      +0.1        2.27        perf-profile.children.cycle=
s-pp.mark_lock
      0.00            +0.1        0.13 =B1 15%  perf-profile.children.cycle=
s-pp.enqueue_task_fair
      0.00            +0.1        0.14 =B1 11%  perf-profile.children.cycle=
s-pp._find_next_bit
      2.55 =B1  2%      +0.1        2.70 =B1  2%  perf-profile.children.cyc=
les-pp.dup_mmap
      2.60 =B1  2%      +0.1        2.75 =B1  2%  perf-profile.children.cyc=
les-pp.dup_mm
      0.81 =B1  7%      +0.2        0.96 =B1  4%  perf-profile.children.cyc=
les-pp.unlink_anon_vmas
      2.23            +0.2        2.38 =B1  2%  perf-profile.children.cycle=
s-pp.trace_hardirqs_on
      0.00            +0.2        0.16 =B1 12%  perf-profile.children.cycle=
s-pp.ttwu_do_activate
      3.16            +0.2        3.32 =B1  2%  perf-profile.children.cycle=
s-pp.copy_process
      3.25            +0.2        3.41 =B1  2%  perf-profile.children.cycle=
s-pp.__do_sys_clone
      3.25            +0.2        3.41 =B1  2%  perf-profile.children.cycle=
s-pp.kernel_clone
      0.10 =B1 14%      +0.2        0.26 =B1  9%  perf-profile.children.cyc=
les-pp._raw_spin_unlock_irq
      0.05 =B1 46%      +0.2        0.22 =B1  7%  perf-profile.children.cyc=
les-pp.mem_cgroup_charge_statistics
      0.07 =B1 17%      +0.2        0.24 =B1  9%  perf-profile.children.cyc=
les-pp.pick_next_task_fair
      0.00            +0.2        0.17 =B1  6%  perf-profile.children.cycle=
s-pp.asm_sysvec_reschedule_ipi
      1.16 =B1  3%      +0.2        1.33 =B1  3%  perf-profile.children.cyc=
les-pp.validate_chain
      1.06 =B1  4%      +0.2        1.24 =B1  4%  perf-profile.children.cyc=
les-pp.free_pgtables
      0.58 =B1  9%      +0.2        0.76 =B1  4%  perf-profile.children.cyc=
les-pp.remove_vma
      0.01 =B1223%      +0.2        0.20 =B1  8%  perf-profile.children.cyc=
les-pp.select_task_rq_fair
      0.12 =B1 30%      +0.2        0.31 =B1  4%  perf-profile.children.cyc=
les-pp.finish_task_switch
      1.74 =B1  3%      +0.2        1.94 =B1  3%  perf-profile.children.cyc=
les-pp.rcu_read_lock_held
      1.09 =B1  4%      +0.2        1.29 =B1  2%  perf-profile.children.cyc=
les-pp.__this_cpu_preempt_check
      0.36 =B1  7%      +0.2        0.57 =B1  6%  perf-profile.children.cyc=
les-pp.lru_add_drain_cpu
      0.04 =B1 72%      +0.2        0.25 =B1  9%  perf-profile.children.cyc=
les-pp.dequeue_entity
      0.06 =B1 17%      +0.2        0.27 =B1  7%  perf-profile.children.cyc=
les-pp.dequeue_task_fair
      0.52 =B1  5%      +0.2        0.76 =B1  6%  perf-profile.children.cyc=
les-pp.lru_add_drain
      0.94 =B1  5%      +0.2        1.19 =B1  3%  perf-profile.children.cyc=
les-pp.__mem_cgroup_charge
      0.07 =B1 12%      +0.2        0.32 =B1  5%  perf-profile.children.cyc=
les-pp.schedule_idle
      0.18 =B1 12%      +0.3        0.47 =B1  8%  perf-profile.children.cyc=
les-pp.update_curr
      0.78 =B1  5%      +0.3        1.07 =B1  4%  perf-profile.children.cyc=
les-pp.__pagevec_lru_add_fn
      2.67 =B1  3%      +0.3        2.97 =B1  3%  perf-profile.children.cyc=
les-pp.mem_cgroup_charge
      0.56 =B1  2%      +0.3        0.89 =B1  4%  perf-profile.children.cyc=
les-pp.page_add_new_anon_rmap
      1.43 =B1  3%      +0.3        1.77 =B1  2%  perf-profile.children.cyc=
les-pp.lru_cache_add
      0.41 =B1 12%      +0.3        0.75 =B1  5%  perf-profile.children.cyc=
les-pp.lock_page_lruvec_irqsave
      2.69 =B1  2%      +0.4        3.06 =B1  2%  perf-profile.children.cyc=
les-pp.rcu_is_watching
      2.78 =B1  2%      +0.4        3.16 =B1  2%  perf-profile.children.cyc=
les-pp.begin_new_exec
      2.59 =B1  2%      +0.4        2.98 =B1  3%  perf-profile.children.cyc=
les-pp.rcu_lockdep_current_cpu_online
      1.44 =B1  4%      +0.4        1.83 =B1  3%  perf-profile.children.cyc=
les-pp.match_held_lock
      0.45 =B1  7%      +0.4        0.88 =B1  5%  perf-profile.children.cyc=
les-pp._raw_spin_unlock_irqrestore
      1.54 =B1  3%      +0.4        1.97 =B1  2%  perf-profile.children.cyc=
les-pp.memcg_slab_free_hook
      3.23 =B1  3%      +0.4        3.67 =B1  4%  perf-profile.children.cyc=
les-pp.__x64_sys_exit_group
      3.23 =B1  3%      +0.4        3.67 =B1  4%  perf-profile.children.cyc=
les-pp.do_group_exit
      3.23 =B1  3%      +0.4        3.67 =B1  4%  perf-profile.children.cyc=
les-pp.do_exit
      1.01 =B1  5%      +0.4        1.46 =B1  3%  perf-profile.children.cyc=
les-pp._raw_spin_unlock
      1.90 =B1  2%      +0.4        2.35 =B1  2%  perf-profile.children.cyc=
les-pp.kmem_cache_free
      1.62 =B1  3%      +0.5        2.10 =B1  2%  perf-profile.children.cyc=
les-pp.release_pages
      1.79 =B1  2%      +0.5        2.28 =B1  2%  perf-profile.children.cyc=
les-pp.tlb_finish_mmu
      4.90 =B1  2%      +0.5        5.40        perf-profile.children.cycle=
s-pp.kmem_cache_alloc
      1.76 =B1  2%      +0.5        2.26 =B1  2%  perf-profile.children.cyc=
les-pp.tlb_flush_mmu
      4.05            +0.5        4.59 =B1  2%  perf-profile.children.cycle=
s-pp.page_remove_rmap
      1.20 =B1  3%      +0.6        1.75 =B1  3%  perf-profile.children.cyc=
les-pp.__pagevec_lru_add
      4.68 =B1  2%      +0.6        5.26        perf-profile.children.cycle=
s-pp.load_elf_binary
      4.91 =B1  2%      +0.6        5.51        perf-profile.children.cycle=
s-pp.bprm_execve
      4.72 =B1  2%      +0.6        5.32        perf-profile.children.cycle=
s-pp.exec_binprm
      5.13            +0.6        5.76 =B1  3%  perf-profile.children.cycle=
s-pp.zap_pte_range
      5.30            +0.6        5.93 =B1  3%  perf-profile.children.cycle=
s-pp.unmap_vmas
      5.24            +0.6        5.87 =B1  3%  perf-profile.children.cycle=
s-pp.unmap_page_range
      6.09 =B1  2%      +0.6        6.73        perf-profile.children.cycle=
s-pp.do_execveat_common
      6.15 =B1  2%      +0.6        6.80        perf-profile.children.cycle=
s-pp.__x64_sys_execve
      6.59 =B1  2%      +0.7        7.25        perf-profile.children.cycle=
s-pp.check_preemption_disabled
      0.17 =B1 21%      +0.7        0.86 =B1  4%  perf-profile.children.cyc=
les-pp.schedule
      0.09 =B1 10%      +0.7        0.82 =B1  4%  perf-profile.children.cyc=
les-pp.try_to_wake_up
      1.76 =B1  3%      +0.8        2.51 =B1  2%  perf-profile.children.cyc=
les-pp._raw_spin_lock
      5.65 =B1  2%      +0.8        6.41 =B1  2%  perf-profile.children.cyc=
les-pp.rcu_read_lock_held_common
      5.49            +0.8        6.27 =B1  2%  perf-profile.children.cycle=
s-pp.exit_mmap
      5.50            +0.8        6.28 =B1  2%  perf-profile.children.cycle=
s-pp.mmput
      1.00 =B1  3%      +0.8        1.81 =B1  2%  perf-profile.children.cyc=
les-pp.__mod_lruvec_page_state
      3.51 =B1  2%      +0.9        4.41        perf-profile.children.cycle=
s-pp.unmap_region
      0.29 =B1  6%      +1.0        1.25 =B1  4%  perf-profile.children.cyc=
les-pp.__mod_memcg_lruvec_state
      4.35 =B1  3%      +1.0        5.33        perf-profile.children.cycle=
s-pp.__do_munmap
      0.00            +1.0        0.98 =B1  5%  perf-profile.children.cycle=
s-pp.__queue_work
      7.13            +1.0        8.14 =B1  2%  perf-profile.children.cycle=
s-pp.do_anonymous_page
      0.00            +1.0        1.03 =B1  5%  perf-profile.children.cycle=
s-pp.queue_work_on
      5.95 =B1  2%      +1.0        7.00        perf-profile.children.cycle=
s-pp.__x64_sys_brk
      0.32 =B1  9%      +1.1        1.43 =B1  2%  perf-profile.children.cyc=
les-pp.__schedule
      0.32 =B1 17%      +1.1        1.43 =B1  4%  perf-profile.children.cyc=
les-pp.native_queued_spin_lock_slowpath
     12.31            +1.2       13.53        perf-profile.children.cycles-=
pp.__handle_mm_fault
      0.46 =B1 10%      +1.2        1.71 =B1  3%  perf-profile.children.cyc=
les-pp.do_raw_spin_lock
      0.04 =B1100%      +1.3        1.29 =B1  4%  perf-profile.children.cyc=
les-pp.cgroup_rstat_updated
      7.84 =B1  3%      +1.3        9.12 =B1  5%  perf-profile.children.cyc=
les-pp.cpuidle_enter
      7.84 =B1  3%      +1.3        9.12 =B1  6%  perf-profile.children.cyc=
les-pp.cpuidle_enter_state
      8.89            +1.4       10.25        perf-profile.children.cycles-=
pp.__lock_acquire
      9.58 =B1  2%      +1.5       11.08        perf-profile.children.cycle=
s-pp.lock_release
      8.09 =B1  5%      +1.5        9.60 =B1  8%  perf-profile.children.cyc=
les-pp.start_secondary
      0.81 =B1  7%      +1.5        2.35 =B1  2%  perf-profile.children.cyc=
les-pp._raw_spin_lock_irqsave
      0.00            +1.6        1.58 =B1  6%  perf-profile.children.cycle=
s-pp.mem_cgroup_css_rstat_flush
     16.58            +1.6       18.18        perf-profile.children.cycles-=
pp.asm_exc_page_fault
     15.80            +1.7       17.46        perf-profile.children.cycles-=
pp.do_user_addr_fault
      8.61 =B1  3%      +1.7       10.27 =B1  7%  perf-profile.children.cyc=
les-pp.secondary_startup_64_no_verify
      8.61 =B1  3%      +1.7       10.27 =B1  7%  perf-profile.children.cyc=
les-pp.cpu_startup_entry
      8.61 =B1  3%      +1.7       10.27 =B1  7%  perf-profile.children.cyc=
les-pp.do_idle
     14.31            +1.7       15.98        perf-profile.children.cycles-=
pp.handle_mm_fault
     16.01            +1.7       17.68        perf-profile.children.cycles-=
pp.exc_page_fault
      4.52            +1.7        6.22 =B1  4%  perf-profile.children.cycle=
s-pp.intel_idle
      9.80            +1.7       11.53        perf-profile.children.cycles-=
pp.lock_is_held_type
     12.58 =B1  2%      +2.1       14.70        perf-profile.children.cycle=
s-pp.rcu_read_lock_sched_held
     30.34            +2.5       32.85        perf-profile.children.cycles-=
pp.entry_SYSCALL_64_after_hwframe
     30.30            +2.5       32.82        perf-profile.children.cycles-=
pp.do_syscall_64
     17.41            +2.9       20.27        perf-profile.children.cycles-=
pp.lock_acquire
      0.00            +4.1        4.08 =B1  3%  perf-profile.children.cycle=
s-pp.cgroup_rstat_flush_locked
      0.00            +4.1        4.12 =B1  3%  perf-profile.children.cycle=
s-pp.cgroup_rstat_flush_irqsafe
      1.18 =B1 14%      +4.2        5.38 =B1  2%  perf-profile.children.cyc=
les-pp.process_one_work
      0.00            +4.3        4.31 =B1  3%  perf-profile.children.cycle=
s-pp.mem_cgroup_flush_stats
      1.19 =B1 14%      +5.0        6.15 =B1  2%  perf-profile.children.cyc=
les-pp.worker_thread
      1.44 =B1 11%      +5.0        6.45 =B1  2%  perf-profile.children.cyc=
les-pp.kthread
      1.49 =B1 11%      +5.0        6.51 =B1  2%  perf-profile.children.cyc=
les-pp.ret_from_fork
     17.68            -4.5       13.13        perf-profile.self.cycles-pp.s=
ieve
      5.91 =B1  2%      -1.6        4.31        perf-profile.self.cycles-pp=
.string_rtns_1
      3.06 =B1  3%      -0.8        2.26 =B1  2%  perf-profile.self.cycles-=
pp.add_int
      3.11 =B1  4%      -0.8        2.31 =B1  2%  perf-profile.self.cycles-=
pp.__strncat_chk
      3.00 =B1  3%      -0.8        2.21 =B1  3%  perf-profile.self.cycles-=
pp.add_long
      2.20 =B1  2%      -0.6        1.58 =B1  2%  perf-profile.self.cycles-=
pp.div_long
      1.82 =B1  3%      -0.5        1.34 =B1  2%  perf-profile.self.cycles-=
pp.__strcat_chk
      1.76 =B1  4%      -0.5        1.30 =B1  3%  perf-profile.self.cycles-=
pp.add_short
      1.12 =B1 14%      -0.4        0.72 =B1 13%  perf-profile.self.cycles-=
pp.memcpy_toio
      0.91 =B1 10%      -0.3        0.66 =B1  8%  perf-profile.self.cycles-=
pp.div_int
      0.98 =B1  4%      -0.2        0.75 =B1 10%  perf-profile.self.cycles-=
pp.div_short
      0.56 =B1  9%      -0.1        0.45 =B1  5%  perf-profile.self.cycles-=
pp.mem_rtns_1
      0.32 =B1  3%      -0.1        0.25 =B1  6%  perf-profile.self.cycles-=
pp.page_test
      0.19 =B1  8%      -0.0        0.15 =B1  6%  perf-profile.self.cycles-=
pp.malloc
      0.06 =B1 11%      +0.0        0.08 =B1 14%  perf-profile.self.cycles-=
pp.__mod_lruvec_page_state
      0.07 =B1 18%      +0.0        0.11 =B1 13%  perf-profile.self.cycles-=
pp.__mod_memcg_lruvec_state
      0.04 =B1 71%      +0.1        0.09 =B1 14%  perf-profile.self.cycles-=
pp.do_raw_spin_unlock
      0.47 =B1  6%      +0.1        0.54 =B1  5%  perf-profile.self.cycles-=
pp.lockdep_hardirqs_on_prepare
      0.00            +0.1        0.07 =B1 12%  perf-profile.self.cycles-pp=
.__schedule
      0.04 =B1100%      +0.1        0.16 =B1 12%  perf-profile.self.cycles-=
pp.cgroup_rstat_updated
      0.14 =B1  9%      +0.1        0.27 =B1  5%  perf-profile.self.cycles-=
pp.do_raw_spin_lock
      2.06 =B1  2%      +0.1        2.19 =B1  2%  perf-profile.self.cycles-=
pp.mark_lock
      0.00            +0.1        0.14 =B1  9%  perf-profile.self.cycles-pp=
._find_next_bit
      1.08 =B1  3%      +0.1        1.22 =B1  3%  perf-profile.self.cycles-=
pp.rcu_read_lock_sched_held
      1.12 =B1  3%      +0.2        1.30 =B1  3%  perf-profile.self.cycles-=
pp.validate_chain
      1.61 =B1  2%      +0.2        1.83 =B1  3%  perf-profile.self.cycles-=
pp.rcu_is_watching
      0.00            +0.3        0.27 =B1  5%  perf-profile.self.cycles-pp=
.cgroup_rstat_flush_locked
      1.83 =B1  3%      +0.3        2.10 =B1  4%  perf-profile.self.cycles-=
pp.rcu_lockdep_current_cpu_online
      1.16 =B1  3%      +0.3        1.46 =B1  2%  perf-profile.self.cycles-=
pp.match_held_lock
      2.24 =B1  2%      +0.3        2.56 =B1  2%  perf-profile.self.cycles-=
pp.lock_acquire
      2.32 =B1  3%      +0.5        2.86 =B1  2%  perf-profile.self.cycles-=
pp.lock_release
      6.17 =B1  2%      +0.6        6.77        perf-profile.self.cycles-pp=
.check_preemption_disabled
      6.33            +1.1        7.41        perf-profile.self.cycles-pp._=
_lock_acquire
      0.32 =B1 17%      +1.1        1.43 =B1  4%  perf-profile.self.cycles-=
pp.native_queued_spin_lock_slowpath
      6.20            +1.2        7.39        perf-profile.self.cycles-pp.l=
ock_is_held_type
      0.00            +1.5        1.45 =B1  7%  perf-profile.self.cycles-pp=
.mem_cgroup_css_rstat_flush
      4.52            +1.7        6.22 =B1  4%  perf-profile.self.cycles-pp=
.intel_idle


                                                                           =
    =20
                               reaim.time.user_time                        =
    =20
                                                                           =
    =20
  615 +--------------------------------------------------------------------=
-+  =20
  610 |-+   +                                                              =
 |  =20
      |     :                                                              =
 |  =20
  605 |-+  : :                                                             =
 |  =20
  600 |-+  : :                                                             =
 |  =20
  595 |-+  :  :     .+.+.+.+. .+                +  +                      +=
 |  =20
  590 |.+.:   ++.+.+         +  :.+.   .+.     + + :+   .+. .+.     +.   + =
+|  =20
      |   +                     +   +.+   +.+.+   +  +.+   +   +.+.+  +.+  =
 |  =20
  585 |-+                                                                  =
 |  =20
  580 |-+                                                                  =
 |  =20
  575 |-O O O OO O O O O O O O O                                           =
 |  =20
  570 |-+                                                                  =
 |  =20
      |                         O O           O O                          =
 |  =20
  565 |-+                           O O O O O     OO O O O                 =
 |  =20
  560 +--------------------------------------------------------------------=
-+  =20
                                                                           =
    =20
                                                                           =
                                                                           =
         =20
                       reaim.time.involuntary_context_switches             =
    =20
                                                                           =
    =20
   1e+06 +-----------------------------------------------------------------=
-+  =20
  900000 |-O OO O O O OO O O O O O                                         =
 |  =20
         |                                                                 =
 |  =20
  800000 |-+                                                               =
 |  =20
  700000 |-+                                                               =
 |  =20
         |                                                                 =
 |  =20
  600000 |-+                                                               =
 |  =20
  500000 |-+                                                               =
 |  =20
  400000 |-+                                                               =
 |  =20
         |                                                                 =
 |  =20
  300000 |-+                                                               =
 |  =20
  200000 |-+                                                               =
 |  =20
         |                                                                 =
 |  =20
  100000 |.+.++.+.+.+.++.+.+.+.+.++.+.+.+.++.+.+.+.++.+.+.+.+.++.+.+.+.++.+=
.|  =20
       0 +-----------------------------------------------------------------=
-+  =20
                                                                           =
    =20
                                                                           =
                                                                           =
         =20
                                 reaim.jobs_per_min                        =
    =20
                                                                           =
    =20
  142000 +-----------------------------------------------------------------=
-+  =20
  140000 |.+.+   .+.+. +.+. .+.+.+                                         =
 |  =20
         |    :.+     +    +     :                                         =
 |  =20
  138000 |-+  +                   :                                        =
.|  =20
  136000 |-+                      +.+.+.+.++.+.+.+.++.+.+.+.+.++.+.+.+.++.+=
 |  =20
  134000 |-+                                                               =
 |  =20
  132000 |-+                                                               =
 |  =20
         |                                                                 =
 |  =20
  130000 |-+ OO O O O OO O       O                                         =
 |  =20
  128000 |-O               O O O                                           =
 |  =20
  126000 |-+                                                               =
 |  =20
  124000 |-+                                                               =
 |  =20
         |                            O O O        OO O                    =
 |  =20
  122000 |-+                      O O      O O O O      O O                =
 |  =20
  120000 +-----------------------------------------------------------------=
-+  =20
                                                                           =
    =20
                                                                           =
                                                                           =
         =20
                             reaim.jobs_per_min_child                      =
    =20
                                                                           =
    =20
  8800 +-------------------------------------------------------------------=
-+  =20
       | +  : +    + .+.+.+.+  +                                           =
 |  =20
  8600 |-+  : :     +           :                                          =
 |  =20
       |     +                  : .+.   .+ .+.          .+. .+. .+. .+ .+. =
.|  =20
       |                         +   +.+  +   +.+.+.+.++   +   +   +  +   +=
 |  =20
  8400 |-+                                                                 =
 |  =20
       |                                                                   =
 |  =20
  8200 |-+                                                                 =
 |  =20
       |      O                                                            =
 |  =20
  8000 |-O O O  O O O O O O OO O                                           =
 |  =20
       |                                                                   =
 |  =20
       |                                                                   =
 |  =20
  7800 |-+                                                                 =
 |  =20
       |                             O O OO       O O OO                   =
 |  =20
  7600 +-------------------------------------------------------------------=
-+  =20
                                                                           =
    =20
                                                                           =
                                                                           =
         =20
                                 reaim.std_dev_time                        =
    =20
                                                                           =
    =20
  0.022 +------------------------------------------------------------------=
-+  =20
        |                                                                  =
 |  =20
   0.02 |-+                         O      O O  O       O O                =
 |  =20
        | O O O  O O O O  O O O O O  O O O     O  O O O                    =
 |  =20
        |      O         O                                                 =
 |  =20
  0.018 |-+                                                                =
 |  =20
        |                                                                  =
 |  =20
  0.016 |-+                                                                =
 |  =20
        |                                                                  =
 |  =20
  0.014 |-+                                                                =
 |  =20
        |                                                                  =
 |  =20
        |                                                                  =
 |  =20
  0.012 |-+.+.+   .+.+.   +.+.                     .+.        .+.          =
 |  =20
        |.+    +.+     +.+    +.+.+.++.+.+.+.+.++.+   +.+.++.+   +.+.++.+.+=
.|  =20
   0.01 +------------------------------------------------------------------=
-+  =20
                                                                           =
    =20
                                                                           =
                                                                           =
         =20
                               reaim.std_dev_percent                       =
    =20
                                                                           =
    =20
  2.8 +--------------------------------------------------------------------=
-+  =20
      |                                     O            O                 =
 |  =20
  2.6 |-O O O      O     O O O OO O O     O   O O O    O                   =
 |  =20
      |        O O   O O              O O          O O                     =
 |  =20
      |       O                                                            =
 |  =20
  2.4 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
  2.2 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
    2 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
      |  .+.    .+.+. .+.+.+.                                              =
 |  =20
  1.8 |.+   +.++     +       +.+                              .+.          =
 |  =20
      |                         +.+.+.+.+.+.+.+.+.++.+.+.+.+.+   +.++.+. .+=
.|  =20
  1.6 +--------------------------------------------------------------------=
-+  =20
                                                                           =
    =20
                                                                           =
                                                                           =
         =20
                               reaim.max_jobs_per_min                      =
    =20
                                                                           =
    =20
  150000 +-----------------------------------------------------------------=
-+  =20
         |                                                                 =
 |  =20
         |                                                                 =
 |  =20
  145000 |.+.+  +.+.+.  .+.+. .+.                                          =
 |  =20
         |    :+      ++     +   +                                         =
 |  =20
         |    +                   :.+.+. .++.+. .+.    .+.+.+.+ .+.+.+. +.+=
.|  =20
  140000 |-+                      +     +      +   ++.+        +       +   =
 |  =20
         |                                                                 =
 |  =20
  135000 |-+                                                               =
 |  =20
         | O OO O O O OO O O O O O                                         =
 |  =20
         |                                                                 =
 |  =20
  130000 |-+                                                               =
 |  =20
         |                            O O O        OO O                    =
 |  =20
         |                          O      O O   O      O O                =
 |  =20
  125000 +-----------------------------------------------------------------=
-+  =20
                                                                           =
    =20
                                                                           =
                                                                           =
         =20
                      perf-sched.total_wait_time.average.ms                =
    =20
                                                                           =
    =20
  70 +---------------------------------------------------------------------=
-+  =20
     |          .+          +                                              =
 |  =20
  60 |-+ +    .+ :  +.+.+  : +                                             =
 |  =20
     |+ + + .+    :+     + :  +.                                           =
 |  =20
  50 |-+   +      +       +     +.+.+.+.++.+.+.+.+.+.+.+.+.+.+.++.+.+.+.+.+=
.|  =20
     |                                                                     =
 |  =20
  40 |-+                                                                   =
 |  =20
     |                                                                     =
 |  =20
  30 |-+                                                                   =
 |  =20
     |                                                                     =
 |  =20
  20 |-+                                                                   =
 |  =20
     |                                                                     =
 |  =20
  10 |-O O O O O OO O O O O O O       O O          O O                     =
 |  =20
     |                          O O O    O O O O O     O O                 =
 |  =20
   0 +---------------------------------------------------------------------=
-+  =20
                                                                           =
    =20
                                                                           =
                                                                           =
         =20
                       perf-sched.total_sch_delay.average.ms               =
    =20
                                                                           =
    =20
   0.1 +-------------------------------------------------------------------=
-+  =20
       |          +              +.   .+.  +  +           + +         +    =
 |  =20
  0.09 |-+       + +             : +.+   ++    + .+. .++.+   +.+. .+. :+   =
 |  =20
       |. .+.+ .+   +.+. .+. +  :               +   +            +   +  +.+=
.|  =20
  0.08 |-+    +         +   + : :                                          =
 |  =20
       |                      ::                                           =
 |  =20
  0.07 |-+                     +                                           =
 |  =20
       |                                                                   =
 |  =20
  0.06 |-+                                                                 =
 |  =20
       |                                                                   =
 |  =20
  0.05 |-+                                                                 =
 |  =20
       |                                                                   =
 |  =20
  0.04 |-+                     O                                           =
 |  =20
       | O O  O O O O O O O OO   O O O O OO O O O O O OO O                 =
 |  =20
  0.03 +-------------------------------------------------------------------=
-+  =20
                                                                           =
    =20
                                                                           =
                                                                           =
         =20
                      perf-sched.total_wait_and_delay.count.ms             =
    =20
                                                                           =
    =20
  140000 +-----------------------------------------------------------------=
-+  =20
         |                          O      O O   O      O O                =
 |  =20
  120000 |-+  O     O             O   O O O    O   OO O                    =
 |  =20
         | O O        OO O O O O O                                         =
 |  =20
  100000 |-+    O O                                                        =
 |  =20
         |                                                                 =
 |  =20
   80000 |-+                                                               =
 |  =20
         |                                                                 =
 |  =20
   60000 |-+                                                               =
 |  =20
         |                                                                 =
 |  =20
   40000 |-+                                                               =
 |  =20
         |                                                                 =
 |  =20
   20000 |.+.++.     .++.   .+. .++.+.+.+.++.+.+.+.++.+.+.+.+.++.+.+.+.++.+=
.|  =20
         |      +.+.+    +.+   +                                           =
 |  =20
       0 +-----------------------------------------------------------------=
-+  =20
                                                                           =
    =20
                                                                           =
                                                                           =
         =20
                   perf-sched.total_wait_and_delay.average.ms              =
    =20
                                                                           =
    =20
  70 +---------------------------------------------------------------------=
-+  =20
     |          .+          +                                              =
 |  =20
  60 |-+ +    .+ :  +.+.+  : +                                             =
 |  =20
     |+ + + .+    :+     + :  +.                .+.                        =
 |  =20
  50 |-+   +      +       +     +.+.+.+.++.+.+.+   +.+.+.+.+.+.++.+.+.+.+.+=
.|  =20
     |                                                                     =
 |  =20
  40 |-+                                                                   =
 |  =20
     |                                                                     =
 |  =20
  30 |-+                                                                   =
 |  =20
     |                                                                     =
 |  =20
  20 |-+                                                                   =
 |  =20
     |                                                                     =
 |  =20
  10 |-O O O O O OO O O O O O O       O O          O O                     =
 |  =20
     |                          O O O    O O O O O     O O                 =
 |  =20
   0 +---------------------------------------------------------------------=
-+  =20
                                                                           =
    =20
                                                                           =
                                                                           =
         =20
          perf-sched.wait_time.avg.ms.worker_thread.kthread.ret_from_fork  =
    =20
                                                                           =
    =20
  180 +--------------------------------------------------------------------=
-+  =20
      |  .+             .+. .+.                                            =
 |  =20
  160 |.+  :  ++.+. .+.+   +   +                                           =
 |  =20
  140 |-+  : +     +            :          .+.          .+.            .+. =
.|  =20
      |     +                   +.+.+.+.+.+   +.+.++.+.+   +.+.+.+.++.+   +=
 |  =20
  120 |-+                                                                  =
 |  =20
  100 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
   80 |-+                                                                  =
 |  =20
   60 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
   40 |-+                                                                  =
 |  =20
   20 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
    0 +--------------------------------------------------------------------=
-+  =20
                                                                           =
    =20
                                                                           =
                                                                           =
         =20
         perf-sched.wait_and_delay.count.worker_thread.kthread.ret_from_for=
k   =20
                                                                           =
    =20
  90000 +------------------------------------------------------------------=
-+  =20
        |                         O OO     O O OO O     O O                =
 |  =20
  80000 |-+        O                   O O          O O                    =
 |  =20
  70000 |-O O O      O O OO O O O                                          =
 |  =20
        |      O O                                                         =
 |  =20
  60000 |-+                                                                =
 |  =20
  50000 |-+                                                                =
 |  =20
        |                                                                  =
 |  =20
  40000 |-+                                                                =
 |  =20
  30000 |-+                                                                =
 |  =20
        |                                                                  =
 |  =20
  20000 |-+                                                                =
 |  =20
  10000 |-+                                                                =
 |  =20
        |                                                                  =
 |  =20
      0 +------------------------------------------------------------------=
-+  =20
                                                                           =
    =20
                                                                           =
                                                                           =
         =20
       perf-sched.wait_and_delay.avg.ms.worker_thread.kthread.ret_from_fork=
    =20
                                                                           =
    =20
  180 +--------------------------------------------------------------------=
-+  =20
      |  .+             .+. .+.                                            =
 |  =20
  160 |.+  :  ++.+. .+.+   +   +                                           =
 |  =20
  140 |-+  : +     +            :          .+.          .+.            .+. =
.|  =20
      |     +                   +.+.+.+.+.+   +.+.++.+.+   +.+.+.+.++.+   +=
 |  =20
  120 |-+                                                                  =
 |  =20
  100 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
   80 |-+                                                                  =
 |  =20
   60 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
   40 |-+                                                                  =
 |  =20
   20 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
    0 +--------------------------------------------------------------------=
-+  =20
                                                                           =
    =20
                                                                           =
                                                                           =
         =20
                                                                           =
    =20
                                                                           =
    =20
  6000 +-------------------------------------------------------------------=
-+  =20
       |     O                         O            O                      =
 |  =20
  5000 |-+                                  O            O                 =
 |  =20
       | O          O   O O OO     O            O                          =
 |  =20
       |          O              O        O   O        O                   =
 |  =20
  4000 |-+ O                                                               =
 |  =20
       |        O     O              O   O        O   O                    =
 |  =20
  3000 |-+                     O                                           =
 |  =20
       |      O                                                            =
 |  =20
  2000 |-+                                                                 =
 |  =20
       |                                                                   =
 |  =20
       |                                                                   =
 |  =20
  1000 |-+                                                                 =
 |  =20
       |                                                                   =
 |  =20
     0 +-------------------------------------------------------------------=
-+  =20
                                                                           =
    =20
                                                                           =
                                                                           =
         =20
                                                                           =
    =20
                                                                           =
    =20
  3500 +-------------------------------------------------------------------=
-+  =20
       | O   O    O   O   O OO                                             =
 |  =20
  3000 |-+    O O       O      O   O O    O     O O    O                   =
 |  =20
       |                                    O            O                 =
 |  =20
  2500 |-+                       O       O    O       O                    =
 |  =20
       |                               O            O                      =
 |  =20
  2000 |-+                                                                 =
 |  =20
       |                                                                   =
 |  =20
  1500 |-+                                                                 =
 |  =20
       |                                                                   =
 |  =20
  1000 |-+                                                                 =
 |  =20
       |                                                                   =
 |  =20
   500 |-+                                                                 =
 |  =20
       |.+.+.++.+.+.+.+.+. .++.+.+.+.+.+.++.+.+.+.+.+.++.+.+.+.+.+.+.++.+.+=
.|  =20
     0 +-------------------------------------------------------------------=
-+  =20
                                                                           =
    =20
                                                                           =
                                                                           =
         =20
                                                                           =
    =20
                                                                           =
    =20
  1800 +-------------------------------------------------------------------=
-+  =20
       |              O                                                    =
 |  =20
  1600 |-+   O            O O                                              =
 |  =20
  1400 |-O O      O O   O    O O   O        O   O        O                 =
 |  =20
       |      O                  O   O O OO   O   O O OO                   =
 |  =20
  1200 |-+      O                                                          =
 |  =20
  1000 |-+                                                                 =
 |  =20
       |                                                                   =
 |  =20
   800 |-+                                                                 =
 |  =20
   600 |-+                                                                 =
 |  =20
       |                                                                   =
 |  =20
   400 |-+                                                                 =
 |  =20
   200 |-+                                                                 =
 |  =20
       |.+.+.++.+.+.+.+.+.+.++.+.+.+.+.+.++.+.+.+.+.+.++.+.+.+.+.+.+.++.+.+=
.|  =20
     0 +-------------------------------------------------------------------=
-+  =20
                                                                           =
    =20
                                                                           =
                                                                           =
         =20
                                                                           =
    =20
                                                                           =
    =20
  70 +---------------------------------------------------------------------=
-+  =20
  65 |-+                          O O          O O                         =
 |  =20
     |     O      O             O     O  O O O     O   O O                 =
 |  =20
  60 |-O O       O          O                                              =
 |  =20
  55 |-+     O O    O O O O   O         O            O                     =
 |  =20
     |                                                                     =
 |  =20
  50 |-+                                                                   =
 |  =20
  45 |-+                                                                   =
 |  =20
  40 |-+                                                                   =
 |  =20
     |                                                                     =
 |  =20
  35 |-+                                                                   =
 |  =20
  30 |-+                                                  .+.   +.         =
 |  =20
     |.+. .+.     +.           .+. .+.+. +.+. .+.+.+.+. .+   +.+  +.+. .+. =
.|  =20
  25 |-+ +   +.+.+  +.+.+.+.+.+   +     +    +         +              +   +=
 |  =20
  20 +---------------------------------------------------------------------=
-+  =20
                                                                           =
    =20
                                                                           =
                                                                           =
         =20
                                                                           =
    =20
                                                                           =
    =20
  1.4 +--------------------------------------------------------------------=
-+  =20
      |                                                                    =
 |  =20
  1.2 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
    1 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
  0.8 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
  0.6 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
  0.4 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
  0.2 |-+                                                                  =
 |  =20
      |    O      .+  O         O              O                  O        =
 |  =20
    0 +--------------------------------------------------------------------=
-+  =20
                                                                           =
    =20
                                                                           =
                                                                           =
         =20
                                                                           =
    =20
                                                                           =
    =20
  1.2 +--------------------------------------------------------------------=
-+  =20
      |                           O                                        =
 |  =20
    1 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
      |                                                                    =
 |  =20
  0.8 |-+             O                                                    =
 |  =20
      |                                                                    =
 |  =20
  0.6 |-+                                                                  =
 |  =20
      |                                           O                O       =
 |  =20
  0.4 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
      |                                                                    =
 |  =20
  0.2 |-+                                                                  =
 |  =20
      |                             O                                      =
 |  =20
    0 +--------------------------------------------------------------------=
-+  =20
                                                                           =
    =20
                                                                           =
                                                                           =
         =20
                                                                           =
    =20
                                                                           =
    =20
  0.14 +-------------------------------------------------------------------=
-+  =20
       |                                                                   =
 |  =20
  0.12 |-+                                                                 =
 |  =20
       |                                                                   =
 |  =20
   0.1 |-+                                                                 =
 |  =20
       |                                                                   =
 |  =20
  0.08 |-+                                                                 =
:|  =20
       |                                                                   =
:|  =20
  0.06 |-+                                                                 =
:|  =20
       |                                                                   =
:|  =20
  0.04 |-O                                                                 =
:|  =20
       |   O     O                          O             O                =
:|  =20
  0.02 |-+         O O O O O O   O     O              O                   :=
 |  =20
       |     O O               O   O O    O   O   O O   O   O             :=
 |  =20
     0 +-------------------------------------------------------------------=
-+  =20
                                                                           =
    =20
                                                                           =
                                                                           =
         =20
                                                                           =
    =20
                                                                           =
    =20
  1.2 +--------------------------------------------------------------------=
-+  =20
      |                              O                                     =
 |  =20
    1 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
      |                                                                    =
 |  =20
  0.8 |-+                               O                                  =
 |  =20
      |                                                                    =
 |  =20
  0.6 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
  0.4 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
      |                                                                    =
 |  =20
  0.2 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
    0 +--------------------------------------------------------------------=
-+  =20
                                                                           =
    =20
                                                                           =
                                                                           =
         =20
                                                                           =
    =20
                                                                           =
    =20
    3 +--------------------------------------------------------------------=
-+  =20
      |  O                                                                 =
 |  =20
  2.5 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
      |                                                                    =
 |  =20
    2 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
  1.5 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
    1 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
      |                                                                    =
 |  =20
  0.5 |-+                                                                  =
 |  =20
      |                                                                    =
 |  =20
    0 +--------------------------------------------------------------------=
-+  =20
                                                                           =
    =20
                                                                           =
    =20
[*] bisect-good sample
[O] bisect-bad  sample

***************************************************************************=
************************
lkp-cfl-e1: 16 threads 1 sockets Intel(R) Xeon(R) E-2278G CPU @ 3.40GHz wit=
h 32G memory
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
compiler/cpufreq_governor/kconfig/nr_task/rootfs/runtime/tbox_group/test/te=
stcase/ucode:
  gcc-9/performance/x86_64-rhel-8.3/100%/debian-10.4-x86_64-20200603.cgz/30=
0s/lkp-cfl-e1/new_fserver/reaim/0xde

commit:=20
  0c7c5da68b ("memcg: switch lruvec stats to rstat")
  cda0d20525 ("memcg: infrastructure to flush memcg stats")

0c7c5da68b4a09ff cda0d205259a7e7c1f8e296130a=20
---------------- ---------------------------=20
         %stddev     %change         %stddev
             \          |                \ =20
      7.99            +1.2%       8.09        reaim.child_systime
      3.26            -1.7%       3.20        reaim.child_utime
    121091            -9.5%     109580        reaim.jobs_per_min
      7568            -9.5%       6848        reaim.jobs_per_min_child
    123789            -8.4%     113349        reaim.max_jobs_per_min
      0.78           +10.6%       0.86        reaim.parent_time
      1.04           +83.8%       1.91        reaim.std_dev_percent
      0.01           +65.8%       0.02        reaim.std_dev_time
    133153          +527.8%     835973        reaim.time.involuntary_contex=
t_switches
      8602           -12.8%       7502        reaim.time.major_page_faults
  16988615            -2.9%   16491812        reaim.time.minor_page_faults
    398.33            -2.5%     388.29        reaim.time.percent_of_cpu_thi=
s_job_got
    858.75            -1.7%     843.93        reaim.time.system_time
    348.24            -4.5%     332.44        reaim.time.user_time
    387134            +4.7%     405213        reaim.time.voluntary_context_=
switches
    170666            -2.9%     165714        reaim.workload
   4180544 =B1  3%     +75.6%    7340133 =B1 24%  cpuidle..usage
      0.00 =B1 42%      +0.0        0.02 =B1109%  mpstat.cpu.all.iowait%
     55207 =B1  3%      -7.3%      51204 =B1  3%  softirqs.CPU8.NET_RX
     36.52            +3.6%      37.86        boot-time.boot
     11.58            +1.5%      11.75        boot-time.dhcp
      3985          +384.8%      19324        vmstat.system.cs
     21914 =B1  2%     +33.7%      29299 =B1 16%  vmstat.system.in
     28464 =B1  2%     +85.3%      52734 =B1  7%  meminfo.Active
     28304 =B1  2%     +84.7%      52277 =B1  8%  meminfo.Active(anon)
     37567           +67.6%      62971 =B1  6%  meminfo.Shmem
      2909 =B1  3%     -14.5%       2489 =B1  3%  slabinfo.cred_jar.active_=
objs
      2909 =B1  3%     -14.5%       2489 =B1  3%  slabinfo.cred_jar.num_objs
      3454 =B1  4%     -10.0%       3110 =B1  3%  slabinfo.kmalloc-256.acti=
ve_objs
      3458 =B1  4%     -10.1%       3110 =B1  3%  slabinfo.kmalloc-256.num_=
objs
      2242 =B1  5%     -17.4%       1853 =B1  5%  slabinfo.kmalloc-rcl-256.=
active_objs
      2309 =B1  5%     -17.0%       1918 =B1  5%  slabinfo.kmalloc-rcl-256.=
num_objs
      1264 =B1  6%     -18.5%       1030 =B1  3%  slabinfo.pid.active_objs
      1264 =B1  6%     -18.5%       1030 =B1  3%  slabinfo.pid.num_objs
      1323 =B1  5%     -18.6%       1077 =B1  3%  slabinfo.task_delay_info.=
active_objs
      1323 =B1  5%     -18.6%       1077 =B1  3%  slabinfo.task_delay_info.=
num_objs
      7105 =B1  2%     +84.0%      13071 =B1  8%  proc-vmstat.nr_active_anon
    597622            +1.1%     604120        proc-vmstat.nr_file_pages
      8026            +3.7%       8325        proc-vmstat.nr_mapped
      9395           +67.6%      15749 =B1  6%  proc-vmstat.nr_shmem
      7105 =B1  2%     +84.0%      13071 =B1  8%  proc-vmstat.nr_zone_activ=
e_anon
  13394184            -2.6%   13042821        proc-vmstat.numa_hit
  13394184            -2.6%   13042821        proc-vmstat.numa_local
     63852           +24.3%      79392 =B1  3%  proc-vmstat.pgactivate
  14095860            -2.9%   13688343        proc-vmstat.pgalloc_normal
  17475839            -2.8%   16985166        proc-vmstat.pgfault
  14070144            -3.0%   13646066        proc-vmstat.pgfree
   1782101            -3.0%    1729290        proc-vmstat.pgreuse
     77684 =B1 98%   +2574.2%    2077436 =B1 48%  turbostat.C1
      0.05 =B1 40%      +1.7        1.75 =B1 56%  turbostat.C1%
    341592 =B1 41%    +252.7%    1204679 =B1 36%  turbostat.C1E
      0.58 =B1 37%      +1.2        1.75 =B1 40%  turbostat.C1E%
    134873 =B1 72%     -74.8%      34048 =B1131%  turbostat.C8
      2.65 =B1 73%      -2.0        0.64 =B1131%  turbostat.C8%
      0.05 =B1 20%    +989.8%       0.51 =B1 80%  turbostat.CPU%c3
      1.60 =B1 80%     -79.2%       0.33 =B1150%  turbostat.CPU%c7
     37.60            +7.9%      40.56 =B1  2%  turbostat.CorWatt
   6681937           +34.0%    8953217 =B1 16%  turbostat.IRQ
     11.48 =B1  4%     -13.2%       9.96 =B1 10%  turbostat.Pkg%pc2
     36.67           -11.0%      32.65 =B1 11%  turbostat.Pkg%pc3
     38.03            +7.8%      41.00 =B1  2%  turbostat.PkgWatt
  4.34e+09            +6.1%  4.604e+09        perf-stat.i.branch-instructio=
ns
  26075142           +13.8%   29666013        perf-stat.i.branch-misses
      2.63 =B1  2%      -0.4        2.24        perf-stat.i.cache-miss-rate%
 1.968e+08           +24.3%  2.445e+08        perf-stat.i.cache-references
      3986          +386.3%      19385        perf-stat.i.context-switches
      1.18            -2.9%       1.15        perf-stat.i.cpi
 1.917e+10            +4.2%  1.997e+10        perf-stat.i.cpu-cycles
    533.29           +99.9%       1066        perf-stat.i.cpu-migrations
      3085 =B1  2%      +5.1%       3243        perf-stat.i.cycles-between-=
cache-misses
      0.06 =B1  2%      -0.0        0.06        perf-stat.i.dTLB-load-miss-=
rate%
 5.264e+09            +6.1%  5.584e+09        perf-stat.i.dTLB-loads
 2.789e+09            +4.0%  2.901e+09        perf-stat.i.dTLB-stores
     72.39            -6.3       66.12 =B1  3%  perf-stat.i.iTLB-load-miss-=
rate%
    378101           +30.7%     494297 =B1  6%  perf-stat.i.iTLB-loads
 2.105e+10            +5.1%  2.212e+10        perf-stat.i.instructions
      0.92            +2.1%       0.94        perf-stat.i.ipc
     28.63           -12.8%      24.97        perf-stat.i.major-faults
      1.20            +4.2%       1.25        perf-stat.i.metric.GHz
    139.31            +6.4%     148.22        perf-stat.i.metric.K/sec
    787.04            +5.2%     828.12        perf-stat.i.metric.M/sec
     56273            -2.8%      54676        perf-stat.i.minor-faults
     56302            -2.8%      54701        perf-stat.i.page-faults
      9.35           +18.3%      11.06        perf-stat.overall.MPKI
      0.60            +0.0        0.64        perf-stat.overall.branch-miss=
-rate%
      2.79            -0.5        2.27        perf-stat.overall.cache-miss-=
rate%
      3489            +3.2%       3600        perf-stat.overall.cycles-betw=
een-cache-misses
      0.01            -0.0        0.01 =B1  3%  perf-stat.overall.dTLB-load=
-miss-rate%
      0.01            -0.0        0.00        perf-stat.overall.dTLB-store-=
miss-rate%
     70.11            -5.7       64.38        perf-stat.overall.iTLB-load-m=
iss-rate%
     23728            +4.6%      24813 =B1  3%  perf-stat.overall.instructi=
ons-per-iTLB-miss
  37316899            +8.3%   40412939        perf-stat.overall.path-length
 4.328e+09            +6.1%  4.591e+09        perf-stat.ps.branch-instructi=
ons
  26003309           +13.8%   29583403        perf-stat.ps.branch-misses
 1.962e+08           +24.3%  2.438e+08        perf-stat.ps.cache-references
      3974          +386.3%      19331        perf-stat.ps.context-switches
 1.911e+10            +4.2%  1.991e+10        perf-stat.ps.cpu-cycles
    532.01           +99.9%       1063        perf-stat.ps.cpu-migrations
  5.25e+09            +6.1%  5.568e+09        perf-stat.ps.dTLB-loads
 2.781e+09            +4.0%  2.893e+09        perf-stat.ps.dTLB-stores
    377084           +30.7%     492966 =B1  6%  perf-stat.ps.iTLB-loads
 2.099e+10            +5.1%  2.206e+10        perf-stat.ps.instructions
     28.55           -12.8%      24.91        perf-stat.ps.major-faults
     56125            -2.8%      54533        perf-stat.ps.minor-faults
     56153            -2.8%      54558        perf-stat.ps.page-faults
 6.369e+12            +5.2%  6.697e+12        perf-stat.total.instructions
     33001 =B1  5%    +333.4%     143034 =B1  2%  interrupts.CAL:Function_c=
all_interrupts
      2974 =B1 54%    +207.0%       9132 =B1  7%  interrupts.CPU0.CAL:Funct=
ion_call_interrupts
      2969 =B1  2%   +1363.9%      43462 =B1  3%  interrupts.CPU0.RES:Resch=
eduling_interrupts
     21.83 =B1 22%   +1446.1%     337.57 =B1  7%  interrupts.CPU0.TLB:TLB_s=
hootdowns
      2239 =B1 44%    +300.7%       8974 =B1  3%  interrupts.CPU1.CAL:Funct=
ion_call_interrupts
      2965 =B1  2%   +1378.5%      43847 =B1  4%  interrupts.CPU1.RES:Resch=
eduling_interrupts
     25.67 =B1 14%   +1200.2%     333.71 =B1  5%  interrupts.CPU1.TLB:TLB_s=
hootdowns
      2677 =B1 53%    +224.5%       8687 =B1 13%  interrupts.CPU10.CAL:Func=
tion_call_interrupts
      2960         +1369.3%      43490 =B1  3%  interrupts.CPU10.RES:Resche=
duling_interrupts
     21.17 =B1 21%   +1474.6%     333.29 =B1  3%  interrupts.CPU10.TLB:TLB_=
shootdowns
      2899 =B1 41%    +192.4%       8479 =B1  9%  interrupts.CPU11.CAL:Func=
tion_call_interrupts
      2895 =B1 29%     +34.8%       3902 =B1  4%  interrupts.CPU11.NMI:Non-=
maskable_interrupts
      2895 =B1 29%     +34.8%       3902 =B1  4%  interrupts.CPU11.PMI:Perf=
ormance_monitoring_interrupts
      2955 =B1  2%   +1382.3%      43803 =B1  2%  interrupts.CPU11.RES:Resc=
heduling_interrupts
     23.50 =B1 17%   +1331.6%     336.43 =B1  5%  interrupts.CPU11.TLB:TLB_=
shootdowns
      1597 =B1 30%    +456.0%       8882 =B1  7%  interrupts.CPU12.CAL:Func=
tion_call_interrupts
      2949         +1365.1%      43212 =B1  2%  interrupts.CPU12.RES:Resche=
duling_interrupts
     23.33 =B1 14%   +1335.1%     334.86 =B1  4%  interrupts.CPU12.TLB:TLB_=
shootdowns
      2284 =B1 35%    +316.9%       9522 =B1 10%  interrupts.CPU13.CAL:Func=
tion_call_interrupts
      2865 =B1 26%     +34.1%       3841 =B1  5%  interrupts.CPU13.NMI:Non-=
maskable_interrupts
      2865 =B1 26%     +34.1%       3841 =B1  5%  interrupts.CPU13.PMI:Perf=
ormance_monitoring_interrupts
      2947         +1376.6%      43523 =B1  2%  interrupts.CPU13.RES:Resche=
duling_interrupts
     24.50 =B1 21%   +1326.2%     349.43 =B1  5%  interrupts.CPU13.TLB:TLB_=
shootdowns
      1620 =B1 17%    +433.1%       8639 =B1  5%  interrupts.CPU14.CAL:Func=
tion_call_interrupts
      2946 =B1  2%   +1385.4%      43772 =B1  2%  interrupts.CPU14.RES:Resc=
heduling_interrupts
     23.33 =B1 18%   +1385.3%     346.57 =B1  7%  interrupts.CPU14.TLB:TLB_=
shootdowns
      1576 =B1 20%    +486.0%       9235 =B1  9%  interrupts.CPU15.CAL:Func=
tion_call_interrupts
      2950 =B1  2%   +1360.2%      43077 =B1  4%  interrupts.CPU15.RES:Resc=
heduling_interrupts
     22.83 =B1  9%   +1421.0%     347.29 =B1  3%  interrupts.CPU15.TLB:TLB_=
shootdowns
      1797 =B1 45%    +392.3%       8846 =B1  4%  interrupts.CPU2.CAL:Funct=
ion_call_interrupts
      2909 =B1  3%   +1414.7%      44071        interrupts.CPU2.RES:Resched=
uling_interrupts
     25.17 =B1 10%   +1177.8%     321.57 =B1  4%  interrupts.CPU2.TLB:TLB_s=
hootdowns
      1569 =B1 24%    +473.5%       8998 =B1  6%  interrupts.CPU3.CAL:Funct=
ion_call_interrupts
      3174 =B1 20%     +23.1%       3908 =B1  4%  interrupts.CPU3.NMI:Non-m=
askable_interrupts
      3174 =B1 20%     +23.1%       3908 =B1  4%  interrupts.CPU3.PMI:Perfo=
rmance_monitoring_interrupts
      3013         +1343.3%      43492        interrupts.CPU3.RES:Reschedul=
ing_interrupts
     26.00 =B1 14%   +1180.8%     333.00 =B1  6%  interrupts.CPU3.TLB:TLB_s=
hootdowns
      1620 =B1 13%    +429.6%       8581 =B1  5%  interrupts.CPU4.CAL:Funct=
ion_call_interrupts
      2878 =B1 27%     +33.5%       3842 =B1  4%  interrupts.CPU4.NMI:Non-m=
askable_interrupts
      2878 =B1 27%     +33.5%       3842 =B1  4%  interrupts.CPU4.PMI:Perfo=
rmance_monitoring_interrupts
      2933 =B1  2%   +1398.8%      43966 =B1  2%  interrupts.CPU4.RES:Resch=
eduling_interrupts
     20.67 =B1 24%   +1498.8%     330.43 =B1  5%  interrupts.CPU4.TLB:TLB_s=
hootdowns
      2286 =B1 56%    +280.6%       8703 =B1  5%  interrupts.CPU5.CAL:Funct=
ion_call_interrupts
      2975 =B1  2%   +1373.5%      43848 =B1  3%  interrupts.CPU5.RES:Resch=
eduling_interrupts
     23.50 =B1  8%   +1334.7%     337.14 =B1  8%  interrupts.CPU5.TLB:TLB_s=
hootdowns
      1447 =B1 15%    +523.4%       9022 =B1  4%  interrupts.CPU6.CAL:Funct=
ion_call_interrupts
      2917 =B1  3%   +1401.5%      43802 =B1  2%  interrupts.CPU6.RES:Resch=
eduling_interrupts
     22.17 =B1 10%   +1459.0%     345.57 =B1  5%  interrupts.CPU6.TLB:TLB_s=
hootdowns
      2405 =B1 17%    +291.3%       9412 =B1  4%  interrupts.CPU7.CAL:Funct=
ion_call_interrupts
      3094 =B1  2%   +1319.7%      43934 =B1  2%  interrupts.CPU7.RES:Resch=
eduling_interrupts
     23.00 =B1 17%   +1322.4%     327.14 =B1  3%  interrupts.CPU7.TLB:TLB_s=
hootdowns
      1933 =B1 39%    +369.4%       9074 =B1  7%  interrupts.CPU8.CAL:Funct=
ion_call_interrupts
      3010 =B1  2%   +1374.6%      44387 =B1  3%  interrupts.CPU8.RES:Resch=
eduling_interrupts
     24.17 =B1 20%   +1241.3%     324.14 =B1  3%  interrupts.CPU8.TLB:TLB_s=
hootdowns
      2072 =B1 15%    +326.6%       8840 =B1  6%  interrupts.CPU9.CAL:Funct=
ion_call_interrupts
      2955         +1383.1%      43828 =B1  2%  interrupts.CPU9.RES:Resched=
uling_interrupts
     25.33 =B1 19%   +1222.9%     335.14 =B1  4%  interrupts.CPU9.TLB:TLB_s=
hootdowns
     48547 =B1  8%     +17.3%      56951 =B1  7%  interrupts.NMI:Non-maskab=
le_interrupts
     48547 =B1  8%     +17.3%      56951 =B1  7%  interrupts.PMI:Performanc=
e_monitoring_interrupts
     47453         +1374.1%     699520        interrupts.RES:Rescheduling_i=
nterrupts
    376.17 =B1  7%   +1328.4%       5373        interrupts.TLB:TLB_shootdow=
ns
      5.54 =B1  3%      -0.9        4.59 =B1  5%  perf-profile.calltrace.cy=
cles-pp.__x64_sys_getdents64.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5.53 =B1  3%      -0.9        4.58 =B1  5%  perf-profile.calltrace.cy=
cles-pp.iterate_dir.__x64_sys_getdents64.do_syscall_64.entry_SYSCALL_64_aft=
er_hwframe
      5.44 =B1  3%      -0.9        4.52 =B1  5%  perf-profile.calltrace.cy=
cles-pp.dcache_readdir.iterate_dir.__x64_sys_getdents64.do_syscall_64.entry=
_SYSCALL_64_after_hwframe
      5.23 =B1  3%      -0.9        4.34 =B1  5%  perf-profile.calltrace.cy=
cles-pp.scan_positives.dcache_readdir.iterate_dir.__x64_sys_getdents64.do_s=
yscall_64
      3.16 =B1 10%      -0.8        2.37 =B1 11%  perf-profile.calltrace.cy=
cles-pp.write
      3.13 =B1 10%      -0.8        2.35 =B1 11%  perf-profile.calltrace.cy=
cles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.write
      3.14 =B1 10%      -0.8        2.35 =B1 11%  perf-profile.calltrace.cy=
cles-pp.entry_SYSCALL_64_after_hwframe.write
      3.04 =B1 10%      -0.8        2.27 =B1 12%  perf-profile.calltrace.cy=
cles-pp.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe.write
      3.02 =B1 10%      -0.8        2.26 =B1 12%  perf-profile.calltrace.cy=
cles-pp.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe.w=
rite
      2.88 =B1  4%      -0.6        2.30 =B1  9%  perf-profile.calltrace.cy=
cles-pp.new_sync_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_=
after_hwframe
      2.03 =B1 10%      -0.5        1.51 =B1  6%  perf-profile.calltrace.cy=
cles-pp.div_long
      2.11 =B1  8%      -0.5        1.63 =B1  4%  perf-profile.calltrace.cy=
cles-pp.add_int.add_int
      0.90 =B1 13%      -0.4        0.45 =B1 67%  perf-profile.calltrace.cy=
cles-pp.devkmsg_write.cold.new_sync_write.vfs_write.ksys_write.do_syscall_64
      0.90 =B1 13%      -0.4        0.45 =B1 67%  perf-profile.calltrace.cy=
cles-pp.devkmsg_emit.devkmsg_write.cold.new_sync_write.vfs_write.ksys_write
      0.75 =B1 21%      -0.4        0.31 =B1 86%  perf-profile.calltrace.cy=
cles-pp.terminate_walk.path_openat.do_filp_open.do_sys_openat2.do_sys_open
      0.90 =B1 13%      -0.4        0.45 =B1 67%  perf-profile.calltrace.cy=
cles-pp.vprintk_emit.devkmsg_emit.devkmsg_write.cold.new_sync_write.vfs_wri=
te
      1.77 =B1  7%      -0.4        1.34 =B1  6%  perf-profile.calltrace.cy=
cles-pp.kill
      1.76 =B1  7%      -0.4        1.33 =B1  6%  perf-profile.calltrace.cy=
cles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.kill
      1.76 =B1  7%      -0.4        1.33 =B1  6%  perf-profile.calltrace.cy=
cles-pp.entry_SYSCALL_64_after_hwframe.kill
      5.86 =B1  3%      -0.4        5.47 =B1  2%  perf-profile.calltrace.cy=
cles-pp.zap_pte_range.unmap_page_range.unmap_vmas.exit_mmap.mmput
      9.51 =B1  2%      -0.4        9.15 =B1  3%  perf-profile.calltrace.cy=
cles-pp.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64
      9.52 =B1  2%      -0.4        9.16 =B1  3%  perf-profile.calltrace.cy=
cles-pp.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL=
_64_after_hwframe
      0.68 =B1 12%      -0.4        0.33 =B1 88%  perf-profile.calltrace.cy=
cles-pp.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe.read
      1.59 =B1  7%      -0.3        1.25 =B1  8%  perf-profile.calltrace.cy=
cles-pp.__strcat_chk
      4.13 =B1  2%      -0.3        3.79 =B1  2%  perf-profile.calltrace.cy=
cles-pp.lock_page_memcg.page_remove_rmap.zap_pte_range.unmap_page_range.unm=
ap_vmas
      2.10 =B1  5%      -0.3        1.78 =B1  2%  perf-profile.calltrace.cy=
cles-pp.unmap_page_range.unmap_vmas.exit_mmap.mmput.begin_new_exec
      2.11 =B1  5%      -0.3        1.79 =B1  2%  perf-profile.calltrace.cy=
cles-pp.unmap_vmas.exit_mmap.mmput.begin_new_exec.load_elf_binary
      2.12 =B1  3%      -0.3        1.81 =B1  6%  perf-profile.calltrace.cy=
cles-pp.dput.scan_positives.dcache_readdir.iterate_dir.__x64_sys_getdents64
      1.19 =B1  8%      -0.3        0.89 =B1  4%  perf-profile.calltrace.cy=
cles-pp.do_open.path_openat.do_filp_open.do_sys_openat2.do_sys_open
      0.59 =B1  7%      -0.3        0.30 =B1 86%  perf-profile.calltrace.cy=
cles-pp.__fput.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user=
_mode.do_syscall_64
      1.03 =B1 12%      -0.3        0.75 =B1 10%  perf-profile.calltrace.cy=
cles-pp.drm_fb_helper_damage_work.process_one_work.worker_thread.kthread.re=
t_from_fork
      1.15 =B1  7%      -0.3        0.87 =B1  5%  perf-profile.calltrace.cy=
cles-pp.__x64_sys_kill.do_syscall_64.entry_SYSCALL_64_after_hwframe.kill
      1.00 =B1 12%      -0.3        0.73 =B1 10%  perf-profile.calltrace.cy=
cles-pp.memcpy_toio.drm_fb_helper_damage_work.process_one_work.worker_threa=
d.kthread
      4.40 =B1  3%      -0.3        4.15 =B1  2%  perf-profile.calltrace.cy=
cles-pp.page_remove_rmap.zap_pte_range.unmap_page_range.unmap_vmas.exit_mmap
      1.06 =B1  7%      -0.2        0.81 =B1  4%  perf-profile.calltrace.cy=
cles-pp.kill_proc_info.__x64_sys_kill.do_syscall_64.entry_SYSCALL_64_after_=
hwframe.kill
      1.16 =B1  9%      -0.2        0.91 =B1  3%  perf-profile.calltrace.cy=
cles-pp.add_short.add_short
      1.20 =B1  8%      -0.2        0.95 =B1  7%  perf-profile.calltrace.cy=
cles-pp.__close
      1.16 =B1  8%      -0.2        0.92 =B1  7%  perf-profile.calltrace.cy=
cles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__close
      1.16 =B1  8%      -0.2        0.92 =B1  7%  perf-profile.calltrace.cy=
cles-pp.entry_SYSCALL_64_after_hwframe.__close
      0.99 =B1  7%      -0.2        0.76 =B1  4%  perf-profile.calltrace.cy=
cles-pp.kill_pid_info.kill_proc_info.__x64_sys_kill.do_syscall_64.entry_SYS=
CALL_64_after_hwframe
      0.84 =B1 11%      -0.2        0.62 =B1 10%  perf-profile.calltrace.cy=
cles-pp.div_int
      0.94 =B1  8%      -0.2        0.75 =B1  7%  perf-profile.calltrace.cy=
cles-pp.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwfr=
ame.__close
      0.65 =B1  5%      -0.2        0.46 =B1 41%  perf-profile.calltrace.cy=
cles-pp.lock_release._raw_spin_unlock.scan_positives.dcache_readdir.iterate=
_dir
      1.21 =B1  3%      -0.2        1.03 =B1  6%  perf-profile.calltrace.cy=
cles-pp.elf_map.load_elf_binary.exec_binprm.bprm_execve.do_execveat_common
      1.18 =B1  3%      -0.2        1.01 =B1  8%  perf-profile.calltrace.cy=
cles-pp.lockref_put_or_lock.dput.scan_positives.dcache_readdir.iterate_dir
      1.18 =B1  6%      -0.2        1.01 =B1  5%  perf-profile.calltrace.cy=
cles-pp.copy_strings.do_execveat_common.__x64_sys_execve.do_syscall_64.entr=
y_SYSCALL_64_after_hwframe
      2.40 =B1  2%      -0.2        2.24 =B1  2%  perf-profile.calltrace.cy=
cles-pp.lock_acquire.lock_page_memcg.page_remove_rmap.zap_pte_range.unmap_p=
age_range
      0.63 =B1  5%      -0.2        0.48 =B1 41%  perf-profile.calltrace.cy=
cles-pp.lock_acquire._raw_spin_lock_nested.scan_positives.dcache_readdir.it=
erate_dir
      0.80 =B1 10%      -0.1        0.65 =B1  9%  perf-profile.calltrace.cy=
cles-pp.do_unlinkat.do_syscall_64.entry_SYSCALL_64_after_hwframe.unlink
      0.99 =B1  4%      -0.1        0.85 =B1  6%  perf-profile.calltrace.cy=
cles-pp.vm_mmap_pgoff.elf_map.load_elf_binary.exec_binprm.bprm_execve
      0.78 =B1  4%      -0.1        0.66 =B1  6%  perf-profile.calltrace.cy=
cles-pp._raw_spin_unlock.scan_positives.dcache_readdir.iterate_dir.__x64_sy=
s_getdents64
      0.89 =B1  5%      -0.1        0.76 =B1  6%  perf-profile.calltrace.cy=
cles-pp.do_mmap.vm_mmap_pgoff.elf_map.load_elf_binary.exec_binprm
      0.88 =B1  5%      -0.1        0.75 =B1  6%  perf-profile.calltrace.cy=
cles-pp.mmap_region.do_mmap.vm_mmap_pgoff.elf_map.load_elf_binary
      2.04 =B1  2%      -0.1        1.93 =B1  3%  perf-profile.calltrace.cy=
cles-pp.lock_page_memcg.page_add_file_rmap.do_set_pte.filemap_map_pages.do_=
fault
      0.73 =B1  4%      -0.1        0.62 =B1  7%  perf-profile.calltrace.cy=
cles-pp._raw_spin_lock.lockref_put_or_lock.dput.scan_positives.dcache_readd=
ir
      0.66 =B1  5%      -0.1        0.56 =B1  6%  perf-profile.calltrace.cy=
cles-pp.lock_acquire._raw_spin_lock.lockref_put_or_lock.dput.scan_positives
      0.66 =B1  5%      -0.1        0.57 =B1  6%  perf-profile.calltrace.cy=
cles-pp._raw_spin_lock_nested.scan_positives.dcache_readdir.iterate_dir.__x=
64_sys_getdents64
      0.69 =B1  2%      -0.1        0.61 =B1  9%  perf-profile.calltrace.cy=
cles-pp._raw_spin_lock.scan_positives.dcache_readdir.iterate_dir.__x64_sys_=
getdents64
      0.00            +0.5        0.53 =B1  3%  perf-profile.calltrace.cycl=
es-pp.__schedule.schedule.worker_thread.kthread.ret_from_fork
      0.00            +0.6        0.55 =B1  3%  perf-profile.calltrace.cycl=
es-pp.schedule.worker_thread.kthread.ret_from_fork
      0.00            +0.7        0.74 =B1  4%  perf-profile.calltrace.cycl=
es-pp.lock_acquire.cgroup_rstat_flush_locked.cgroup_rstat_flush_irqsafe.mem=
_cgroup_flush_stats.process_one_work
      0.00            +1.5        1.50 =B1  3%  perf-profile.calltrace.cycl=
es-pp.mem_cgroup_css_rstat_flush.cgroup_rstat_flush_locked.cgroup_rstat_flu=
sh_irqsafe.mem_cgroup_flush_stats.process_one_work
      6.91            +1.9        8.80 =B1  4%  perf-profile.calltrace.cycl=
es-pp.cpuidle_enter_state.cpuidle_enter.do_idle.cpu_startup_entry.start_sec=
ondary
      6.96            +1.9        8.86 =B1  4%  perf-profile.calltrace.cycl=
es-pp.cpuidle_enter.do_idle.cpu_startup_entry.start_secondary.secondary_sta=
rtup_64_no_verify
      4.22 =B1  2%      +2.0        6.18 =B1  4%  perf-profile.calltrace.cy=
cles-pp.intel_idle.cpuidle_enter_state.cpuidle_enter.do_idle.cpu_startup_en=
try
      7.66            +2.4       10.02 =B1  5%  perf-profile.calltrace.cycl=
es-pp.do_idle.cpu_startup_entry.start_secondary.secondary_startup_64_no_ver=
ify
      7.66            +2.4       10.03 =B1  5%  perf-profile.calltrace.cycl=
es-pp.cpu_startup_entry.start_secondary.secondary_startup_64_no_verify
      7.66            +2.4       10.03 =B1  5%  perf-profile.calltrace.cycl=
es-pp.start_secondary.secondary_startup_64_no_verify
      8.19            +2.5       10.65 =B1  5%  perf-profile.calltrace.cycl=
es-pp.secondary_startup_64_no_verify
      0.00            +3.8        3.80        perf-profile.calltrace.cycles=
-pp.cgroup_rstat_flush_locked.cgroup_rstat_flush_irqsafe.mem_cgroup_flush_s=
tats.process_one_work.worker_thread
      0.00            +3.8        3.85        perf-profile.calltrace.cycles=
-pp.cgroup_rstat_flush_irqsafe.mem_cgroup_flush_stats.process_one_work.work=
er_thread.kthread
      1.06 =B1 12%      +4.0        5.08        perf-profile.calltrace.cycl=
es-pp.process_one_work.worker_thread.kthread.ret_from_fork
      0.00            +4.1        4.06        perf-profile.calltrace.cycles=
-pp.mem_cgroup_flush_stats.process_one_work.worker_thread.kthread.ret_from_=
fork
      2.17 =B1  6%      +4.6        6.73 =B1  2%  perf-profile.calltrace.cy=
cles-pp.kthread.ret_from_fork
      2.18 =B1  6%      +4.6        6.75 =B1  2%  perf-profile.calltrace.cy=
cles-pp.ret_from_fork
      1.09 =B1 12%      +4.6        5.71        perf-profile.calltrace.cycl=
es-pp.worker_thread.kthread.ret_from_fork
     57.01 =B1  2%      -2.6       54.44        perf-profile.children.cycle=
s-pp.entry_SYSCALL_64_after_hwframe
     56.96 =B1  2%      -2.6       54.40        perf-profile.children.cycle=
s-pp.do_syscall_64
      5.54 =B1  3%      -0.9        4.59 =B1  5%  perf-profile.children.cyc=
les-pp.__x64_sys_getdents64
      5.53 =B1  3%      -0.9        4.58 =B1  5%  perf-profile.children.cyc=
les-pp.iterate_dir
      5.44 =B1  3%      -0.9        4.52 =B1  5%  perf-profile.children.cyc=
les-pp.dcache_readdir
      5.24 =B1  3%      -0.9        4.34 =B1  5%  perf-profile.children.cyc=
les-pp.scan_positives
      3.16 =B1 10%      -0.8        2.37 =B1 11%  perf-profile.children.cyc=
les-pp.write
      2.03 =B1 10%      -0.5        1.51 =B1  6%  perf-profile.children.cyc=
les-pp.div_long
     11.54            -0.5       11.02 =B1  2%  perf-profile.children.cycle=
s-pp.do_sys_open
     11.53            -0.5       11.02 =B1  2%  perf-profile.children.cycle=
s-pp.do_sys_openat2
      8.26 =B1  2%      -0.5        7.77        perf-profile.children.cycle=
s-pp.lock_page_memcg
      2.12 =B1  8%      -0.5        1.64 =B1  4%  perf-profile.children.cyc=
les-pp.add_int
      4.96 =B1  2%      -0.4        4.52 =B1  3%  perf-profile.children.cyc=
les-pp.dput
      3.23 =B1  3%      -0.4        2.80 =B1  7%  perf-profile.children.cyc=
les-pp.vfs_write
      1.77 =B1  7%      -0.4        1.34 =B1  6%  perf-profile.children.cyc=
les-pp.kill
      3.24 =B1  3%      -0.4        2.81 =B1  7%  perf-profile.children.cyc=
les-pp.ksys_write
     10.26 =B1  2%      -0.4        9.84 =B1  2%  perf-profile.children.cyc=
les-pp.path_openat
     10.28 =B1  2%      -0.4        9.86 =B1  2%  perf-profile.children.cyc=
les-pp.do_filp_open
      2.96 =B1  4%      -0.4        2.54 =B1  8%  perf-profile.children.cyc=
les-pp.new_sync_write
      6.88 =B1  2%      -0.4        6.50        perf-profile.children.cycle=
s-pp.filemap_map_pages
      0.90 =B1 13%      -0.3        0.55 =B1 33%  perf-profile.children.cyc=
les-pp.devkmsg_write.cold
      0.90 =B1 13%      -0.3        0.55 =B1 33%  perf-profile.children.cyc=
les-pp.devkmsg_emit
      1.59 =B1  7%      -0.3        1.26 =B1  8%  perf-profile.children.cyc=
les-pp.__strcat_chk
      7.76 =B1  2%      -0.3        7.46        perf-profile.children.cycle=
s-pp.do_fault
      1.03 =B1 12%      -0.3        0.75 =B1 10%  perf-profile.children.cyc=
les-pp.drm_fb_helper_damage_work
      1.02 =B1 12%      -0.3        0.74 =B1 10%  perf-profile.children.cyc=
les-pp.memcpy_toio
      4.86 =B1  2%      -0.3        4.58 =B1  2%  perf-profile.children.cyc=
les-pp.do_set_pte
      4.00 =B1  2%      -0.3        3.75 =B1  2%  perf-profile.children.cyc=
les-pp.page_add_file_rmap
      1.20 =B1  8%      -0.2        0.95 =B1  7%  perf-profile.children.cyc=
les-pp.__close
      1.16 =B1  9%      -0.2        0.91 =B1  3%  perf-profile.children.cyc=
les-pp.add_short
      2.77 =B1  4%      -0.2        2.53 =B1  2%  perf-profile.children.cyc=
les-pp.debug_lockdep_rcu_enabled
      0.84 =B1 11%      -0.2        0.62 =B1 10%  perf-profile.children.cyc=
les-pp.div_int
      1.98 =B1  2%      -0.2        1.78 =B1  5%  perf-profile.children.cyc=
les-pp.lockref_put_or_lock
      1.50 =B1  6%      -0.2        1.32 =B1  8%  perf-profile.children.cyc=
les-pp.do_open
      1.20 =B1  4%      -0.2        1.02 =B1 10%  perf-profile.children.cyc=
les-pp.__x64_sys_kill
      1.11 =B1  4%      -0.2        0.94 =B1 10%  perf-profile.children.cyc=
les-pp.kill_proc_info
      2.28 =B1  3%      -0.2        2.13 =B1  2%  perf-profile.children.cyc=
les-pp.syscall_exit_to_user_mode
      1.04 =B1  4%      -0.2        0.88 =B1 10%  perf-profile.children.cyc=
les-pp.kill_pid_info
      2.29 =B1  3%      -0.2        2.14 =B1  3%  perf-profile.children.cyc=
les-pp.fs_reclaim_acquire
      0.88 =B1  4%      -0.1        0.73 =B1  4%  perf-profile.children.cyc=
les-pp.ip_finish_output2
      0.96 =B1  4%      -0.1        0.81 =B1  4%  perf-profile.children.cyc=
les-pp.ip_output
      1.87 =B1  5%      -0.1        1.72 =B1  3%  perf-profile.children.cyc=
les-pp.__might_fault
      1.14 =B1  5%      -0.1        1.00 =B1  3%  perf-profile.children.cyc=
les-pp.sock_write_iter
      1.13 =B1  5%      -0.1        1.00 =B1  4%  perf-profile.children.cyc=
les-pp.sock_sendmsg
      3.18 =B1  2%      -0.1        3.06 =B1  2%  perf-profile.children.cyc=
les-pp.mark_lock
      1.63 =B1  3%      -0.1        1.52 =B1  5%  perf-profile.children.cyc=
les-pp.step_into
      0.72 =B1  4%      -0.1        0.62 =B1  6%  perf-profile.children.cyc=
les-pp._raw_spin_lock_nested
      0.68 =B1  2%      -0.1        0.58 =B1  3%  perf-profile.children.cyc=
les-pp.__local_bh_enable_ip
      0.58 =B1  3%      -0.1        0.48 =B1  8%  perf-profile.children.cyc=
les-pp.do_send_sig_info
      0.46 =B1 11%      -0.1        0.36 =B1  8%  perf-profile.children.cyc=
les-pp.__x64_sys_rt_sigreturn
      1.22 =B1  5%      -0.1        1.12 =B1  3%  perf-profile.children.cyc=
les-pp.trace_hardirqs_off
      0.32 =B1  6%      -0.1        0.23 =B1  3%  perf-profile.children.cyc=
les-pp.strnlen_user
      0.94 =B1  3%      -0.1        0.85 =B1  4%  perf-profile.children.cyc=
les-pp.lockdep_hardirqs_off
      1.22 =B1  4%      -0.1        1.14 =B1  3%  perf-profile.children.cyc=
les-pp.copy_strings
      0.55 =B1  2%      -0.1        0.46 =B1  6%  perf-profile.children.cyc=
les-pp.do_softirq
      0.33 =B1  9%      -0.1        0.24 =B1 10%  perf-profile.children.cyc=
les-pp.aa_get_task_label
      0.50 =B1  7%      -0.1        0.41 =B1  6%  perf-profile.children.cyc=
les-pp.net_rx_action
      0.48 =B1  6%      -0.1        0.40 =B1  6%  perf-profile.children.cyc=
les-pp.__napi_poll
      0.61 =B1  5%      -0.1        0.53 =B1  9%  perf-profile.children.cyc=
les-pp.do_truncate
      0.46 =B1  5%      -0.1        0.39 =B1  6%  perf-profile.children.cyc=
les-pp.process_backlog
      1.44 =B1  4%      -0.1        1.37 =B1  2%  perf-profile.children.cyc=
les-pp.terminate_walk
      1.50 =B1  3%      -0.1        1.43 =B1  3%  perf-profile.children.cyc=
les-pp.__open64_nocancel
      0.80 =B1  3%      -0.1        0.73 =B1  3%  perf-profile.children.cyc=
les-pp.get_user_arg_ptr
      0.36 =B1  9%      -0.1        0.29 =B1  6%  perf-profile.children.cyc=
les-pp.kernel_wait4
      0.37 =B1  9%      -0.1        0.30 =B1  8%  perf-profile.children.cyc=
les-pp.inet_recvmsg
      0.18 =B1 12%      -0.1        0.11 =B1 15%  perf-profile.children.cyc=
les-pp.__waitpid
      0.54 =B1  5%      -0.1        0.47 =B1  6%  perf-profile.children.cyc=
les-pp.count
      0.38 =B1  9%      -0.1        0.31 =B1  9%  perf-profile.children.cyc=
les-pp.sock_read_iter
      0.36 =B1  9%      -0.1        0.29 =B1  5%  perf-profile.children.cyc=
les-pp.__do_sys_wait4
      0.34 =B1  9%      -0.1        0.28 =B1  6%  perf-profile.children.cyc=
les-pp.do_wait
      0.16 =B1 13%      -0.1        0.10 =B1 16%  perf-profile.children.cyc=
les-pp.io_serial_out
      0.49 =B1  5%      -0.1        0.43 =B1  6%  perf-profile.children.cyc=
les-pp.arch_do_signal_or_restart
      0.24 =B1 12%      -0.1        0.18 =B1 13%  perf-profile.children.cyc=
les-pp.apparmor_task_getsecid
      0.24 =B1 14%      -0.1        0.18 =B1 15%  perf-profile.children.cyc=
les-pp.tcp_recvmsg
      0.31 =B1  8%      -0.1        0.26 =B1  6%  perf-profile.children.cyc=
les-pp.ip_local_deliver
      0.31 =B1  9%      -0.1        0.26 =B1  6%  perf-profile.children.cyc=
les-pp.ip_local_deliver_finish
      0.21 =B1 15%      -0.1        0.15 =B1 14%  perf-profile.children.cyc=
les-pp.tcp_recvmsg_locked
      0.34 =B1  6%      -0.1        0.29 =B1  6%  perf-profile.children.cyc=
les-pp.__netif_receive_skb_one_core
      0.22 =B1 14%      -0.1        0.16 =B1  9%  perf-profile.children.cyc=
les-pp.sighandler
      0.46 =B1  4%      -0.1        0.41        perf-profile.children.cycle=
s-pp.syscall_enter_from_user_mode
      0.32 =B1  7%      -0.1        0.27 =B1  5%  perf-profile.children.cyc=
les-pp.ip_rcv
      0.24 =B1  6%      -0.0        0.20 =B1 11%  perf-profile.children.cyc=
les-pp.send_signal
      0.07 =B1 10%      -0.0        0.04 =B1 65%  perf-profile.children.cyc=
les-pp.__libc_calloc
      0.17 =B1 10%      -0.0        0.13 =B1  7%  perf-profile.children.cyc=
les-pp.dentry_needs_remove_privs
      0.12 =B1 13%      -0.0        0.08 =B1 12%  perf-profile.children.cyc=
les-pp.compar1
      0.13 =B1 10%      -0.0        0.10 =B1 10%  perf-profile.children.cyc=
les-pp.simple_xattr_get
      0.19 =B1  8%      -0.0        0.16 =B1 11%  perf-profile.children.cyc=
les-pp.__setup_rt_frame
      0.16 =B1 10%      -0.0        0.13 =B1  7%  perf-profile.children.cyc=
les-pp.security_inode_need_killpriv
      0.16 =B1  8%      -0.0        0.13 =B1  6%  perf-profile.children.cyc=
les-pp.cap_inode_need_killpriv
      0.16 =B1  8%      -0.0        0.13 =B1  6%  perf-profile.children.cyc=
les-pp.__vfs_getxattr
      0.12 =B1  7%      -0.0        0.10 =B1 16%  perf-profile.children.cyc=
les-pp.security_task_kill
      0.12 =B1  8%      -0.0        0.09 =B1 15%  perf-profile.children.cyc=
les-pp.apparmor_task_kill
      0.16 =B1 11%      -0.0        0.13 =B1  8%  perf-profile.children.cyc=
les-pp.__alloc_skb
      0.08 =B1 10%      -0.0        0.06 =B1 41%  perf-profile.children.cyc=
les-pp.sort_rtns_1
      0.08 =B1 11%      -0.0        0.06 =B1  5%  perf-profile.children.cyc=
les-pp.kmalloc_reserve
      0.08 =B1  8%      -0.0        0.06 =B1  5%  perf-profile.children.cyc=
les-pp.__kmalloc_node_track_caller
      0.06 =B1 14%      +0.0        0.09 =B1 11%  perf-profile.children.cyc=
les-pp.prandom_u32
      0.09 =B1 12%      +0.0        0.12 =B1  4%  perf-profile.children.cyc=
les-pp.lock_pin_lock
      0.24 =B1  8%      +0.0        0.27 =B1  9%  perf-profile.children.cyc=
les-pp.shift_arg_pages
      0.09 =B1 19%      +0.0        0.13 =B1 12%  perf-profile.children.cyc=
les-pp.cpuacct_charge
      0.01 =B1223%      +0.1        0.06 =B1 12%  perf-profile.children.cyc=
les-pp.__pagevec_release
      0.00            +0.1        0.06 =B1  8%  perf-profile.children.cycle=
s-pp.select_idle_sibling
      0.05 =B1 46%      +0.1        0.10 =B1 19%  perf-profile.children.cyc=
les-pp.enqueue_entity
      0.40 =B1  3%      +0.1        0.46 =B1  4%  perf-profile.children.cyc=
les-pp.__pmd_alloc
      0.35 =B1  9%      +0.1        0.41 =B1  7%  perf-profile.children.cyc=
les-pp.__pagevec_lru_add
      0.21 =B1  6%      +0.1        0.28 =B1  5%  perf-profile.children.cyc=
les-pp.__pagevec_lru_add_fn
      0.04 =B1 71%      +0.1        0.11 =B1 10%  perf-profile.children.cyc=
les-pp.preempt_schedule_thunk
      0.04 =B1 71%      +0.1        0.11 =B1 10%  perf-profile.children.cyc=
les-pp.preempt_schedule_common
      0.09 =B1 10%      +0.1        0.16 =B1 11%  perf-profile.children.cyc=
les-pp.irqentry_exit
      0.14 =B1  7%      +0.1        0.22 =B1 10%  perf-profile.children.cyc=
les-pp.page_add_new_anon_rmap
      0.11 =B1  9%      +0.1        0.19 =B1 11%  perf-profile.children.cyc=
les-pp.update_load_avg
      0.00            +0.1        0.07 =B1 12%  perf-profile.children.cycle=
s-pp.rcu_note_context_switch
      1.08 =B1  5%      +0.1        1.16 =B1  4%  perf-profile.children.cyc=
les-pp.wp_page_copy
      0.00            +0.1        0.08 =B1 23%  perf-profile.children.cycle=
s-pp.put_prev_entity
      0.00            +0.1        0.08 =B1 17%  perf-profile.children.cycle=
s-pp.ttwu_do_wakeup
      0.06 =B1 11%      +0.1        0.14 =B1 17%  perf-profile.children.cyc=
les-pp.enqueue_task_fair
      0.83 =B1  3%      +0.1        0.92 =B1  4%  perf-profile.children.cyc=
les-pp.tlb_finish_mmu
      0.82 =B1  3%      +0.1        0.91 =B1  4%  perf-profile.children.cyc=
les-pp.tlb_flush_mmu
      0.00            +0.1        0.09 =B1 14%  perf-profile.children.cycle=
s-pp.perf_tp_event
      0.79 =B1  3%      +0.1        0.88 =B1  4%  perf-profile.children.cyc=
les-pp.release_pages
      0.00            +0.1        0.09 =B1 15%  perf-profile.children.cycle=
s-pp.preempt_schedule_irq
      0.38 =B1  7%      +0.1        0.48 =B1  7%  perf-profile.children.cyc=
les-pp._raw_spin_unlock_irq
      0.00            +0.1        0.11 =B1 14%  perf-profile.children.cycle=
s-pp.perf_trace_sched_wakeup_template
      0.04 =B1 71%      +0.1        0.14 =B1 17%  perf-profile.children.cyc=
les-pp.ttwu_do_activate
      0.12 =B1 12%      +0.1        0.23 =B1 12%  perf-profile.children.cyc=
les-pp.pick_next_task_fair
      0.09 =B1  9%      +0.1        0.22 =B1  8%  perf-profile.children.cyc=
les-pp.dequeue_entity
      0.00            +0.1        0.14 =B1 15%  perf-profile.children.cycle=
s-pp.asm_sysvec_reschedule_ipi
      0.11 =B1 11%      +0.1        0.25 =B1  7%  perf-profile.children.cyc=
les-pp.dequeue_task_fair
      0.06 =B1 48%      +0.1        0.20 =B1  8%  perf-profile.children.cyc=
les-pp.select_task_rq_fair
      0.01 =B1223%      +0.1        0.15 =B1 11%  perf-profile.children.cyc=
les-pp._find_next_bit
      0.22 =B1  7%      +0.1        0.37 =B1  5%  perf-profile.children.cyc=
les-pp.finish_task_switch
      1.19 =B1  7%      +0.2        1.34        perf-profile.children.cycle=
s-pp.unlink_anon_vmas
      0.27 =B1  6%      +0.2        0.43 =B1  9%  perf-profile.children.cyc=
les-pp.update_curr
      0.99 =B1  6%      +0.2        1.15 =B1  3%  perf-profile.children.cyc=
les-pp.remove_vma
      0.12 =B1 12%      +0.2        0.35 =B1  5%  perf-profile.children.cyc=
les-pp.schedule_idle
      0.48 =B1 21%      +0.3        0.81 =B1  6%  perf-profile.children.cyc=
les-pp.native_queued_spin_lock_slowpath
      0.49 =B1  8%      +0.4        0.84 =B1  4%  perf-profile.children.cyc=
les-pp.__mod_lruvec_page_state
      0.99 =B1  9%      +0.4        1.37 =B1  3%  perf-profile.children.cyc=
les-pp.do_raw_spin_lock
      2.95 =B1  4%      +0.4        3.33 =B1  3%  perf-profile.children.cyc=
les-pp.memcg_slab_free_hook
      0.50 =B1 11%      +0.4        0.88 =B1  6%  perf-profile.children.cyc=
les-pp._raw_spin_unlock_irqrestore
      0.28 =B1  7%      +0.5        0.76 =B1  3%  perf-profile.children.cyc=
les-pp.schedule
      0.16 =B1 10%      +0.6        0.76 =B1  2%  perf-profile.children.cyc=
les-pp.try_to_wake_up
      0.00            +0.8        0.81 =B1  4%  perf-profile.children.cycle=
s-pp.__queue_work
      0.55 =B1  4%      +0.8        1.37 =B1  3%  perf-profile.children.cyc=
les-pp.__schedule
      0.25 =B1  9%      +0.8        1.10 =B1  4%  perf-profile.children.cyc=
les-pp.__mod_memcg_lruvec_state
      0.00            +0.8        0.85 =B1  4%  perf-profile.children.cycle=
s-pp.queue_work_on
      0.01 =B1223%      +0.9        0.90 =B1  4%  perf-profile.children.cyc=
les-pp.cgroup_rstat_updated
      0.57 =B1  8%      +0.9        1.51 =B1  6%  perf-profile.children.cyc=
les-pp._raw_spin_lock_irqsave
      0.00            +1.5        1.50 =B1  3%  perf-profile.children.cycle=
s-pp.mem_cgroup_css_rstat_flush
      4.51            +1.9        6.41        perf-profile.children.cycles-=
pp.intel_idle
      7.44            +2.0        9.41 =B1  3%  perf-profile.children.cycle=
s-pp.cpuidle_enter
      7.44            +2.0        9.41 =B1  3%  perf-profile.children.cycle=
s-pp.cpuidle_enter_state
      7.66            +2.4       10.03 =B1  5%  perf-profile.children.cycle=
s-pp.start_secondary
      8.19            +2.5       10.65 =B1  5%  perf-profile.children.cycle=
s-pp.secondary_startup_64_no_verify
      8.19            +2.5       10.65 =B1  5%  perf-profile.children.cycle=
s-pp.cpu_startup_entry
      8.19            +2.5       10.65 =B1  5%  perf-profile.children.cycle=
s-pp.do_idle
      0.00            +3.8        3.81        perf-profile.children.cycles-=
pp.cgroup_rstat_flush_locked
      0.00            +3.8        3.85        perf-profile.children.cycles-=
pp.cgroup_rstat_flush_irqsafe
      1.06 =B1 12%      +4.0        5.08        perf-profile.children.cycle=
s-pp.process_one_work
      0.00            +4.1        4.06        perf-profile.children.cycles-=
pp.mem_cgroup_flush_stats
      2.17 =B1  6%      +4.6        6.73 =B1  2%  perf-profile.children.cyc=
les-pp.kthread
      2.27 =B1  6%      +4.6        6.85 =B1  2%  perf-profile.children.cyc=
les-pp.ret_from_fork
      1.09 =B1 12%      +4.6        5.71        perf-profile.children.cycle=
s-pp.worker_thread
      1.99 =B1 10%      -0.5        1.48 =B1  6%  perf-profile.self.cycles-=
pp.div_long
      2.06 =B1  8%      -0.5        1.59 =B1  4%  perf-profile.self.cycles-=
pp.add_int
      1.55 =B1  7%      -0.3        1.22 =B1  8%  perf-profile.self.cycles-=
pp.__strcat_chk
      1.00 =B1 12%      -0.3        0.73 =B1 10%  perf-profile.self.cycles-=
pp.memcpy_toio
      1.12 =B1  8%      -0.2        0.89 =B1  3%  perf-profile.self.cycles-=
pp.add_short
      2.45 =B1  4%      -0.2        2.24 =B1  3%  perf-profile.self.cycles-=
pp.debug_lockdep_rcu_enabled
      0.82 =B1 11%      -0.2        0.61 =B1 10%  perf-profile.self.cycles-=
pp.div_int
      0.16 =B1 13%      -0.1        0.10 =B1 16%  perf-profile.self.cycles-=
pp.io_serial_out
      0.11 =B1 14%      -0.0        0.08 =B1 12%  perf-profile.self.cycles-=
pp.compar1
      0.08 =B1 11%      -0.0        0.06 =B1 41%  perf-profile.self.cycles-=
pp.sort_rtns_1
      0.00            +0.1        0.06 =B1 16%  perf-profile.self.cycles-pp=
.__schedule
      0.01 =B1223%      +0.1        0.11 =B1 10%  perf-profile.self.cycles-=
pp.cgroup_rstat_updated
      0.00            +0.1        0.14 =B1  9%  perf-profile.self.cycles-pp=
._find_next_bit
      0.00            +0.2        0.23 =B1  8%  perf-profile.self.cycles-pp=
.cgroup_rstat_flush_locked
      3.62 =B1  3%      +0.2        3.86 =B1  2%  perf-profile.self.cycles-=
pp.lock_release
      0.47 =B1 22%      +0.3        0.80 =B1  5%  perf-profile.self.cycles-=
pp.native_queued_spin_lock_slowpath
      0.00            +1.4        1.39 =B1  3%  perf-profile.self.cycles-pp=
.mem_cgroup_css_rstat_flush
      4.51            +1.9        6.41        perf-profile.self.cycles-pp.i=
ntel_idle
      0.05 =B1  7%    +112.1%       0.11 =B1  8%  perf-sched.sch_delay.avg.=
ms.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group.do_syscall_64
      0.06 =B1  7%    +212.1%       0.18 =B1 65%  perf-sched.sch_delay.avg.=
ms.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64
      0.02 =B1 22%    +198.9%       0.06 =B1 14%  perf-sched.sch_delay.avg.=
ms.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_sysvec_apic_tim=
er_interrupt.[unknown]
      0.03 =B1 80%     -62.9%       0.01 =B1 39%  perf-sched.sch_delay.avg.=
ms.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_sysvec_reschedu=
le_ipi.[unknown]
      0.11 =B1 39%    +105.5%       0.23 =B1 28%  perf-sched.sch_delay.avg.=
ms.io_schedule.__lock_page_killable.filemap_fault.__do_fault
      0.05 =B1 48%     -65.6%       0.02 =B1 74%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.__dentry=
_kill.dput
      0.05 =B1 65%     -79.6%       0.01 =B1103%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.lockref_=
put_or_lock.dput
      0.02 =B1134%     -92.5%       0.00 =B1 67%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.pick_fil=
e.close_fd
      0.10 =B1 23%     -64.9%       0.04 =B1 26%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.zap_pte_=
range.unmap_page_range
      0.00 =B1152%   +3058.7%       0.14 =B1138%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.rele=
ase_task.wait_task_zombie
      0.00 =B1151%    +852.7%       0.04 =B1 45%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.wait=
_task_zombie.do_wait
      0.05 =B1178%     -90.8%       0.00 =B1 83%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.do_send_sig_info.kill_pid_info
      0.00 =B1223%  +11900.0%       0.20 =B1183%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.thread_group_cputime_adjusted.wait_task_zombie
      0.02 =B1 10%    +708.3%       0.13 =B1 28%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_write_unlock_irq.rel=
ease_task.wait_task_zombie
      0.22 =B1172%     -98.8%       0.00 =B1 80%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk.fd_install.do_sys_openat2=
.do_sys_open
      0.14 =B1178%     -97.4%       0.00 =B1 94%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk.perf_iterate_sb.perf_even=
t_mmap.__install_special_mapping
      0.05 =B1171%     -92.6%       0.00 =B1 89%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.lock_=
acquire.mntput_no_expire
      0.01 =B1 49%     -80.1%       0.00 =B1158%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.d_alloc_par=
allel.__lookup_slow
      0.06 =B1 56%     -98.0%       0.00 =B1 98%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.kmem_cache_=
free.remove_vma
      0.09 =B1131%     -94.1%       0.01 =B1108%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.ktime_get_c=
oarse_real_ts64.current_time
      0.01 =B1 72%   +1774.7%       0.12 =B1 81%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.down_read_trylock
      0.11 =B1150%     -92.3%       0.01 =B1120%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.kmem_cache_alloc
      0.18 =B1137%     -99.0%       0.00 =B1 72%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.memcg_slab_free_hook
      0.02 =B1111%     -95.3%       0.00 =B1 75%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.obj_cgroup_charge_pages
      0.11 =B1116%     -82.0%       0.02 =B1 79%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_is_hel=
d_type.___might_sleep
      0.02 =B1 47%     -86.1%       0.00 =B1 81%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.refill_obj_=
stock.memcg_slab_free_hook
      0.01 =B1 48%     -91.1%       0.00 =B1115%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.kernel_clone.__d=
o_sys_clone.do_syscall_64
      0.14 =B1203%     -97.8%       0.00 =B1 66%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.kme=
m_cache_alloc.__alloc_file
      0.03 =B1136%     -93.7%       0.00 =B1 67%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.kme=
m_cache_alloc.anon_vma_clone
      0.34 =B1213%     -99.1%       0.00 =B1106%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.mnt=
put_no_expire.terminate_walk
      0.21 =B1136%     -98.7%       0.00 =B1 47%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release._co=
py_from_user.copy_strings
      0.03 =B1122%     -89.4%       0.00 =B1115%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.get=
_mem_cgroup_from_objcg.obj_cgroup_charge_pages
      0.01 =B1 37%     -89.7%       0.00 =B1 54%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.kme=
m_cache_alloc.anon_vma_clone
      0.05 =B1184%     -97.4%       0.00 =B1 99%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.kme=
m_cache_alloc.anon_vma_fork
      0.02 =B1 84%     -87.8%       0.00 =B1 79%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.kme=
m_cache_alloc.getname_flags
      0.03 =B1 87%     -90.9%       0.00 =B1 95%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.mem=
_cgroup_uncharge_list.release_pages
      0.14 =B1 69%     -93.8%       0.01 =B1148%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.mem=
cg_slab_free_hook.kmem_cache_free
      0.01 =B1201%   +1003.1%       0.08 =B1 91%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.__anon_vma_prepare
      0.01 =B1119%  +29990.8%       1.71 =B1236%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.anon_vma_fork
      0.01 =B1 82%    +615.4%       0.09 =B1107%  perf-sched.sch_delay.avg.=
ms.rwsem_down_write_slowpath.filename_create.do_linkat.__x64_sys_link
      0.02 =B1 23%   +2589.1%       0.46 =B1211%  perf-sched.sch_delay.avg.=
ms.rwsem_down_write_slowpath.path_openat.do_filp_open.do_sys_openat2
     11.95 =B1 21%     +48.1%      17.70 =B1 18%  perf-sched.sch_delay.max.=
ms.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group.do_syscall_64
      2.05 =B1 44%    +307.3%       8.34 =B1 29%  perf-sched.sch_delay.max.=
ms.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_sysvec_apic_tim=
er_interrupt.[unknown]
      1.44 =B1 91%    +369.6%       6.79 =B1 78%  perf-sched.sch_delay.max.=
ms.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_sysvec_reschedu=
le_ipi.[unknown]
      0.05 =B1 94%   +4699.5%       2.54 =B1162%  perf-sched.sch_delay.max.=
ms.exit_to_user_mode_prepare.syscall_exit_to_user_mode.do_syscall_64.entry_=
SYSCALL_64_after_hwframe
      0.01 =B1223%  +23956.2%       1.28 =B1213%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.__local_bh_enable_ip.copy=
_fpstate_to_sigframe.__setup_rt_frame
      0.57 =B1 96%    +933.8%       5.91 =B1 41%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_read_unlock.wait_tas=
k_zombie.do_wait
      5.55 =B1 26%    +138.7%      13.24 =B1 22%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.filemap_=
map_pages.do_fault
      0.02 =B1 56%  +13714.0%       2.39 =B1154%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.get_=
signal.arch_do_signal_or_restart
      0.00 =B1152%  +33881.0%       1.53 =B1161%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.rele=
ase_task.wait_task_zombie
      0.00 =B1100%  +22738.6%       0.76 =B1183%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.ret_=
from_fork.[unknown]
      0.02 =B1 22%  +15927.9%       3.31 =B1 98%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.shme=
m_add_to_page_cache.shmem_getpage_gfp
      0.01 =B1141%   +7238.1%       0.44 =B1 78%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.wait=
_task_zombie.do_wait
      0.08 =B1159%   +2093.7%       1.84 =B1186%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.delete_from_page_cache.truncate_inode_page
      0.01 =B1100%  +13227.7%       1.09 =B1223%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.release_pages.__pagevec_release
     10.04 =B1 34%     +75.6%      17.63 =B1 24%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.sched_move_task.do_exit
      0.00 =B1223%  +96714.3%       1.61 =B1215%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.thread_group_cputime_adjusted.wait_task_zombie
      0.02 =B1 14%  +33245.7%       6.72 =B1 69%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_write_unlock_irq.rel=
ease_task.wait_task_zombie
      0.00 =B1223%   +6237.1%       0.16 =B1209%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.lru_add_drain.__pagevec_r=
elease.shmem_undo_range
      0.34 =B1138%    +781.6%       3.03 =B1 81%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.lru_add_drain.exit_mmap.m=
mput
      0.26 =B1182%     -91.0%       0.02 =B1 89%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.perf_iterate_sb.perf_even=
t_mmap.__install_special_mapping
      0.35 =B1209%    +967.7%       3.74 =B1 52%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.try_to_wake_up.wake_up_q.=
rwsem_wake
      0.04 =B1 12%     -14.6%       0.04 =B1  9%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.vprintk_emit.devkmsg_emit=
.constprop
      0.33 =B1 97%   +1104.9%       3.94 =B1146%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.memcg=
_slab_free_hook.kmem_cache_free
      0.02 =B1 98%   +1101.6%       0.21 =B1151%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__mem_cgrou=
p_charge.mem_cgroup_charge
      0.00 =B1223%  +47660.0%       0.40 =B1233%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.count.isra
      0.07 =B1208%   +4562.7%       3.28 =B1130%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.find_vma.do=
_user_addr_fault
      0.11 =B1164%   +3912.2%       4.51 =B1 72%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.handle_mm_f=
ault.do_user_addr_fault
      0.20 =B1102%     -90.8%       0.02 =B1101%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.kmem_cache_=
free.remove_vma
      0.46 =B1 85%    +857.7%       4.38 =B1 91%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.__might_fault
      0.01 =B1 92%  +35773.7%       4.42 =B1 89%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.down_read_trylock
      0.03 =B1 94%   +5361.6%       1.58 =B1112%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.get_mem_cgroup_from_objcg
      0.12 =B1136%    +638.2%       0.90 =B1 83%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_is_hel=
d_type.mem_cgroup_from_task
      0.00 =B1142%    +816.5%       0.02 =B1 89%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.mem=
_cgroup_charge.wp_page_copy
      0.00 =B1141%    +414.3%       0.02 =B1 32%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.pag=
ecache_get_page.shmem_getpage_gfp
      0.19 =B1209%   +3391.3%       6.52 =B1 79%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.__alloc_file
      0.01 =B1187%  +32718.1%       2.68 =B1109%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.__anon_vma_prepare
      0.05 =B1201%  +2.7e+05%     144.31 =B1242%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.__d_alloc
      0.00 =B1141%  +71174.5%       3.33 =B1149%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.anon_vma_clone
      0.01 =B1108%  +2.4e+06%     146.00 =B1239%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.anon_vma_fork
      0.02 =B1141%  +14953.1%       2.31 =B1110%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.vm_area_alloc
      0.01 =B1 83%  +27325.7%       2.74 =B1103%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.vm_area_dup
      0.02 =B1 63%  +17882.6%       4.44 =B1 37%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
memcg_slab_free_hook.kmem_cache_free
      0.15 =B1183%   +3099.4%       4.67 =B1102%  perf-sched.sch_delay.max.=
ms.rwsem_down_write_slowpath.anon_vma_clone.anon_vma_fork.dup_mmap
      0.34 =B1117%   +1079.3%       4.02 =B1 99%  perf-sched.sch_delay.max.=
ms.rwsem_down_write_slowpath.filename_create.do_linkat.__x64_sys_link
      2.37 =B1 46%   +6268.4%     151.16 =B1229%  perf-sched.sch_delay.max.=
ms.rwsem_down_write_slowpath.path_openat.do_filp_open.do_sys_openat2
      0.63 =B1209%   +1026.8%       7.12 =B1 82%  perf-sched.sch_delay.max.=
ms.rwsem_down_write_slowpath.unlink_anon_vmas.free_pgtables.exit_mmap
      3.11 =B1  8%   +1463.8%      48.56 =B1217%  perf-sched.sch_delay.max.=
ms.worker_thread.kthread.ret_from_fork
     17.70 =B1 20%    +826.4%     163.98 =B1209%  perf-sched.total_sch_dela=
y.max.ms
     29.22           -73.2%       7.84 =B1  8%  perf-sched.total_wait_and_d=
elay.average.ms
     30290          +285.8%     116849 =B1  9%  perf-sched.total_wait_and_d=
elay.count.ms
      6631           -55.2%       2969        perf-sched.total_wait_and_del=
ay.max.ms
     29.17           -73.3%       7.78 =B1  8%  perf-sched.total_wait_time.=
average.ms
      6631           -55.2%       2968        perf-sched.total_wait_time.ma=
x.ms
     59.63 =B1 13%     -17.3%      49.31 =B1  6%  perf-sched.wait_and_delay=
.avg.ms.preempt_schedule_common.preempt_schedule_thunk.cpu_stop_queue_work.=
affine_move_task.__set_cpus_allowed_ptr
    310.64 =B1 21%     -33.9%     205.45 =B1  9%  perf-sched.wait_and_delay=
.avg.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do=
_sys_poll
     71.02 =B1  4%     -96.6%       2.42 =B1  9%  perf-sched.wait_and_delay=
.avg.ms.worker_thread.kthread.ret_from_fork
    134.33 =B1 44%   +1034.5%       1524 =B1 12%  perf-sched.wait_and_delay=
.count.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_sysvec_resc=
hedule_ipi.[unknown]
    374.00 =B1  3%    +381.6%       1801 =B1 12%  perf-sched.wait_and_delay=
.count.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.file=
map_map_pages.do_fault
    382.67 =B1  6%    +469.6%       2179 =B1 12%  perf-sched.wait_and_delay=
.count.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.zap_=
pte_range.unmap_page_range
     36.33 =B1  5%     +76.1%      64.00 =B1 10%  perf-sched.wait_and_delay=
.count.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_=
sys_poll
      2283 =B1  4%   +3039.1%      71671 =B1 10%  perf-sched.wait_and_delay=
.count.worker_thread.kthread.ret_from_fork
     14.07 =B1 30%   +5035.2%     722.29 =B1 60%  perf-sched.wait_and_delay=
.max.ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.zap=
_pte_range.unmap_page_range
      0.38 =B1 80%    +165.3%       1.02 =B1 28%  perf-sched.wait_time.avg.=
ms.exit_to_user_mode_prepare.syscall_exit_to_user_mode.do_syscall_64.entry_=
SYSCALL_64_after_hwframe
      0.93 =B1193%   +8638.6%      81.15 =B1153%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk.__mutex_lock.perf_poll.do=
_sys_poll
      0.00 =B1223%   +3392.9%       0.05 =B1108%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.__pte_al=
loc.do_anonymous_page
      0.00 =B1223%   +2573.2%       0.07 =B1125%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.__pte_al=
loc.finish_fault
      2.90 =B1 23%     -88.9%       0.32 =B1 67%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.copy_pte=
_range.copy_page_range
      0.33 =B1157%   +6283.7%      21.35 =B1 34%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.do_anony=
mous_page.__handle_mm_fault
      0.08 =B1223%   +1416.0%       1.15 =B1 56%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.do_exit.=
do_group_exit
      0.00 =B1141%    +617.3%       0.02 =B1 36%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.follow_p=
age_pte.__get_user_pages
      1.23 =B1 35%     -83.1%       0.21 =B1 46%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.pick_fil=
e.close_fd
      5.03 =B1 30%     -75.4%       1.24 =B1 83%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.__x6=
4_sys_rt_sigreturn.do_syscall_64
      2.90 =B1 43%     -68.5%       0.91 =B1 44%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.do_s=
igaction.__x64_sys_rt_sigaction
      6.23 =B1 29%    +199.3%      18.65 =B1 28%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.shme=
m_add_to_page_cache.shmem_getpage_gfp
      1.24 =B1141%    +367.8%       5.79 =B1 18%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.wait=
_task_zombie.do_wait
      6.47 =B1 13%     -68.7%       2.02 =B1 13%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.delete_from_page_cache.truncate_inode_page
      0.51 =B1 96%    +384.9%       2.49 =B1 40%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.rcu_preempt_deferred_qs_irqrestore.__rcu_read_unlock
      2.08 =B1 55%     -50.8%       1.02 =B1 87%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.sched_fork.copy_process
      0.84 =B1 16%     +96.2%       1.65 =B1 18%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.sched_move_task.do_exit
      1.04 =B1222%    +455.7%       5.80 =B1 18%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.thread_group_cputime_adjusted.wait_task_zombie
      2.40 =B1 35%     -61.2%       0.93 =B1 50%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.wake_up_new_task.kernel_clone
     59.62 =B1 13%     -17.3%      49.31 =B1  6%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk.cpu_stop_queue_work.affin=
e_move_task.__set_cpus_allowed_ptr
      0.00 =B1223%  +20410.7%       0.82 =B1158%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk.d_alloc_parallel.lookup_o=
pen.path_openat
      0.28 =B1 86%    +644.7%       2.07 =B1132%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk.lru_add_drain.exit_mmap.m=
mput
      0.00 =B1223%  +1.8e+05%       3.69 =B1216%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk.touch_atime.pick_link.ste=
p_into
      6.29 =B1 21%     -82.8%       1.08 =B1 53%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk.vfs_write.ksys_write.do_s=
yscall_64
      4.32 =B1106%     -99.9%       0.00 =B1244%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__loc=
al_bh_enable_ip.arch_do_signal_or_restart
     19.54 =B1122%     -89.4%       2.08 =B1 33%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.ktime=
_get_coarse_real_ts64.current_time
      5.89 =B1176%     -89.6%       0.61 =B1 45%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.lock_=
acquire.__might_fault
     11.38 =B1109%     -89.2%       1.23 =B1 33%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.lock_=
acquire.kmem_cache_alloc
      2.46 =B1105%     -80.6%       0.48 =B1244%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.lock_=
release.strncpy_from_user
      0.00 =B1223%  +11214.3%       0.13 =B1186%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.___might_sl=
eep.kmem_cache_alloc
      0.00 =B1223%   +2287.8%       0.03 =B1151%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.___might_sl=
eep.task_work_run
      0.00 =B1223%    +1e+06%      22.50 =B1239%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__alloc_pag=
es.alloc_pages_vma
      0.02 =B1214%    +557.3%       0.15 =B1 91%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__mem_cgrou=
p_charge.mem_cgroup_charge
      0.06 =B1167%    +521.5%       0.40 =B1 93%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__might_sle=
ep.do_user_addr_fault
      0.01 =B1223%   +1226.2%       0.08 =B1104%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__might_sle=
ep.kmem_cache_alloc
      0.00 =B1223%   +7641.1%       0.21 =B1199%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__pmd_alloc=
.copy_page_range
      0.00 =B1223%   +1957.1%       0.04 =B1 93%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__rcu_read_=
lock.get_obj_cgroup_from_current
      0.00 =B1150%    +435.7%       0.02 =B1 46%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__rcu_read_=
unlock.memcg_slab_free_hook
      0.00 =B1223%   +4576.2%       0.07 =B1133%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__vma_link_=
rb.vma_link
      0.00 =B1223%   +2139.3%       0.03 =B1 74%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi._copy_from_=
user.copy_strings
      0.04 =B1211%   +2642.2%       1.19 =B1 83%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.account_ker=
nel_stack.dup_task_struct
      0.00 =B1223%  +31985.7%       1.44 =B1 85%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.acct_collec=
t.do_exit
      0.00 =B1223%   +3475.5%       0.04 =B1 99%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.call_rcu.__=
dentry_kill
      0.01 =B1223%   +9379.0%       0.54 =B1111%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.check_stack=
_object.__check_object_size
      0.00 =B1158%   +2526.9%       0.07 =B1164%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.copy_string=
s.isra
      0.08 =B1223%   +1204.5%       1.07 =B1 94%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.copy_user_e=
nhanced_fast_string.copyout
      0.00 =B1223%   +1082.9%       0.02 =B1 67%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.debug_lockd=
ep_rcu_enabled.get_obj_cgroup_from_current
      0.08 =B1138%    +744.4%       0.64 =B1 55%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.debug_lockd=
ep_rcu_enabled.rcu_read_lock_held_common
      0.07 =B1 67%    +498.8%       0.45 =B1 30%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.do_user_add=
r_fault.exc_page_fault
      0.17 =B1150%    +399.5%       0.87 =B1 36%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.exit_to_use=
r_mode_prepare
      0.11 =B1140%    +886.9%       1.08 =B1 41%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.find_vma.do=
_user_addr_fault
      0.00 =B1223%   +4042.9%       0.04 =B1154%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.free_unref_=
page_list.release_pages
      0.00 =B1223%  +45705.7%       1.15 =B1118%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.generic_per=
form_write.__generic_file_write_iter
      0.00 =B1223%   +3517.1%       0.03 =B1113%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.get_mem_cgr=
oup_from_objcg.obj_cgroup_charge_pages
      0.10 =B1 99%    +270.0%       0.36 =B1 33%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.handle_mm_f=
ault.do_user_addr_fault
      0.00 =B1223%  +14471.4%       0.36 =B1122%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.kmem_cache_=
free.do_sys_openat2
      0.02 =B1223%   +3189.9%       0.56 =B1161%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.link_path_w=
alk.part
      0.00 =B1223%   +4738.1%       0.07 =B1180%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.__task_pid_nr_ns
      0.00 =B1223%  +34475.0%       0.46 =B1 70%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.aa_file_perm
      0.00 =B1223%   +7828.6%       0.16 =B1127%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.cgroup_throttle_swaprate
      0.08 =B1 97%   +1132.5%       0.94 =B1 19%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.handle_mm_fault
      0.00 =B1223%  +17814.3%       0.42 =B1 89%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.mnt_want_write
      0.00 =B1223%   +7185.7%       0.08 =B1101%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.mntput_no_expire
      0.09 =B1168%   +8240.6%       7.37 =B1225%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.pagecache_get_page
      0.06 =B1198%    +656.0%       0.47 =B1102%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_is_hel=
d_type.xas_start
      0.00 =B1223%  +20115.7%       0.67 =B1 84%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e.aa_file_perm
      0.00 =B1223%   +4428.6%       0.05 =B1 99%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e.get_user_arg_ptr
      0.03 =B1156%    +893.6%       0.34 =B1 87%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e.handle_mm_fault
      0.63 =B1102%     -90.6%       0.06 =B1 73%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.memcg_slab_=
free_hook.kmem_cache_free
      0.00 =B1223%  +66634.7%       0.78 =B1156%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.path_init.p=
ath_lookupat
      0.01 =B1223%   +5980.4%       0.49 =B1110%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.rcu_read_lo=
ck_held_common.rcu_read_lock_held
      0.01 =B1104%   +4944.9%       0.29 =B1 76%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.step_into.w=
alk_component
      0.11 =B1223%    +760.9%       0.93 =B1 99%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.strncpy_fro=
m_user.getname_flags
      1.57 =B1141%    +269.0%       5.78 =B1 19%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.thread_grou=
p_cputime.thread_group_cputime_adjusted
      0.07 =B1223%    +915.4%       0.67 =B1 67%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.unmap_page_=
range.unmap_vmas
      0.01 =B1223%   +7943.2%       0.50 =B1123%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.unmap_vmas.=
exit_mmap
      2.91 =B1 73%     -87.7%       0.36 =B1 95%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.kme=
m_cache_alloc.vm_area_dup
      0.00 =B1173%   +1014.3%       0.04 =B1 88%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.cre=
ate_elf_tables.isra
      1.94 =B1 53%     -83.8%       0.31 =B1 39%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.get=
_obj_cgroup_from_current.kmem_cache_alloc
      4.04 =B1 46%     -91.6%       0.34 =B1 87%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.kme=
m_cache_alloc.anon_vma_clone
      2.23 =B1 33%     -80.9%       0.43 =B1 61%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.kme=
m_cache_alloc.anon_vma_fork
      2.36 =B1 42%     -81.8%       0.43 =B1 73%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.kme=
m_cache_alloc.vm_area_dup
      0.15 =B1164%    +417.2%       0.78 =B1 64%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.up_=
read.do_user_addr_fault
      0.41 =B1166%   +1891.6%       8.25 =B1 60%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.__alloc_file
      0.04 =B1203%  +39096.9%      15.81 =B1 44%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.__d_alloc
      1.17 =B1222%   +1833.9%      22.67 =B1 43%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.anon_vma_clone
      2.06 =B1139%    +618.3%      14.83 =B1 92%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.anon_vma_fork
      2.16 =B1 34%     -72.0%       0.60 =B1 52%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_lockdep_curr=
ent_cpu_online.rcu_read_lock_held_common.rcu_read_lock_held
    310.63 =B1 21%     -33.9%     205.44 =B1  9%  perf-sched.wait_time.avg.=
ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_sys_=
poll
     71.01 =B1  4%     -96.6%       2.40 =B1  9%  perf-sched.wait_time.avg.=
ms.worker_thread.kthread.ret_from_fork
      1.50 =B1134%    +782.0%      13.23 =B1 58%  perf-sched.wait_time.max.=
ms.exit_to_user_mode_prepare.syscall_exit_to_user_mode.do_syscall_64.entry_=
SYSCALL_64_after_hwframe
      0.93 =B1193%  +32546.6%     303.18 =B1147%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.__mutex_lock.perf_poll.do=
_sys_poll
      0.57 =B1222%    +771.6%       4.94 =B1 78%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.__mutex_lock.uprobe_clear=
_state.mmput
      7.07 =B1 48%    +176.2%      19.53 =B1 14%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_read_unlock.wait_tas=
k_zombie.do_wait
      0.00 =B1223%   +7686.3%       0.32 =B1155%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.__pte_al=
loc.do_anonymous_page
      0.00 =B1223%  +21741.1%       0.58 =B1155%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.__pte_al=
loc.finish_fault
      2.40 =B1124%  +41821.9%       1004        perf-sched.wait_time.max.ms=
.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.do_anonymo=
us_page.__handle_mm_fault
      0.08 =B1223%   +4129.1%       3.21 =B1 41%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.do_exit.=
do_group_exit
      0.02 =B1158%    +824.4%       0.18 =B1 91%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.follow_p=
age_pte.__get_user_pages
      2.25 =B1141%    +139.2%       5.38 =B1 68%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.shmem_mk=
nod.lookup_open
      3.11 =B1 84%  +23006.2%     718.99 =B1 62%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.wp_page_=
copy.__handle_mm_fault
     11.01 =B1 26%   +6440.1%     720.17 =B1 61%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.zap_pte_=
range.unmap_page_range
      1.51 =B1150%    +538.7%       9.66 =B1 21%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.rele=
ase_task.wait_task_zombie
      9.42 =B1 30%  +13230.7%       1255 =B1 21%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.shme=
m_add_to_page_cache.shmem_getpage_gfp
      1.81 =B1152%    +830.7%      16.83 =B1 35%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.wait=
_task_zombie.do_wait
      8.13 =B1 35%    +140.9%      19.60 =B1 39%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.delete_from_page_cache.truncate_inode_page
      1.67 =B1155%    +419.5%       8.66 =B1 42%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.do_wait.kernel_wait4
      3.27 =B1114%    +325.8%      13.93 =B1 33%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.rcu_preempt_deferred_qs_irqrestore.__rcu_read_unlock
      3.40 =B1100%    +322.3%      14.35 =B1 26%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.release_pages.__pagevec_release
      2.40 =B1 53%    +232.2%       7.98 =B1 51%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.release_pages.tlb_flush_mmu
     12.67 =B1 30%     +53.0%      19.38 =B1 15%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.sched_move_task.do_exit
      1.04 =B1222%   +1216.2%      13.75 =B1 30%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.thread_group_cputime_adjusted.wait_task_zombie
      6.34 =B1 23%   +2406.8%     158.86 =B1216%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_write_unlock_irq.rel=
ease_task.wait_task_zombie
      0.00 =B1223%  +48803.6%       1.96 =B1155%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.d_alloc_parallel.lookup_o=
pen.path_openat
      1.16 =B1223%    +979.8%      12.49 =B1 46%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.lru_add_drain.__pagevec_r=
elease.shmem_undo_range
      2.32 =B1 75%   +6569.2%     154.86 =B1222%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.lru_add_drain.exit_mmap.m=
mput
      7.51 =B1 49%  +13964.7%       1056 =B1 76%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.lru_cache_add.shmem_getpa=
ge_gfp.shmem_write_begin
      0.00 =B1223%  +1.9e+05%       3.86 =B1205%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.touch_atime.pick_link.ste=
p_into
      1.89 =B1120%    +217.2%       6.01 =B1 34%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.try_to_wake_up.wake_up_q.=
rwsem_wake
      5.55 =B1 80%    -100.0%       0.00 =B1244%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.__loc=
al_bh_enable_ip.arch_do_signal_or_restart
      0.00 =B1223%  +62691.8%       1.47 =B1194%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.___might_sl=
eep.kmem_cache_alloc
      0.00 =B1223%   +7173.5%       0.08 =B1209%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.___might_sl=
eep.task_work_run
      0.00 =B1223%  +6.5e+06%     269.83 =B1239%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__alloc_pag=
es.alloc_pages_vma
      0.69 =B1116%   +1181.7%       8.87 =B1 44%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__handle_mm=
_fault.handle_mm_fault
      0.07 =B1213%   +6062.5%       4.12 =B1 92%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__mem_cgrou=
p_charge.mem_cgroup_charge
      0.07 =B1164%   +5287.8%       3.52 =B1 90%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__might_sle=
ep.do_user_addr_fault
      0.01 =B1223%   +7326.2%       0.45 =B1108%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__might_sle=
ep.kmem_cache_alloc
      1.13 =B1223%    +548.7%       7.35 =B1110%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__might_sle=
ep.pagecache_get_page
      0.00 =B1223%  +56926.8%       1.52 =B1214%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__pmd_alloc=
.copy_page_range
      0.00 =B1223%   +2255.3%       0.09 =B1 73%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__rcu_read_=
lock.get_obj_cgroup_from_current
      0.01 =B1149%    +673.6%       0.05 =B1 73%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__rcu_read_=
unlock.memcg_slab_free_hook
      0.01 =B1223%   +1334.2%       0.13 =B1 78%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__virt_addr=
_valid.__check_object_size
      0.00 =B1223%  +19252.4%       0.29 =B1163%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__vma_link_=
rb.vma_link
      0.00 =B1223%   +2439.3%       0.10 =B1113%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi._copy_from_=
user.copy_strings
      0.05 =B1200%  +10677.3%       4.89 =B1 79%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.account_ker=
nel_stack.dup_task_struct
      0.00 =B1223%  +1.1e+05%       4.92 =B1132%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.acct_collec=
t.do_exit
      0.00 =B1223%  +24379.4%       1.10 =B1219%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.anon_vma_in=
terval_tree_insert.anon_vma_clone
      0.00 =B1223%  +14153.1%       0.33 =B1122%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.call_rcu.__=
dentry_kill
      0.02 =B1223%  +27738.5%       4.69 =B1122%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.check_stack=
_object.__check_object_size
      0.01 =B1141%  +15807.9%       1.30 =B1197%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.copy_string=
s.isra
      0.08 =B1223%   +5409.9%       4.52 =B1 87%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.copy_user_e=
nhanced_fast_string.copyout
      0.33 =B1134%   +1612.6%       5.58 =B1 54%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.debug_lockd=
ep_rcu_enabled.___might_sleep
      0.00 =B1223%   +5000.0%       0.08 =B1126%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.debug_lockd=
ep_rcu_enabled.get_obj_cgroup_from_current
      0.15 =B1138%   +3202.9%       4.97 =B1 56%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.debug_lockd=
ep_rcu_enabled.rcu_read_lock_held_common
      0.53 =B1 42%   +2440.7%      13.42 =B1 36%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.do_user_add=
r_fault.exc_page_fault
      0.52 =B1109%   +1741.8%       9.54 =B1 19%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.exit_to_use=
r_mode_prepare
      1.47 =B1180%    +779.0%      12.90 =B1 39%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.exit_to_use=
r_mode_prepare.syscall_exit_to_user_mode
      0.34 =B1163%   +3235.6%      11.44 =B1 25%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.find_vma.do=
_user_addr_fault
      0.00 =B1223%  +13706.9%       0.58 =B1215%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.free_unref_=
page_list.release_pages
      0.00 =B1223%  +1.6e+05%       3.95 =B1123%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.generic_per=
form_write.__generic_file_write_iter
      0.00 =B1223%  +15517.1%       0.13 =B1185%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.get_mem_cgr=
oup_from_objcg.obj_cgroup_charge_pages
      0.11 =B1161%  +1.4e+05%     145.15 =B1240%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.get_obj_cgr=
oup_from_current.kmem_cache_alloc
      0.00 =B1223%   +8128.6%       0.19 =B1135%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.handle_mm_f=
ault.__get_user_pages
      0.31 =B1105%   +3112.1%       9.98 =B1 16%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.handle_mm_f=
ault.do_user_addr_fault
      0.22 =B1135%   +2566.3%       5.80 =B1 55%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.kmem_cache_=
alloc.__alloc_file
      0.01 =B1109%   +7095.6%       0.71 =B1151%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.kmem_cache_=
alloc.security_file_alloc
      0.03 =B1186%   +5975.7%       1.64 =B1212%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.kmem_cache_=
alloc.vm_area_alloc
      0.17 =B1181%   +3002.3%       5.41 =B1 62%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.kmem_cache_=
alloc.vm_area_dup
      0.00 =B1223%  +1.2e+05%       3.07 =B1122%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.kmem_cache_=
free.do_sys_openat2
      1.52 =B1180%  +28630.2%     437.90 =B1112%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.ktime_get_c=
oarse_real_ts64.current_time
      0.07 =B1223%  +10748.6%       7.36 =B1154%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.link_path_w=
alk.part
      0.02 =B1179%  +15642.6%       2.49 =B1141%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.__memcg_kmem_charge_page
      1.72 =B1121%    +740.8%      14.50 =B1 80%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.__might_fault
      0.00 =B1223%  +13528.6%       0.20 =B1192%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.__task_pid_nr_ns
      0.00 =B1223%  +1.6e+05%       6.69 =B1 64%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.aa_file_perm
      0.00 =B1223%  +59020.5%       2.27 =B1131%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.cgroup_throttle_swaprate
      0.09 =B1207%   +1812.0%       1.69 =B1 94%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.down_read
      1.48 =B1156%    +642.8%      11.02 =B1 50%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.down_write
      0.00 =B1223%  +20134.9%       0.91 =B1232%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.filemap_get_read_batch
      5.13 =B1 61%    +189.8%      14.88 =B1 46%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.fs_reclaim_acquire
      0.59 =B1203%   +1013.4%       6.55 =B1 49%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.get_mem_cgroup_from_objcg
      0.27 =B1 89%   +3684.7%      10.33 =B1 26%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.handle_mm_fault
      0.00 =B1223%    +3e+05%       7.02 =B1 89%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.mnt_want_write
      0.00 =B1223%  +68600.0%       1.60 =B1127%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.mntput_no_expire
      0.23 =B1152%  +63872.1%     147.14 =B1236%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.pagecache_get_page
      0.00 =B1223%  +17083.2%       0.49 =B1172%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.perf_iterate_sb
      5.92 =B1 38%    +104.5%      12.11 =B1 29%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_is_hel=
d_type.___might_sleep
      1.24 =B1205%    +369.3%       5.81 =B1 42%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_is_hel=
d_type.mem_cgroup_from_task
      2.56 =B1108%   +5832.7%     151.68 =B1228%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_is_hel=
d_type.rcu_read_lock_held
      0.08 =B1204%   +6275.1%       5.39 =B1 97%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_is_hel=
d_type.xas_start
      0.18 =B1141%   +1652.7%       3.18 =B1127%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e.__alloc_pages
      0.00 =B1223%  +1.5e+05%       4.96 =B1 71%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e.aa_file_perm
      0.13 =B1223%   +2434.5%       3.35 =B1 96%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e.get_mem_cgroup_from_mm
      0.06 =B1173%   +4990.9%       2.84 =B1128%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e.get_mem_cgroup_from_objcg
      0.00 =B1223%  +29529.7%       1.23 =B1165%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e.get_user_arg_ptr
      0.09 =B1167%   +3688.7%       3.57 =B1 89%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e.handle_mm_fault
      0.10 =B1166%  +1.4e+05%     144.52 =B1241%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e.up_read
      0.30 =B1140%   +2334.1%       7.41 =B1114%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.page_counte=
r_try_charge.obj_cgroup_charge_pages
      0.01 =B1223%  +18087.1%       2.15 =B1148%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.path_openat=
.do_filp_open
      0.01 =B1223%  +49341.1%       3.96 =B1110%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.rcu_read_lo=
ck_held_common.rcu_read_lock_held
      0.22 =B1152%   +3582.4%       8.22 =B1 81%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.refill_obj_=
stock.obj_cgroup_charge
      0.01 =B1104%  +94192.9%       5.66 =B1 82%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.step_into.w=
alk_component
      0.11 =B1223%   +4235.2%       4.67 =B1 86%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.strncpy_fro=
m_user.getname_flags
      1.63 =B1147%    +693.9%      12.96 =B1 31%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.syscall_ent=
er_from_user_mode.do_syscall_64
      0.49 =B1 76%   +1354.1%       7.06 =B1 40%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.syscall_exi=
t_to_user_mode_prepare.syscall_exit_to_user_mode
      2.36 =B1153%    +532.7%      14.90 =B1 45%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.thread_grou=
p_cputime.thread_group_cputime_adjusted
      0.02 =B1192%   +7757.4%       1.62 =B1191%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.try_charge.=
__mem_cgroup_charge
      0.01 =B1223%   +5863.0%       0.51 =B1216%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.uncharge_ba=
tch.mem_cgroup_uncharge_list
      0.13 =B1223%   +2934.5%       4.02 =B1 52%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.unmap_page_=
range.unmap_vmas
      0.01 =B1223%  +39090.0%       2.42 =B1134%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.unmap_vmas.=
exit_mmap
      5.55 =B1 36%   +4888.5%     276.68 =B1232%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.__perf_sw_event.=
handle_mm_fault.do_user_addr_fault
      0.01 =B1160%   +4986.6%       0.54 =B1201%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.kmem_cache_free.=
___pte_free_tlb.free_p4d_range
      7.37 =B1  9%   +2047.6%     158.29 =B1217%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.fs_=
reclaim_acquire.kmem_cache_alloc
      1.90 =B1142%    +320.8%       8.00 =B1 10%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.pag=
ecache_get_page.shmem_getpage_gfp
      0.00 =B1150%   +7446.6%       0.29 =B1107%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.cre=
ate_elf_tables.isra
      0.02 =B1120%   +7077.1%       1.08 =B1215%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.try=
_to_unlazy.path_openat
      0.34 =B1149%   +2030.2%       7.21 =B1 37%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.up_=
read.do_user_addr_fault
      1.38 =B1205%  +62408.7%     862.20 =B1 40%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.__alloc_file
      0.11 =B1215%    +8e+05%     861.59 =B1 40%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.__d_alloc
      1.35 =B1222%  +63833.9%     863.32 =B1 39%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.anon_vma_clone
      2.09 =B1136%  +34318.0%     719.28 =B1 62%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.anon_vma_fork
      0.10 =B1223%   +1755.1%       1.94 =B1162%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.vm_area_alloc
      2.24 =B1137%   +6776.7%     153.76 =B1225%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.vm_area_dup
      1.02 =B1139%  +14761.3%     151.86 =B1228%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
memcg_slab_free_hook.kmem_cache_free
      0.21 =B1 66%    +703.0%       1.70 =B1114%  perf-sched.wait_time.max.=
ms.rwsem_down_write_slowpath.__vma_adjust.__split_vma.mprotect_fixup
      8.58 =B1 26%   +3400.3%     300.47 =B1147%  perf-sched.wait_time.max.=
ms.rwsem_down_write_slowpath.anon_vma_clone.anon_vma_fork.dup_mmap



***************************************************************************=
************************
lkp-csl-2ap2: 192 threads 4 sockets Intel(R) Xeon(R) Platinum 9242 CPU @ 2.=
30GHz with 192G memory
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
compiler/cpufreq_governor/disk/filesize/fs/iterations/kconfig/nr_threads/ro=
otfs/sync_method/tbox_group/test_size/testcase/ucode:
  gcc-9/performance/1BRD_48G/4M/btrfs/1x/x86_64-rhel-8.3/1t/debian-10.4-x86=
_64-20200603.cgz/fsyncBeforeClose/lkp-csl-2ap2/24G/fsmark/0x5003006

commit:=20
  0c7c5da68b ("memcg: switch lruvec stats to rstat")
  cda0d20525 ("memcg: infrastructure to flush memcg stats")

0c7c5da68b4a09ff cda0d205259a7e7c1f8e296130a=20
---------------- ---------------------------=20
         %stddev     %change         %stddev
             \          |                \ =20
     55.18            -6.9%      51.40        fsmark.files_per_sec
    120.73            +7.8%     130.20        fsmark.time.elapsed_time
    120.73            +7.8%     130.20        fsmark.time.elapsed_time.max
    116.29            +7.5%     125.06        fsmark.time.system_time
      0.62            +0.3        0.91        mpstat.cpu.all.sys%
      9117 =B1  4%    +154.2%      23180 =B1  5%  numa-meminfo.node3.Active=
(anon)
     12157 =B1  4%    +118.1%      26513 =B1  5%  meminfo.Active(anon)
     31896           +59.5%      50869 =B1  2%  meminfo.Shmem
      2274 =B1  4%    +152.8%       5749 =B1  5%  numa-vmstat.node3.nr_acti=
ve_anon
      5404 =B1 30%     +58.1%       8546 =B1 18%  numa-vmstat.node3.nr_shmem
      2274 =B1  4%    +152.8%       5749 =B1  5%  numa-vmstat.node3.nr_zone=
_active_anon
    207967            -7.3%     192752        vmstat.io.bo
      1.00          +100.0%       2.00        vmstat.procs.r
      2604          +872.7%      25334        vmstat.system.cs
     19899 =B1  5%     +12.2%      22332 =B1  5%  softirqs.CPU1.SCHED
     17317 =B1  5%     +15.3%      19971 =B1  5%  softirqs.CPU100.SCHED
     18092 =B1  6%     +14.0%      20631 =B1  4%  softirqs.CPU108.SCHED
     32264 =B1 14%     -13.8%      27817 =B1 17%  softirqs.CPU109.RCU
     18441 =B1  3%     +11.2%      20507 =B1  4%  softirqs.CPU118.SCHED
     18586 =B1  2%     +13.6%      21117 =B1  7%  softirqs.CPU9.SCHED
      9915 =B1 57%     +99.8%      19814 =B1  4%  softirqs.CPU96.SCHED
      3039 =B1  4%    +118.1%       6628 =B1  5%  proc-vmstat.nr_active_anon
     33813            -1.1%      33430        proc-vmstat.nr_active_file
      9198            +9.8%      10100        proc-vmstat.nr_mapped
      7974           +59.5%      12722 =B1  2%  proc-vmstat.nr_shmem
      3039 =B1  4%    +118.1%       6628 =B1  5%  proc-vmstat.nr_zone_activ=
e_anon
     33813            -1.1%      33430        proc-vmstat.nr_zone_active_fi=
le
      4926 =B1  5%     -55.8%       2176 =B1 31%  proc-vmstat.numa_hint_fau=
lts
      3990 =B1 22%     -63.0%       1475 =B1 43%  proc-vmstat.numa_hint_fau=
lts_local
     27189           +74.6%      47479        proc-vmstat.pgactivate
    666580            +4.9%     699366        proc-vmstat.pgfault
    799.00 =B1 21%     +87.1%       1495 =B1 12%  slabinfo.btrfs_trans_hand=
le.active_objs
    799.00 =B1 21%     +87.1%       1495 =B1 12%  slabinfo.btrfs_trans_hand=
le.num_objs
      2044 =B1 22%    +118.4%       4466 =B1 12%  slabinfo.ext4_io_end_vec.=
active_objs
      2044 =B1 22%    +118.4%       4466 =B1 12%  slabinfo.ext4_io_end_vec.=
num_objs
     15776 =B1  5%      -7.0%      14666 =B1  2%  slabinfo.kmalloc-128.num_=
objs
      3212 =B1 20%     +27.2%       4087 =B1  6%  slabinfo.posix_timers_cac=
he.active_objs
      3226 =B1 19%     +26.9%       4094 =B1  6%  slabinfo.posix_timers_cac=
he.num_objs
      1151 =B1  5%      -8.7%       1050 =B1  3%  slabinfo.task_group.activ=
e_objs
      1151 =B1  5%      -8.7%       1050 =B1  3%  slabinfo.task_group.num_o=
bjs
      2777 =B1  6%     +14.6%       3183 =B1  5%  slabinfo.xfs_efd_item.act=
ive_objs
      2779 =B1  6%     +14.6%       3184 =B1  5%  slabinfo.xfs_efd_item.num=
_objs
 3.698e+09 =B1  5%     +23.1%  4.551e+09 =B1  6%  perf-stat.i.branch-instru=
ctions
      2464          +929.5%      25372        perf-stat.i.context-switches
  1.64e+10 =B1  4%     +18.0%  1.936e+10 =B1  8%  perf-stat.i.cpu-cycles
 5.176e+09 =B1  5%     +21.1%  6.266e+09 =B1  5%  perf-stat.i.dTLB-loads
 1.736e+10 =B1  5%     +22.1%  2.121e+10 =B1  6%  perf-stat.i.instructions
      5079 =B1 10%     +40.6%       7140 =B1 11%  perf-stat.i.instructions-=
per-iTLB-miss
      3.83 =B1 15%     -15.3%       3.25 =B1  6%  perf-stat.i.major-faults
      0.09 =B1  4%     +18.1%       0.10 =B1  8%  perf-stat.i.metric.GHz
     61.30 =B1  5%     +21.0%      74.16 =B1  5%  perf-stat.i.metric.M/sec
      4956            -2.5%       4835        perf-stat.i.minor-faults
      4960            -2.5%       4838        perf-stat.i.page-faults
      5096 =B1 10%     +40.5%       7158 =B1 11%  perf-stat.overall.instruc=
tions-per-iTLB-miss
 3.666e+09 =B1  5%     +23.1%  4.515e+09 =B1  6%  perf-stat.ps.branch-instr=
uctions
      2442          +930.3%      25167        perf-stat.ps.context-switches
 1.626e+10 =B1  4%     +18.1%  1.921e+10 =B1  8%  perf-stat.ps.cpu-cycles
 5.132e+09 =B1  5%     +21.1%  6.217e+09 =B1  5%  perf-stat.ps.dTLB-loads
 1.721e+10 =B1  5%     +22.2%  2.104e+10 =B1  6%  perf-stat.ps.instructions
      3.80 =B1 15%     -15.4%       3.22 =B1  6%  perf-stat.ps.major-faults
      4909            -2.4%       4793        perf-stat.ps.minor-faults
      4913            -2.4%       4796        perf-stat.ps.page-faults
 2.086e+12 =B1  4%     +31.9%  2.751e+12 =B1  5%  perf-stat.total.instructi=
ons
    525504 =B1  4%      +9.9%     577408 =B1  2%  interrupts.CAL:Function_c=
all_interrupts
      2667 =B1  4%     +25.3%       3341 =B1 25%  interrupts.CPU0.CAL:Funct=
ion_call_interrupts
      2533 =B1  4%    +128.4%       5785 =B1 57%  interrupts.CPU1.CAL:Funct=
ion_call_interrupts
      2204 =B1 26%    +111.5%       4663 =B1 87%  interrupts.CPU10.CAL:Func=
tion_call_interrupts
      6.50 =B1 90%   +3190.1%     213.86 =B1144%  interrupts.CPU102.RES:Res=
cheduling_interrupts
    215.33 =B1 33%    +117.8%     469.00 =B1 42%  interrupts.CPU108.NMI:Non=
-maskable_interrupts
    215.33 =B1 33%    +117.8%     469.00 =B1 42%  interrupts.CPU108.PMI:Per=
formance_monitoring_interrupts
    202.00 =B1 29%     +56.4%     316.00 =B1 32%  interrupts.CPU117.NMI:Non=
-maskable_interrupts
    202.00 =B1 29%     +56.4%     316.00 =B1 32%  interrupts.CPU117.PMI:Per=
formance_monitoring_interrupts
    222.17 =B1 34%    +114.0%     475.43 =B1 40%  interrupts.CPU12.NMI:Non-=
maskable_interrupts
    222.17 =B1 34%    +114.0%     475.43 =B1 40%  interrupts.CPU12.PMI:Perf=
ormance_monitoring_interrupts
      2452           +65.9%       4069 =B1 62%  interrupts.CPU122.CAL:Funct=
ion_call_interrupts
    193.50 =B1 32%     +93.1%     373.57 =B1 36%  interrupts.CPU14.NMI:Non-=
maskable_interrupts
    193.50 =B1 32%     +93.1%     373.57 =B1 36%  interrupts.CPU14.PMI:Perf=
ormance_monitoring_interrupts
    192.17 =B1 38%    +127.9%     438.00 =B1 45%  interrupts.CPU15.NMI:Non-=
maskable_interrupts
    192.17 =B1 38%    +127.9%     438.00 =B1 45%  interrupts.CPU15.PMI:Perf=
ormance_monitoring_interrupts
      7.17 =B1130%   +6177.1%     449.86 =B1129%  interrupts.CPU17.RES:Resc=
heduling_interrupts
      2472 =B1  2%     +56.4%       3868 =B1 64%  interrupts.CPU26.CAL:Func=
tion_call_interrupts
      9.67 =B1155%   +2832.0%     283.43 =B1138%  interrupts.CPU3.RES:Resch=
eduling_interrupts
      3.83 =B1 96%   +7223.0%     280.71 =B1106%  interrupts.CPU4.RES:Resch=
eduling_interrupts
      7.50 =B1 99%   +4263.8%     327.29 =B1105%  interrupts.CPU5.RES:Resch=
eduling_interrupts
    161.17 =B1 20%     +46.3%     235.86 =B1 15%  interrupts.CPU81.NMI:Non-=
maskable_interrupts
    161.17 =B1 20%     +46.3%     235.86 =B1 15%  interrupts.CPU81.PMI:Perf=
ormance_monitoring_interrupts
     51316 =B1  6%     +20.1%      61616 =B1  8%  interrupts.NMI:Non-maskab=
le_interrupts
     51316 =B1  6%     +20.1%      61616 =B1  8%  interrupts.PMI:Performanc=
e_monitoring_interrupts
      1298 =B1  7%   +1608.1%      22176 =B1  9%  interrupts.RES:Rescheduli=
ng_interrupts
      0.01 =B1 19%     -72.9%       0.00 =B1 26%  perf-sched.sch_delay.avg.=
ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_sys_=
poll
      0.02 =B1 29%     -68.9%       0.01        perf-sched.sch_delay.avg.ms=
.worker_thread.kthread.ret_from_fork
      0.01 =B1 20%     -31.4%       0.01 =B1  6%  perf-sched.total_sch_dela=
y.average.ms
    220.68           -89.1%      24.00 =B1  2%  perf-sched.total_wait_and_d=
elay.average.ms
     11823          +833.5%     110368        perf-sched.total_wait_and_del=
ay.count.ms
      9308 =B1  6%     -26.6%       6835 =B1 15%  perf-sched.total_wait_and=
_delay.max.ms
    220.66           -89.1%      23.99 =B1  2%  perf-sched.total_wait_time.=
average.ms
      9307 =B1  6%     -26.6%       6835 =B1 15%  perf-sched.total_wait_tim=
e.max.ms
      0.07 =B1  2%    -100.0%       0.00        perf-sched.wait_and_delay.a=
vg.ms.btrfs_start_ordered_extent.btrfs_wait_ordered_range.btrfs_sync_file.d=
o_fsync
      2.74          -100.0%       0.00        perf-sched.wait_and_delay.avg=
.ms.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64
      6.82 =B1 28%     -36.0%       4.36        perf-sched.wait_and_delay.a=
vg.ms.preempt_schedule_common.preempt_schedule_thunk.cpu_stop_queue_work.af=
fine_move_task.__set_cpus_allowed_ptr
      4.20 =B1  9%    -100.0%       0.00        perf-sched.wait_and_delay.a=
vg.ms.rcu_gp_kthread.kthread.ret_from_fork
    108.93 =B1141%    +176.8%     301.52 =B1 36%  perf-sched.wait_and_delay=
.avg.ms.schedule_hrtimeout_range_clock.ep_poll.do_epoll_wait.__x64_sys_epol=
l_wait
    622.38 =B1 23%     -49.8%     312.43 =B1  2%  perf-sched.wait_and_delay=
.avg.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do=
_sys_poll
      0.01 =B1 26%    -100.0%       0.00        perf-sched.wait_and_delay.a=
vg.ms.wait_for_partner.fifo_open.do_dentry_open.do_open.isra
    300.44 =B1  5%     -98.4%       4.68 =B1  9%  perf-sched.wait_and_delay=
.avg.ms.worker_thread.kthread.ret_from_fork
    541.33          -100.0%       0.00        perf-sched.wait_and_delay.cou=
nt.btrfs_start_ordered_extent.btrfs_wait_ordered_range.btrfs_sync_file.do_f=
sync
    306.00          -100.0%       0.00        perf-sched.wait_and_delay.cou=
nt.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64
    397.67 =B1 10%    -100.0%       0.00        perf-sched.wait_and_delay.c=
ount.rcu_gp_kthread.kthread.ret_from_fork
     21.67 =B1  4%    +167.7%      58.00 =B1  3%  perf-sched.wait_and_delay=
.count.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_=
sys_poll
     72.00          -100.0%       0.00        perf-sched.wait_and_delay.cou=
nt.wait_for_partner.fifo_open.do_dentry_open.do_open.isra
      1328         +7408.2%      99708        perf-sched.wait_and_delay.cou=
nt.worker_thread.kthread.ret_from_fork
      0.24 =B1  9%    -100.0%       0.00        perf-sched.wait_and_delay.m=
ax.ms.btrfs_start_ordered_extent.btrfs_wait_ordered_range.btrfs_sync_file.d=
o_fsync
     41.50          -100.0%       0.00        perf-sched.wait_and_delay.max=
.ms.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64
      5.03          -100.0%       0.00        perf-sched.wait_and_delay.max=
.ms.rcu_gp_kthread.kthread.ret_from_fork
      0.09 =B1 65%    -100.0%       0.00        perf-sched.wait_and_delay.m=
ax.ms.wait_for_partner.fifo_open.do_dentry_open.do_open.isra
      8288 =B1 10%     -18.9%       6725 =B1 15%  perf-sched.wait_and_delay=
.max.ms.worker_thread.kthread.ret_from_fork
      0.06 =B1  2%     +18.6%       0.07 =B1  2%  perf-sched.wait_time.avg.=
ms.btrfs_start_ordered_extent.btrfs_wait_ordered_range.btrfs_sync_file.do_f=
sync
      6.82 =B1 28%     -36.1%       4.36        perf-sched.wait_time.avg.ms=
.preempt_schedule_common.preempt_schedule_thunk.cpu_stop_queue_work.affine_=
move_task.__set_cpus_allowed_ptr
      0.06 =B1 41%     -77.1%       0.01 =B1158%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk.cpu_stop_queue_work.stop_=
one_cpu.migrate_task_to
    131.30 =B1105%    +129.6%     301.49 =B1 36%  perf-sched.wait_time.avg.=
ms.schedule_hrtimeout_range_clock.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
    622.37 =B1 23%     -49.8%     312.42 =B1  2%  perf-sched.wait_time.avg.=
ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_sys_=
poll
    300.41 =B1  5%     -98.4%       4.67 =B1  9%  perf-sched.wait_time.avg.=
ms.worker_thread.kthread.ret_from_fork
      0.23 =B1  9%    +119.2%       0.50 =B1 36%  perf-sched.wait_time.max.=
ms.btrfs_start_ordered_extent.btrfs_wait_ordered_range.btrfs_sync_file.do_f=
sync
      0.03 =B1100%    +297.4%       0.11 =B1 24%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.__set_page_dirty_nobuffers.btrfs_dirty_pages
      0.06 =B1 41%     -77.1%       0.01 =B1158%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.cpu_stop_queue_work.stop_=
one_cpu.migrate_task_to
     14.70 =B1  5%     +16.6%      17.14 =B1  4%  perf-sched.wait_time.max.=
ms.schedule_timeout.rcu_gp_kthread.kthread.ret_from_fork
      8288 =B1 10%     -18.9%       6725 =B1 15%  perf-sched.wait_time.max.=
ms.worker_thread.kthread.ret_from_fork
     78.84 =B1  2%      -5.7       73.09 =B1  3%  perf-profile.calltrace.cy=
cles-pp.cpu_startup_entry.start_secondary.secondary_startup_64_no_verify
     78.84 =B1  2%      -5.7       73.09 =B1  3%  perf-profile.calltrace.cy=
cles-pp.start_secondary.secondary_startup_64_no_verify
     78.80 =B1  2%      -5.7       73.05 =B1  3%  perf-profile.calltrace.cy=
cles-pp.do_idle.cpu_startup_entry.start_secondary.secondary_startup_64_no_v=
erify
     79.28 =B1  2%      -5.5       73.80 =B1  2%  perf-profile.calltrace.cy=
cles-pp.secondary_startup_64_no_verify
      6.75 =B1  6%      -0.7        6.05 =B1  4%  perf-profile.calltrace.cy=
cles-pp.irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_inte=
rrupt.cpuidle_enter_state.cpuidle_enter
      0.86 =B1 19%      -0.3        0.52 =B1 42%  perf-profile.calltrace.cy=
cles-pp.__lock_acquire.lock_acquire.ktime_get_update_offsets_now.hrtimer_in=
terrupt.__sysvec_apic_timer_interrupt
      0.66 =B1  8%      -0.2        0.41 =B1 63%  perf-profile.calltrace.cy=
cles-pp.lock_release._raw_spin_unlock_irqrestore.__hrtimer_run_queues.hrtim=
er_interrupt.__sysvec_apic_timer_interrupt
      0.74 =B1 11%      -0.2        0.52 =B1 41%  perf-profile.calltrace.cy=
cles-pp.btrfs_set_extent_delalloc.btrfs_dirty_pages.btrfs_buffered_write.bt=
rfs_file_write_iter.new_sync_write
      0.73 =B1 10%      -0.2        0.52 =B1 41%  perf-profile.calltrace.cy=
cles-pp.set_extent_bit.btrfs_set_extent_delalloc.btrfs_dirty_pages.btrfs_bu=
ffered_write.btrfs_file_write_iter
      1.92 =B1  5%      -0.2        1.73 =B1  7%  perf-profile.calltrace.cy=
cles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.23 =B1  9%      -0.2        1.05 =B1  9%  perf-profile.calltrace.cy=
cles-pp._raw_spin_lock_irq.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_=
apic_timer_interrupt.sysvec_apic_timer_interrupt
      1.00 =B1  8%      -0.2        0.83 =B1  8%  perf-profile.calltrace.cy=
cles-pp.rcu_read_lock_sched_held.__hrtimer_run_queues.hrtimer_interrupt.__s=
ysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt
      1.15 =B1  8%      -0.2        0.98 =B1  9%  perf-profile.calltrace.cy=
cles-pp.lock_acquire._raw_spin_lock_irq.__hrtimer_run_queues.hrtimer_interr=
upt.__sysvec_apic_timer_interrupt
      0.66 =B1 10%      -0.1        0.58 =B1  7%  perf-profile.calltrace.cy=
cles-pp.lock_release.ktime_get.tick_irq_enter.irq_enter_rcu.sysvec_apic_tim=
er_interrupt
      0.00            +1.0        0.97 =B1 11%  perf-profile.calltrace.cycl=
es-pp.rcu_read_lock_sched_held.lock_acquire._raw_spin_lock.cgroup_rstat_flu=
sh_locked.cgroup_rstat_flush_irqsafe
      0.00            +1.0        1.01 =B1 14%  perf-profile.calltrace.cycl=
es-pp.rcu_read_lock_sched_held.lock_release._raw_spin_unlock.cgroup_rstat_f=
lush_locked.cgroup_rstat_flush_irqsafe
      0.00            +1.6        1.60 =B1 13%  perf-profile.calltrace.cycl=
es-pp.lock_release._raw_spin_unlock.cgroup_rstat_flush_locked.cgroup_rstat_=
flush_irqsafe.mem_cgroup_flush_stats
      0.00            +1.8        1.85 =B1 13%  perf-profile.calltrace.cycl=
es-pp._raw_spin_unlock.cgroup_rstat_flush_locked.cgroup_rstat_flush_irqsafe=
.mem_cgroup_flush_stats.process_one_work
      0.00            +2.3        2.26 =B1 10%  perf-profile.calltrace.cycl=
es-pp.__lock_acquire.lock_acquire._raw_spin_lock.cgroup_rstat_flush_locked.=
cgroup_rstat_flush_irqsafe
      0.00            +3.7        3.74 =B1 11%  perf-profile.calltrace.cycl=
es-pp.lock_acquire._raw_spin_lock.cgroup_rstat_flush_locked.cgroup_rstat_fl=
ush_irqsafe.mem_cgroup_flush_stats
      0.00            +3.9        3.86 =B1 11%  perf-profile.calltrace.cycl=
es-pp._raw_spin_lock.cgroup_rstat_flush_locked.cgroup_rstat_flush_irqsafe.m=
em_cgroup_flush_stats.process_one_work
      0.00            +6.8        6.79 =B1 10%  perf-profile.calltrace.cycl=
es-pp.cgroup_rstat_flush_locked.cgroup_rstat_flush_irqsafe.mem_cgroup_flush=
_stats.process_one_work.worker_thread
      0.00            +6.8        6.83 =B1 10%  perf-profile.calltrace.cycl=
es-pp.cgroup_rstat_flush_irqsafe.mem_cgroup_flush_stats.process_one_work.wo=
rker_thread.kthread
      0.00            +7.0        6.96 =B1 10%  perf-profile.calltrace.cycl=
es-pp.mem_cgroup_flush_stats.process_one_work.worker_thread.kthread.ret_fro=
m_fork
      0.00            +7.3        7.30 =B1 10%  perf-profile.calltrace.cycl=
es-pp.process_one_work.worker_thread.kthread.ret_from_fork
      0.00            +7.8        7.78 =B1 10%  perf-profile.calltrace.cycl=
es-pp.worker_thread.kthread.ret_from_fork
      0.00            +8.0        8.00 =B1 10%  perf-profile.calltrace.cycl=
es-pp.ret_from_fork
      0.00            +8.0        8.00 =B1 10%  perf-profile.calltrace.cycl=
es-pp.kthread.ret_from_fork
     78.84 =B1  2%      -5.7       73.09 =B1  3%  perf-profile.children.cyc=
les-pp.start_secondary
     79.28 =B1  2%      -5.5       73.80 =B1  2%  perf-profile.children.cyc=
les-pp.do_idle
     79.28 =B1  2%      -5.5       73.80 =B1  2%  perf-profile.children.cyc=
les-pp.secondary_startup_64_no_verify
     79.28 =B1  2%      -5.5       73.80 =B1  2%  perf-profile.children.cyc=
les-pp.cpu_startup_entry
      1.16 =B1  5%      -0.2        0.98 =B1 11%  perf-profile.children.cyc=
les-pp.lockdep_hardirqs_on_prepare
      1.19 =B1  8%      -0.2        1.03 =B1  6%  perf-profile.children.cyc=
les-pp.trace_hardirqs_on
      0.74 =B1 11%      -0.2        0.58 =B1 12%  perf-profile.children.cyc=
les-pp.btrfs_set_extent_delalloc
      0.78 =B1 11%      -0.2        0.62 =B1 16%  perf-profile.children.cyc=
les-pp.alloc_extent_state
      1.41 =B1  7%      -0.2        1.26 =B1  6%  perf-profile.children.cyc=
les-pp._raw_spin_lock_irq
      0.76 =B1 10%      -0.2        0.61 =B1 12%  perf-profile.children.cyc=
les-pp.set_extent_bit
      0.66 =B1  9%      -0.1        0.52 =B1 17%  perf-profile.children.cyc=
les-pp.lockdep_init_map_type
      0.65 =B1  9%      -0.1        0.52 =B1 17%  perf-profile.children.cyc=
les-pp.static_obj
      0.60 =B1 10%      -0.1        0.47 =B1 17%  perf-profile.children.cyc=
les-pp.__is_kernel_percpu_address
      0.61 =B1 11%      -0.1        0.49 =B1 18%  perf-profile.children.cyc=
les-pp.__init_waitqueue_head
      0.34 =B1 11%      -0.1        0.27 =B1 11%  perf-profile.children.cyc=
les-pp.hrtimer_update_next_event
      0.24 =B1 10%      -0.1        0.17 =B1 15%  perf-profile.children.cyc=
les-pp.__remove_hrtimer
      0.19 =B1 10%      -0.1        0.13 =B1 15%  perf-profile.children.cyc=
les-pp.timerqueue_del
      0.46 =B1  7%      -0.1        0.39 =B1  9%  perf-profile.children.cyc=
les-pp.trace_hardirqs_on_prepare
      0.69 =B1  3%      -0.1        0.63 =B1  4%  perf-profile.children.cyc=
les-pp.debug_smp_processor_id
      0.13 =B1 16%      -0.0        0.09 =B1 13%  perf-profile.children.cyc=
les-pp.menu_reflect
      0.39 =B1  5%      -0.0        0.35 =B1  6%  perf-profile.children.cyc=
les-pp.lockdep_hardirqs_on
      0.16 =B1  9%      -0.0        0.12 =B1 17%  perf-profile.children.cyc=
les-pp.btrfs_set_delalloc_extent
      0.15 =B1  7%      -0.0        0.12 =B1 11%  perf-profile.children.cyc=
les-pp.syscall_exit_to_user_mode
      0.10 =B1 11%      -0.0        0.08 =B1 11%  perf-profile.children.cyc=
les-pp.rcu_nmi_enter
      0.08 =B1 14%      +0.0        0.10 =B1 11%  perf-profile.children.cyc=
les-pp.remove_vma
      0.06 =B1 13%      +0.0        0.09 =B1 16%  perf-profile.children.cyc=
les-pp.newidle_balance
      0.09 =B1  9%      +0.1        0.14 =B1  7%  perf-profile.children.cyc=
les-pp.___perf_sw_event
      0.20 =B1  9%      +0.1        0.26 =B1  8%  perf-profile.children.cyc=
les-pp.do_raw_spin_unlock
      0.27 =B1 12%      +0.1        0.34 =B1  6%  perf-profile.children.cyc=
les-pp.memcg_slab_free_hook
      0.02 =B1142%      +0.1        0.10 =B1 12%  perf-profile.children.cyc=
les-pp.select_task_rq_fair
      0.00            +0.1        0.08 =B1 18%  perf-profile.children.cycle=
s-pp.enqueue_task_fair
      0.01 =B1223%      +0.1        0.10 =B1 18%  perf-profile.children.cyc=
les-pp.pick_next_task_fair
      0.00            +0.1        0.10 =B1 22%  perf-profile.children.cycle=
s-pp.ttwu_do_activate
      0.07 =B1 50%      +0.1        0.17 =B1 14%  perf-profile.children.cyc=
les-pp.update_curr
      0.01 =B1223%      +0.1        0.13 =B1 18%  perf-profile.children.cyc=
les-pp.finish_task_switch
      0.01 =B1223%      +0.1        0.13 =B1 16%  perf-profile.children.cyc=
les-pp.dequeue_entity
      0.01 =B1223%      +0.1        0.14 =B1 16%  perf-profile.children.cyc=
les-pp.dequeue_task_fair
      0.00            +0.2        0.22 =B1 15%  perf-profile.children.cycle=
s-pp.native_queued_spin_lock_slowpath
      1.10 =B1  2%      +0.2        1.33 =B1  4%  perf-profile.children.cyc=
les-pp.match_held_lock
      0.06 =B1 59%      +0.2        0.29 =B1 13%  perf-profile.children.cyc=
les-pp.schedule_idle
      0.10 =B1 15%      +0.3        0.36 =B1 13%  perf-profile.children.cyc=
les-pp.__mod_memcg_lruvec_state
      0.00            +0.3        0.28 =B1 17%  perf-profile.children.cycle=
s-pp.cgroup_rstat_updated
      0.00            +0.4        0.35 =B1  9%  perf-profile.children.cycle=
s-pp.mem_cgroup_css_rstat_flush
      0.11 =B1 19%      +0.4        0.48 =B1 15%  perf-profile.children.cyc=
les-pp.schedule
      0.56 =B1  9%      +0.4        0.95 =B1  7%  perf-profile.children.cyc=
les-pp.do_raw_spin_lock
      0.07 =B1 17%      +0.4        0.49 =B1 12%  perf-profile.children.cyc=
les-pp.try_to_wake_up
      0.73 =B1 11%      +0.5        1.24 =B1 14%  perf-profile.children.cyc=
les-pp.__mod_lruvec_page_state
      0.00            +0.6        0.58 =B1 13%  perf-profile.children.cycle=
s-pp.__queue_work
      0.20 =B1 14%      +0.6        0.78 =B1 13%  perf-profile.children.cyc=
les-pp.__schedule
      0.00            +0.6        0.60 =B1 14%  perf-profile.children.cycle=
s-pp.queue_work_on
      2.35 =B1  4%      +1.6        3.96 =B1  7%  perf-profile.children.cyc=
les-pp._raw_spin_unlock
      3.97 =B1  3%      +3.5        7.48 =B1  6%  perf-profile.children.cyc=
les-pp._raw_spin_lock
      0.00            +6.8        6.81 =B1 10%  perf-profile.children.cycle=
s-pp.cgroup_rstat_flush_locked
      0.00            +6.8        6.83 =B1 10%  perf-profile.children.cycle=
s-pp.cgroup_rstat_flush_irqsafe
      0.00            +7.0        6.96 =B1 10%  perf-profile.children.cycle=
s-pp.mem_cgroup_flush_stats
      0.18 =B1 10%      +7.1        7.31 =B1 10%  perf-profile.children.cyc=
les-pp.process_one_work
      0.45 =B1  6%      +7.6        8.02 =B1 10%  perf-profile.children.cyc=
les-pp.ret_from_fork
      0.43 =B1  8%      +7.6        8.00 =B1 10%  perf-profile.children.cyc=
les-pp.kthread
      0.20 =B1 10%      +7.6        7.78 =B1 10%  perf-profile.children.cyc=
les-pp.worker_thread
      1.67 =B1  9%      -0.2        1.46 =B1  2%  perf-profile.self.cycles-=
pp.cpuidle_enter_state
      0.47 =B1  6%      -0.1        0.40 =B1  7%  perf-profile.self.cycles-=
pp.lockdep_hardirqs_on_prepare
      0.28 =B1 10%      -0.0        0.23 =B1  7%  perf-profile.self.cycles-=
pp.__hrtimer_next_event_base
      0.25 =B1 14%      -0.0        0.21 =B1 17%  perf-profile.self.cycles-=
pp.__is_kernel_percpu_address
      0.19 =B1  5%      -0.0        0.14 =B1 21%  perf-profile.self.cycles-=
pp.brd_do_bvec
      0.07 =B1 16%      -0.0        0.03 =B1 86%  perf-profile.self.cycles-=
pp.timerqueue_del
      0.16 =B1 14%      -0.0        0.12 =B1 20%  perf-profile.self.cycles-=
pp.sysvec_apic_timer_interrupt
      0.08 =B1  6%      -0.0        0.05 =B1 44%  perf-profile.self.cycles-=
pp.rb_erase
      0.18 =B1  8%      +0.0        0.23 =B1  8%  perf-profile.self.cycles-=
pp.do_raw_spin_unlock
      0.06 =B1  9%      +0.1        0.12 =B1 11%  perf-profile.self.cycles-=
pp._raw_spin_lock
      0.10 =B1  9%      +0.1        0.18 =B1 14%  perf-profile.self.cycles-=
pp._raw_spin_unlock
      0.88 =B1  3%      +0.2        1.04 =B1  3%  perf-profile.self.cycles-=
pp.match_held_lock
      0.54 =B1  7%      +0.2        0.72 =B1  6%  perf-profile.self.cycles-=
pp.do_raw_spin_lock
      0.00            +0.2        0.22 =B1 15%  perf-profile.self.cycles-pp=
.native_queued_spin_lock_slowpath
      0.00            +0.2        0.22 =B1  6%  perf-profile.self.cycles-pp=
.cgroup_rstat_flush_locked
      0.00            +0.3        0.33 =B1 10%  perf-profile.self.cycles-pp=
.mem_cgroup_css_rstat_flush



***************************************************************************=
************************
lkp-cfl-e1: 16 threads 1 sockets Intel(R) Xeon(R) E-2278G CPU @ 3.40GHz wit=
h 32G memory
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
compiler/cpufreq_governor/kconfig/nr_task/rootfs/runtime/tbox_group/test/te=
stcase/ucode:
  gcc-9/performance/x86_64-rhel-8.3/100%/debian-10.4-x86_64-20200603.cgz/30=
0s/lkp-cfl-e1/five_sec/reaim/0xde

commit:=20
  0c7c5da68b ("memcg: switch lruvec stats to rstat")
  cda0d20525 ("memcg: infrastructure to flush memcg stats")

0c7c5da68b4a09ff cda0d205259a7e7c1f8e296130a=20
---------------- ---------------------------=20
         %stddev     %change         %stddev
             \          |                \ =20
     16.84            +1.2%      17.05        reaim.child_systime
      1.17            -1.7%       1.15        reaim.child_utime
     77332           -10.7%      69064        reaim.jobs_per_min
      4833           -10.7%       4316        reaim.jobs_per_min_child
     79421           -10.3%      71230        reaim.max_jobs_per_min
      1.23           +12.0%       1.38        reaim.parent_time
      1.00           +61.7%       1.61 =B1  2%  reaim.std_dev_percent
      0.01           +84.7%       0.02 =B1  2%  reaim.std_dev_time
    186593          +620.2%    1343882        reaim.time.involuntary_contex=
t_switches
     15277           -15.4%      12918        reaim.time.major_page_faults
  45920952            -4.7%   43779707        reaim.time.minor_page_faults
    549.17            -3.4%     530.57        reaim.time.percent_of_cpu_thi=
s_job_got
      1554            -3.5%       1500        reaim.time.system_time
    108.32            -6.3%     101.53        reaim.time.user_time
    147200            -4.7%     140342        reaim.workload
   4260000 =B1 24%     +85.2%    7890750 =B1 16%  cpuidle..usage
      0.00 =B1 94%      +0.0        0.01 =B1125%  mpstat.cpu.all.iowait%
     37619           +10.2%      41448        softirqs.CPU5.SCHED
      4236 =B1  3%     -20.4%       3371 =B1  4%  slabinfo.cred_jar.active_=
objs
      4236 =B1  3%     -20.4%       3371 =B1  4%  slabinfo.cred_jar.num_objs
      5335          +425.1%      28014        vmstat.system.cs
     25198 =B1 13%     +34.2%      33810 =B1 10%  vmstat.system.in
     36327           +93.6%      70343 =B1  3%  meminfo.Active
     36170           +93.4%      69943 =B1  4%  meminfo.Active(anon)
    374203            +9.7%     410350        meminfo.Committed_AS
     45925           +77.1%      81324 =B1  4%  meminfo.Shmem
     60038 =B1 58%   +4479.1%    2749217 =B1 35%  turbostat.C1
      0.06 =B1 34%      +1.9        1.96 =B1 41%  turbostat.C1%
    374823 =B1 34%    +283.9%    1438762 =B1 52%  turbostat.C1E
      0.66 =B1 33%      +1.4        2.10 =B1 55%  turbostat.C1E%
     92340 =B1 84%     -99.3%     670.00 =B1204%  turbostat.C8
     48.13            +7.4%      51.70        turbostat.CorWatt
   7689266 =B1 13%     +33.9%   10296075 =B1  9%  turbostat.IRQ
     11.56 =B1 34%     -29.5%       8.15 =B1  9%  turbostat.Pkg%pc2
     48.58            +7.4%      52.15        turbostat.PkgWatt
      9048           +92.7%      17436 =B1  4%  proc-vmstat.nr_active_anon
    599695            +1.5%     608725        proc-vmstat.nr_file_pages
      8070            +4.9%       8467        proc-vmstat.nr_mapped
     11469           +77.0%      20298 =B1  4%  proc-vmstat.nr_shmem
      9048           +92.7%      17436 =B1  4%  proc-vmstat.nr_zone_active_=
anon
  42656780            -4.6%   40700689        proc-vmstat.numa_hit
  42656780            -4.6%   40700689        proc-vmstat.numa_local
     92407           +22.4%     113128        proc-vmstat.pgactivate
  43569042            -4.7%   41530882        proc-vmstat.pgalloc_normal
  46430133            -4.6%   44284838        proc-vmstat.pgfault
  43538315            -4.7%   41477247        proc-vmstat.pgfree
   1629898            -4.2%    1561322        proc-vmstat.pgreuse
 5.801e+09            +6.4%  6.174e+09        perf-stat.i.branch-instructio=
ns
  30752328           +16.4%   35783086        perf-stat.i.branch-misses
      2.16 =B1  2%      -0.3        1.81        perf-stat.i.cache-miss-rate%
 2.765e+08           +25.7%  3.475e+08        perf-stat.i.cache-references
      5341          +426.1%      28100        perf-stat.i.context-switches
      1.15            -2.8%       1.11        perf-stat.i.cpi
 2.523e+10            +4.4%  2.633e+10        perf-stat.i.cpu-cycles
    747.05           +84.5%       1378        perf-stat.i.cpu-migrations
      3729            +7.5%       4008        perf-stat.i.cycles-between-ca=
che-misses
 7.878e+09            +5.2%  8.284e+09        perf-stat.i.dTLB-loads
      0.01 =B1  9%      -0.0        0.01        perf-stat.i.dTLB-store-miss=
-rate%
    560872            -4.9%     533422        perf-stat.i.dTLB-store-misses
 4.383e+09            +2.4%  4.487e+09        perf-stat.i.dTLB-stores
     68.79 =B1  2%      -5.0       63.79 =B1  2%  perf-stat.i.iTLB-load-mis=
s-rate%
   1070659 =B1  3%      +6.7%    1142823 =B1  2%  perf-stat.i.iTLB-load-mis=
ses
    578652           +21.6%     703855 =B1  3%  perf-stat.i.iTLB-loads
  2.76e+10            +5.4%  2.908e+10        perf-stat.i.instructions
      0.94            +2.0%       0.96        perf-stat.i.ipc
     50.65           -15.2%      42.96        perf-stat.i.major-faults
      0.24 =B1  3%     +12.4%       0.27 =B1  3%  perf-stat.i.metric.G/sec
      1.58            +4.4%       1.65        perf-stat.i.metric.GHz
    199.04            +3.3%     205.70        perf-stat.i.metric.K/sec
    904.24            +3.3%     933.92        perf-stat.i.metric.M/sec
    150989            -4.4%     144377        perf-stat.i.minor-faults
    151039            -4.4%     144420        perf-stat.i.page-faults
     36548 =B1  4%    +356.1%     166686        interrupts.CAL:Function_cal=
l_interrupts
      2202 =B1 12%    +376.0%      10483 =B1  4%  interrupts.CPU0.CAL:Funct=
ion_call_interrupts
      4568         +1471.3%      71781 =B1  2%  interrupts.CPU0.RES:Resched=
uling_interrupts
     25.83 =B1 21%   +1613.2%     442.57 =B1  6%  interrupts.CPU0.TLB:TLB_s=
hootdowns
      2257 =B1 18%    +353.1%      10231 =B1  3%  interrupts.CPU1.CAL:Funct=
ion_call_interrupts
      4591         +1491.3%      73058 =B1  2%  interrupts.CPU1.RES:Resched=
uling_interrupts
     30.33 =B1 13%   +1384.9%     450.43 =B1  3%  interrupts.CPU1.TLB:TLB_s=
hootdowns
      2310 =B1 20%    +330.9%       9957 =B1  4%  interrupts.CPU10.CAL:Func=
tion_call_interrupts
      4562 =B1  2%   +1496.4%      72842 =B1  2%  interrupts.CPU10.RES:Resc=
heduling_interrupts
     31.33 =B1 19%   +1291.0%     435.86 =B1  4%  interrupts.CPU10.TLB:TLB_=
shootdowns
      2043 =B1 19%    +414.7%      10517 =B1  8%  interrupts.CPU11.CAL:Func=
tion_call_interrupts
      4444 =B1  2%   +1532.5%      72561        interrupts.CPU11.RES:Resche=
duling_interrupts
     26.17 =B1 17%   +1588.6%     441.86 =B1  4%  interrupts.CPU11.TLB:TLB_=
shootdowns
      2257 =B1 24%    +363.1%      10452 =B1  6%  interrupts.CPU12.CAL:Func=
tion_call_interrupts
      4576         +1474.2%      72041 =B1  2%  interrupts.CPU12.RES:Resche=
duling_interrupts
     27.17 =B1 15%   +1606.4%     463.57 =B1  5%  interrupts.CPU12.TLB:TLB_=
shootdowns
      1948 =B1 18%    +449.5%      10706 =B1  7%  interrupts.CPU13.CAL:Func=
tion_call_interrupts
      4551         +1487.9%      72280 =B1  3%  interrupts.CPU13.RES:Resche=
duling_interrupts
     28.67 =B1 17%   +1446.8%     443.43 =B1  4%  interrupts.CPU13.TLB:TLB_=
shootdowns
      2363 =B1 23%    +353.4%      10714 =B1  7%  interrupts.CPU14.CAL:Func=
tion_call_interrupts
      4521 =B1  2%   +1497.2%      72218 =B1  2%  interrupts.CPU14.RES:Resc=
heduling_interrupts
     27.00 =B1 19%   +1561.4%     448.57 =B1  4%  interrupts.CPU14.TLB:TLB_=
shootdowns
      2111 =B1 20%    +381.6%      10167 =B1  5%  interrupts.CPU15.CAL:Func=
tion_call_interrupts
      4594         +1460.4%      71685        interrupts.CPU15.RES:Reschedu=
ling_interrupts
     26.67 =B1 21%   +1553.2%     440.86 =B1  5%  interrupts.CPU15.TLB:TLB_=
shootdowns
      2477 =B1 23%    +319.6%      10397 =B1  4%  interrupts.CPU2.CAL:Funct=
ion_call_interrupts
      4551 =B1  2%   +1496.0%      72641 =B1  2%  interrupts.CPU2.RES:Resch=
eduling_interrupts
     29.50 =B1 15%   +1381.4%     437.00 =B1  4%  interrupts.CPU2.TLB:TLB_s=
hootdowns
      2220 =B1 17%    +348.6%       9962 =B1  4%  interrupts.CPU3.CAL:Funct=
ion_call_interrupts
      4577         +1483.3%      72469 =B1  2%  interrupts.CPU3.RES:Resched=
uling_interrupts
     27.83 =B1 18%   +1437.2%     427.86 =B1  3%  interrupts.CPU3.TLB:TLB_s=
hootdowns
      1926 =B1 13%    +457.0%      10731 =B1  7%  interrupts.CPU4.CAL:Funct=
ion_call_interrupts
      4532         +1490.4%      72080 =B1  3%  interrupts.CPU4.RES:Resched=
uling_interrupts
     29.00 =B1 18%   +1472.4%     456.00 =B1  5%  interrupts.CPU4.TLB:TLB_s=
hootdowns
      2441 =B1 22%    +313.7%      10101 =B1  4%  interrupts.CPU5.CAL:Funct=
ion_call_interrupts
      4613         +1479.5%      72866        interrupts.CPU5.RES:Reschedul=
ing_interrupts
     25.33 =B1 25%   +1684.8%     452.14 =B1  5%  interrupts.CPU5.TLB:TLB_s=
hootdowns
      2400 =B1 16%    +337.5%      10502 =B1  6%  interrupts.CPU6.CAL:Funct=
ion_call_interrupts
      4527         +1480.1%      71535        interrupts.CPU6.RES:Reschedul=
ing_interrupts
     26.50 =B1 22%   +1557.1%     439.14 =B1  5%  interrupts.CPU6.TLB:TLB_s=
hootdowns
      2799 =B1 22%    +294.2%      11034 =B1  6%  interrupts.CPU7.CAL:Funct=
ion_call_interrupts
      4623 =B1  2%   +1435.4%      70979 =B1  2%  interrupts.CPU7.RES:Resch=
eduling_interrupts
     27.83 =B1 21%   +1465.4%     435.71 =B1  8%  interrupts.CPU7.TLB:TLB_s=
hootdowns
      2487 =B1 12%    +303.6%      10039 =B1  5%  interrupts.CPU8.CAL:Funct=
ion_call_interrupts
      4534         +1504.6%      72761 =B1  3%  interrupts.CPU8.RES:Resched=
uling_interrupts
     28.17 =B1 21%   +1515.4%     455.00 =B1  5%  interrupts.CPU8.TLB:TLB_s=
hootdowns
      2300 =B1 13%    +364.6%      10685 =B1  7%  interrupts.CPU9.CAL:Funct=
ion_call_interrupts
      4563         +1458.2%      71100        interrupts.CPU9.RES:Reschedul=
ing_interrupts
     25.00 =B1 24%   +1686.9%     446.71 =B1  7%  interrupts.CPU9.TLB:TLB_s=
hootdowns
     72933         +1483.5%    1154904        interrupts.RES:Rescheduling_i=
nterrupts
    442.33 =B1  4%   +1508.9%       7116        interrupts.TLB:TLB_shootdow=
ns
      0.04 =B1  4%    +138.7%       0.11 =B1  6%  perf-sched.sch_delay.avg.=
ms.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group.do_syscall_64
      0.05 =B1  5%    +158.0%       0.13 =B1  4%  perf-sched.sch_delay.avg.=
ms.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64
      0.11 =B1 39%    +127.2%       0.26 =B1 32%  perf-sched.sch_delay.avg.=
ms.io_schedule.__lock_page_killable.filemap_fault.__do_fault
      0.02 =B1 27%     -46.9%       0.01 =B1 26%  perf-sched.sch_delay.avg.=
ms.pipe_read.new_sync_read.vfs_read.ksys_read
      0.03 =B1  7%     -15.7%       0.02 =B1 15%  perf-sched.sch_delay.avg.=
ms.pipe_write.new_sync_write.vfs_write.ksys_write
      0.02 =B1 31%    +659.1%       0.13 =B1 55%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_read_unlock.wait_tas=
k_zombie.do_wait
      0.12 =B1 78%     -77.2%       0.03 =B1121%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.__dentry=
_kill.dput
      0.20 =B1142%     -99.6%       0.00 =B1115%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.begin_ne=
w_exec.load_elf_binary
      0.02 =B1 57%     -78.0%       0.00 =B1112%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.change_p=
4d_range.change_protection
      0.02 =B1 72%     -79.4%       0.01 =B1 91%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.do_sys_o=
penat2.do_sys_open
      0.04 =B1150%     -84.4%       0.01 =B1 73%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.finish_f=
ault.do_fault
      0.07 =B1  8%     -62.4%       0.03 =B1 33%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.zap_pte_=
range.unmap_page_range
      0.00 =B1223%   +3094.3%       0.08 =B1179%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.rele=
ase_task.wait_task_zombie
      0.12 =B1108%     -84.9%       0.02 =B1 94%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.task=
_work_run.exit_to_user_mode_prepare
      0.02 =B1 46%    +282.4%       0.07 =B1 68%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.wait=
_task_zombie.do_wait
      0.10 =B1115%     -88.0%       0.01 =B1111%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.release_pages.tlb_flush_mmu
      0.20 =B1 70%    +182.4%       0.55 =B1 14%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.sched_move_task.do_exit
      0.13 =B1113%     -93.8%       0.01 =B1 98%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk.fd_install.do_sys_openat2=
.do_sys_open
      0.21 =B1215%     -99.7%       0.00 =B1 86%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk.flush_tlb_mm_range.tlb_fl=
ush_mmu.tlb_finish_mmu
      0.12 =B1 68%     -76.3%       0.03 =B1 40%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk.lru_add_drain.exit_mmap.m=
mput
      0.03 =B1143%     -94.6%       0.00 =B1105%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk.lru_add_drain.free_pages_=
and_swap_cache.tlb_flush_mmu
      0.03 =B1105%     -94.8%       0.00 =B1 66%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk.lru_cache_add.shmem_getpa=
ge_gfp.shmem_write_begin
      0.02 =B1 30%     -79.6%       0.00 =B1 90%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.free_=
unref_page_list.release_pages
      0.05 =B1118%    +288.1%       0.18 =B1 55%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.handl=
e_mm_fault.do_user_addr_fault
      0.02 =B1 47%     -70.1%       0.01 =B1130%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.kmem_=
cache_free.__put_anon_vma
      0.03 =B1 94%     -80.9%       0.01 =B1 92%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.lock_=
acquire.__lock_task_sighand
      0.03 =B1 40%     -83.3%       0.01 =B1155%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.lock_=
acquire.aa_file_perm
      0.06 =B1 60%    +150.6%       0.15 =B1 43%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.lock_=
is_held_type.___might_sleep
      0.02 =B1107%     -93.1%       0.00 =B1197%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vm_ar=
ea_dup.dup_mmap
      0.04 =B1118%     -93.0%       0.00 =B1116%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_i=
nterval_tree_insert.__vma_adjust
      0.04 =B1 66%     -89.1%       0.00 =B1183%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.___might_sl=
eep.unmap_page_range
      0.01 =B1106%     -85.2%       0.00 =B1101%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__might_sle=
ep.dput
      0.00 =B1223%    +610.2%       0.01 =B1 47%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.acct_collec=
t.do_exit
      0.03 =B1100%     -85.6%       0.00 =B1100%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.d_alloc_par=
allel.__lookup_slow
      0.05 =B1 89%     -96.1%       0.00 =B1 58%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.d_path.perf=
_event_mmap
      0.11 =B1 74%     -86.4%       0.01 =B1 80%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.__might_fault
      0.05 =B1 55%     -78.8%       0.01 =B1 23%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.fs_reclaim_acquire
      0.11 =B1118%     -86.2%       0.02 =B1 93%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.kmem_cache_alloc
      0.09 =B1 43%     -86.4%       0.01 =B1121%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.memcg_slab_free_hook
      0.09 =B1 56%     -86.6%       0.01 =B1 68%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_is_hel=
d_type.___might_sleep
      0.17 =B1 97%     -96.3%       0.01 =B1 86%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e.kmem_cache_alloc
      0.12 =B1196%     -97.3%       0.00 =B1138%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.__mark_inode_dir=
ty.generic_update_time.touch_atime
      0.02 =B1 26%     -95.8%       0.00 =B1 97%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.kmem_cache_free.=
unlink_anon_vmas.free_pgtables
      0.02 =B1138%     -94.4%       0.00 =B1118%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.kme=
m_cache_alloc.__anon_vma_prepare
      0.04 =B1 74%     -95.4%       0.00 =B1 86%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.kme=
m_cache_alloc.vm_area_dup
      0.06 =B1 40%     -70.2%       0.02 =B1 97%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.mem=
cg_slab_free_hook.kmem_cache_free
      0.01 =B1 68%     -86.9%       0.00 =B1112%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.per=
f_iterate_sb.perf_event_mmap
      0.05 =B1 72%     -71.1%       0.01 =B1142%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.unc=
harge_page.mem_cgroup_uncharge_list
      0.07 =B1103%     -88.2%       0.01 =B1 99%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.get=
_obj_cgroup_from_current.kmem_cache_alloc
      0.09 =B1 79%     -97.7%       0.00 =B1 84%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.kme=
m_cache_alloc.__anon_vma_prepare
      0.02 =B1 53%     -85.6%       0.00 =B1102%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.kme=
m_cache_alloc.__pmd_alloc
      0.03 =B1 72%     -79.2%       0.01 =B1125%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.kme=
m_cache_alloc_trace.perf_event_mmap
      0.03 =B1142%     -98.4%       0.00 =B1169%  perf-sched.sch_delay.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.mem=
_cgroup_charge.do_anonymous_page
      0.01 =B1 25%    +243.9%       0.05 =B1 67%  perf-sched.sch_delay.avg.=
ms.rwsem_down_read_slowpath.down_read.walk_component.path_lookupat.isra
      0.01 =B1 13%    +475.0%       0.09 =B1132%  perf-sched.sch_delay.avg.=
ms.rwsem_down_write_slowpath.anon_vma_clone.anon_vma_fork.dup_mmap
      0.00 =B1223%   +4900.0%       0.05 =B1140%  perf-sched.sch_delay.avg.=
ms.rwsem_down_write_slowpath.anon_vma_fork.dup_mmap.dup_mm
      0.01 =B1 21%    +307.1%       0.05 =B1 58%  perf-sched.sch_delay.avg.=
ms.rwsem_down_write_slowpath.do_unlinkat.do_syscall_64.entry_SYSCALL_64_aft=
er_hwframe
      0.01 =B1 34%    +397.9%       0.06 =B1 61%  perf-sched.sch_delay.avg.=
ms.rwsem_down_write_slowpath.filename_create.do_linkat.__x64_sys_link
     12.48 =B1 31%     +76.0%      21.98 =B1  9%  perf-sched.sch_delay.max.=
ms.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group.do_syscall_64
      0.02 =B1 27%  +32984.9%       6.18 =B1 74%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_read_unlock.wait_tas=
k_zombie.do_wait
      0.48 =B1179%     -96.2%       0.02 =B1116%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.begin_ne=
w_exec.load_elf_binary
      0.99 =B1103%    +507.9%       6.01 =B1 53%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.do_anony=
mous_page.__handle_mm_fault
      0.06 =B1 16%   +4772.3%       2.90 =B1 87%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.do_wp_pa=
ge.__handle_mm_fault
      5.12 =B1 33%    +186.5%      14.66 =B1 22%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.filemap_=
map_pages.do_fault
      1.66 =B1 73%    +491.1%       9.84 =B1 29%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.wp_page_=
copy.__handle_mm_fault
      5.83 =B1 36%    +131.2%      13.47 =B1 30%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.zap_pte_=
range.unmap_page_range
      0.06 =B1127%    +852.8%       0.53 =B1146%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.get_=
signal.arch_do_signal_or_restart
      0.00 =B1223%  +42871.4%       1.07 =B1209%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.rele=
ase_task.wait_task_zombie
      0.02 =B1128%   +7349.0%       1.30 =B1172%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.ret_=
from_fork.[unknown]
      0.00 =B1223%   +3033.9%       0.08 =B1113%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.sigp=
rocmask.__x64_sys_rt_sigprocmask
      0.02 =B1 53%   +9229.0%       2.02 =B1 81%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.wait=
_task_zombie.do_wait
      0.02 =B1  8%  +20160.8%       3.68 =B1124%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.delete_from_page_cache.truncate_inode_page
      0.01 =B1101%   +1939.1%       0.19 =B1113%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.do_wait.kernel_wait4
      6.45 =B1 74%    +198.2%      19.24 =B1 21%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.sched_move_task.do_exit
      0.01 =B1 50%   +9448.0%       1.42 =B1143%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.thread_group_cputime_adjusted.wait_task_zombie
      0.19 =B1198%   +2910.9%       5.70 =B1 55%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_write_unlock_irq.rel=
ease_task.wait_task_zombie
      7.16 =B1 66%    +231.6%      23.74 =B1 13%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.cpu_stop_queue_work.stop_=
one_cpu.sched_exec
      0.00 =B1223%  +1.1e+05%       3.91 =B1157%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.exit_signals.do_exit.do_g=
roup_exit
      0.39 =B1116%   +1113.2%       4.70 =B1139%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.lru_add_drain.unmap_regio=
n.__do_munmap
      8.76 =B1 23%     +77.5%      15.54 =B1 22%  perf-sched.sch_delay.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.schedule_tail.ret_from_fo=
rk.[unknown]
      0.33 =B1173%   +1025.4%       3.72 =B1 81%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.handl=
e_mm_fault.do_user_addr_fault
      1.95 =B1 72%    +325.3%       8.30 =B1 52%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.lock_=
is_held_type.___might_sleep
      0.47 =B1 86%   +1401.6%       6.99 =B1 94%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.memcg=
_slab_free_hook.kmem_cache_free
      0.07 =B1134%     -95.8%       0.00 =B1115%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.vma_i=
nterval_tree_insert.__vma_adjust
      0.03 =B1 92%  +10097.9%       2.72 =B1 83%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__might_sle=
ep.do_user_addr_fault
      0.00 =B1223%   +1504.1%       0.02 =B1 36%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.acct_collec=
t.do_exit
      2.34 =B1 61%    +468.7%      13.30 =B1 33%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.do_user_add=
r_fault.exc_page_fault
      0.00 =B1223%    +702.0%       0.02 =B1 44%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.down_read_t=
rylock.do_user_addr_fault
      0.43 =B1203%   +1077.3%       5.11 =B1 40%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.handle_mm_f=
ault.do_user_addr_fault
      0.02 =B1109%   +5174.6%       0.84 =B1205%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.down_write_killable
      0.06 =B1 30%   +4203.6%       2.75 =B1 93%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.memcg_slab_=
free_hook.kmem_cache_free
      0.05 =B1181%    +723.6%       0.42 =B1 91%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.syscall_exi=
t_to_user_mode_prepare.syscall_exit_to_user_mode
      0.00 =B1223%   +8372.5%       0.18 =B1101%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.up_read.do_=
user_addr_fault
      0.00 =B1223%  +1.4e+05%       1.81 =B1234%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.xas_load.xa=
s_find
      0.00 =B1141%   +3282.9%       0.08 =B1194%  perf-sched.sch_delay.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.xas_start.x=
as_load
      0.13 =B1175%     -87.4%       0.02 =B1123%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.__mark_inode_dir=
ty.generic_update_time.touch_atime
      1.66 =B1113%    +364.7%       7.71 =B1 42%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.__perf_sw_event.=
do_user_addr_fault.exc_page_fault
      0.05 =B1 39%     -77.3%       0.01 =B1 68%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.kmem_cache_free.=
unlink_anon_vmas.free_pgtables
      0.12 =B1223%   +1385.4%       1.78 =B1105%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.thr=
ead_group_cputime.thread_group_cputime_adjusted
      0.33 =B1 90%     -92.5%       0.02 =B1 80%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.kme=
m_cache_alloc.__anon_vma_prepare
      0.12 =B1174%     -95.2%       0.01 =B1160%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.mem=
_cgroup_charge.do_anonymous_page
      0.02 =B1141%  +22936.6%       3.69 =B1153%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.__anon_vma_prepare
      0.02 =B1108%  +13620.0%       2.74 =B1129%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.__d_alloc
      0.00 =B1146%  +29728.6%       1.29 =B1136%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.anon_vma_clone
      0.05 =B1223%   +1812.4%       0.96 =B1 99%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.anon_vma_fork
      0.02 =B1111%   +9575.2%       1.84 =B1111%  perf-sched.sch_delay.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.vm_area_alloc
      0.04 =B1 52%   +6245.5%       2.70 =B1157%  perf-sched.sch_delay.max.=
ms.rwsem_down_write_slowpath.anon_vma_clone.anon_vma_fork.dup_mmap
      0.00 =B1223%  +13314.3%       0.27 =B1143%  perf-sched.sch_delay.max.=
ms.rwsem_down_write_slowpath.anon_vma_fork.dup_mmap.dup_mm
      0.93 =B1 33%    +377.4%       4.42 =B1 58%  perf-sched.sch_delay.max.=
ms.rwsem_down_write_slowpath.do_unlinkat.do_syscall_64.entry_SYSCALL_64_aft=
er_hwframe
      3.52 =B1  6%     +48.2%       5.22 =B1 57%  perf-sched.sch_delay.max.=
ms.worker_thread.kthread.ret_from_fork
      0.05 =B1  2%     -20.3%       0.04        perf-sched.total_sch_delay.=
average.ms
     24.34 =B1  2%     -77.8%       5.41 =B1 10%  perf-sched.total_wait_and=
_delay.average.ms
     37615          +339.2%     165218 =B1  5%  perf-sched.total_wait_and_d=
elay.count.ms
     24.29 =B1  2%     -77.9%       5.37 =B1 10%  perf-sched.total_wait_tim=
e.average.ms
      7.69 =B1  6%     -16.0%       6.46 =B1 12%  perf-sched.wait_and_delay=
.avg.ms.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64
      6.52 =B1 58%    -100.0%       0.00        perf-sched.wait_and_delay.a=
vg.ms.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_sysvec_apic_=
timer_interrupt.[unknown]
      4.93 =B1 44%    -100.0%       0.00        perf-sched.wait_and_delay.a=
vg.ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.scan_=
positives.dcache_readdir
    294.26 =B1 28%     -50.5%     145.74 =B1 16%  perf-sched.wait_and_delay=
.avg.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do=
_sys_poll
     87.51 =B1  5%     -16.8%      72.80 =B1 11%  perf-sched.wait_and_delay=
.avg.ms.smpboot_thread_fn.kthread.ret_from_fork
     57.89 =B1  3%     -97.1%       1.70 =B1 10%  perf-sched.wait_and_delay=
.avg.ms.worker_thread.kthread.ret_from_fork
    268.33 =B1  5%    -100.0%       0.00        perf-sched.wait_and_delay.c=
ount.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_sysvec_apic_t=
imer_interrupt.[unknown]
    315.17 =B1  4%     -73.3%      84.00 =B1158%  perf-sched.wait_and_delay=
.count.io_schedule.__lock_page_killable.filemap_fault.__do_fault
    491.17 =B1  4%    +502.5%       2959 =B1  4%  perf-sched.wait_and_delay=
.count.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.file=
map_map_pages.do_fault
    235.00 =B1  5%    -100.0%       0.00        perf-sched.wait_and_delay.c=
ount.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.scan_p=
ositives.dcache_readdir
    547.67 =B1  4%    +584.9%       3751 =B1  8%  perf-sched.wait_and_delay=
.count.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.zap_=
pte_range.unmap_page_range
     38.83 =B1  9%    +113.0%      82.71 =B1  6%  perf-sched.wait_and_delay=
.count.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_=
sys_poll
      3532           +15.4%       4076 =B1  5%  perf-sched.wait_and_delay.c=
ount.smpboot_thread_fn.kthread.ret_from_fork
      2873 =B1  3%   +3435.5%     101580 =B1  5%  perf-sched.wait_and_delay=
.count.worker_thread.kthread.ret_from_fork
    509.76 =B1 96%    -100.0%       0.00        perf-sched.wait_and_delay.m=
ax.ms.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_sysvec_apic_=
timer_interrupt.[unknown]
    511.70 =B1 95%    -100.0%       0.00        perf-sched.wait_and_delay.m=
ax.ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.scan_=
positives.dcache_readdir
    177.28 =B1207%    +308.9%     724.85 =B1 60%  perf-sched.wait_and_delay=
.max.ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.zap=
_pte_range.unmap_page_range
      7.64 =B1  6%     -17.2%       6.33 =B1 13%  perf-sched.wait_time.avg.=
ms.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64
      0.04 =B1130%  +10932.2%       4.74 =B1212%  perf-sched.wait_time.avg.=
ms.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_exc_page_fault.=
[unknown]
      6.47 =B1 58%     -61.2%       2.51 =B1  8%  perf-sched.wait_time.avg.=
ms.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_sysvec_apic_tim=
er_interrupt.[unknown]
      0.00 =B1141%   +2257.1%       0.06 =B1 47%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_read_unlock.exec_bin=
prm.bprm_execve
      0.00 =B1223%   +1689.3%       0.02 =B1139%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.__pte_al=
loc.finish_fault
     18.18 =B1188%     -97.1%       0.53 =B1 41%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.copy_pte=
_range.copy_page_range
      1.42 =B1107%     -86.1%       0.20 =B1128%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.filemap_=
map_pages.do_fault
      0.00 =B1223%  +31642.9%       0.16 =B1192%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.pgd_allo=
c.mm_init
      4.91 =B1 44%     -56.2%       2.15 =B1 38%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.scan_pos=
itives.dcache_readdir
      4.45 =B1 16%     -48.3%       2.30 =B1 34%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.__x6=
4_sys_rt_sigreturn.do_syscall_64
      3.01 =B1 49%    +284.5%      11.58 =B1 82%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.wait=
_task_zombie.do_wait
      0.05 =B1 45%   +9984.3%       4.76 =B1131%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.__wake_up_common_lock.pipe_write
      6.77 =B1  4%     -85.3%       1.00 =B1 27%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.delete_from_page_cache.truncate_inode_page
      3.45 =B1 10%     -42.3%       1.99 =B1 32%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.do_send_sig_info.kill_pid_info
      0.00 =B1223%   +2182.1%       0.03 =B1100%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.get_random_u32.arch_align_stack
      2.99 =B1 33%     -53.1%       1.40 =B1 31%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.sched_fork.copy_process
      0.76 =B1 11%    +106.1%       1.57 =B1  6%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.sched_move_task.do_exit
      1.79 =B1 23%     -52.2%       0.86 =B1 43%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.wake_up_new_task.kernel_clone
      1.62 =B1 35%     -80.6%       0.32 =B1 85%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk.lru_add_drain.free_pages_=
and_swap_cache.tlb_flush_mmu
      0.91 =B1 33%     -78.7%       0.19 =B1 55%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk.lru_add_drain.unmap_regio=
n.__do_munmap
      0.00 =B1223%  +21276.2%       0.64 =B1200%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk.mnt_drop_write.do_unlinka=
t.do_syscall_64
      2.76 =B1 42%     -90.9%       0.25 =B1 64%  perf-sched.wait_time.avg.=
ms.preempt_schedule_common.preempt_schedule_thunk.perf_iterate_sb.perf_even=
t_mmap.do_brk_flags
      2.72 =B1 50%     -74.3%       0.70 =B1107%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.free_=
unref_page_list.release_pages
      1.47 =B1 57%     -92.6%       0.11 =B1183%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.kmem_=
cache_free.remove_vma
      0.00 =B1223%   +1271.4%       0.01 =B1 53%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.___might_sl=
eep.copy_strings
      0.04 =B1156%   +1105.5%       0.47 =B1 40%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__handle_mm=
_fault.handle_mm_fault
      0.03 =B1161%   +5970.7%       1.90 =B1 76%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__local_bh_=
enable_ip.arch_do_signal_or_restart
      0.00 =B1223%   +2400.0%       0.02 =B1131%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__might_sle=
ep.down_write_killable
      0.00 =B1223%  +47861.0%       0.88 =B1164%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.aa_get_task=
_label.apparmor_task_getsecid
      0.00 =B1223%  +11202.9%       0.28 =B1 84%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.common_file=
_perm.security_file_permission
      0.00 =B1223%   +6298.9%       0.28 =B1139%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.copy_user_e=
nhanced_fast_string._copy_from_user
      0.00 =B1223%  +12987.5%       0.35 =B1106%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.copy_user_e=
nhanced_fast_string.copyout
      0.00 =B1223%  +65085.7%       0.22 =B1224%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.do_dentry_o=
pen.do_open
      0.01 =B1223%   +8642.9%       1.12 =B1 67%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.do_syscall_=
64.entry_SYSCALL_64_after_hwframe
      1.42 =B1 38%     -47.4%       0.75 =B1 26%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.exit_to_use=
r_mode_prepare.syscall_exit_to_user_mode
      0.00 =B1146%  +12813.0%       0.50 =B1 96%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.find_vma.do=
_user_addr_fault
      0.08 =B1134%    +184.1%       0.22 =B1 59%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.kmem_cache_=
alloc.__alloc_file
      0.03 =B1223%  +20360.2%       6.41 =B1 89%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.__fget_files
      0.84 =B1112%     -89.9%       0.08 =B1 73%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.get_mem_cgroup_from_mm
      0.05 =B1 75%    +469.9%       0.31 =B1 55%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.handle_mm_fault
      0.00 =B1223%  +12399.2%       0.35 =B1110%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.path_init
      0.00 =B1223%  +26716.3%       0.31 =B1 60%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.vfs_write
      0.34 =B1 25%     -44.9%       0.19 =B1 18%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_is_hel=
d_type.___might_sleep
      0.00 =B1223%   +2968.6%       0.03 =B1 68%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_is_hel=
d_type.__memcg_kmem_charge_page
      0.00 =B1223%  +45528.6%       0.23 =B1 70%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_is_hel=
d_type.xas_descend
      0.04 =B1223%    +563.2%       0.27 =B1 92%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_is_hel=
d_type.xas_start
      0.04 =B1203%    +943.6%       0.46 =B1110%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e.aa_file_perm
      0.01 =B1165%   +1435.2%       0.14 =B1159%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e.cgroup_throttle_swaprate
      0.07 =B1152%    +838.6%       0.70 =B1 65%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e.handle_mm_fault
      0.00 =B1223%  +23621.4%       0.16 =B1152%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.page_counte=
r_try_charge.obj_cgroup_charge_pages
      0.01 =B1154%   +2000.5%       0.31 =B1 71%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.refill_obj_=
stock.obj_cgroup_charge
      0.04 =B1188%    +529.3%       0.27 =B1 82%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.unmap_page_=
range.unmap_vmas
      0.02 =B1183%   +3708.7%       0.63 =B1 76%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.up_read.do_=
user_addr_fault
      0.00 =B1141%   +1782.4%       0.08 =B1180%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.vm_unmapped=
_area.arch_get_unmapped_area_topdown
      0.00 =B1223%  +25295.9%       0.30 =B1 64%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.vmacache_fi=
nd.find_vma
      0.00 =B1223%   +9764.3%       0.20 =B1209%  perf-sched.wait_time.avg.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.walk_compon=
ent.link_path_walk
      1.11 =B1 25%     -51.6%       0.54 =B1 19%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.__perf_sw_event.=
handle_mm_fault.do_user_addr_fault
      0.00 =B1152%   +7242.9%       0.15 =B1224%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.kmem_cache_free.=
__put_anon_vma.unlink_anon_vmas
      0.00 =B1 76%   +2532.7%       0.03 =B1122%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.__m=
ight_fault.get_user_arg_ptr
      2.73 =B1 33%     -48.9%       1.39 =B1 32%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.dpu=
t.scan_positives
      1.85 =B1 42%     -78.8%       0.39 =B1 93%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.fs_=
reclaim_acquire.__alloc_pages
      1.58 =B1 12%     -76.8%       0.37 =B1 65%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.get=
_mem_cgroup_from_mm.mem_cgroup_charge
      1.30 =B1 39%     -71.3%       0.37 =B1 53%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.get=
_obj_cgroup_from_current.kmem_cache_alloc
      0.01 =B1 79%    +318.4%       0.03 =B1 68%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.pre=
pend_path.isra
      0.76 =B1223%    +600.6%       5.33 =B1 11%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.thr=
ead_group_cputime.thread_group_cputime_adjusted
      0.00 =B1223%   +1287.0%       0.03 =B1121%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.__a=
lloc_pages.__get_free_pages
    105.94 =B1219%     -99.5%       0.53 =B1108%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.__a=
lloc_pages.alloc_pages_vma
     20.60 =B1200%     -98.2%       0.37 =B1 56%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.get=
_mem_cgroup_from_mm.mem_cgroup_charge
      2.78 =B1 41%     -88.2%       0.33 =B1 62%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.kme=
m_cache_alloc.vm_area_dup
      1.85 =B1 27%     -88.8%       0.21 =B1 88%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.mem=
_cgroup_charge.do_anonymous_page
      1.55 =B1 36%     -78.4%       0.33 =B1108%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.mem=
_cgroup_uncharge_list.release_pages
      0.34 =B1 32%     -74.1%       0.09 =B1 31%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.mem=
cg_slab_free_hook.kmem_cache_free
      2.16 =B1 74%     -92.9%       0.15 =B1145%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.per=
f_event_mmap.do_brk_flags
      0.58 =B1223%    +781.1%       5.15 =B1 14%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.thr=
ead_group_cputime.thread_group_cputime_adjusted
      0.01 =B1141%    +445.5%       0.03 =B1111%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.wp_=
page_copy.__handle_mm_fault
      2.04 =B1 35%     -78.3%       0.44 =B1112%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
get_obj_cgroup_from_current.kmem_cache_alloc
      0.04 =B1223%   +9636.3%       4.12 =B1223%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.__d_alloc
      0.95 =B1149%    +917.3%       9.62 =B1 79%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.anon_vma_clone
      1.39 =B1 37%     -61.0%       0.54 =B1 42%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
rcu_read_lock_held_common.rcu_read_lock_held
      1.95 =B1 60%     -74.3%       0.50 =B1 38%  perf-sched.wait_time.avg.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_lockdep_curr=
ent_cpu_online.rcu_read_lock_held_common.rcu_read_lock_held
      0.04 =B1141%  +69206.9%      30.26 =B1135%  perf-sched.wait_time.avg.=
ms.rwsem_down_write_slowpath.anon_vma_fork.dup_mmap.dup_mm
    294.22 =B1 28%     -50.5%     145.72 =B1 16%  perf-sched.wait_time.avg.=
ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_sys_=
poll
     87.48 =B1  5%     -16.8%      72.78 =B1 11%  perf-sched.wait_time.avg.=
ms.smpboot_thread_fn.kthread.ret_from_fork
     57.88 =B1  3%     -97.1%       1.69 =B1 10%  perf-sched.wait_time.avg.=
ms.worker_thread.kthread.ret_from_fork
      0.14 =B1122%  +1.1e+05%     152.64 =B1227%  perf-sched.wait_time.max.=
ms.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_exc_page_fault.=
[unknown]
      6.21 =B1 42%    +143.8%      15.13 =B1 35%  perf-sched.wait_time.max.=
ms.exit_to_user_mode_prepare.syscall_exit_to_user_mode.do_syscall_64.entry_=
SYSCALL_64_after_hwframe
      5.02 =B1 43%     -68.6%       1.58 =B1133%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_read_unlock.do_wait.=
kernel_wait4
      0.01 =B1142%  +15034.7%       0.88 =B1 28%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_read_unlock.exec_bin=
prm.bprm_execve
      6.53 =B1 24%   +7474.9%     494.92 =B1113%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_read_unlock.wait_tas=
k_zombie.do_wait
      2.34 =B1141%   +6328.5%     150.26 =B1232%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.__pmd_al=
loc.copy_page_range
      9.61 =B1 13%   +8868.5%     862.08 =B1 39%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.do_anony=
mous_page.__handle_mm_fault
      0.00 =B1223%  +42044.6%       1.12 =B1186%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.pgd_allo=
c.mm_init
    177.02 =B1207%    +308.8%     723.69 =B1 60%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock.zap_pte_=
range.unmap_page_range
      7.76 =B1 15%   +1879.9%     153.69 =B1225%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.do_s=
igaction.__x64_sys_rt_sigaction
      0.61 =B1202%    +511.4%       3.70 =B1 80%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.fute=
x_exit_release.exit_mm_release
      8.75 =B1 17%     +92.0%      16.80 =B1 39%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.get_=
signal.arch_do_signal_or_restart
      1.84 =B1223%    +630.6%      13.43 =B1 33%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.rele=
ase_task.wait_task_zombie
      3.27 =B1 58%   +9126.8%     302.10 =B1146%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irq.wait=
_task_zombie.do_wait
      3.17 =B1 66%  +13581.8%     433.83 =B1112%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.__wake_up_common_lock.pipe_write
      7.42 =B1  8%    +157.9%      19.12 =B1 37%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.delete_from_page_cache.truncate_inode_page
      3.27 =B1113%    +228.9%      10.75 =B1 21%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.do_wait.kernel_wait4
      3.72 =B1 83%    +283.0%      14.24 =B1  8%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.rcu_preempt_deferred_qs_irqrestore.__rcu_read_unlock
      6.55 =B1 20%  +10910.3%     721.27 =B1 62%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.release_pages.tlb_flush_mmu
      0.02 =B1212%   +2925.0%       0.60 =B1113%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.rwsem_wake.isra
      7.20 =B1  8%     +60.4%      11.54 =B1 26%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.sched_fork.copy_process
     10.13 =B1 32%    +118.2%      22.10 =B1 14%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.sched_move_task.do_exit
      4.88 =B1 53%    +180.5%      13.68 =B1 29%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_spin_unlock_irqresto=
re.thread_group_cputime_adjusted.wait_task_zombie
      4.92 =B1 56%   +8906.5%     442.97 =B1109%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk._raw_write_unlock_irq.rel=
ease_task.wait_task_zombie
      3.40 =B1 83%    +294.7%      13.41 =B1 24%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.cpu_stop_queue_work.stop_=
one_cpu.sched_exec
      0.52 =B1223%   +1456.8%       8.11 =B1 71%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.exit_signals.do_exit.do_g=
roup_exit
      4.60 =B1 42%   +6321.5%     295.15 =B1151%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.lru_add_drain.exit_mmap.m=
mput
      0.00 =B1223%  +36990.3%       1.55 =B1170%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.mnt_drop_write.do_unlinka=
t.do_syscall_64
      0.00 =B1223%   +1495.2%       0.05 =B1140%  perf-sched.wait_time.max.=
ms.preempt_schedule_common.preempt_schedule_thunk.rwsem_down_write_slowpath=
.unlink_anon_vmas.free_pgtables
      1.14 =B1217%    +347.5%       5.10 =B1 75%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.kmem_=
cache_alloc.__d_alloc
      7.78 =B1 19%     +59.5%      12.41 =B1 25%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.kmem_=
cache_alloc.vm_area_dup
      3.67 =B1 50%     -83.4%       0.61 =B1197%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.kmem_=
cache_free.remove_vma
      8.33 =B1 10%     +96.5%      16.37 =B1 30%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.lock_=
acquire.get_obj_cgroup_from_current
      0.01 =B1141%  +11672.2%       0.69 =B1172%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.___pmd_free=
_tlb.free_p4d_range
      0.12 =B1156%   +8195.3%       9.69 =B1 38%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__handle_mm=
_fault.handle_mm_fault
      0.11 =B1223%   +2602.9%       2.85 =B1111%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__local_bh_=
enable_ip.__fpu__restore_sig
      0.03 =B1161%  +16380.9%       5.16 =B1 66%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__local_bh_=
enable_ip.arch_do_signal_or_restart
      2.82 =B1 97%   +5262.6%     151.09 =B1230%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__mem_cgrou=
p_charge.mem_cgroup_charge
      0.60 =B1206%  +25004.9%     149.42 =B1232%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__might_sle=
ep.__might_fault
      0.19 =B1146%   +1714.2%       3.48 =B1102%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__might_sle=
ep.down_write
      0.01 =B1223%  +21307.5%       2.46 =B1139%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.__rcu_read_=
unlock.dput
      0.00 =B1223%  +5.8e+06%     144.37 =B1241%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.aa_file_per=
m.common_file_perm
      0.00 =B1223%  +71167.5%       2.61 =B1151%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.aa_get_task=
_label.apparmor_task_getsecid
      0.00 =B1223%  +1.6e+05%       3.98 =B1 82%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.common_file=
_perm.security_file_permission
      0.00 =B1223%  +11128.6%       0.30 =B1121%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.copy_string=
s.isra
      0.01 =B1223%  +29050.6%       3.74 =B1150%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.copy_user_e=
nhanced_fast_string._copy_from_user
      0.00 =B1223%  +1.5e+05%       4.01 =B1 86%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.copy_user_e=
nhanced_fast_string.copyout
      0.03 =B1213%   +4267.9%       1.40 =B1186%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.d_lookup.lo=
okup_dcache
      0.00 =B1223%  +1.1e+05%       1.25 =B1233%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.do_dentry_o=
pen.do_open
      0.02 =B1223%  +22138.8%       4.74 =B1 68%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.do_syscall_=
64.entry_SYSCALL_64_after_hwframe
      4.16 =B1 64%   +3667.2%     156.55 =B1220%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.do_user_add=
r_fault.exc_page_fault
      0.08 =B1223%   +6720.7%       5.66 =B1112%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.down_read_t=
rylock.do_user_addr_fault
      1.52 =B1145%    +705.3%      12.27 =B1 32%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.exit_to_use=
r_mode_prepare
      7.16 =B1 11%    +121.6%      15.86 =B1 32%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.exit_to_use=
r_mode_prepare.syscall_exit_to_user_mode
      0.01 =B1141%  +84292.1%       7.60 =B1 66%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.find_vma.do=
_user_addr_fault
      0.04 =B1205%   +1176.4%       0.45 =B1108%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.free_pages_=
and_swap_cache.tlb_flush_mmu
      1.92 =B1127%   +8073.6%     157.00 =B1219%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.handle_mm_f=
ault.do_user_addr_fault
      0.22 =B1145%   +3590.2%       8.30 =B1 73%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.kmem_cache_=
alloc.__alloc_file
      0.10 =B1223%   +3801.0%       4.06 =B1103%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.kmem_cache_=
alloc.getname_flags
      0.08 =B1146%   +2656.7%       2.34 =B1122%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.kmem_cache_=
alloc.vm_area_alloc
      0.05 =B1187%   +1790.1%       0.99 =B1120%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.kthread_blk=
cg.cgroup_throttle_swaprate
      2.44 =B1122%    +449.2%      13.40 =B1 32%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.ktime_get_c=
oarse_real_ts64.current_time
      0.00 =B1223%  +10871.4%       0.26 =B1212%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.__d_lookup
      0.08 =B1223%  +36479.6%      30.48 =B1 82%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.__fget_files
      5.50 =B1 59%     +97.5%      10.86 =B1 31%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.__might_fault
      2.10 =B1113%    +391.9%      10.35 =B1 22%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.aa_file_perm
      0.03 =B1177%   +3898.4%       1.29 =B1211%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.cgroup_throttle_swaprate
      1.30 =B1176%    +739.9%      10.96 =B1 34%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.down_read_trylock
      2.52 =B1114%    +344.4%      11.21 =B1 46%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.down_write
      3.22 =B1 89%    +161.8%       8.44 =B1 27%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.get_obj_cgroup_from_current
      0.29 =B1 93%   +2767.1%       8.21 =B1 20%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.handle_mm_fault
      0.14 =B1223%   +5523.7%       8.05 =B1 43%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.pagecache_get_page
      0.00 =B1223%  +1.2e+05%       3.34 =B1110%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.path_init
      0.00 =B1223%  +6.1e+05%       7.18 =B1 50%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_acquir=
e.vfs_write
      6.77 =B1 23%    +239.8%      23.00 =B1 53%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_is_hel=
d_type.___might_sleep
      0.00 =B1223%   +8857.1%       0.15 =B1104%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_is_hel=
d_type.__memcg_kmem_charge_page
      0.19 =B1137%   +1638.9%       3.34 =B1 95%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_is_hel=
d_type.cgroup_throttle_swaprate
      0.06 =B1175%   +2742.1%       1.71 =B1168%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_is_hel=
d_type.get_mem_cgroup_from_mm
      2.16 =B1124%    +214.1%       6.78 =B1 22%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_is_hel=
d_type.mem_cgroup_from_task
      0.00 =B1223%  +2.9e+05%       5.25 =B1 63%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_is_hel=
d_type.xas_descend
      0.14 =B1223%   +3535.7%       4.96 =B1 75%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_is_hel=
d_type.xas_start
      1.06 =B1223%    +527.8%       6.68 =B1 40%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e._copy_from_user
      0.08 =B1212%   +6635.0%       5.47 =B1102%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e.aa_file_perm
      0.01 =B1177%  +15285.1%       1.87 =B1162%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e.cgroup_throttle_swaprate
      0.14 =B1162%   +6587.0%       9.46 =B1 50%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e.handle_mm_fault
      1.77 =B1125%   +8487.3%     151.72 =B1228%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e.kmem_cache_alloc
      0.05 =B1223%   +2843.3%       1.42 =B1150%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lock_releas=
e.perf_event_mmap
      0.00 =B1223%   +5081.8%       0.10 =B1170%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.lockdep_ini=
t_map_type.__raw_spin_lock_init
      1.17 =B1187%   +2440.6%      29.72 =B1189%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.mem_cgroup_=
from_task.handle_mm_fault
      1.26 =B1105%    +253.9%       4.46 =B1 52%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.memcg_slab_=
free_hook.kmem_cache_free
      1.74 =B1132%    +395.9%       8.64 =B1 35%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.obj_cgroup_=
charge.kmem_cache_alloc
      0.00 =B1223%  +2.4e+05%       3.15 =B1165%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.page_counte=
r_try_charge.obj_cgroup_charge_pages
      0.00 =B1223%   +1987.8%       0.05 =B1106%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.perf_lock_t=
ask_context.perf_pin_task_context
      0.00 =B1223%   +8128.6%       0.18 =B1113%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.pte_alloc_o=
ne.do_fault
      0.00 =B1223%  +28185.7%       1.04 =B1229%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.rcu_is_watc=
hing.dput
      0.81 =B1 86%    +582.0%       5.49 =B1 51%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.refill_obj_=
stock.memcg_slab_free_hook
      0.04 =B1168%  +16709.0%       6.95 =B1 44%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.refill_obj_=
stock.obj_cgroup_charge
      0.22 =B1146%   +2102.2%       4.91 =B1136%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.static_obj.=
lockdep_init_map_type
      0.00 =B1223%  +50820.0%       1.27 =B1185%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.strlen.perf=
_event_mmap
      5.01 =B1 52%    +229.3%      16.51 =B1 31%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.syscall_ent=
er_from_user_mode.do_syscall_64
      1.63 =B1223%    +951.0%      17.10 =B1 16%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.thread_grou=
p_cputime.thread_group_cputime_adjusted
      0.05 =B1151%   +5056.5%       2.71 =B1 85%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.unmap_page_=
range.unmap_vmas
      0.03 =B1200%  +19804.7%       6.00 =B1 41%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.up_read.do_=
user_addr_fault
      0.01 =B1141%   +2797.1%       0.24 =B1192%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.vm_unmapped=
_area.arch_get_unmapped_area_topdown
      0.00 =B1223%    +2e+05%       5.26 =B1 46%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.vmacache_fi=
nd.find_vma
      0.00 =B1223%  +24977.0%       0.96 =B1215%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.walk_compon=
ent.link_path_walk
      0.00 =B1223%  +70171.4%       1.41 =B1238%  perf-sched.wait_time.max.=
ms.preempt_schedule_irq.irqentry_exit.asm_sysvec_reschedule_ipi.xas_start.x=
as_load
      8.36 =B1 19%   +2637.0%     228.71 =B1158%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.__perf_sw_event.=
do_user_addr_fault.exc_page_fault
      0.01 =B1223%  +19788.2%       1.16 =B1214%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.kmem_cache_alloc=
.__alloc_file.alloc_empty_file
      0.01 =B1146%   +8216.4%       0.57 =B1231%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.kmem_cache_free.=
__put_anon_vma.unlink_anon_vmas
      5.94 =B1 42%     +85.7%      11.02 =B1 29%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.__m=
ight_fault._copy_from_user
      0.01 =B1 75%  +11643.9%       1.60 =B1186%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.__m=
ight_fault.get_user_arg_ptr
      4.10 =B1 75%    +121.1%       9.07 =B1 18%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.dow=
n_read_trylock.do_user_addr_fault
      2.49 =B1130%    +402.6%      12.53 =B1 55%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.han=
dle_mm_fault.do_user_addr_fault
      0.76 =B1223%   +1327.6%      10.87 =B1 20%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_acquire.thr=
ead_group_cputime.thread_group_cputime_adjusted
      0.00 =B1223%   +4832.5%       0.09 =B1174%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.__a=
lloc_pages.__get_free_pages
      0.00 =B1223%  +71889.3%       1.92 =B1156%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.cop=
y_page_to_iter.shmem_file_read_iter
      3.56 =B1 10%     +46.6%       5.22 =B1 28%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.mem=
cg_slab_free_hook.kmem_cache_free
      0.58 =B1223%    +722.0%       4.78 =B1 69%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.pro=
c_invalidate_siblings_dcache.release_task
      0.58 =B1223%   +1111.7%       7.08 =B1 34%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.thr=
ead_group_cputime.thread_group_cputime_adjusted
      0.01 =B1168%   +1055.9%       0.13 =B1121%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.lock_release.wp_=
page_copy.__handle_mm_fault
      1.13 =B1215%  +38575.8%     436.26 =B1112%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.__alloc_file
      0.08 =B1213%   +3170.2%       2.58 =B1203%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.__anon_vma_prepare
      0.08 =B1223%  +1.8e+05%     151.13 =B1230%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.__d_alloc
      2.20 =B1142%  +26189.6%     578.11 =B1 84%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.anon_vma_clone
      1.39 =B1223%  +31241.3%     436.58 =B1112%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
kmem_cache_alloc.anon_vma_fork
      6.93 =B1  6%     +82.5%      12.64 =B1 58%  perf-sched.wait_time.max.=
ms.preempt_schedule_notrace.preempt_schedule_notrace_thunk.rcu_is_watching.=
rcu_read_lock_held_common.rcu_read_lock_held
      9.37 =B1 14%   +1609.7%     160.15 =B1214%  perf-sched.wait_time.max.=
ms.rwsem_down_write_slowpath.anon_vma_clone.anon_vma_fork.dup_mmap
      0.05 =B1141%  +6.5e+05%     295.63 =B1151%  perf-sched.wait_time.max.=
ms.rwsem_down_write_slowpath.anon_vma_fork.dup_mmap.dup_mm
      8.11 =B1 19%     +66.7%      13.52 =B1 43%  perf-sched.wait_time.max.=
ms.rwsem_down_write_slowpath.dup_mmap.dup_mm.copy_process
      0.30 =B1 61%    +298.5%       1.20 =B1 26%  perf-sched.wait_time.max.=
ms.rwsem_down_write_slowpath.vma_link.mmap_region.do_mmap
     12.00            -2.2        9.77 =B1  4%  perf-profile.calltrace.cycl=
es-pp.__x64_sys_getdents64.do_syscall_64.entry_SYSCALL_64_after_hwframe
     11.84            -2.2        9.62 =B1  4%  perf-profile.calltrace.cycl=
es-pp.dcache_readdir.iterate_dir.__x64_sys_getdents64.do_syscall_64.entry_S=
YSCALL_64_after_hwframe
     11.97            -2.2        9.75 =B1  4%  perf-profile.calltrace.cycl=
es-pp.iterate_dir.__x64_sys_getdents64.do_syscall_64.entry_SYSCALL_64_after=
_hwframe
     11.42            -2.2        9.24 =B1  4%  perf-profile.calltrace.cycl=
es-pp.scan_positives.dcache_readdir.iterate_dir.__x64_sys_getdents64.do_sys=
call_64
     11.56 =B1  3%      -1.2       10.36 =B1  7%  perf-profile.calltrace.cy=
cles-pp.execve
     11.44 =B1  3%      -1.2       10.26 =B1  7%  perf-profile.calltrace.cy=
cles-pp.__x64_sys_execve.do_syscall_64.entry_SYSCALL_64_after_hwframe.execve
     11.44 =B1  3%      -1.2       10.26 =B1  7%  perf-profile.calltrace.cy=
cles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.execve
     11.44 =B1  3%      -1.2       10.26 =B1  7%  perf-profile.calltrace.cy=
cles-pp.entry_SYSCALL_64_after_hwframe.execve
     11.31 =B1  3%      -1.2       10.13 =B1  7%  perf-profile.calltrace.cy=
cles-pp.do_execveat_common.__x64_sys_execve.do_syscall_64.entry_SYSCALL_64_=
after_hwframe.execve
     12.64 =B1  2%      -1.1       11.57        perf-profile.calltrace.cycl=
es-pp.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.a=
sm_exc_page_fault
      2.84 =B1  8%      -1.1        1.78 =B1 20%  perf-profile.calltrace.cy=
cles-pp.do_raw_spin_lock.scan_positives.dcache_readdir.iterate_dir.__x64_sy=
s_getdents64
      2.45 =B1  9%      -1.0        1.45 =B1 24%  perf-profile.calltrace.cy=
cles-pp.native_queued_spin_lock_slowpath.do_raw_spin_lock.scan_positives.dc=
ache_readdir.iterate_dir
      4.78 =B1  3%      -0.9        3.88 =B1 17%  perf-profile.calltrace.cy=
cles-pp.kill
      4.76 =B1  3%      -0.9        3.85 =B1 17%  perf-profile.calltrace.cy=
cles-pp.entry_SYSCALL_64_after_hwframe.kill
      4.75 =B1  3%      -0.9        3.85 =B1 17%  perf-profile.calltrace.cy=
cles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.kill
      5.38 =B1  4%      -0.9        4.48 =B1  3%  perf-profile.calltrace.cy=
cles-pp.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_p=
age_fault
      5.01 =B1  4%      -0.8        4.21 =B1  8%  perf-profile.calltrace.cy=
cles-pp.lock_page_memcg.page_remove_rmap.zap_pte_range.unmap_page_range.unm=
ap_vmas
      6.32 =B1  4%      -0.6        5.68 =B1  3%  perf-profile.calltrace.cy=
cles-pp.zap_pte_range.unmap_page_range.unmap_vmas.exit_mmap.mmput
      3.14 =B1  3%      -0.6        2.52 =B1 16%  perf-profile.calltrace.cy=
cles-pp.__x64_sys_kill.do_syscall_64.entry_SYSCALL_64_after_hwframe.kill
      2.90 =B1  4%      -0.6        2.34 =B1 16%  perf-profile.calltrace.cy=
cles-pp.kill_proc_info.__x64_sys_kill.do_syscall_64.entry_SYSCALL_64_after_=
hwframe.kill
      9.05            -0.5        8.56 =B1  2%  perf-profile.calltrace.cycl=
es-pp.bprm_execve.do_execveat_common.__x64_sys_execve.do_syscall_64.entry_S=
YSCALL_64_after_hwframe
      4.26 =B1  5%      -0.5        3.77 =B1  3%  perf-profile.calltrace.cy=
cles-pp.filemap_map_pages.do_fault.__handle_mm_fault.handle_mm_fault.do_use=
r_addr_fault
      1.60 =B1 15%      -0.5        1.13 =B1  3%  perf-profile.calltrace.cy=
cles-pp.path_lookupat.filename_lookup.vfs_statx.__do_sys_newstat.do_syscall=
_64
      3.86            -0.5        3.39        perf-profile.calltrace.cycles=
-pp.dput.scan_positives.dcache_readdir.iterate_dir.__x64_sys_getdents64
      8.61            -0.5        8.14 =B1  3%  perf-profile.calltrace.cycl=
es-pp.load_elf_binary.exec_binprm.bprm_execve.do_execveat_common.__x64_sys_=
execve
      4.76 =B1  4%      -0.5        4.29 =B1  2%  perf-profile.calltrace.cy=
cles-pp.page_remove_rmap.zap_pte_range.unmap_page_range.unmap_vmas.exit_mmap
      8.70            -0.5        8.23 =B1  3%  perf-profile.calltrace.cycl=
es-pp.exec_binprm.bprm_execve.do_execveat_common.__x64_sys_execve.do_syscal=
l_64
      1.72 =B1 12%      -0.4        1.30 =B1 19%  perf-profile.calltrace.cy=
cles-pp.filename_lookup.vfs_statx.__do_sys_newstat.do_syscall_64.entry_SYSC=
ALL_64_after_hwframe
      4.98 =B1  3%      -0.4        4.59 =B1  2%  perf-profile.calltrace.cy=
cles-pp.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL=
_64_after_hwframe
      4.96 =B1  3%      -0.4        4.58 =B1  2%  perf-profile.calltrace.cy=
cles-pp.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64
      6.33            -0.3        5.99 =B1  2%  perf-profile.calltrace.cycl=
es-pp.copy_process.kernel_clone.__do_sys_clone.do_syscall_64.entry_SYSCALL_=
64_after_hwframe
      1.54 =B1  5%      -0.3        1.23 =B1 17%  perf-profile.calltrace.cy=
cles-pp.do_send_sig_info.kill_pid_info.kill_proc_info.__x64_sys_kill.do_sys=
call_64
      2.61 =B1  5%      -0.3        2.30 =B1  2%  perf-profile.calltrace.cy=
cles-pp.lock_acquire.lock_page_memcg.page_remove_rmap.zap_pte_range.unmap_p=
age_range
      2.74 =B1  4%      -0.3        2.43 =B1  3%  perf-profile.calltrace.cy=
cles-pp.kill_pid_info.kill_proc_info.__x64_sys_kill.do_syscall_64.entry_SYS=
CALL_64_after_hwframe
      5.30            -0.3        5.01 =B1  2%  perf-profile.calltrace.cycl=
es-pp.dup_mm.copy_process.kernel_clone.__do_sys_clone.do_syscall_64
      5.19            -0.3        4.90 =B1  2%  perf-profile.calltrace.cycl=
es-pp.dup_mmap.dup_mm.copy_process.kernel_clone.__do_sys_clone
      2.89 =B1  2%      -0.3        2.61 =B1  3%  perf-profile.calltrace.cy=
cles-pp.do_set_pte.filemap_map_pages.do_fault.__handle_mm_fault.handle_mm_f=
ault
      0.73 =B1  6%      -0.3        0.46 =B1 63%  perf-profile.calltrace.cy=
cles-pp.get_mem_cgroup_from_mm.mem_cgroup_charge.do_anonymous_page.__handle=
_mm_fault.handle_mm_fault
      2.01 =B1  2%      -0.3        1.74 =B1  8%  perf-profile.calltrace.cy=
cles-pp.unmap_vmas.exit_mmap.mmput.begin_new_exec.load_elf_binary
      1.99 =B1  2%      -0.3        1.73 =B1  8%  perf-profile.calltrace.cy=
cles-pp.unmap_page_range.unmap_vmas.exit_mmap.mmput.begin_new_exec
      2.52            -0.2        2.27 =B1  2%  perf-profile.calltrace.cycl=
es-pp.setlocale
      5.87            -0.2        5.62 =B1  3%  perf-profile.calltrace.cycl=
es-pp.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_faul=
t.exc_page_fault
      1.46 =B1  5%      -0.2        1.21 =B1  6%  perf-profile.calltrace.cy=
cles-pp.elf_map.load_elf_binary.exec_binprm.bprm_execve.do_execveat_common
      2.30            -0.2        2.06 =B1  3%  perf-profile.calltrace.cycl=
es-pp.lock_page_memcg.page_add_file_rmap.do_set_pte.filemap_map_pages.do_fa=
ult
      0.63 =B1  7%      -0.2        0.40 =B1 63%  perf-profile.calltrace.cy=
cles-pp.perf_event_mmap.do_brk_flags.__x64_sys_brk.do_syscall_64.entry_SYSC=
ALL_64_after_hwframe
      1.21 =B1  5%      -0.2        0.98 =B1 15%  perf-profile.calltrace.cy=
cles-pp.unlink
      1.20 =B1  5%      -0.2        0.97 =B1 15%  perf-profile.calltrace.cy=
cles-pp.entry_SYSCALL_64_after_hwframe.unlink
      1.20 =B1  6%      -0.2        0.97 =B1 15%  perf-profile.calltrace.cy=
cles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.unlink
      2.40            -0.2        2.17 =B1  3%  perf-profile.calltrace.cycl=
es-pp.page_add_file_rmap.do_set_pte.filemap_map_pages.do_fault.__handle_mm_=
fault
      1.26 =B1  4%      -0.2        1.04 =B1 14%  perf-profile.calltrace.cy=
cles-pp.do_brk_flags.__x64_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwf=
rame.brk
      2.10            -0.2        1.88 =B1  2%  perf-profile.calltrace.cycl=
es-pp.lockref_put_or_lock.dput.scan_positives.dcache_readdir.iterate_dir
      1.06 =B1 24%      -0.2        0.83 =B1  3%  perf-profile.calltrace.cy=
cles-pp.kmem_cache_alloc.vm_area_dup.dup_mmap.dup_mm.copy_process
      1.19 =B1  6%      -0.2        0.98 =B1  7%  perf-profile.calltrace.cy=
cles-pp.vm_mmap_pgoff.elf_map.load_elf_binary.exec_binprm.bprm_execve
      1.09 =B1  6%      -0.2        0.89 =B1 15%  perf-profile.calltrace.cy=
cles-pp.do_unlinkat.do_syscall_64.entry_SYSCALL_64_after_hwframe.unlink
      0.80 =B1  5%      -0.2        0.60 =B1 43%  perf-profile.calltrace.cy=
cles-pp.arch_do_signal_or_restart.exit_to_user_mode_prepare.syscall_exit_to=
_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.96 =B1  4%      -0.2        0.77 =B1 16%  perf-profile.calltrace.cy=
cles-pp.group_send_sig_info.kill_pid_info.kill_proc_info.__x64_sys_kill.do_=
syscall_64
      1.08 =B1  5%      -0.2        0.88 =B1  8%  perf-profile.calltrace.cy=
cles-pp.do_mmap.vm_mmap_pgoff.elf_map.load_elf_binary.exec_binprm
      1.06 =B1  6%      -0.2        0.87 =B1  7%  perf-profile.calltrace.cy=
cles-pp.mmap_region.do_mmap.vm_mmap_pgoff.elf_map.load_elf_binary
      1.40 =B1  2%      -0.2        1.21 =B1  3%  perf-profile.calltrace.cy=
cles-pp._raw_spin_unlock.scan_positives.dcache_readdir.iterate_dir.__x64_sy=
s_getdents64
      1.29 =B1  2%      -0.2        1.11 =B1  4%  perf-profile.calltrace.cy=
cles-pp._raw_spin_lock_nested.scan_positives.dcache_readdir.iterate_dir.__x=
64_sys_getdents64
      1.32 =B1  3%      -0.2        1.14 =B1  3%  perf-profile.calltrace.cy=
cles-pp._raw_spin_lock.scan_positives.dcache_readdir.iterate_dir.__x64_sys_=
getdents64
      1.24 =B1  2%      -0.2        1.06 =B1  4%  perf-profile.calltrace.cy=
cles-pp.lock_acquire._raw_spin_lock_nested.scan_positives.dcache_readdir.it=
erate_dir
      1.02 =B1  3%      -0.2        0.84 =B1 15%  perf-profile.calltrace.cy=
cles-pp.alloc_pages_vma.do_anonymous_page.__handle_mm_fault.handle_mm_fault=
.do_user_addr_fault
      0.99 =B1  3%      -0.2        0.82 =B1 15%  perf-profile.calltrace.cy=
cles-pp.__alloc_pages.alloc_pages_vma.do_anonymous_page.__handle_mm_fault.h=
andle_mm_fault
      2.02            -0.2        1.85        perf-profile.calltrace.cycles=
-pp.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_af=
ter_hwframe
      1.96 =B1  2%      -0.2        1.80        perf-profile.calltrace.cycl=
es-pp.mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
      0.92 =B1  5%      -0.2        0.76 =B1 17%  perf-profile.calltrace.cy=
cles-pp.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwfr=
ame.kill
      1.22 =B1  3%      -0.2        1.06 =B1  3%  perf-profile.calltrace.cy=
cles-pp.lock_acquire._raw_spin_lock.scan_positives.dcache_readdir.iterate_d=
ir
      1.13 =B1  3%      -0.2        0.97 =B1  3%  perf-profile.calltrace.cy=
cles-pp.lock_release._raw_spin_unlock.scan_positives.dcache_readdir.iterate=
_dir
      1.32 =B1  2%      -0.1        1.18 =B1  3%  perf-profile.calltrace.cy=
cles-pp._raw_spin_lock.lockref_put_or_lock.dput.scan_positives.dcache_readd=
ir
      0.59 =B1  6%      -0.1        0.45 =B1 40%  perf-profile.calltrace.cy=
cles-pp.rcu_read_lock_sched_held.lock_acquire.lock_page_memcg.page_remove_r=
map.zap_pte_range
      1.35 =B1  2%      -0.1        1.21 =B1  3%  perf-profile.calltrace.cy=
cles-pp.lock_acquire.lock_page_memcg.page_add_file_rmap.do_set_pte.filemap_=
map_pages
      2.85 =B1  2%      -0.1        2.72        perf-profile.calltrace.cycl=
es-pp.__libc_fork
      0.87 =B1  3%      -0.1        0.74 =B1  3%  perf-profile.calltrace.cy=
cles-pp.sync
      0.86 =B1  3%      -0.1        0.74 =B1  3%  perf-profile.calltrace.cy=
cles-pp.entry_SYSCALL_64_after_hwframe.sync
      0.86 =B1  3%      -0.1        0.74 =B1  3%  perf-profile.calltrace.cy=
cles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.sync
      0.97 =B1  5%      -0.1        0.84 =B1  4%  perf-profile.calltrace.cy=
cles-pp.lock_acquire.dput.scan_positives.dcache_readdir.iterate_dir
      0.86 =B1  3%      -0.1        0.74 =B1  3%  perf-profile.calltrace.cy=
cles-pp.__x64_sys_sync.do_syscall_64.entry_SYSCALL_64_after_hwframe.sync
      0.86 =B1  3%      -0.1        0.74 =B1  3%  perf-profile.calltrace.cy=
cles-pp.ksys_sync.__x64_sys_sync.do_syscall_64.entry_SYSCALL_64_after_hwfra=
me.sync
      1.39 =B1  2%      -0.1        1.27 =B1  3%  perf-profile.calltrace.cy=
cles-pp.vfs_statx.__do_sys_newstat.do_syscall_64.entry_SYSCALL_64_after_hwf=
rame
      1.40 =B1  2%      -0.1        1.28 =B1  4%  perf-profile.calltrace.cy=
cles-pp.__do_sys_newstat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.44 =B1  2%      -0.1        2.32 =B1  2%  perf-profile.calltrace.cy=
cles-pp.entry_SYSCALL_64_after_hwframe.__libc_fork
      2.44 =B1  2%      -0.1        2.32 =B1  2%  perf-profile.calltrace.cy=
cles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_fork
      0.80 =B1  3%      -0.1        0.69 =B1  4%  perf-profile.calltrace.cy=
cles-pp.iterate_supers.ksys_sync.__x64_sys_sync.do_syscall_64.entry_SYSCALL=
_64_after_hwframe
      0.94 =B1  4%      -0.1        0.82 =B1  3%  perf-profile.calltrace.cy=
cles-pp.entry_SYSCALL_64_after_hwframe.__mmap
      0.94 =B1  4%      -0.1        0.82 =B1  3%  perf-profile.calltrace.cy=
cles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
      2.44 =B1  2%      -0.1        2.32 =B1  2%  perf-profile.calltrace.cy=
cles-pp.__do_sys_clone.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_=
fork
      2.44 =B1  2%      -0.1        2.32 =B1  2%  perf-profile.calltrace.cy=
cles-pp.kernel_clone.__do_sys_clone.do_syscall_64.entry_SYSCALL_64_after_hw=
frame.__libc_fork
      0.94 =B1  4%      -0.1        0.83 =B1  3%  perf-profile.calltrace.cy=
cles-pp.__mmap
      1.19 =B1  2%      -0.1        1.08 =B1  4%  perf-profile.calltrace.cy=
cles-pp.lock_acquire._raw_spin_lock.lockref_put_or_lock.dput.scan_positives
      0.82 =B1  3%      -0.1        0.71 =B1  6%  perf-profile.calltrace.cy=
cles-pp.__xstat64
      0.68 =B1  3%      -0.1        0.57 =B1  4%  perf-profile.calltrace.cy=
cles-pp.__lock_acquire.lock_acquire._raw_spin_lock_nested.scan_positives.dc=
ache_readdir
      0.91 =B1  4%      -0.1        0.80 =B1  3%  perf-profile.calltrace.cy=
cles-pp.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
      0.94 =B1  4%      -0.1        0.84 =B1  8%  perf-profile.calltrace.cy=
cles-pp.__clear_user.load_elf_binary.exec_binprm.bprm_execve.do_execveat_co=
mmon
      0.73 =B1  3%      -0.1        0.63 =B1  6%  perf-profile.calltrace.cy=
cles-pp.__do_sys_newstat.do_syscall_64.entry_SYSCALL_64_after_hwframe.__xst=
at64
      0.88 =B1  4%      -0.1        0.78 =B1  3%  perf-profile.calltrace.cy=
cles-pp.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_=
hwframe.__mmap
      0.75 =B1  3%      -0.1        0.65 =B1  6%  perf-profile.calltrace.cy=
cles-pp.entry_SYSCALL_64_after_hwframe.__xstat64
      0.75 =B1  2%      -0.1        0.65 =B1  6%  perf-profile.calltrace.cy=
cles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__xstat64
      2.33            -0.1        2.23 =B1  2%  perf-profile.calltrace.cycl=
es-pp.anon_vma_fork.dup_mmap.dup_mm.copy_process.kernel_clone
      0.70 =B1  3%      -0.1        0.61 =B1  6%  perf-profile.calltrace.cy=
cles-pp.vfs_statx.__do_sys_newstat.do_syscall_64.entry_SYSCALL_64_after_hwf=
rame.__xstat64
      1.14 =B1  3%      -0.1        1.05 =B1  3%  perf-profile.calltrace.cy=
cles-pp.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwf=
rame.__open64_nocancel
      1.18 =B1  3%      -0.1        1.09 =B1  3%  perf-profile.calltrace.cy=
cles-pp.entry_SYSCALL_64_after_hwframe.__open64_nocancel.setlocale
      1.18 =B1  3%      -0.1        1.09 =B1  3%  perf-profile.calltrace.cy=
cles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__open64_nocancel.setl=
ocale
      1.19 =B1  3%      -0.1        1.11 =B1  3%  perf-profile.calltrace.cy=
cles-pp.__open64_nocancel.setlocale
      1.14 =B1  3%      -0.1        1.06 =B1  3%  perf-profile.calltrace.cy=
cles-pp.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe.__open64_n=
ocancel.setlocale
      0.69 =B1  4%      -0.1        0.61 =B1  4%  perf-profile.calltrace.cy=
cles-pp.__lock_acquire.lock_acquire._raw_spin_lock.scan_positives.dcache_re=
addir
      0.69 =B1  4%      -0.1        0.61 =B1  2%  perf-profile.calltrace.cy=
cles-pp.asm_exc_page_fault.setlocale
      0.67 =B1  5%      -0.1        0.59 =B1  5%  perf-profile.calltrace.cy=
cles-pp.rcu_read_lock_sched_held.lock_release._raw_spin_unlock.scan_positiv=
es.dcache_readdir
      0.67 =B1  4%      -0.1        0.59 =B1  2%  perf-profile.calltrace.cy=
cles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.setlocale
      0.68 =B1  5%      -0.1        0.60 =B1  2%  perf-profile.calltrace.cy=
cles-pp.exc_page_fault.asm_exc_page_fault.setlocale
      0.79 =B1  4%      -0.1        0.72 =B1  4%  perf-profile.calltrace.cy=
cles-pp.__x64_sys_mprotect.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.79 =B1  4%      -0.1        0.72 =B1  4%  perf-profile.calltrace.cy=
cles-pp.do_mprotect_pkey.__x64_sys_mprotect.do_syscall_64.entry_SYSCALL_64_=
after_hwframe
      0.70 =B1  3%      -0.1        0.63 =B1  2%  perf-profile.calltrace.cy=
cles-pp._raw_spin_unlock.lockref_put_or_lock.dput.scan_positives.dcache_rea=
ddir
      0.66 =B1  3%      -0.1        0.60 =B1  5%  perf-profile.calltrace.cy=
cles-pp.__lock_acquire.lock_acquire._raw_spin_lock.lockref_put_or_lock.dput
      0.70 =B1  5%      -0.1        0.63 =B1  4%  perf-profile.calltrace.cy=
cles-pp.__lock_acquire.lock_acquire.lock_page_memcg.page_add_file_rmap.do_s=
et_pte
      0.74 =B1  3%      -0.1        0.68 =B1  4%  perf-profile.calltrace.cy=
cles-pp.mprotect_fixup.do_mprotect_pkey.__x64_sys_mprotect.do_syscall_64.en=
try_SYSCALL_64_after_hwframe
      0.58 =B1  5%      -0.1        0.52 =B1  2%  perf-profile.calltrace.cy=
cles-pp.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_faul=
t.setlocale
      0.00            +0.6        0.56 =B1  5%  perf-profile.calltrace.cycl=
es-pp.__schedule.schedule.worker_thread.kthread.ret_from_fork
      0.00            +0.6        0.58 =B1  4%  perf-profile.calltrace.cycl=
es-pp.schedule.worker_thread.kthread.ret_from_fork
      0.00            +0.9        0.92 =B1  2%  perf-profile.calltrace.cycl=
es-pp.lock_acquire.cgroup_rstat_flush_locked.cgroup_rstat_flush_irqsafe.mem=
_cgroup_flush_stats.process_one_work
      3.56 =B1  8%      +1.6        5.19 =B1  3%  perf-profile.calltrace.cy=
cles-pp.intel_idle.cpuidle_enter_state.cpuidle_enter.do_idle.cpu_startup_en=
try
      5.41 =B1  8%      +1.8        7.24 =B1  3%  perf-profile.calltrace.cy=
cles-pp.cpuidle_enter_state.cpuidle_enter.do_idle.cpu_startup_entry.start_s=
econdary
      5.46 =B1  8%      +1.8        7.30 =B1  3%  perf-profile.calltrace.cy=
cles-pp.cpuidle_enter.do_idle.cpu_startup_entry.start_secondary.secondary_s=
tartup_64_no_verify
      0.00            +1.9        1.95 =B1  2%  perf-profile.calltrace.cycl=
es-pp.mem_cgroup_css_rstat_flush.cgroup_rstat_flush_locked.cgroup_rstat_flu=
sh_irqsafe.mem_cgroup_flush_stats.process_one_work
      6.01 =B1  9%      +2.3        8.32 =B1  3%  perf-profile.calltrace.cy=
cles-pp.cpu_startup_entry.start_secondary.secondary_startup_64_no_verify
      6.01 =B1  9%      +2.3        8.32 =B1  3%  perf-profile.calltrace.cy=
cles-pp.start_secondary.secondary_startup_64_no_verify
      6.00 =B1  9%      +2.3        8.31 =B1  3%  perf-profile.calltrace.cy=
cles-pp.do_idle.cpu_startup_entry.start_secondary.secondary_startup_64_no_v=
erify
      6.40 =B1  9%      +2.4        8.83 =B1  4%  perf-profile.calltrace.cy=
cles-pp.secondary_startup_64_no_verify
      0.00            +4.7        4.70 =B1  2%  perf-profile.calltrace.cycl=
es-pp.cgroup_rstat_flush_locked.cgroup_rstat_flush_irqsafe.mem_cgroup_flush=
_stats.process_one_work.worker_thread
      0.00            +4.7        4.75 =B1  2%  perf-profile.calltrace.cycl=
es-pp.cgroup_rstat_flush_irqsafe.mem_cgroup_flush_stats.process_one_work.wo=
rker_thread.kthread
      0.00            +5.0        4.97 =B1  2%  perf-profile.calltrace.cycl=
es-pp.mem_cgroup_flush_stats.process_one_work.worker_thread.kthread.ret_fro=
m_fork
      0.51 =B1 44%      +5.3        5.83        perf-profile.calltrace.cycl=
es-pp.process_one_work.worker_thread.kthread.ret_from_fork
      1.45 =B1  3%      +5.8        7.26        perf-profile.calltrace.cycl=
es-pp.ret_from_fork
      1.43 =B1  3%      +5.8        7.24        perf-profile.calltrace.cycl=
es-pp.kthread.ret_from_fork
      0.62 =B1  7%      +5.9        6.49        perf-profile.calltrace.cycl=
es-pp.worker_thread.kthread.ret_from_fork
     68.58            -6.3       62.23        perf-profile.children.cycles-=
pp.entry_SYSCALL_64_after_hwframe
     68.53            -6.3       62.18        perf-profile.children.cycles-=
pp.do_syscall_64
     12.00            -2.2        9.77 =B1  4%  perf-profile.children.cycle=
s-pp.__x64_sys_getdents64
     11.84            -2.2        9.62 =B1  4%  perf-profile.children.cycle=
s-pp.dcache_readdir
     11.98            -2.2        9.75 =B1  4%  perf-profile.children.cycle=
s-pp.iterate_dir
     11.43            -2.2        9.26 =B1  4%  perf-profile.children.cycle=
s-pp.scan_positives
     21.24            -1.5       19.78        perf-profile.children.cycles-=
pp.asm_exc_page_fault
     20.66            -1.3       19.32        perf-profile.children.cycles-=
pp.exc_page_fault
     20.44            -1.3       19.12        perf-profile.children.cycles-=
pp.do_user_addr_fault
     33.66            -1.2       32.41        perf-profile.children.cycles-=
pp.lock_acquire
     16.79            -1.2       15.57        perf-profile.children.cycles-=
pp.__handle_mm_fault
     11.56 =B1  3%      -1.2       10.37 =B1  7%  perf-profile.children.cyc=
les-pp.execve
     19.02            -1.1       17.89        perf-profile.children.cycles-=
pp.handle_mm_fault
      9.69 =B1  2%      -1.1        8.61        perf-profile.children.cycle=
s-pp.lock_page_memcg
     11.75            -0.9       10.80        perf-profile.children.cycles-=
pp.check_preemption_disabled
     23.40            -0.9       22.48        perf-profile.children.cycles-=
pp.rcu_read_lock_sched_held
      8.81            -0.9        7.90        perf-profile.children.cycles-=
pp.do_fault
      4.80 =B1  3%      -0.9        3.88 =B1 17%  perf-profile.children.cyc=
les-pp.kill
      7.80            -0.8        6.96 =B1  2%  perf-profile.children.cycle=
s-pp.filemap_map_pages
     11.79            -0.8       11.00        perf-profile.children.cycles-=
pp.__x64_sys_execve
     11.65            -0.8       10.86        perf-profile.children.cycles-=
pp.do_execveat_common
      6.16            -0.7        5.46 =B1  2%  perf-profile.children.cycle=
s-pp.dput
     18.41            -0.7       17.71        perf-profile.children.cycles-=
pp.lock_release
     10.40            -0.6        9.78        perf-profile.children.cycles-=
pp.rcu_read_lock_held_common
      5.50 =B1  2%      -0.6        4.88 =B1  2%  perf-profile.children.cyc=
les-pp.do_set_pte
      8.02 =B1  3%      -0.6        7.42        perf-profile.children.cycle=
s-pp.unmap_vmas
      7.92 =B1  3%      -0.6        7.33        perf-profile.children.cycle=
s-pp.unmap_page_range
     10.56 =B1  2%      -0.6        9.99        perf-profile.children.cycle=
s-pp.mmput
     17.03            -0.6       16.46        perf-profile.children.cycles-=
pp.__lock_acquire
     10.54 =B1  2%      -0.6        9.97        perf-profile.children.cycle=
s-pp.exit_mmap
      7.72 =B1  3%      -0.6        7.16        perf-profile.children.cycle=
s-pp.zap_pte_range
      9.20            -0.5        8.66        perf-profile.children.cycles-=
pp.bprm_execve
     17.96            -0.5       17.42        perf-profile.children.cycles-=
pp.lock_is_held_type
      3.54 =B1  2%      -0.5        3.01 =B1  2%  perf-profile.children.cyc=
les-pp.debug_lockdep_rcu_enabled
      8.75            -0.5        8.23 =B1  2%  perf-profile.children.cycle=
s-pp.load_elf_binary
      8.85            -0.5        8.33 =B1  2%  perf-profile.children.cycle=
s-pp.exec_binprm
      4.53            -0.5        4.02 =B1  2%  perf-profile.children.cycle=
s-pp.page_add_file_rmap
      6.34 =B1  2%      -0.5        5.88        perf-profile.children.cycle=
s-pp.do_sys_open
      6.34 =B1  2%      -0.5        5.87        perf-profile.children.cycle=
s-pp.do_sys_openat2
     10.06            -0.4        9.63        perf-profile.children.cycles-=
pp.kmem_cache_alloc
      3.29            -0.4        2.87 =B1  2%  perf-profile.children.cycle=
s-pp.__x64_sys_kill
      5.76 =B1  3%      -0.4        5.36        perf-profile.children.cycle=
s-pp.do_filp_open
      5.75 =B1  3%      -0.4        5.35        perf-profile.children.cycle=
s-pp.path_openat
      6.01 =B1  3%      -0.4        5.63        perf-profile.children.cycle=
s-pp.page_remove_rmap
      3.04            -0.4        2.66 =B1  2%  perf-profile.children.cycle=
s-pp.kill_proc_info
      2.86            -0.4        2.49 =B1  2%  perf-profile.children.cycle=
s-pp.kill_pid_info
      3.93            -0.4        3.56        perf-profile.children.cycles-=
pp.trace_hardirqs_on
      3.40            -0.4        3.03 =B1  2%  perf-profile.children.cycle=
s-pp.vm_mmap_pgoff
      6.52            -0.4        6.17 =B1  2%  perf-profile.children.cycle=
s-pp.__do_sys_clone
      6.52            -0.4        6.17 =B1  2%  perf-profile.children.cycle=
s-pp.kernel_clone
      3.56 =B1  2%      -0.4        3.20 =B1  2%  perf-profile.children.cyc=
les-pp.lockdep_hardirqs_on_prepare
      6.34            -0.3        5.99 =B1  2%  perf-profile.children.cycle=
s-pp.copy_process
      3.13            -0.3        2.79 =B1  2%  perf-profile.children.cycle=
s-pp.do_mmap
      3.05            -0.3        2.72 =B1  2%  perf-profile.children.cycle=
s-pp.mmap_region
      3.31 =B1  2%      -0.3        2.98 =B1  3%  perf-profile.children.cyc=
les-pp.___might_sleep
      3.99            -0.3        3.67        perf-profile.children.cycles-=
pp.mark_lock
      2.22            -0.3        1.91        perf-profile.children.cycles-=
pp.perf_event_mmap
      2.51            -0.3        2.20 =B1  2%  perf-profile.children.cycle=
s-pp.fs_reclaim_acquire
      4.88            -0.3        4.57        perf-profile.children.cycles-=
pp.rcu_is_watching
      2.86 =B1  2%      -0.3        2.55        perf-profile.children.cycle=
s-pp.__alloc_pages
      2.75 =B1  3%      -0.3        2.45 =B1  2%  perf-profile.children.cyc=
les-pp.lockref_put_or_lock
      5.31            -0.3        5.02 =B1  2%  perf-profile.children.cycle=
s-pp.dup_mm
      5.20            -0.3        4.91 =B1  2%  perf-profile.children.cycle=
s-pp.dup_mmap
      2.65 =B1  3%      -0.3        2.37 =B1  2%  perf-profile.children.cyc=
les-pp.get_obj_cgroup_from_current
      2.45 =B1  2%      -0.3        2.18 =B1  4%  perf-profile.children.cyc=
les-pp.__might_fault
      3.55 =B1  2%      -0.3        3.28        perf-profile.children.cycle=
s-pp.walk_component
      4.79            -0.3        4.54        perf-profile.children.cycles-=
pp.rcu_lockdep_current_cpu_online
      2.52            -0.2        2.27 =B1  2%  perf-profile.children.cycle=
s-pp.setlocale
      3.08 =B1  3%      -0.2        2.83        perf-profile.children.cycle=
s-pp.link_path_walk
      2.58 =B1  2%      -0.2        2.33        perf-profile.children.cycle=
s-pp.syscall_exit_to_user_mode
      1.21 =B1  5%      -0.2        0.98 =B1 15%  perf-profile.children.cyc=
les-pp.unlink
      6.20            -0.2        5.97 =B1  2%  perf-profile.children.cycle=
s-pp.do_anonymous_page
      1.61 =B1  2%      -0.2        1.39 =B1  3%  perf-profile.children.cyc=
les-pp.do_send_sig_info
      2.16            -0.2        1.95 =B1  2%  perf-profile.children.cycle=
s-pp.vfs_statx
      2.12            -0.2        1.91 =B1  2%  perf-profile.children.cycle=
s-pp.__do_sys_newstat
      2.88 =B1  3%      -0.2        2.67 =B1  3%  perf-profile.children.cyc=
les-pp.rcu_read_lock_held
      1.50 =B1  4%      -0.2        1.29 =B1  3%  perf-profile.children.cyc=
les-pp.elf_map
      2.14 =B1  2%      -0.2        1.94 =B1  3%  perf-profile.children.cyc=
les-pp.filename_lookup
      2.11 =B1  2%      -0.2        1.91        perf-profile.children.cycle=
s-pp.mark_held_locks
      2.24            -0.2        2.04        perf-profile.children.cycles-=
pp.ksys_mmap_pgoff
      2.09 =B1  2%      -0.2        1.90 =B1  3%  perf-profile.children.cyc=
les-pp.path_lookupat
      1.35 =B1  2%      -0.2        1.16 =B1  5%  perf-profile.children.cyc=
les-pp._raw_spin_lock_nested
      1.58            -0.2        1.41        perf-profile.children.cycles-=
pp.alloc_pages_vma
      2.00 =B1  2%      -0.2        1.84        perf-profile.children.cycle=
s-pp.exit_to_user_mode_prepare
      1.62            -0.2        1.45 =B1  3%  perf-profile.children.cycle=
s-pp.__perf_sw_event
      1.48 =B1  5%      -0.2        1.32 =B1  4%  perf-profile.children.cyc=
les-pp.trace_hardirqs_off
      1.17 =B1  4%      -0.2        1.01 =B1  3%  perf-profile.children.cyc=
les-pp.lockdep_hardirqs_off
      1.41            -0.2        1.25 =B1  2%  perf-profile.children.cycle=
s-pp.do_brk_flags
      1.16 =B1  5%      -0.1        1.02 =B1  6%  perf-profile.children.cyc=
les-pp.do_unlinkat
      4.74            -0.1        4.60        perf-profile.children.cycles-=
pp.__x64_sys_brk
      1.20 =B1  3%      -0.1        1.06 =B1  2%  perf-profile.children.cyc=
les-pp.down_write
      1.64 =B1  2%      -0.1        1.51        perf-profile.children.cycle=
s-pp.__open64_nocancel
      2.86 =B1  2%      -0.1        2.73 =B1  2%  perf-profile.children.cyc=
les-pp.__libc_fork
      1.01 =B1  3%      -0.1        0.88 =B1  5%  perf-profile.children.cyc=
les-pp.group_send_sig_info
      1.22 =B1  5%      -0.1        1.09 =B1  3%  perf-profile.children.cyc=
les-pp.step_into
      0.89 =B1  3%      -0.1        0.76 =B1  2%  perf-profile.children.cyc=
les-pp.get_user_arg_ptr
      1.33 =B1  4%      -0.1        1.21 =B1  2%  perf-profile.children.cyc=
les-pp.copy_strings
      0.87 =B1  3%      -0.1        0.74 =B1  3%  perf-profile.children.cyc=
les-pp.sync
      1.16 =B1  2%      -0.1        1.04 =B1  4%  perf-profile.children.cyc=
les-pp.get_mem_cgroup_from_mm
      0.86 =B1  3%      -0.1        0.74 =B1  3%  perf-profile.children.cyc=
les-pp.__x64_sys_sync
      0.86 =B1  3%      -0.1        0.74 =B1  3%  perf-profile.children.cyc=
les-pp.ksys_sync
      1.26 =B1  4%      -0.1        1.14 =B1  3%  perf-profile.children.cyc=
les-pp.arch_do_signal_or_restart
      2.50 =B1  2%      -0.1        2.38 =B1  3%  perf-profile.children.cyc=
les-pp.mem_cgroup_charge
      0.77 =B1  4%      -0.1        0.65 =B1  4%  perf-profile.children.cyc=
les-pp.d_path
      0.81 =B1  3%      -0.1        0.69 =B1  4%  perf-profile.children.cyc=
les-pp.iterate_supers
      0.59 =B1  4%      -0.1        0.47 =B1  5%  perf-profile.children.cyc=
les-pp.count
      0.95 =B1  5%      -0.1        0.83 =B1  3%  perf-profile.children.cyc=
les-pp.__mmap
      1.10 =B1  4%      -0.1        0.99 =B1  4%  perf-profile.children.cyc=
les-pp.getname_flags
      0.87            -0.1        0.76 =B1  3%  perf-profile.children.cycle=
s-pp.terminate_walk
      2.02 =B1  2%      -0.1        1.91        perf-profile.children.cycle=
s-pp.vm_area_dup
      0.94 =B1  3%      -0.1        0.83 =B1  4%  perf-profile.children.cyc=
les-pp.next_uptodate_page
      0.82 =B1  3%      -0.1        0.71 =B1  6%  perf-profile.children.cyc=
les-pp.__xstat64
      1.79 =B1  3%      -0.1        1.68 =B1  2%  perf-profile.children.cyc=
les-pp.d_alloc_parallel
      0.93 =B1  3%      -0.1        0.82 =B1  4%  perf-profile.children.cyc=
les-pp.perf_iterate_sb
      0.66 =B1  5%      -0.1        0.56 =B1  4%  perf-profile.children.cyc=
les-pp.__task_pid_nr_ns
      1.12 =B1  3%      -0.1        1.02 =B1  5%  perf-profile.children.cyc=
les-pp.__x64_sys_rt_sigreturn
      1.91 =B1  3%      -0.1        1.80 =B1  2%  perf-profile.children.cyc=
les-pp.__lookup_slow
      0.66 =B1  4%      -0.1        0.55 =B1  4%  perf-profile.children.cyc=
les-pp.syscall_enter_from_user_mode
      0.84 =B1  3%      -0.1        0.74 =B1  2%  perf-profile.children.cyc=
les-pp.obj_cgroup_charge
      0.56 =B1  4%      -0.1        0.46 =B1  8%  perf-profile.children.cyc=
les-pp.prepend_path
      0.56 =B1  6%      -0.1        0.46 =B1 18%  perf-profile.children.cyc=
les-pp.sighandler
      2.33            -0.1        2.24 =B1  2%  perf-profile.children.cycle=
s-pp.anon_vma_fork
      0.88 =B1  5%      -0.1        0.79 =B1  3%  perf-profile.children.cyc=
les-pp.__memcg_kmem_charge_page
      0.68 =B1  5%      -0.1        0.59 =B1  5%  perf-profile.children.cyc=
les-pp.send_signal
      0.31 =B1 13%      -0.1        0.22 =B1 12%  perf-profile.children.cyc=
les-pp.strnlen_user
      0.98 =B1  4%      -0.1        0.90 =B1  3%  perf-profile.children.cyc=
les-pp.__clear_user
      0.85 =B1  4%      -0.1        0.77        perf-profile.children.cycle=
s-pp.get_mem_cgroup_from_objcg
      0.80 =B1  5%      -0.1        0.72 =B1  4%  perf-profile.children.cyc=
les-pp.obj_cgroup_charge_pages
      0.64 =B1  4%      -0.1        0.56 =B1  3%  perf-profile.children.cyc=
les-pp.up_write
      0.66 =B1  3%      -0.1        0.58 =B1  5%  perf-profile.children.cyc=
les-pp.restore_sigcontext
      0.85 =B1  3%      -0.1        0.77 =B1  2%  perf-profile.children.cyc=
les-pp.lockdep_hardirqs_on
      0.73 =B1  4%      -0.1        0.65 =B1  4%  perf-profile.children.cyc=
les-pp.mem_cgroup_from_task
      0.79 =B1  4%      -0.1        0.72 =B1  4%  perf-profile.children.cyc=
les-pp.__x64_sys_mprotect
      0.79 =B1  4%      -0.1        0.72 =B1  4%  perf-profile.children.cyc=
les-pp.do_mprotect_pkey
      0.54 =B1  5%      -0.1        0.47 =B1  3%  perf-profile.children.cyc=
les-pp.lookup_fast
      0.80 =B1  4%      -0.1        0.73 =B1  7%  perf-profile.children.cyc=
les-pp.__x64_sys_link
      0.54 =B1  4%      -0.1        0.47 =B1  6%  perf-profile.children.cyc=
les-pp.try_to_unlazy
      0.50 =B1  6%      -0.1        0.43 =B1  7%  perf-profile.children.cyc=
les-pp.check_kill_permission
      1.08 =B1  2%      -0.1        1.01 =B1  3%  perf-profile.children.cyc=
les-pp.__split_vma
      0.64 =B1  5%      -0.1        0.57 =B1  4%  perf-profile.children.cyc=
les-pp.cgroup_throttle_swaprate
      0.50 =B1  4%      -0.1        0.43 =B1  3%  perf-profile.children.cyc=
les-pp.vma_merge
      0.65 =B1  2%      -0.1        0.59 =B1  6%  perf-profile.children.cyc=
les-pp.get_page_from_freelist
      0.43 =B1  5%      -0.1        0.37 =B1  6%  perf-profile.children.cyc=
les-pp.__legitimize_path
      0.36 =B1  2%      -0.1        0.29 =B1  3%  perf-profile.children.cyc=
les-pp._dl_addr
      0.55 =B1  4%      -0.1        0.49 =B1  5%  perf-profile.children.cyc=
les-pp.time
      0.74 =B1  3%      -0.1        0.68 =B1  4%  perf-profile.children.cyc=
les-pp.mprotect_fixup
      0.46 =B1  3%      -0.1        0.40 =B1  3%  perf-profile.children.cyc=
les-pp.__lock_task_sighand
      0.45 =B1  5%      -0.1        0.39 =B1  7%  perf-profile.children.cyc=
les-pp.copy_fpstate_to_sigframe
      0.25 =B1  6%      -0.1        0.19 =B1  8%  perf-profile.children.cyc=
les-pp.irqentry_exit_to_user_mode
      0.38 =B1  5%      -0.1        0.32 =B1  7%  perf-profile.children.cyc=
les-pp.do_wait
      0.43 =B1  2%      -0.1        0.37 =B1  4%  perf-profile.children.cyc=
les-pp.down_read
      0.39 =B1  5%      -0.1        0.34 =B1  7%  perf-profile.children.cyc=
les-pp.__do_sys_wait4
      0.39 =B1  5%      -0.1        0.34 =B1  7%  perf-profile.children.cyc=
les-pp.kernel_wait4
      0.41 =B1  6%      -0.1        0.35 =B1  6%  perf-profile.children.cyc=
les-pp.lockref_get_not_dead
      0.46 =B1  4%      -0.1        0.40 =B1  7%  perf-profile.children.cyc=
les-pp.trace_hardirqs_off_finish
      0.08 =B1 10%      -0.1        0.03 =B1 87%  perf-profile.children.cyc=
les-pp.load_balance
      0.36 =B1  4%      -0.0        0.32 =B1  4%  perf-profile.children.cyc=
les-pp.free_unref_page_list
      0.33 =B1  5%      -0.0        0.29 =B1  5%  perf-profile.children.cyc=
les-pp.__rcu_read_lock
      0.50 =B1  3%      -0.0        0.45 =B1  5%  perf-profile.children.cyc=
les-pp.preempt_count_add
      0.61 =B1  4%      -0.0        0.57 =B1  4%  perf-profile.children.cyc=
les-pp.lookup_open
      0.40 =B1  5%      -0.0        0.35 =B1  2%  perf-profile.children.cyc=
les-pp.__get_free_pages
      0.25 =B1  5%      -0.0        0.21 =B1 11%  perf-profile.children.cyc=
les-pp.audit_signal_info_syscall
      0.30 =B1  4%      -0.0        0.27 =B1  3%  perf-profile.children.cyc=
les-pp.tracer_hardirqs_on
      0.26 =B1  4%      -0.0        0.23 =B1  5%  perf-profile.children.cyc=
les-pp.kmem_cache_alloc_trace
      0.24 =B1  5%      -0.0        0.21 =B1  8%  perf-profile.children.cyc=
les-pp.wait4
      0.27 =B1  4%      -0.0        0.24 =B1  5%  perf-profile.children.cyc=
les-pp.__pud_alloc
      0.09 =B1 17%      -0.0        0.06 =B1 12%  perf-profile.children.cyc=
les-pp.do_task_dead
      0.25 =B1  4%      -0.0        0.22 =B1  9%  perf-profile.children.cyc=
les-pp.__cxa_atexit
      0.17 =B1  6%      -0.0        0.14 =B1 10%  perf-profile.children.cyc=
les-pp.__might_sleep
      0.09 =B1 11%      -0.0        0.07 =B1 13%  perf-profile.children.cyc=
les-pp.__x64_sys_unlink
      0.06 =B1  7%      +0.0        0.09 =B1 12%  perf-profile.children.cyc=
les-pp.delete_from_page_cache
      0.07 =B1 13%      +0.0        0.10 =B1 14%  perf-profile.children.cyc=
les-pp.truncate_inode_page
      0.08 =B1 12%      +0.0        0.11 =B1 22%  perf-profile.children.cyc=
les-pp.run_rebalance_domains
      0.04 =B1 71%      +0.0        0.07 =B1 15%  perf-profile.children.cyc=
les-pp.prandom_u32
      0.08 =B1 12%      +0.1        0.13 =B1 12%  perf-profile.children.cyc=
les-pp.update_rq_clock
      0.06 =B1 13%      +0.1        0.11 =B1  7%  perf-profile.children.cyc=
les-pp.enqueue_entity
      0.05 =B1 48%      +0.1        0.10 =B1 14%  perf-profile.children.cyc=
les-pp.lock_pin_lock
      0.00            +0.1        0.06 =B1 13%  perf-profile.children.cycle=
s-pp.select_idle_sibling
      0.00            +0.1        0.06 =B1  8%  perf-profile.children.cycle=
s-pp.unaccount_page_cache_page
      0.02 =B1141%      +0.1        0.07 =B1 15%  perf-profile.children.cyc=
les-pp.__delete_from_page_cache
      0.00            +0.1        0.06 =B1 12%  perf-profile.children.cycle=
s-pp.check_preempt_curr
      0.08 =B1 13%      +0.1        0.14 =B1 10%  perf-profile.children.cyc=
les-pp.cpuacct_charge
      0.12 =B1  7%      +0.1        0.18 =B1 13%  perf-profile.children.cyc=
les-pp.update_load_avg
      0.07 =B1 14%      +0.1        0.15 =B1  6%  perf-profile.children.cyc=
les-pp.enqueue_task_fair
      0.00            +0.1        0.08 =B1 12%  perf-profile.children.cycle=
s-pp.rcu_note_context_switch
      0.06 =B1 13%      +0.1        0.14 =B1 10%  perf-profile.children.cyc=
les-pp.preempt_schedule_common
      0.00            +0.1        0.09 =B1  8%  perf-profile.children.cycle=
s-pp.ttwu_do_wakeup
      0.06 =B1 11%      +0.1        0.15 =B1 10%  perf-profile.children.cyc=
les-pp.preempt_schedule_thunk
      0.00            +0.1        0.09 =B1 12%  perf-profile.children.cycle=
s-pp.put_prev_entity
      0.08 =B1 14%      +0.1        0.17 =B1  6%  perf-profile.children.cyc=
les-pp.irqentry_exit
      0.35 =B1  7%      +0.1        0.44 =B1  6%  perf-profile.children.cyc=
les-pp.lock_page_lruvec_irqsave
      0.58 =B1  4%      +0.1        0.67 =B1  7%  perf-profile.children.cyc=
les-pp._raw_spin_unlock_irq
      0.67 =B1  2%      +0.1        0.77 =B1  3%  perf-profile.children.cyc=
les-pp.lru_add_drain
      0.00            +0.1        0.11 =B1 11%  perf-profile.children.cycle=
s-pp.perf_tp_event
      0.00            +0.1        0.11 =B1 10%  perf-profile.children.cycle=
s-pp.preempt_schedule_irq
      0.22 =B1 26%      +0.1        0.33 =B1 21%  perf-profile.children.cyc=
les-pp.tick_nohz_next_event
      0.00            +0.1        0.11 =B1 10%  perf-profile.children.cycle=
s-pp.perf_trace_sched_wakeup_template
      0.13 =B1 10%      +0.1        0.24 =B1  9%  perf-profile.children.cyc=
les-pp.pick_next_task_fair
      0.44 =B1  4%      +0.1        0.55 =B1  3%  perf-profile.children.cyc=
les-pp.lru_add_drain_cpu
      0.28 =B1 26%      +0.1        0.41 =B1 21%  perf-profile.children.cyc=
les-pp.tick_nohz_get_sleep_length
      0.73 =B1  3%      +0.1        0.86        perf-profile.children.cycle=
s-pp.__pagevec_lru_add_fn
      0.26 =B1 10%      +0.1        0.40 =B1 10%  perf-profile.children.cyc=
les-pp.finish_task_switch
      0.02 =B1142%      +0.1        0.16 =B1  6%  perf-profile.children.cyc=
les-pp.ttwu_do_activate
      0.09 =B1 18%      +0.1        0.23 =B1  6%  perf-profile.children.cyc=
les-pp.select_task_rq_fair
      0.05 =B1 45%      +0.1        0.19 =B1  8%  perf-profile.children.cyc=
les-pp.mem_cgroup_charge_statistics
      0.00            +0.1        0.15 =B1 14%  perf-profile.children.cycle=
s-pp.asm_sysvec_reschedule_ipi
      0.09 =B1 15%      +0.1        0.24 =B1  8%  perf-profile.children.cyc=
les-pp.dequeue_entity
      0.52 =B1  4%      +0.2        0.68 =B1  3%  perf-profile.children.cyc=
les-pp.page_add_new_anon_rmap
      0.10 =B1 13%      +0.2        0.27 =B1  8%  perf-profile.children.cyc=
les-pp.dequeue_task_fair
      0.37 =B1 27%      +0.2        0.54 =B1 21%  perf-profile.children.cyc=
les-pp.menu_select
      0.00            +0.2        0.18 =B1  4%  perf-profile.children.cycle=
s-pp._find_next_bit
      0.26 =B1  7%      +0.2        0.45 =B1  5%  perf-profile.children.cyc=
les-pp.update_curr
      1.12 =B1  2%      +0.2        1.32        perf-profile.children.cycle=
s-pp.__pagevec_lru_add
      0.14 =B1 16%      +0.2        0.34 =B1 12%  perf-profile.children.cyc=
les-pp.schedule_idle
      0.64 =B1  4%      +0.5        1.09 =B1  4%  perf-profile.children.cyc=
les-pp._raw_spin_unlock_irqrestore
      0.28 =B1  7%      +0.5        0.78 =B1  3%  perf-profile.children.cyc=
les-pp.schedule
      1.06 =B1  2%      +0.6        1.61 =B1  3%  perf-profile.children.cyc=
les-pp.__mod_lruvec_page_state
      0.16 =B1  4%      +0.7        0.83 =B1  3%  perf-profile.children.cyc=
les-pp.try_to_wake_up
      0.59 =B1  8%      +0.9        1.45 =B1  3%  perf-profile.children.cyc=
les-pp.__schedule
      0.00            +0.9        0.90 =B1  2%  perf-profile.children.cycle=
s-pp.__queue_work
      0.00            +1.0        0.97 =B1  2%  perf-profile.children.cycle=
s-pp.queue_work_on
      0.37 =B1  4%      +1.1        1.46 =B1  3%  perf-profile.children.cyc=
les-pp.__mod_memcg_lruvec_state
      0.07 =B1 18%      +1.3        1.37 =B1  4%  perf-profile.children.cyc=
les-pp.cgroup_rstat_updated
      0.92 =B1  2%      +1.4        2.30 =B1  3%  perf-profile.children.cyc=
les-pp._raw_spin_lock_irqsave
      3.78 =B1  8%      +1.7        5.50 =B1  3%  perf-profile.children.cyc=
les-pp.intel_idle
      5.82 =B1  9%      +1.9        7.75 =B1  4%  perf-profile.children.cyc=
les-pp.cpuidle_enter
      5.81 =B1  9%      +1.9        7.75 =B1  4%  perf-profile.children.cyc=
les-pp.cpuidle_enter_state
      0.00            +2.0        1.96 =B1  2%  perf-profile.children.cycle=
s-pp.mem_cgroup_css_rstat_flush
      6.01 =B1  9%      +2.3        8.32 =B1  3%  perf-profile.children.cyc=
les-pp.start_secondary
      6.40 =B1  9%      +2.4        8.83 =B1  4%  perf-profile.children.cyc=
les-pp.secondary_startup_64_no_verify
      6.40 =B1  9%      +2.4        8.83 =B1  4%  perf-profile.children.cyc=
les-pp.cpu_startup_entry
      6.40 =B1  9%      +2.4        8.83 =B1  4%  perf-profile.children.cyc=
les-pp.do_idle
      0.00            +4.7        4.71 =B1  2%  perf-profile.children.cycle=
s-pp.cgroup_rstat_flush_locked
      0.00            +4.7        4.75 =B1  2%  perf-profile.children.cycle=
s-pp.cgroup_rstat_flush_irqsafe
      0.00            +5.0        4.97 =B1  2%  perf-profile.children.cycle=
s-pp.mem_cgroup_flush_stats
      0.59 =B1  8%      +5.2        5.83        perf-profile.children.cycle=
s-pp.process_one_work
      1.54 =B1  3%      +5.8        7.35        perf-profile.children.cycle=
s-pp.ret_from_fork
      1.43 =B1  3%      +5.8        7.24        perf-profile.children.cycle=
s-pp.kthread
      0.62 =B1  7%      +5.9        6.49        perf-profile.children.cycle=
s-pp.worker_thread
     10.94            -0.9       10.05        perf-profile.self.cycles-pp.c=
heck_preemption_disabled
      3.13 =B1  2%      -0.5        2.67 =B1  2%  perf-profile.self.cycles-=
pp.debug_lockdep_rcu_enabled
      3.82            -0.3        3.51        perf-profile.self.cycles-pp.m=
ark_lock
     11.35            -0.2       11.11        perf-profile.self.cycles-pp.l=
ock_is_held_type
      4.30            -0.2        4.13 =B1  2%  perf-profile.self.cycles-pp=
.lock_acquire
      2.89            -0.1        2.75        perf-profile.self.cycles-pp.r=
cu_is_watching
      2.00 =B1  2%      -0.1        1.90 =B1  3%  perf-profile.self.cycles-=
pp.rcu_read_lock_sched_held
      0.90            -0.1        0.80 =B1  3%  perf-profile.self.cycles-pp=
.lockdep_hardirqs_on_prepare
      0.60 =B1  6%      -0.1        0.53 =B1  4%  perf-profile.self.cycles-=
pp.lockdep_hardirqs_off
      0.93 =B1  2%      -0.1        0.86 =B1  3%  perf-profile.self.cycles-=
pp.mark_held_locks
      0.58 =B1  5%      -0.1        0.52 =B1  4%  perf-profile.self.cycles-=
pp.lockdep_hardirqs_on
      0.64            -0.1        0.58 =B1  4%  perf-profile.self.cycles-pp=
.___might_sleep
      0.33 =B1  3%      -0.1        0.27 =B1  4%  perf-profile.self.cycles-=
pp._dl_addr
      0.30 =B1  5%      -0.0        0.25 =B1  4%  perf-profile.self.cycles-=
pp.__rcu_read_lock
      0.30 =B1  7%      -0.0        0.26 =B1  8%  perf-profile.self.cycles-=
pp.next_uptodate_page
      0.07 =B1  5%      -0.0        0.04 =B1 63%  perf-profile.self.cycles-=
pp.down_write
      0.23 =B1  7%      -0.0        0.19 =B1  8%  perf-profile.self.cycles-=
pp.lock_page_memcg
      0.25 =B1  4%      -0.0        0.22 =B1  3%  perf-profile.self.cycles-=
pp.tracer_hardirqs_on
      0.16 =B1  7%      -0.0        0.13 =B1 12%  perf-profile.self.cycles-=
pp.page_remove_rmap
      0.10 =B1 10%      -0.0        0.08 =B1 15%  perf-profile.self.cycles-=
pp.trace_hardirqs_on_prepare
      0.06 =B1  7%      -0.0        0.05 =B1  9%  perf-profile.self.cycles-=
pp.__rb_insert_augmented
      0.10 =B1 11%      +0.0        0.12 =B1  6%  perf-profile.self.cycles-=
pp.__mod_memcg_lruvec_state
      0.00            +0.1        0.07 =B1 16%  perf-profile.self.cycles-pp=
.__schedule
      0.07 =B1 18%      +0.1        0.18 =B1 15%  perf-profile.self.cycles-=
pp.cgroup_rstat_updated
      0.00            +0.2        0.17 =B1  4%  perf-profile.self.cycles-pp=
._find_next_bit
      4.45            +0.2        4.67        perf-profile.self.cycles-pp.l=
ock_release
      0.00            +0.3        0.30 =B1  6%  perf-profile.self.cycles-pp=
.cgroup_rstat_flush_locked
      3.78 =B1  8%      +1.7        5.50 =B1  3%  perf-profile.self.cycles-=
pp.intel_idle
      0.00            +1.8        1.80 =B1  2%  perf-profile.self.cycles-pp=
.mem_cgroup_css_rstat_flush





Disclaimer:
Results have been estimated based on internal Intel analysis and are provid=
ed
for informational purposes only. Any difference in system hardware or softw=
are
design or configuration may affect actual performance.


---
0DAY/LKP+ Test Infrastructure                   Open Source Technology Cent=
er
https://lists.01.org/hyperkitty/list/lkp@lists.01.org       Intel Corporati=
on

Thanks,
Oliver Sang


--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-5.13.0-rc2-00028-gcda0d205259a"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 5.13.0-rc2 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="gcc-9 (Debian 9.3.0-22) 9.3.0"
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=90300
CONFIG_CLANG_VERSION=0
CONFIG_AS_IS_GNU=y
CONFIG_AS_VERSION=23502
CONFIG_LD_IS_BFD=y
CONFIG_LD_VERSION=23502
CONFIG_LLD_VERSION=0
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
CONFIG_HAVE_KERNEL_ZSTD=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
# CONFIG_KERNEL_ZSTD is not set
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
CONFIG_IRQ_SIM=y
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
CONFIG_HAVE_POSIX_CPU_TIMERS_TASK_WORK=y
CONFIG_POSIX_CPU_TIMERS_TASK_WORK=y

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
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_PREEMPTION=y
CONFIG_PREEMPT_DYNAMIC=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_SCHED_AVG_IRQ=y
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
CONFIG_PREEMPT_RCU=y
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
# CONFIG_CGROUP_MISC is not set
# CONFIG_CGROUP_DEBUG is not set
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_TIME_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_CHECKPOINT_RESTORE=y
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
CONFIG_RD_ZSTD=y
# CONFIG_BOOT_CONFIG is not set
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_LD_ORPHAN_WARN=y
CONFIG_SYSCTL=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
CONFIG_EXPERT=y
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
CONFIG_HAVE_ARCH_USERFAULTFD_MINOR=y
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
# CONFIG_BPF_PRELOAD is not set
CONFIG_USERFAULTFD=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_KCMP=y
CONFIG_RSEQ=y
# CONFIG_DEBUG_RSEQ is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
# CONFIG_PC104 is not set

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
# CONFIG_SLOB is not set
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
CONFIG_ARCH_HAS_FILTER_PGPROT=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
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
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
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
CONFIG_XEN_PVHVM_GUEST=y
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
# CONFIG_PROCESSOR_SELECT is not set
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

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=m
CONFIG_PERF_EVENTS_INTEL_RAPL=m
CONFIG_PERF_EVENTS_INTEL_CSTATE=m
# CONFIG_PERF_EVENTS_AMD_POWER is not set
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
# CONFIG_AMD_MEM_ENCRYPT is not set
CONFIG_NUMA=y
# CONFIG_AMD_NUMA is not set
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
CONFIG_X86_SGX=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_MIXED=y
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
CONFIG_ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_SUSPEND_SKIP_SYNC is not set
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
# CONFIG_DPM_WATCHDOG is not set
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
# CONFIG_ACPI_FPDT is not set
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_SLEEP=y
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
CONFIG_ACPI_PLATFORM_PROFILE=m
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
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
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
# CONFIG_ACPI_DPTF is not set
CONFIG_ACPI_WATCHDOG=y
CONFIG_ACPI_EXTLOG=m
CONFIG_ACPI_ADXL=y
# CONFIG_ACPI_CONFIGFS is not set
CONFIG_PMIC_OPREGION=y
CONFIG_X86_PM_TIMER=y

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
# CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
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
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_ISA_BUS is not set
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
CONFIG_KVM_XFER_TO_GUEST_WORK=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_WERROR is not set
CONFIG_KVM_INTEL=y
# CONFIG_X86_SGX_KVM is not set
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_XEN is not set
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
CONFIG_GENERIC_ENTRY=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
# CONFIG_STATIC_CALL_SELFTEST is not set
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
CONFIG_HAVE_ARCH_SECCOMP=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP=y
CONFIG_SECCOMP_FILTER=y
# CONFIG_SECCOMP_CACHE_DEBUG is not set
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR_STRONG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG_THIN=y
CONFIG_LTO_NONE=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_CONTEXT_TRACKING_OFFSTACK=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOVE_PUD=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_HAVE_SOFTIRQ_ON_OWN_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET=y
# CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT is not set
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
CONFIG_ARCH_USE_MEMREMAP_PROT=y
# CONFIG_LOCK_EVENT_COUNTS is not set
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
CONFIG_HAVE_STATIC_CALL=y
CONFIG_HAVE_STATIC_CALL_INLINE=y
CONFIG_HAVE_PREEMPT_DYNAMIC=y
CONFIG_ARCH_WANT_LD_ORPHAN_WARN=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HAS_ELFCORE_COMPAT=y

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
CONFIG_MODULE_COMPRESS_NONE=y
# CONFIG_MODULE_COMPRESS_GZIP is not set
# CONFIG_MODULE_COMPRESS_XZ is not set
# CONFIG_MODULE_COMPRESS_ZSTD is not set
# CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
CONFIG_MODPROBE_PATH="/sbin/modprobe"
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
CONFIG_UNINLINE_SPIN_UNLOCK=y
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
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_FAST_GUP=y
CONFIG_NUMA_KEEP_MEMINFO=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_MHP_MEMMAP_ON_MEMORY=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_PAGE_REPORTING=y
CONFIG_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_ARCH_ENABLE_THP_MIGRATION=y
CONFIG_CONTIG_ALLOC=y
CONFIG_PHYS_ADDR_T_64BIT=y
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
# CONFIG_CMA_SYSFS is not set
CONFIG_CMA_AREAS=19
# CONFIG_MEM_SOFT_DIRTY is not set
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
CONFIG_ZSMALLOC_STAT=y
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_PTE_DEVMAP=y
CONFIG_ZONE_DEVICE=y
CONFIG_DEV_PAGEMAP_OPS=y
CONFIG_HMM_MIRROR=y
CONFIG_DEVICE_PRIVATE=y
CONFIG_VMAP_PFN=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
# CONFIG_PERCPU_STATS is not set
CONFIG_GUP_TEST=y
# CONFIG_READ_ONLY_THP_FOR_FS is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_IO_MAPPING=y
# end of Memory Management options

CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y
CONFIG_NET_INGRESS=y
CONFIG_NET_EGRESS=y
CONFIG_NET_REDIRECT=y
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
# CONFIG_XFRM_USER_COMPAT is not set
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
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=y
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE_COMMON=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=y
CONFIG_NET_FOU=y
CONFIG_NET_FOU_IP_TUNNELS=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_ESP_OFFLOAD=m
# CONFIG_INET_ESPINTCP is not set
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=y
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
CONFIG_INET6_TUNNEL=y
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
CONFIG_IPV6_FOU=y
CONFIG_IPV6_FOU_TUNNEL=y
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_IPV6_SEG6_LWTUNNEL=y
# CONFIG_IPV6_SEG6_HMAC is not set
CONFIG_IPV6_SEG6_BPF=y
# CONFIG_IPV6_RPL_LWTUNNEL is not set
CONFIG_NETLABEL=y
CONFIG_MPTCP=y
CONFIG_INET_MPTCP_DIAG=m
CONFIG_MPTCP_IPV6=y
CONFIG_MPTCP_KUNIT_TEST=y
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
CONFIG_NF_LOG_SYSLOG=m
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
CONFIG_NFT_FLOW_OFFLOAD=m
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
# CONFIG_NFT_REJECT_NETDEV is not set
CONFIG_NF_FLOW_TABLE_INET=m
CONFIG_NF_FLOW_TABLE=m
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XTABLES_COMPAT=y

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
# CONFIG_IP_VS_TWOS is not set

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
CONFIG_NF_FLOW_TABLE_IPV4=m
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
CONFIG_NF_FLOW_TABLE_IPV6=m
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
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_MRP=y
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
# CONFIG_BRIDGE_MRP is not set
# CONFIG_BRIDGE_CFM is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
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
CONFIG_NET_SCH_ETF=m
# CONFIG_NET_SCH_TAPRIO is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=y
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
CONFIG_NET_SCH_INGRESS=y
CONFIG_NET_SCH_PLUG=m
CONFIG_NET_SCH_ETS=m
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
CONFIG_NET_EMATCH_CANID=m
CONFIG_NET_EMATCH_IPSET=m
CONFIG_NET_EMATCH_IPT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_SAMPLE=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
CONFIG_NET_ACT_MPLS=m
CONFIG_NET_ACT_VLAN=m
CONFIG_NET_ACT_BPF=m
CONFIG_NET_ACT_CONNMARK=m
CONFIG_NET_ACT_CTINFO=m
CONFIG_NET_ACT_SKBMOD=m
CONFIG_NET_ACT_IFE=m
CONFIG_NET_ACT_TUNNEL_KEY=m
CONFIG_NET_ACT_CT=m
# CONFIG_NET_ACT_GATE is not set
CONFIG_NET_IFE_SKBMARK=m
CONFIG_NET_IFE_SKBPRIO=m
CONFIG_NET_IFE_SKBTCINDEX=m
# CONFIG_NET_TC_SKB_EXT is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_GRE=m
CONFIG_OPENVSWITCH_VXLAN=m
CONFIG_OPENVSWITCH_GENEVE=m
CONFIG_VSOCKETS=m
CONFIG_VSOCKETS_DIAG=m
CONFIG_VSOCKETS_LOOPBACK=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS_COMMON=m
CONFIG_HYPERV_VSOCKETS=m
CONFIG_NETLINK_DIAG=m
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=m
CONFIG_MPLS_ROUTING=m
CONFIG_MPLS_IPTUNNEL=m
CONFIG_NET_NSH=y
# CONFIG_HSR is not set
CONFIG_NET_SWITCHDEV=y
CONFIG_NET_L3_MASTER_DEV=y
# CONFIG_QRTR is not set
# CONFIG_NET_NCSI is not set
CONFIG_PCPU_DEV_REFCNT=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_SOCK_RX_QUEUE_MAPPING=y
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
# CONFIG_CAN_ISOTP is not set

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
# CONFIG_CAN_MCP251XFD is not set
# end of CAN SPI interfaces

#
# CAN USB interfaces
#
# CONFIG_CAN_8DEV_USB is not set
# CONFIG_CAN_EMS_USB is not set
# CONFIG_CAN_ESD_USB2 is not set
# CONFIG_CAN_ETAS_ES58X is not set
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
# CONFIG_BT_AOSPEXT is not set
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
# CONFIG_BT_VIRTIO is not set
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
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
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
CONFIG_NFC=m
# CONFIG_NFC_DIGITAL is not set
CONFIG_NFC_NCI=m
# CONFIG_NFC_NCI_SPI is not set
# CONFIG_NFC_NCI_UART is not set
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_VIRTUAL_NCI=m
# CONFIG_NFC_FDP is not set
# CONFIG_NFC_PN533_USB is not set
# CONFIG_NFC_PN533_I2C is not set
# CONFIG_NFC_MRVL_USB is not set
# CONFIG_NFC_ST_NCI_I2C is not set
# CONFIG_NFC_ST_NCI_SPI is not set
# CONFIG_NFC_NXP_NCI is not set
# CONFIG_NFC_S3FWRN5_I2C is not set
# end of Near Field Communication (NFC) devices

CONFIG_PSAMPLE=m
CONFIG_NET_IFE=m
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_SOCK_VALIDATE_XMIT=y
CONFIG_NET_SELFTESTS=y
CONFIG_NET_SOCK_MSG=y
CONFIG_NET_DEVLINK=y
CONFIG_PAGE_POOL=y
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
# CONFIG_PCIE_BUS_TUNE_OFF is not set
CONFIG_PCIE_BUS_DEFAULT=y
# CONFIG_PCIE_BUS_SAFE is not set
# CONFIG_PCIE_BUS_PERFORMANCE is not set
# CONFIG_PCIE_BUS_PEER2PEER is not set
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

# CONFIG_CXL_BUS is not set
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
CONFIG_PM_QOS_KUNIT_TEST=y
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_DRIVER_PE_KUNIT_TEST=y
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
CONFIG_ZRAM=m
CONFIG_ZRAM_DEF_COMP_LZORLE=y
# CONFIG_ZRAM_DEF_COMP_LZO is not set
CONFIG_ZRAM_DEF_COMP="lzo-rle"
CONFIG_ZRAM_WRITEBACK=y
# CONFIG_ZRAM_MEMORY_TRACKING is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=m
CONFIG_VIRTIO_BLK=m
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
# CONFIG_NVME_TARGET_PASSTHRU is not set
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
# CONFIG_DW_XDATA_PCIE is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_XILINX_SDFEC is not set
CONFIG_MISC_RTSX=m
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
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_BCM_VK is not set
# CONFIG_MISC_ALCOR_PCI is not set
CONFIG_MISC_RTSX_PCI=m
# CONFIG_MISC_RTSX_USB is not set
# CONFIG_HABANA_AI is not set
# CONFIG_UACCE is not set
CONFIG_PVPANIC=y
# CONFIG_PVPANIC_MMIO is not set
# CONFIG_PVPANIC_PCI is not set
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
CONFIG_SCSI_SAS_ATA=y
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
CONFIG_SCSI_ISCI=m
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
# CONFIG_PATA_PLATFORM is not set
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
# CONFIG_DM_MULTIPATH_IOA is not set
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
CONFIG_DUMMY=y
# CONFIG_WIREGUARD is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_IFB=y
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_IPVLAN is not set
CONFIG_VXLAN=y
CONFIG_GENEVE=y
CONFIG_BAREUDP=m
# CONFIG_GTP is not set
CONFIG_MACSEC=y
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=m
# CONFIG_TUN_VNET_CROSS_LE is not set
CONFIG_VETH=m
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
CONFIG_NET_VRF=y
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
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BCMGENET is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
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
CONFIG_IGC=y
CONFIG_NET_VENDOR_MICROSOFT=y
# CONFIG_MICROSOFT_MANA is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_PRESTERA is not set
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
# CONFIG_YELLOWFIN is not set
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
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
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
# CONFIG_XILINX_EMACLITE is not set
# CONFIG_XILINX_AXI_EMAC is not set
# CONFIG_XILINX_LL_TEMAC is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y
# CONFIG_LED_TRIGGER_PHY is not set
# CONFIG_FIXED_PHY is not set

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
# CONFIG_ADIN_PHY is not set
# CONFIG_AQUANTIA_PHY is not set
# CONFIG_AX88796B_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM54140_PHY is not set
# CONFIG_BCM7XXX_PHY is not set
# CONFIG_BCM84881_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_CORTINA_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_INTEL_XWAY_PHY is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_MARVELL_10G_PHY is not set
# CONFIG_MARVELL_88X2222_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_MICROCHIP_PHY is not set
# CONFIG_MICROCHIP_T1_PHY is not set
# CONFIG_MICROSEMI_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_NXP_C45_TJA11XX_PHY is not set
# CONFIG_NXP_TJA11XX_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_REALTEK_PHY=y
# CONFIG_RENESAS_PHY is not set
# CONFIG_ROCKCHIP_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_TERANETICS_PHY is not set
# CONFIG_DP83822_PHY is not set
# CONFIG_DP83TC811_PHY is not set
# CONFIG_DP83848_PHY is not set
# CONFIG_DP83867_PHY is not set
# CONFIG_DP83869_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_XILINX_GMII2RGMII is not set
# CONFIG_MICREL_KS8995MA is not set
CONFIG_MDIO_DEVICE=y
CONFIG_MDIO_BUS=y
CONFIG_MDIO_DEVRES=y
# CONFIG_MDIO_BITBANG is not set
# CONFIG_MDIO_BCM_UNIMAC is not set
# CONFIG_MDIO_MVUSB is not set
# CONFIG_MDIO_MSCC_MIIM is not set
# CONFIG_MDIO_THUNDER is not set

#
# MDIO Multiplexers
#

#
# PCS device drivers
#
# CONFIG_PCS_XPCS is not set
# end of PCS device drivers

# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_USB_NET_DRIVERS=y
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_RTL8152=y
# CONFIG_USB_LAN78XX is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
# CONFIG_USB_NET_CDCETHER is not set
# CONFIG_USB_NET_CDC_EEM is not set
# CONFIG_USB_NET_CDC_NCM is not set
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
# CONFIG_USB_NET_CDC_MBIM is not set
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
# CONFIG_USB_NET_SMSC75XX is not set
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
# CONFIG_USB_NET_RNDIS_HOST is not set
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
# CONFIG_USB_HSO is not set
# CONFIG_USB_NET_INT51X1 is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
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
# CONFIG_ATH11K is not set
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
# CONFIG_MT7663S is not set
# CONFIG_MT7915E is not set
# CONFIG_MT7921E is not set
CONFIG_WLAN_VENDOR_MICROCHIP=y
# CONFIG_WILC1000_SDIO is not set
# CONFIG_WILC1000_SPI is not set
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
# CONFIG_WWAN is not set
CONFIG_XEN_NETDEV_FRONTEND=y
# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
# CONFIG_HYPERV_NET is not set
CONFIG_NETDEVSIM=m
CONFIG_NET_FAILOVER=m
# CONFIG_ISDN is not set
# CONFIG_NVM is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=m
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
# CONFIG_RMI4_F3A is not set
# CONFIG_RMI4_F54 is not set
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
# CONFIG_SERIAL_BCM63XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_FSL_LINFLEXUART is not set
# CONFIG_SERIAL_SPRD is not set
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK_GT=m
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
CONFIG_NOZOMI=m
# CONFIG_NULL_TTY is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
# CONFIG_SERIAL_DEV_BUS is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_VIRTIO_CONSOLE=m
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
# CONFIG_HW_RANDOM_BA431 is not set
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_XIPHERA is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_DEVMEM=y
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
# CONFIG_TCG_TIS_I2C_CR50 is not set
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
CONFIG_I2C_SMBUS=m
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
CONFIG_I2C_I801=m
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
# CONFIG_I2C_CP2615 is not set
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
# CONFIG_SPI_ALTERA_CORE is not set
# CONFIG_SPI_AXI_SPI_ENGINE is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_CADENCE is not set
# CONFIG_SPI_DESIGNWARE is not set
# CONFIG_SPI_NXP_FLEXSPI is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_LANTIQ_SSC is not set
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
CONFIG_SPI_DYNAMIC=y
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
# CONFIG_PTP_1588_CLOCK_OCP is not set
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
CONFIG_PINCTRL_INTEL=y
# CONFIG_PINCTRL_ALDERLAKE is not set
CONFIG_PINCTRL_BROXTON=m
CONFIG_PINCTRL_CANNONLAKE=m
CONFIG_PINCTRL_CEDARFORK=m
CONFIG_PINCTRL_DENVERTON=m
# CONFIG_PINCTRL_ELKHARTLAKE is not set
# CONFIG_PINCTRL_EMMITSBURG is not set
CONFIG_PINCTRL_GEMINILAKE=m
# CONFIG_PINCTRL_ICELAKE is not set
# CONFIG_PINCTRL_JASPERLAKE is not set
# CONFIG_PINCTRL_LAKEFIELD is not set
CONFIG_PINCTRL_LEWISBURG=m
CONFIG_PINCTRL_SUNRISEPOINT=m
# CONFIG_PINCTRL_TIGERLAKE is not set

#
# Renesas pinctrl drivers
#
# end of Renesas pinctrl drivers

CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_CDEV=y
CONFIG_GPIO_CDEV_V1=y
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
# CONFIG_GPIO_PCA9570 is not set
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

#
# Virtual GPIO drivers
#
# CONFIG_GPIO_AGGREGATOR is not set
CONFIG_GPIO_MOCKUP=m
# end of Virtual GPIO drivers

# CONFIG_W1 is not set
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
# CONFIG_CHARGER_LTC4162L is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24257 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ2515X is not set
# CONFIG_CHARGER_BQ25890 is not set
# CONFIG_CHARGER_BQ25980 is not set
# CONFIG_CHARGER_BQ256XX is not set
CONFIG_CHARGER_SMB347=m
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_BATTERY_GOLDFISH is not set
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
# CONFIG_SENSORS_AHT10 is not set
# CONFIG_SENSORS_AS370 is not set
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_AXI_FAN_CONTROL is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ASPEED is not set
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_CORSAIR_CPRO is not set
# CONFIG_SENSORS_CORSAIR_PSU is not set
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
# CONFIG_SENSORS_LTC2992 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX127 is not set
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
# CONFIG_SENSORS_TPS23861 is not set
# CONFIG_SENSORS_MR75203 is not set
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
# CONFIG_SENSORS_NZXT_KRAKEN2 is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ADM1266 is not set
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_BEL_PFE is not set
# CONFIG_SENSORS_BPA_RS600 is not set
# CONFIG_SENSORS_FSP_3Y is not set
# CONFIG_SENSORS_IBM_CFFPS is not set
# CONFIG_SENSORS_INSPUR_IPSPS is not set
# CONFIG_SENSORS_IR35221 is not set
# CONFIG_SENSORS_IR36021 is not set
# CONFIG_SENSORS_IR38064 is not set
# CONFIG_SENSORS_IRPS5401 is not set
# CONFIG_SENSORS_ISL68137 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_LTC3815 is not set
# CONFIG_SENSORS_MAX15301 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX16601 is not set
# CONFIG_SENSORS_MAX20730 is not set
# CONFIG_SENSORS_MAX20751 is not set
# CONFIG_SENSORS_MAX31785 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_MP2975 is not set
# CONFIG_SENSORS_PM6764TR is not set
# CONFIG_SENSORS_PXE1610 is not set
# CONFIG_SENSORS_Q54SJ108A2 is not set
# CONFIG_SENSORS_STPDDC60 is not set
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_TPS53679 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_XDPE122 is not set
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_SBTSI is not set
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
# CONFIG_THERMAL_NETLINK is not set
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
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_PKG_TEMP_THERMAL=m
CONFIG_INTEL_SOC_DTS_IOSF_CORE=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
CONFIG_INT340X_THERMAL=m
CONFIG_ACPI_THERMAL_REL=m
# CONFIG_INT3406_THERMAL is not set
CONFIG_PROC_THERMAL_MMIO_RAPL=m
# end of ACPI INT340X thermal drivers

CONFIG_INTEL_PCH_THERMAL=m
# CONFIG_INTEL_TCC_COOLING is not set
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
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=m
# CONFIG_INTEL_SOC_PMIC_CHTDC_TI is not set
CONFIG_MFD_INTEL_LPSS=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
CONFIG_MFD_INTEL_LPSS_PCI=y
# CONFIG_MFD_INTEL_PMC_BXT is not set
# CONFIG_MFD_INTEL_PMT is not set
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
# CONFIG_MFD_ATC260X_I2C is not set
# CONFIG_MFD_INTEL_M10_BMC is not set
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
CONFIG_IR_SHARP_DECODER=m
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
CONFIG_RC_LOOPBACK=m
CONFIG_IR_SERIAL=m
CONFIG_IR_SERIAL_TRANSMITTER=y
CONFIG_IR_SIR=m
# CONFIG_RC_XBOX_DVD is not set
# CONFIG_IR_TOY is not set
CONFIG_MEDIA_CEC_SUPPORT=y
# CONFIG_CEC_CH7322 is not set
# CONFIG_CEC_GPIO is not set
# CONFIG_CEC_SECO is not set
# CONFIG_USB_PULSE8_CEC is not set
# CONFIG_USB_RAINSHADOW_CEC is not set
CONFIG_MEDIA_SUPPORT=m
# CONFIG_MEDIA_SUPPORT_FILTER is not set
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set

#
# Media device types
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_SDR_SUPPORT=y
CONFIG_MEDIA_PLATFORM_SUPPORT=y
CONFIG_MEDIA_TEST_SUPPORT=y
# end of Media device types

#
# Media core support
#
CONFIG_VIDEO_DEV=m
CONFIG_MEDIA_CONTROLLER=y
CONFIG_DVB_CORE=m
# end of Media core support

#
# Video4Linux options
#
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L2_I2C=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
# end of Video4Linux options

#
# Media controller options
#
# CONFIG_MEDIA_CONTROLLER_DVB is not set
# end of Media controller options

#
# Digital TV options
#
# CONFIG_DVB_MMAP is not set
CONFIG_DVB_NET=y
CONFIG_DVB_MAX_ADAPTERS=16
CONFIG_DVB_DYNAMIC_MINORS=y
# CONFIG_DVB_DEMUX_SECTION_LOSS_LOG is not set
# CONFIG_DVB_ULE_DEBUG is not set
# end of Digital TV options

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_SI470X is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_USB_MR800 is not set
# CONFIG_USB_DSBR is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_SHARK is not set
# CONFIG_RADIO_SHARK2 is not set
# CONFIG_USB_KEENE is not set
# CONFIG_USB_RAREMONO is not set
# CONFIG_USB_MA901 is not set
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_RADIO_SAA7706H is not set
# CONFIG_RADIO_TEF6862 is not set
# CONFIG_RADIO_WL1273 is not set
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_V4L2=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_DVB_PLATFORM_DRIVERS is not set
# CONFIG_SDR_PLATFORM_DRIVERS is not set

#
# MMC/SDIO DVB adapters
#
# CONFIG_SMS_SDIO_DRV is not set
# CONFIG_V4L_TEST_DRIVERS is not set
# CONFIG_DVB_TEST_DRIVERS is not set

#
# FireWire (IEEE 1394) Adapters
#
# CONFIG_DVB_FIREDTV is not set
# end of Media drivers

#
# Media ancillary drivers
#
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
# CONFIG_VIDEO_TDA7432 is not set
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TEA6415C is not set
# CONFIG_VIDEO_TEA6420 is not set
# CONFIG_VIDEO_MSP3400 is not set
# CONFIG_VIDEO_CS3308 is not set
# CONFIG_VIDEO_CS5345 is not set
# CONFIG_VIDEO_CS53L32A is not set
# CONFIG_VIDEO_TLV320AIC23B is not set
# CONFIG_VIDEO_UDA1342 is not set
# CONFIG_VIDEO_WM8775 is not set
# CONFIG_VIDEO_WM8739 is not set
# CONFIG_VIDEO_VP27SMPX is not set
# CONFIG_VIDEO_SONY_BTF_MPX is not set
# end of Audio decoders, processors and mixers

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set
# end of RDS decoders

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
# CONFIG_VIDEO_ADV7183 is not set
# CONFIG_VIDEO_ADV7604 is not set
# CONFIG_VIDEO_ADV7842 is not set
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
# CONFIG_VIDEO_ML86V7667 is not set
# CONFIG_VIDEO_SAA7110 is not set
# CONFIG_VIDEO_SAA711X is not set
# CONFIG_VIDEO_TC358743 is not set
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_TVP7002 is not set
# CONFIG_VIDEO_TW2804 is not set
# CONFIG_VIDEO_TW9903 is not set
# CONFIG_VIDEO_TW9906 is not set
# CONFIG_VIDEO_TW9910 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
# CONFIG_VIDEO_CX25840 is not set
# end of Video decoders

#
# Video encoders
#
# CONFIG_VIDEO_SAA7127 is not set
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_ADV7170 is not set
# CONFIG_VIDEO_ADV7175 is not set
# CONFIG_VIDEO_ADV7343 is not set
# CONFIG_VIDEO_ADV7393 is not set
# CONFIG_VIDEO_ADV7511 is not set
# CONFIG_VIDEO_AD9389B is not set
# CONFIG_VIDEO_AK881X is not set
# CONFIG_VIDEO_THS8200 is not set
# end of Video encoders

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
# CONFIG_VIDEO_UPD64083 is not set
# end of Video improvement chips

#
# Audio/Video compression chips
#
# CONFIG_VIDEO_SAA6752HS is not set
# end of Audio/Video compression chips

#
# SDR tuner chips
#
# CONFIG_SDR_MAX2175 is not set
# end of SDR tuner chips

#
# Miscellaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
# CONFIG_VIDEO_M52790 is not set
# CONFIG_VIDEO_I2C is not set
# CONFIG_VIDEO_ST_MIPID02 is not set
# end of Miscellaneous helper chips

#
# Camera sensor devices
#
# CONFIG_VIDEO_HI556 is not set
# CONFIG_VIDEO_IMX214 is not set
# CONFIG_VIDEO_IMX219 is not set
# CONFIG_VIDEO_IMX258 is not set
# CONFIG_VIDEO_IMX274 is not set
# CONFIG_VIDEO_IMX290 is not set
# CONFIG_VIDEO_IMX319 is not set
# CONFIG_VIDEO_IMX355 is not set
# CONFIG_VIDEO_OV02A10 is not set
# CONFIG_VIDEO_OV2640 is not set
# CONFIG_VIDEO_OV2659 is not set
# CONFIG_VIDEO_OV2680 is not set
# CONFIG_VIDEO_OV2685 is not set
# CONFIG_VIDEO_OV2740 is not set
# CONFIG_VIDEO_OV5647 is not set
# CONFIG_VIDEO_OV5648 is not set
# CONFIG_VIDEO_OV6650 is not set
# CONFIG_VIDEO_OV5670 is not set
# CONFIG_VIDEO_OV5675 is not set
# CONFIG_VIDEO_OV5695 is not set
# CONFIG_VIDEO_OV7251 is not set
# CONFIG_VIDEO_OV772X is not set
# CONFIG_VIDEO_OV7640 is not set
# CONFIG_VIDEO_OV7670 is not set
# CONFIG_VIDEO_OV7740 is not set
# CONFIG_VIDEO_OV8856 is not set
# CONFIG_VIDEO_OV8865 is not set
# CONFIG_VIDEO_OV9640 is not set
# CONFIG_VIDEO_OV9650 is not set
# CONFIG_VIDEO_OV9734 is not set
# CONFIG_VIDEO_OV13858 is not set
# CONFIG_VIDEO_VS6624 is not set
# CONFIG_VIDEO_MT9M001 is not set
# CONFIG_VIDEO_MT9M032 is not set
# CONFIG_VIDEO_MT9M111 is not set
# CONFIG_VIDEO_MT9P031 is not set
# CONFIG_VIDEO_MT9T001 is not set
# CONFIG_VIDEO_MT9T112 is not set
# CONFIG_VIDEO_MT9V011 is not set
# CONFIG_VIDEO_MT9V032 is not set
# CONFIG_VIDEO_MT9V111 is not set
# CONFIG_VIDEO_SR030PC30 is not set
# CONFIG_VIDEO_NOON010PC30 is not set
# CONFIG_VIDEO_M5MOLS is not set
# CONFIG_VIDEO_RDACM20 is not set
# CONFIG_VIDEO_RDACM21 is not set
# CONFIG_VIDEO_RJ54N1 is not set
# CONFIG_VIDEO_S5K6AA is not set
# CONFIG_VIDEO_S5K6A3 is not set
# CONFIG_VIDEO_S5K4ECGX is not set
# CONFIG_VIDEO_S5K5BAF is not set
# CONFIG_VIDEO_CCS is not set
# CONFIG_VIDEO_ET8EK8 is not set
# CONFIG_VIDEO_S5C73M3 is not set
# end of Camera sensor devices

#
# Lens drivers
#
# CONFIG_VIDEO_AD5820 is not set
# CONFIG_VIDEO_AK7375 is not set
# CONFIG_VIDEO_DW9714 is not set
# CONFIG_VIDEO_DW9768 is not set
# CONFIG_VIDEO_DW9807_VCM is not set
# end of Lens drivers

#
# Flash devices
#
# CONFIG_VIDEO_ADP1653 is not set
# CONFIG_VIDEO_LM3560 is not set
# CONFIG_VIDEO_LM3646 is not set
# end of Flash devices

#
# SPI helper chips
#
# CONFIG_VIDEO_GS1662 is not set
# end of SPI helper chips

#
# Media SPI Adapters
#
CONFIG_CXD2880_SPI_DRV=m
# end of Media SPI Adapters

CONFIG_MEDIA_TUNER=m

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA18250=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MSI001=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=m
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=m
CONFIG_MEDIA_TUNER_M88RS6000T=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_SI2157=m
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m
CONFIG_MEDIA_TUNER_MXL301RF=m
CONFIG_MEDIA_TUNER_QM1D1C0042=m
CONFIG_MEDIA_TUNER_QM1D1B0004=m
# end of Customize TV tuners

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
CONFIG_DVB_STV0910=m
CONFIG_DVB_STV6110x=m
CONFIG_DVB_STV6111=m
CONFIG_DVB_MXL5XX=m
CONFIG_DVB_M88DS3103=m

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
CONFIG_DVB_TDA18271C2DD=m
CONFIG_DVB_SI2165=m
CONFIG_DVB_MN88472=m
CONFIG_DVB_MN88473=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_CX24117=m
CONFIG_DVB_CX24120=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_TS2020=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m
CONFIG_DVB_TDA10071=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_S5H1432=m
CONFIG_DVB_DRXD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_DIB9000=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
CONFIG_DVB_STV0367=m
CONFIG_DVB_CXD2820R=m
CONFIG_DVB_CXD2841ER=m
CONFIG_DVB_RTL2830=m
CONFIG_DVB_RTL2832=m
CONFIG_DVB_RTL2832_SDR=m
CONFIG_DVB_SI2168=m
CONFIG_DVB_ZD1301_DEMOD=m
CONFIG_DVB_CXD2880=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_LGDT3306A=m
CONFIG_DVB_LG2160=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
CONFIG_DVB_AU8522_V4L=m
CONFIG_DVB_S5H1411=m
CONFIG_DVB_MXL692=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
CONFIG_DVB_DIB8000=m
CONFIG_DVB_MB86A20S=m

#
# ISDB-S (satellite) & ISDB-T (terrestrial) frontends
#
CONFIG_DVB_TC90522=m
CONFIG_DVB_MN88443X=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_DRX39XYJ=m
CONFIG_DVB_LNBH25=m
CONFIG_DVB_LNBH29=m
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_A8293=m
CONFIG_DVB_LGS8GL5=m
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=m
CONFIG_DVB_M88RS2000=m
CONFIG_DVB_AF9033=m
CONFIG_DVB_HORUS3A=m
CONFIG_DVB_ASCOT2E=m
CONFIG_DVB_HELENE=m

#
# Common Interface (EN50221) controller drivers
#
CONFIG_DVB_CXD2099=m
CONFIG_DVB_SP2=m
# end of Customise DVB Frontends

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set
# end of Media ancillary drivers

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_INTEL_GTT=m
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_MIPI_DSI=y
CONFIG_DRM_DP_AUX_CHARDEV=y
# CONFIG_DRM_DEBUG_MM is not set
CONFIG_DRM_DEBUG_SELFTEST=m
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_DEBUG_DP_MST_TOPOLOGY_REFS is not set
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
# CONFIG_DRM_FBDEV_LEAK_PHYS_SMEM is not set
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
# CONFIG_DRM_DP_CEC is not set
CONFIG_DRM_TTM=m
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

#
# drm/i915 Debugging
#
# CONFIG_DRM_I915_WERROR is not set
# CONFIG_DRM_I915_DEBUG is not set
# CONFIG_DRM_I915_DEBUG_MMIO is not set
# CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS is not set
# CONFIG_DRM_I915_SW_FENCE_CHECK_DAG is not set
# CONFIG_DRM_I915_DEBUG_GUC is not set
# CONFIG_DRM_I915_SELFTEST is not set
# CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS is not set
# CONFIG_DRM_I915_DEBUG_VBLANK_EVADE is not set
# CONFIG_DRM_I915_DEBUG_RUNTIME_PM is not set
# end of drm/i915 Debugging

#
# drm/i915 Profile Guided Optimisation
#
CONFIG_DRM_I915_REQUEST_TIMEOUT=20000
CONFIG_DRM_I915_FENCE_TIMEOUT=10000
CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND=250
CONFIG_DRM_I915_HEARTBEAT_INTERVAL=2500
CONFIG_DRM_I915_PREEMPT_TIMEOUT=640
CONFIG_DRM_I915_MAX_REQUEST_BUSYWAIT=8000
CONFIG_DRM_I915_STOP_TIMEOUT=100
CONFIG_DRM_I915_TIMESLICE_DURATION=1
# end of drm/i915 Profile Guided Optimisation

CONFIG_DRM_VGEM=y
# CONFIG_DRM_VKMS is not set
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=m
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
# CONFIG_DRM_XEN_FRONTEND is not set
# CONFIG_DRM_VBOXVIDEO is not set
# CONFIG_DRM_GUD is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_EXPORT_FOR_TESTS=y
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y
CONFIG_DRM_LIB_RANDOM=y

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
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
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
# CONFIG_BACKLIGHT_KTD253 is not set
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
# CONFIG_HID_FT260 is not set
CONFIG_HID_GEMBIRD=m
CONFIG_HID_GFRM=m
# CONFIG_HID_GLORIOUS is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_VIVALDI is not set
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
# CONFIG_HID_PLAYSTATION is not set
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
# CONFIG_I2C_HID_ACPI is not set
# end of I2C HID support

#
# Intel ISH HID support
#
CONFIG_INTEL_ISH_HID=m
# CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER is not set
# end of Intel ISH HID support

#
# AMD SFH HID Support
#
# CONFIG_AMD_SFH_HID is not set
# end of AMD SFH HID Support
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
# CONFIG_USB_FEW_INIT_RETRIES is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_PRODUCTLIST is not set
# CONFIG_USB_OTG_DISABLE_EXTERNAL_HUB is not set
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
# CONFIG_USB_CDNS_SUPPORT is not set
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
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_XSENS_MT is not set
# CONFIG_USB_SERIAL_WISHBONE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_UPD78F0730 is not set
# CONFIG_USB_SERIAL_XR is not set
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
# CONFIG_TYPEC_STUSB160X is not set

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
# CONFIG_LEDS_CLASS_MULTICOLOR is not set
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
# CONFIG_LEDS_LP50XX is not set
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
# Flash and Torch LED drivers
#

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
# CONFIG_LEDS_TRIGGER_TTY is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ON_DEMAND_PAGING=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS=y
CONFIG_INFINIBAND_VIRT_DMA=y
# CONFIG_INFINIBAND_MTHCA is not set
# CONFIG_INFINIBAND_EFA is not set
# CONFIG_INFINIBAND_I40IW is not set
# CONFIG_MLX4_INFINIBAND is not set
# CONFIG_INFINIBAND_OCRDMA is not set
# CONFIG_INFINIBAND_USNIC is not set
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
# CONFIG_EDAC_IGEN6 is not set
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
# CONFIG_RTC_DRV_RV3032 is not set
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
# CONFIG_RTC_DRV_RX6110 is not set

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
# CONFIG_RTC_DRV_GOLDFISH is not set
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
# CONFIG_XILINX_ZYNQMP_DPDMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y
# CONFIG_DW_EDMA is not set
# CONFIG_DW_EDMA_PCIE is not set
CONFIG_HSU_DMA=y
# CONFIG_SF_PDMA is not set
# CONFIG_INTEL_LDMA is not set

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
CONFIG_SW_SYNC=y
# CONFIG_UDMABUF is not set
# CONFIG_DMABUF_MOVE_NOTIFY is not set
# CONFIG_DMABUF_DEBUG is not set
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
CONFIG_IRQ_BYPASS_MANAGER=y
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_PCI_LIB=y
CONFIG_VIRTIO_MENU=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_LEGACY=y
# CONFIG_VIRTIO_PMEM is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MEM=m
CONFIG_VIRTIO_INPUT=m
# CONFIG_VIRTIO_MMIO is not set
CONFIG_VIRTIO_DMA_SHARED_BUFFER=m
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
# CONFIG_XEN_UNPOPULATED_ALLOC is not set
# end of Xen driver support

# CONFIG_GREYBUS is not set
# CONFIG_COMEDI is not set
CONFIG_STAGING=y
# CONFIG_PRISM2_USB is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTLLIB is not set
# CONFIG_RTL8723BS is not set
# CONFIG_R8712U is not set
# CONFIG_R8188EU is not set
# CONFIG_RTS5208 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_FB_SM750 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ASHMEM is not set
# end of Android

# CONFIG_LTE_GDM724X is not set
# CONFIG_FIREWIRE_SERIAL is not set
# CONFIG_GS_FPGABOOT is not set
# CONFIG_UNISYSSPAR is not set
# CONFIG_FB_TFT is not set
# CONFIG_KS7010 is not set
# CONFIG_PI433 is not set
# CONFIG_FIELDBUS_DEV is not set
# CONFIG_KPC2000 is not set
# CONFIG_QLGE is not set
# CONFIG_WFX is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACPI_WMI=m
CONFIG_WMI_BMOF=m
# CONFIG_HUAWEI_WMI is not set
# CONFIG_UV_SYSFS is not set
# CONFIG_INTEL_WMI_SBL_FW_UPDATE is not set
CONFIG_INTEL_WMI_THUNDERBOLT=m
CONFIG_MXM_WMI=m
# CONFIG_PEAQ_WMI is not set
# CONFIG_XIAOMI_WMI is not set
# CONFIG_GIGABYTE_WMI is not set
CONFIG_ACERHDF=m
# CONFIG_ACER_WIRELESS is not set
CONFIG_ACER_WMI=m
# CONFIG_AMD_PMC is not set
# CONFIG_ADV_SWBUTTON is not set
CONFIG_APPLE_GMUX=m
CONFIG_ASUS_LAPTOP=m
# CONFIG_ASUS_WIRELESS is not set
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
CONFIG_EEEPC_LAPTOP=m
CONFIG_EEEPC_WMI=m
# CONFIG_X86_PLATFORM_DRIVERS_DELL is not set
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
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_MELLANOX_PLATFORM=y
CONFIG_MLXREG_HOTPLUG=m
# CONFIG_MLXREG_IO is not set
CONFIG_SURFACE_PLATFORMS=y
# CONFIG_SURFACE3_WMI is not set
# CONFIG_SURFACE_3_POWER_OPREGION is not set
# CONFIG_SURFACE_GPE is not set
# CONFIG_SURFACE_HOTPLUG is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
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
# CONFIG_XILINX_VCU is not set
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
# CONFIG_AMD_IOMMU is not set
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
# Enable LiteX SoC Builder specific drivers
#
# end of Enable LiteX SoC Builder specific drivers

#
# Qualcomm SoC drivers
#
# end of Qualcomm SoC drivers

# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
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
# CONFIG_NTB_EPF is not set
# CONFIG_NTB_SWITCHTEC is not set
# CONFIG_NTB_PINGPONG is not set
# CONFIG_NTB_TOOL is not set
# CONFIG_NTB_PERF is not set
# CONFIG_NTB_TRANSPORT is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_DEBUG is not set
# CONFIG_PWM_DWC is not set
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
# CONFIG_USB_LGM_PHY is not set
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_INTEL_LGM_EMMC is not set
# end of PHY Subsystem

CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL_CORE=m
CONFIG_INTEL_RAPL=m
# CONFIG_IDLE_INJECT is not set
# CONFIG_DTPM is not set
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
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
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
# CONFIG_NVMEM_RMEM is not set

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
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_EXT4_KUNIT_TESTS=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_SUPPORT_V4=y
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
CONFIG_NETFS_SUPPORT=m
# CONFIG_NETFS_STATS is not set
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
# CONFIG_TMPFS_INODE64 is not set
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
CONFIG_PSTORE_DEFAULT_KMSG_BYTES=10240
CONFIG_PSTORE_DEFLATE_COMPRESS=y
# CONFIG_PSTORE_LZO_COMPRESS is not set
# CONFIG_PSTORE_LZ4_COMPRESS is not set
# CONFIG_PSTORE_LZ4HC_COMPRESS is not set
# CONFIG_PSTORE_842_COMPRESS is not set
# CONFIG_PSTORE_ZSTD_COMPRESS is not set
CONFIG_PSTORE_COMPRESS=y
CONFIG_PSTORE_DEFLATE_COMPRESS_DEFAULT=y
CONFIG_PSTORE_COMPRESS_DEFAULT="deflate"
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_PMSG=y
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
# CONFIG_NFS_V4_2_READ_PLUS is not set
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
CONFIG_NFS_V4_2_SSC_HELPER=y
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
# CONFIG_CIFS_SWN_UPCALL is not set
# CONFIG_CIFS_SMB_DIRECT is not set
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set
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
# CONFIG_HARDENED_USERCOPY_PAGESPAN is not set
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
CONFIG_SECURITY_APPARMOR_KUNIT_TEST=y
# CONFIG_SECURITY_LOADPIN is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_SAFESETID is not set
# CONFIG_SECURITY_LOCKDOWN_LSM is not set
# CONFIG_SECURITY_LANDLOCK is not set
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
CONFIG_IMA_DEFAULT_HASH="sha1"
CONFIG_IMA_WRITE_POLICY=y
CONFIG_IMA_READ_POLICY=y
CONFIG_IMA_APPRAISE=y
CONFIG_IMA_ARCH_POLICY=y
# CONFIG_IMA_APPRAISE_BUILD_POLICY is not set
CONFIG_IMA_APPRAISE_BOOTPARAM=y
# CONFIG_IMA_APPRAISE_MODSIG is not set
CONFIG_IMA_TRUSTED_KEYRING=y
# CONFIG_IMA_BLACKLIST_KEYRING is not set
# CONFIG_IMA_LOAD_X509 is not set
CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS=y
CONFIG_IMA_QUEUE_EARLY_BOOT_KEYS=y
CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT=y
CONFIG_EVM=y
CONFIG_EVM_ATTR_FSUUID=y
# CONFIG_EVM_ADD_XATTRS is not set
# CONFIG_EVM_LOAD_X509 is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_LSM="landlock,lockdown,yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor,bpf"

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

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=m
CONFIG_CRYPTO_ECC=m
CONFIG_CRYPTO_ECDH=m
# CONFIG_CRYPTO_ECDSA is not set
# CONFIG_CRYPTO_ECRDSA is not set
# CONFIG_CRYPTO_SM2 is not set
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
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_OFB is not set
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m
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
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_SHA3=m
# CONFIG_CRYPTO_SM3 is not set
# CONFIG_CRYPTO_STREEBOG is not set
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
# CONFIG_CRYPTO_USER_API_RNG_CAVP is not set
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE=y
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
CONFIG_CRYPTO_DEV_CCP_DD=m
CONFIG_CRYPTO_DEV_SP_CCP=y
CONFIG_CRYPTO_DEV_CCP_CRYPTO=m
CONFIG_CRYPTO_DEV_SP_PSP=y
# CONFIG_CRYPTO_DEV_CCP_DEBUGFS is not set
CONFIG_CRYPTO_DEV_QAT=m
CONFIG_CRYPTO_DEV_QAT_DH895xCC=m
CONFIG_CRYPTO_DEV_QAT_C3XXX=m
CONFIG_CRYPTO_DEV_QAT_C62X=m
# CONFIG_CRYPTO_DEV_QAT_4XXX is not set
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
# CONFIG_SYSTEM_REVOCATION_LIST is not set
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
CONFIG_PRIME_NUMBERS=m
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
CONFIG_ZSTD_DECOMPRESS=y
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
CONFIG_DECOMPRESS_ZSTD=y
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
CONFIG_DMA_OPS=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_SWIOTLB=y
CONFIG_DMA_CMA=y
# CONFIG_DMA_PERNUMA_CMA is not set

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
CONFIG_DMA_MAP_BENCHMARK=y
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
CONFIG_ARCH_HAS_COPY_MC=y
CONFIG_ARCH_STACKWALK=y
CONFIG_SBITMAP=y
# CONFIG_STRING_SELFTEST is not set
# end of Library routines

CONFIG_ASN1_ENCODER=y

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_PRINTK_CALLER=y
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
# CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT is not set
CONFIG_DEBUG_INFO_DWARF4=y
# CONFIG_DEBUG_INFO_DWARF5 is not set
CONFIG_PAHOLE_HAS_SPLIT_BTF=y
# CONFIG_GDB_SCRIPTS is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_HEADERS_INSTALL is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
# CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_32B is not set
CONFIG_STACK_VALIDATION=y
# CONFIG_VMLINUX_MAP is not set
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
CONFIG_DEBUG_FS_ALLOW_ALL=y
# CONFIG_DEBUG_FS_DISALLOW_MOUNT is not set
# CONFIG_DEBUG_FS_ALLOW_NONE is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
# CONFIG_UBSAN is not set
CONFIG_HAVE_ARCH_KCSAN=y
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
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
# CONFIG_KASAN is not set
CONFIG_HAVE_ARCH_KFENCE=y
# CONFIG_KFENCE is not set
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
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=480
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_WQ_WATCHDOG=y
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
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RAW_LOCK_NESTING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_RWSEMS=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_LOCKDEP=y
CONFIG_LOCKDEP_BITS=15
CONFIG_LOCKDEP_CHAINS_BITS=16
CONFIG_LOCKDEP_STACK_TRACE_BITS=19
CONFIG_LOCKDEP_STACK_TRACE_HASH_BITS=14
CONFIG_LOCKDEP_CIRCULAR_QUEUE_BITS=12
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=m
CONFIG_WW_MUTEX_SELFTEST=m
# CONFIG_SCF_TORTURE_TEST is not set
# CONFIG_CSD_LOCK_WAIT_DEBUG is not set
# end of Lock Debugging (spinlocks, mutexes, etc...)

CONFIG_TRACE_IRQFLAGS=y
CONFIG_TRACE_IRQFLAGS_NMI=y
# CONFIG_DEBUG_IRQFLAGS is not set
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set

#
# Debug kernel data structures
#
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PLIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_BUG_ON_DATA_CORRUPTION=y
# end of Debug kernel data structures

# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_TORTURE_TEST=m
CONFIG_RCU_SCALE_TEST=m
CONFIG_RCU_TORTURE_TEST=m
# CONFIG_RCU_REF_SCALE_TEST is not set
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
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_OBJTOOL_MCOUNT=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_PREEMPTIRQ_TRACEPOINTS=y
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
CONFIG_TRACE_PREEMPT_TOGGLE=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_PREEMPT_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_HWLAT_TRACER=y
# CONFIG_MMIOTRACE is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
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
CONFIG_FTRACE_MCOUNT_USE_CC=y
CONFIG_TRACING_MAP=y
CONFIG_SYNTH_EVENTS=y
CONFIG_HIST_TRIGGERS=y
# CONFIG_TRACE_EVENT_INJECT is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_TRACE_EVAL_MAP_FILE is not set
# CONFIG_FTRACE_RECORD_RECURSION is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_VALIDATE_TIME_DELTAS is not set
CONFIG_PREEMPTIRQ_DELAY_TEST=m
# CONFIG_SYNTH_EVENT_GEN_TEST is not set
# CONFIG_KPROBE_EVENT_GEN_TEST is not set
# CONFIG_HIST_TRIGGERS_DEBUG is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_SAMPLES=y
# CONFIG_SAMPLE_AUXDISPLAY is not set
# CONFIG_SAMPLE_TRACE_EVENTS is not set
CONFIG_SAMPLE_TRACE_PRINTK=m
CONFIG_SAMPLE_FTRACE_DIRECT=m
# CONFIG_SAMPLE_TRACE_ARRAY is not set
# CONFIG_SAMPLE_KOBJECT is not set
# CONFIG_SAMPLE_KPROBES is not set
# CONFIG_SAMPLE_HW_BREAKPOINT is not set
# CONFIG_SAMPLE_KFIFO is not set
# CONFIG_SAMPLE_LIVEPATCH is not set
# CONFIG_SAMPLE_CONFIGFS is not set
# CONFIG_SAMPLE_VFIO_MDEV_MTTY is not set
# CONFIG_SAMPLE_VFIO_MDEV_MDPY is not set
# CONFIG_SAMPLE_VFIO_MDEV_MDPY_FB is not set
# CONFIG_SAMPLE_VFIO_MDEV_MBOCHS is not set
# CONFIG_SAMPLE_WATCHDOG is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set

#
# x86 Debugging
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_NMI_SUPPORT=y
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
# CONFIG_UNWINDER_GUESS is not set
# end of x86 Debugging

#
# Kernel Testing and Coverage
#
CONFIG_KUNIT=y
CONFIG_KUNIT_DEBUGFS=y
CONFIG_KUNIT_TEST=y
CONFIG_KUNIT_EXAMPLE_TEST=y
CONFIG_KUNIT_ALL_TESTS=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_NETDEV_NOTIFIER_ERROR_INJECT is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAULT_INJECTION_USERCOPY is not set
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
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_TEST_MIN_HEAP is not set
# CONFIG_TEST_SORT is not set
# CONFIG_TEST_DIV64 is not set
# CONFIG_KPROBES_SANITY_TEST is not set
CONFIG_BACKTRACE_SELF_TEST=y
# CONFIG_RBTREE_TEST is not set
# CONFIG_REED_SOLOMON_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_STRSCPY=m
# CONFIG_TEST_KSTRTOX is not set
CONFIG_TEST_PRINTF=m
CONFIG_TEST_BITMAP=m
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_XARRAY is not set
# CONFIG_TEST_OVERFLOW is not set
# CONFIG_TEST_RHASHTABLE is not set
CONFIG_TEST_HASH=y
# CONFIG_TEST_IDA is not set
CONFIG_TEST_LKM=m
CONFIG_TEST_BITOPS=m
CONFIG_TEST_VMALLOC=m
CONFIG_TEST_USER_COPY=m
CONFIG_TEST_BPF=m
CONFIG_TEST_BLACKHOLE_DEV=m
# CONFIG_FIND_BIT_BENCHMARK is not set
CONFIG_TEST_FIRMWARE=m
CONFIG_TEST_SYSCTL=y
CONFIG_BITFIELD_KUNIT=y
CONFIG_RESOURCE_KUNIT_TEST=y
CONFIG_SYSCTL_KUNIT_TEST=y
CONFIG_LIST_KUNIT_TEST=y
# CONFIG_LINEAR_RANGES_TEST is not set
CONFIG_CMDLINE_KUNIT_TEST=y
# CONFIG_BITS_TEST is not set
# CONFIG_TEST_UDELAY is not set
CONFIG_TEST_STATIC_KEYS=m
CONFIG_TEST_KMOD=m
# CONFIG_TEST_MEMCAT_P is not set
CONFIG_TEST_LIVEPATCH=m
# CONFIG_TEST_STACKINIT is not set
# CONFIG_TEST_MEMINIT is not set
CONFIG_TEST_HMM=m
# CONFIG_TEST_FREE_PAGES is not set
# CONFIG_TEST_FPU is not set
CONFIG_ARCH_USE_MEMTEST=y
# CONFIG_MEMTEST is not set
# CONFIG_HYPERV_TESTING is not set
# end of Kernel Testing and Coverage
# end of Kernel hacking

--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=job-script

#!/bin/sh

export_top_env()
{
	export suite='reaim'
	export testcase='reaim'
	export category='benchmark'
	export runtime=300
	export nr_task=16
	export job_origin='reaim-100.yaml'
	export queue_cmdline_keys='branch
commit
queue_at_least_once'
	export queue='validate'
	export testbox='lkp-cfl-e1'
	export tbox_group='lkp-cfl-e1'
	export kconfig='x86_64-rhel-8.3'
	export submit_id='60fd1390faca18183633681f'
	export job_file='/lkp/jobs/scheduled/lkp-cfl-e1/reaim-performance-100%-300s-new_dbase-ucode=0xde-debian-10.4-x86_64-20200603.cgz-cda0d205259a7e7c1f8e296130ac091557134a66-20210725-71734-14vtc01-5.yaml'
	export id='3c98165cff6583c707728ef9ebf63583bceca804'
	export queuer_version='/lkp-src'
	export model='Coffee Lake'
	export nr_node=1
	export nr_cpu=16
	export memory='32G'
	export nr_hdd_partitions=1
	export hdd_partitions='/dev/disk/by-id/ata-WDC_WD20EZRX-00D8PB0_WD-WCC4M5CEX6NU-part2'
	export swap_partitions='LABEL=SWAP'
	export rootfs_partition='/dev/disk/by-id/ata-WDC_WD20EZRX-00D8PB0_WD-WCC4M5CEX6NU-part1'
	export brand='Intel(R) Xeon(R) E-2278G CPU @ 3.40GHz'
	export avoid_nfs=1
	export commit='cda0d205259a7e7c1f8e296130ac091557134a66'
	export netconsole_port=6685
	export ucode='0xde'
	export need_kconfig_hw='{"IGB"=>"y"}
SATA_AHCI'
	export enqueue_time='2021-07-25 15:32:32 +0800'
	export _id='60fd13a1faca181836336821'
	export _rt='/result/reaim/performance-100%-300s-new_dbase-ucode=0xde/lkp-cfl-e1/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3/gcc-9/cda0d205259a7e7c1f8e296130ac091557134a66'
	export user='lkp'
	export compiler='gcc-9'
	export LKP_SERVER='internal-lkp-server'
	export head_commit='fbce25f8d9687acb11cdf55c754631ce2f91f6f0'
	export base_commit='2734d6c1b1a089fb593ef6a23d4b70903526fe0c'
	export branch='linux-review/Shakeel-Butt/memcg-switch-lruvec-stats-to-rstat/20210718-103230'
	export rootfs='debian-10.4-x86_64-20200603.cgz'
	export result_root='/result/reaim/performance-100%-300s-new_dbase-ucode=0xde/lkp-cfl-e1/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3/gcc-9/cda0d205259a7e7c1f8e296130ac091557134a66/3'
	export scheduler_version='/lkp/lkp/.src-20210724-100040'
	export arch='x86_64'
	export max_uptime=2100
	export initrd='/osimage/debian/debian-10.4-x86_64-20200603.cgz'
	export bootloader_append='root=/dev/ram0
user=lkp
job=/lkp/jobs/scheduled/lkp-cfl-e1/reaim-performance-100%-300s-new_dbase-ucode=0xde-debian-10.4-x86_64-20200603.cgz-cda0d205259a7e7c1f8e296130ac091557134a66-20210725-71734-14vtc01-5.yaml
ARCH=x86_64
kconfig=x86_64-rhel-8.3
branch=linux-review/Shakeel-Butt/memcg-switch-lruvec-stats-to-rstat/20210718-103230
commit=cda0d205259a7e7c1f8e296130ac091557134a66
BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3/gcc-9/cda0d205259a7e7c1f8e296130ac091557134a66/vmlinuz-5.13.0-rc2-00028-gcda0d205259a
max_uptime=2100
RESULT_ROOT=/result/reaim/performance-100%-300s-new_dbase-ucode=0xde/lkp-cfl-e1/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3/gcc-9/cda0d205259a7e7c1f8e296130ac091557134a66/3
LKP_SERVER=internal-lkp-server
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
	export modules_initrd='/pkg/linux/x86_64-rhel-8.3/gcc-9/cda0d205259a7e7c1f8e296130ac091557134a66/modules.cgz'
	export bm_initrd='/osimage/deps/debian-10.4-x86_64-20200603.cgz/run-ipconfig_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/lkp_20210707.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/rsync-rootfs_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/reaim_20210701.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/reaim-x86_64-7.0.1.13-1_20210701.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/mpstat_20200714.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/turbostat_20200721.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/turbostat-x86_64-3.7-4_20200721.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/perf_20210621.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/perf-x86_64-d8079fac1681-1_20210725.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/sar-x86_64-34c92a
 e-1_20200702.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/hw_20200715.cgz'
	export ucode_initrd='/osimage/ucode/intel-ucode-20210222.cgz'
	export lkp_initrd='/osimage/user/lkp/lkp-x86_64.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export last_kernel='5.14.0-rc2-g2734d6c1b1a0'
	export repeat_to=6
	export queue_at_least_once=1
	export kernel='/pkg/linux/x86_64-rhel-8.3/gcc-9/cda0d205259a7e7c1f8e296130ac091557134a66/vmlinuz-5.13.0-rc2-00028-gcda0d205259a'
	export dequeue_time='2021-07-25 15:38:04 +0800'
	export job_initrd='/lkp/jobs/scheduled/lkp-cfl-e1/reaim-performance-100%-300s-new_dbase-ucode=0xde-debian-10.4-x86_64-20200603.cgz-cda0d205259a7e7c1f8e296130ac091557134a66-20210725-71734-14vtc01-5.cgz'

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

	run_setup $LKP_SRC/setup/cpufreq_governor 'performance'

	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/no-stdout/wrapper boot-time
	run_monitor $LKP_SRC/monitors/wrapper uptime
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
	run_monitor lite_mode=1 $LKP_SRC/monitors/wrapper perf-sched
	run_monitor $LKP_SRC/monitors/wrapper softirqs
	run_monitor $LKP_SRC/monitors/one-shot/wrapper bdi_dev_mapping
	run_monitor $LKP_SRC/monitors/wrapper diskstats
	run_monitor $LKP_SRC/monitors/wrapper nfsstat
	run_monitor $LKP_SRC/monitors/wrapper cpuidle
	run_monitor $LKP_SRC/monitors/wrapper cpufreq-stats
	run_monitor $LKP_SRC/monitors/wrapper turbostat
	run_monitor $LKP_SRC/monitors/wrapper sched_debug
	run_monitor $LKP_SRC/monitors/wrapper perf-stat
	run_monitor $LKP_SRC/monitors/wrapper mpstat
	run_monitor lite_mode=1 $LKP_SRC/monitors/no-stdout/wrapper perf-profile
	run_monitor $LKP_SRC/monitors/wrapper oom-killer
	run_monitor $LKP_SRC/monitors/plain/watchdog

	run_test test='new_dbase' $LKP_SRC/tests/wrapper reaim
}

extract_stats()
{
	export stats_part_begin=
	export stats_part_end=

	env test='new_dbase' $LKP_SRC/stats/wrapper reaim
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper boot-time
	$LKP_SRC/stats/wrapper uptime
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
	env lite_mode=1 $LKP_SRC/stats/wrapper perf-sched
	$LKP_SRC/stats/wrapper softirqs
	$LKP_SRC/stats/wrapper diskstats
	$LKP_SRC/stats/wrapper nfsstat
	$LKP_SRC/stats/wrapper cpuidle
	$LKP_SRC/stats/wrapper turbostat
	$LKP_SRC/stats/wrapper sched_debug
	$LKP_SRC/stats/wrapper perf-stat
	$LKP_SRC/stats/wrapper mpstat
	env lite_mode=1 $LKP_SRC/stats/wrapper perf-profile

	$LKP_SRC/stats/wrapper time reaim.time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper last_state
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper time
}

"$@"

--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---
:#! jobs/reaim-100.yaml:
suite: reaim
testcase: reaim
category: benchmark
runtime: 300s
nr_task: 100%
reaim:
  test: new_dbase
job_origin: reaim-100.yaml
:#! queue options:
queue_cmdline_keys:
- branch
- commit
- queue_at_least_once
queue: bisect
testbox: lkp-cfl-e1
tbox_group: lkp-cfl-e1
kconfig: x86_64-rhel-8.3
submit_id: 60fbc919faca18ecc0219597
job_file: "/lkp/jobs/scheduled/lkp-cfl-e1/reaim-performance-100%-300s-new_dbase-ucode=0xde-debian-10.4-x86_64-20200603.cgz-cda0d205259a7e7c1f8e296130ac091557134a66-20210724-60608-1drqeey-1.yaml"
id: d7db6164d1e179b0e8b39128bb18fabbc30e828a
queuer_version: "/lkp-src"
:#! hosts/lkp-cfl-e1:
model: Coffee Lake
nr_node: 1
nr_cpu: 16
memory: 32G
nr_hdd_partitions: 1
hdd_partitions: "/dev/disk/by-id/ata-WDC_WD20EZRX-00D8PB0_WD-WCC4M5CEX6NU-part2"
swap_partitions: LABEL=SWAP
rootfs_partition: "/dev/disk/by-id/ata-WDC_WD20EZRX-00D8PB0_WD-WCC4M5CEX6NU-part1"
brand: Intel(R) Xeon(R) E-2278G CPU @ 3.40GHz
:#! include/category/benchmark:
kmsg:
boot-time:
uptime:
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
perf-sched:
  lite_mode: 1
softirqs:
bdi_dev_mapping:
diskstats:
nfsstat:
cpuidle:
cpufreq-stats:
turbostat:
sched_debug:
perf-stat:
mpstat:
perf-profile:
  lite_mode: 1
:#! include/category/ALL:
cpufreq_governor: performance
:#! include/reaim:
avoid_nfs: 1
:#! include/queue/cyclic:
commit: cda0d205259a7e7c1f8e296130ac091557134a66
:#! include/testbox/lkp-cfl-e1:
netconsole_port: 6685
ucode: '0xde'
need_kconfig_hw:
- IGB: y
- SATA_AHCI
enqueue_time: 2021-07-24 16:02:33.156934288 +08:00
_id: 60fbc92afaca18ecc0219598
_rt: "/result/reaim/performance-100%-300s-new_dbase-ucode=0xde/lkp-cfl-e1/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3/gcc-9/cda0d205259a7e7c1f8e296130ac091557134a66"
:#! schedule options:
user: lkp
compiler: gcc-9
LKP_SERVER: internal-lkp-server
head_commit: fbce25f8d9687acb11cdf55c754631ce2f91f6f0
base_commit: 2734d6c1b1a089fb593ef6a23d4b70903526fe0c
branch: linux-devel/devel-hourly-20210723-121604
rootfs: debian-10.4-x86_64-20200603.cgz
result_root: "/result/reaim/performance-100%-300s-new_dbase-ucode=0xde/lkp-cfl-e1/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3/gcc-9/cda0d205259a7e7c1f8e296130ac091557134a66/0"
scheduler_version: "/lkp/lkp/.src-20210724-100040"
arch: x86_64
max_uptime: 2100
initrd: "/osimage/debian/debian-10.4-x86_64-20200603.cgz"
bootloader_append:
- root=/dev/ram0
- user=lkp
- job=/lkp/jobs/scheduled/lkp-cfl-e1/reaim-performance-100%-300s-new_dbase-ucode=0xde-debian-10.4-x86_64-20200603.cgz-cda0d205259a7e7c1f8e296130ac091557134a66-20210724-60608-1drqeey-1.yaml
- ARCH=x86_64
- kconfig=x86_64-rhel-8.3
- branch=linux-devel/devel-hourly-20210723-121604
- commit=cda0d205259a7e7c1f8e296130ac091557134a66
- BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3/gcc-9/cda0d205259a7e7c1f8e296130ac091557134a66/vmlinuz-5.13.0-rc2-00028-gcda0d205259a
- max_uptime=2100
- RESULT_ROOT=/result/reaim/performance-100%-300s-new_dbase-ucode=0xde/lkp-cfl-e1/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3/gcc-9/cda0d205259a7e7c1f8e296130ac091557134a66/0
- LKP_SERVER=internal-lkp-server
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
modules_initrd: "/pkg/linux/x86_64-rhel-8.3/gcc-9/cda0d205259a7e7c1f8e296130ac091557134a66/modules.cgz"
bm_initrd: "/osimage/deps/debian-10.4-x86_64-20200603.cgz/run-ipconfig_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/lkp_20210707.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/rsync-rootfs_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/reaim_20210701.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/reaim-x86_64-7.0.1.13-1_20210701.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/mpstat_20200714.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/turbostat_20200721.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/turbostat-x86_64-3.7-4_20200721.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/perf_20210621.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/perf-x86_64-de5540965853-1_20210711.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/sar-x86_64-34c92ae-1_202
 00702.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/hw_20200715.cgz"
ucode_initrd: "/osimage/ucode/intel-ucode-20210222.cgz"
lkp_initrd: "/osimage/user/lkp/lkp-x86_64.cgz"
site: inn
:#! /lkp/lkp/.src-20210723-151953/include/site/inn:
LKP_CGI_PORT: 80
LKP_CIFS_PORT: 139
oom-killer:
watchdog:
:#! runtime status:
last_kernel: 5.14.0-rc2
repeat_to: 3
:#! user overrides:
queue_at_least_once: 0
kernel: "/pkg/linux/x86_64-rhel-8.3/gcc-9/cda0d205259a7e7c1f8e296130ac091557134a66/vmlinuz-5.13.0-rc2-00028-gcda0d205259a"
dequeue_time: 2021-07-24 16:03:58.084627927 +08:00
:#! /lkp/lkp/.src-20210724-100040/include/site/inn:
job_state: finished
loadavg: 3.43 3.59 1.80 1/226 9596
start_time: '1627113922'
end_time: '1627114223'
version: "/lkp/lkp/.src-20210724-100113:2046f0a8:5b503b310"

--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce


for cpu_dir in /sys/devices/system/cpu/cpu[0-9]*
do
	online_file="$cpu_dir"/online
	[ -f "$online_file" ] && [ "$(cat "$online_file")" -eq 0 ] && continue

	file="$cpu_dir"/cpufreq/scaling_governor
	[ -f "$file" ] && echo "performance" > "$file"
done

cp data/workfile.new_dbase .
mkdir -p /fs/shm
umount /fs/shm
mount -t tmpfs tmpfs /fs/shm
echo FILESIZE 10k > reaim.config
echo POOLSIZE 1m >> reaim.config
echo DISKDIR /fs/shm  >> reaim.config
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100
./reaim -s16 -e16 -i16 -fworkfile.new_dbase -r1 -c./reaim.config -l/tmp/lkp/result/reaim_debug -j100

--XF85m9dhOBO43t/C--

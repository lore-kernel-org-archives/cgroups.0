From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 0/8] cpusets: Isolate CPUs via sysfs using cpusets
Date: Fri,  4 Apr 2014 14:05:27 +0530
Message-ID: <cover.1396599474.git.viresh.kumar@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tglx@linutronix.de, fweisbec@gmail.com, peterz@infradead.org, mingo@kernel.org, tj@kernel.org, lizefan@huawei.com
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org, Arvind.Chauhan@arm.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>

We need to migrate away all the background kernel activities (Unbound) for
systems requiring isolation of cores (HPC, Real time, networking, etc). After
creating cpusets, you can write 1 or 0 to cpuset.quiesce file.

In our case, we are working on a networking machine which wants to run time
critical data plane threads on some CPUs, i.e. a single thread per CPU. And
these CPUs shouldn't be interrupted at all by background kernel activities, like
timers/hrtimers/workqueues/etc..

Writing '1': on this file would migrate unbound/unpinned timers and hrtimers
away from the CPUs of the cpuset in question. Also it would disallow addition of
any new unpinned timers & hrtimers to isolated CPUs.

Writing '0': will disable isolation of CPUs in current cpuset and unpinned
timers/hrtimers would be allowed in future on these CPUs.

This patchset allow us to do this. In the first few patches it builds basic
infrastructure in timers and hrtimers and then finally use that in cpusets. Also
it updates get_nohz_timer_target() to stop adding new timers/hrtimers to these
isolated CPUs.

V1: https://lkml.org/lkml/2014/3/20/319

Not many comments received.

Based on some other timers/hrtimers cleanup I did:
http://comments.gmane.org/gmane.linux.kernel/1677797

Available here: git://git.linaro.org/people/viresh.kumar/linux.git isolate-cpusets

V1->V2:
- Add support to migrate hrtimers as well (V1 only had timers)
- cpuset.quiesce now supports writing 0 and reading as well
- update get_nohz_timer_target() to stop adding new timers/hrtimers to these
  isolated CPUs.
- Minor fixups that I noticed

Known issues:
1. Patch: "timer: track pinned timers with TIMER_PINNED flag", following
   reporting by kbuild system (Don't know how to fix this):

	config: make ARCH=blackfin allyesconfig
	
	Note: the vireshk/timer-cleanup-for-tglx HEAD
	ea63467ac9150cd86f4d960887116f99a2803b56 builds fine.  It only hurts
	bisectibility.
	
	All error/warnings:
	
	   kernel/timer.c: In function 'init_timers':
	>> kernel/timer.c:1683:2: error: call to '__compiletime_assert_1683'
	>> declared with attribute error: BUILD_BUG_ON failed:
	>> __alignof__(struct tvec_base) & TIMER_FLAG_MASK
	
2. Patch: "timer: don't migrate pinned timers", following reporting by kbuild
   system (Not really a problem created due to this patch, but just highlighted
   an existing bug. As pinned timers must be removed by owners before CPU goes
   down):


	smpboot: CPU 1 is now offline
	------------[ cut here ]------------
	WARNING: CPU: 0 PID: 1935 at kernel/timer.c:1621 migrate_timer_list+0xd6/0xf0()
	migrate_timer_list: can't migrate pinned timer: ffffffff81f06a60, deactivating it
	Modules linked in:


Viresh Kumar (8):
  timer: track pinned timers with TIMER_PINNED flag
  timer: don't migrate pinned timers
  timer: create timer_quiesce_cpu() to isolate CPU from timers
  hrtimer: update timer->state with 'pinned' information
  hrtimer: don't migrate pinned timers
  hrtimer: create hrtimer_quiesce_cpu() to isolate CPU from hrtimers
  cpuset: Create sysfs file: cpusets.quiesce to isolate CPUs
  sched: don't queue timers on quiesced CPUs

 Documentation/cgroups/cpusets.txt | 19 +++++++-
 include/linux/cpuset.h            |  8 ++++
 include/linux/hrtimer.h           |  6 +++
 include/linux/timer.h             | 13 ++++--
 kernel/cpuset.c                   | 76 ++++++++++++++++++++++++++++++++
 kernel/hrtimer.c                  | 69 ++++++++++++++++++++++++-----
 kernel/sched/core.c               |  9 ++--
 kernel/timer.c                    | 91 +++++++++++++++++++++++++++++++--------
 8 files changed, 253 insertions(+), 38 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

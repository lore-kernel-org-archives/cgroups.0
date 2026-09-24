Received: from mta1.migadu.com (out-87.mta1.migadu.com [95.215.58.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E625B2D8DC4
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 18:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790275574; cv=none; b=aF3RkiBPDnvJB0g8/aUBgHI4/WzT1IuZBlKTc60ekB/c6drbGy6/HS3FH7Js5Ehjmy040hppcibFBJImFIBYhdODrS/BaGrfI5mtjdeDCMG8lmCJPXdO3S6Foenk9QhamftUF1m/c7cWF+fOPUbuLtdm2IYMpHkn/GEGQShKlwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790275574; c=relaxed/simple;
	bh=91syfsU5GYx0rGSvaym71XNdT9fl8e/N6mWVzG2+jLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C3u9Xhs5Y8dEEfNqBivTpZWOHSfZXlE7F1DwB2k22IMquhfKmYfwHvMBrRyqz3YanId0+VVQ3RWJc+JusrTYb3JlAU2YU9+3l4+RKbpzuQ5ay0Z0jDp9FtinvorZYaQLsbFJdvBQjoOFDwabOTwfWpWtKcBpAEeuO7X8lWMp6mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IOIYj5+V; arc=none smtp.client-ip=95.215.58.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IOIYj5+V"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=91syfsU5GYx0rGSvaym71XNdT9fl8e/N6mWVzG2+jLQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790275560; v=1; x=1790880360;
 b=IOIYj5+VjsG9hUuYSnQhqlVYL/2iq+akA2W0bwrSeUSazTjLI/+WYRim3Ko5k6PxAi/HFseq
 Qmcl8gNMsI29I5ZSQtFR4dQ1kvOFDxPLF9eEIz4ttvhwcGvOl3uaubsA2DwYTnVDqky5mdy2AQZ
 pZUUyHwQ6RbIr7DV2TjHJW20=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 69da63fa5bdfc846;
	Thu, 24 Sep 2026 18:46:00 +0000
X-Mizu-Trace-ID: 69da63fa5bdfc846
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Peter Zijlstra <peterz@infradead.org>
Cc: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	David Dai <david.dai@linux.dev>,
	JP Kobryn <jp.kobryn@linux.dev>,
	Frederic Weisbecker <frederic@kernel.org>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Hao Lee <haolee.swjtu@gmail.com>,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/7] cgroup: charge kernel work to the cgroup it is done for
Date: Thu, 24 Sep 2026 11:45:21 -0700
Message-ID: <20260924184529.879516-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sometimes a kernel thread does work for a cgroup. The CPU time of that
work is charged to the thread's own cgroup, which is usually the root.
The cgroup that caused the work never sees it, and never pays for it.

This series lets a kernel thread say which cgroup it is working for.
That cgroup then sees the CPU time in its cpu.stat and the stalls in
its memory.pressure, and the CPU time comes out of its cpu.max quota.
The first user is the memcg reclaim that runs from high_work.


The problem
===========

When a memcg goes over memory.high, the task that charged the memory
is made to reclaim on its way back to user space. That does not work
when the charge happens in IRQ context, because the interrupted task
may have nothing to do with the memcg. For that case the kernel
queues memcg->high_work, and a kworker does the reclaim later.

The kworker runs in the root cgroup. So for that reclaim:
 - its CPU time does not show up in the memcg's cpu.stat;
 - its reclaim work does not show up in the memcg's memory.pressure;
 - its CPU time does not count against the memcg's cpu.max limit;
 - the rest of the system sees it as system overhead.

It is one case of a wider gap. For memory, a kernel thread can charge
an allocation to another memcg with set_active_memcg(). For IO there
is kthread_associate_blkcg(). For CPU time and pressure there is
nothing like it. And a kworker cannot just be moved into the cgroup:
kworkers are bound kthreads (PF_NO_SETAFFINITY), and cgroup refuses to
move those.

For our lock isolation work [5, 6], we plan to use async reclaim more
extensively, not just for charge requests from IRQ context, and thus
we want to make the CPU accounting of this work accurate.


Earlier attempts
================

This has come up before, with memory reclaim as one of the main
examples.

In 2019, Daniel Jordan posted "cgroup-aware unbound workqueues" [1].
It moved the worker into the work item's cgroup before running it, and
back to the root after. A move took about 1 us, but every move takes
cgroup_mutex and cgroup_threadgroup_rwsem, so moves cannot run in
parallel. The workers also showed up in cgroup.procs and blocked
rmdir, and cpuset did not work. It was not merged. In his reply [2],
Tejun said the direction for memory and IO is "remote charging, where
a kthread explicitly says who the specific io or allocation is for",
along with back-charging, and that "CPU doesn't have a backcharging
mechanism yet".

In 2021, Hao Lee asked for remote charging of CPU time [3]. His case
is ours: memcg reclaim from a workqueue "will steal cpu time from the
system level, which breaks the resource isolation". Tejun agreed [4]
that something like this is needed for CPU time spent in common code
for a specific cgroup, "e.g. memory reclaim, net packet rx", and said
he knew of no patches for it. Daniel said he was working on one.
Nothing has been merged since.


Options we looked at
====================

A. Keep the shared kworker, and only charge the cgroup.

  A1. Measure how long the reclaim ran, then charge that time to the
      memcg's cgroup.

  A2. Let the kworker say "charge this cgroup" while it works, the
      same way set_active_memcg() works for memory.

B. Also make the cgroup's CPU limits apply.

  B1. Run the kworker in the cgroup's scheduling group while it works,
      so cpu.weight and cpu.max apply to it.

  B2. Run the reclaim at full speed, then take its CPU time out of the
      cgroup's cpu.max quota afterwards (back-charging).

C. Do the reclaim inside the cgroup.

  C1. Record the overage as a debt on the memcg, and let the memcg's
      own tasks pay it the next time they charge memory or return to
      user space.

  C2. Give each memcg its own reclaim thread that lives in the cgroup.

  C3. Use a cgroup-aware workqueue, as in [1], or per-cgroup worker
      pools.


What we chose and why
=====================

We chose A2, together with B2 for cpu.max.

We do not throttle the reclaim itself. Adding limits to it is more
complicated and most probably unneeded, as we envision that we will
need concurrent background reclaimers instead of throttling in a
real-world environment. We are working on developing a system to
balance the rate of allocations/charges with the rate of reclaim, to
keep the system always running effectively.

In addition, reclaim takes sleeping locks, like i_mmap_rwsem and the
anon_vma lock in rmap walks, and fs locks in shrinkers. With a low
cgroup weight, the kworker can be preempted while it holds them, and
then tasks in other cgroups wait on it. It also hurts the workqueue. A
kworker that is runnable but not running still counts as running, and
the workqueue only spots CPU hogs by the CPU time they use. So other
work queued on that CPU's system_wq waits too.

Still, the reclaim should not be free CPU time on top of the cgroup's
limit. With A2 alone, the reclaim shows up in cpu.stat, but the
cgroup's own tasks still get their full cpu.max quota. B2 fixes that
without slowing the reclaim down. The kworker runs at full speed, and
afterwards its time is taken out of the cgroup's cpu.max quota, so the
cgroup's own tasks get less CPU time instead. This is the
back-charging Tejun described [2]. It only covers cpu.max.
Back-charging cpu.weight is future work.

We did not take C2 or C3. A high_work run asks for only 64 pages,
which is far too little to pay for moving a thread into a cgroup
through the global cgroup locks. A thread per memcg means thousands of
threads. cgroup v2 does not allow tasks in a non-leaf domain cgroup.
And a kernel thread in a cgroup shows up in cgroup.procs and blocks
rmdir.

C1 changes behaviour. memory.high would start slowing tasks down for
socket memory that arrived in softirq, and it would still need a
fallback for when no task in the memcg runs. That deserves its own
discussion.

Between A1 and A2: A1 is a few lines and easy to backport, but it only
fixes cpu.stat, it charges the time in one lump at the end, and it
only helps this one user. A2 charges the time as it is used, PSI can
follow it, and any kernel thread that works for a cgroup can use it.


How it works
============

task_struct gets an active_cgroup pointer. set_active_cgroup() sets it
and returns the old value, which the caller puts back when done:

	old = set_active_cgroup(memcg->css.cgroup);
	reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
	set_active_cgroup(old);

Three important details:

 - Before switching, set_active_cgroup() charges the time used so far
   to the old target, under the task's rq lock. A high_work run is
   often shorter than a tick. Without this, its time goes to whatever
   is set the next time the scheduler adds up run time, which is
   usually root again.

 - Code run under set_active_cgroup() is always kernel code. So its
   time is charged as system time right away, and the tick and vtime
   paths skip it. Without this, on nohz_full CPUs vtime posts kernel
   time late, after the old value is back, and system_usec comes out
   as 0. Forced idle time from core scheduling comes through the same
   path. It is not run time, so it goes to the active cgroup there.

 - PSI follows active_cgroup too. When it changes, the task's pressure
   state moves from the old groups to the new ones under the same rq
   lock, the same way cgroup_move_task() does for a real move.

For cpu.max, set_active_cgroup() also notes the task's run time at
each switch. When it switches away from a cgroup, it passes the time
used under that cgroup to cfs_bandwidth_charge():

 - The time is taken from the cpu.max pool of the cgroup and of each
   ancestor that has a limit. These are the same pools the cgroup's
   own tasks draw from.

 - The kworker is never throttled, because the work has already run.
   If a pool runs dry, the rest becomes debt, which is paid first out
   of the next periods' quota. So the cgroup's own tasks get less CPU
   time for a while.

 - The debt is capped at one period's quota, so one long piece of
   work cannot starve the cgroup for long. Time over the cap still
   shows up in cpu.stat. Writing cpu.max or cpu.max.burst clears the
   debt.

 - If neither the cgroup nor any ancestor has a limit, it returns
   right away.

The caller must keep the cgroup alive until it puts back the old
value. For high_work this holds: the memcg's css pins its cgroup, and
high_work is cancelled in mem_cgroup_css_free(). If a task exits with
active_cgroup still set, it gets a warning and the field is cleared.

The caller must be in the root cgroup, as kworkers are. The scheduler
still runs the caller in its own cgroup, so from any other cgroup the
time would also be taken out of that cgroup's cpu.max, and on nohz_full
CPUs vtime could post some system time to the wrong cgroup at a switch.
For such a caller, set_active_cgroup() warns and does nothing.

Which cgroup pays for high_work? The work belongs to the memcg that is
over memory.high. A charge in IRQ context walks up from the charging
memcg and queues the high_work of the first memcg it finds over
memory.high. So if a child makes the charge but only its parent is
over memory.high, the reclaim is charged to the parent: its cpu.stat,
its memory.pressure, and the cpu.max of the parent and of each
ancestor above it that has a limit. The child is not charged. Reclaim
in task context is different: the charging task reclaims on its way
back to user space, so the child and every ancestor above it are
charged.


The patches
===========

  1: A helper that charges kernel CPU time to a cgroup.
  2: set_active_cgroup().
  3: PSI following it.
  4: A helper that takes kernel CPU time out of a cgroup's cpu.max.
  5: set_active_cgroup() using it.
  6: high_work using set_active_cgroup().
  7: Selftests for high_work.


Testing
=======

 - End to end, with the setup above. Without the series, the memcg's
   cpu.stat and memory.pressure did not move. With it, the memcg's
   usage_usec matched the CPU time that high_work used, measured with
   bpftrace, to within 1%, all of it as system time, also on nohz_full.
   memory.pressure grew by the reclaim's stall time.

 - A test module that calls set_active_cgroup() directly. The charge
   matches the CPU time used to within 20 us in runs of 200 to 500 ms.
   It also covers nesting, use from a user task in the root cgroup,
   over 30,000 switches while userspace moves the thread between
   cgroups, a task that exits without putting the old value back, and
   rmdir of a cgroup that is still in use. A caller outside the root
   cgroup gets one warning, and its time stays with its own cgroup. It
   passes on normal, psi=0, cgroup_disable=pressure, nohz_full,
   lockdep+KASAN+UBSAN and KCSAN kernels. No pressure state is left
   behind, and KCSAN reports nothing in the new code.

 - Forced idle, on a core scheduling kernel with SMT siblings. The
   module burns 500 ms under set_active_cgroup() next to a busy loop
   with a different core scheduling cookie, so each forces the other's
   CPU idle. The active cgroup's core_sched.force_idle_usec grows by
   exactly the forced idle time charged to the module's thread, about
   250 ms per run.

 - The same module against cpu.max, with a CPU hog in a cgroup whose
   cpu.max is "20000 100000":
    - 100 pieces of 2 ms of work for the cgroup cost the hog 214 to
      233 ms of CPU time for 199 ms of work. The same holds with the
      limit on the parent and the hog in a sibling cgroup.
    - Five 300 ms pieces cost the hog 89 to 104 ms, about five
      periods' quota. When cpu.max is written after each piece, the
      debt is cleared and the hog loses nothing.
    - Without a limit, the hog loses nothing.
    - rmdir of a cgroup that has debt works.
   It passes on normal, lockdep+KASAN+UBSAN and KCSAN kernels.

 - A caller inside a limited cgroup, doing 200 ms of work for that same
   cgroup. set_active_cgroup() refuses it, so the work is charged once:
   a hog there loses 227 to 233 ms, the same as when the caller does
   not use set_active_cgroup() at all (211 to 232 ms). Without the
   root cgroup rule, it loses 412 to 423 ms, as the time is charged
   twice.

 - A stress test that creates, fills, kills and removes memcgs while
   high_work runs, with and without cpu.max limits on the memcgs and
   their parent, on normal and debug kernels. With limits, each run
   takes 4 to 5 seconds of high_work time out of cpu.max, in about
   2,100 pieces. All the dying memcgs get freed within 2 seconds.

 - The two new selftests. Without the series, the first fails and the
   second skips, because no reclaim time shows up at all. With only
   patches 1-3 and 6, the second fails. With the whole series, both
   pass, on normal and debug kernels.

 - Every patch builds, with and without cgroups, and with core
   scheduling. The whole series builds cleanly without PSI, without
   memcg, without cgroups, without CFS bandwidth control, without
   CGROUP_SCHED, on UP, with PREEMPT_RT, with SCHED_CORE, with
   nohz_full, on i386, with clang, on arm64, with allmodconfig, and
   with W=1 on the touched files.

 - No measurable change in perf bench sched pipe or messaging. The hot
   path gains one load and one branch.


Open questions
==============

 - When the memcg's own tasks are idle, the kworker is its only busy
   member while it reclaims. So memory.pressure "full" equals "some"
   for that time. Is that what we want? Tools like oomd will see it.

 - Is set_active_cgroup() the right name and place? It is limited to
   callers in the root cgroup. Other callers would need the vtime state
   split at each switch, and their own cpu.max left alone while the
   override is set. Is that worth doing?

 - Is one period's quota the right cap for the cpu.max debt? A larger
   cap makes the cgroup pay for more of a long run, but can stall its
   tasks for longer.

 - Should high_work charge the memcg that made the charge instead, as
   reclaim in task context does? That would mean queuing the charging
   memcg's own high_work, so several children of an over-high parent
   could reclaim at the same time, instead of one shared work item.

 - Other kernel threads that work for one cgroup could use
   set_active_cgroup() too. Network receive itself is harder, because
   the cgroup is only known after the work starts, as Daniel pointed
   out in the thread at [3].


[1] https://lore.kernel.org/20190605133650.28545-1-daniel.m.jordan@oracle.com/
[2] https://lore.kernel.org/20190605135319.GK374014@devbig004.ftw2.facebook.com/
[3] https://lore.kernel.org/60decdb6.1c69fb81.6130e.7642@mx.google.com/
[4] https://lore.kernel.org/YN+Sne76dhKBzV%2FR@mtj.duckdns.org/
[5] https://lore.kernel.org/20260921192559.2619635-1-shakeel.butt@linux.dev/
[6] https://lore.kernel.org/20260924155025.949998-1-shakeel.butt@linux.dev/

Shakeel Butt (7):
  cgroup: add cgroup_account_system_time()
  cgroup: add set_active_cgroup() to charge CPU time to a cgroup
  psi: charge pressure to the task's active cgroup
  sched/fair: add cfs_bandwidth_charge() for kernel work done for a
    cgroup
  cgroup: take set_active_cgroup() time out of the cgroup's cpu.max
  memcg: charge high_work reclaim to the memcg
  selftests: cgroup: check that high_work reclaim is charged to the
    memcg

 include/linux/cgroup.h                        |  39 ++
 include/linux/sched.h                         |   4 +
 kernel/cgroup/cgroup.c                        |   4 +
 kernel/fork.c                                 |   4 +
 kernel/sched/core.c                           |  52 +++
 kernel/sched/fair.c                           |  43 +++
 kernel/sched/psi.c                            |  22 +-
 kernel/sched/sched.h                          |   8 +
 kernel/sched/stats.h                          |  10 +
 mm/memcontrol.c                               |   5 +
 .../selftests/cgroup/test_memcontrol.c        | 332 ++++++++++++++++++
 11 files changed, 522 insertions(+), 1 deletion(-)


base-commit: a8c591ed6b672915e0be57843f943a2a723aff40
-- 
2.53.0-Meta


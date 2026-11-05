Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793897250;
	b=yIBL6kD897T/wbKT6fyPL5WlcVeGhK4Kw5LRrhySmLsQ/Rv9PTS8TgwWdIXLiiqu98d3
	 nAvoGw5dQSMlUT/mH6rD0mIjh7Y+QmznwYcVvqA0chvJABeAsjoXwTP4ecySmHJloxLHe
	 G37Y68KuHvLMCC68ePI5HfH9CO4CgQHTgx8t3utC8VGwhqCHwJVlB2JeY+1yOhGlkE3UU
	 ntBw+4JQjRkGtRVRBgcBQ6bA3rjvR7pgtIgspHi9QDBOnoJnUauaG1aJjao+ZxKJ/24TN
	 oKfHHqM2/PtPyZHBv3Sh9WNX/rQdSo/cyEiu2xZ4FdKhw/abTxUs9wmhJ/ThO+l3UlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793897250;
	h=DMARC-Filter:Date:DKIM-Signature:DKIM-Signature:From:To:Cc:Subject:
	 Message-ID:MIME-Version:Content-Type:Content-Disposition;
	bh=vXFNyBZ6l8R2I32D0AmLX4lB1G58/JcdgGp3e5QR1B8=;
	b=jWPEuk+7qeaKYZRHUDeDwyyvHtn0slnJRSSUTthEVob2KRl/j6h7mDm9PBkpdpTRmwwo
	 WvFIyYKfJMW5K7R6LILyRn2oHcytCqYIAR8Rq+MSb/WTujCV22D411O5ZVTj35IfdcTy5
	 uM8gGQA212nL7nVUuvCBFklNMUpTuBtzugHApti5KJzLE2tr2qqJRduAI3QQpGzWcNjnu
	 OPnBRgW6MAit5eAXcx2aYIq/2KAA+kTmEz4cUpBqRYb2o/7/U4VicBkfyuGagNvkph1Tv
	 bBvzgCJ9TJhiPBkdNcADTS/eduLbWv+JrQnlkakDMqxjvhT2D/66Y/lo3yYE+nP8zsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=awDkH1nd;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=hEolDJwp;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FB3606A334;
	Thu,  5 Nov 2026 16:47:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2FB3606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=awDkH1nd;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=hEolDJwp
Date: Thu, 5 Nov 2026 17:47:24 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1793897246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=vXFNyBZ6l8R2I32D0AmLX4lB1G58/JcdgGp3e5QR1B8=;
	b=awDkH1ndJdC0kc1GdVF1wX9K3LR7J8EcP5fFHrNit/bNzVPleWaRtnFShbDuAlwUXDIjy2
	AcJmYQtgAj2oSSKKdv6FlYL1nuh5AIZlr+rCDnkMYzh98FcG1CPxFegvIgET0fbJFZNnXb
	0/bIOn3OR4ohqd4JwVXTE94X3I9P8FT0FZidgDI3+POFAxXWFJ8M3P8hzl9AsWjHCrJ6fF
	gnaqD5XAMX0sj34QrVOIMlNZRbyzGD6f/Z5ibHaPX+3xf4Xp5CS2wuiOJf7zTpksa91mjI
	KuuwvDO/t00pbPBRBgdadr8RHLbhI5/sA0Valvj/ZQo+7tU6zexQmcNYIK45pA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1793897246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=vXFNyBZ6l8R2I32D0AmLX4lB1G58/JcdgGp3e5QR1B8=;
	b=hEolDJwp1PfGETtWulygz3XcEhdUYetCQX9FthB48uf3+yRcExhpFgCdWaxSJHbWGSyS4X
	ju33DwGe5I/71RDA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-devel@lists.linux.dev, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	John Ogness <john.ogness@linutronix.de>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	luca abeni <luca.abeni@santannapisa.it>,
	Yuri Andriaccio <yurand2000@gmail.com>,
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>
Subject: [PATCH] sched: Remove CONFIG_RT_GROUP_SCHED
Message-ID: <20261105164724.yxONBd03@linutronix.de>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

The RT_GROUP_SCHED is broken beyond repair and it is to not enable it
during compile. If enabled it is recommended to disable it at boot time
with the rt_group_sched= option.
With it enabled it is not possible to set the policy of a task to
SCHED_{FIFO|RR} because its cgroup has no runtime assigned. The runtime
can not be assigned with cgroup v2. The root group has however all the
runtime assigned meaning the global sysctl runtime parameter
(sched_rt_runtime_us) can no be reduced because the new bandwidth will
be less than what is current available.
It is possible to schedule SCHED_DEADLINE tasks but the admission
control is stuck can only be disabled via -1 (same sysctl parameter).

As a result all major distors (Debian, Open Suse, Fedora, Archlinux)
have it disabled.

I don't think it is needed to somehow fix RT_GROUP_SCHED. The DL fair
server already handles the RT throttling mechanism. There is work on
Hierarchical constant bandwidth server (HCBS) which aim to group
multiple real-time tasks within one deadline configuration.

Remove CONFIG_RT_GROUP_SCHED.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---

Follow-up to https://lore.kernel.org/all/20261023161348.t3lpPLQZ@linutronix.de/
First step.

 Documentation/admin-guide/cgroup-v2.rst       |  15 +-
 .../admin-guide/kernel-parameters.txt         |   5 -
 Documentation/scheduler/index.rst             |   1 -
 Documentation/scheduler/sched-bwc.rst         |   1 -
 Documentation/scheduler/sched-deadline.rst    |  19 +-
 Documentation/scheduler/sched-design-CFS.rst  |   3 -
 Documentation/scheduler/sched-rt-group.rst    | 190 ----
 include/linux/sched.h                         |   7 -
 init/Kconfig                                  |  22 -
 kernel/sched/autogroup.c                      |  17 -
 kernel/sched/core.c                           | 111 +--
 kernel/sched/deadline.c                       |  26 -
 kernel/sched/debug.c                          |  10 -
 kernel/sched/features.h                       |   1 -
 kernel/sched/rt.c                             | 925 ------------------
 kernel/sched/sched.h                          |  87 +-
 kernel/sched/syscalls.c                       |  13 -
 17 files changed, 15 insertions(+), 1438 deletions(-)
 delete mode 100644 Documentation/scheduler/sched-rt-group.rst

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 9e3c67b02ae2e..f8ee6e63f1775 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1107,20 +1107,7 @@ provided by a CPU, as well as the maximum desired frequency, which should not
 be exceeded by a CPU.
 
 WARNING: cgroup2 cpu controller doesn't yet support the (bandwidth) control of
-realtime processes. For a kernel built with the CONFIG_RT_GROUP_SCHED option
-enabled for group scheduling of realtime processes, the cpu controller can only
-be enabled when all RT processes are in the root cgroup. Be aware that system
-management software may already have placed RT processes into non-root cgroups
-during the system boot process, and these processes may need to be moved to the
-root cgroup before the cpu controller can be enabled with a
-CONFIG_RT_GROUP_SCHED enabled kernel.
-
-With CONFIG_RT_GROUP_SCHED disabled, this limitation does not apply and some of
-the interface files either affect realtime processes or account for them. See
-the following section for details. Only the cpu controller is affected by
-CONFIG_RT_GROUP_SCHED. Other controllers can be used for the resource control of
-realtime processes irrespective of CONFIG_RT_GROUP_SCHED.
-
+realtime processes.
 
 CPU Interface Files
 ~~~~~~~~~~~~~~~~~~~
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0b3c140babd94..188ca6844e970 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6778,11 +6778,6 @@ Kernel parameters
 			debug mode. Defaults to CONFIG_RSEQ_DEBUG_DEFAULT_ENABLE.
 			Format: <bool>
 
-	rt_group_sched=	[KNL] Enable or disable SCHED_RR/FIFO group scheduling
-			when CONFIG_RT_GROUP_SCHED=y. Defaults to
-			!CONFIG_RT_GROUP_SCHED_DEFAULT_DISABLED.
-			Format: <bool>
-
 	rw		[KNL] Mount root device read-write on boot
 
 	S		[KNL] Run init in single mode
diff --git a/Documentation/scheduler/index.rst b/Documentation/scheduler/index.rst
index 791178ac8bec6..a9b3295e7c8ff 100644
--- a/Documentation/scheduler/index.rst
+++ b/Documentation/scheduler/index.rst
@@ -19,7 +19,6 @@ Scheduler
     schedutil
     sched-util-clamp
     sched-nice-design
-    sched-rt-group
     sched-stats
     sched-ext
     sched-debug
diff --git a/Documentation/scheduler/sched-bwc.rst b/Documentation/scheduler/sched-bwc.rst
index e881a945c1888..2402be2d09f0d 100644
--- a/Documentation/scheduler/sched-bwc.rst
+++ b/Documentation/scheduler/sched-bwc.rst
@@ -4,7 +4,6 @@ CFS Bandwidth Control
 
 .. note::
    This document only discusses CPU bandwidth control for SCHED_NORMAL.
-   The SCHED_RT case is covered in Documentation/scheduler/sched-rt-group.rst
 
 CFS bandwidth control is a CONFIG_FAIR_GROUP_SCHED extension which allows the
 specification of the maximum CPU bandwidth available to a group or hierarchy.
diff --git a/Documentation/scheduler/sched-deadline.rst b/Documentation/scheduler/sched-deadline.rst
index 9019b66f6a5ba..1ad59e918a454 100644
--- a/Documentation/scheduler/sched-deadline.rst
+++ b/Documentation/scheduler/sched-deadline.rst
@@ -567,10 +567,8 @@ Deadline Task Scheduling
  of a "traditional" real-time task, and is also often referred to as
  "bandwidth".
  The interface used to control the CPU bandwidth that can be allocated
- to -deadline tasks is similar to the one already used for -rt
- tasks with real-time group scheduling (a.k.a. RT-throttling - see
- Documentation/scheduler/sched-rt-group.rst), and is based on readable/
- writable control files located in procfs (for system wide settings).
+ to -deadline tasks is based on readable/ writable control files located in
+ procfs (for system wide settings).
  Notice that per-group settings (controlled through cgroupfs) are still not
  defined for -deadline tasks, because more discussion is needed in order to
  figure out how we want to manage SCHED_DEADLINE bandwidth at the task group
@@ -592,13 +590,12 @@ Deadline Task Scheduling
 
  The system wide settings are configured under the /proc virtual file system.
 
- For now the -rt knobs are used for -deadline admission control and with
- CONFIG_RT_GROUP_SCHED the -deadline runtime is accounted against the (root)
- -rt runtime. With !CONFIG_RT_GROUP_SCHED the knob only serves for the -dl
- admission control. We realize that this isn't entirely desirable; however, it
- is better to have a small interface for now, and be able to change it easily
- later. The ideal situation (see 5.) is to run -rt tasks from a -deadline
- server; in which case the -rt bandwidth is a direct subset of dl_bw.
+ For now the -rt knobs are used for -deadline admission control. The knob only
+ serves for the -dl admission control. We realize that this isn't entirely
+ desirable; however, it is better to have a small interface for now, and be
+ able to change it easily later. The ideal situation (see 5.) is to run -rt
+ tasks from a -deadline server; in which case the -rt bandwidth is a direct
+ subset of dl_bw.
 
  This means that, for a root_domain comprising M CPUs, -deadline tasks
  can be created while the sum of their bandwidths stays below:
diff --git a/Documentation/scheduler/sched-design-CFS.rst b/Documentation/scheduler/sched-design-CFS.rst
index 03998f6c8f9c4..5d58f1f3592b9 100644
--- a/Documentation/scheduler/sched-design-CFS.rst
+++ b/Documentation/scheduler/sched-design-CFS.rst
@@ -220,9 +220,6 @@ each task belonging to a user.
 CONFIG_CGROUP_SCHED strives to achieve exactly that.  It lets tasks to be
 grouped and divides CPU time fairly among such groups.
 
-CONFIG_RT_GROUP_SCHED permits to group real-time (i.e., SCHED_FIFO and
-SCHED_RR) tasks.
-
 CONFIG_FAIR_GROUP_SCHED permits to group CFS (i.e., SCHED_NORMAL and
 SCHED_BATCH) tasks.
 
diff --git a/Documentation/scheduler/sched-rt-group.rst b/Documentation/scheduler/sched-rt-group.rst
deleted file mode 100644
index ab464335d3204..0000000000000
--- a/Documentation/scheduler/sched-rt-group.rst
+++ /dev/null
@@ -1,190 +0,0 @@
-==========================
-Real-Time group scheduling
-==========================
-
-.. CONTENTS
-
-   0. WARNING
-   1. Overview
-     1.1 The problem
-     1.2 The solution
-   2. The interface
-     2.1 System-wide settings
-     2.2 Default behaviour
-     2.3 Basis for grouping tasks
-   3. Future plans
-
-
-0. WARNING
-==========
-
- Fiddling with these settings can result in an unstable system, the knobs are
- root only and assumes root knows what he is doing.
-
-Most notable:
-
- * very small values in sched_rt_period_us can result in an unstable
-   system when the period is smaller than either the available hrtimer
-   resolution, or the time it takes to handle the budget refresh itself.
-
- * very small values in sched_rt_runtime_us can result in an unstable
-   system when the runtime is so small the system has difficulty making
-   forward progress (NOTE: the migration thread and kstopmachine both
-   are real-time processes).
-
-1. Overview
-===========
-
-
-1.1 The problem
----------------
-
-Real-time scheduling is all about determinism, a group has to be able to rely on
-the amount of bandwidth (eg. CPU time) being constant. In order to schedule
-multiple groups of real-time tasks, each group must be assigned a fixed portion
-of the CPU time available.  Without a minimum guarantee a real-time group can
-obviously fall short. A fuzzy upper limit is of no use since it cannot be
-relied upon. Which leaves us with just the single fixed portion.
-
-1.2 The solution
-----------------
-
-CPU time is divided by means of specifying how much time can be spent running
-in a given period. We allocate this "run time" for each real-time group which
-the other real-time groups will not be permitted to use.
-
-Any time not allocated to a real-time group will be used to run normal priority
-tasks (SCHED_OTHER). Any allocated run time not used will also be picked up by
-SCHED_OTHER.
-
-Let's consider an example: a frame fixed real-time renderer must deliver 25
-frames a second, which yields a period of 0.04s per frame. Now say it will also
-have to play some music and respond to input, leaving it with around 80% CPU
-time dedicated for the graphics. We can then give this group a run time of 0.8
-* 0.04s = 0.032s.
-
-This way the graphics group will have a 0.04s period with a 0.032s run time
-limit. Now if the audio thread needs to refill the DMA buffer every 0.005s, but
-needs only about 3% CPU time to do so, it can do with a 0.03 * 0.005s =
-0.00015s. So this group can be scheduled with a period of 0.005s and a run time
-of 0.00015s.
-
-The remaining CPU time will be used for user input and other tasks. Because
-real-time tasks have explicitly allocated the CPU time they need to perform
-their tasks, buffer underruns in the graphics or audio can be eliminated.
-
-NOTE: the above example is not fully implemented yet. We still
-lack an EDF scheduler to make non-uniform periods usable.
-
-
-2. The Interface
-================
-
-
-2.1 System wide settings
-------------------------
-
-The system wide settings are configured under the /proc virtual file system:
-
-/proc/sys/kernel/sched_rt_period_us:
-  The scheduling period that is equivalent to 100% CPU bandwidth.
-
-/proc/sys/kernel/sched_rt_runtime_us:
-  A global limit on how much time real-time scheduling may use. This is always
-  less or equal to the period_us, as it denotes the time allocated from the
-  period_us for the real-time tasks. Without CONFIG_RT_GROUP_SCHED enabled,
-  this only serves for admission control of deadline tasks. With
-  CONFIG_RT_GROUP_SCHED=y it also signifies the total bandwidth available to
-  all real-time groups.
-
-  * Time is specified in us because the interface is s32. This gives an
-    operating range from 1us to about 35 minutes.
-  * sched_rt_period_us takes values from 1 to INT_MAX.
-  * sched_rt_runtime_us takes values from -1 to sched_rt_period_us.
-  * A run time of -1 specifies runtime == period, ie. no limit.
-  * sched_rt_runtime_us/sched_rt_period_us > 0.05 inorder to preserve
-    bandwidth for fair dl_server. For accurate value check average of
-    runtime/period in /sys/kernel/debug/sched/fair_server/cpuX/
-
-
-2.2 Default behaviour
----------------------
-
-The default values for sched_rt_period_us (1000000 or 1s) and
-sched_rt_runtime_us (950000 or 0.95s).  This gives 0.05s to be used by
-SCHED_OTHER (non-RT tasks). These defaults were chosen so that a run-away
-real-time tasks will not lock up the machine but leave a little time to recover
-it.  By setting runtime to -1 you'd get the old behaviour back.
-
-By default all bandwidth is assigned to the root group and new groups get the
-period from /proc/sys/kernel/sched_rt_period_us and a run time of 0. If you
-want to assign bandwidth to another group, reduce the root group's bandwidth
-and assign some or all of the difference to another group.
-
-Real-time group scheduling means you have to assign a portion of total CPU
-bandwidth to the group before it will accept real-time tasks. Therefore you will
-not be able to run real-time tasks as any user other than root until you have
-done that, even if the user has the rights to run processes with real-time
-priority!
-
-
-2.3 Basis for grouping tasks
-----------------------------
-
-Enabling CONFIG_RT_GROUP_SCHED lets you explicitly allocate real
-CPU bandwidth to task groups.
-
-This uses the cgroup virtual file system and "<cgroup>/cpu.rt_runtime_us"
-to control the CPU time reserved for each control group.
-
-For more information on working with control groups, you should read
-Documentation/admin-guide/cgroup-v1/cgroups.rst as well.
-
-Group settings are checked against the following limits in order to keep the
-configuration schedulable:
-
-   \Sum_{i} runtime_{i} / global_period <= global_runtime / global_period
-
-For now, this can be simplified to just the following (but see Future plans):
-
-   \Sum_{i} runtime_{i} <= global_runtime
-
-
-3. Future plans
-===============
-
-There is work in progress to make the scheduling period for each group
-("<cgroup>/cpu.rt_period_us") configurable as well.
-
-The constraint on the period is that a subgroup must have a smaller or
-equal period to its parent. But realistically its not very useful _yet_
-as its prone to starvation without deadline scheduling.
-
-Consider two sibling groups A and B; both have 50% bandwidth, but A's
-period is twice the length of B's.
-
-* group A: period=100000us, runtime=50000us
-
-	- this runs for 0.05s once every 0.1s
-
-* group B: period= 50000us, runtime=25000us
-
-	- this runs for 0.025s twice every 0.1s (or once every 0.05 sec).
-
-This means that currently a while (1) loop in A will run for the full period of
-B and can starve B's tasks (assuming they are of lower priority) for a whole
-period.
-
-The next project will be SCHED_EDF (Earliest Deadline First scheduling) to bring
-full deadline scheduling to the linux kernel. Deadline scheduling the above
-groups and treating end of the period as a deadline will ensure that they both
-get their allocated time.
-
-Implementing SCHED_EDF might take a while to complete. Priority Inheritance is
-the biggest challenge as the current linux PI infrastructure is geared towards
-the limited static priority levels 0-99. With deadline scheduling you need to
-do deadline inheritance (since priority is inversely proportional to the
-deadline delta (deadline - now)).
-
-This means the whole PI machinery will have to be reworked - and that is one of
-the most complex pieces of code we have.
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1c93da75226e3..ea6d0cab63f88 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -628,13 +628,6 @@ struct sched_rt_entity {
 	unsigned short			on_list;
 
 	struct sched_rt_entity		*back;
-#ifdef CONFIG_RT_GROUP_SCHED
-	struct sched_rt_entity		*parent;
-	/* rq on which this entity is (to be) queued: */
-	struct rt_rq			*rt_rq;
-	/* rq "owned" by this entity/group: */
-	struct rt_rq			*my_q;
-#endif
 } __randomize_layout;
 
 struct rq_flags;
diff --git a/init/Kconfig b/init/Kconfig
index 4013781e0a029..3a49369e40430 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -978,28 +978,6 @@ config CFS_BANDWIDTH
 	  restriction.
 	  See Documentation/scheduler/sched-bwc.rst for more information.
 
-config RT_GROUP_SCHED
-	bool "Group scheduling for SCHED_RR/FIFO"
-	depends on CGROUP_SCHED
-	default n
-	help
-	  This feature lets you explicitly allocate real CPU bandwidth
-	  to task groups. If enabled, it will also make it impossible to
-	  schedule realtime tasks for non-root users until you allocate
-	  realtime bandwidth for them.
-	  See Documentation/scheduler/sched-rt-group.rst for more information.
-
-config RT_GROUP_SCHED_DEFAULT_DISABLED
-	bool "Require boot parameter to enable group scheduling for SCHED_RR/FIFO"
-	depends on RT_GROUP_SCHED
-	default n
-	help
-	  When set, the RT group scheduling is disabled by default. The option
-	  is in inverted form so that mere RT_GROUP_SCHED enables the group
-	  scheduling.
-
-	  Say N if unsure.
-
 config EXT_GROUP_SCHED
 	bool
 	depends on SCHED_CLASS_EXT && CGROUP_SCHED
diff --git a/kernel/sched/autogroup.c b/kernel/sched/autogroup.c
index e380cf9372bbd..e9b25a4ea0b36 100644
--- a/kernel/sched/autogroup.c
+++ b/kernel/sched/autogroup.c
@@ -50,11 +50,6 @@ static inline void autogroup_destroy(struct kref *kref)
 {
 	struct autogroup *ag = container_of(kref, struct autogroup, kref);
 
-#ifdef CONFIG_RT_GROUP_SCHED
-	/* We've redirected RT tasks to the root task group... */
-	ag->tg->rt_se = NULL;
-	ag->tg->rt_rq = NULL;
-#endif
 	sched_release_group(ag->tg);
 	sched_destroy_group(ag->tg);
 }
@@ -100,18 +95,6 @@ static inline struct autogroup *autogroup_create(void)
 	init_rwsem(&ag->lock);
 	ag->id = atomic_inc_return(&autogroup_seq_nr);
 	ag->tg = tg;
-#ifdef CONFIG_RT_GROUP_SCHED
-	/*
-	 * Autogroup RT tasks are redirected to the root task group
-	 * so we don't have to move tasks around upon policy change,
-	 * or flail around trying to allocate bandwidth on the fly.
-	 * A bandwidth exception in __sched_setscheduler() allows
-	 * the policy change to proceed.
-	 */
-	free_rt_sched_group(tg);
-	tg->rt_se = root_task_group.rt_se;
-	tg->rt_rq = root_task_group.rt_rq;
-#endif /* CONFIG_RT_GROUP_SCHED */
 	tg->autogroup = ag;
 
 	sched_online_group(tg, &root_task_group);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 04b62c16fa8ca..600339bef0547 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1490,7 +1490,7 @@ bool sched_can_stop_tick(struct rq *rq)
 }
 #endif /* CONFIG_NO_HZ_FULL */
 
-#if defined(CONFIG_RT_GROUP_SCHED) || defined(CONFIG_FAIR_GROUP_SCHED)
+#ifdef CONFIG_FAIR_GROUP_SCHED
 /*
  * Iterate task_group tree rooted at *from, calling @down when first entering a
  * node and @up when leaving it for the final time.
@@ -8935,23 +8935,9 @@ void __init sched_init(void)
 #ifdef CONFIG_EXT_GROUP_SCHED
 	scx_tg_init(&root_task_group);
 #endif /* CONFIG_EXT_GROUP_SCHED */
-#ifdef CONFIG_RT_GROUP_SCHED
-	ptr += 2 * nr_cpu_ids * sizeof(void **);
-	ptr = (unsigned long)kzalloc(ptr, GFP_NOWAIT);
-	root_task_group.rt_se = (struct sched_rt_entity **)ptr;
-	ptr += nr_cpu_ids * sizeof(void **);
-
-	root_task_group.rt_rq = (struct rt_rq **)ptr;
-	ptr += nr_cpu_ids * sizeof(void **);
-
-#endif /* CONFIG_RT_GROUP_SCHED */
 
 	init_defrootdomain();
 
-#ifdef CONFIG_RT_GROUP_SCHED
-	init_rt_bandwidth(&root_task_group.rt_bandwidth,
-			global_rt_period(), global_rt_runtime());
-#endif /* CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_CGROUP_SCHED
 	task_group_cache = KMEM_CACHE(task_group, 0);
@@ -8998,15 +8984,6 @@ void __init sched_init(void)
 		init_tg_cfs_entry(&root_task_group, &rq->cfs, NULL, i, NULL);
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-#ifdef CONFIG_RT_GROUP_SCHED
-		/*
-		 * This is required for init cpu because rt.c:__enable_runtime()
-		 * starts working after scheduler_running, which is not the case
-		 * yet.
-		 */
-		rq->rt.rt_runtime = global_rt_runtime();
-		init_tg_rt_entry(&root_task_group, &rq->rt, NULL, i, NULL);
-#endif
 		rq->next_class = &idle_sched_class;
 
 		rq->sd = NULL;
@@ -9568,19 +9545,6 @@ static void cpu_cgroup_css_free(struct cgroup_subsys_state *css)
 
 static int cpu_cgroup_can_attach(struct cgroup_taskset *tset)
 {
-#ifdef CONFIG_RT_GROUP_SCHED
-	struct task_struct *task;
-	struct cgroup_subsys_state *css;
-
-	if (!rt_group_sched_enabled())
-		goto scx_check;
-
-	cgroup_taskset_for_each(task, css, tset) {
-		if (!sched_rt_can_attach(css_tg(css), task))
-			return -EINVAL;
-	}
-scx_check:
-#endif /* CONFIG_RT_GROUP_SCHED */
 	return scx_cgroup_can_attach(tset);
 }
 
@@ -10184,31 +10148,6 @@ static int cpu_burst_write_u64(struct cgroup_subsys_state *css,
 }
 #endif /* CONFIG_GROUP_SCHED_BANDWIDTH */
 
-#ifdef CONFIG_RT_GROUP_SCHED
-static int cpu_rt_runtime_write(struct cgroup_subsys_state *css,
-				struct cftype *cft, s64 val)
-{
-	return sched_group_set_rt_runtime(css_tg(css), val);
-}
-
-static s64 cpu_rt_runtime_read(struct cgroup_subsys_state *css,
-			       struct cftype *cft)
-{
-	return sched_group_rt_runtime(css_tg(css));
-}
-
-static int cpu_rt_period_write_uint(struct cgroup_subsys_state *css,
-				    struct cftype *cftype, u64 rt_period_us)
-{
-	return sched_group_set_rt_period(css_tg(css), rt_period_us);
-}
-
-static u64 cpu_rt_period_read_uint(struct cgroup_subsys_state *css,
-				   struct cftype *cft)
-{
-	return sched_group_rt_period(css_tg(css));
-}
-#endif /* CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_GROUP_SCHED_WEIGHT
 static s64 cpu_idle_read_s64(struct cgroup_subsys_state *css,
@@ -10286,54 +10225,6 @@ static struct cftype cpu_legacy_files[] = {
 	{ }	/* Terminate */
 };
 
-#ifdef CONFIG_RT_GROUP_SCHED
-static struct cftype rt_group_files[] = {
-	{
-		.name = "rt_runtime_us",
-		.read_s64 = cpu_rt_runtime_read,
-		.write_s64 = cpu_rt_runtime_write,
-	},
-	{
-		.name = "rt_period_us",
-		.read_u64 = cpu_rt_period_read_uint,
-		.write_u64 = cpu_rt_period_write_uint,
-	},
-	{ }	/* Terminate */
-};
-
-# ifdef CONFIG_RT_GROUP_SCHED_DEFAULT_DISABLED
-DEFINE_STATIC_KEY_FALSE(rt_group_sched);
-# else
-DEFINE_STATIC_KEY_TRUE(rt_group_sched);
-# endif
-
-static int __init setup_rt_group_sched(char *str)
-{
-	long val;
-
-	if (kstrtol(str, 0, &val) || val < 0 || val > 1) {
-		pr_warn("Unable to set rt_group_sched\n");
-		return 1;
-	}
-	if (val)
-		static_branch_enable(&rt_group_sched);
-	else
-		static_branch_disable(&rt_group_sched);
-
-	return 1;
-}
-__setup("rt_group_sched=", setup_rt_group_sched);
-
-static int __init cpu_rt_group_init(void)
-{
-	if (!rt_group_sched_enabled())
-		return 0;
-
-	WARN_ON(cgroup_add_legacy_cftypes(&cpu_cgrp_subsys, rt_group_files));
-	return 0;
-}
-subsys_initcall(cpu_rt_group_init);
-#endif /* CONFIG_RT_GROUP_SCHED */
 
 static int cpu_extra_stat_show(struct seq_file *sf,
 			       struct cgroup_subsys_state *css)
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index c0ebdcde5fe5d..076a6c2f017bb 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1540,32 +1540,6 @@ static void update_curr_dl_se(struct rq *rq, struct sched_dl_entity *dl_se, s64
 	if (dl_se->dl_server)
 		return;
 
-#ifdef CONFIG_RT_GROUP_SCHED
-	/*
-	 * Because -- for now -- we share the rt bandwidth, we need to
-	 * account our runtime there too, otherwise actual rt tasks
-	 * would be able to exceed the shared quota.
-	 *
-	 * Account to the root rt group for now.
-	 *
-	 * The solution we're working towards is having the RT groups scheduled
-	 * using deadline servers -- however there's a few nasties to figure
-	 * out before that can happen.
-	 */
-	if (rt_bandwidth_enabled()) {
-		struct rt_rq *rt_rq = &rq->rt;
-
-		raw_spin_lock(&rt_rq->rt_runtime_lock);
-		/*
-		 * We'll let actual RT tasks worry about the overflow here, we
-		 * have our own CBS to keep us inline; only account when RT
-		 * bandwidth is relevant.
-		 */
-		if (sched_rt_bandwidth_account(rt_rq))
-			rt_rq->rt_time += delta_exec;
-		raw_spin_unlock(&rt_rq->rt_runtime_lock);
-	}
-#endif /* CONFIG_RT_GROUP_SCHED */
 }
 
 /*
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index e6a3b516c703b..b5c203925d075 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -1127,13 +1127,8 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 
 void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 {
-#ifdef CONFIG_RT_GROUP_SCHED
-	SEQ_printf(m, "\n");
-	SEQ_printf_task_group_path(m, rt_rq->tg, "rt_rq[%d]:%s\n", cpu);
-#else
 	SEQ_printf(m, "\n");
 	SEQ_printf(m, "rt_rq[%d]:\n", cpu);
-#endif
 
 #define P(x) \
 	SEQ_printf(m, "  .%-30s: %Ld\n", #x, (long long)(rt_rq->x))
@@ -1144,11 +1139,6 @@ void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 
 	PU(rt_nr_running);
 
-#ifdef CONFIG_RT_GROUP_SCHED
-	P(rt_throttled);
-	PN(rt_time);
-	PN(rt_runtime);
-#endif
 
 #undef PN
 #undef PU
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 8f0dee8fc4755..729ec5ee2e399 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -122,7 +122,6 @@ SCHED_FEAT(RT_PUSH_IPI, false)
 # endif
 #endif
 
-SCHED_FEAT(RT_RUNTIME_SHARE, false)
 SCHED_FEAT(LB_MIN, false)
 SCHED_FEAT(ATTACH_AGE_LOAD, true)
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 1535046a23ffa..1266f173211cb 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -85,214 +85,8 @@ void init_rt_rq(struct rt_rq *rt_rq)
 	/* We start is dequeued state, because no RT tasks are queued */
 	rt_rq->rt_queued = 0;
 
-#ifdef CONFIG_RT_GROUP_SCHED
-	rt_rq->rt_time = 0;
-	rt_rq->rt_throttled = 0;
-	rt_rq->rt_runtime = 0;
-	raw_spin_lock_init(&rt_rq->rt_runtime_lock);
-	rt_rq->tg = &root_task_group;
-#endif
 }
 
-#ifdef CONFIG_RT_GROUP_SCHED
-
-static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun);
-
-static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
-{
-	struct rt_bandwidth *rt_b =
-		container_of(timer, struct rt_bandwidth, rt_period_timer);
-	int idle = 0;
-	int overrun;
-
-	raw_spin_lock(&rt_b->rt_runtime_lock);
-	for (;;) {
-		overrun = hrtimer_forward_now(timer, rt_b->rt_period);
-		if (!overrun)
-			break;
-
-		raw_spin_unlock(&rt_b->rt_runtime_lock);
-		idle = do_sched_rt_period_timer(rt_b, overrun);
-		raw_spin_lock(&rt_b->rt_runtime_lock);
-	}
-	if (idle)
-		rt_b->rt_period_active = 0;
-	raw_spin_unlock(&rt_b->rt_runtime_lock);
-
-	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
-}
-
-void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime)
-{
-	rt_b->rt_period = ns_to_ktime(period);
-	rt_b->rt_runtime = runtime;
-
-	raw_spin_lock_init(&rt_b->rt_runtime_lock);
-
-	hrtimer_setup(&rt_b->rt_period_timer, sched_rt_period_timer, CLOCK_MONOTONIC,
-		      HRTIMER_MODE_REL_HARD);
-}
-
-static inline void do_start_rt_bandwidth(struct rt_bandwidth *rt_b)
-{
-	raw_spin_lock(&rt_b->rt_runtime_lock);
-	if (!rt_b->rt_period_active) {
-		rt_b->rt_period_active = 1;
-		/*
-		 * SCHED_DEADLINE updates the bandwidth, as a run away
-		 * RT task with a DL task could hog a CPU. But DL does
-		 * not reset the period. If a deadline task was running
-		 * without an RT task running, it can cause RT tasks to
-		 * throttle when they start up. Kick the timer right away
-		 * to update the period.
-		 */
-		hrtimer_forward_now(&rt_b->rt_period_timer, ns_to_ktime(0));
-		hrtimer_start_expires(&rt_b->rt_period_timer,
-				      HRTIMER_MODE_ABS_PINNED_HARD);
-	}
-	raw_spin_unlock(&rt_b->rt_runtime_lock);
-}
-
-static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
-{
-	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
-		return;
-
-	do_start_rt_bandwidth(rt_b);
-}
-
-static void destroy_rt_bandwidth(struct rt_bandwidth *rt_b)
-{
-	hrtimer_cancel(&rt_b->rt_period_timer);
-}
-
-#define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
-
-static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
-{
-	WARN_ON_ONCE(!rt_entity_is_task(rt_se));
-
-	return container_of(rt_se, struct task_struct, rt);
-}
-
-static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
-{
-	/* Cannot fold with non-CONFIG_RT_GROUP_SCHED version, layout */
-	WARN_ON(!rt_group_sched_enabled() && rt_rq->tg != &root_task_group);
-	return rt_rq->rq;
-}
-
-static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
-{
-	WARN_ON(!rt_group_sched_enabled() && rt_se->rt_rq->tg != &root_task_group);
-	return rt_se->rt_rq;
-}
-
-static inline struct rq *rq_of_rt_se(struct sched_rt_entity *rt_se)
-{
-	struct rt_rq *rt_rq = rt_se->rt_rq;
-
-	WARN_ON(!rt_group_sched_enabled() && rt_rq->tg != &root_task_group);
-	return rt_rq->rq;
-}
-
-void unregister_rt_sched_group(struct task_group *tg)
-{
-	if (!rt_group_sched_enabled())
-		return;
-
-	if (tg->rt_se)
-		destroy_rt_bandwidth(&tg->rt_bandwidth);
-}
-
-void free_rt_sched_group(struct task_group *tg)
-{
-	int i;
-
-	if (!rt_group_sched_enabled())
-		return;
-
-	for_each_possible_cpu(i) {
-		if (tg->rt_rq)
-			kfree(tg->rt_rq[i]);
-		if (tg->rt_se)
-			kfree(tg->rt_se[i]);
-	}
-
-	kfree(tg->rt_rq);
-	kfree(tg->rt_se);
-}
-
-void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
-		struct sched_rt_entity *rt_se, int cpu,
-		struct sched_rt_entity *parent)
-{
-	struct rq *rq = cpu_rq(cpu);
-
-	rt_rq->highest_prio.curr = MAX_RT_PRIO-1;
-	rt_rq->rt_nr_boosted = 0;
-	rt_rq->rq = rq;
-	rt_rq->tg = tg;
-
-	tg->rt_rq[cpu] = rt_rq;
-	tg->rt_se[cpu] = rt_se;
-
-	if (!rt_se)
-		return;
-
-	if (!parent)
-		rt_se->rt_rq = &rq->rt;
-	else
-		rt_se->rt_rq = parent->my_q;
-
-	rt_se->my_q = rt_rq;
-	rt_se->parent = parent;
-	INIT_LIST_HEAD(&rt_se->run_list);
-}
-
-int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
-{
-	struct rt_rq *rt_rq;
-	struct sched_rt_entity *rt_se;
-	int i;
-
-	if (!rt_group_sched_enabled())
-		return 1;
-
-	tg->rt_rq = kzalloc_objs(rt_rq, nr_cpu_ids);
-	if (!tg->rt_rq)
-		goto err;
-	tg->rt_se = kzalloc_objs(rt_se, nr_cpu_ids);
-	if (!tg->rt_se)
-		goto err;
-
-	init_rt_bandwidth(&tg->rt_bandwidth, ktime_to_ns(global_rt_period()), 0);
-
-	for_each_possible_cpu(i) {
-		rt_rq = kzalloc_node(sizeof(struct rt_rq),
-				     GFP_KERNEL, cpu_to_node(i));
-		if (!rt_rq)
-			goto err;
-
-		rt_se = kzalloc_node(sizeof(struct sched_rt_entity),
-				     GFP_KERNEL, cpu_to_node(i));
-		if (!rt_se)
-			goto err_free_rq;
-
-		init_rt_rq(rt_rq);
-		rt_rq->rt_runtime = tg->rt_bandwidth.rt_runtime;
-		init_tg_rt_entry(tg, rt_rq, rt_se, i, parent->rt_se[i]);
-	}
-
-	return 1;
-
-err_free_rq:
-	kfree(rt_rq);
-err:
-	return 0;
-}
-
-#else /* !CONFIG_RT_GROUP_SCHED: */
 
 #define rt_entity_is_task(rt_se) (1)
 
@@ -328,7 +122,6 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 {
 	return 1;
 }
-#endif /* !CONFIG_RT_GROUP_SCHED */
 
 static inline bool need_pull_rt_task(struct rq *rq, struct task_struct *prev)
 {
@@ -476,434 +269,6 @@ static inline bool rt_task_fits_capacity(struct task_struct *p, int cpu)
 }
 #endif /* !CONFIG_UCLAMP_TASK */
 
-#ifdef CONFIG_RT_GROUP_SCHED
-
-static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
-{
-	return rt_rq->rt_runtime;
-}
-
-static inline u64 sched_rt_period(struct rt_rq *rt_rq)
-{
-	return ktime_to_ns(rt_rq->tg->rt_bandwidth.rt_period);
-}
-
-typedef struct task_group *rt_rq_iter_t;
-
-static inline struct task_group *next_task_group(struct task_group *tg)
-{
-	if (!rt_group_sched_enabled()) {
-		WARN_ON(tg != &root_task_group);
-		return NULL;
-	}
-
-	do {
-		tg = list_entry_rcu(tg->list.next,
-			typeof(struct task_group), list);
-	} while (&tg->list != &task_groups && task_group_is_autogroup(tg));
-
-	if (&tg->list == &task_groups)
-		tg = NULL;
-
-	return tg;
-}
-
-#define for_each_rt_rq(rt_rq, iter, rq)					\
-	for (iter = &root_task_group;					\
-		iter && (rt_rq = iter->rt_rq[cpu_of(rq)]);		\
-		iter = next_task_group(iter))
-
-#define for_each_sched_rt_entity(rt_se) \
-	for (; rt_se; rt_se = rt_se->parent)
-
-static inline struct rt_rq *group_rt_rq(struct sched_rt_entity *rt_se)
-{
-	return rt_se->my_q;
-}
-
-static void enqueue_rt_entity(struct sched_rt_entity *rt_se, unsigned int flags);
-static void dequeue_rt_entity(struct sched_rt_entity *rt_se, unsigned int flags);
-
-static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
-{
-	struct task_struct *donor = rq_of_rt_rq(rt_rq)->donor;
-	struct rq *rq = rq_of_rt_rq(rt_rq);
-	struct sched_rt_entity *rt_se;
-
-	int cpu = cpu_of(rq);
-
-	rt_se = rt_rq->tg->rt_se[cpu];
-
-	if (rt_rq->rt_nr_running) {
-		if (!rt_se)
-			enqueue_top_rt_rq(rt_rq);
-		else if (!on_rt_rq(rt_se))
-			enqueue_rt_entity(rt_se, 0);
-
-		if (rt_rq->highest_prio.curr < donor->prio)
-			resched_curr(rq);
-	}
-}
-
-static void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
-{
-	struct sched_rt_entity *rt_se;
-	int cpu = cpu_of(rq_of_rt_rq(rt_rq));
-
-	rt_se = rt_rq->tg->rt_se[cpu];
-
-	if (!rt_se) {
-		dequeue_top_rt_rq(rt_rq, rt_rq->rt_nr_running);
-		/* Kick cpufreq (see the comment in kernel/sched/sched.h). */
-		cpufreq_update_util(rq_of_rt_rq(rt_rq), 0);
-	}
-	else if (on_rt_rq(rt_se))
-		dequeue_rt_entity(rt_se, 0);
-}
-
-static inline int rt_rq_throttled(struct rt_rq *rt_rq)
-{
-	return rt_rq->rt_throttled && !rt_rq->rt_nr_boosted;
-}
-
-static int rt_se_boosted(struct sched_rt_entity *rt_se)
-{
-	struct rt_rq *rt_rq = group_rt_rq(rt_se);
-	struct task_struct *p;
-
-	if (rt_rq)
-		return !!rt_rq->rt_nr_boosted;
-
-	p = rt_task_of(rt_se);
-	return p->prio != p->normal_prio;
-}
-
-static inline const struct cpumask *sched_rt_period_mask(void)
-{
-	return this_rq()->rd->span;
-}
-
-static inline
-struct rt_rq *sched_rt_period_rt_rq(struct rt_bandwidth *rt_b, int cpu)
-{
-	return container_of(rt_b, struct task_group, rt_bandwidth)->rt_rq[cpu];
-}
-
-static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
-{
-	return &rt_rq->tg->rt_bandwidth;
-}
-
-bool sched_rt_bandwidth_account(struct rt_rq *rt_rq)
-{
-	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
-
-	return (hrtimer_active(&rt_b->rt_period_timer) ||
-		rt_rq->rt_time < rt_b->rt_runtime);
-}
-
-/*
- * We ran out of runtime, see if we can borrow some from our neighbours.
- */
-static void do_balance_runtime(struct rt_rq *rt_rq)
-{
-	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
-	struct root_domain *rd = rq_of_rt_rq(rt_rq)->rd;
-	int i, weight;
-	u64 rt_period;
-
-	weight = cpumask_weight(rd->span);
-
-	raw_spin_lock(&rt_b->rt_runtime_lock);
-	rt_period = ktime_to_ns(rt_b->rt_period);
-	for_each_cpu(i, rd->span) {
-		struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
-		s64 diff;
-
-		if (iter == rt_rq)
-			continue;
-
-		raw_spin_lock(&iter->rt_runtime_lock);
-		/*
-		 * Either all rqs have inf runtime and there's nothing to steal
-		 * or __disable_runtime() below sets a specific rq to inf to
-		 * indicate its been disabled and disallow stealing.
-		 */
-		if (iter->rt_runtime == RUNTIME_INF)
-			goto next;
-
-		/*
-		 * From runqueues with spare time, take 1/n part of their
-		 * spare time, but no more than our period.
-		 */
-		diff = iter->rt_runtime - iter->rt_time;
-		if (diff > 0) {
-			diff = div_u64((u64)diff, weight);
-			if (rt_rq->rt_runtime + diff > rt_period)
-				diff = rt_period - rt_rq->rt_runtime;
-			iter->rt_runtime -= diff;
-			rt_rq->rt_runtime += diff;
-			if (rt_rq->rt_runtime == rt_period) {
-				raw_spin_unlock(&iter->rt_runtime_lock);
-				break;
-			}
-		}
-next:
-		raw_spin_unlock(&iter->rt_runtime_lock);
-	}
-	raw_spin_unlock(&rt_b->rt_runtime_lock);
-}
-
-/*
- * Ensure this RQ takes back all the runtime it lend to its neighbours.
- */
-static void __disable_runtime(struct rq *rq)
-{
-	struct root_domain *rd = rq->rd;
-	rt_rq_iter_t iter;
-	struct rt_rq *rt_rq;
-
-	if (unlikely(!scheduler_running))
-		return;
-
-	for_each_rt_rq(rt_rq, iter, rq) {
-		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
-		s64 want;
-		int i;
-
-		raw_spin_lock(&rt_b->rt_runtime_lock);
-		raw_spin_lock(&rt_rq->rt_runtime_lock);
-		/*
-		 * Either we're all inf and nobody needs to borrow, or we're
-		 * already disabled and thus have nothing to do, or we have
-		 * exactly the right amount of runtime to take out.
-		 */
-		if (rt_rq->rt_runtime == RUNTIME_INF ||
-				rt_rq->rt_runtime == rt_b->rt_runtime)
-			goto balanced;
-		raw_spin_unlock(&rt_rq->rt_runtime_lock);
-
-		/*
-		 * Calculate the difference between what we started out with
-		 * and what we current have, that's the amount of runtime
-		 * we lend and now have to reclaim.
-		 */
-		want = rt_b->rt_runtime - rt_rq->rt_runtime;
-
-		/*
-		 * Greedy reclaim, take back as much as we can.
-		 */
-		for_each_cpu(i, rd->span) {
-			struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
-			s64 diff;
-
-			/*
-			 * Can't reclaim from ourselves or disabled runqueues.
-			 */
-			if (iter == rt_rq || iter->rt_runtime == RUNTIME_INF)
-				continue;
-
-			raw_spin_lock(&iter->rt_runtime_lock);
-			if (want > 0) {
-				diff = min_t(s64, iter->rt_runtime, want);
-				iter->rt_runtime -= diff;
-				want -= diff;
-			} else {
-				iter->rt_runtime -= want;
-				want -= want;
-			}
-			raw_spin_unlock(&iter->rt_runtime_lock);
-
-			if (!want)
-				break;
-		}
-
-		raw_spin_lock(&rt_rq->rt_runtime_lock);
-		/*
-		 * We cannot be left wanting - that would mean some runtime
-		 * leaked out of the system.
-		 */
-		WARN_ON_ONCE(want);
-balanced:
-		/*
-		 * Disable all the borrow logic by pretending we have inf
-		 * runtime - in which case borrowing doesn't make sense.
-		 */
-		rt_rq->rt_runtime = RUNTIME_INF;
-		rt_rq->rt_throttled = 0;
-		raw_spin_unlock(&rt_rq->rt_runtime_lock);
-		raw_spin_unlock(&rt_b->rt_runtime_lock);
-
-		/* Make rt_rq available for pick_next_task() */
-		sched_rt_rq_enqueue(rt_rq);
-	}
-}
-
-static void __enable_runtime(struct rq *rq)
-{
-	rt_rq_iter_t iter;
-	struct rt_rq *rt_rq;
-
-	if (unlikely(!scheduler_running))
-		return;
-
-	/*
-	 * Reset each runqueue's bandwidth settings
-	 */
-	for_each_rt_rq(rt_rq, iter, rq) {
-		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
-
-		raw_spin_lock(&rt_b->rt_runtime_lock);
-		raw_spin_lock(&rt_rq->rt_runtime_lock);
-		rt_rq->rt_runtime = rt_b->rt_runtime;
-		rt_rq->rt_time = 0;
-		rt_rq->rt_throttled = 0;
-		raw_spin_unlock(&rt_rq->rt_runtime_lock);
-		raw_spin_unlock(&rt_b->rt_runtime_lock);
-	}
-}
-
-static void balance_runtime(struct rt_rq *rt_rq)
-{
-	if (!sched_feat(RT_RUNTIME_SHARE))
-		return;
-
-	if (rt_rq->rt_time > rt_rq->rt_runtime) {
-		raw_spin_unlock(&rt_rq->rt_runtime_lock);
-		do_balance_runtime(rt_rq);
-		raw_spin_lock(&rt_rq->rt_runtime_lock);
-	}
-}
-
-static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
-{
-	int i, idle = 1, throttled = 0;
-	const struct cpumask *span;
-
-	span = sched_rt_period_mask();
-
-	/*
-	 * FIXME: isolated CPUs should really leave the root task group,
-	 * whether they are isolcpus or were isolated via cpusets, lest
-	 * the timer run on a CPU which does not service all runqueues,
-	 * potentially leaving other CPUs indefinitely throttled.  If
-	 * isolation is really required, the user will turn the throttle
-	 * off to kill the perturbations it causes anyway.  Meanwhile,
-	 * this maintains functionality for boot and/or troubleshooting.
-	 */
-	if (rt_b == &root_task_group.rt_bandwidth)
-		span = cpu_online_mask;
-
-	for_each_cpu(i, span) {
-		int enqueue = 0;
-		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);
-		struct rq *rq = rq_of_rt_rq(rt_rq);
-		struct rq_flags rf;
-		int skip;
-
-		/*
-		 * When span == cpu_online_mask, taking each rq->lock
-		 * can be time-consuming. Try to avoid it when possible.
-		 */
-		raw_spin_lock(&rt_rq->rt_runtime_lock);
-		if (!sched_feat(RT_RUNTIME_SHARE) && rt_rq->rt_runtime != RUNTIME_INF)
-			rt_rq->rt_runtime = rt_b->rt_runtime;
-		skip = !rt_rq->rt_time && !rt_rq->rt_nr_running;
-		raw_spin_unlock(&rt_rq->rt_runtime_lock);
-		if (skip)
-			continue;
-
-		rq_lock(rq, &rf);
-		update_rq_clock(rq);
-
-		if (rt_rq->rt_time) {
-			u64 runtime;
-
-			raw_spin_lock(&rt_rq->rt_runtime_lock);
-			if (rt_rq->rt_throttled)
-				balance_runtime(rt_rq);
-			runtime = rt_rq->rt_runtime;
-			rt_rq->rt_time -= min(rt_rq->rt_time, overrun*runtime);
-			if (rt_rq->rt_throttled && rt_rq->rt_time < runtime) {
-				rt_rq->rt_throttled = 0;
-				enqueue = 1;
-
-				/*
-				 * When we're idle and a woken (rt) task is
-				 * throttled wakeup_preempt() will set
-				 * skip_update and the time between the wakeup
-				 * and this unthrottle will get accounted as
-				 * 'runtime'.
-				 */
-				if (rt_rq->rt_nr_running && rq->curr == rq->idle)
-					rq_clock_cancel_skipupdate(rq);
-			}
-			if (rt_rq->rt_time || rt_rq->rt_nr_running)
-				idle = 0;
-			raw_spin_unlock(&rt_rq->rt_runtime_lock);
-		} else if (rt_rq->rt_nr_running) {
-			idle = 0;
-			if (!rt_rq_throttled(rt_rq))
-				enqueue = 1;
-		}
-		if (rt_rq->rt_throttled)
-			throttled = 1;
-
-		if (enqueue)
-			sched_rt_rq_enqueue(rt_rq);
-		rq_unlock(rq, &rf);
-	}
-
-	if (!throttled && (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF))
-		return 1;
-
-	return idle;
-}
-
-static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
-{
-	u64 runtime = sched_rt_runtime(rt_rq);
-
-	if (rt_rq->rt_throttled)
-		return rt_rq_throttled(rt_rq);
-
-	if (runtime >= sched_rt_period(rt_rq))
-		return 0;
-
-	balance_runtime(rt_rq);
-	runtime = sched_rt_runtime(rt_rq);
-	if (runtime == RUNTIME_INF)
-		return 0;
-
-	if (rt_rq->rt_time > runtime) {
-		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
-
-		/*
-		 * Don't actually throttle groups that have no runtime assigned
-		 * but accrue some time due to boosting.
-		 */
-		if (likely(rt_b->rt_runtime)) {
-			rt_rq->rt_throttled = 1;
-			printk_deferred_once("sched: RT throttling activated\n");
-		} else {
-			/*
-			 * In case we did anyway, make it go away,
-			 * replenishment is a joke, since it will replenish us
-			 * with exactly 0 ns.
-			 */
-			rt_rq->rt_time = 0;
-		}
-
-		if (rt_rq_throttled(rt_rq)) {
-			sched_rt_rq_dequeue(rt_rq);
-			return 1;
-		}
-	}
-
-	return 0;
-}
-
-#else /* !CONFIG_RT_GROUP_SCHED: */
 
 typedef struct rt_rq *rt_rq_iter_t;
 
@@ -944,25 +309,12 @@ static inline const struct cpumask *sched_rt_period_mask(void)
 	return cpu_online_mask;
 }
 
-static inline
-struct rt_rq *sched_rt_period_rt_rq(struct rt_bandwidth *rt_b, int cpu)
-{
-	return &cpu_rq(cpu)->rt;
-}
-
 static void __enable_runtime(struct rq *rq) { }
 static void __disable_runtime(struct rq *rq) { }
 
-#endif /* !CONFIG_RT_GROUP_SCHED */
 
 static inline int rt_se_prio(struct sched_rt_entity *rt_se)
 {
-#ifdef CONFIG_RT_GROUP_SCHED
-	struct rt_rq *rt_rq = group_rt_rq(rt_se);
-
-	if (rt_rq)
-		return rt_rq->highest_prio.curr;
-#endif
 
 	return rt_task_of(rt_se)->prio;
 }
@@ -983,28 +335,6 @@ static void update_curr_rt(struct rq *rq)
 	if (unlikely(delta_exec <= 0))
 		return;
 
-#ifdef CONFIG_RT_GROUP_SCHED
-	struct sched_rt_entity *rt_se = &donor->rt;
-
-	if (!rt_bandwidth_enabled())
-		return;
-
-	for_each_sched_rt_entity(rt_se) {
-		struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
-		int exceeded;
-
-		if (sched_rt_runtime(rt_rq) != RUNTIME_INF) {
-			raw_spin_lock(&rt_rq->rt_runtime_lock);
-			rt_rq->rt_time += delta_exec;
-			exceeded = sched_rt_runtime_exceeded(rt_rq);
-			if (exceeded)
-				resched_curr(rq);
-			raw_spin_unlock(&rt_rq->rt_runtime_lock);
-			if (exceeded)
-				do_start_rt_bandwidth(sched_rt_bandwidth(rt_rq));
-		}
-	}
-#endif /* CONFIG_RT_GROUP_SCHED */
 }
 
 static void
@@ -1051,12 +381,6 @@ inc_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
 {
 	struct rq *rq = rq_of_rt_rq(rt_rq);
 
-	/*
-	 * Change rq's cpupri only if rt_rq is the top queue.
-	 */
-	if (IS_ENABLED(CONFIG_RT_GROUP_SCHED) && &rq->rt != rt_rq)
-		return;
-
 	if (rq->online && prio < prev_prio)
 		cpupri_set(&rq->rd->cpupri, rq->cpu, prio);
 }
@@ -1066,12 +390,6 @@ dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
 {
 	struct rq *rq = rq_of_rt_rq(rt_rq);
 
-	/*
-	 * Change rq's cpupri only if rt_rq is the top queue.
-	 */
-	if (IS_ENABLED(CONFIG_RT_GROUP_SCHED) && &rq->rt != rt_rq)
-		return;
-
 	if (rq->online && rt_rq->highest_prio.curr != prev_prio)
 		cpupri_set(&rq->rd->cpupri, rq->cpu, rt_rq->highest_prio.curr);
 }
@@ -1114,27 +432,6 @@ dec_rt_prio(struct rt_rq *rt_rq, int prio)
 	dec_rt_prio_smp(rt_rq, prio, prev_prio);
 }
 
-#ifdef CONFIG_RT_GROUP_SCHED
-
-static void
-inc_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
-{
-	if (rt_se_boosted(rt_se))
-		rt_rq->rt_nr_boosted++;
-
-	start_rt_bandwidth(&rt_rq->tg->rt_bandwidth);
-}
-
-static void
-dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
-{
-	if (rt_se_boosted(rt_se))
-		rt_rq->rt_nr_boosted--;
-
-	WARN_ON(!rt_rq->rt_nr_running && rt_rq->rt_nr_boosted);
-}
-
-#else /* !CONFIG_RT_GROUP_SCHED: */
 
 static void
 inc_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
@@ -1144,7 +441,6 @@ inc_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 static inline
 void dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq) {}
 
-#endif /* !CONFIG_RT_GROUP_SCHED */
 
 static inline
 unsigned int rt_se_nr_running(struct sched_rt_entity *rt_se)
@@ -2591,12 +1887,7 @@ static int task_is_throttled_rt(struct task_struct *p, int cpu)
 {
 	struct rt_rq *rt_rq;
 
-#ifdef CONFIG_RT_GROUP_SCHED // XXX maybe add task_rt_rq(), see also sched_rt_period_rt_rq
-	rt_rq = task_group(p)->rt_rq[cpu];
-	WARN_ON(!rt_group_sched_enabled() && rt_rq->tg != &root_task_group);
-#else
 	rt_rq = &cpu_rq(cpu)->rt;
-#endif
 
 	return rt_rq_throttled(rt_rq);
 }
@@ -2640,215 +1931,6 @@ DEFINE_SCHED_CLASS(rt) = {
 #endif
 };
 
-#ifdef CONFIG_RT_GROUP_SCHED
-/*
- * Ensure that the real time constraints are schedulable.
- */
-static DEFINE_MUTEX(rt_constraints_mutex);
-
-static inline int tg_has_rt_tasks(struct task_group *tg)
-{
-	struct task_struct *task;
-	struct css_task_iter it;
-	int ret = 0;
-
-	/*
-	 * Autogroups do not have RT tasks; see autogroup_create().
-	 */
-	if (task_group_is_autogroup(tg))
-		return 0;
-
-	css_task_iter_start(&tg->css, 0, &it);
-	while (!ret && (task = css_task_iter_next(&it)))
-		ret |= rt_task(task);
-	css_task_iter_end(&it);
-
-	return ret;
-}
-
-struct rt_schedulable_data {
-	struct task_group *tg;
-	u64 rt_period;
-	u64 rt_runtime;
-};
-
-static int tg_rt_schedulable(struct task_group *tg, void *data)
-{
-	struct rt_schedulable_data *d = data;
-	struct task_group *child;
-	u64 total, sum = 0;
-	u64 period, runtime;
-
-	period = ktime_to_ns(tg->rt_bandwidth.rt_period);
-	runtime = tg->rt_bandwidth.rt_runtime;
-
-	if (tg == d->tg) {
-		period = d->rt_period;
-		runtime = d->rt_runtime;
-	}
-
-	/*
-	 * Cannot have more runtime than the period.
-	 */
-	if (runtime > period && runtime != RUNTIME_INF)
-		return -EINVAL;
-
-	/*
-	 * Ensure we don't starve existing RT tasks if runtime turns zero.
-	 */
-	if (rt_bandwidth_enabled() && !runtime &&
-	    tg->rt_bandwidth.rt_runtime && tg_has_rt_tasks(tg))
-		return -EBUSY;
-
-	total = to_ratio(period, runtime);
-
-	/*
-	 * Nobody can have more than the global setting allows.
-	 */
-	if (total > to_ratio(global_rt_period(), global_rt_runtime()))
-		return -EINVAL;
-
-	/*
-	 * The sum of our children's runtime should not exceed our own.
-	 */
-	list_for_each_entry_rcu(child, &tg->children, siblings) {
-		period = ktime_to_ns(child->rt_bandwidth.rt_period);
-		runtime = child->rt_bandwidth.rt_runtime;
-
-		if (child == d->tg) {
-			period = d->rt_period;
-			runtime = d->rt_runtime;
-		}
-
-		sum += to_ratio(period, runtime);
-	}
-
-	if (sum > total)
-		return -EINVAL;
-
-	return 0;
-}
-
-static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
-{
-	int ret;
-
-	struct rt_schedulable_data data = {
-		.tg = tg,
-		.rt_period = period,
-		.rt_runtime = runtime,
-	};
-
-	rcu_read_lock();
-	ret = walk_tg_tree(tg_rt_schedulable, tg_nop, &data);
-	rcu_read_unlock();
-
-	return ret;
-}
-
-static int tg_set_rt_bandwidth(struct task_group *tg,
-		u64 rt_period, u64 rt_runtime)
-{
-	int i, err = 0;
-
-	/*
-	 * Disallowing the root group RT runtime is BAD, it would disallow the
-	 * kernel creating (and or operating) RT threads.
-	 */
-	if (tg == &root_task_group && rt_runtime == 0)
-		return -EINVAL;
-
-	/* No period doesn't make any sense. */
-	if (rt_period == 0)
-		return -EINVAL;
-
-	/*
-	 * Bound quota to defend quota against overflow during bandwidth shift.
-	 */
-	if (rt_runtime != RUNTIME_INF && rt_runtime > max_rt_runtime)
-		return -EINVAL;
-
-	mutex_lock(&rt_constraints_mutex);
-	err = __rt_schedulable(tg, rt_period, rt_runtime);
-	if (err)
-		goto unlock;
-
-	raw_spin_lock_irq(&tg->rt_bandwidth.rt_runtime_lock);
-	tg->rt_bandwidth.rt_period = ns_to_ktime(rt_period);
-	tg->rt_bandwidth.rt_runtime = rt_runtime;
-
-	for_each_possible_cpu(i) {
-		struct rt_rq *rt_rq = tg->rt_rq[i];
-
-		raw_spin_lock(&rt_rq->rt_runtime_lock);
-		rt_rq->rt_runtime = rt_runtime;
-		raw_spin_unlock(&rt_rq->rt_runtime_lock);
-	}
-	raw_spin_unlock_irq(&tg->rt_bandwidth.rt_runtime_lock);
-unlock:
-	mutex_unlock(&rt_constraints_mutex);
-
-	return err;
-}
-
-int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
-{
-	u64 rt_runtime, rt_period;
-
-	rt_period = ktime_to_ns(tg->rt_bandwidth.rt_period);
-	rt_runtime = (u64)rt_runtime_us * NSEC_PER_USEC;
-	if (rt_runtime_us < 0)
-		rt_runtime = RUNTIME_INF;
-	else if ((u64)rt_runtime_us > U64_MAX / NSEC_PER_USEC)
-		return -EINVAL;
-
-	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
-}
-
-long sched_group_rt_runtime(struct task_group *tg)
-{
-	u64 rt_runtime_us;
-
-	if (tg->rt_bandwidth.rt_runtime == RUNTIME_INF)
-		return -1;
-
-	rt_runtime_us = tg->rt_bandwidth.rt_runtime;
-	do_div(rt_runtime_us, NSEC_PER_USEC);
-	return rt_runtime_us;
-}
-
-int sched_group_set_rt_period(struct task_group *tg, u64 rt_period_us)
-{
-	u64 rt_runtime, rt_period;
-
-	if (rt_period_us > U64_MAX / NSEC_PER_USEC)
-		return -EINVAL;
-
-	rt_period = rt_period_us * NSEC_PER_USEC;
-	rt_runtime = tg->rt_bandwidth.rt_runtime;
-
-	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
-}
-
-long sched_group_rt_period(struct task_group *tg)
-{
-	u64 rt_period_us;
-
-	rt_period_us = ktime_to_ns(tg->rt_bandwidth.rt_period);
-	do_div(rt_period_us, NSEC_PER_USEC);
-	return rt_period_us;
-}
-
-int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk)
-{
-	/* Don't accept real-time tasks when there is no way for them to run */
-	if (rt_group_sched_enabled() && rt_task(tsk) && tg->rt_bandwidth.rt_runtime == 0)
-		return 0;
-
-	return 1;
-}
-
-#endif /* !CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_SYSCTL
 static int sched_rt_global_validate(void)
@@ -2859,13 +1941,6 @@ static int sched_rt_global_validate(void)
 			NSEC_PER_USEC > max_rt_runtime)))
 		return -EINVAL;
 
-#ifdef CONFIG_RT_GROUP_SCHED
-	if (!rt_group_sched_enabled())
-		return 0;
-
-	scoped_guard(mutex, &rt_constraints_mutex)
-		return __rt_schedulable(NULL, 0, 0);
-#endif
 	return 0;
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 6c7c5633524a3..b5aabceabde8e 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -313,15 +313,6 @@ struct rt_prio_array {
 	struct list_head queue[MAX_RT_PRIO];
 };
 
-struct rt_bandwidth {
-	/* nests inside the rq lock: */
-	raw_spinlock_t		rt_runtime_lock;
-	ktime_t			rt_period;
-	u64			rt_runtime;
-	struct hrtimer		rt_period_timer;
-	unsigned int		rt_period_active;
-};
-
 static inline int dl_bandwidth_enabled(void)
 {
 	return sysctl_sched_rt_runtime >= 0;
@@ -334,11 +325,9 @@ static inline int dl_bandwidth_enabled(void)
  *  - cache the fraction of bandwidth that is currently allocated in
  *    each root domain;
  *
- * This is all done in the data structure below. It is similar to the
- * one used for RT-throttling (rt_bandwidth), with the main difference
- * that, since here we are only interested in admission control, we
- * do not decrease any runtime while the group "executes", neither we
- * need a timer to replenish it.
+ * This is all done in the data structure below. We are only interested in
+ * admission control, we do not decrease any runtime while the group
+ * "executes", neither we need a timer to replenish it.
  *
  * With respect to SMP, bandwidth is given on a per root domain basis,
  * meaning that:
@@ -497,12 +486,6 @@ struct task_group {
 
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-#ifdef CONFIG_RT_GROUP_SCHED
-	struct sched_rt_entity	**rt_se;
-	struct rt_rq		**rt_rq;
-
-	struct rt_bandwidth	rt_bandwidth;
-#endif
 
 	struct scx_task_group	scx;
 
@@ -581,15 +564,6 @@ extern void start_cfs_bandwidth(struct cfs_bandwidth *cfs_b);
 extern void unthrottle_cfs_rq(struct cfs_rq *cfs_rq);
 extern bool cfs_task_bw_constrained(struct task_struct *p);
 
-extern void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
-		struct sched_rt_entity *rt_se, int cpu,
-		struct sched_rt_entity *parent);
-extern int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us);
-extern int sched_group_set_rt_period(struct task_group *tg, u64 rt_period_us);
-extern long sched_group_rt_runtime(struct task_group *tg);
-extern long sched_group_rt_period(struct task_group *tg);
-extern int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk);
-
 extern struct task_group *sched_create_group(struct task_group *parent);
 extern void sched_online_group(struct task_group *tg,
 			       struct task_group *parent);
@@ -869,11 +843,6 @@ struct scx_rq {
 };
 #endif /* CONFIG_SCHED_CLASS_EXT */
 
-static inline int rt_bandwidth_enabled(void)
-{
-	return sysctl_sched_rt_runtime >= 0;
-}
-
 /* RT IPI pull logic requires IRQ_WORK */
 #if defined(CONFIG_IRQ_WORK) && defined(CONFIG_SMP)
 # define HAVE_RT_PUSH_IPI
@@ -893,17 +862,6 @@ struct rt_rq {
 
 	int			rt_queued;
 
-#ifdef CONFIG_RT_GROUP_SCHED
-	int			rt_throttled;
-	u64			rt_time; /* consumed RT time, goes up in update_curr_rt */
-	u64			rt_runtime; /* allotted RT time, "slice" from rt_bandwidth, RT sharing/balancing */
-	/* Nests inside the rq lock: */
-	raw_spinlock_t		rt_runtime_lock;
-
-	unsigned int		rt_nr_boosted;
-
-	struct rq		*rq; /* this is always top-level rq, cache? */
-#endif
 #ifdef CONFIG_CGROUP_SCHED
 	struct task_group	*tg; /* this tg has "this" rt_rq on given CPU for runnable entities */
 #endif
@@ -1663,24 +1621,6 @@ static inline bool task_has_sched_core(struct task_struct *p)
 
 #endif /* !CONFIG_SCHED_CORE */
 
-#ifdef CONFIG_RT_GROUP_SCHED
-# ifdef CONFIG_RT_GROUP_SCHED_DEFAULT_DISABLED
-DECLARE_STATIC_KEY_FALSE(rt_group_sched);
-static inline bool rt_group_sched_enabled(void)
-{
-	return static_branch_unlikely(&rt_group_sched);
-}
-# else /* !CONFIG_RT_GROUP_SCHED_DEFAULT_DISABLED: */
-DECLARE_STATIC_KEY_TRUE(rt_group_sched);
-static inline bool rt_group_sched_enabled(void)
-{
-	return static_branch_likely(&rt_group_sched);
-}
-# endif /* !CONFIG_RT_GROUP_SCHED_DEFAULT_DISABLED */
-#else /* !CONFIG_RT_GROUP_SCHED: */
-# define rt_group_sched_enabled()	false
-#endif /* !CONFIG_RT_GROUP_SCHED */
-
 static inline void lockdep_assert_rq_held(struct rq *rq)
 	__assumes_ctx_lock(__rq_lockp(rq))
 {
@@ -2396,28 +2336,14 @@ static inline struct sched_entity *cfs_rq_se(struct cfs_rq *cfs_rq)
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 {
-#if defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED)
-	struct task_group *tg = task_group(p);
-#endif
-
 #ifdef CONFIG_FAIR_GROUP_SCHED
+	struct task_group *tg = task_group(p);
+
 	set_task_rq_fair(&p->se, p->se.cfs_rq, tg_cfs_rq(tg, cpu));
 	p->se.cfs_rq = tg_cfs_rq(tg, cpu);
 	p->se.parent = tg_se(tg, cpu);
 	p->se.depth = p->se.parent ? p->se.parent->depth + 1 : 0;
 #endif
-
-#ifdef CONFIG_RT_GROUP_SCHED
-	/*
-	 * p->rt.rt_rq is NULL initially and it is easier to assign
-	 * root_task_group's rt_rq than switching in rt_rq_of_se()
-	 * Clobbers tg(!)
-	 */
-	if (!rt_group_sched_enabled())
-		tg = &root_task_group;
-	p->rt.rt_rq  = tg->rt_rq[cpu];
-	p->rt.parent = tg->rt_se[cpu];
-#endif /* CONFIG_RT_GROUP_SCHED */
 }
 
 #else /* !CONFIG_CGROUP_SCHED: */
@@ -3049,9 +2975,6 @@ extern void resched_curr(struct rq *rq);
 extern void resched_curr_lazy(struct rq *rq);
 extern void resched_cpu(int cpu);
 
-extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime);
-extern bool sched_rt_bandwidth_account(struct rt_rq *rt_rq);
-
 extern void init_dl_entity(struct sched_dl_entity *dl_se);
 
 extern void init_cfs_throttle_work(struct task_struct *p);
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 45a127deeadd9..02688e75a8bd6 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -606,19 +606,6 @@ int __sched_setscheduler(struct task_struct *p,
 change:
 
 	if (user) {
-#ifdef CONFIG_RT_GROUP_SCHED
-		/*
-		 * Do not allow real-time tasks into groups that have no runtime
-		 * assigned.
-		 */
-		if (rt_group_sched_enabled() &&
-				rt_bandwidth_enabled() && rt_policy(policy) &&
-				task_group(p)->rt_bandwidth.rt_runtime == 0 &&
-				!task_group_is_autogroup(task_group(p))) {
-			retval = -EPERM;
-			goto unlock;
-		}
-#endif /* CONFIG_RT_GROUP_SCHED */
 		if (dl_bandwidth_enabled() && dl_policy(policy) &&
 				!(attr->sched_flags & SCHED_FLAG_SUGOV)) {
 			cpumask_t *span = rq->rd->span;
-- 
2.55.0


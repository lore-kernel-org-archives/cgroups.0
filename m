Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795443467;
	b=AKUrcuzMQASC8Pi/HQXqvqm0zMgWxxL+H29sYgGzol3LDO+6M8oNQ0cw0nDiiMp0zUcb
	 FMaU8XhNjDXHJoLBUdcjtdteXaNAPccUET+U5qhL2KzvK7lj8z8T6TY2XpVySgu1MtgZy
	 b9yXOy1A7Mt3oG8PdzrXHmmUCmzyek6ZVjiVQ8FZGzZKscQiI8JDFk4YVoXsEoY9emVaf
	 Tw8TeJXQCnrrrjMzf9sABslKfgPlbNSepRg9feqGtjIWvuSm7dzypEE5xru9L8DuScBZV
	 Fw09McvqSzRr4iUlO6jpXC5SxqDiYnetIiZt/r1/RDK6jYPRbbt3JSWc4ii/g1qdSKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795443467;
	h=DMARC-Filter:Date:DKIM-Signature:DKIM-Signature:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=mmLjqOdC5jJ874kc/yb76i/bBMhfJA46OxJXhAdQn20=;
	b=jqfmc66ooNu2AayGiUOR6KibXuQLtRfN/ls7kO0EPKpwMXO/2Joz0BWrFM1nEb2tIr/p
	 mUj8gE6FGmYLqUmb775vdj9mWEENNFdmdG7PeEI+5O9BhWXgU1syJB2riq0+xbLJJ8BhM
	 80kN8dEJ7u0wHq5TsFfWkOrM79hnik+BkZCgjjZLWIcLUgoZDJFs/A9DIYO9FIBiC1T+a
	 pN0V5PWqXYUyYIyvGRo2TtRZcizmwh/iDpzxlf/xDbPFIaqHoMwdKD9g4sxwGTedz968d
	 CRh+4XIjJBH4hnZDU4de404T387efZFLx1IcFg6NOVsbKwNtXesNu19PF+udewVxUFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=OorltFdB;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=nLZ74Ce7;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0C7606A31A;
	Mon, 23 Nov 2026 14:17:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C0C7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=OorltFdB;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=nLZ74Ce7
Date: Mon, 23 Nov 2026 15:17:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795443464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mmLjqOdC5jJ874kc/yb76i/bBMhfJA46OxJXhAdQn20=;
	b=OorltFdBfCkP24O9uW0zSrkwtk574JG7H+C8zI/UM1VNLbcE/V5vrVq2kT9gEqPWDPBXBX
	Gz48GTq0k58gXeh7+772U7s0MIsNiStSewIzNbIbBWnsrDKvLvoqtginYW6134ZYjJIYTe
	yD25lXj+qPgV5beRtqMqyr6KVHuYjuXUUzmZ+QqHqOzd5yx37QxzjEEKKS7MSGvNIOC8ze
	rSYB+d+L1LR0ofGdCcHoagG7FAk0GNzkQD1yeTkLsAe1+yK4CPrI6V0MuPXtPLp8YT5HAj
	zhF4h0r+KOigYisKZv46FMF0dwnnVamsaru1PP1blbk841EqYiNiGyF0d4S9/g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795443464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mmLjqOdC5jJ874kc/yb76i/bBMhfJA46OxJXhAdQn20=;
	b=nLZ74Ce7CELGWuJsSJUHvoyvsj43rjgPnaHCF/WKXBOLnW039ahlTOaccw8RWUL4iP38cp
	vfJNmgOjs/iAh+BQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	rcu@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	luca abeni <luca.abeni@santannapisa.it>,
	Yuri Andriaccio <yurand2000@gmail.com>,
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>, Davidlohr Bueso <dave@stgolabs.net>,
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	Qais Yousef <qyousef@layalina.io>,
	John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v4 5/6] Documentation/sched: Drop the section enumeration
 in sched-deadline
Message-ID: <20261123141742.Cdq5EAtX@linutronix.de>
References: <20261123-sched_dl-v4-0-d523e4d960d3@linutronix.de>
 <20261123-sched_dl-v4-5-d523e4d960d3@linutronix.de>
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
In-Reply-To: <20261123-sched_dl-v4-5-d523e4d960d3@linutronix.de>

On 2026-11-23 14:41:11 [+0100], To linux-kernel@vger.kernel.org wrote:
> Each headline within the document has a manual numbering. If a new
> section is added in the middle of the document then one has to renumber
> the sections that follow plus update the maunal TOC at the top of the
> document.
> 
> Remove the manual created TOC and the numbers before the section. The
> rendered HTML has a TOC.

sashiko complained that the that the references within the document
(such ass "see 5.") are now broken.

This should deal with it:

--- a/Documentation/scheduler/sched-deadline.rst
+++ b/Documentation/scheduler/sched-deadline.rst
@@ -2,53 +2,29 @@
 Deadline Task Scheduling
 ========================
 
-.. CONTENTS
-
-    0. WARNING
-    1. Overview
-    2. Scheduling algorithm
-      2.1 Main algorithm
-      2.2 Bandwidth reclaiming
-    3. Scheduling Real-Time Tasks
-      3.1 Definitions
-      3.2 Schedulability Analysis for Uniprocessor Systems
-      3.3 Schedulability Analysis for Multiprocessor Systems
-      3.4 Relationship with SCHED_DEADLINE Parameters
-    4. Bandwidth management
-      4.1 System-wide settings
-      4.2 Task interface
-      4.3 Default behavior
-      4.4 Behavior of sched_yield()
-    5. Tasks CPU affinity
-      5.1 Using cgroup v1 cpuset controller
-      5.2 Using cgroup v2 cpuset controller
-    6. Future plans
-    A. Test suite
-    B. Minimal main()
-
-
-0. WARNING
-==========
+WARNING
+=======
 
  Fiddling with these settings can result in an unpredictable or even unstable
  system behavior. As for -rt (group) scheduling, it is assumed that root users
  know what they're doing.
 
 
-1. Overview
-===========
+Overview
+========
 
  The SCHED_DEADLINE policy contained inside the sched_dl scheduling class is
  basically an implementation of the Earliest Deadline First (EDF) scheduling
  algorithm, augmented with a mechanism (called Constant Bandwidth Server, CBS)
  that makes it possible to isolate the behavior of tasks between each other.
 
+.. _scheduling_algorithm:
 
-2. Scheduling algorithm
-=======================
+Scheduling algorithm
+====================
 
-2.1 Main algorithm
-------------------
+Main algorithm
+--------------
 
  SCHED_DEADLINE [18] uses three parameters, named "runtime", "period", and
  "deadline", to schedule tasks. A SCHED_DEADLINE task should receive
@@ -60,7 +36,7 @@ Deadline Task Scheduling
  scheduled using EDF[1] on these scheduling deadlines (the task with the
  earliest scheduling deadline is selected for execution). Notice that the
  task actually receives "runtime" time units within "deadline" if a proper
- "admission control" strategy (see Section "4. Bandwidth management") is used
+ "admission control" strategy (see :ref:`bandwidth_management`) is used
  (clearly, if the system is overloaded this guarantee cannot be respected).
 
  Summing up, the CBS[2,3] algorithm assigns scheduling deadlines to tasks so
@@ -68,8 +44,8 @@ Deadline Task Scheduling
  interference between different tasks (bandwidth isolation), while the EDF[1]
  algorithm selects the task with the earliest scheduling deadline as the one
  to be executed next. Thanks to this feature, tasks that do not strictly comply
- with the "traditional" real-time task model (see Section 3) can effectively
- use the new policy.
+ with the "traditional" real-time task model (see :ref:`scheduling_real_time_tasks`)
+ can effectively use the new policy.
 
  In more details, the CBS algorithm assigns scheduling deadlines to
  tasks in the following way:
@@ -123,8 +99,8 @@ Deadline Task Scheduling
  signals.
 
 
-2.2 Bandwidth reclaiming
-------------------------
+Bandwidth reclaiming
+--------------------
 
  Bandwidth reclaiming for deadline tasks is based on the GRUB (Greedy
  Reclamation of Unused Bandwidth) algorithm [15, 16, 17] and it is enabled
@@ -287,8 +263,8 @@ Deadline Task Scheduling
     running_bw is incremented.
 
 
-2.3 Energy-aware scheduling
----------------------------
+Energy-aware scheduling
+-----------------------
 
  When cpufreq's schedutil governor is selected, SCHED_DEADLINE implements the
  GRUB-PA [19] algorithm, reducing the CPU operating frequency to the minimum
@@ -299,9 +275,10 @@ Deadline Task Scheduling
  is of the same order of magnitude of the reservation period. In such cases,
  setting a fixed CPU frequency results in a lower amount of deadline misses.
 
+.. _scheduling_real_time_tasks:
 
-3. Scheduling Real-Time Tasks
-=============================
+Scheduling Real-Time Tasks
+==========================
 
 
 
@@ -311,7 +288,7 @@ Deadline Task Scheduling
 
    This section contains a (not-thorough) summary on classical deadline
    scheduling theory, and how it applies to SCHED_DEADLINE.
-   The reader can "safely" skip to Section 4 if only interested in seeing
+   The reader can "safely" skip to :ref:`bandwidth_management` if only interested in seeing
    how the scheduling policy can be used. Anyway, we strongly recommend
    to come back here and continue reading (once the urge for testing is
    satisfied :P) to be sure of fully understanding all technical details.
@@ -323,8 +300,8 @@ Deadline Task Scheduling
  suited for periodic or sporadic real-time tasks that need guarantees on their
  timing behavior, e.g., multimedia, streaming, control applications, etc.
 
-3.1 Definitions
-------------------------
+Definitions
+-----------
 
  A typical real-time task is composed of a repetition of computation phases
  (task instances, or jobs) which are activated on a periodic or sporadic
@@ -369,8 +346,8 @@ Deadline Task Scheduling
  is the minimum WCET, and U_max = max{WCET_i/P_i} is the maximum
  utilization[12].
 
-3.2 Schedulability Analysis for Uniprocessor Systems
-----------------------------------------------------
+Schedulability Analysis for Uniprocessor Systems
+------------------------------------------------
 
  If M=1 (uniprocessor system), or in case of partitioned scheduling (each
  real-time task is statically assigned to one and only one CPU), it is
@@ -411,11 +388,12 @@ Deadline Task Scheduling
  between 0 and a maximum value L. The cited papers contain all of the
  mathematical details and explain how to compute h(t) and L.
  In any case, this kind of analysis is too complex as well as too
- time-consuming to be performed on-line. Hence, as explained in Section
- 4 Linux uses an admission test based on the tasks' utilizations.
+ time-consuming to be performed on-line. Hence, as explained in
+ :ref:`bandwidth_management`
+ Linux uses an admission test based on the tasks' utilizations.
 
-3.3 Schedulability Analysis for Multiprocessor Systems
-------------------------------------------------------
+Schedulability Analysis for Multiprocessor Systems
+--------------------------------------------------
 
  On multiprocessor systems with global EDF scheduling (non partitioned
  systems), a sufficient test for schedulability can not be based on the
@@ -464,16 +442,17 @@ Deadline Task Scheduling
  the total utilization is smaller or equal than M then the response times of
  the tasks are limited.
 
-3.4 Relationship with SCHED_DEADLINE Parameters
------------------------------------------------
+Relationship with SCHED_DEADLINE Parameters
+-------------------------------------------
 
  Finally, it is important to understand the relationship between the
- SCHED_DEADLINE scheduling parameters described in Section 2 (runtime,
+ SCHED_DEADLINE scheduling parameters described in
+ :ref:`scheduling_algorithm` (runtime,
  deadline and period) and the real-time task parameters (WCET, D, P)
  described in this section. Note that the tasks' temporal constraints are
  represented by its absolute deadlines d_j = r_j + D described above, while
  SCHED_DEADLINE schedules the tasks according to scheduling deadlines (see
- Section 2).
+ :ref:`scheduling_algorithm`).
  If an admission test is used to guarantee that the scheduling deadlines
  are respected, then SCHED_DEADLINE can be used to schedule real-time tasks
  guaranteeing that all the jobs' deadlines of a task are respected.
@@ -549,8 +528,10 @@ Deadline Task Scheduling
        2018), Pau, France, April 2018.
 
 
-4. Bandwidth management
-=======================
+.. _bandwidth_management:
+
+Bandwidth management
+====================
 
  As previously mentioned, in order for -deadline scheduling to be
  effective and useful (that is, to be able to provide "runtime" time units
@@ -559,7 +540,8 @@ Deadline Task Scheduling
  This is usually called "admission control" and if it is not performed, then
  no guarantee can be given on the actual scheduling of the -deadline tasks.
 
- As already stated in Section 3, a necessary condition to be respected to
+ As already stated in :ref:`scheduling_real_time_tasks`,
+ a necessary condition to be respected to
  correctly schedule a set of real-time tasks is that the total utilization
  is smaller than M. When talking about -deadline tasks, this requires that
  the sum of the ratio between runtime and period for all tasks is smaller
@@ -587,13 +569,13 @@ Deadline Task Scheduling
  interface we can put a cap on total utilization of -deadline tasks (i.e.,
  \Sum (runtime_i / period_i) < global_dl_utilization_cap).
 
-4.1 System wide settings
-------------------------
+System wide settings
+--------------------
 
  The system wide settings are configured under /sys/kernel/sched.
 
- The ideal situation (see 5.) is to run -rt tasks from a -deadline server; in
- which case the -rt bandwidth is a direct subset of dl_bw.
+ The ideal situation (see ref:`tasks_cpu_affinity`) is to run -rt tasks from a
+ -deadline server; in which case the -rt bandwidth is a direct subset of dl_bw.
 
  This means that, for a root_domain comprising M CPUs, -deadline tasks
  can be created while the sum of their bandwidths stays below:
@@ -604,9 +586,8 @@ Deadline Task Scheduling
  be thus free of oversubscribing the system up to any arbitrary level.
  This is done by writing -1 in /sys/kernel/sched/dl_runtime_us.
 
-
-4.2 Task interface
-------------------
+Task interface
+--------------
 
  Specifying a periodic/sporadic task that executes for a given amount of
  runtime at each instance, and that is scheduled according to the urgency of
@@ -640,8 +621,8 @@ Deadline Task Scheduling
  reference, that is not directly usable from user-space.
 
 
-4.3 Default behavior
----------------------
+Default behavior
+----------------
 
  The default value for SCHED_DEADLINE bandwidth is to have dl_runtime_us equal to
  1000000. With rt_period equal to 1000000, by default, it means that -deadline
@@ -651,7 +632,8 @@ Deadline Task Scheduling
  and that -deadline tasks will receive their runtime with a guaranteed
  worst-case delay respect to the "deadline" parameter. If "deadline" = "period"
  and the cpuset mechanism is used to implement partitioned scheduling (see
- Section 5), then this simple setting of the bandwidth management is able to
+ :ref:`tasks_cpu_affinity`),
+ then this simple setting of the bandwidth management is able to
  deterministically guarantee that -deadline tasks will receive their runtime
  in a period.
 
@@ -659,8 +641,8 @@ Deadline Task Scheduling
  -deadline task cannot fork.
 
 
-4.4 Behavior of sched_yield()
------------------------------
+Behavior of sched_yield()
+-------------------------
 
  When a SCHED_DEADLINE task calls sched_yield(), it gives up its
  remaining runtime and is immediately throttled, until the next
@@ -674,9 +656,10 @@ Deadline Task Scheduling
  make the leftoever runtime available for reclamation by other
  SCHED_DEADLINE tasks.
 
+.. _tasks_cpu_affinity:
 
-5. Tasks CPU affinity
-=====================
+Tasks CPU affinity
+==================
 
  Deadline tasks cannot have a cpu affinity mask smaller than the root domain they
  are created on. So, using ``sched_setaffinity(2)`` won't work. Instead, the
@@ -685,8 +668,8 @@ Deadline Task Scheduling
  See :ref:`Documentation/admin-guide/cgroup-v1/cpusets.rst <cpusets>` and
  :ref:`Documentation/admin-guide/cgroup-v2.rst <cgroup-v2>` for more information.
 
-5.1 Using cgroup v1 cpuset controller
--------------------------------------
+Using cgroup v1 cpuset controller
+---------------------------------
 
  An example of a simple configuration (pin a -deadline task to CPU0) follows::
 
@@ -703,8 +686,8 @@ Deadline Task Scheduling
    echo $$ > cpu0/tasks
    chrt --sched-runtime 100000 --sched-period 200000 --deadline 0 yes > /dev/null
 
-5.2 Using cgroup v2 cpuset controller
--------------------------------------
+Using cgroup v2 cpuset controller
+---------------------------------
 
  Assuming the cgroup v2 root is mounted at ``/sys/fs/cgroup``, an example of a
  simple configuration (pin a -deadline task to CPU0) follows::
@@ -717,8 +700,8 @@ Deadline Task Scheduling
    echo $$ > deadline_group/cgroup.procs
    chrt --sched-runtime 100000 --sched-period 200000 --deadline 0 yes > /dev/null
 
-6. Future plans
-===============
+Future plans
+============
 
  Still missing:
 
-- 
2.55.0


Sebastian

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795441285;
	b=wIodL1ILodyz+VWLGguu7l6eGM82m3tcdl2kO7aKBCYbwmuJjCF27Cov+cht7LFYl/i7
	 pFkUbDrwNCS+/PUAHpq1dGv9uH8NOIWuryimmwedLnP7XwxPWh7ztYL0LFL3hgmGsqIQP
	 j/JnfTys8vecqyxE7ppFHHRAzCqgoj7zgASprS+glAsrFGbCEpA7el32Ef6dtl7GckVmd
	 AhCvmily/E1qwfJ/zvkzhyHfjLrAQgevovtE+5/2+bfEL2qXAoPMKMbhVGtEorNfeDnDa
	 RxIRqE5KH3l5sGkCnzdHAgWXRcY6Aljwy5THj76h30eNyTE2mKSr6s8eSLSVOfrsOmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795441285;
	h=DMARC-Filter:From:DKIM-Signature:DKIM-Signature:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=F3+7VuYgEVs4JO82ydLh12bWXfwvVc9HVf8ISbCt4go=;
	b=XKAfatRgENIDjW47+6+xAPF3lx8cm2hRTFVOW7cvAOAYXgZE1r94WwA/GEDJNTUjHFtJ
	 FrYRN6xdSUkifX5WqZRk+n3WtRFeynNtSJPoSj+muYCfOKBCVXPbnfTPul+lQSh4g/Hak
	 lvQdCtWbzDo2SgteWBJkyHIzgm+YZFKEtIjbADn6J87lXsy1CAo6c9TJB9sImUOO9+gCu
	 PjqFGS0btnBywtV7w0OblFn7dRkUEtHPydx6FU22EZP+5m69/n0OlDGmyOVs8yeMpZA5w
	 k9fUjZlhM8RnOmt1/w83A0Yidcwuw8IMg4AVvGgLD6t7/aSPOnej4Ja/iWre4A/eNOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=V2wFJIog;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=BSMYkveH;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671EE606A69B;
	Mon, 23 Nov 2026 13:41:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 671EE606A69B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=V2wFJIog;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=BSMYkveH
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795441283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F3+7VuYgEVs4JO82ydLh12bWXfwvVc9HVf8ISbCt4go=;
	b=V2wFJIogoEzcLifBw3E4xj1LPgUi8D5F7Nb7jUD8Mad9R/1XIsfPEikkk4F9kTX98UBj0h
	3dIobPMumaIVThGzRO0YVgrPvPKw3wuYVfNvt7NCo3vGwPjwTcY9BWBI2HuHzNdlGO1oXm
	5CujGZqsBWdqutcAfSirJTNPNGzWA8pfmdRJgnVvm5Wfr76yTFxA9ypE17DGYYmnCygi8u
	K+29t0Maa/4DdI7jlWAc4aUg55dYFDurSUNBTqzAzxRUul4S7cj+kFseVgatSGScJd9W8h
	SRb37O/GQYSI2CZ9Vx9T7Ahn7mp4O1iNau7yP+HsWon4YwGiuTvJ56HvkE/o8A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795441283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F3+7VuYgEVs4JO82ydLh12bWXfwvVc9HVf8ISbCt4go=;
	b=BSMYkveHvf6mDWgebPucDL+woTFaQclWzfVKmC5H8QvjksOaXYsXv/uJqvXxCAPnQTEmtj
	SKjBaPS2l3eeegAA==
To: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
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
	Boqun Feng <boqun@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
	Qais Yousef <qyousef@layalina.io>,
	John Ogness <john.ogness@linutronix.de>
Subject: [PATCH v4 5/6] Documentation/sched: Drop the section enumeration in sched-deadline
Date: Mon, 23 Nov 2026 14:41:11 +0100
Message-ID: <20261123-sched_dl-v4-5-d523e4d960d3@linutronix.de>
In-Reply-To: <20261123-sched_dl-v4-0-d523e4d960d3@linutronix.de>
References: <20261123-sched_dl-v4-0-d523e4d960d3@linutronix.de>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Each headline within the document has a manual numbering. If a new
section is added in the middle of the document then one has to renumber
the sections that follow plus update the maunal TOC at the top of the
document.

Remove the manual created TOC and the numbers before the section. The
rendered HTML has a TOC.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 Documentation/scheduler/sched-deadline.rst | 106 +++++++++++--------------=
----
 1 file changed, 40 insertions(+), 66 deletions(-)

diff --git a/Documentation/scheduler/sched-deadline.rst b/Documentation/sch=
eduler/sched-deadline.rst
index 4441bb689cca1..b76bb61cd48fd 100644
--- a/Documentation/scheduler/sched-deadline.rst
+++ b/Documentation/scheduler/sched-deadline.rst
@@ -2,41 +2,16 @@
 Deadline Task Scheduling
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
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
-=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+WARNING
+=3D=3D=3D=3D=3D=3D=3D
=20
  Fiddling with these settings can result in an unpredictable or even unsta=
ble
  system behavior. As for -rt (group) scheduling, it is assumed that root u=
sers
  know what they're doing.
=20
=20
-1. Overview
-=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+Overview
+=3D=3D=3D=3D=3D=3D=3D=3D
=20
  The SCHED_DEADLINE policy contained inside the sched_dl scheduling class =
is
  basically an implementation of the Earliest Deadline First (EDF) scheduli=
ng
@@ -44,11 +19,11 @@ Deadline Task Scheduling
  that makes it possible to isolate the behavior of tasks between each othe=
r.
=20
=20
-2. Scheduling algorithm
-=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+Scheduling algorithm
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
-2.1 Main algorithm
-------------------
+Main algorithm
+--------------
=20
  SCHED_DEADLINE [18] uses three parameters, named "runtime", "period", and
  "deadline", to schedule tasks. A SCHED_DEADLINE task should receive
@@ -123,8 +98,8 @@ Deadline Task Scheduling
  signals.
=20
=20
-2.2 Bandwidth reclaiming
-------------------------
+Bandwidth reclaiming
+--------------------
=20
  Bandwidth reclaiming for deadline tasks is based on the GRUB (Greedy
  Reclamation of Unused Bandwidth) algorithm [15, 16, 17] and it is enabled
@@ -287,8 +262,8 @@ Deadline Task Scheduling
     running_bw is incremented.
=20
=20
-2.3 Energy-aware scheduling
----------------------------
+Energy-aware scheduling
+-----------------------
=20
  When cpufreq's schedutil governor is selected, SCHED_DEADLINE implements =
the
  GRUB-PA [19] algorithm, reducing the CPU operating frequency to the minim=
um
@@ -300,8 +275,8 @@ Deadline Task Scheduling
  setting a fixed CPU frequency results in a lower amount of deadline misse=
s.
=20
=20
-3. Scheduling Real-Time Tasks
-=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
+Scheduling Real-Time Tasks
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
=20
=20
=20
@@ -323,8 +298,8 @@ Deadline Task Scheduling
  suited for periodic or sporadic real-time tasks that need guarantees on t=
heir
  timing behavior, e.g., multimedia, streaming, control applications, etc.
=20
-3.1 Definitions
-------------------------
+Definitions
+-----------
=20
  A typical real-time task is composed of a repetition of computation phases
  (task instances, or jobs) which are activated on a periodic or sporadic
@@ -369,8 +344,8 @@ Deadline Task Scheduling
  is the minimum WCET, and U_max =3D max{WCET_i/P_i} is the maximum
  utilization[12].
=20
-3.2 Schedulability Analysis for Uniprocessor Systems
-----------------------------------------------------
+Schedulability Analysis for Uniprocessor Systems
+------------------------------------------------
=20
  If M=3D1 (uniprocessor system), or in case of partitioned scheduling (each
  real-time task is statically assigned to one and only one CPU), it is
@@ -414,8 +389,8 @@ Deadline Task Scheduling
  time-consuming to be performed on-line. Hence, as explained in Section
  4 Linux uses an admission test based on the tasks' utilizations.
=20
-3.3 Schedulability Analysis for Multiprocessor Systems
-------------------------------------------------------
+Schedulability Analysis for Multiprocessor Systems
+--------------------------------------------------
=20
  On multiprocessor systems with global EDF scheduling (non partitioned
  systems), a sufficient test for schedulability can not be based on the
@@ -464,8 +439,8 @@ Deadline Task Scheduling
  the total utilization is smaller or equal than M then the response times =
of
  the tasks are limited.
=20
-3.4 Relationship with SCHED_DEADLINE Parameters
------------------------------------------------
+Relationship with SCHED_DEADLINE Parameters
+-------------------------------------------
=20
  Finally, it is important to understand the relationship between the
  SCHED_DEADLINE scheduling parameters described in Section 2 (runtime,
@@ -549,8 +524,8 @@ Deadline Task Scheduling
        2018), Pau, France, April 2018.
=20
=20
-4. Bandwidth management
-=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+Bandwidth management
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
  As previously mentioned, in order for -deadline scheduling to be
  effective and useful (that is, to be able to provide "runtime" time units
@@ -587,8 +562,8 @@ Deadline Task Scheduling
  interface we can put a cap on total utilization of -deadline tasks (i.e.,
  \Sum (runtime_i / period_i) < global_dl_utilization_cap).
=20
-4.1 System wide settings
-------------------------
+System wide settings
+--------------------
=20
  The system wide settings are configured under /sys/kernel/sched.
=20
@@ -604,9 +579,8 @@ Deadline Task Scheduling
  be thus free of oversubscribing the system up to any arbitrary level.
  This is done by writing -1 in /sys/kernel/sched/dl_runtime_us.
=20
-
-4.2 Task interface
-------------------
+Task interface
+--------------
=20
  Specifying a periodic/sporadic task that executes for a given amount of
  runtime at each instance, and that is scheduled according to the urgency =
of
@@ -640,8 +614,8 @@ Deadline Task Scheduling
  reference, that is not directly usable from user-space.
=20
=20
-4.3 Default behavior
----------------------
+Default behavior
+----------------
=20
  The default value for SCHED_DEADLINE bandwidth is to have dl_runtime_us e=
qual to
  1000000. With rt_period equal to 1000000, by default, it means that -dead=
line
@@ -659,8 +633,8 @@ Deadline Task Scheduling
  -deadline task cannot fork.
=20
=20
-4.4 Behavior of sched_yield()
------------------------------
+Behavior of sched_yield()
+-------------------------
=20
  When a SCHED_DEADLINE task calls sched_yield(), it gives up its
  remaining runtime and is immediately throttled, until the next
@@ -675,8 +649,8 @@ Deadline Task Scheduling
  SCHED_DEADLINE tasks.
=20
=20
-5. Tasks CPU affinity
-=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+Tasks CPU affinity
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
  Deadline tasks cannot have a cpu affinity mask smaller than the root doma=
in they
  are created on. So, using ``sched_setaffinity(2)`` won't work. Instead, t=
he
@@ -685,8 +659,8 @@ Deadline Task Scheduling
  See :ref:`Documentation/admin-guide/cgroup-v1/cpusets.rst <cpusets>` and
  :ref:`Documentation/admin-guide/cgroup-v2.rst <cgroup-v2>` for more infor=
mation.
=20
-5.1 Using cgroup v1 cpuset controller
--------------------------------------
+Using cgroup v1 cpuset controller
+---------------------------------
=20
  An example of a simple configuration (pin a -deadline task to CPU0) follo=
ws::
=20
@@ -703,8 +677,8 @@ Deadline Task Scheduling
    echo $$ > cpu0/tasks
    chrt --sched-runtime 100000 --sched-period 200000 --deadline 0 yes > /d=
ev/null
=20
-5.2 Using cgroup v2 cpuset controller
--------------------------------------
+Using cgroup v2 cpuset controller
+---------------------------------
=20
  Assuming the cgroup v2 root is mounted at ``/sys/fs/cgroup``, an example =
of a
  simple configuration (pin a -deadline task to CPU0) follows::
@@ -717,8 +691,8 @@ Deadline Task Scheduling
    echo $$ > deadline_group/cgroup.procs
    chrt --sched-runtime 100000 --sched-period 200000 --deadline 0 yes > /d=
ev/null
=20
-6. Future plans
-=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+Future plans
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
  Still missing:
=20

--=20
2.55.0


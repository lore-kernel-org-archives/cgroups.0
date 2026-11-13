Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794567037;
	b=E4yGw+BbHXdil1ytc/BUJbVWH8SCUhirITI2VPk5SdSb/HQdR64FHVN6UWjw3zo+jwVq
	 FkZRt4n7puwGEom9eX61GxxVheLXEkcwffdE2fe2ZP7LGLRynj/0yB0n+wJqCnJtdWvU2
	 DVxV+ztWPeEhqV7cpbfLVgp7SxciKufVnAH844znOLeS8MMJv2BUp21NAXpJCqnTdYBlQ
	 Bfz8cMLW3yoJP8LSb2p/1oQpHfN5HSYYt8VVQ/BWwhxMtDP0VkkO4LHQE1MBnfA0no9kk
	 4W9ENbouSMxi29nB+iLD8bP6Lqfjc4oYMLDbgdSvVWKkIMi8upVUvgUskr84JLVJH0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794567037;
	h=DMARC-Filter:From:DKIM-Signature:DKIM-Signature:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=ntj3HkbDGHyVNps112Kw7iIlCxULklKvo53QoNA5oes=;
	b=p+Y2vkboB6VebrCfFLqOCKtLe9Tqlb3TiMWLqQ0UjdXZvOTVEIaxwTx1YDcOjTRYEZyl
	 o3XbSPy2mLXw//AGxON1lFUsXmcu+GENc9XIkICNVsCrdMXsNFkPmnM2N1GYGYm0ILzkN
	 enjqy6Z9nsib28AkIFye51PeE88eqtirVHPt3zaW3HKGR4j9N7LIN5CQ87UOj0orB2ukw
	 X3qWXQDwza5EFdpmnN8LA+wxaBZ/xDskFkCOIlsmmFuaJ8yOrvhlydPAA4YNx43oCuM5j
	 F8zFM3EdEI0aslvFO5NlmChWtG0mLu7C4CFiKd4UcPzk74i+krjHgsMG3dTtiHt+4tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=O8cMfFdq;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=iirxdDN5;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E15A606A333;
	Fri, 13 Nov 2026 10:50:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E15A606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=O8cMfFdq;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=iirxdDN5
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1794567035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ntj3HkbDGHyVNps112Kw7iIlCxULklKvo53QoNA5oes=;
	b=O8cMfFdqwPLmB36HBCO6iiREWI3KYR6OH6N5S9xRVyVg2v2IAGfp1ZR1CFSNjpwywcwWWP
	9pMEA38btmXY7gzj6qlzjANjSkpEU7ghKsbzvdQ/QQ4pM4au9DZjPpy34k7Gt+6Sv+lExX
	2Xmt6rSDxJoVXcwrZ/XYXLRmEk2tdOrDCUhMMpk9jMlNY5GTYKFKe0ZOWce0TRrJjN/0Jt
	Hqk7RV68c8HGzce6CPWB8/Q7XahcKxQvS+fMgPD7DTW5/1lrBPY87W1iMegD8Wigs7Fyw8
	cCn/0UcvaHmh7iFhJBrXI7Dww02z9zUek4STm0+4l9p7kyD8Kqpi1PDxRRIWeA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1794567035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ntj3HkbDGHyVNps112Kw7iIlCxULklKvo53QoNA5oes=;
	b=iirxdDN5dVogf2chZokrevFJcZbA/Neb8u0/50H44tmFtY9XddI1opkwIIIQzgnTWRuZn8
	J73+8TjRDbln+GDw==
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
Subject: [PATCH v3 2/8] sched: Mark RT_GROUP_SCHED broken
Date: Fri, 13 Nov 2026 11:50:23 +0100
Message-ID: <20261113-sched_dl-v3-2-a76ffa1cdeee@linutronix.de>
In-Reply-To: <20261113-sched_dl-v3-0-a76ffa1cdeee@linutronix.de>
References: <20261113-sched_dl-v3-0-a76ffa1cdeee@linutronix.de>
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

The RT_GROUP_SCHED is broken beyond repair and it is best to not enable
it during compile. If enabled it is recommended to disable it at boot
time with the rt_group_sched=3D option.
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

There is work on Hierarchical constant bandwidth server (HCBS) which aim
to group multiple real-time tasks within one deadline configuration.

Mark CONFIG_RT_GROUP_SCHED broken. Move code which is not under
RT_GROUP_SCHED but only used by it within its IFDEF section. This
includes also RT_RUNTIME_SHARE.
Update the documentation, to state that it is not related to real-time
tasks in general but only to RT-group scheduling. While at it, also
update the current defaults.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 Documentation/scheduler/sched-rt-group.rst |  7 ++++++-
 init/Kconfig                               |  2 +-
 kernel/sched/features.h                    |  2 ++
 kernel/sched/rt.c                          |  6 ------
 kernel/sched/sched.h                       | 19 +++++++++++--------
 5 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/Documentation/scheduler/sched-rt-group.rst b/Documentation/sch=
eduler/sched-rt-group.rst
index ab464335d3204..cd69c93baeb6a 100644
--- a/Documentation/scheduler/sched-rt-group.rst
+++ b/Documentation/scheduler/sched-rt-group.rst
@@ -18,6 +18,11 @@ Real-Time group scheduling
 0. WARNING
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
+ This document applies to RT group scheduling provided by CONFIG_RT_GROUP_=
SCHED.
+ If you don't use RT-group scheduling, schedule real-time tasks and experi=
ence
+ throttling issues please look into Documentation/scheduler/sched-deadline=
.rst
+ for the fair_server.
+
  Fiddling with these settings can result in an unstable system, the knobs =
are
  root only and assumes root knows what he is doing.
=20
@@ -111,7 +116,7 @@ lack an EDF scheduler to make non-uniform periods usabl=
e.
 ---------------------
=20
 The default values for sched_rt_period_us (1000000 or 1s) and
-sched_rt_runtime_us (950000 or 0.95s).  This gives 0.05s to be used by
+sched_rt_runtime_us (1000000 or 1s).  This gives 0s to be used by
 SCHED_OTHER (non-RT tasks). These defaults were chosen so that a run-away
 real-time tasks will not lock up the machine but leave a little time to re=
cover
 it.  By setting runtime to -1 you'd get the old behaviour back.
diff --git a/init/Kconfig b/init/Kconfig
index 4013781e0a029..7d5db38cc82c8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -980,7 +980,7 @@ config CFS_BANDWIDTH
=20
 config RT_GROUP_SCHED
 	bool "Group scheduling for SCHED_RR/FIFO"
-	depends on CGROUP_SCHED
+	depends on CGROUP_SCHED && BROKEN
 	default n
 	help
 	  This feature lets you explicitly allocate real CPU bandwidth
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 8f0dee8fc4755..acc1c3fdfe2a2 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -122,7 +122,9 @@ SCHED_FEAT(RT_PUSH_IPI, false)
 # endif
 #endif
=20
+#ifdef CONFIG_RT_GROUP_SCHED
 SCHED_FEAT(RT_RUNTIME_SHARE, false)
+#endif
 SCHED_FEAT(LB_MIN, false)
 SCHED_FEAT(ATTACH_AGE_LOAD, true)
=20
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 1535046a23ffa..cdeddd3fc9af2 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -944,12 +944,6 @@ static inline const struct cpumask *sched_rt_period_ma=
sk(void)
 	return cpu_online_mask;
 }
=20
-static inline
-struct rt_rq *sched_rt_period_rt_rq(struct rt_bandwidth *rt_b, int cpu)
-{
-	return &cpu_rq(cpu)->rt;
-}
-
 static void __enable_runtime(struct rq *rq) { }
 static void __disable_runtime(struct rq *rq) { }
=20
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1d76950dbb0a1..a7964537bac75 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -313,6 +313,7 @@ struct rt_prio_array {
 	struct list_head queue[MAX_RT_PRIO];
 };
=20
+#ifdef CONFIG_RT_GROUP_SCHED
 struct rt_bandwidth {
 	/* nests inside the rq lock: */
 	raw_spinlock_t		rt_runtime_lock;
@@ -321,6 +322,7 @@ struct rt_bandwidth {
 	struct hrtimer		rt_period_timer;
 	unsigned int		rt_period_active;
 };
+#endif
=20
 static inline int dl_bandwidth_enabled(void)
 {
@@ -581,6 +583,7 @@ extern void start_cfs_bandwidth(struct cfs_bandwidth *c=
fs_b);
 extern void unthrottle_cfs_rq(struct cfs_rq *cfs_rq);
 extern bool cfs_task_bw_constrained(struct task_struct *p);
=20
+#ifdef CONFIG_RT_GROUP_SCHED
 extern void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
 		struct sched_rt_entity *rt_se, int cpu,
 		struct sched_rt_entity *parent);
@@ -589,6 +592,14 @@ extern int sched_group_set_rt_period(struct task_group=
 *tg, u64 rt_period_us);
 extern long sched_group_rt_runtime(struct task_group *tg);
 extern long sched_group_rt_period(struct task_group *tg);
 extern int sched_rt_can_attach(struct task_group *tg, struct task_struct *=
tsk);
+extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 r=
untime);
+extern bool sched_rt_bandwidth_account(struct rt_rq *rt_rq);
+
+static inline int rt_bandwidth_enabled(void)
+{
+	return sysctl_sched_rt_runtime >=3D 0;
+}
+#endif
=20
 extern struct task_group *sched_create_group(struct task_group *parent);
 extern void sched_online_group(struct task_group *tg,
@@ -869,11 +880,6 @@ struct scx_rq {
 };
 #endif /* CONFIG_SCHED_CLASS_EXT */
=20
-static inline int rt_bandwidth_enabled(void)
-{
-	return sysctl_sched_rt_runtime >=3D 0;
-}
-
 /* RT IPI pull logic requires IRQ_WORK */
 #if defined(CONFIG_IRQ_WORK) && defined(CONFIG_SMP)
 # define HAVE_RT_PUSH_IPI
@@ -3049,9 +3055,6 @@ extern void resched_curr(struct rq *rq);
 extern void resched_curr_lazy(struct rq *rq);
 extern void resched_cpu(int cpu);
=20
-extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 r=
untime);
-extern bool sched_rt_bandwidth_account(struct rt_rq *rt_rq);
-
 extern void init_dl_entity(struct sched_dl_entity *dl_se);
=20
 extern void init_cfs_throttle_work(struct task_struct *p);

--=20
2.55.0


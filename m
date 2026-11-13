Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794567040;
	b=p6x9XoDsfWlY/2dKiVBqJTppBvIbN2myUny6rcme1qDtpb/kW+M5uBh+okktlvL4uvS3
	 u/r3ApWDhuYMtovdMaE6vOOlctK8WskNy9gktLXmsKYJhLyW3yYRVhrPNo1vIBbpv6ORP
	 PaoNV8nlVsVbR2DrFwx+1Ur23mMEqrQJoHksgtWDPwisqJRYDyLKGwlaycn+7rdPtNMCG
	 UsswRJTI5M63fLzgwH0h6qWEWF1QSJ9LOKt2OPUzbkgVJVvcwFPBN2F/c0ce9NUqB5k4o
	 Q1YdYMIRimJDYHUbZT/a1T/mQoVoEl7Mm5h/8x3Lwizy9a63ixQg8WjjwCnekppAxfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794567040;
	h=DMARC-Filter:From:DKIM-Signature:DKIM-Signature:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=DclmTec3i4xGbMWErspUiVzJ3bfBW5vSmaRYIYwza24=;
	b=bozDx3thIk76xm6Z3kxcIiFeJ/EePmH88SE89s1XUyrFcerM4fKpS61XOjvKo3OzT2Dd
	 9J5iDrV8xeBs1E3B1LsJ2Rmm29ND+CnmDFS0JXDJmKXnZmSKd9I6U8Oko6GzNL5ty/AgD
	 5yVXdfPkRsjMxxG1Ne8FaFirIH/F+6Dn1MV14nrXzhGh56QEtjchDzYWl8ttQCI0eZQfK
	 Uhb/E/S3f6GCyhGhBmrQA8+ylcTgM9NU3m/Kdu+tDeGD6EONU9BT98JIyGXdDPvPD+X39
	 Y3svPIRavIsvqEEKhHJfO7UuIIjrr3QivtFjHVyx6ZZgoECtLUfgKITTdadrGlKpYmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b="o/nUUCyR";
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b="/nFUufqW";
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B5C60A2604;
	Fri, 13 Nov 2026 10:50:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57B5C60A2604
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=o/nUUCyR;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=/nFUufqW
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1794567038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DclmTec3i4xGbMWErspUiVzJ3bfBW5vSmaRYIYwza24=;
	b=o/nUUCyRCTxHTd4nOYg+U7+0dBcAMWOlMv4LVUxk/uaPxMcRIsV+cQ8C6mWX9NjR3pCw8Y
	x0aBrH+rjzUbipWrlx4MNEtNUF2vTo8OPjOmpwfswncakRQf8LYl3rcxEZMsOpwzAVMIwL
	YFhjsyU9S77VXwDnwPXZUsi4DEyWRfrR4mFLOJyogyB9r+/b/fVOBSmxcBYKOUx23Ni7Or
	q6oCxhLUIjdORnG5J85hCWJ4BaaXRhc1kmRqWFzY/KkDDjsywoeOtWyYUaRPJ+MCdCrsLh
	RoIK9AvY27dkezf6n0/kMiW1EMWCOpGVT6CpqE8Jdwt4/pCHYKWxCoGqdU2mpg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1794567038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DclmTec3i4xGbMWErspUiVzJ3bfBW5vSmaRYIYwza24=;
	b=/nFUufqWBSXsINPyC6nRzBYFoVyMoTiuHbBBzgqT9ufxwMibtGyaTBVHEqYb2WGaChwDJL
	47SsHIbh7XaUxqDg==
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
Subject: [PATCH v3 6/8] sched: Limit sysctl sched_rt_{period|runtime}_us to RT_GROUP_SCHED
Date: Fri, 13 Nov 2026 11:50:27 +0100
Message-ID: <20261113-sched_dl-v3-6-a76ffa1cdeee@linutronix.de>
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

The admission control for SCHED_DL has been moved to sysfs and RT
throttling has been moved (long ago) to the fair_server and its debugfs
interface.

This file remains to have an impact only on RT_GROUP_SCHED. Keeping it
for ABI/ compatibility reasons makes no sense because its original
purpose (RT throttling) is no longer served. Anyone changing this file
and hoping to change the throttling behaviour will be surprised.

Limit sysctl sched_rt_{period|runtime}_us to RT_GROUP_SCHED so everyone
using this outdated file is aware.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/sched/rt.c    | 34 ++++++++++++++++++++++------------
 kernel/sched/sched.h |  5 +++--
 2 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 1a6450f91d567..abe8e05942249 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -8,6 +8,8 @@
 #include "pelt.h"
=20
 int sched_rr_timeslice =3D RR_TIMESLICE;
+
+#ifdef CONFIG_RT_GROUP_SCHED
 /* More than 4 hours if BW_SHIFT equals 20. */
 static const u64 max_rt_runtime =3D MAX_BW;
=20
@@ -22,14 +24,26 @@ int sysctl_sched_rt_period =3D 1000000;
  * default: 1s
  */
 int sysctl_sched_rt_runtime =3D 1000000;
+#endif
=20
 #ifdef CONFIG_SYSCTL
 static int sysctl_sched_rr_timeslice =3D (MSEC_PER_SEC * RR_TIMESLICE) / H=
Z;
-static int sched_rt_handler(const struct ctl_table *table, int write, void=
 *buffer,
-		size_t *lenp, loff_t *ppos);
 static int sched_rr_handler(const struct ctl_table *table, int write, void=
 *buffer,
 		size_t *lenp, loff_t *ppos);
 static const struct ctl_table sched_rt_sysctls[] =3D {
+	{
+		.procname       =3D "sched_rr_timeslice_ms",
+		.data           =3D &sysctl_sched_rr_timeslice,
+		.maxlen         =3D sizeof(int),
+		.mode           =3D 0644,
+		.proc_handler   =3D sched_rr_handler,
+	},
+};
+
+#ifdef CONFIG_RT_GROUP_SCHED
+static int sched_rt_handler(const struct ctl_table *table, int write, void=
 *buffer,
+		size_t *lenp, loff_t *ppos);
+static const struct ctl_table sched_rt_group_sysctls[] =3D {
 	{
 		.procname       =3D "sched_rt_period_us",
 		.data           =3D &sysctl_sched_rt_period,
@@ -48,18 +62,15 @@ static const struct ctl_table sched_rt_sysctls[] =3D {
 		.extra1         =3D SYSCTL_NEG_ONE,
 		.extra2         =3D (void *)&sysctl_sched_rt_period,
 	},
-	{
-		.procname       =3D "sched_rr_timeslice_ms",
-		.data           =3D &sysctl_sched_rr_timeslice,
-		.maxlen         =3D sizeof(int),
-		.mode           =3D 0644,
-		.proc_handler   =3D sched_rr_handler,
-	},
 };
+#endif
=20
 static int __init sched_rt_sysctl_init(void)
 {
 	register_sysctl_init("kernel", sched_rt_sysctls);
+#ifdef CONFIG_RT_GROUP_SCHED
+	register_sysctl_init("kernel", sched_rt_group_sysctls);
+#endif
 	return 0;
 }
 late_initcall(sched_rt_sysctl_init);
@@ -2845,6 +2856,7 @@ int sched_rt_can_attach(struct task_group *tg, struct=
 task_struct *tsk)
 #endif /* !CONFIG_RT_GROUP_SCHED */
=20
 #ifdef CONFIG_SYSCTL
+#ifdef CONFIG_RT_GROUP_SCHED
 static int sched_rt_global_validate(void)
 {
 	if ((sysctl_sched_rt_runtime !=3D RUNTIME_INF) &&
@@ -2853,14 +2865,11 @@ static int sched_rt_global_validate(void)
 			NSEC_PER_USEC > max_rt_runtime)))
 		return -EINVAL;
=20
-#ifdef CONFIG_RT_GROUP_SCHED
 	if (!rt_group_sched_enabled())
 		return 0;
=20
 	scoped_guard(mutex, &rt_constraints_mutex)
 		return __rt_schedulable(NULL, 0, 0);
-#endif
-	return 0;
 }
=20
 static int sched_rt_handler(const struct ctl_table *table, int write, void=
 *buffer,
@@ -2887,6 +2896,7 @@ static int sched_rt_handler(const struct ctl_table *t=
able, int write, void *buff
=20
 	return ret;
 }
+#endif /* !CONFIG_RT_GROUP_SCHED */
=20
 static int sched_rr_handler(const struct ctl_table *table, int write, void=
 *buffer,
 		size_t *lenp, loff_t *ppos)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 00a3802d0ce04..966fe46fb38e7 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -110,8 +110,6 @@ extern long calc_load_fold_active(struct rq *this_rq, l=
ong adjust);
 extern void call_trace_sched_update_nr_running(struct rq *rq, int count);
=20
 extern u64 sysfs_dl_runtime;
-extern int sysctl_sched_rt_period;
-extern int sysctl_sched_rt_runtime;
 extern int sched_rr_timeslice;
=20
 /*
@@ -583,6 +581,9 @@ extern void unthrottle_cfs_rq(struct cfs_rq *cfs_rq);
 extern bool cfs_task_bw_constrained(struct task_struct *p);
=20
 #ifdef CONFIG_RT_GROUP_SCHED
+extern int sysctl_sched_rt_period;
+extern int sysctl_sched_rt_runtime;
+
 extern void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
 		struct sched_rt_entity *rt_se, int cpu,
 		struct sched_rt_entity *parent);

--=20
2.55.0


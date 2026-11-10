Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794332144;
	b=uHKKEBJAcVLbGVWjaG8wsQ31COFz9DIwH+G2sGy+w8suwxzzerVpXK2sJu7NT7NYkqMm
	 eZWxeggOX5b04aqknxkGnMtJJGHrGM7oUYT80jXGOL9ijx+dUdvglUcx17+KEI/i9jnlA
	 v4GSFsB51ikk1ZIw4Ui9VtYm8RGzJcOI8QaU2ypBxjjwTamHXcPtUwmy8e/x/XsrRkRvU
	 g3Nh2y2qRfVjR5y1yNIn1HU0FDQ3GpSeyAvtEI26IVJxGQlY0DwARjDKvzQ2CPGsZo+iP
	 614tq4zjdYmrt7ICSTX6KRZxhjewEF5/rAzVDD5AuqCpTJUQldrCnw486rHLhNKwNHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794332144;
	h=DMARC-Filter:From:DKIM-Signature:DKIM-Signature:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=qThPFwQh/YlsuXHUZSO9OIPn8uv/mcMeWuP0/iLWm/M=;
	b=q2mnlPzWqLqL4bYbPkCBNSpwv0uXpze6m/Wctlmw4p5LRTDQWRyW+TRAdr+yqah/a1MK
	 0+qr8Q3EciNnRD/alz5gXrjk1Z/CjuFguncttz5BKZxDjjVfo7SMjYvykmA16S0yU9tpz
	 jzWFzlvEZgbZ0x4Ciin3iARAZK4cg5LoWqKemsWUOxqYtJ2IvM2sg0cPJGbjlzkakkkB8
	 dwuwHj5lJRJ5cbeo96JMmG8kqaVsMyoVjPkMllrLA7awZLzMLmbp1AqmQTPlwvr2hRrLU
	 0UM2ng81yDlkYEkC6l1j1YzAlde77MA7Ji6+IwESwOoFa0m+NPma1rgYd3v+RDS62jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=TIFXR1gL;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=ZKyr49vR;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686A960A3821;
	Tue, 10 Nov 2026 17:35:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 686A960A3821
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=TIFXR1gL;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=ZKyr49vR
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1794332143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qThPFwQh/YlsuXHUZSO9OIPn8uv/mcMeWuP0/iLWm/M=;
	b=TIFXR1gL/W3mCTLQ0SuJim344Vw8LMC1tDMgN5nXuLDDbn05A9f93/xzcB2sfGkTyu6b5g
	l+pNinEX/FLmE6QRDCapda90DkBDJG1Ll+xU3XakPov5oaah1+tEU+uothXQNuxbc9N2qo
	AI0xsNRnEGeRp2lEwKkElUTvsjhAPzsVRxLEo0xbhHOzKAZ76+W1smwdfYgF+GHTq9yEmO
	F4HafTsYNOopRqMQi1OYmoHPGYbx0667GuQYETQBfQjnX9H8suYUz/sPjo/JjuflHNFh/8
	/TOQy+4AqTsXOPXuujmIi8yNCWMQFFm1fiFdhHgNRH4K8MJnao6uq/RIWNmhAw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1794332143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qThPFwQh/YlsuXHUZSO9OIPn8uv/mcMeWuP0/iLWm/M=;
	b=ZKyr49vRhR8SNTnOBremmuW9OJw3mRZt4bDur2ZXqgOebyx7f+st7NC5zahBWMo7+FnEFI
	H4NdhHcafN6W+9AQ==
To: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: John Ogness <john.ogness@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
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
	Qais Yousef <qyousef@layalina.io>
Subject: [PATCH v2 5/7] sched: Limit sysctl sched_rt_{period|runtime}_us to RT_GROUP_SCHED
Date: Tue, 10 Nov 2026 18:34:47 +0100
Message-ID: <20261110-sched_dl-v2-5-cc9399f7aeb1@linutronix.de>
In-Reply-To: <20261110-sched_dl-v2-0-cc9399f7aeb1@linutronix.de>
References: <20261110-sched_dl-v2-0-cc9399f7aeb1@linutronix.de>
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
 kernel/sched/rt.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 1a6450f91d567..855e4ee470f69 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -25,11 +25,22 @@ int sysctl_sched_rt_runtime =3D 1000000;
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
@@ -48,18 +59,15 @@ static const struct ctl_table sched_rt_sysctls[] =3D {
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
@@ -2845,6 +2853,7 @@ int sched_rt_can_attach(struct task_group *tg, struct=
 task_struct *tsk)
 #endif /* !CONFIG_RT_GROUP_SCHED */
=20
 #ifdef CONFIG_SYSCTL
+#ifdef CONFIG_RT_GROUP_SCHED
 static int sched_rt_global_validate(void)
 {
 	if ((sysctl_sched_rt_runtime !=3D RUNTIME_INF) &&
@@ -2853,13 +2862,11 @@ static int sched_rt_global_validate(void)
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
 	return 0;
 }
=20
@@ -2887,6 +2894,7 @@ static int sched_rt_handler(const struct ctl_table *t=
able, int write, void *buff
=20
 	return ret;
 }
+#endif /* !CONFIG_RT_GROUP_SCHED */
=20
 static int sched_rr_handler(const struct ctl_table *table, int write, void=
 *buffer,
 		size_t *lenp, loff_t *ppos)

--=20
2.55.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795441283;
	b=H4PHBMqmXj/kZwGjHxTvk/pd6IVeYalDN44uQvwxvKS4FoE2AzDT1uZa3aZhsAyHNmTz
	 LWSQAz0HJ7QfDVWzFBJ3lEqN/KLwpPDzfTP5duHFKguC6djLNcjJMz32Kbq8mE8IgWmCc
	 Q9OHyMOL46fl3Ldh3PHw27V+dF6LBYx/2fZ5jyg0dlYCerieoee8CSbICjUfSUoKycN1V
	 SEn+ru5FD5eMZUk2CspZufdvcEKu0B3/0x9zRuVZAwDfL3HMFktY18JBLlpXt7fABC29O
	 hP7A5G3f6rQXOF690t3Vvjxp16MymGUNXJzCq43dPXh4b2WL3eqa1IIh7H6od0aeJFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795441283;
	h=DMARC-Filter:From:DKIM-Signature:DKIM-Signature:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=brLBc8W9Y3ec6CKEQmu9jutydKZ1CGkRjeXdsbZR1Ws=;
	b=R9SeCuNqHOv025szmI8xR4TOwm1W/Nq1lf6GwqLh7N9MTpu8eJBJyCbCdEl4pDAC0yDE
	 ERYK9u+ftE0SO2tqPPG5BlzLa3nCCZs1mpMqofIjbrWJ/UeAGXZ2p9mjUO/Xg3EL0/NYu
	 +XMfFAhntsDJNClan7UyYgsKubajArUWO8aj7liN/9dG0JxgZQ+6XDDd2MMT8NfRVcHZ/
	 uWjMtXOyT0OhBjVq5L8jLKJ11kO/0STdRd9JAjrC9Qht/DVIN4UOUGswxjVDhdMMiIFKR
	 pn9NpFK5+5JvM+aJUKvWDiay38mD3tCvyCeDDdl0NjrVQ5NwAZXi47JT25JQ+mqbvvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=Y2j8bAZl;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=v6Cs+nvi;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB22606A338;
	Mon, 23 Nov 2026 13:41:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4AB22606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=Y2j8bAZl;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=v6Cs+nvi
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795441279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=brLBc8W9Y3ec6CKEQmu9jutydKZ1CGkRjeXdsbZR1Ws=;
	b=Y2j8bAZlWCmBcEhNKANVVUrj8Vb+rZYsvVYDQJVSEjfZ7zEZ7RB+RyT3ZsIwvQcmkUb/Tc
	amhEQR9r6XgBE/Rt9sN2RtYt6rVE5h6Rtrb18UdtAafH4/VjvP/bvo+yM3Q7PofjOW0L+A
	xGaXuOKy91DrYkmb2LYjevhiTET1/S3Lhr3TK/e382PbueH14yTD3gQZGtk5KRQG1EFhjy
	BlMVwLvtt0y10NGqgWJCyOUyr9AvycgqCF7Yc5zgE3Xdl8kOYPC4PU9HAZMH5mPOmo5hUc
	SBH5Ip5SBI8SQAXFkqEvos5AAT7wjrWWZBL65itnjagowaZg7yM+NMnInYOwkQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795441279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=brLBc8W9Y3ec6CKEQmu9jutydKZ1CGkRjeXdsbZR1Ws=;
	b=v6Cs+nvi80lJiwn84sJ5LpOkc/TUZGPtireMauVpq0JcWnRRngdUi6D4d480XtRb18nmxQ
	Ky6FrJuzGnHDwJBg==
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
Subject: [PATCH v4 2/6] sched: Move DL's admission control to sysfs
Date: Mon, 23 Nov 2026 14:41:08 +0100
Message-ID: <20261123-sched_dl-v4-2-d523e4d960d3@linutronix.de>
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

SCHED_DL uses the sysctl sched_rt_{period|runtime}_us to configure its
admission control. It is used to verify that it does not allocate more
time globally to SCHED_DL tasks than it can theoretically handle.

This sysctl used to control RT throttling. With the introduction of the
DL server this knob controls RT throttling within a RT-cgroup if
CONFIG_RT_GROUP_SCHED is enabled. In this case the knob is also stuck
and can not be changed. So it can not be used for SCHED_DL control at
all. Unless to disable it by writing -1.

Split the DL bits into its knob at sysfs' location. Once the DL logic
is out, sched_domains_mutex.*() and rebuild_sched_domains() can be
removed from sched_rt_handler().

Move SCHED_DL usage of this sysctl to /sys/kernel/sched/ as
dl_runtime_us + dl_period_us. Replace global_rt_period()/
global_rt_runtime() with sysfs_dl_period/ sysfs_dl_runtime. Store the
new attributes in ns. Move global_rt_period()/ global_rt_runtime() to
CONFIG_RT_GROUP_SCHED.
Preserve compatibility for DL-admission update via the proc interface.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 Documentation/arch/arm64/asymmetric-32bit.rst |   2 +-
 Documentation/scheduler/sched-deadline.rst    |  23 ++--
 kernel/sched/deadline.c                       | 162 ++++++++++++++++++++++=
++--
 kernel/sched/rt.c                             |  13 +--
 kernel/sched/sched.h                          |  33 +++---
 5 files changed, 179 insertions(+), 54 deletions(-)

diff --git a/Documentation/arch/arm64/asymmetric-32bit.rst b/Documentation/=
arch/arm64/asymmetric-32bit.rst
index fc0c350c5e001..375958f8971e5 100644
--- a/Documentation/arch/arm64/asymmetric-32bit.rst
+++ b/Documentation/arch/arm64/asymmetric-32bit.rst
@@ -105,7 +105,7 @@ affinity for the task is updated and any saved mask fro=
m a prior
 Explicit admission of a 32-bit deadline task to the default root domain
 (e.g. by calling ``sched_setattr(2)``) is rejected on an asymmetric
 32-bit system unless admission control is disabled by writing -1 to
-``/proc/sys/kernel/sched_rt_runtime_us``.
+``/sys/kernel/sched/dl_runtime_us``.
=20
 ``execve(2)`` of a 32-bit program from a 64-bit deadline task will
 return ``-ENOEXEC`` if the root domain for the task contains any
diff --git a/Documentation/scheduler/sched-deadline.rst b/Documentation/sch=
eduler/sched-deadline.rst
index 9019b66f6a5ba..4441bb689cca1 100644
--- a/Documentation/scheduler/sched-deadline.rst
+++ b/Documentation/scheduler/sched-deadline.rst
@@ -590,24 +590,19 @@ Deadline Task Scheduling
 4.1 System wide settings
 ------------------------
=20
- The system wide settings are configured under the /proc virtual file syst=
em.
+ The system wide settings are configured under /sys/kernel/sched.
=20
- For now the -rt knobs are used for -deadline admission control and with
- CONFIG_RT_GROUP_SCHED the -deadline runtime is accounted against the (roo=
t)
- -rt runtime. With !CONFIG_RT_GROUP_SCHED the knob only serves for the -dl
- admission control. We realize that this isn't entirely desirable; however=
, it
- is better to have a small interface for now, and be able to change it eas=
ily
- later. The ideal situation (see 5.) is to run -rt tasks from a -deadline
- server; in which case the -rt bandwidth is a direct subset of dl_bw.
+ The ideal situation (see 5.) is to run -rt tasks from a -deadline server;=
 in
+ which case the -rt bandwidth is a direct subset of dl_bw.
=20
  This means that, for a root_domain comprising M CPUs, -deadline tasks
  can be created while the sum of their bandwidths stays below:
=20
-   M * (sched_rt_runtime_us / sched_rt_period_us)
+   M * (dl_runtime_us / dl_period_us)
=20
  It is also possible to disable this bandwidth management logic, and
  be thus free of oversubscribing the system up to any arbitrary level.
- This is done by writing -1 in /proc/sys/kernel/sched_rt_runtime_us.
+ This is done by writing -1 in /sys/kernel/sched/dl_runtime_us.
=20
=20
 4.2 Task interface
@@ -648,11 +643,11 @@ Deadline Task Scheduling
 4.3 Default behavior
 ---------------------
=20
- The default value for SCHED_DEADLINE bandwidth is to have rt_runtime equa=
l to
- 950000. With rt_period equal to 1000000, by default, it means that -deadl=
ine
- tasks can use at most 95%, multiplied by the number of CPUs that compose =
the
+ The default value for SCHED_DEADLINE bandwidth is to have dl_runtime_us e=
qual to
+ 1000000. With rt_period equal to 1000000, by default, it means that -dead=
line
+ tasks can use at most 100%, multiplied by the number of CPUs that compose=
 the
  root_domain, for each root_domain.
- This means that non -deadline tasks will receive at least 5% of the CPU t=
ime,
+ This means that non -deadline tasks will receive at least 0% of the CPU t=
ime,
  and that -deadline tasks will receive their runtime with a guaranteed
  worst-case delay respect to the "deadline" parameter. If "deadline" =3D "=
period"
  and the cpuset mechanism is used to implement partitioned scheduling (see
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index dfae08625342e..49ab477bb9bd1 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -23,6 +23,14 @@
 #include "sched.h"
 #include "pelt.h"
=20
+/*
+ * Admission control for DL tasks. For a root_domain comprising M CPUs,
+ * -deadline tasks can be created while the sum of their bandwidths stays
+ *  below:  M * (dl_runtime / dl_period)
+ */
+static u64 sysfs_dl_period  =3D 1000000 * NSEC_PER_USEC;
+u64 sysfs_dl_runtime =3D 1000000 * NSEC_PER_USEC;
+
 /*
  * Default limits for DL period; on the top end we guard against small util
  * tasks still getting ridiculously long effective runtimes, on the bottom=
 end we
@@ -509,10 +517,10 @@ static void init_dl_rq_bw_ratio(struct dl_rq *dl_rq);
 void init_dl_bw(struct dl_bw *dl_b)
 {
 	raw_spin_lock_init(&dl_b->lock);
-	if (global_rt_runtime() =3D=3D RUNTIME_INF)
+	if (sysfs_dl_runtime =3D=3D RUNTIME_INF)
 		dl_b->bw =3D -1;
 	else
-		dl_b->bw =3D to_ratio(global_rt_period(), global_rt_runtime());
+		dl_b->bw =3D to_ratio(sysfs_dl_period, sysfs_dl_runtime);
 	dl_b->total_bw =3D 0;
 }
=20
@@ -3687,10 +3695,8 @@ DEFINE_SCHED_CLASS(dl) =3D {
  */
 u64 dl_cookie;
=20
-int sched_dl_global_validate(void)
+static int sched_dl_global_validate(u64 runtime, u64 period)
 {
-	u64 runtime =3D global_rt_runtime();
-	u64 period =3D global_rt_period();
 	u64 new_bw =3D to_ratio(period, runtime);
 	u64 cookie =3D ++dl_cookie;
 	struct dl_bw *dl_b;
@@ -3728,18 +3734,18 @@ int sched_dl_global_validate(void)
=20
 static void init_dl_rq_bw_ratio(struct dl_rq *dl_rq)
 {
-	if (global_rt_runtime() =3D=3D RUNTIME_INF) {
+	if (sysfs_dl_runtime =3D=3D RUNTIME_INF) {
 		dl_rq->bw_ratio =3D 1 << RATIO_SHIFT;
 		dl_rq->max_bw =3D dl_rq->extra_bw =3D 1 << BW_SHIFT;
 	} else {
-		dl_rq->bw_ratio =3D to_ratio(global_rt_runtime(),
-			  global_rt_period()) >> (BW_SHIFT - RATIO_SHIFT);
+		dl_rq->bw_ratio =3D to_ratio(sysfs_dl_runtime,
+			  sysfs_dl_period) >> (BW_SHIFT - RATIO_SHIFT);
 		dl_rq->max_bw =3D dl_rq->extra_bw =3D
-			to_ratio(global_rt_period(), global_rt_runtime());
+			to_ratio(sysfs_dl_period, sysfs_dl_runtime);
 	}
 }
=20
-void sched_dl_do_global(void)
+static void sched_dl_do_global(void)
 {
 	u64 new_bw =3D -1;
 	u64 cookie =3D ++dl_cookie;
@@ -3747,8 +3753,8 @@ void sched_dl_do_global(void)
 	int cpu;
 	unsigned long flags;
=20
-	if (global_rt_runtime() !=3D RUNTIME_INF)
-		new_bw =3D to_ratio(global_rt_period(), global_rt_runtime());
+	if (sysfs_dl_runtime !=3D RUNTIME_INF)
+		new_bw =3D to_ratio(sysfs_dl_period, sysfs_dl_runtime);
=20
 	for_each_possible_cpu(cpu)
 		init_dl_rq_bw_ratio(&cpu_rq(cpu)->dl);
@@ -4099,3 +4105,135 @@ void print_dl_stats(struct seq_file *m, int cpu)
 {
 	print_dl_rq(m, cpu, &cpu_rq(cpu)->dl);
 }
+
+#define SCHED_ATTR(_name)					\
+	static struct kobj_attribute sched_attr_## _name =3D	\
+	__ATTR(_name, 0644, sched_attr_##_name##_show, sched_attr_##_name##_store)
+
+int sched_dl_try_boundary(int runtime, int period)
+{
+	static DEFINE_MUTEX(sched_dl_update_lock);
+	u64 runtime_ns, period_ns;
+	int ret;
+
+	guard(mutex)(&sched_dl_update_lock);
+	if (runtime) {
+		if (runtime < 0)
+			runtime_ns =3D RUNTIME_INF;
+		else
+			runtime_ns =3D (u64)runtime * NSEC_PER_USEC;
+	} else {
+		runtime_ns =3D sysfs_dl_runtime;
+	}
+
+	if (period)
+		period_ns =3D (u64)period * NSEC_PER_USEC;
+	else
+		period_ns =3D sysfs_dl_period;
+
+	if (runtime_ns !=3D RUNTIME_INF) {
+		if (runtime_ns > period_ns || runtime_ns > MAX_BW)
+			return -EINVAL;
+	}
+
+	sched_domains_mutex_lock();
+	ret =3D sched_dl_global_validate(runtime_ns, period_ns);
+	if (ret) {
+		sched_domains_mutex_unlock();
+		return ret;
+	}
+
+	sysfs_dl_period =3D period_ns;
+	sysfs_dl_runtime =3D runtime_ns;
+
+	sched_dl_do_global();
+	sched_domains_mutex_unlock();
+	/*
+	 * After changing maximum available bandwidth for DEADLINE, we need to
+	 * recompute per root domain and per cpus variables accordingly.
+	 */
+	rebuild_sched_domains();
+	return 0;
+}
+
+static ssize_t sched_attr_dl_runtime_us_show(struct kobject *kobj,
+					     struct kobj_attribute *attr, char *buf)
+{
+	u64 val =3D sysfs_dl_runtime;
+
+	if (val =3D=3D RUNTIME_INF)
+		val =3D -1;
+	else
+		do_div(val, NSEC_PER_USEC);
+
+	return sysfs_emit(buf, "%lld\n", val);
+}
+
+static ssize_t sched_attr_dl_runtime_us_store(struct kobject *kobj,
+					      struct kobj_attribute *attr,
+					      const char *buf, size_t count)
+{
+	int val, ret;
+
+	ret =3D kstrtoint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	if (!(val =3D=3D -1 || val > 0))
+		return -EINVAL;
+
+	ret =3D sched_dl_try_boundary(val, 0);
+	if (ret)
+		return ret;
+	return count;
+}
+SCHED_ATTR(dl_runtime_us);
+
+static ssize_t sched_attr_dl_period_us_show(struct kobject *kobj,
+					    struct kobj_attribute *attr, char *buf)
+{
+	u64 val =3D sysfs_dl_period;
+
+	do_div(val, NSEC_PER_USEC);
+	return sysfs_emit(buf, "%lld\n", val);
+}
+
+static ssize_t sched_attr_dl_period_us_store(struct kobject *kobj,
+					     struct kobj_attribute *attr,
+					     const char *buf, size_t count)
+{
+	int val, ret;
+
+	ret =3D kstrtoint(buf, 0, &val);
+	if (ret)
+		return ret;
+	if (val <=3D 0)
+		return -EINVAL;
+
+	ret =3D sched_dl_try_boundary(0, val);
+	if (ret)
+		return ret;
+	return count;
+}
+SCHED_ATTR(dl_period_us);
+
+static struct attribute *sched_global_attrs[] =3D {
+	&sched_attr_dl_runtime_us.attr,
+	&sched_attr_dl_period_us.attr,
+	NULL,
+};
+
+static const struct attribute_group sched_global_attrs_group =3D {
+	.attrs =3D sched_global_attrs,
+};
+
+static int __init sched_dl_init(void)
+{
+	struct kobject *sched_kobj;
+
+	sched_kobj =3D kobject_create_and_add("sched", kernel_kobj);
+	if (!sched_kobj)
+		return -ENOMEM;
+	return sysfs_create_group(sched_kobj, &sched_global_attrs_group);
+}
+late_initcall(sched_dl_init);
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index cdeddd3fc9af2..bd37dbf2bebbe 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2871,7 +2871,6 @@ static int sched_rt_handler(const struct ctl_table *t=
able, int write, void *buff
 	int ret;
=20
 	mutex_lock(&mutex);
-	sched_domains_mutex_lock();
 	old_period =3D sysctl_sched_rt_period;
 	old_runtime =3D sysctl_sched_rt_runtime;
=20
@@ -2882,26 +2881,18 @@ static int sched_rt_handler(const struct ctl_table =
*table, int write, void *buff
 		if (ret)
 			goto undo;
=20
-		ret =3D sched_dl_global_validate();
+		ret =3D sched_dl_try_boundary(sysctl_sched_rt_runtime,
+					    sysctl_sched_rt_period);
 		if (ret)
 			goto undo;
-
-		sched_dl_do_global();
 	}
 	if (0) {
 undo:
 		sysctl_sched_rt_period =3D old_period;
 		sysctl_sched_rt_runtime =3D old_runtime;
 	}
-	sched_domains_mutex_unlock();
 	mutex_unlock(&mutex);
=20
-	/*
-	 * After changing maximum available bandwidth for DEADLINE, we need to
-	 * recompute per root domain and per cpus variables accordingly.
-	 */
-	rebuild_sched_domains();
-
 	return ret;
 }
=20
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 4d4128d5600f3..e755572f1cbb1 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -109,6 +109,7 @@ extern long calc_load_fold_active(struct rq *this_rq, l=
ong adjust);
=20
 extern void call_trace_sched_update_nr_running(struct rq *rq, int count);
=20
+extern u64 sysfs_dl_runtime;
 extern int sysctl_sched_rt_period;
 extern int sysctl_sched_rt_runtime;
 extern int sched_rr_timeslice;
@@ -326,7 +327,7 @@ struct rt_bandwidth {
=20
 static inline int dl_bandwidth_enabled(void)
 {
-	return sysctl_sched_rt_runtime >=3D 0;
+	return sysfs_dl_runtime >=3D 0 && sysfs_dl_runtime !=3D RUNTIME_INF;
 }
=20
 /*
@@ -354,8 +355,6 @@ struct dl_bw {
 };
=20
 extern void init_dl_bw(struct dl_bw *dl_b);
-extern int  sched_dl_global_validate(void);
-extern void sched_dl_do_global(void);
 extern int  sched_dl_overflow(struct task_struct *p, int policy, const str=
uct sched_attr *attr);
 extern void __setparam_dl(struct task_struct *p, const struct sched_attr *=
attr);
 extern void __getparam_dl(struct task_struct *p, struct sched_attr *attr, =
unsigned int flags);
@@ -364,6 +363,8 @@ extern bool dl_param_changed(struct task_struct *p, con=
st struct sched_attr *att
 extern int  dl_cpuset_cpumask_can_shrink(const struct cpumask *cur, const =
struct cpumask *trial);
 extern int  dl_bw_deactivate(int cpu);
 extern s64 dl_scaled_delta_exec(struct rq *rq, struct sched_dl_entity *dl_=
se, s64 delta_exec);
+extern int sched_dl_try_boundary(int runtime, int period);
+
 /*
  * SCHED_DEADLINE supports servers (nested scheduling) with the following
  * interface:
@@ -599,6 +600,19 @@ static inline int rt_bandwidth_enabled(void)
 {
 	return sysctl_sched_rt_runtime >=3D 0;
 }
+
+static inline u64 global_rt_period(void)
+{
+	return (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
+}
+
+static inline u64 global_rt_runtime(void)
+{
+	if (sysctl_sched_rt_runtime < 0)
+		return RUNTIME_INF;
+
+	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
+}
 #endif
=20
 extern struct task_group *sched_create_group(struct task_group *parent);
@@ -2532,19 +2546,6 @@ extern union sched_feat_key sched_feat_keys[__SCHED_=
FEAT_NR];
 extern struct static_key_false sched_numa_balancing;
 extern struct static_key_false sched_schedstats;
=20
-static inline u64 global_rt_period(void)
-{
-	return (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
-}
-
-static inline u64 global_rt_runtime(void)
-{
-	if (sysctl_sched_rt_runtime < 0)
-		return RUNTIME_INF;
-
-	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
-}
-
 /*
  * Is p the current execution context?
  */

--=20
2.55.0


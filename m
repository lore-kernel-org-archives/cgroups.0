Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794332146;
	b=XjiJO5c4HS8FB87PTSZtgU0yNdZKioUgIkQ07M+b+A6g1I6C2iDaKViBejls5nD0tci0
	 /k0uJX7SIImYm6FCzzTofpbFGdPalw/sBH9JQSQ59p+LKFtueZIYEwhN0/KL0sll5rIEL
	 ePfap7ZPN5/fS9tSaj66BIEBkid0HFBL3QE2X5Cl+PD4I+7oSURGo68yd82yzK7qECXdd
	 1gTbd04ID45qet2ZPzqrwzj9jPb7M13MNA/CzfyF370cDj8oc+XGMNLck+58ZtYaCIotp
	 FJICrVtmoo37XvNOj5znN1pxTMZPGEBtWWbUUAUySX4IiNIPuKX1IjYMNBnqnG++UJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794332146;
	h=DMARC-Filter:From:DKIM-Signature:DKIM-Signature:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=DpHXja1Sn1bdSvrQOfHx8aWnL8JCMm8nde+yLXZQF3s=;
	b=GQ5klPTXZW1F6cWp1IDbm5SBVfKpUVJFx067gxcjMQldYqCy48Nt2ilxG6zxCiTdV7Y5
	 Br5XjQRSjis1zFzdR8nr9Z/DVjtmqAbyyq5WrwEhytmJ3xOS+ounzjpwIfodT6V9nkjfU
	 75yuDaY5qyqjTyLaQoQaZkdunEGpKnN9+5196ajJqSxIpJpzxNyvAlaROV2VNbc89WbP1
	 rXbN1RZcfHrsZsK5wovDpIKP7wlPB6PUCPP52hGd+POc83p6NgzfXzlDCza8luDTqmsdG
	 /Z1Us2eCHessrko3Ww2AUZI6mwkj9U8bBBTAtU8spnytfwSIVuioXClleYSokxEkHNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=USfhEz7z;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b="LtZ/Gh2Z";
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427C260A3813;
	Tue, 10 Nov 2026 17:35:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 427C260A3813
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=USfhEz7z;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=LtZ/Gh2Z
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1794332143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DpHXja1Sn1bdSvrQOfHx8aWnL8JCMm8nde+yLXZQF3s=;
	b=USfhEz7z3M7tZULL0Z2g3eqP6mkHtv22zuCMv1tPoHsPq2JeLB9De9QKVdT7zOcV5eNLEg
	U+Hp1bKWsdyG8ddxQvlMay/IRk76Kxbt/v8hRhWg6O7YH8r9+dTQhANNGkY0I1xC/A+RvT
	Q4+cA8OHhLD/bHOEWiDKu4hogrUoxMmelYjew91/0sktiVjf6mkZRu60mNJZ2Ub6M4lcZ2
	zy+lbiAjSWhyI3GTM0xhG5GZRaBXG6DJ6XrpcspwdbgO+VgO3tM+L7vxcHJqiLO8WVcBGh
	6VokIDa6fd8+wRU0fOHj3gWZ5NUJM2gzUbhyYGCLM4mJRBtuZFQhnGI1+pI+bw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1794332143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DpHXja1Sn1bdSvrQOfHx8aWnL8JCMm8nde+yLXZQF3s=;
	b=LtZ/Gh2Z9flFrNxCM/fMtnBzop8G/rHkqkJJJIEDlCG/7immcnNVkKynNWyFJDgEf9m5VE
	1L8y0HYQHgde53AQ==
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
Subject: [PATCH v2 6/7] sched: Add sysfs files for the per-CPU fair_server knobs
Date: Tue, 10 Nov 2026 18:34:48 +0100
Message-ID: <20261110-sched_dl-v2-6-cc9399f7aeb1@linutronix.de>
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

The fair_server exposes the runtime and period knobs per-CPU in the
debugfs folder. The debugfs interface is not a stable ABI.
Make the /sys/kernel/debug/sched/fair_server/cpu*/{period|runtime} knobs
available as /sys/kernel/sched/cpuX/{fair_server_period|fair_server_runtime=
}.

It adds a struct kobject to the rq and exposes only those two. The
per-runqueue folder is named `cpu' rather than `rq' since it might be
more intuitive to the user than `rq' or `runqueue'.

The set logic is pulled from the debugfs folder but it is still shared.
That debugfs logic could be removed (after providing the same for
ext-server) or symlinked for a while.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/sched/deadline.c | 152 ++++++++++++++++++++++++++++++++++++++++++++=
+++-
 kernel/sched/debug.c    |  56 ++----------------
 kernel/sched/sched.h    |   8 +++
 3 files changed, 163 insertions(+), 53 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index c5a2499a1450a..b574135f45e7e 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -4131,6 +4131,59 @@ void print_dl_stats(struct seq_file *m, int cpu)
 	print_dl_rq(m, cpu, &cpu_rq(cpu)->dl);
 }
=20
+static unsigned long dl_server_period_max =3D (1UL << 22) * NSEC_PER_USEC;=
 /* ~4 seconds */
+static unsigned long dl_server_period_min =3D (100) * NSEC_PER_USEC;     /=
* 100 us */
+
+int __sched_server_write_common(enum dl_param param, u64 value, struct rq =
*rq,
+				struct sched_dl_entity *dl_se, const char *sname)
+{
+	u64 old_runtime, runtime, period;
+	int retval =3D 0;
+
+	scoped_guard (rq_lock_irqsave, rq) {
+		old_runtime =3D runtime =3D dl_se->dl_runtime;
+		period =3D dl_se->dl_period;
+
+		switch (param) {
+		case DL_RUNTIME:
+			if (runtime =3D=3D value)
+				break;
+			runtime =3D value;
+			break;
+		case DL_PERIOD:
+			if (value =3D=3D period)
+				break;
+			period =3D value;
+			break;
+		}
+
+		if (runtime > period ||
+		    period > dl_server_period_max ||
+		    period < dl_server_period_min) {
+			return  -EINVAL;
+		}
+
+		if (!cpu_online(cpu_of(rq)))
+			return -EBUSY;
+
+		update_rq_clock(rq);
+		dl_server_stop(dl_se);
+		retval =3D dl_server_apply_params(dl_se, runtime, period, 0);
+		dl_server_start(dl_se);
+
+		if (retval < 0)
+			return retval;
+	}
+	if (!!old_runtime ^ !!runtime) {
+		pr_info("%s server %sabled on CPU %d%s.\n",
+			sname,
+			runtime ? "en" : "dis",
+			cpu_of(rq),
+			runtime ? "" : ", system may malfunction due to starvation");
+	}
+	return 0;
+}
+
 #define SCHED_ATTR(_name)					\
 	static struct kobj_attribute sched_attr_## _name =3D	\
 	__ATTR(_name, 0644, sched_attr_##_name##_show, sched_attr_##_name##_store)
@@ -4253,13 +4306,110 @@ static const struct attribute_group sched_global_a=
ttrs_group =3D {
 	.attrs =3D sched_global_attrs,
 };
=20
+/* RQ */
+#define RQ_ATTR(_name)						\
+	static struct kobj_attribute rq_## _name =3D	\
+	__ATTR(_name, 0644, rq_##_name##_show, rq_##_name##_store)
+
+#define kobj_to_rq(__kobj) container_of(__kobj, struct rq, rq_kobj)
+
+static ssize_t rq_fair_server_runtime_show(struct kobject *kobj, struct ko=
bj_attribute *attr,
+					   char *buf)
+{
+	struct rq *rq =3D kobj_to_rq(kobj);
+	struct sched_dl_entity *dl_se;
+
+	dl_se =3D &rq->fair_server;
+
+	return sysfs_emit(buf, "%llu\n", dl_se->dl_runtime);
+}
+
+static ssize_t rq_fair_server_runtime_store(struct kobject *kobj, struct k=
obj_attribute *attr,
+					    const char *buf, size_t count)
+{
+	struct rq *rq =3D kobj_to_rq(kobj);
+	u64 val;
+	int ret;
+
+	ret =3D kstrtoull(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	ret =3D  __sched_server_write_common(DL_RUNTIME, val, rq, &rq->fair_serve=
r, "Fair");
+	if (ret)
+		return ret;
+	return count;
+}
+RQ_ATTR(fair_server_runtime);
+
+static ssize_t rq_fair_server_period_show(struct kobject *kobj, struct kob=
j_attribute *attr,
+					  char *buf)
+{
+	struct rq *rq =3D kobj_to_rq(kobj);
+	struct sched_dl_entity *dl_se;
+
+	dl_se =3D &rq->fair_server;
+
+	return sysfs_emit(buf, "%llu\n", dl_se->dl_period);
+}
+
+static ssize_t rq_fair_server_period_store(struct kobject *kobj, struct ko=
bj_attribute *attr,
+					   const char *buf, size_t count)
+{
+	struct rq *rq =3D kobj_to_rq(kobj);
+	u64 val;
+	int ret;
+
+	ret =3D kstrtoull(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	ret =3D  __sched_server_write_common(DL_PERIOD, val, rq, &rq->fair_server=
, "Fair");
+	if (ret)
+		return ret;
+	return count;
+}
+RQ_ATTR(fair_server_period);
+
+static struct attribute *rq_attrs[] =3D {
+	&rq_fair_server_runtime.attr,
+	&rq_fair_server_period.attr,
+	NULL
+};
+ATTRIBUTE_GROUPS(rq);
+
+static const struct kobj_type rq_ktype =3D {
+	.sysfs_ops      =3D &kobj_sysfs_ops,
+	.default_groups =3D rq_groups,
+};
+
+static int sched_create_rq_sysfs(struct kobject *sched_kobj)
+{
+	unsigned int cpu;
+	int ret;
+
+	for_each_possible_cpu(cpu) {
+		struct rq *rq =3D cpu_rq(cpu);
+
+		ret =3D kobject_init_and_add(&rq->rq_kobj, &rq_ktype, sched_kobj,
+					   "cpu%d", cpu);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
 static int __init sched_dl_init(void)
 {
 	struct kobject *sched_kobj;
+	int ret;
=20
 	sched_kobj =3D kobject_create_and_add("sched", kernel_kobj);
 	if (!sched_kobj)
 		return -ENOMEM;
-	return sysfs_create_group(sched_kobj, &sched_global_attrs_group);
+	ret =3D sysfs_create_group(sched_kobj, &sched_global_attrs_group);
+	if (ret)
+		return ret;
+	return sched_create_rq_sysfs(sched_kobj);
 }
 late_initcall(sched_dl_init);
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index e6a3b516c703b..0e0782603a99a 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -363,23 +363,13 @@ static const struct file_operations sched_debug_fops =
=3D {
 	.release	=3D seq_release,
 };
=20
-enum dl_param {
-	DL_RUNTIME =3D 0,
-	DL_PERIOD,
-};
-
-static unsigned long dl_server_period_max =3D (1UL << 22) * NSEC_PER_USEC;=
 /* ~4 seconds */
-static unsigned long dl_server_period_min =3D (100) * NSEC_PER_USEC;     /=
* 100 us */
-
 static ssize_t sched_server_write_common(struct file *filp, const char __u=
ser *ubuf,
 					 size_t cnt, loff_t *ppos, enum dl_param param,
 					 void *server)
 {
 	long cpu =3D (long) ((struct seq_file *) filp->private_data)->private;
 	struct sched_dl_entity *dl_se =3D (struct sched_dl_entity *)server;
-	u64 old_runtime, runtime, period;
 	struct rq *rq =3D cpu_rq(cpu);
-	int retval =3D 0;
 	size_t err;
 	u64 value;
=20
@@ -387,48 +377,10 @@ static ssize_t sched_server_write_common(struct file =
*filp, const char __user *u
 	if (err)
 		return err;
=20
-	scoped_guard (rq_lock_irqsave, rq) {
-		old_runtime =3D runtime =3D dl_se->dl_runtime;
-		period =3D dl_se->dl_period;
-
-		switch (param) {
-		case DL_RUNTIME:
-			if (runtime =3D=3D value)
-				break;
-			runtime =3D value;
-			break;
-		case DL_PERIOD:
-			if (value =3D=3D period)
-				break;
-			period =3D value;
-			break;
-		}
-
-		if (runtime > period ||
-		    period > dl_server_period_max ||
-		    period < dl_server_period_min) {
-			return  -EINVAL;
-		}
-
-		if (!cpu_online(cpu_of(rq)))
-			return -EBUSY;
-
-		update_rq_clock(rq);
-		dl_server_stop(dl_se);
-		retval =3D dl_server_apply_params(dl_se, runtime, period, 0);
-		dl_server_start(dl_se);
-
-		if (retval < 0)
-			return retval;
-	}
-
-	if (!!old_runtime ^ !!runtime) {
-		pr_info("%s server %sabled on CPU %d%s.\n",
-			server =3D=3D &rq->fair_server ? "Fair" : "Ext",
-			runtime ? "en" : "dis",
-			cpu_of(rq),
-			runtime ? "" : ", system may malfunction due to starvation");
-	}
+	err =3D __sched_server_write_common(param, value, rq, dl_se,
+					  server =3D=3D &rq->fair_server ? "Fair" : "Ext");
+	if (err)
+		return err;
=20
 	*ppos +=3D cnt;
 	return cnt;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 5f99f5ef415e7..8f813d9df0cc5 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1432,6 +1432,7 @@ struct rq {
 #endif
=20
 	atomic_t		nr_iowait;
+	struct kobject		rq_kobj;
 } __no_randomize_layout;
=20
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -3507,6 +3508,13 @@ extern void print_cfs_rq(struct seq_file *m, int cpu=
, struct cfs_rq *cfs_rq);
 extern void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq);
 extern void print_dl_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq);
=20
+enum dl_param {
+	DL_RUNTIME =3D 0,
+	DL_PERIOD,
+};
+extern int __sched_server_write_common(enum dl_param param, u64 value, str=
uct rq *rq,
+				       struct sched_dl_entity *dl_se, const char *sname);
+
 extern void resched_latency_warn(int cpu, u64 latency);
=20
 #ifdef CONFIG_NUMA_BALANCING

--=20
2.55.0


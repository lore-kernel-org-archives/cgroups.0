Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795441284;
	b=xE9cMf8wH1v11R1Q8DAqQLQ1RSRu8+6UP3XXJxVeVHaJlH13DHUV2rgt1kAf3iAcnXHv
	 foPWJcesyrnnBcsWFz4NmawWAW3Vn+4qVEQ5n+Hgl49LdRcDz8d1QcJapJsRAlieI6JWD
	 KM5C/asXHUBNYDqyrqtxYBxnO59YrBlPob9gTw22pglV4fx/vNH2jtD4SZ6kPT2YRVTB3
	 K8E5SkK3kZ/0C0vYZhhmgygu6iFFm2OQnLSqLUBKNKVuz3y7IjYbin6gjEM4NIcoHu3V1
	 /vUDt/7ovJ2+I2i4Hremy71B0WybW61alaDmFcxW0koCRDNu/1ogp9AW5aZxTIdg1OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795441284;
	h=DMARC-Filter:From:DKIM-Signature:DKIM-Signature:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=G4f4khOqJyPAuwGJMhRWhrTJB44nQh+QIvpHf6ZOuyc=;
	b=jgLyuPic1OC2NG1vmyflYWL0XZDLMsf5iqY9aRZU475hR0/mUmTshFvKRyyX8SXLDSwA
	 9Na+r0AA6qlALm/jqf7P5hoZP03HCxUAuIqHAUWg+WuJfgap0S+YiPJLhoNgjA7534ObB
	 f0Cf0Md73zCz4d3+lbtVWIlgZAWM+M0JoAL2kUhCG90htzjVdvpiP2dRekqBMjvmTZ2kX
	 KCPd2QLNaxSPNsyEppua50nX/Nr+UihxtWIjO/9yDzRDXrITzY+vTr98PHql0AOVEQ01d
	 yA185+M/6tHKTWFV+npRRnMEuvVOxJYEIAvdND/lJLxeCs43cY0s8yCJ4f67HnUdU2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b="p3bpX/Q8";
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=7RVlango;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612C2606A682;
	Mon, 23 Nov 2026 13:41:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 612C2606A682
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=p3bpX/Q8;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=7RVlango
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795441281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G4f4khOqJyPAuwGJMhRWhrTJB44nQh+QIvpHf6ZOuyc=;
	b=p3bpX/Q8phtlm1UV1Ncp7UTCdS6lV9qhKldBfuPRAGsXRN+yGBkhmONd5aJsnzmlHNfgDc
	p0o3l6RitTpWeIGYUGmRG44Tf937DH/LWicLyWZq6XL5ORz4ZXHizf7ndv0sW3oNh0z5H2
	e9+oGgJiiahD27+z6e9J0y5dhWYAc0MKwzTXc/oOQaWmYIbuzeHAoFpPdmoVWCXz1Lk/NH
	BAFG6W15uHrJDEQKZAdv2jjw/Nd0PFDMkXC3dKYwxvB+ygVO+73NDDKGLy3iBFP/JrfCX1
	9+XoLqI82p+qdbO5xm908q/m0qTAGN54irdcw6+2+uzd1oq1YlFe9Q2B9gcsfw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795441281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G4f4khOqJyPAuwGJMhRWhrTJB44nQh+QIvpHf6ZOuyc=;
	b=7RVlangob+3BzLdmXEd0rTsc3FpVolIL01wTE7rq+NywSa+ruD+gDkj+yiH/PtItgac68I
	PaNJS7W2ToKDP1DA==
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
Subject: [PATCH v4 3/6] sched: Add sysfs files for the per-CPU fair_server knobs
Date: Mon, 23 Nov 2026 14:41:09 +0100
Message-ID: <20261123-sched_dl-v4-3-d523e4d960d3@linutronix.de>
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
index 49ab477bb9bd1..64e20e281b016 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -4106,6 +4106,59 @@ void print_dl_stats(struct seq_file *m, int cpu)
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
@@ -4227,13 +4280,110 @@ static const struct attribute_group sched_global_a=
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
index dcf9b1daf3d06..e533cd0e085ca 100644
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
index e755572f1cbb1..eb215e3ac1260 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1443,6 +1443,7 @@ struct rq {
 #endif
=20
 	atomic_t		nr_iowait;
+	struct kobject		rq_kobj;
 } __no_randomize_layout;
=20
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -3537,6 +3538,13 @@ extern void print_cfs_rq(struct seq_file *m, int cpu=
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


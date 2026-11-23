Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795441285;
	b=rgtASj3ffQZ4KgVnawag65xsXGbJpTsBa1cTpj4Z3/sH+nmoXzjrQTS0stCNHscVGkYT
	 yo+t+PVmvBQIxPCmyRbRak2QHLcg6kpY8HzSM7fazpJ3m4epgpyNvwG+NqOmlITZs5jpt
	 rgD7BINEcpAZKKf9nzbBqAAFoaBOYCOeHXMs7QWHzGGYl2asqWpU1kEWYBt8VZZaCYXYl
	 lfmC3F657sZom2VolS05D3A7Bg7wBXlCcebbeYOxh0wqXMdRtZRRToE6xpjdtg5Wp2Wom
	 +9oq5r1JKa+I7Ig4Zmra1K/KexHOMam0mW86idLRw+9rNYI490E23tZV8guvKF/weFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795441285;
	h=DMARC-Filter:From:DKIM-Signature:DKIM-Signature:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=2C5LERpIR4RerF/oqQKKb980WkL3XrIcGTt7ILAE0M8=;
	b=3gGAe7JyflUBTssGY8+aPSxah75HRkULA9wUkAvzc0c7bFzPxX1o6E9tzwr0fnEEmwzQ
	 u/OaRSI4RobElmyhQ6hbUmxCJEOkPo2rF/+6j6QmGbp/7cstRU0lULXovRzJXJO0h9XfB
	 SUkcm3T3Eh56RTjk2Ss1HyRsvTIrEdQkmNEerjCG4KZ9hX6N+PWWtvWLhFKpMtYXQGuhy
	 1tQCzUC2QS6TcKc44TReD1sq0yaSgWj/6oALPJQGd+sHMFRDVqHtA/xdT0thnbx4JcXF2
	 OfCEXRXOh+t52zRZIIgYCnYezvM5uybx/IW/FhiLrJMiVm8VepfMWfijhVVnPPBReGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=MnfTLWI5;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b="1+B/jNg3";
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD96606A693;
	Mon, 23 Nov 2026 13:41:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BD96606A693
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=MnfTLWI5;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=1+B/jNg3
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795441282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2C5LERpIR4RerF/oqQKKb980WkL3XrIcGTt7ILAE0M8=;
	b=MnfTLWI5bPSoDROgNwQ4QweduyrCrgNv/9kr9vXAF2HiZNA/bi+OP1o32yM0VWw6r4KZbf
	VXKfUrgTO5Pp/MCG1xq1VQZ4NAjVq8M4vqN+ZGc01DD6jvN8ONnYlvHXAighS9RQSGCXHK
	ceFSWLlaWr0IyX/zCT23y97YBraJ2DAiwHtGK4n658vjQDOYEDkGn06Qr1y0jTYuczL4MI
	dNoO6X6eQHWzGquiYIQt7tBCRBNZU1mswr0dFM6DTcjdRcsxACpG03q1ZvdXvWe60buenw
	5CZ9mZKe0EwUw/ygvjMY7Pur0mY4moJ+XflMBYG3KXrd5U6mZuBQDqFhhxPqyA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795441282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2C5LERpIR4RerF/oqQKKb980WkL3XrIcGTt7ILAE0M8=;
	b=1+B/jNg3CkgWgxfm9fgcXhzQupBdQYnBqY6yUBEyiB9sYEGTXMNYGiyTo8jYRnNh1B24Qy
	IoV6bMmLCBKJ2+Dw==
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
Subject: [PATCH v4 4/6] sched: Limit sysctl sched_rt_{period|runtime}_us to RT_GROUP_SCHED
Date: Mon, 23 Nov 2026 14:41:10 +0100
Message-ID: <20261123-sched_dl-v4-4-d523e4d960d3@linutronix.de>
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
 kernel/sched/rt.c    | 8 ++++++++
 kernel/sched/sched.h | 5 +++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index bd37dbf2bebbe..258b187459bb9 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2877,6 +2877,14 @@ static int sched_rt_handler(const struct ctl_table *=
table, int write, void *buff
 	ret =3D proc_dointvec_minmax(table, write, buffer, lenp, ppos);
=20
 	if (!ret && write) {
+		if (!IS_ENABLED(CONFIG_RT_GROUP_SCHED)) {
+			const char *msg =3D
+			"Please note that DL admission control (via sched_rt_period_us, sched_r=
t_runtime_us) moved to sysfs.\n"
+			"This update will be mirrored. Controls for RT throttling moved to the =
fair_server.\n"
+			"This will not be mirrored. The fair_server settings are under /sys/ker=
nel/sched/cpuX/.\n";
+
+			pr_warn_once("%s", msg);
+		}
 		ret =3D sched_rt_global_validate();
 		if (ret)
 			goto undo;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index eb215e3ac1260..922708b6aad65 100644
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
@@ -585,6 +583,9 @@ extern void unthrottle_cfs_rq(struct cfs_rq *cfs_rq);
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


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794332144;
	b=xK7EOrMXwJ7lcgRssttSWV1in8wSmDgQRG7okuueKoH6+gvHvk5FCC0eun58a29ubXWV
	 1RaOUWW3AtdyucGiH2XSo+KA+zbkz3fWjENZ72Pr9kKBGvX0AtB6dBPvjfpawEMcnBLnd
	 y7fheQhQ+UzdrtOmyTnoIL5BCFueMbXjeIvreDB85wNQdYXopNXQQVPnLZDj/KRLBbN5P
	 Y11Gsz4WYiGx40AgtCBu+sAAq9OmTlNTTVM6x9VhCK2XvxtpLNZU99adygJV2p7mN8HkR
	 cUP68AxLRQkod+5ypkGdhvRYqr752dHia80IaqHup0gtOOuo0vXC5GsGvZ/qIxMuf0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794332144;
	h=DMARC-Filter:From:DKIM-Signature:DKIM-Signature:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=4JIm60LJ5BNoX0E6sxAPVbVA/swv83hxBeMq2hHYq+w=;
	b=hIZZ9/Ie+LMpfGD+57wcAs0PfP2epl6d4ufodHwdvPfCK3e2JgTISbsCyCT2whIuRn7A
	 7FBRYjE93UAgZnP3jYFkxx4zCTFjYanQjWjt7PZcMJyIk3gu2jtP0NHfC/TvnvkNuZ29F
	 C/8zqjm/sgZCIlbMvJS7vzWFnxlVGKMC7VaDdqYJo1EcvgMW72i0lV5xOK6mQQcUJIFFj
	 8FyT72lZlIP3ryN0vzUs1KUUn20yJIhSN7FJfv+HYZJgCSk6bGs3k1sZ8RouW/ujLxWm5
	 5JmZWmnnikCi180DA+C7YFVA1a3iMQKps5jmbf6sf1kqWw0CPXhYlUE/hdYYfrSkwtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=umAS+QZj;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=qnlzkLti;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0BE60A380E;
	Tue, 10 Nov 2026 17:35:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E0BE60A380E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=umAS+QZj;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=qnlzkLti
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1794332141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4JIm60LJ5BNoX0E6sxAPVbVA/swv83hxBeMq2hHYq+w=;
	b=umAS+QZj4g3YkRYy1Epd5TPvM0FbTysr2rIvd7vkzhaw+eiDIBK20EaaiDYiRftRgsqDoa
	WVbvQbQscQYllsr8e/rYiKBVFQubMWwk76RT+rAMeWyRzRwc3dX/ye6P1q0MDpnZlzr+EW
	LqEK4nqLFSuE58Y7SDPielIfg1YLz8dFlNY/5DNv7DBlQqs3omOjWJl5pXd6z7QiBxzjlG
	+JW24Gp3FBpzq8lu5c6/bq8//cW508gUQLgiVksTUDzM6KFf8hxy/mwCYHLSPaqeYQbB0J
	qXJBacab6Q0uM+FkLa88urkfdvSWj+prme60Z/BIaogGtY7MfmO7qZa/cnI4fA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1794332141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4JIm60LJ5BNoX0E6sxAPVbVA/swv83hxBeMq2hHYq+w=;
	b=qnlzkLti9C+8CgaIcq5SX1SiEInm4mApuMkZSPOArEIQVbnPQTmMdjzfm0qSrxfI77HvhD
	VWu+GcxoBaLHmnCw==
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
Subject: [PATCH v2 3/7] sched: rcutorture: Allow to disable DL fair_server
Date: Tue, 10 Nov 2026 18:34:45 +0100
Message-ID: <20261110-sched_dl-v2-3-cc9399f7aeb1@linutronix.de>
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

The rcutorture test used to disable RT throttling only in the built-in
mode and this functionality got lost while RT throttling was moved to
the fair_server.
Enabling this option (built-in) slows down the system considerably.
Therefore it makes little sense to enable the fair_server once the test
is done since a reboot comes next.

Add dl_server_fair_disable() do disable the fair_server which can only
be used by rcutorture.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/rcu/rcutorture.c |  4 ++++
 kernel/sched/deadline.c | 25 +++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index aecc4da7161bb..f6f1c0eb2dc73 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1333,6 +1333,8 @@ static unsigned long rcutorture_seq_diff(unsigned lon=
g new, unsigned long old)
 	return cur_ops->gp_diff(new, old);
 }
=20
+void dl_server_fair_disable(unsigned int cpu);
+
 static bool rcu_torture_boost_failed(unsigned long gp_state, unsigned long=
 *start)
 {
 	int cpu;
@@ -3394,6 +3396,8 @@ static int rcutorture_booster_init(unsigned int cpu)
=20
 	/* Don't allow time recalculation while creating a new task. */
 	mutex_lock(&boost_mutex);
+	if (IS_BUILTIN(CONFIG_RCU_TORTURE_TEST))
+		dl_server_fair_disable(cpu);
 	VERBOSE_TOROUT_STRING("Creating rcu_torture_boost task");
 	boost_tasks[cpu] =3D kthread_run_on_cpu(rcu_torture_boost, NULL,
 					      cpu, "rcu_torture_boost_%u");
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index dfae08625342e..24633af261be6 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1947,6 +1947,31 @@ int dl_server_apply_params(struct sched_dl_entity *d=
l_se, u64 runtime, u64 perio
 	return 0;
 }
=20
+#ifdef CONFIG_RCU_TORTURE_TEST
+/*
+ * The RCU-TORTURE built-in test will disable fair-server to avoid any
+ * throttling while testing RCU-boosting.
+ * If compiled as module then the user needs to disable it manually before
+ * loading the module.
+ */
+void dl_server_fair_disable(unsigned int cpu);
+
+void dl_server_fair_disable(unsigned int cpu)
+{
+	struct rq *rq =3D cpu_rq(cpu);
+	int retval;
+
+	scoped_guard (rq_lock_irqsave, rq) {
+		struct sched_dl_entity *dl_se =3D &rq->fair_server;
+
+		update_rq_clock(rq);
+		dl_server_stop(dl_se);
+		retval =3D dl_server_apply_params(dl_se, 0, dl_se->dl_period, 0);
+	}
+	WARN_ON_ONCE(retval);
+}
+#endif
+
 /*
  * Add @dl_se's bw to the root-domain accounting.
  *

--=20
2.55.0


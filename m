Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794567038;
	b=dbrNYQMMSbD5vBlirnLfG92XIA8i4YnO9adnzX9yDKeb4RazUsVqAnMdJG7wetSHG3pX
	 4cZSBzbO6ICjQ65oocbjuZiWTVAZXaNGk9ISmMwM26Eon1SYVhJdfcramKEBjVJdceXT9
	 Ts+TErmg648vyh8yjk+boF5INpnn1Lgw9lMRblNeO1dH2PZKiPQ4CkGlZ6ibXQpKlGkuE
	 qridvA0PVGa4mRk5KHU+7LXPlvZyMTKF3jktWQp6K4dFV7RYES0/890Rpew3h4A+sb+3a
	 W9lPDFNFmYzkpfFop5iDDN0dImc8efKmbe4zS7OhdtJ1g2bziD4deNtPYroSHR+Tsiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794567038;
	h=DMARC-Filter:From:DKIM-Signature:DKIM-Signature:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=15wtnSkdKQvbPfkLyNOi0tT6njNQ/nSioq6SltVvP+Q=;
	b=ViLsrO6F3bOoOffv8mftcu3DVcBKuGQwOx+hKhaxPO9jcHLTaXVyobJ/rzBrg2/l5ucB
	 PYBEId0k6oSQDjFlOsUpszv2fQFJ43sWexOTsH27QAjnrIdJ1V5mKi3fvxRacJ+ymqlJ0
	 1QxJktRVfU+ADhv52RAccWxvE5GnIg2xZiTTJaz9WhKBSrl5iaxH2wo0RvSXcJjDGrryl
	 4AYl5Yskyp8cWyd0M5RKk/yDLuQBKcWQAwoly1QyHa8a4P4+GvX1pGZuO+7FZbuidtNl9
	 rpd/qeK2fJ5ZJ4pUVBMliB4WIBoe5I4I9nSrUyp2JhAKCg1Wl8G0iKob+rdmypp44HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=MSy5lv1c;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=chyKSOyd;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D976B606A893;
	Fri, 13 Nov 2026 10:50:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D976B606A893
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=MSy5lv1c;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=chyKSOyd
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1794567036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=15wtnSkdKQvbPfkLyNOi0tT6njNQ/nSioq6SltVvP+Q=;
	b=MSy5lv1cvnFILTXSQ9v1lo4GcHN434ID5jN11A+geXb0H9qK7aiw94egvSNfagR+A6d9PZ
	O+To9FfVsNVJ7MyiD+qvRxvBcVCk4WADYCiMfec+aFScULSfCT5oyKTX1Msddtvd1KOpt1
	CZ+ehxATdonMna5CCSl29Dz0SYbDRTBmqaldNTSuNkGRAroCGCvYcm6Ky/Z7ufX7VfxCtO
	IKon32QiKSzhDgd0FbIpMSTvHXrt61htGn4FMx9lYgBafyraj+3XCxRUL9ZSDz06lUfD5Z
	v232IMdPTu3dfe8AfxRuHe0gjLXw8pVjP5edp0lYm97qpT2yKFriSb89xSZjPg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1794567036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=15wtnSkdKQvbPfkLyNOi0tT6njNQ/nSioq6SltVvP+Q=;
	b=chyKSOydmNTCkQbvoesPWAVuTu340N7N9Rto4sT2IXCoHGT2ctu46lmhkHRtiFaR6M92pH
	sdiw9OnUjZVJyuDQ==
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
Subject: [PATCH v3 4/8] sched: rcutorture: Allow to disable DL fair_server
Date: Fri, 13 Nov 2026 11:50:25 +0100
Message-ID: <20261113-sched_dl-v3-4-a76ffa1cdeee@linutronix.de>
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

The rcutorture test used to disable RT throttling only in the built-in
mode and this functionality got lost while RT throttling was moved to
the fair_server.
Enabling this option (built-in) slows down the system considerably.
Therefore it makes little sense to enable the fair_server once the test
is done since a reboot comes next.

The fair server can not be disabled from the hotplug notifier because
the CPU must be marked active. Instead of this off-switch an alternative
would be to skip sched_init_dl_servers().

Add dl_server_fair_disable() do disable the fair_server which can only
be used by rcutorture. Use dl_server_fair_disable() in
rcu_torture_boost() which is invoked on the CPU which should have the
fair_server disabled.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/rcu/rcutorture.c |  4 ++++
 kernel/sched/deadline.c | 28 ++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index aecc4da7161bb..5c434cb3ef732 100644
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
@@ -1402,6 +1404,8 @@ static int rcu_torture_boost(void *arg)
 		}
 		VERBOSE_TOROUT_STRING("rcu_torture_boost finished holdoff period");
 	}
+	if (IS_BUILTIN(CONFIG_RCU_TORTURE_TEST))
+		dl_server_fair_disable(smp_processor_id());
=20
 	/* Set real-time priority. */
 	sched_set_fifo_low(current);
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 10beb54281881..a713ad9dd6208 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1950,6 +1950,34 @@ int dl_server_apply_params(struct sched_dl_entity *d=
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
+		if (dl_se->dl_runtime =3D=3D 0)
+			return;
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


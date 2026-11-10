Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794332143;
	b=sYqu6bbTQDgQQVxg60NAWQH6crgyg/nwkCDIWo20Z1OfED+OMg1byn9oNHlrTPpfrDlk
	 UDyP/TXuBGZVoGO0mAVIV6VDhTBWlxxHO87aVKyVBfOI1OvRCdjDp1goHJUWtEDrN6AVV
	 hpGTqEjweQcTHQnU4SKaVgG++IgYX5Q8hfPy5cuhAjcYBHsX4dWSJDcMT8nKkaOJfxztF
	 g3IHiGhqD0OGZzC921NZWHubGwK7ZKdcPwMQRchziTWP3xo0aEZTn3fj/bqRG+AjtfVn7
	 y6JRn3Kdd4xhp7AtDJJ/7Nwh/pDWfA8BWyOyoQkdh2cNWQzQKQ+QgE9pgX8m+mpeCNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794332143;
	h=DMARC-Filter:From:DKIM-Signature:DKIM-Signature:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=pY0XB2Amvb6YQszTSQKoVgy7OfnT7ScdY0OEf4Q2BEM=;
	b=MJNhRdeoKGt/pWjocA8AjTAa63UAJzCuYqJPleNZ3LGx0TqJfI5aUHh3c/ufNluHL79q
	 wxPVIr35Ymp+cJF1Xx6rkjI66+HAdJeS0TGkFBqEJVDMexU8i0A3yHVYaJZtMQCq6xJUg
	 /sAuK497xa62N8KpCc4hYmo+56UjHHcsOVPoSToPooiJwBAQy1V8vxydt0O+PgMUfu9VK
	 0FBrdZXLprxlslBLpedsBVY3mr0PD6sKYn4/yNmoh+ubhzKLKtM89DjINM3wplolIIQOe
	 hDsAsKuk7dkFAktLTbwP80KM45MHL8KGGFPjPISOm8cWMieS3qqo/whcMb9qjR4FGlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=i1sfQVYj;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=BzT6gKr6;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8681F60A2601;
	Tue, 10 Nov 2026 17:35:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8681F60A2601
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=i1sfQVYj;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=BzT6gKr6
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1794332141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pY0XB2Amvb6YQszTSQKoVgy7OfnT7ScdY0OEf4Q2BEM=;
	b=i1sfQVYjdv7Glk+c/iQHPNVTEqtT0whf6VRXvyuUxKnP/9SJPQbD6ts3LyLMivXJhuajDw
	66tSlsfAoR0DdXr4oDRuMLUOfDKgYuo+j/E33r16ax81rPhY7Y/hfCuBGEWKN/JqQzz0R8
	A7MiZOpsLERGu5qgDK2nG66vmot2rWB7zDvPugKCUlSY9xkmXO0b3A9KtCFtxTGFAnNxKU
	Ur1KL9q9U9NN9fvSMpv0oEnkooqUGGiV9j6J8j1U0/QabYHn3L5ArLI79iMv0OeN2owMOz
	QmhAzYOy66iyOStrlP+7ejX6+UvLoLAmIkdE0hhbTSS5bcQQPLsfjdGCPUSVCA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1794332141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pY0XB2Amvb6YQszTSQKoVgy7OfnT7ScdY0OEf4Q2BEM=;
	b=BzT6gKr6E5kwSvvhCL65bDrFF6NcWkK8dVkKgLqE77+xMCSAuQIHUA6syuj/IriJtBO00y
	yUv44O5ykfns1DBQ==
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
Subject: [PATCH v2 2/7] rcutorture: Don't try to disable to RT throttling.
Date: Tue, 10 Nov 2026 18:34:44 +0100
Message-ID: <20261110-sched_dl-v2-2-cc9399f7aeb1@linutronix.de>
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

Commit 450efca7182a5 ("rcutorture: Disable RT throttling for boost
tests") added the ability to disable RT throttling while rcutorture was
run.

Since v6.12 the DL fair_server takes control of throttling and this
interface no longer serves this purpose. That sysctl control still
exists but serves a different cause.

There is no in-kernel interface to provide this feature, one needs to
echo 0 to each /sys/kernel/debug/sched/fair_server/cpu*/runtime file.

Since sysctl_sched_rt_runtime does not do what it once did, remove it
from rcutorture.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/rcu/rcu.h        |  2 --
 kernel/rcu/rcutorture.c | 35 -----------------------------------
 2 files changed, 37 deletions(-)

diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index d60444bf3a02d..6d1034e49d411 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -69,8 +69,6 @@
 /* A complete grace period count */
 #define RCU_SEQ_GP (RCU_SEQ_STATE_MASK + 1)
=20
-extern int sysctl_sched_rt_runtime;
-
 /*
  * Return the counter portion of a sequence number previously returned
  * by rcu_seq_snap() or rcu_seq_current().
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 93ca7f06371e4..aecc4da7161bb 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1333,39 +1333,6 @@ static unsigned long rcutorture_seq_diff(unsigned lo=
ng new, unsigned long old)
 	return cur_ops->gp_diff(new, old);
 }
=20
-/*
- * RCU torture priority-boost testing.  Runs one real-time thread per
- * CPU for moderate bursts, repeatedly starting grace periods and waiting
- * for them to complete.  If a given grace period takes too long, we assume
- * that priority inversion has occurred.
- */
-
-static int old_rt_runtime =3D -1;
-
-static void rcu_torture_disable_rt_throttle(void)
-{
-	/*
-	 * Disable RT throttling so that rcutorture's boost threads don't get
-	 * throttled. Only possible if rcutorture is built-in otherwise the
-	 * user should manually do this by setting the sched_rt_period_us and
-	 * sched_rt_runtime sysctls.
-	 */
-	if (!IS_BUILTIN(CONFIG_RCU_TORTURE_TEST) || old_rt_runtime !=3D -1)
-		return;
-
-	old_rt_runtime =3D sysctl_sched_rt_runtime;
-	sysctl_sched_rt_runtime =3D -1;
-}
-
-static void rcu_torture_enable_rt_throttle(void)
-{
-	if (!IS_BUILTIN(CONFIG_RCU_TORTURE_TEST) || old_rt_runtime =3D=3D -1)
-		return;
-
-	sysctl_sched_rt_runtime =3D old_rt_runtime;
-	old_rt_runtime =3D -1;
-}
-
 static bool rcu_torture_boost_failed(unsigned long gp_state, unsigned long=
 *start)
 {
 	int cpu;
@@ -3390,7 +3357,6 @@ static int rcutorture_booster_cleanup(unsigned int cp=
u)
 	mutex_lock(&boost_mutex);
 	t =3D boost_tasks[cpu];
 	boost_tasks[cpu] =3D NULL;
-	rcu_torture_enable_rt_throttle();
 	mutex_unlock(&boost_mutex);
=20
 	/* This must be outside of the mutex, otherwise deadlock! */
@@ -3428,7 +3394,6 @@ static int rcutorture_booster_init(unsigned int cpu)
=20
 	/* Don't allow time recalculation while creating a new task. */
 	mutex_lock(&boost_mutex);
-	rcu_torture_disable_rt_throttle();
 	VERBOSE_TOROUT_STRING("Creating rcu_torture_boost task");
 	boost_tasks[cpu] =3D kthread_run_on_cpu(rcu_torture_boost, NULL,
 					      cpu, "rcu_torture_boost_%u");

--=20
2.55.0


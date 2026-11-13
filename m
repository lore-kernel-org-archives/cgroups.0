Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794567037;
	b=0hraPO6yRC1a7WrWnoLiB8Ll+yH+TIdkUMr2Eabplznk7fyA4Efg0svuXUDO9N2rVQpB
	 CHXNQAW/YuORWAP5SWiSwOwuG5Q2SxvOkgajh/jf8fr2ZqGFyXq7LMfrLW0rAlQhR25qB
	 g96vmEQu8pAmdWRfOW2M+cmjYizz5asN4o0kJd9QCySqMp2LJ22SICuQO5HwM8Yoh2UR0
	 ch/BOSSAVZ/tsfMg02aIIQCV84IAmotL0DecnOAKPS/0whw5Oa/ftqp5yBw4q1sYPqcMy
	 dMOHm6vdesmlnVAEo5G7cQeGno1kjjeivYV4s8s42b8MvM5b09WiGts+D+4ThJTl+3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794567037;
	h=DMARC-Filter:From:DKIM-Signature:DKIM-Signature:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=pY0XB2Amvb6YQszTSQKoVgy7OfnT7ScdY0OEf4Q2BEM=;
	b=nw6Z1/c0nlNqIL1S7Q7aJ5PBJGYUQnor/Pkhwhj0HCretcYuID4CnQJlQxK5/JjrKsQT
	 dUHMamWj0quBhbbhsR/fth9ze8HrE+DhLRTD6YCO7hsBoq4aN/lH4S3RC8uLtNY0gDG8D
	 2gXrptiQQzSOfyEwQltdgzo9tP6tDT1txH0rIwJbVLt6SmefN44o8bVXD50Pjt7XP4M5f
	 7PmGD7HzoR49okyqplBvZ9OgWt9PRwM1mps3gh1XSh8GYPhdrXtAMGjfQ+/c3w+x8XYSK
	 E2FYa+YVKnXL3iC/niUGoVNcKqaddqbhC4Co10Mk2/kYFgzt6ZY3A6iPLNne+RlqK6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=cmbolfGH;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=ayEQ6qxP;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48658606A883;
	Fri, 13 Nov 2026 10:50:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48658606A883
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=cmbolfGH;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=ayEQ6qxP
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1794567035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pY0XB2Amvb6YQszTSQKoVgy7OfnT7ScdY0OEf4Q2BEM=;
	b=cmbolfGHurBcnIAEFsAwFf1VTiMy1XiKKTNd0E28WosFFe2+XByY3pdSwLPGsZgc3o4Lt3
	xSHLwpYmEQSjJDPpMtGWWt+8y+HVLo5Ks3sdzYVjXa7EA21HKBezJHYb/ROqMvI3wxoTAf
	PRH81dh+t/zCcjR0rxRAs+XyYcDoNMkHvirScPpfiJ0WfegfXFi/bna9t6MeGiKqSlQDo1
	dXVoQ77KIQYvQf+MN06+6h32a9JjVZhJaoGnXhZbms8QcwrgfjExmXKoB3oJCNMKUDkCKG
	aXPpLw7e8FMre4U+WGD7EQ+A0YQDZfAVUgPutDJuElcrRU5poq5z/dCKTi0vqw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1794567035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pY0XB2Amvb6YQszTSQKoVgy7OfnT7ScdY0OEf4Q2BEM=;
	b=ayEQ6qxPVrffEkyHRPmN4M5rxureGwkMvnzxfVvlWljaQcbLfVScPcg+YLbYG1g7fifJ1t
	N8t92+HiqvqxeoBQ==
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
Subject: [PATCH v3 3/8] rcutorture: Don't try to disable to RT throttling.
Date: Fri, 13 Nov 2026 11:50:24 +0100
Message-ID: <20261113-sched_dl-v3-3-a76ffa1cdeee@linutronix.de>
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


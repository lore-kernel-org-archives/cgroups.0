Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907258;
	b=0ZzUfkkW6uVSdKwXNc+WF0nOTGztnzb4ekDwqqYFgiFl7gbBmaBixb9RgTrDrhTD1ZEw
	 kgngR5JtEqVRI/ZdE4vETC53ZYgCukOQrholxk4pIIPqenBLwJ3Ju9mFLRxSMIGdPW4jV
	 +sTZzZfaQ2Eob4Hdzf3QWR1VpNliWZCFw+TBoJAEiJPbraNnvfiBA6PNi9MCeJNzMs0Wu
	 aXt/PXFH0tLoovbSCLdIqYbutWffDtcftD3jhV6Btl5+jYKLzAK10TzXWQyJMw+EDnC15
	 0NSFi15UD25QQIdxiIvwzgHzHOosG+502kZwIzQVLfazprIdcW6WzIRl10gATuIV09g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907258;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bboQbc/TKIg+1eTyFjEonhrWH4tVzXOKD3NJsctd7Nk=;
	b=DIYsPsFgCBI/Cb5EiLCX8P76j9rmlQCwrFtoEIwt7vFOpMMwDSNbkyW9ZTXwwA5JS278
	 ZG6I8teouAz21Dbv2vqbrx7NOVBKUCS6rR6ghwNWslBp/fJ+s6OVEZCTFKHbvJEDxcfzS
	 tpTFrG3zAj9ucdpkpNdsWOOyAn1i2OYALuJTt7PX97I+Sc2lP3l9ki5mnWbCmryjBagnL
	 SKndL+ZBYbvIwCvjYnTTQ1GlAgjMGTytaK/v5p2/n0dzEAf5eUSoj/tvasjQQ7jML+R5k
	 QDTqNxsoRKB1UBobUXcp1N0RAgePQRzhd8rdCZ64K54n56RoMSxVTZwiFkgvjADKf1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=aW8ClfcM;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCFA606B05C;
	Thu,  5 Nov 2026 19:34:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBCFA606B05C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=aW8ClfcM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793907250;
	bh=bboQbc/TKIg+1eTyFjEonhrWH4tVzXOKD3NJsctd7Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aW8ClfcMLNCO0TlcfguYcjVIZ2TTFYrcCbnbchmuMf+Ag6lQs69lhnrPBELpmYqLA
	 wWtTaItJqyhxaBzFHDYdrSCWV7Bhz6wp3Oa0l+Q4QohmQ57Q1PbMRSrPOw4LOnT/pQ
	 TMSbnR+JL7eujMOuIY1Vkh9p7DeBsNM7w2qkBdbnZI8VAGXHpzFnZntLwOM8770Lpf
	 SIuBfJ92e6P6ckA4Im+wfXrm3QFXtoFC3JpFvn+hQSuMC5Zk+vZq+Nip941Yup05JR
	 YZM+Y2v78ezHyTSVHIGz79r/XC4HVKRRo9WyeNNodWb4BdX3gg5k1tcMUqAZwMhYl3
	 CMq9mt31EzlbA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLCDL1SyrzLJs;
	Thu, 05 Nov 2026 14:34:10 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	luca.abeni@santannapisa.it,
	mathieu.poirier@linaro.org,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	parri.andrea@gmail.com,
	m.szyprowski@samsung.com,
	kayracizmeci@gmail.com,
	weihengqiuu@gmail.com,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH v3 08/24] sched/deadline: Release the bandwidth of a task that leaves the class asleep
Date: Thu,  5 Nov 2026 14:33:43 -0500
Message-Id: <20261105193359.1450487-9-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
References: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A task that leaves SCHED_DEADLINE while it is not queued, asleep or
stopped, keeps its bandwidth in the root domain's total_bw for good:

 - switched_from_dl() hands the release to task_non_contending() for a
   queued task alone;
 - for one that is not queued, it takes the bandwidth off the
   runqueue's running_bw and this_bw, and nothing takes it off
   total_bw;
 - the inactive timer is the one other path that does, and it is not
   armed: the task never ran as SCHED_DEADLINE, or the timer fired
   while it still was, taking running_bw alone.

Repeated, it fills total_bw up to the admission cap, after which
sched_setattr(SCHED_DEADLINE) and the offlining of a CPU fail with
EBUSY.

Release it in switched_from_dl() where the task is not queued and no
inactive timer is pending, for a task with parameters of its own, not
special: a task deboosted from priority inheritance with no parameters
of its own, and a special one (SCHED_FLAG_SUGOV), have no bandwidth in
total_bw. Then clear its bandwidth, once sub_rq_bw(), which reads it, is
done: every path that would release it again takes a dl_bw of 0. Kept,
it would make the task one with bandwidth to task_contending() and
task_non_contending() once priority inheritance boosts it into the
class, and a deboost while it sleeps would release it a second time. So
would the inactive timer's handler when it runs late, dl_non_contending
cleared under it by migrate_task_rq_dl(): it finds the task out of the
class. A test of hrtimer_active() would not tell that handler apart: it
stays true after the handler returns, until the hrtimer code clears its
running state, and the bandwidth of a task switched out meanwhile would
never be released.

With the bandwidth goes the state of the period the task was in, as
where inactive_task_timer() resets it: its 0-lag time is past, a return
to the class starts a period anew, and a throttle left behind would hold
a returning task until the old timer fires. The parameters themselves,
dl_runtime, dl_deadline and dl_period, stay, because the task may still
be the donor of a priority inheritance boost: rt_mutex_adjust_pi() walks
the chain and deboosts the owner after the runqueue lock of the policy
change is dropped, and until it does, a replenishment of that owner,
which update_curr_dl_se() does at once for a boosted entity, would run
replenish_dl_entity() on a donor whose dl_runtime and dl_period are 0.
It would warn and then never leave

	while (dl_se->runtime <= 0) {
		dl_se->deadline += pi_of(dl_se)->dl_period;
		dl_se->runtime += pi_of(dl_se)->dl_runtime;
	}

with the runqueue lock held and interrupts off. __setparam_dl() sets
the parameters anew if the task comes back, and the inactive timer of a
boost into the class resets them if it does not.

The leak was reported by Tejun Heo, and first fixed by Juri Lelli's
"sched/deadline: Fix total_bw leak when switching away from
SCHED_DEADLINE while !queued", since dropped from tip, which released
for every task on this path and kept the bandwidth: the double release
of a boosted task is the pi_former_owner_asleep case of the
deadline_bw_test selftest added later in this series, in a one-CPU
partition with room, the waiter of its second round refused as a
deadline task, total_bw having wrapped.

The donor window was found by the Sashiko AI review of the first
posting of this series, and shown with a kernel carrying mdelay(20)
before rt_mutex_adjust_pi() to widen it: a deadline task blocks on a
PTHREAD_PRIO_INHERIT mutex with its runtime unspent, and is switched to
SCHED_OTHER while the owner it boosts spins. Clearing the parameters
there, that kernel warns in replenish_dl_entity() and stops, on round 4
and round 3 of two 8-CPU VMs; keeping them, both go through their eight
rounds.

Link: https://lore.kernel.org/all/20261103-b4-sched-dl-bw-fixes-v1-2-dd761fe005b4@redhat.com/
Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
Reported-by: Tejun Heo <tj@kernel.org>
Closes: https://lore.kernel.org/all/2b5fb3f22bca6aa383be8f4781923392@kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 86 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 73 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 088e84fb9b10..867111a0822e 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -350,6 +350,7 @@ static void dl_change_utilization(struct task_struct *p, u64 new_bw)
 	dl_rq_change_utilization(task_rq(p), &p->dl, new_bw);
 }
 
+static void __dl_clear_state(struct sched_dl_entity *dl_se);
 static void __dl_clear_params(struct sched_dl_entity *dl_se);
 
 /*
@@ -3550,15 +3551,62 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 	dec_dl_tasks_cs(p);
 
 	if (!task_on_rq_queued(p)) {
-		/*
-		 * Inactive timer is armed. However, p is leaving DEADLINE and
-		 * might migrate away from this rq while continuing to run on
-		 * some other class. We need to remove its contribution from
-		 * this rq running_bw now, or sub_rq_bw (below) will complain.
-		 */
-		if (p->dl.dl_non_contending)
+		bool released = false;
+
+		if (p->dl.dl_non_contending) {
+			/*
+			 * Inactive timer is armed. However, p is leaving
+			 * DEADLINE and might migrate away from this rq while
+			 * continuing to run on some other class. We need to
+			 * remove its contribution from this rq running_bw now,
+			 * or sub_rq_bw (below) will complain.
+			 *
+			 * inactive_task_timer() will find !dl_task(p) and
+			 * release total_bw via __dl_sub().
+			 */
 			sub_running_bw(&p->dl, &rq->dl);
+		} else if (p->dl.dl_runtime && !dl_entity_is_special(&p->dl)) {
+			/*
+			 * No pending inactive timer: the task never ran as
+			 * DEADLINE or the timer already fired while still
+			 * DEADLINE (only dropping running_bw at that time).
+			 * Nobody else will release total_bw, do it now.
+			 *
+			 * Not for a task without parameters of its own, one
+			 * deboosted from priority inheritance, nor for a
+			 * special one: neither has bandwidth in total_bw.
+			 */
+			struct dl_bw *dl_b = dl_bw_of(task_cpu(p));
+
+			raw_spin_lock(&dl_b->lock);
+			__dl_sub(dl_b, p->dl.dl_bw, dl_bw_cpus(task_cpu(p)));
+			raw_spin_unlock(&dl_b->lock);
+			released = true;
+		}
 		sub_rq_bw(&p->dl, &rq->dl);
+		/*
+		 * Released: its 0-lag time is past, and the state of the
+		 * period it was in goes with the bandwidth, as where
+		 * inactive_task_timer() resets it. Its bandwidth is no one's
+		 * to release again, and a dl_bw of 0 is what every path that
+		 * would takes. Kept, it would make the task one with
+		 * bandwidth to task_contending() and task_non_contending()
+		 * once priority inheritance boosts it, and a deboost while
+		 * it sleeps would release it a second time. So would the
+		 * inactive timer's handler when it runs late,
+		 * dl_non_contending cleared under it by
+		 * migrate_task_rq_dl(): it finds !dl_task(p).
+		 *
+		 * The parameters themselves stay, where
+		 * inactive_task_timer() resets them with the bandwidth: the
+		 * task may still be the donor of a priority inheritance
+		 * boost until rt_mutex_adjust_pi() walks the chain, outside
+		 * this runqueue lock, and replenish_dl_entity() of the
+		 * boosted owner would never leave its loop over a dl_period
+		 * and a dl_runtime of 0.
+		 */
+		if (released)
+			__dl_clear_state(&p->dl);
 	}
 
 	/*
@@ -3960,22 +4008,34 @@ bool __checkparam_dl(const struct sched_attr *attr)
 /*
  * This function clears the sched_dl_entity static params.
  */
-static void __dl_clear_params(struct sched_dl_entity *dl_se)
+/*
+ * The bandwidth of @dl_se and the state of the period it is in: what a
+ * task that left the class past its 0-lag time has no use for. The
+ * parameters stay, where a boosted owner may still read them.
+ */
+static void __dl_clear_state(struct sched_dl_entity *dl_se)
 {
-	dl_se->dl_runtime		= 0;
-	dl_se->dl_deadline		= 0;
-	dl_se->dl_period		= 0;
 	dl_se->flags			= 0;
 	dl_se->dl_bw			= 0;
-	dl_se->dl_density		= 0;
 
 	dl_se->deadline			= 0;
 	dl_se->runtime			= 0;
 
 	dl_se->dl_throttled		= 0;
 	dl_se->dl_yielded		= 0;
-	dl_se->dl_non_contending	= 0;
 	dl_se->dl_overrun		= 0;
+}
+
+static void __dl_clear_params(struct sched_dl_entity *dl_se)
+{
+	__dl_clear_state(dl_se);
+
+	dl_se->dl_runtime		= 0;
+	dl_se->dl_deadline		= 0;
+	dl_se->dl_period		= 0;
+	dl_se->dl_density		= 0;
+
+	dl_se->dl_non_contending	= 0;
 	dl_se->dl_server		= 0;
 	dl_se->dl_defer			= 0;
 	dl_se->dl_defer_running		= 0;
-- 
2.47.3


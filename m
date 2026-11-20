Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795181615;
	b=zZRhCqPtwmcb0EsuA/7YPqkDmgcQ7ani2pJd2SRaSaPpDqlSRUQRBHG5vwlyjLNMJvAm
	 tGMA8PzLx33H2Z0p44STt3W6a0SnjblA9CMtbb05+6siSJJdby42vT4KFW3J7cGNaG8EP
	 DQ0UAJO6a5HeCj5wZXA7D8KNtT2Eh/YUnBG1mJkwxjJF5uAxcpvMWx3D3P75ST1rSkROA
	 gacdu0hnn8iqErOE3HEXnFV1nNh2wM+a5ZwMD9ZAgURv4tyZQmrzPMvfV6bz/u2GtohiB
	 OorAVmggy1Q6lERNDFdJN5+Md56Vsl+aKIhxFmanEFm0Uo/DecOLUd8Zw6d8sPg04qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795181615;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ItqwSvSZ8iuWNx4RiptPGqq6vki5TsQPNC9NH0gHMis=;
	b=jQZqlEpS2/GjOxW1nRxUu31OMpt4ZE6NbPiGG8aa7Bq8SMOQKaehxkmpftm8IpwK00Qh
	 feLu2QZ1qs85ybfSALDFu3lWUMxGZkuYCQOl1BFpz2XzLzlkxi5/naGtCGO5l8RDAAv6T
	 oCkGAUJCba7WoAub8nD+2hfT1+taMU+SFgJipFvqksnTkvhksZbcQF4vn6H+FZa05nlTK
	 yzZ7u45tz66+9mi1x6YVaEJpfiUjFj5+m+bNOh9UtG7AAtBuGswMNrP6tMqbneOawC58U
	 mD+mfNMlCII7w1otGf8e2gx5X/+YEu/9pheneKAAMZZOzgfEXqiJduMhypplTW/RgbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=kBxvEKJB;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BF7606A326;
	Fri, 20 Nov 2026 13:33:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90BF7606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=kBxvEKJB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795181613;
	bh=ItqwSvSZ8iuWNx4RiptPGqq6vki5TsQPNC9NH0gHMis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBxvEKJBd215Yne/GG+BDazUWoNvyOJTQRRzE6NXw/fbnGTVMJczxeKSTyxT5q6ZG
	 yhuGEDQQ1Vjn3E/oJeHTx0lNHDXJ5Az8KZSu9kx1oLSPRIYDFzQfzSv1meA5A51DyD
	 8Nb/GjOEgejSvi0vQwAWcmAX7A76WVrS5nAAAwhF//a7MFzGPjZRktenUs96IrVJaz
	 PAo4jZj++l0YD0B+Pe1G7+62UJrSiH4fRAMV8hoBjtANuPWDxUJNlN97y2rtrU4eus
	 Y7a3SVAd0H/1jTucMFHlV/GydB24yBN5w6rPncTd7wEFXBAHS1opSWLou1fQJgC+8u
	 38t/xQ7y1cinA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWGWK37H0zV0D;
	Fri, 20 Nov 2026 08:33:33 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	tglx@kernel.org,
	will@kernel.org,
	boqun@kernel.org,
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
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH v5.1 10/17] sched/deadline: Fix an overflow of the 0-lag time with long periods
Date: Fri, 20 Nov 2026 08:33:32 -0500
Message-Id: <d975f317a4f9f79d2300b68ad76664755459ba36.1795181168.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <awBEww33F6yn0MBO@jlelli-thinkpadt14gen4.remote.csb>
References: <cover.1795115075.git.mathieu.desnoyers@efficios.com> <2be3813af9e997f5f7d9d3161d0b65b8d4ab917c.1795115075.git.mathieu.desnoyers@efficios.com> <awBEww33F6yn0MBO@jlelli-thinkpadt14gen4.remote.csb>
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

When a deadline task blocks, task_non_contending() computes its 0-lag
time:

  zerolag_time = deadline - runtime * dl_period / dl_runtime

A task that ran at its reserved bandwidth would use up its runtime left
at that time. Until then, the task still counts in running_bw. A task
that leaves SCHED_DEADLINE also keeps its bandwidth in total_bw until
then. This comes from commit 209a0cbda7a0 ("sched/deadline: Improve the
tracking of active utilization"), which adds the inactive timer of the
GRUB algorithm.

The product runtime * dl_period is computed on 64 bits, then divided as
an s64 by div64_long(). With a period of 4s, it passes S64_MAX once the
runtime left is above 2.3s. The default limit on the period is about
4.2s, so no sysctl change is needed. The quotient is then negative, and
the 0-lag time lands after the deadline.

On 32-bit, div64_long() also truncates dl_runtime to an s32. A
dl_runtime above about 2.1s then gives a wrong 0-lag time too. If root
raises the period limit, a dl_runtime that is a multiple of 2^32 ns
would divide by zero. This was found by reading.

The bandwidth is then released seconds late. Until then, the root domain
refuses deadline tasks that would fit. In an x86-64 guest, a task took a
reservation of 3.1s every 4s, then went back to SCHED_OTHER at once.
Another task asking for the same reservation got EBUSY for 5.95s.

Fix this by multiplying on 128 bits with mul_u64_u64_div_u64(). Its
operands are unsigned. So take the magnitude of the runtime, which is
negative after an overrun, and add or subtract the result. With the fix,
the second task got its reservation at once.

The quotient must still fit in 64 bits. On x86-64, mul_u64_u64_div_u64()
traps with a divide error otherwise. After a change of parameters, the
runtime and the deadline stay those of the old parameters until the
next period. The 0-lag time uses the new dl_runtime and dl_period. So
the runtime left can be far above dl_runtime. For example, root can
raise the period limit and give a task 150s every 300s. The task can
then shrink its runtime to 1024ns. Before the division, compare the
runtime left with the runtime that the parameters give until the
deadline. If it is larger, the 0-lag time has passed, and the bandwidth
is released at once. Otherwise, the quotient is at most the time to the
deadline.

The new helper dl_time_to_zerolag() computes the 0-lag time, with one
return per case.

A negative runtime is an overrun. It lasts at most about a tick, unless
the CPU stalls. A vCPU preempted on the host can stall for seconds. Say
root raised the period limit to about an hour, and the task has a
dl_runtime of 1024ns. A stall of a few seconds then pushes the quotient
past S64_MAX. The 0-lag time would be centuries away. Release the
bandwidth at once in that case. This was found by reading.

The params_switched_asleep and params_shrunk_long_period cases of
deadline_bw_test, added later in this series, test the check of the
runtime left. No case tests the overrun, which needs a stall.

Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
---
This updates patch 10 of v5 alone, as Juri suggested. Patches 11 to 17
of v5 apply on top of it unchanged.

Changes since v5:
- Move the 0-lag computation into the helper dl_time_to_zerolag() that
  Juri wrote, with one return per case. Fix a comma in its comment.
- Add Juri's Reviewed-by.

 kernel/sched/deadline.c | 80 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 71 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index d6d2657dcddd..a122b6ce1271 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -352,6 +352,76 @@ static void dl_change_utilization(struct task_struct *p, u64 new_bw)
 
 static void __dl_clear_params(struct sched_dl_entity *dl_se);
 
+/*
+ * Return the time from now to the 0-lag time of @dl_se, or a negative
+ * value if the 0-lag time has passed.
+ *
+ * The 0-lag time is when a task running at its reserved bandwidth would
+ * use up the runtime it has left:
+ *
+ *   0-lag = deadline - runtime * dl_period / dl_runtime
+ *
+ * Example: 30ms every 100ms, blocking 10ms into its period with 20ms
+ * left. 0-lag = 100 - 20 * 100 / 30 = 33ms. From there to the deadline,
+ * 30% of the CPU is exactly the 20ms left.
+ *
+ * The product can overflow 64 bits, so mul_u64_u64_div_u64() multiplies
+ * on 128 bits. Its quotient must still fit: on x86-64 it traps
+ * otherwise. Usually |runtime| <= dl_runtime and the quotient is at most
+ * dl_period.
+ *
+ * Each check compares against the bound scaled by dl_runtime / dl_period.
+ * That quotient cannot overflow, as dl_runtime <= dl_period.
+ */
+static s64 dl_time_to_zerolag(struct sched_dl_entity *dl_se, struct rq *rq)
+{
+	/* Time to the deadline. Negative if the deadline has passed. */
+	s64 left = dl_se->deadline - rq_clock(rq);
+
+	if (dl_se->runtime < 0) {
+		/*
+		 * Overrun: the 0-lag time is after the deadline, by the time
+		 * needed to pay the overrun back at the reserved bandwidth.
+		 */
+		u64 overrun = -dl_se->runtime;
+		u64 room = S64_MAX - max(left, 0LL);
+
+		/*
+		 * overrun * dl_period / dl_runtime > room: the result would
+		 * overflow s64. The 0-lag time is centuries away, for a
+		 * negligible bandwidth. Release it now.
+		 */
+		if (overrun > mul_u64_u64_div_u64(room, dl_se->dl_runtime,
+						  dl_se->dl_period)) {
+			return -1;
+		}
+
+		return left + mul_u64_u64_div_u64(overrun, dl_se->dl_period,
+						  dl_se->dl_runtime);
+	}
+
+	/*
+	 * Runtime left: the 0-lag time is before the deadline. It has
+	 * passed if the deadline has.
+	 */
+	if (left < 0)
+		return -1;
+
+	/*
+	 * runtime * dl_period / dl_runtime > left: the 0-lag time has
+	 * passed. The runtime left is more than the bandwidth gives until
+	 * the deadline, as a wakeup would find with dl_entity_overflow().
+	 */
+	if (dl_se->runtime > mul_u64_u64_div_u64(left, dl_se->dl_runtime,
+						 dl_se->dl_period)) {
+		return -1;
+	}
+
+	/* The quotient is at most @left here. */
+	return left - mul_u64_u64_div_u64(dl_se->runtime, dl_se->dl_period,
+					  dl_se->dl_runtime);
+}
+
 /*
  * The utilization of a task cannot be immediately removed from
  * the rq active utilization (running_bw) when the task blocks.
@@ -425,15 +495,7 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 
 	WARN_ON(dl_se->dl_non_contending);
 
-	zerolag_time = dl_se->deadline -
-		 div64_long((dl_se->runtime * dl_se->dl_period),
-			dl_se->dl_runtime);
-
-	/*
-	 * Using relative times instead of the absolute "0-lag time"
-	 * allows to simplify the code
-	 */
-	zerolag_time -= rq_clock(rq);
+	zerolag_time = dl_time_to_zerolag(dl_se, rq);
 
 	/*
 	 * If the "0-lag time" already passed, decrease the active

base-commit: ec6f6731538e0d45872eb279fdeb477bed152d6f
prerequisite-patch-id: 5e2478ffdfb7583751bf44bdf87fb930bc23551b
prerequisite-patch-id: d5e5ef986ff2d9bc39a87b56e96a2acbd3158687
prerequisite-patch-id: 99e47f80396008ee2b2576157d37842481ce52d2
prerequisite-patch-id: a10824f98c11a4c902dad55cab3ec03b3dbe2c8a
prerequisite-patch-id: 8959e5a408641b4fa81bc79737cd17d5f1b03389
prerequisite-patch-id: 16acf1d18f01d20310d6db767dfbec2f072e0372
prerequisite-patch-id: e1946bb015a7b14ed4e2cd0421e5e30b0c7afdda
prerequisite-patch-id: 4daf48a89779fbd8c8bc5fc1d7a7d6df9bca2d9d
prerequisite-patch-id: f8b34127a06e7503c069fb08e275574569aa1663
-- 
2.47.3


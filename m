From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC 1/3] sched/fair: call __refill_cfs_bandwidth_runtime
 only for finite quota
Date: Mon, 16 May 2016 12:36:26 +0300
Message-ID: <146339138652.25295.12568582885578664992.stgit@buzz>
References: <146339085068.25295.7687045977863852568.stgit@buzz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
	t=1463391390; bh=9Haz0oOig468RBqXJDzKGw7BpNlxWTITTqgayPKHWJQ=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding;
	b=UI1dbpyAqs1HSs4CI59S5y2DU8WA9LqqR/Xm0QBYMFQHRGccPcBZ/ndFOIZNuipLd
	 k4fx/GxNlVtEa04F5RMnPzvy0vZ20rpuFUJd5XC9IUMM7bXkXL0Ur2NUOWr0oHJGp0
	 Qo1Peohqbzyu/O+8uZDSB3CdaaWVzPByl6kRPXmY=
In-Reply-To: <146339085068.25295.7687045977863852568.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, containers@lists.linux-foundation.org

Both call sites (tg_set_cfs_bandwidth and do_sched_cfs_period_timer)
already have checks for infinite quota.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 kernel/sched/core.c |    5 +++--
 kernel/sched/fair.c |    6 +-----
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d1f7149f8704..355698188ea9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8196,10 +8196,11 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 	cfs_b->period = ns_to_ktime(period);
 	cfs_b->quota = quota;
 
-	__refill_cfs_bandwidth_runtime(cfs_b);
 	/* restart the period timer (if active) to handle new period expiry */
-	if (runtime_enabled)
+	if (runtime_enabled) {
+		__refill_cfs_bandwidth_runtime(cfs_b);
 		start_cfs_bandwidth(cfs_b);
+	}
 	raw_spin_unlock_irq(&cfs_b->lock);
 
 	for_each_online_cpu(i) {
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e7dd0ec169be..d26b631a9a1d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3559,12 +3559,8 @@ static inline u64 sched_cfs_bandwidth_slice(void)
  */
 void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
 {
-	u64 now;
+	u64 now = sched_clock_cpu(smp_processor_id());
 
-	if (cfs_b->quota == RUNTIME_INF)
-		return;
-
-	now = sched_clock_cpu(smp_processor_id());
 	cfs_b->runtime = cfs_b->quota;
 	cfs_b->runtime_expires = now + ktime_to_ns(cfs_b->period);
 }


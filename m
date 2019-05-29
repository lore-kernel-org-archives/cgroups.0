From: bsegall@google.com
Subject: Re: [PATCH v3 1/1] sched/fair: Fix low cpu usage with high throttling by removing expiration of cpu-local slices
Date: Wed, 29 May 2019 12:50:22 -0700
Message-ID: <xm26blzlyr9d.fsf@bsegall-linux.svl.corp.google.com>
References: <1558121424-2914-1-git-send-email-chiluk+linux@indeed.com>
        <1559156926-31336-1-git-send-email-chiluk+linux@indeed.com>
        <1559156926-31336-2-git-send-email-chiluk+linux@indeed.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=z596bta4rnvntAQDgf+fFcauM3ob59dKjWY1OdsYMKo=;
        b=pE1DG7jxvSSAUIngdKKy8SGdjXwNZF0gKUEfIO7uIOz19XZQLPVNGTFcfJvyXyO3W9
         FQwJJn15+yK86NLne5wN9s8kpifZsp+U7+HedfghIBYeUQBULzTgSZqoucRCcEvJr8sC
         RYF07nkoPv0kjyLAW8qfe3qOWb1gCyKuTytRud3LD2WRPBzI+yw5iH4ELti4VEqkfqt7
         9zclBKHZtmYjOsWw0NB0DSHFDCOaetAq68wYIlk36kwfooWpH6SbbQYPdxOW2Mo06ugy
         t2KLfNWlEZid2pIRCCKt53pYGHq++hzN4JwX+kbVcDpMc0o0LKhxXZTV5V7JQefcSiNs
         RoaQ==
In-Reply-To: <1559156926-31336-2-git-send-email-chiluk+linux@indeed.com> (Dave
        Chiluk's message of "Wed, 29 May 2019 14:08:46 -0500")
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chiluk <chiluk+linux@indeed.com>
Cc: Phil Auld <pauld@redhat.com>, Peter Oskolkov <posk@posk.io>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Brendan Gregg <bgregg@netflix.com>, Kyle Anderson <kwa@yelp.com>, Gabriel Munos <gmunoz@netflix.com>, John Hammond <jhammond@indeed.com>, Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org

Dave Chiluk <chiluk+linux@indeed.com> writes:

> It has been observed, that highly-threaded, non-cpu-bound applications
> running under cpu.cfs_quota_us constraints can hit a high percentage of
> periods throttled while simultaneously not consuming the allocated
> amount of quota.  This use case is typical of user-interactive non-cpu
> bound applications, such as those running in kubernetes or mesos when
> run on multiple cpu cores.
>
> This has been root caused to threads being allocated per cpu bandwidth
> slices, and then not fully using that slice within the period. At which
> point the slice and quota expires.  This expiration of unused slice
> results in applications not being able to utilize the quota for which
> they are allocated.
>

So most of the bandwidth is supposed to be returned, leaving only 1ms.
I'm setting up to try your test now, but there was a bug with the
unthrottle part of this where it could be continuously pushed into the
future. You might try this patch instead, possibly along with lowering
min_cfs_rq_runtime (currently not runtime tunable) if you see that cost
more than the cost of extra locking to acquire runtime.





From: Ben Segall <bsegall@google.com>
Date: Tue, 28 May 2019 12:30:25 -0700
Subject: [PATCH] sched/fair: don't push cfs_bandwith slack timers forward

When a cfs_rq sleeps and returns its quota, we delay for 5ms before waking any
throttled cfs_rqs to coalesce with other cfs_rqs going to sleep, as this has has
to be done outside of the rq lock we hold. The current code waits for 5ms
without any sleeps, instead of waiting for 5ms from the first sleep, which can
delay the unthrottle more than we want. Switch this around.

Change-Id: Ife536bb54af633863de486ba6ec0d20e55ada8c9
Signed-off-by: Ben Segall <bsegall@google.com>
---
 kernel/sched/fair.c  | 7 +++++++
 kernel/sched/sched.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8213ff6e365d..2ead252cfa32 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4729,6 +4729,11 @@ static void start_cfs_slack_bandwidth(struct cfs_bandwidth *cfs_b)
 	if (runtime_refresh_within(cfs_b, min_left))
 		return;
 
+	/* don't push forwards an existing deferred unthrottle */
+	if (cfs_b->slack_started)
+		return;
+	cfs_b->slack_started = true;
+
 	hrtimer_start(&cfs_b->slack_timer,
 			ns_to_ktime(cfs_bandwidth_slack_period),
 			HRTIMER_MODE_REL);
@@ -4782,6 +4787,7 @@ static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b)
 
 	/* confirm we're still not at a refresh boundary */
 	raw_spin_lock_irqsave(&cfs_b->lock, flags);
+	cfs_b->slack_started = false;
 	if (cfs_b->distribute_running) {
 		raw_spin_unlock_irqrestore(&cfs_b->lock, flags);
 		return;
@@ -4920,6 +4926,7 @@ void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 	hrtimer_init(&cfs_b->slack_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	cfs_b->slack_timer.function = sched_cfs_slack_timer;
 	cfs_b->distribute_running = 0;
+	cfs_b->slack_started = false;
 }
 
 static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index efa686eeff26..60219acda94b 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -356,6 +356,7 @@ struct cfs_bandwidth {
 	u64			throttled_time;
 
 	bool                    distribute_running;
+	bool                    slack_started;
 #endif
 };
 
-- 
2.22.0.rc1.257.g3120a18244-goog


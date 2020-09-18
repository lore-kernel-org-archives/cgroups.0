From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 5/5] iocost: add iocg_forgive_debt tracepoint
Date: Thu, 17 Sep 2020 20:44:56 -0400
Message-ID: <20200918004456.593983-6-tj@kernel.org>
References: <20200918004456.593983-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mKtA7cFsHNh8hYHY7vxbi2vKeig9nNldo1RjIq6TDkU=;
        b=qEUz8l3TjyhsGosmXReNkCXnNOUMnbuhorgcWpRVoMfslfF8hO0Z5BXLsGJ1eOA/YQ
         B/FJJyDVE+YoC/n5s19IhlY5KOzaDWsulPXgRRPl7m/2HV8UYEPh+Y7deLQjqLMoogD5
         q/I2xRsP1X1d9aMY0QgP2C+Eohq109DY5E4dtT6MZWUc5vLE8gF0gOB8xokWY68MiENL
         OOTeZVRCNo4yFZ9ZZ6jSDJGKf73eKQpEV8U+D6gLO532hS38I1AwwrnGxI6LK75Lei+F
         SFYqsZ1NDgmJtBFZbeMnCGOKsef3Pc4dcwqjay5YgwrIERh9W80ioJxhA7i4yoyUAClm
         WeTw==
In-Reply-To: <20200918004456.593983-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-iocost.c            | 12 ++++++++++
 include/trace/events/iocost.h | 41 +++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 9b1f94499432..328ae805e85f 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2046,12 +2046,24 @@ static void ioc_forgive_debts(struct ioc *ioc, u64 usage_us_sum, int nr_debtors,
 	ioc->dfgv_period_rem = do_div(nr_cycles, DFGV_PERIOD);
 
 	list_for_each_entry(iocg, &ioc->active_iocgs, active_list) {
+		u64 __maybe_unused old_debt, __maybe_unused old_delay;
+
 		if (!iocg->abs_vdebt)
 			continue;
+
 		spin_lock(&iocg->waitq.lock);
+
+		old_debt = iocg->abs_vdebt;
+		old_delay = iocg->delay;
+
 		iocg->abs_vdebt >>= nr_cycles;
 		iocg->delay = 0; /* kick_waitq will recalc */
 		iocg_kick_waitq(iocg, true, now);
+
+		TRACE_IOCG_PATH(iocg_forgive_debt, iocg, now, usage_pct,
+				old_debt, iocg->abs_vdebt,
+				old_delay, iocg->delay);
+
 		spin_unlock(&iocg->waitq.lock);
 	}
 }
diff --git a/include/trace/events/iocost.h b/include/trace/events/iocost.h
index b350860d2e71..0b6869980ba2 100644
--- a/include/trace/events/iocost.h
+++ b/include/trace/events/iocost.h
@@ -164,6 +164,47 @@ TRACE_EVENT(iocost_ioc_vrate_adj,
 	)
 );
 
+TRACE_EVENT(iocost_iocg_forgive_debt,
+
+	TP_PROTO(struct ioc_gq *iocg, const char *path, struct ioc_now *now,
+		u32 usage_pct, u64 old_debt, u64 new_debt,
+		u64 old_delay, u64 new_delay),
+
+	TP_ARGS(iocg, path, now, usage_pct,
+		old_debt, new_debt, old_delay, new_delay),
+
+	TP_STRUCT__entry (
+		__string(devname, ioc_name(iocg->ioc))
+		__string(cgroup, path)
+		__field(u64, now)
+		__field(u64, vnow)
+		__field(u32, usage_pct)
+		__field(u64, old_debt)
+		__field(u64, new_debt)
+		__field(u64, old_delay)
+		__field(u64, new_delay)
+	),
+
+	TP_fast_assign(
+		__assign_str(devname, ioc_name(iocg->ioc));
+		__assign_str(cgroup, path);
+		__entry->now = now->now;
+		__entry->vnow = now->vnow;
+		__entry->usage_pct = usage_pct;
+		__entry->old_debt = old_debt;
+		__entry->new_debt = new_debt;
+		__entry->old_delay = old_delay;
+		__entry->new_delay = new_delay;
+	),
+
+	TP_printk("[%s:%s] now=%llu:%llu usage=%u debt=%llu->%llu delay=%llu->%llu",
+		__get_str(devname), __get_str(cgroup),
+		__entry->now, __entry->vnow, __entry->usage_pct,
+		__entry->old_debt, __entry->new_debt,
+		__entry->old_delay, __entry->new_delay
+	)
+);
+
 #endif /* _TRACE_BLK_IOCOST_H */
 
 /* This part must be outside protection */
-- 
2.26.2


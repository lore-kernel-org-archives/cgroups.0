From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Tue, 31 May 2022 14:18:21 -0400
Message-ID: <20220531181821.187834-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654021115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=hCTUSkWIIHgNixKuY/6iwCz6DbkjCFmwTBRc2bIkHG8=;
        b=egSCP6eDOmNhwU7e5Kxy+kQo+p/9TxlMnWDfcHMbyMD0PK0Zq+OGK5tYtTcwuJJP/08AJW
        RaZNLvW1kf3kK4ZRXxJs6FqG8dqMnKJotIzcCgmPNoEBjskVVplohIOSkLm8gTQOlMMwTw
        6TVVro9x6uojzRRW2xUQJBmKkwLhv8w=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

For a system with many CPUs and block devices, the time to do
blkcg_rstat_flush() from cgroup_rstat_flush() can be rather long. It
can be especially problematic as interrupt is disabled during the flush.
It was reported that it might take seconds in some extreme cases leading
to hard lockup messages.

As it is likely that not all the percpu blkg_iostat_set's has been
updated since the last flush, those stale blkg_iostat_set's don't need
to be flushed in this case. This patch optimizes blkcg_rstat_flush()
by checking the current sequence number against the one recorded since
the last flush and skip the blkg_iostat_set if the sequence number
hasn't changed. There is a slight chance that it may miss an update
that is being done in parallel, the new update will just have to wait
until the next flush.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/blk-cgroup.c | 18 +++++++++++++++---
 block/blk-cgroup.h |  1 +
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 40161a3f68d0..79b89af61ef2 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -864,11 +864,23 @@ static void blkcg_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 		unsigned long flags;
 		unsigned int seq;
 
+		seq = u64_stats_fetch_begin(&bisc->sync);
+		/*
+		 * If the sequence number hasn't been updated since the last
+		 * flush, we can skip this blkg_iostat_set though we may miss
+		 * an update that is happening in parallel.
+		 */
+		if (seq == bisc->last_seq)
+			continue;
+
 		/* fetch the current per-cpu values */
-		do {
-			seq = u64_stats_fetch_begin(&bisc->sync);
+		while (true) {
+			bisc->last_seq = seq;
 			blkg_iostat_set(&cur, &bisc->cur);
-		} while (u64_stats_fetch_retry(&bisc->sync, seq));
+			if (!u64_stats_fetch_retry(&bisc->sync, seq))
+				break;
+			seq = u64_stats_fetch_begin(&bisc->sync);
+		}
 
 		/* propagate percpu delta to global */
 		flags = u64_stats_update_begin_irqsave(&blkg->iostat.sync);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index d4de0a35e066..22b4ea139b93 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -45,6 +45,7 @@ struct blkg_iostat_set {
 	struct u64_stats_sync		sync;
 	struct blkg_iostat		cur;
 	struct blkg_iostat		last;
+	unsigned int			last_seq;
 };
 
 /* association between a blk cgroup and a request queue */
-- 
2.31.1


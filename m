From: Waiman Long <longman@redhat.com>
Subject: [PATCH-block 2/3] blk-cgroup: Don't flush a blkg if destroyed
Date: Thu,  8 Dec 2022 17:01:40 -0500
Message-ID: <20221208220141.2625775-3-longman@redhat.com>
References: <20221208220141.2625775-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s3VQJPU/3HC+t8N1wzyewiUON5nIdBJkilNRlkYPV+o=;
        b=C46WpCFE2tlO/WF/+cF40ha66UDto72z7/HTjk+EPgMybEZfyNNHi49NJVsreYE3uHtYux
        xT1yAB0lWotXbYmCy9B4cWAzawXWRJfcA3Y6DhQY7k7in+INB/P52Sv57sCEqJyKCjISty
        NP7dz0JJb9oSvyCeKnX/gTuDSAPjNn8=
In-Reply-To: <20221208220141.2625775-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Waiman Long <longman@redhat.com>

Before commit 3b8cc6298724 ("blk-cgroup: Optimize blkcg_rstat_flush()"),
blkg's stats is only flushed if they are online. In addition, the
stat flushing of blkgs in blkcg_rstat_flush() includes propagating
the rstat data to its parent. However, if a blkg has been destroyed
(offline), the validity of its parent may be questionable. For safety,
revert back to the old behavior by ignoring offline blkg's.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 block/blk-cgroup.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 21cc88349f21..c466aef0d467 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -885,6 +885,12 @@ static void blkcg_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 
 		WRITE_ONCE(bisc->lqueued, false);
 
+		/* Don't flush its stats if blkg is offline */
+		if (unlikely(!blkg->online)) {
+			percpu_ref_put(&blkg->refcnt);
+			continue;
+		}
+
 		/* fetch the current per-cpu values */
 		do {
 			seq = u64_stats_fetch_begin(&bisc->sync);
-- 
2.31.1


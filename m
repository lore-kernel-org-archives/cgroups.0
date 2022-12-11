From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH-block v2 2/3] blk-cgroup: Don't flush a blkg if destroyed
Date: Sun, 11 Dec 2022 17:20:57 -0500
Message-ID: <20221211222058.2946830-3-longman@redhat.com>
References: <20221211222058.2946830-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670797272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s3VQJPU/3HC+t8N1wzyewiUON5nIdBJkilNRlkYPV+o=;
        b=EWGelmnvbiGtbREhtarYYeSCyiuZRiZ7xkJjsvn6DXJ65g4XBWa1pg/eJIM9b786jcopP1
        LwnSiAVdyP3JCVJ7aYu5eVWy/xL95sF2Q0T5QVZrCLrRxvxEfPF4e0xWEF539yrowjY1n+
        khoZiPEkvewKXEcHIgkUCj63txZaxnk=
In-Reply-To: <20221211222058.2946830-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, "Dennis Zhou (Facebook)" <dennisszhou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Before commit 3b8cc6298724 ("blk-cgroup: Optimize blkcg_rstat_flush()"),
blkg's stats is only flushed if they are online. In addition, the
stat flushing of blkgs in blkcg_rstat_flush() includes propagating
the rstat data to its parent. However, if a blkg has been destroyed
(offline), the validity of its parent may be questionable. For safety,
revert back to the old behavior by ignoring offline blkg's.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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


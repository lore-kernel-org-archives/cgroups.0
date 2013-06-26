From: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cgroups: Do not show inactive devices in cgroups statistics
Date: Wed, 26 Jun 2013 12:26:10 -0700
Message-ID: <1372274770-30679-1-git-send-email-anatol.pomozov@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Before 3.5 cgrups stats files shown only devices with activity.
But latest kernel shows stats for all devices. The previous implementation
looks better. Imagine a server machine with hundreds cgroups and hundreds
iSCSI block devices (where cgroup uses just a few block devices). This
generates *a lot* of useless data that requires more resources to
process/store.

Recover previous behaviour by skipping entries with zero stats.

Signed-off-by: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 block/blk-cgroup.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index e8918ff..915c2b0 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -548,6 +548,9 @@ u64 __blkg_prfill_u64(struct seq_file *sf, struct blkg_policy_data *pd, u64 v)
 	if (!dname)
 		return 0;
 
+	if (!v)
+		return 0;
+
 	seq_printf(sf, "%s %llu\n", dname, (unsigned long long)v);
 	return v;
 }
@@ -571,19 +574,23 @@ u64 __blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
 		[BLKG_RWSTAT_ASYNC]	= "Async",
 	};
 	const char *dname = blkg_dev_name(pd->blkg);
-	u64 v;
+	u64 total;
 	int i;
 
 	if (!dname)
 		return 0;
 
+	total = rwstat->cnt[BLKG_RWSTAT_READ] + rwstat->cnt[BLKG_RWSTAT_WRITE];
+	/* skip devices with no activity */
+	if (!total)
+		return 0;
+
 	for (i = 0; i < BLKG_RWSTAT_NR; i++)
 		seq_printf(sf, "%s %s %llu\n", dname, rwstr[i],
 			   (unsigned long long)rwstat->cnt[i]);
 
-	v = rwstat->cnt[BLKG_RWSTAT_READ] + rwstat->cnt[BLKG_RWSTAT_WRITE];
-	seq_printf(sf, "%s Total %llu\n", dname, (unsigned long long)v);
-	return v;
+	seq_printf(sf, "%s Total %llu\n", dname, (unsigned long long)total);
+	return total;
 }
 EXPORT_SYMBOL_GPL(__blkg_prfill_rwstat);
 
-- 
1.8.3

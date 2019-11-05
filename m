From: Tejun Heo <tj@kernel.org>
Subject: [PATCH block/for-5.4-fixes] blkcg: make blkcg_print_stat() print
 stats only for online blkgs
Date: Tue, 5 Nov 2019 08:09:51 -0800
Message-ID: <20191105160951.GS3622521@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=me3lESL1ggtumWsSVDttQmUrbEo7485lmzzekY64N38=;
        b=tPrZdHjJcV0IzlK9UurrMNrUsqfSlMSqpZQhPr+KB57uDynjOd2cTm7wzPG77+mtk+
         hLy4rIuS5QDPxR2XJOLho/ugr6NpnXyf0z2qcsyEs1KXsWE9iEwSbsL5HK0pA0vxrdRX
         RBmf7MvgZoeS34lShwgpJj4mMhwED4aY97WiHDCa09wdQQw3dEbBYj1qurBcXocQ253p
         NOj/Fk6JB7X5eax98zJ3qHft9JtWqDZD4pM4D8np4axWPcwEM7cjLQ/Z8FzI96R6rpFz
         2xv70RhmHogmpE1IRKYvm5C6SePm7MjU72MVcm51XYWQSpWchtuiI+mDMKCXRc9E8u76
         4/YQ==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Roman Gushchin <guro@fb.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Josef Bacik <jbacik@fb.com>

blkcg_print_stat() iterates blkgs under RCU and doesn't test whether
the blkg is online.  This can call into pd_stat_fn() on a pd which is
still being initialized leading to an oops.

The heaviest operation - recursively summing up rwstat counters - is
already done while holding the queue_lock.  Expand queue_lock to cover
the other operations and skip the blkg if it isn't online yet.  The
online state is protected by both blkcg and queue locks, so this
guarantees that only online blkgs are processed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Roman Gushchin <guro@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Fixes: 903d23f0a354 ("blk-cgroup: allow controllers to output their own stats")
Cc: stable@vger.kernel.org # v4.19+
---
 block/blk-cgroup.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -934,9 +934,14 @@ static int blkcg_print_stat(struct seq_f
 		int i;
 		bool has_stats = false;
 
+		spin_lock_irq(&blkg->q->queue_lock);
+
+		if (!blkg->online)
+			goto skip;
+
 		dname = blkg_dev_name(blkg);
 		if (!dname)
-			continue;
+			goto skip;
 
 		/*
 		 * Hooray string manipulation, count is the size written NOT
@@ -946,8 +951,6 @@ static int blkcg_print_stat(struct seq_f
 		 */
 		off += scnprintf(buf+off, size-off, "%s ", dname);
 
-		spin_lock_irq(&blkg->q->queue_lock);
-
 		blkg_rwstat_recursive_sum(blkg, NULL,
 				offsetof(struct blkcg_gq, stat_bytes), &rwstat);
 		rbytes = rwstat.cnt[BLKG_RWSTAT_READ];
@@ -960,8 +963,6 @@ static int blkcg_print_stat(struct seq_f
 		wios = rwstat.cnt[BLKG_RWSTAT_WRITE];
 		dios = rwstat.cnt[BLKG_RWSTAT_DISCARD];
 
-		spin_unlock_irq(&blkg->q->queue_lock);
-
 		if (rbytes || wbytes || rios || wios) {
 			has_stats = true;
 			off += scnprintf(buf+off, size-off,
@@ -999,6 +1000,8 @@ static int blkcg_print_stat(struct seq_f
 				seq_commit(sf, -1);
 			}
 		}
+	skip:
+		spin_unlock_irq(&blkg->q->queue_lock);
 	}
 
 	rcu_read_unlock();

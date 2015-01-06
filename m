From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/45] writeback, blkcg: associate each blkcg_gq with the corresponding bdi_writeback
Date: Tue,  6 Jan 2015 16:25:43 -0500
Message-ID: <1420579582-8516-7-git-send-email-tj@kernel.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MdMjyO1DwrsHANe1WjQi1/ie9GDSr6ItaAiH0RCQubM=;
        b=1EDM/ftfnBKKyRBMhTpQEf/+9coVa9KxsQrr0wCZJO8Q3+yha2fssb2gtpk4UmQOkG
         lHwkkjIKi6KQL50wLj1ClbKaRV8ABqknLsaj+hlbKazJfPEQN2pO870aSeqXP7WyRbAo
         nF5rxKTXxlAH9AGSuXKD9mrnWvCmL60lgXeXgoeNQJwzFYdqq51w/mSf+sGaXqaYlIwq
         Yk8UtbT4ahwa7heoqKgK3bUjOIDhLBstGeXFRzJxTpPFTz5zRXbMyly2MOggnbAwe3AM
         /EkwsVbTH4oe54qN/X32N1yaaxC9kXaKtUVjayABqAv0T6XO8KqBB3ki4WtQJcQuMoIe
         76vA==
In-Reply-To: <1420579582-8516-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, Tejun Heo <tj@kernel.org>

A blkg (blkcg_gq) can be congested and decongested independently from
other blkgs on the same request_queue.  Accordingly, for cgroup
writeback support, the congestion status at bdi (backing_dev_info)
should be split to per-cgroup wb's (bdi_writeback's) and updated
separately from matching blkg's.

This patch prepares by adding blkg->wb and associating a blkg with its
matching per-cgroup wb on creation.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c         | 15 +++++++++++++++
 include/linux/blk-cgroup.h |  6 ++++++
 2 files changed, 21 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 8bebaa9..6fe085c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -182,6 +182,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 				    struct blkcg_gq *new_blkg)
 {
 	struct blkcg_gq *blkg;
+	struct bdi_writeback *wb;
 	int i, ret;
 
 	WARN_ON_ONCE(!rcu_read_lock_held());
@@ -193,6 +194,19 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 		goto err_free_blkg;
 	}
 
+	/*
+	 * Once created, @wb will stay alive longer than @blkg.  @wb is
+	 * destroyed iff either its bdi or @blkcg is destroyed.  The bdi is
+	 * part of the request_queue and will outlive @blkg, and, while
+	 * @blkcg is being brought down, @wb will be destroyed the last in
+	 * ->css_released().
+	 */
+	wb = cgwb_lookup_create(&q->backing_dev_info, &blkcg->css);
+	if (!wb) {
+		ret = -ENOMEM;
+		goto err_free_blkg;
+	}
+
 	/* allocate */
 	if (!new_blkg) {
 		new_blkg = blkg_alloc(blkcg, q, GFP_ATOMIC);
@@ -202,6 +216,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 		}
 	}
 	blkg = new_blkg;
+	blkg->wb = wb;
 
 	/* link parent */
 	if (blkcg_parent(blkcg)) {
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 3033eb1..97ceee3 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -99,6 +99,12 @@ struct blkcg_gq {
 	struct hlist_node		blkcg_node;
 	struct blkcg			*blkcg;
 
+	/*
+	 * Each blkg gets congested separately and the congestion state is
+	 * propagated to the matching cgroup wb.
+	 */
+	struct bdi_writeback		*wb;
+
 	/* all non-root blkcg_gq's are guaranteed to have access to parent */
 	struct blkcg_gq			*parent;
 
-- 
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

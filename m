From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/11] blkcg: add request_queue->root_blkg
Date: Fri, 13 Apr 2012 13:11:32 -0700
Message-ID: <1334347895-6268-9-git-send-email-tj@kernel.org>
References: <1334347895-6268-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=7exglU+srwTtFFd55EWaf2fCVhp/uCkRx8SoBMFTcOE=;
        b=eqeJHCu5uZlAHUrWchaxXoE1kUsP7lzKZ7SD4Isy+X3rhT+QARBxccDBl7YNtg+SEY
         zb6IA9/Lbg3gNwzM/bR2qzrYMaMkiCOA6rAV7/7vXCcUGvpndrHZxm9vdr3/K3C8AzcB
         oYUlxC8s4K1Yy3YK0VnnTBmoPlGSSSjsv7o8m8FB/Zdeb5NrQobFSTeQiVkgCZj7QN9l
         cpoO/hYkOGTEvCrM1+GVbSRqr3JuyY9Mm0y5d2AZbklWYlwn1H5SSdo5uQT7he3nuVko
         G7RWW5o3y7MUlomOn0zdRPnIA4NDfXHcmcR05oGOwqhd5zkGRO+9VV+51a2JRW0VMfAO
         5/lg==
In-Reply-To: <1334347895-6268-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, containers@lists.linux-foundation.org, Tejun Heo <tj@kernel.org>

With per-queue policy activation, root blkg creation will be moved to
blkcg core.  Add q->root_blkg in preparation.  For blk-throtl, this
replaces throtl_data->root_tg; however, cfq needs to keep
cfqd->root_group for !CONFIG_CFQ_GROUP_IOSCHED.

This is to prepare for per-queue policy activation and doesn't cause
any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c   |   16 ++++++++++------
 block/cfq-iosched.c    |    4 +++-
 include/linux/blkdev.h |    2 ++
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 6f1bfdf..8c520fa 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -97,7 +97,6 @@ struct throtl_data
 	/* service tree for active throtl groups */
 	struct throtl_rb_root tg_service_tree;
 
-	struct throtl_grp *root_tg;
 	struct request_queue *queue;
 
 	/* Total Number of queued bios on READ and WRITE lists */
@@ -131,6 +130,11 @@ static inline struct blkio_group *tg_to_blkg(struct throtl_grp *tg)
 	return pdata_to_blkg(tg);
 }
 
+static inline struct throtl_grp *td_root_tg(struct throtl_data *td)
+{
+	return blkg_to_tg(td->queue->root_blkg);
+}
+
 enum tg_state_flags {
 	THROTL_TG_FLAG_on_rr = 0,	/* on round-robin busy list */
 };
@@ -261,7 +265,7 @@ throtl_grp *throtl_lookup_tg(struct throtl_data *td, struct blkio_cgroup *blkcg)
 	 * Avoid lookup in this case
 	 */
 	if (blkcg == &blkio_root_cgroup)
-		return td->root_tg;
+		return td_root_tg(td);
 
 	return blkg_to_tg(blkg_lookup(blkcg, td->queue));
 }
@@ -277,7 +281,7 @@ static struct throtl_grp *throtl_lookup_create_tg(struct throtl_data *td,
 	 * Avoid lookup in this case
 	 */
 	if (blkcg == &blkio_root_cgroup) {
-		tg = td->root_tg;
+		tg = td_root_tg(td);
 	} else {
 		struct blkio_group *blkg;
 
@@ -287,7 +291,7 @@ static struct throtl_grp *throtl_lookup_create_tg(struct throtl_data *td,
 		if (!IS_ERR(blkg))
 			tg = blkg_to_tg(blkg);
 		else if (!blk_queue_dead(q))
-			tg = td->root_tg;
+			tg = td_root_tg(td);
 	}
 
 	return tg;
@@ -1245,12 +1249,12 @@ int blk_throtl_init(struct request_queue *q)
 
 	blkg = blkg_lookup_create(&blkio_root_cgroup, q, true);
 	if (!IS_ERR(blkg))
-		td->root_tg = blkg_to_tg(blkg);
+		q->root_blkg = blkg;
 
 	spin_unlock_irq(q->queue_lock);
 	rcu_read_unlock();
 
-	if (!td->root_tg) {
+	if (!q->root_blkg) {
 		kfree(td);
 		return -ENOMEM;
 	}
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index de95f9a..86440e0 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3964,8 +3964,10 @@ static int cfq_init_queue(struct request_queue *q)
 	spin_lock_irq(q->queue_lock);
 
 	blkg = blkg_lookup_create(&blkio_root_cgroup, q, true);
-	if (!IS_ERR(blkg))
+	if (!IS_ERR(blkg)) {
+		q->root_blkg = blkg;
 		cfqd->root_group = blkg_to_cfqg(blkg);
+	}
 
 	spin_unlock_irq(q->queue_lock);
 	rcu_read_unlock();
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d2c69f8..b01c377 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -31,6 +31,7 @@ struct blk_trace;
 struct request;
 struct sg_io_hdr;
 struct bsg_job;
+struct blkio_group;
 
 #define BLKDEV_MIN_RQ	4
 #define BLKDEV_MAX_RQ	128	/* Default maximum */
@@ -369,6 +370,7 @@ struct request_queue {
 
 	struct list_head	icq_list;
 #ifdef CONFIG_BLK_CGROUP
+	struct blkio_group	*root_blkg;
 	struct list_head	blkg_list;
 #endif
 
-- 
1.7.7.3

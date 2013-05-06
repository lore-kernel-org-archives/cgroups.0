From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/33] blk-throttle: simplify throtl_grp flag handling
Date: Mon,  6 May 2013 15:45:51 -0700
Message-ID: <1367880372-28312-13-git-send-email-tj@kernel.org>
References: <1367880372-28312-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=e07tBs+EiE1zI67NYNZwEIlp++o34gLc4Unwm9sEjSI=;
        b=slOND33MtTHcDwhJCeSR8g9PpPimIuPPP6PvJCT/+lEnqJtx1P7/MXjXGVaiygNGMh
         vsnf3NJeq2P6RYEtKk7x75fv9F3XiobclJvdR368CCEYV3su85u3IbF1ebhpLAG2CwnH
         276skE5j1PmH6vgKDK6zlxEA0+YnILmQpGiKbbiHI6OJMBLat6ucd1M+hEqYa6vpDD1N
         yFtGNyqxAzJyh/16U9dVhinRs8XNL98kvgMhEDf0N67Ht9Ioa+VbBBlEnK768NUcefJV
         AGYIPx2fpTNOvAP+JjO4+AVopS8XiI15P8oX0To/SHLzM6o8iiYTEbtAv0a07/mRUvQ9
         ivkg==
In-Reply-To: <1367880372-28312-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, vgoyal@redhat.com, Tejun Heo <tj@kernel.org>

blk-throttle is still using function-defining macros to define flag
handling functions, which went out style at least a decade ago.

Just define the flag as bitmask and use direct bit operations.

This patch doesn't make any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-throttle.c | 34 +++++++++-------------------------
 1 file changed, 9 insertions(+), 25 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index b279110..e8ef43d 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -36,6 +36,10 @@ struct throtl_service_queue {
 #define THROTL_SERVICE_QUEUE_INITIALIZER				\
 	(struct throtl_service_queue){ .pending_tree = RB_ROOT }
 
+enum tg_state_flags {
+	THROTL_TG_PENDING	= 1 << 0,	/* on parent's pending tree */
+};
+
 #define rb_entry_tg(node)	rb_entry((node), struct throtl_grp, rb_node)
 
 /* Per-cpu group stats */
@@ -136,26 +140,6 @@ static inline struct throtl_grp *td_root_tg(struct throtl_data *td)
 	return blkg_to_tg(td->queue->root_blkg);
 }
 
-enum tg_state_flags {
-	THROTL_TG_FLAG_on_rr = 0,	/* on round-robin busy list */
-};
-
-#define THROTL_TG_FNS(name)						\
-static inline void throtl_mark_tg_##name(struct throtl_grp *tg)		\
-{									\
-	(tg)->flags |= (1 << THROTL_TG_FLAG_##name);			\
-}									\
-static inline void throtl_clear_tg_##name(struct throtl_grp *tg)	\
-{									\
-	(tg)->flags &= ~(1 << THROTL_TG_FLAG_##name);			\
-}									\
-static inline int throtl_tg_##name(const struct throtl_grp *tg)		\
-{									\
-	return ((tg)->flags & (1 << THROTL_TG_FLAG_##name)) != 0;	\
-}
-
-THROTL_TG_FNS(on_rr);
-
 #define throtl_log_tg(td, tg, fmt, args...)	do {			\
 	char __pbuf[128];						\
 									\
@@ -369,25 +353,25 @@ static void __throtl_enqueue_tg(struct throtl_data *td, struct throtl_grp *tg)
 	struct throtl_service_queue *sq = &td->service_queue;
 
 	tg_service_queue_add(sq, tg);
-	throtl_mark_tg_on_rr(tg);
+	tg->flags |= THROTL_TG_PENDING;
 	sq->nr_pending++;
 }
 
 static void throtl_enqueue_tg(struct throtl_data *td, struct throtl_grp *tg)
 {
-	if (!throtl_tg_on_rr(tg))
+	if (!(tg->flags & THROTL_TG_PENDING))
 		__throtl_enqueue_tg(td, tg);
 }
 
 static void __throtl_dequeue_tg(struct throtl_data *td, struct throtl_grp *tg)
 {
 	throtl_rb_erase(&tg->rb_node, &td->service_queue);
-	throtl_clear_tg_on_rr(tg);
+	tg->flags &= ~THROTL_TG_PENDING;
 }
 
 static void throtl_dequeue_tg(struct throtl_data *td, struct throtl_grp *tg)
 {
-	if (throtl_tg_on_rr(tg))
+	if (tg->flags & THROTL_TG_PENDING)
 		__throtl_dequeue_tg(td, tg);
 }
 
@@ -964,7 +948,7 @@ static int tg_set_conf(struct cgroup *cgrp, struct cftype *cft, const char *buf,
 	throtl_start_new_slice(td, tg, 0);
 	throtl_start_new_slice(td, tg, 1);
 
-	if (throtl_tg_on_rr(tg)) {
+	if (tg->flags & THROTL_TG_PENDING) {
 		tg_update_disptime(td, tg);
 		throtl_schedule_next_dispatch(td);
 	}
-- 
1.8.1.4

From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/15] blktrace: cleanup the __trace_note_message interface
Date: Wed, 20 Apr 2022 06:27:16 +0200
Message-ID: <20220420042723.1010598-9-hch@lst.de>
References: <20220420042723.1010598-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=z4kVHfd818SoTIxGrpcQJu5PQ1rXDdXeUKXa081g1Ys=; b=RFet4+Us30CXi/pkLau0em9STC
        WS+iXsWbgQ9oFkmgXRiY8e1CcQLXRheY9BeFJqs0srT5dKUqC6izzKiGL5uF8UjeIcH/TT956v147
        7Zg3Oey+6+loGX15z2grCVC9fUbrtW9xcYAXjmuUjGqZtBvQNkHIXj5frxosMux4ILcwUXyw6R0G8
        3w5620LBGKpKmi3b0DrE37PRyHWgdAUahBEGYaaR8SOj4eOFxfHXSxWAIZotuMcld/foTSGqZqqmy
        XVEJUaOHEQptIWsjW93bx0l9fZL0rA7RX0rL8f9+oLXbQFvcUKiIMsbTbDMLUb67IoEToPQWbDu40
        M9y4YqNQ==;
In-Reply-To: <20220420042723.1010598-1-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Paolo Valente <paolo.valente@linaro.org>, Tejun Heo <tj@kernel.org>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-nvme@lists.infradead.org, linux-mm@kvack.org

Pass the cgroup_subsys_state instead of a the blkg so that blktrace
doesn't need to poke into blk-cgroup internals, and give the name a
blk prefix as the current name is way too generic for a public
interface.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bfq-iosched.h          |  4 ++--
 block/blk-throttle.c         |  2 +-
 include/linux/blktrace_api.h | 10 ++++------
 kernel/trace/blktrace.c      | 20 ++++++++++----------
 4 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 978ef5d6fe6ab..b18d6c31c2251 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -1102,13 +1102,13 @@ struct bfq_group *bfqq_group(struct bfq_queue *bfqq);
 		break;							\
 	bfq_bfqq_name((bfqq), pid_str, MAX_BFQQ_NAME_LENGTH);		\
 	blk_add_cgroup_trace_msg((bfqd)->queue,				\
-			bfqg_to_blkg(bfqq_group(bfqq))->blkcg,		\
+			&bfqg_to_blkg(bfqq_group(bfqq))->blkcg->css,	\
 			"%s " fmt, pid_str, ##args);			\
 } while (0)
 
 #define bfq_log_bfqg(bfqd, bfqg, fmt, args...)	do {			\
 	blk_add_cgroup_trace_msg((bfqd)->queue,				\
-		bfqg_to_blkg(bfqg)->blkcg, fmt, ##args);		\
+		&bfqg_to_blkg(bfqg)->blkcg->css, fmt, ##args);		\
 } while (0)
 
 #else /* CONFIG_BFQ_GROUP_IOSCHED */
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 469c483719bea..447e1b8722f7a 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -227,7 +227,7 @@ static unsigned int tg_iops_limit(struct throtl_grp *tg, int rw)
 		break;							\
 	if ((__tg)) {							\
 		blk_add_cgroup_trace_msg(__td->queue,			\
-			tg_to_blkg(__tg)->blkcg, "throtl " fmt, ##args);\
+			&tg_to_blkg(__tg)->blkcg->css, "throtl " fmt, ##args);\
 	} else {							\
 		blk_add_trace_msg(__td->queue, "throtl " fmt, ##args);	\
 	}								\
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 22501a293fa54..623e22492afa5 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -27,12 +27,10 @@ struct blk_trace {
 	atomic_t dropped;
 };
 
-struct blkcg;
-
 extern int blk_trace_ioctl(struct block_device *, unsigned, char __user *);
 extern void blk_trace_shutdown(struct request_queue *);
-extern __printf(3, 4)
-void __trace_note_message(struct blk_trace *, struct blkcg *blkcg, const char *fmt, ...);
+__printf(3, 4) void __blk_trace_note_message(struct blk_trace *bt,
+		struct cgroup_subsys_state *css, const char *fmt, ...);
 
 /**
  * blk_add_trace_msg - Add a (simple) message to the blktrace stream
@@ -47,14 +45,14 @@ void __trace_note_message(struct blk_trace *, struct blkcg *blkcg, const char *f
  *     NOTE: Can not use 'static inline' due to presence of var args...
  *
  **/
-#define blk_add_cgroup_trace_msg(q, cg, fmt, ...)			\
+#define blk_add_cgroup_trace_msg(q, css, fmt, ...)			\
 	do {								\
 		struct blk_trace *bt;					\
 									\
 		rcu_read_lock();					\
 		bt = rcu_dereference((q)->blk_trace);			\
 		if (unlikely(bt))					\
-			__trace_note_message(bt, cg, fmt, ##__VA_ARGS__);\
+			__blk_trace_note_message(bt, css, fmt, ##__VA_ARGS__);\
 		rcu_read_unlock();					\
 	} while (0)
 #define blk_add_trace_msg(q, fmt, ...)					\
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 4d5629196d01d..9ef349ac49c01 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -145,13 +145,14 @@ static void trace_note_time(struct blk_trace *bt)
 	local_irq_restore(flags);
 }
 
-void __trace_note_message(struct blk_trace *bt, struct blkcg *blkcg,
-	const char *fmt, ...)
+void __blk_trace_note_message(struct blk_trace *bt,
+		struct cgroup_subsys_state *css, const char *fmt, ...)
 {
 	int n;
 	va_list args;
 	unsigned long flags;
 	char *buf;
+	u64 cgid = 0;
 
 	if (unlikely(bt->trace_state != Blktrace_running &&
 		     !blk_tracer_enabled))
@@ -170,17 +171,16 @@ void __trace_note_message(struct blk_trace *bt, struct blkcg *blkcg,
 	n = vscnprintf(buf, BLK_TN_MAX_MSG, fmt, args);
 	va_end(args);
 
-	if (!(blk_tracer_flags.val & TRACE_BLK_OPT_CGROUP))
-		blkcg = NULL;
 #ifdef CONFIG_BLK_CGROUP
-	trace_note(bt, current->pid, BLK_TN_MESSAGE, buf, n,
-		   blkcg ? cgroup_id(blkcg->css.cgroup) : 1);
-#else
-	trace_note(bt, current->pid, BLK_TN_MESSAGE, buf, n, 0);
+	if (css && (blk_tracer_flags.val & TRACE_BLK_OPT_CGROUP))
+		cgid = cgroup_id(css->cgroup);
+	else
+		cgid = 1;
 #endif
+	trace_note(bt, current->pid, BLK_TN_MESSAGE, buf, n, cgid);
 	local_irq_restore(flags);
 }
-EXPORT_SYMBOL_GPL(__trace_note_message);
+EXPORT_SYMBOL_GPL(__blk_trace_note_message);
 
 static int act_log_check(struct blk_trace *bt, u32 what, sector_t sector,
 			 pid_t pid)
@@ -411,7 +411,7 @@ static ssize_t blk_msg_write(struct file *filp, const char __user *buffer,
 		return PTR_ERR(msg);
 
 	bt = filp->private_data;
-	__trace_note_message(bt, NULL, "%s", msg);
+	__blk_trace_note_message(bt, NULL, "%s", msg);
 	kfree(msg);
 
 	return count;
-- 
2.30.2


From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 09/31] blk-throttle: relocate throtl_schedule_delayed_work()
Date: Wed,  1 May 2013 17:39:27 -0700
Message-ID: <1367455189-6957-10-git-send-email-tj@kernel.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=gLomw5S7hxOA3v/PH/K9MiyxX1DavyL9MQMik4hCPiA=;
        b=WMmWvdCMCvlKcQ2JBQwA+A9LF4oDnfjuxkr5o66dajvm0kJQMyxjHJlXIBpu+7nVgQ
         dMrBJGCe9RLUGoOtzI51g1AeQdr3M+iCN6NS4OtBO6BZdcKjwyXgnrxSh6nUb/5GLtNI
         Q1R7Ee42HAAMJd7wUz/WO2YwACNe9CMU1rxGH1fElgFdC8JfEqgEJJKM5fE7BZKoCn3/
         Fpo2gOF9zApuTMnKUpuzIUo1WgrQt/SWw5keVzXWXTNqYlZevAJBTX6Oo5WCz47CD372
         4BAFpT0pZ09XuPanfu2RHtZIeTSBO0W5MEtx7/uhhQv82VyafrYARj4AgPJIIHpFojmY
         QMNg==
In-Reply-To: <1367455189-6957-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Move throtl_schedule_delayed_work() above its first user so that the
forward declaration can be removed.

This patch is pure relocaiton.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-throttle.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index d50d8d1..00e72f4 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -25,8 +25,6 @@ static struct blkcg_policy blkcg_policy_throtl;
 
 /* A workqueue to queue throttle related work */
 static struct workqueue_struct *kthrotld_workqueue;
-static void throtl_schedule_delayed_work(struct throtl_data *td,
-				unsigned long delay);
 
 struct throtl_rb_root {
 	struct rb_root rb;
@@ -398,6 +396,19 @@ static void throtl_dequeue_tg(struct throtl_data *td, struct throtl_grp *tg)
 		__throtl_dequeue_tg(td, tg);
 }
 
+/* Call with queue lock held */
+static void throtl_schedule_delayed_work(struct throtl_data *td,
+					 unsigned long delay)
+{
+	struct delayed_work *dwork = &td->dispatch_work;
+
+	if (total_nr_queued(td)) {
+		mod_delayed_work(kthrotld_workqueue, dwork, delay);
+		throtl_log(td, "schedule work. delay=%lu jiffies=%lu",
+			   delay, jiffies);
+	}
+}
+
 static void throtl_schedule_next_dispatch(struct throtl_data *td)
 {
 	struct throtl_rb_root *st = &td->tg_service_tree;
@@ -863,20 +874,6 @@ out:
 	}
 }
 
-/* Call with queue lock held */
-static void
-throtl_schedule_delayed_work(struct throtl_data *td, unsigned long delay)
-{
-
-	struct delayed_work *dwork = &td->dispatch_work;
-
-	if (total_nr_queued(td)) {
-		mod_delayed_work(kthrotld_workqueue, dwork, delay);
-		throtl_log(td, "schedule work. delay=%lu jiffies=%lu",
-				delay, jiffies);
-	}
-}
-
 static u64 tg_prfill_cpu_rwstat(struct seq_file *sf,
 				struct blkg_policy_data *pd, int off)
 {
-- 
1.8.1.4

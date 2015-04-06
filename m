From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/49] cgroup, block: implement task_get_css() and use it in bio_associate_current()
Date: Mon,  6 Apr 2015 15:57:56 -0400
Message-ID: <1428350318-8215-8-git-send-email-tj@kernel.org>
References: <1428350318-8215-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=n79EXbZjE8tkKedy0HAdStcVdzdt0oNhnPbmkJaxUdE=;
        b=Ha3S/e280FN6BU5zCMcfe1wAV3+baDke2DfOC5X6CkzETiAE1ya2rLGDqv/3tzO2lh
         XQw5KdOBUSUd8TOvjHVOzW7mGQlw5LKPbp/S8ZuOqDpMjQ7QcpvaMW6P74caK0dW5wc6
         dmpVsJYeeT45AMh5Uml2pK2rgJhXEl4P4BWpVyj2KjQlc9XLe/Rc46KdrqA9gBuysnZt
         X+ww2mPlGlmqFOgB/gbCY+Z0hcOpMmbFcMSaBuU4unRxQ3Romq5cbXje1tEcHVRMPha5
         4fKnmBywvYHkUErZ3jbXkyLe0lDPSdtFPCpp9XiZ3Kub5oAy/kQRSMY5q29N5GW/nHeg
         sJxg==
In-Reply-To: <1428350318-8215-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>

bio_associate_current() currently open codes task_css() and
css_tryget_online() to find and pin $current's blkcg css.  Abstract it
into task_get_css() which is implemented from cgroup side.  As a task
is always associated with an online css for every subsystem except
while the css_set update is propagating, task_get_css() retries till
css_tryget_online() succeeds.

This is a cleanup and shouldn't lead to noticeable behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/bio.c            | 11 +----------
 include/linux/cgroup.h | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index f66a4ea..968683e 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1987,7 +1987,6 @@ EXPORT_SYMBOL(bioset_create_nobvec);
 int bio_associate_current(struct bio *bio)
 {
 	struct io_context *ioc;
-	struct cgroup_subsys_state *css;
 
 	if (bio->bi_ioc)
 		return -EBUSY;
@@ -1996,17 +1995,9 @@ int bio_associate_current(struct bio *bio)
 	if (!ioc)
 		return -ENOENT;
 
-	/* acquire active ref on @ioc and associate */
 	get_io_context_active(ioc);
 	bio->bi_ioc = ioc;
-
-	/* associate blkcg if exists */
-	rcu_read_lock();
-	css = task_css(current, blkio_cgrp_id);
-	if (css && css_tryget_online(css))
-		bio->bi_css = css;
-	rcu_read_unlock();
-
+	bio->bi_css = task_get_css(current, blkio_cgrp_id);
 	return 0;
 }
 
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index b9cb94c..e7da0aa 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -774,6 +774,31 @@ static inline struct cgroup_subsys_state *task_css(struct task_struct *task,
 }
 
 /**
+ * task_get_css - find and get the css for (task, subsys)
+ * @task: the target task
+ * @subsys_id: the target subsystem ID
+ *
+ * Find the css for the (@task, @subsys_id) combination, increment a
+ * reference on and return it.  This function is guaranteed to return a
+ * valid css.
+ */
+static inline struct cgroup_subsys_state *
+task_get_css(struct task_struct *task, int subsys_id)
+{
+	struct cgroup_subsys_state *css;
+
+	rcu_read_lock();
+	while (true) {
+		css = task_css(task, subsys_id);
+		if (likely(css_tryget_online(css)))
+			break;
+		cpu_relax();
+	}
+	rcu_read_unlock();
+	return css;
+}
+
+/**
  * task_css_is_root - test whether a task belongs to the root css
  * @task: the target task
  * @subsys_id: the target subsystem ID
-- 
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

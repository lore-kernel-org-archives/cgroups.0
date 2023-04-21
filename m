From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 5/5] cgroup: remove cgroup_rstat_flush_atomic()
Date: Fri, 21 Apr 2023 17:40:20 +0000
Message-ID: <20230421174020.2994750-6-yosryahmed@google.com>
References: <20230421174020.2994750-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682098832; x=1684690832;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xEOFJLcgICBTmNTLnyQD1ooBVf7w9cMBHK4zBwAxhps=;
        b=2LLI0uS0HCGgUG+To5FG73zbxk+tuzk5tTcOBZNGKwnVbYk9yq2r0zkyTl0MD4wfQ3
         kKiggVfa7NNclULg8NuxAqHV3zYnq7LZjfMrcVD62yChQCNHWbk54zVsBhxomTb0t0SN
         +XgJr7wul3fQD2JopF/MZfktxPtuUWKER8IL9ZU+RSEl7sW66jFXxgj6K5ErZztO7Nce
         l4ZWAyWNanyDDUgKfIgOcWOkpHNwJKJvYyr6/84gH8i9GqoBVPKeVaSusHPk+GdeSMBt
         A9hidHBqS6YCIVpadKtHiQ8uYxCY8mC3l7iI3bjfr9izY/KQoToKFIDt3lP79eIF321D
         fMOw==
In-Reply-To: <20230421174020.2994750-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Previous patches removed the only caller of cgroup_rstat_flush_atomic().
Remove the function and simplify the code.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h |  1 -
 kernel/cgroup/rstat.c  | 26 +++++---------------------
 2 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 885f5395fcd0..567c547cf371 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -692,7 +692,6 @@ static inline void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen)
  */
 void cgroup_rstat_updated(struct cgroup *cgrp, int cpu);
 void cgroup_rstat_flush(struct cgroup *cgrp);
-void cgroup_rstat_flush_atomic(struct cgroup *cgrp);
 void cgroup_rstat_flush_hold(struct cgroup *cgrp);
 void cgroup_rstat_flush_release(void);
 
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index d3252b0416b6..f9ad33f117c8 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -171,7 +171,7 @@ __weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
 __diag_pop();
 
 /* see cgroup_rstat_flush() */
-static void cgroup_rstat_flush_locked(struct cgroup *cgrp, bool may_sleep)
+static void cgroup_rstat_flush_locked(struct cgroup *cgrp)
 	__releases(&cgroup_rstat_lock) __acquires(&cgroup_rstat_lock)
 {
 	int cpu;
@@ -207,9 +207,8 @@ static void cgroup_rstat_flush_locked(struct cgroup *cgrp, bool may_sleep)
 		}
 		raw_spin_unlock_irqrestore(cpu_lock, flags);
 
-		/* if @may_sleep, play nice and yield if necessary */
-		if (may_sleep && (need_resched() ||
-				  spin_needbreak(&cgroup_rstat_lock))) {
+		/* play nice and yield if necessary */
+		if (need_resched() || spin_needbreak(&cgroup_rstat_lock)) {
 			spin_unlock_irq(&cgroup_rstat_lock);
 			if (!cond_resched())
 				cpu_relax();
@@ -236,25 +235,10 @@ __bpf_kfunc void cgroup_rstat_flush(struct cgroup *cgrp)
 	might_sleep();
 
 	spin_lock_irq(&cgroup_rstat_lock);
-	cgroup_rstat_flush_locked(cgrp, true);
+	cgroup_rstat_flush_locked(cgrp);
 	spin_unlock_irq(&cgroup_rstat_lock);
 }
 
-/**
- * cgroup_rstat_flush_atomic- atomic version of cgroup_rstat_flush()
- * @cgrp: target cgroup
- *
- * This function can be called from any context.
- */
-void cgroup_rstat_flush_atomic(struct cgroup *cgrp)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&cgroup_rstat_lock, flags);
-	cgroup_rstat_flush_locked(cgrp, false);
-	spin_unlock_irqrestore(&cgroup_rstat_lock, flags);
-}
-
 /**
  * cgroup_rstat_flush_hold - flush stats in @cgrp's subtree and hold
  * @cgrp: target cgroup
@@ -269,7 +253,7 @@ void cgroup_rstat_flush_hold(struct cgroup *cgrp)
 {
 	might_sleep();
 	spin_lock_irq(&cgroup_rstat_lock);
-	cgroup_rstat_flush_locked(cgrp, true);
+	cgroup_rstat_flush_locked(cgrp);
 }
 
 /**
-- 
2.40.0.634.g4ca3ef3211-goog


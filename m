From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 2/3] sched: Provide copy_user_cpus_mask() to copy out user mask
Date: Tue, 16 Aug 2022 11:11:18 -0400
Message-ID: <20220816151119.29534-3-longman@redhat.com>
References: <20220816151119.29534-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660662698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wtQ3T2SnjxmANB9ZOMVYpxJhFmJErNinRxxSjh7HxJA=;
        b=aWDUtQWEp/CvjO6j0e0piWFBdhaAWMmGNxvMcUjugMsq2mveXwGU2snrtJWe5/IuHlOFSI
        O91phw6HX8cez68HSYFxeH3cLx/ilBmaSYoiBLRAxfffnuTcGKeAovSGY+rUVUmMN1somp
        u7IZnDOvsYlB1NZUfvgA/UAl4zeb4f4=
In-Reply-To: <20220816151119.29534-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Since accessing the content of the user_cpus_ptr requires lock protection
to ensure its validity, provide a helper function copy_user_cpus_mask()
to facilitate its reading.

Suggested-by: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sched.h |  1 +
 kernel/sched/core.c   | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e7b2f8a5c711..f2b0340c094e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1830,6 +1830,7 @@ extern int task_can_attach(struct task_struct *p, const struct cpumask *cs_effec
 extern void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask);
 extern int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask);
 extern int dup_user_cpus_ptr(struct task_struct *dst, struct task_struct *src, int node);
+extern struct cpumask *copy_user_cpus_mask(struct task_struct *p, struct cpumask *user_mask);
 extern void release_user_cpus_ptr(struct task_struct *p);
 extern int dl_task_check_affinity(struct task_struct *p, const struct cpumask *mask);
 extern void force_compatible_cpus_allowed_ptr(struct task_struct *p);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9353641efdca..ee0fa1635163 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2618,6 +2618,25 @@ void release_user_cpus_ptr(struct task_struct *p)
 	kfree(clear_user_cpus_ptr(p));
 }
 
+/*
+ * Return the copied mask pointer or NULL if user mask not available.
+ * Acquiring pi_lock for read access protection.
+ */
+struct cpumask *copy_user_cpus_mask(struct task_struct *p,
+				    struct cpumask *user_mask)
+{
+	struct cpumask *mask = NULL;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&p->pi_lock, flags);
+	if (p->user_cpus_ptr) {
+		cpumask_copy(user_mask, p->user_cpus_ptr);
+		mask = user_mask;
+	}
+	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+	return mask;
+}
+
 /*
  * This function is wildly self concurrent; here be dragons.
  *
-- 
2.31.1


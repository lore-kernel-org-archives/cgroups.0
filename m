From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 2/3] sched: Provide copy_user_cpus_mask() to copy out user mask
Date: Fri, 12 Aug 2022 16:39:28 -0400
Message-ID: <20220812203929.364341-3-longman@redhat.com>
References: <20220812203929.364341-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660336803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PTybH4D4WwOeqo3rN415vbeLaTvaxhsUDN/KB9esUqw=;
        b=hWG9LNFswjTO52SCpmolgUQs+b48IeYYVw581gLvISdnyqabZ7sFnkx4WxCvX/qnSgpnpf
        /ceTCUt6akz16tTTUSMchduBbg+B8E6mq1X1nJ/1MEKieuMY20esb2uA+hB/4zAA4ZQnWH
        jo6eFwSMrrD77Y2rFa26Ra5q8HutRCw=
In-Reply-To: <20220812203929.364341-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Since accessing the content of the user_cpus_ptr requires lock protection
to ensure its validity, provide a helper function copy_user_cpus_mask()
to facilitate its reading.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sched.h |  1 +
 kernel/sched/core.c   | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index cf7206a9b29a..e06bc1cbccca 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1831,6 +1831,7 @@ extern int task_can_attach(struct task_struct *p, const struct cpumask *cs_effec
 extern void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask);
 extern int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask);
 extern int dup_user_cpus_ptr(struct task_struct *dst, struct task_struct *src, int node);
+extern struct cpumask *copy_user_cpus_mask(struct task_struct *p, struct cpumask *user_mask);
 extern void release_user_cpus_ptr(struct task_struct *p);
 extern int dl_task_check_affinity(struct task_struct *p, const struct cpumask *mask);
 extern void force_compatible_cpus_allowed_ptr(struct task_struct *p);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7e2576068331..4d3b10e91e1a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2619,6 +2619,24 @@ void release_user_cpus_ptr(struct task_struct *p)
 	kfree(clear_user_cpus_ptr(p));
 }
 
+/*
+ * Return the copied mask pointer or NULL if user mask not available.
+ */
+struct cpumask *copy_user_cpus_mask(struct task_struct *p,
+				    struct cpumask *user_mask)
+{
+	struct rq_flags rf;
+	struct rq *rq = task_rq_lock(p, &rf);
+	struct cpumask *mask = NULL;
+
+	if (p->user_cpus_ptr) {
+		cpumask_copy(user_mask, p->user_cpus_ptr);
+		mask = user_mask;
+	}
+	task_rq_unlock(rq, p, &rf);
+	return mask;
+}
+
 /*
  * This function is wildly self concurrent; here be dragons.
  *
-- 
2.31.1


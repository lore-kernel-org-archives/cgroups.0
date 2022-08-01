From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/2] sched: Use user_cpus_ptr for saving user provided cpumask in sched_setaffinity()
Date: Mon,  1 Aug 2022 11:41:23 -0400
Message-ID: <20220801154124.2011987-2-longman@redhat.com>
References: <20220801154124.2011987-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659368512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E9xfUKzaMxgAzfihkAM8W5v0xDYFIwnIQQwpHHoC9fQ=;
        b=cYxUrx4el7b/9JThaBgorAA7wBDVnTJhqxBsHUt/RCIAm7nGfjAwhqeYZbXbm/WqzKtQbu
        5c2erYcv3bmEhNBqkdrtj/BCRx0Kxmlot+4g/JVKjnFzxqanqyQ47E0WPhrzF/2aj8jccE
        rVGHXxHa9R9yJyrWPn3a+jHhTFqfTh4=
In-Reply-To: <20220801154124.2011987-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

The user_cpus_ptr field is added by commit b90ca8badbd1 ("sched:
Introduce task_struct::user_cpus_ptr to track requested affinity"). It
is currently used only by arm64 arch due to possible asymmetric cpu
setup. This patch extends its usage to save user provided cpumask when
sched_setaffinity() is called for all arches.

To preserve the existing arm64 use case, a new cpus_affinity_set flag is
added to differentiate if user_cpus_ptr is set up by sched_setaffinity()
or by force_compatible_cpus_allowed_ptr(). user_cpus_ptr
set by sched_setaffinity() has priority and won't be
overwritten by force_compatible_cpus_allowed_ptr() or
relax_compatible_cpus_allowed_ptr().

As a call to sched_setaffinity() will no longer clear user_cpus_ptr
but set it instead, the SCA_USER flag is no longer necessary and can
be removed.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sched.h |  1 +
 kernel/sched/core.c   | 71 +++++++++++++++++++++++++++++++------------
 kernel/sched/sched.h  |  1 -
 3 files changed, 52 insertions(+), 21 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c46f3a63b758..60ae022fa842 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -815,6 +815,7 @@ struct task_struct {
 
 	unsigned int			policy;
 	int				nr_cpus_allowed;
+	int				cpus_affinity_set;
 	const cpumask_t			*cpus_ptr;
 	cpumask_t			*user_cpus_ptr;
 	cpumask_t			cpus_mask;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index da0bf6fe9ecd..7757828c7422 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2607,6 +2607,7 @@ int dup_user_cpus_ptr(struct task_struct *dst, struct task_struct *src,
 		return -ENOMEM;
 
 	cpumask_copy(dst->user_cpus_ptr, src->user_cpus_ptr);
+	dst->cpus_affinity_set = src->cpus_affinity_set;
 	return 0;
 }
 
@@ -2854,7 +2855,6 @@ static int __set_cpus_allowed_ptr_locked(struct task_struct *p,
 	const struct cpumask *cpu_allowed_mask = task_cpu_possible_mask(p);
 	const struct cpumask *cpu_valid_mask = cpu_active_mask;
 	bool kthread = p->flags & PF_KTHREAD;
-	struct cpumask *user_mask = NULL;
 	unsigned int dest_cpu;
 	int ret = 0;
 
@@ -2913,14 +2913,7 @@ static int __set_cpus_allowed_ptr_locked(struct task_struct *p,
 
 	__do_set_cpus_allowed(p, new_mask, flags);
 
-	if (flags & SCA_USER)
-		user_mask = clear_user_cpus_ptr(p);
-
-	ret = affine_move_task(rq, p, rf, dest_cpu, flags);
-
-	kfree(user_mask);
-
-	return ret;
+	return affine_move_task(rq, p, rf, dest_cpu, flags);
 
 out:
 	task_rq_unlock(rq, p, rf);
@@ -2994,19 +2987,24 @@ static int restrict_cpus_allowed_ptr(struct task_struct *p,
 
 	/*
 	 * We're about to butcher the task affinity, so keep track of what
-	 * the user asked for in case we're able to restore it later on.
+	 * the user asked for in case we're able to restore it later on
+	 * unless it has been set before by sched_setaffinity().
 	 */
-	if (user_mask) {
+	if (user_mask && !p->cpus_affinity_set) {
 		cpumask_copy(user_mask, p->cpus_ptr);
 		p->user_cpus_ptr = user_mask;
+		user_mask = NULL;
 	}
 
-	return __set_cpus_allowed_ptr_locked(p, new_mask, 0, rq, &rf);
+	err = __set_cpus_allowed_ptr_locked(p, new_mask, 0, rq, &rf);
 
-err_unlock:
-	task_rq_unlock(rq, p, &rf);
+free_user_mask:
 	kfree(user_mask);
 	return err;
+
+err_unlock:
+	task_rq_unlock(rq, p, &rf);
+	goto free_user_mask;
 }
 
 /*
@@ -3055,7 +3053,7 @@ void force_compatible_cpus_allowed_ptr(struct task_struct *p)
 }
 
 static int
-__sched_setaffinity(struct task_struct *p, const struct cpumask *mask);
+__sched_setaffinity(struct task_struct *p, const struct cpumask *mask, bool save_mask);
 
 /*
  * Restore the affinity of a task @p which was previously restricted by a
@@ -3073,9 +3071,10 @@ void relax_compatible_cpus_allowed_ptr(struct task_struct *p)
 	/*
 	 * Try to restore the old affinity mask. If this fails, then
 	 * we free the mask explicitly to avoid it being inherited across
-	 * a subsequent fork().
+	 * a subsequent fork() unless it is set by sched_setaffinity().
 	 */
-	if (!user_mask || !__sched_setaffinity(p, user_mask))
+	if (!user_mask || !__sched_setaffinity(p, user_mask, false) ||
+	    p->cpus_affinity_set)
 		return;
 
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
@@ -8010,10 +8009,11 @@ int dl_task_check_affinity(struct task_struct *p, const struct cpumask *mask)
 #endif
 
 static int
-__sched_setaffinity(struct task_struct *p, const struct cpumask *mask)
+__sched_setaffinity(struct task_struct *p, const struct cpumask *mask, bool save_mask)
 {
 	int retval;
 	cpumask_var_t cpus_allowed, new_mask;
+	struct cpumask *user_mask = NULL;
 
 	if (!alloc_cpumask_var(&cpus_allowed, GFP_KERNEL))
 		return -ENOMEM;
@@ -8029,8 +8029,38 @@ __sched_setaffinity(struct task_struct *p, const struct cpumask *mask)
 	retval = dl_task_check_affinity(p, new_mask);
 	if (retval)
 		goto out_free_new_mask;
+
+	/*
+	 * Save the user requested mask into user_cpus_ptr
+	 */
+	if (save_mask && !p->user_cpus_ptr) {
+alloc_again:
+		user_mask = kmalloc(cpumask_size(), GFP_KERNEL);
+
+		if (!user_mask) {
+			retval = -ENOMEM;
+			goto out_free_new_mask;
+		}
+	}
+	if (save_mask) {
+		struct rq_flags rf;
+		struct rq *rq = task_rq_lock(p, &rf);
+
+		if (unlikely(!p->user_cpus_ptr && !user_mask)) {
+			task_rq_unlock(rq, p, &rf);
+			goto alloc_again;
+		}
+		if (!p->user_cpus_ptr) {
+			p->user_cpus_ptr = user_mask;
+			user_mask = NULL;
+		}
+
+		cpumask_copy(p->user_cpus_ptr, mask);
+		p->cpus_affinity_set = 1;
+		task_rq_unlock(rq, p, &rf);
+	}
 again:
-	retval = __set_cpus_allowed_ptr(p, new_mask, SCA_CHECK | SCA_USER);
+	retval = __set_cpus_allowed_ptr(p, new_mask, SCA_CHECK);
 	if (retval)
 		goto out_free_new_mask;
 
@@ -8044,6 +8074,7 @@ __sched_setaffinity(struct task_struct *p, const struct cpumask *mask)
 		goto again;
 	}
 
+	kfree(user_mask);
 out_free_new_mask:
 	free_cpumask_var(new_mask);
 out_free_cpus_allowed:
@@ -8087,7 +8118,7 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 	if (retval)
 		goto out_put_task;
 
-	retval = __sched_setaffinity(p, in_mask);
+	retval = __sched_setaffinity(p, in_mask, true);
 out_put_task:
 	put_task_struct(p);
 	return retval;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 47b89a0fc6e5..c9e9731a1a17 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2242,7 +2242,6 @@ extern struct task_struct *pick_next_task_idle(struct rq *rq);
 #define SCA_CHECK		0x01
 #define SCA_MIGRATE_DISABLE	0x02
 #define SCA_MIGRATE_ENABLE	0x04
-#define SCA_USER		0x08
 
 #ifdef CONFIG_SMP
 
-- 
2.31.1


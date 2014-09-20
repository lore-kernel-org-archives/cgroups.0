From: Zefan Li <lizefan@huawei.com>
Subject: Re: Racy manipulation of task_struct->flags in cgroups code causes
 hard to reproduce kernel panics
Date: Sat, 20 Sep 2014 13:55:54 +0800
Message-ID: <541D16EA.70407@huawei.com>
References: <201409192053.IHJ35462.JLOMOSOFFVtQFH@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201409192053.IHJ35462.JLOMOSOFFVtQFH@I-love.SAKURA.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: peterz@infradead.org, mingo@redhat.com, tj@kernel.org, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, fernando_b1@lab.ntt.co.jp

> Then, what made current->flags to unexpectedly preserve PF_USED_MATH flag?
> The user is running cgrulesengd process in order to utilize cpuset cgroup.
> Thus, cpuset_update_task_spread_flag() is called when cgrulesengd process
> writes someone's pid to /cgroup/cpuset/$group/tasks interface.
> 
> cpuset_update_task_spread_flag() is updating other thread's
> "struct task_struct"->flags without exclusion control or atomic
> operations!
> 
> ---------- linux-2.6.32-358.23.2.el6/kernel/cpuset.c ----------
> 300:/*
> 301: * update task's spread flag if cpuset's page/slab spread flag is set
> 302: *
> 303: * Called with callback_mutex/cgroup_mutex held
> 304: */
> 305:static void cpuset_update_task_spread_flag(struct cpuset *cs,
> 306:                                    struct task_struct *tsk)
> 307:{
> 308:    if (is_spread_page(cs))
> 309:            tsk->flags |= PF_SPREAD_PAGE;
> 310:    else
> 311:            tsk->flags &= ~PF_SPREAD_PAGE;
> 312:    if (is_spread_slab(cs))
> 313:            tsk->flags |= PF_SPREAD_SLAB;
> 314:    else
> 315:            tsk->flags &= ~PF_SPREAD_SLAB;
> 316:}

We should make the updating of this flag atomic.

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 0d4e067..2f073db 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -94,12 +94,12 @@ extern int cpuset_slab_spread_node(void);
 
 static inline int cpuset_do_page_mem_spread(void)
 {
-	return current->flags & PF_SPREAD_PAGE;
+	return task_spread_page(current);
 }
 
 static inline int cpuset_do_slab_mem_spread(void)
 {
-	return current->flags & PF_SPREAD_SLAB;
+	return task_spread_slab(current);
 }
 
 extern int current_cpuset_is_being_rebound(void);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5c2c885..1e448a3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1903,8 +1903,6 @@ extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut,
 #define PF_KTHREAD	0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE	0x00400000	/* randomize virtual address space */
 #define PF_SWAPWRITE	0x00800000	/* Allowed to write to swap */
-#define PF_SPREAD_PAGE	0x01000000	/* Spread page cache over cpuset */
-#define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
 #define PF_NO_SETAFFINITY 0x04000000	/* Userland is not allowed to meddle with cpus_allowed */
 #define PF_MCE_EARLY    0x08000000      /* Early kill for mce process policy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
@@ -1958,6 +1956,8 @@ static inline void memalloc_noio_restore(unsigned int flags)
 
 /* Per-process atomic flags. */
 #define PFA_NO_NEW_PRIVS 0x00000001	/* May not gain new privileges. */
+#define PFA_SPREAD_PAGE  0x00000002	/* Spread page cache over cpuset */
+#define PFA_SPREAD_SLAB  0x00000004	/* Spread some slab caches over cpuset */
 
 static inline bool task_no_new_privs(struct task_struct *p)
 {
@@ -1969,6 +1969,36 @@ static inline void task_set_no_new_privs(struct task_struct *p)
 	set_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
 }
 
+static inline bool task_spread_page(struct task_struct *p)
+{
+	return test_bit(PFA_SPREAD_PAGE, &p->atomic_flags);
+}
+
+static inline void task_set_spread_page(struct task_struct *p)
+{
+	set_bit(PFA_SPREAD_PAGE, &p->atomic_flags);
+}
+
+static inline void task_clear_spread_page(struct task_struct *p)
+{
+	clear_bit(PFA_SPREAD_PAGE, &p->atomic_flags);
+}
+
+static inline bool task_spread_slab(struct task_struct *p)
+{
+	return test_bit(PFA_SPREAD_SLAB, &p->atomic_flags);
+}
+
+static inline void task_set_spread_slab(struct task_struct *p)
+{
+	set_bit(PFA_SPREAD_SLAB, &p->atomic_flags);
+}
+
+static inline void task_clear_spread_slab(struct task_struct *p)
+{
+	clear_bit(PFA_SPREAD_SLAB, &p->atomic_flags);
+}
+
 /*
  * task->jobctl flags
  */
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index a37f4ed..1f107c7 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -365,13 +365,14 @@ static void cpuset_update_task_spread_flag(struct cpuset *cs,
 					struct task_struct *tsk)
 {
 	if (is_spread_page(cs))
-		tsk->flags |= PF_SPREAD_PAGE;
+		task_set_spread_page(tsk);
 	else
-		tsk->flags &= ~PF_SPREAD_PAGE;
+		task_clear_spread_page(tsk);
+
 	if (is_spread_slab(cs))
-		tsk->flags |= PF_SPREAD_SLAB;
+		task_set_spread_slab(tsk);
 	else
-		tsk->flags &= ~PF_SPREAD_SLAB;
+		task_clear_spread_slab(tsk);
 }
 
 /*


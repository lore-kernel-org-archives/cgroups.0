From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] late cgroup fixes for v3.17-rc6
Date: Sat, 27 Sep 2014 10:01:08 -0400
Message-ID: <20140927140108.GA24783@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=6yUi22W6/wP8HP15WRPDKvQTLjGAtRhjRHar+GbqPpw=;
        b=cAotNCVmBDcsAPJc8spHalnR+oS6XILKrVCN2cs0HY5SY69+MdEfud/lU9UjA0gp0P
         nV2qSxOU98EeRtdGqRcaWAcUK8DVp8E+Hu0NQ9lREIoMxr2gXTN25bu7HuUhYbjVvw/z
         cbFu0cr8H1smZQHs7gNG08iqtTXI5h55ji14GyzvHmI6z1NWZ4LtTi8TzRHBry3i38ae
         YHhiBWoRbSzkIziVtYIMa3XUMCVN62QzKW62zU7D55xDme9ph1rcO2XO9zzzWCxmZyO2
         cPIHNXd9J0pA7QhHcosw4GQZDCAF90/aQQ4vHrfRDpulF6LlAc220OBH1YK0mIquiMoa
         valA==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

This is quite late but these need to be backported anyway.  This is
the fix for a long-standing cpuset bug which existed from 2009.
cpuset makes use of PF_SPREAD_{PAGE|SLAB} flags to modify the task's
memory allocation behavior according to the settings of the cpuset it
belongs to; unfortunately, when those flags have to be changed, cpuset
did so directly even whlie the target task is running, which is
obviously racy as task->flags may be modified by the task itself at
any time.  This obscure bug manifested as corrupt PF_USED_MATH flag
leading to a weird crash.

The bug is fixed by moving the flag to task->atomic_flags.  The first
two are prepatory ones to help defining atomic_flags accessors and the
third one is the actual fix.

Thanks.

The following changes since commit eb4aec84d6bdf98d00cedb41c18000f7a31e648a:

  cgroup: fix unbalanced locking (2014-09-18 12:32:52 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.17-fixes

for you to fetch changes up to 2ad654bc5e2b211e92f66da1d819e47d79a866f0:

  cpuset: PF_SPREAD_PAGE and PF_SPREAD_SLAB should be atomic flags (2014-09-24 22:16:06 -0400)

----------------------------------------------------------------
Zefan Li (3):
      sched: fix confusing PFA_NO_NEW_PRIVS constant
      sched: add macros to define bitops for task atomic flags
      cpuset: PF_SPREAD_PAGE and PF_SPREAD_SLAB should be atomic flags

 Documentation/cgroups/cpusets.txt |  6 +++---
 include/linux/cpuset.h            |  4 ++--
 include/linux/sched.h             | 38 +++++++++++++++++++++++++-------------
 kernel/cpuset.c                   |  9 +++++----
 mm/slab.c                         |  4 ++--
 scripts/tags.sh                   |  6 ++++++
 6 files changed, 43 insertions(+), 24 deletions(-)

diff --git a/Documentation/cgroups/cpusets.txt b/Documentation/cgroups/cpusets.txt
index 7740038..3c94ff3 100644
--- a/Documentation/cgroups/cpusets.txt
+++ b/Documentation/cgroups/cpusets.txt
@@ -345,14 +345,14 @@ the named feature on.
 The implementation is simple.
 
 Setting the flag 'cpuset.memory_spread_page' turns on a per-process flag
-PF_SPREAD_PAGE for each task that is in that cpuset or subsequently
+PFA_SPREAD_PAGE for each task that is in that cpuset or subsequently
 joins that cpuset.  The page allocation calls for the page cache
-is modified to perform an inline check for this PF_SPREAD_PAGE task
+is modified to perform an inline check for this PFA_SPREAD_PAGE task
 flag, and if set, a call to a new routine cpuset_mem_spread_node()
 returns the node to prefer for the allocation.
 
 Similarly, setting 'cpuset.memory_spread_slab' turns on the flag
-PF_SPREAD_SLAB, and appropriately marked slab caches will allocate
+PFA_SPREAD_SLAB, and appropriately marked slab caches will allocate
 pages from the node returned by cpuset_mem_spread_node().
 
 The cpuset_mem_spread_node() routine is also simple.  It uses the
diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index ade2390..6e39c9b 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -93,12 +93,12 @@ extern int cpuset_slab_spread_node(void);
 
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
index 5c2c885..7b1cafe 100644
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
@@ -1957,17 +1955,31 @@ static inline void memalloc_noio_restore(unsigned int flags)
 }
 
 /* Per-process atomic flags. */
-#define PFA_NO_NEW_PRIVS 0x00000001	/* May not gain new privileges. */
-
-static inline bool task_no_new_privs(struct task_struct *p)
-{
-	return test_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
-}
-
-static inline void task_set_no_new_privs(struct task_struct *p)
-{
-	set_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
-}
+#define PFA_NO_NEW_PRIVS 0	/* May not gain new privileges. */
+#define PFA_SPREAD_PAGE  1      /* Spread page cache over cpuset */
+#define PFA_SPREAD_SLAB  2      /* Spread some slab caches over cpuset */
+
+
+#define TASK_PFA_TEST(name, func)					\
+	static inline bool task_##func(struct task_struct *p)		\
+	{ return test_bit(PFA_##name, &p->atomic_flags); }
+#define TASK_PFA_SET(name, func)					\
+	static inline void task_set_##func(struct task_struct *p)	\
+	{ set_bit(PFA_##name, &p->atomic_flags); }
+#define TASK_PFA_CLEAR(name, func)					\
+	static inline void task_clear_##func(struct task_struct *p)	\
+	{ clear_bit(PFA_##name, &p->atomic_flags); }
+
+TASK_PFA_TEST(NO_NEW_PRIVS, no_new_privs)
+TASK_PFA_SET(NO_NEW_PRIVS, no_new_privs)
+
+TASK_PFA_TEST(SPREAD_PAGE, spread_page)
+TASK_PFA_SET(SPREAD_PAGE, spread_page)
+TASK_PFA_CLEAR(SPREAD_PAGE, spread_page)
+
+TASK_PFA_TEST(SPREAD_SLAB, spread_slab)
+TASK_PFA_SET(SPREAD_SLAB, spread_slab)
+TASK_PFA_CLEAR(SPREAD_SLAB, spread_slab)
 
 /*
  * task->jobctl flags
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 22874d7..52cb04c 100644
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
diff --git a/mm/slab.c b/mm/slab.c
index a467b30..881951e 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2994,7 +2994,7 @@ out:
 
 #ifdef CONFIG_NUMA
 /*
- * Try allocating on another node if PF_SPREAD_SLAB is a mempolicy is set.
+ * Try allocating on another node if PFA_SPREAD_SLAB is a mempolicy is set.
  *
  * If we are in_interrupt, then process context, including cpusets and
  * mempolicy, may not apply and should not be used for allocation policy.
@@ -3226,7 +3226,7 @@ __do_cache_alloc(struct kmem_cache *cache, gfp_t flags)
 {
 	void *objp;
 
-	if (current->mempolicy || unlikely(current->flags & PF_SPREAD_SLAB)) {
+	if (current->mempolicy || cpuset_do_slab_mem_spread()) {
 		objp = alternate_node_alloc(cache, flags);
 		if (objp)
 			goto out;
diff --git a/scripts/tags.sh b/scripts/tags.sh
index cbfd269..293828b 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -197,6 +197,9 @@ exuberant()
 	--regex-c++='/SETPCGFLAG\(([^,)]*).*/SetPageCgroup\1/'		\
 	--regex-c++='/CLEARPCGFLAG\(([^,)]*).*/ClearPageCgroup\1/'	\
 	--regex-c++='/TESTCLEARPCGFLAG\(([^,)]*).*/TestClearPageCgroup\1/' \
+	--regex-c++='/TASK_PFA_TEST\([^,]*,\s*([^)]*)\)/task_\1/'	\
+	--regex-c++='/TASK_PFA_SET\([^,]*,\s*([^)]*)\)/task_set_\1/'	\
+	--regex-c++='/TASK_PFA_CLEAR\([^,]*,\s*([^)]*)\)/task_clear_\1/'\
 	--regex-c='/PCI_OP_READ\((\w*).*[1-4]\)/pci_bus_read_config_\1/' \
 	--regex-c='/PCI_OP_WRITE\((\w*).*[1-4]\)/pci_bus_write_config_\1/' \
 	--regex-c='/DEFINE_(MUTEX|SEMAPHORE|SPINLOCK)\((\w*)/\2/v/'	\
@@ -260,6 +263,9 @@ emacs()
 	--regex='/SETPCGFLAG\(([^,)]*).*/SetPageCgroup\1/'	\
 	--regex='/CLEARPCGFLAG\(([^,)]*).*/ClearPageCgroup\1/'	\
 	--regex='/TESTCLEARPCGFLAG\(([^,)]*).*/TestClearPageCgroup\1/' \
+	--regex='/TASK_PFA_TEST\([^,]*,\s*([^)]*)\)/task_\1/'		\
+	--regex='/TASK_PFA_SET\([^,]*,\s*([^)]*)\)/task_set_\1/'	\
+	--regex='/TASK_PFA_CLEAR\([^,]*,\s*([^)]*)\)/task_clear_\1/'	\
 	--regex='/_PE(\([^,)]*\).*/PEVENT_ERRNO__\1/'		\
 	--regex='/PCI_OP_READ(\([a-z]*[a-z]\).*[1-4])/pci_bus_read_config_\1/' \
 	--regex='/PCI_OP_WRITE(\([a-z]*[a-z]\).*[1-4])/pci_bus_write_config_\1/'\

-- 
tejun

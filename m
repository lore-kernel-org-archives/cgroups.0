From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-4.5-fixes] cpuset: make mm migration asynchronous
Date: Tue, 19 Jan 2016 12:18:41 -0500
Message-ID: <20160119171841.GP3520@mtj.duckdns.org>
References: <56978452.6010606@de.ibm.com>
 <20160114195630.GA3520@mtj.duckdns.org>
 <5698A023.9070703@de.ibm.com>
 <20160115164023.GH3520@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=RHCPIwykw52VMyTydnPB5uVGQRoFhwvqMWOgz9mkL8s=;
        b=xyknf1ccMorrwzF4icCIZoDYWwMWEBXNvcChtIsXpRW9ySizloooG6y8nDLwcgnfQp
         wom92508annsf9+Ua18c9GVj0YUic75OLlshnwQuwV9diE5i6kgyQTiU28Dk7UKl4N4H
         rmKd60l2Ly80uoD9ma/43FIMuVUfUmRXr7kjF2Dg7OVr3WSNLOhpC5WLP/ANU9daQv15
         BBf0gT3fWs8cfOJQb2+JefVTIEIoiNltvvJYigkDmua558fn8n+C21tX0bJpSQPCTuea
         iXvJN5A1fzKaYcTLIla44wbvi2Pajp1cLtDytygDEhLuJEei3lTHZYjmIW5km+oWjf5z
         fQpg==
Content-Disposition: inline
In-Reply-To: <20160115164023.GH3520-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-s390 <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KVM list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

If "cpuset.memory_migrate" is set, when a process is moved from one
cpuset to another with a different memory node mask, pages in used by
the process are migrated to the new set of nodes.  This was performed
synchronously in the ->attach() callback, which is synchronized
against process management.  Recently, the synchronization was changed
from per-process rwsem to global percpu rwsem for simplicity and
optimization.

Combined with the synchronous mm migration, this led to deadlocks
because mm migration could schedule a work item which may in turn try
to create a new worker blocking on the process management lock held
from cgroup process migration path.

This heavy an operation shouldn't be performed synchronously from that
deep inside cgroup migration in the first place.  This patch punts the
actual migration to an ordered workqueue and updates cgroup process
migration and cpuset config update paths to flush the workqueue after
all locks are released.  This way, the operations still seem
synchronous to userland without entangling mm migration with process
management synchronization.  CPU hotplug can also invoke mm migration
but there's no reason for it to wait for mm migrations and thus
doesn't synchronize against their completions.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-and-tested-by: Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v4.4+
---
 include/linux/cpuset.h |    6 ++++
 kernel/cgroup.c        |    2 +
 kernel/cpuset.c        |   71 +++++++++++++++++++++++++++++++++----------------
 3 files changed, 57 insertions(+), 22 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 85a868c..fea160e 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -137,6 +137,8 @@ static inline void set_mems_allowed(nodemask_t nodemask)
 	task_unlock(current);
 }
 
+extern void cpuset_post_attach_flush(void);
+
 #else /* !CONFIG_CPUSETS */
 
 static inline bool cpusets_enabled(void) { return false; }
@@ -243,6 +245,10 @@ static inline bool read_mems_allowed_retry(unsigned int seq)
 	return false;
 }
 
+static inline void cpuset_post_attach_flush(void)
+{
+}
+
 #endif /* !CONFIG_CPUSETS */
 
 #endif /* _LINUX_CPUSET_H */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c03a640..88abd4d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -58,6 +58,7 @@
 #include <linux/kthread.h>
 #include <linux/delay.h>
 #include <linux/atomic.h>
+#include <linux/cpuset.h>
 #include <net/sock.h>
 
 /*
@@ -2739,6 +2740,7 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 out_unlock_threadgroup:
 	percpu_up_write(&cgroup_threadgroup_rwsem);
 	cgroup_kn_unlock(of->kn);
+	cpuset_post_attach_flush();
 	return ret ?: nbytes;
 }
 
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3e945fc..41989ab 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -287,6 +287,8 @@ static struct cpuset top_cpuset = {
 static DEFINE_MUTEX(cpuset_mutex);
 static DEFINE_SPINLOCK(callback_lock);
 
+static struct workqueue_struct *cpuset_migrate_mm_wq;
+
 /*
  * CPU / memory hotplug is handled asynchronously.
  */
@@ -972,31 +974,51 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 }
 
 /*
- * cpuset_migrate_mm
- *
- *    Migrate memory region from one set of nodes to another.
- *
- *    Temporarilly set tasks mems_allowed to target nodes of migration,
- *    so that the migration code can allocate pages on these nodes.
- *
- *    While the mm_struct we are migrating is typically from some
- *    other task, the task_struct mems_allowed that we are hacking
- *    is for our current task, which must allocate new pages for that
- *    migrating memory region.
+ * Migrate memory region from one set of nodes to another.  This is
+ * performed asynchronously as it can be called from process migration path
+ * holding locks involved in process management.  All mm migrations are
+ * performed in the queued order and can be waited for by flushing
+ * cpuset_migrate_mm_wq.
  */
 
+struct cpuset_migrate_mm_work {
+	struct work_struct	work;
+	struct mm_struct	*mm;
+	nodemask_t		from;
+	nodemask_t		to;
+};
+
+static void cpuset_migrate_mm_workfn(struct work_struct *work)
+{
+	struct cpuset_migrate_mm_work *mwork =
+		container_of(work, struct cpuset_migrate_mm_work, work);
+
+	/* on a wq worker, no need to worry about %current's mems_allowed */
+	do_migrate_pages(mwork->mm, &mwork->from, &mwork->to, MPOL_MF_MOVE_ALL);
+	mmput(mwork->mm);
+	kfree(mwork);
+}
+
 static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
 							const nodemask_t *to)
 {
-	struct task_struct *tsk = current;
-
-	tsk->mems_allowed = *to;
+	struct cpuset_migrate_mm_work *mwork;
 
-	do_migrate_pages(mm, from, to, MPOL_MF_MOVE_ALL);
+	mwork = kzalloc(sizeof(*mwork), GFP_KERNEL);
+	if (mwork) {
+		mwork->mm = mm;
+		mwork->from = *from;
+		mwork->to = *to;
+		INIT_WORK(&mwork->work, cpuset_migrate_mm_workfn);
+		queue_work(cpuset_migrate_mm_wq, &mwork->work);
+	} else {
+		mmput(mm);
+	}
+}
 
-	rcu_read_lock();
-	guarantee_online_mems(task_cs(tsk), &tsk->mems_allowed);
-	rcu_read_unlock();
+void cpuset_post_attach_flush(void)
+{
+	flush_workqueue(cpuset_migrate_mm_wq);
 }
 
 /*
@@ -1097,7 +1119,8 @@ static void update_tasks_nodemask(struct cpuset *cs)
 		mpol_rebind_mm(mm, &cs->mems_allowed);
 		if (migrate)
 			cpuset_migrate_mm(mm, &cs->old_mems_allowed, &newmems);
-		mmput(mm);
+		else
+			mmput(mm);
 	}
 	css_task_iter_end(&it);
 
@@ -1545,11 +1568,11 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 			 * @old_mems_allowed is the right nodesets that we
 			 * migrate mm from.
 			 */
-			if (is_memory_migrate(cs)) {
+			if (is_memory_migrate(cs))
 				cpuset_migrate_mm(mm, &oldcs->old_mems_allowed,
 						  &cpuset_attach_nodemask_to);
-			}
-			mmput(mm);
+			else
+				mmput(mm);
 		}
 	}
 
@@ -1714,6 +1737,7 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 	mutex_unlock(&cpuset_mutex);
 	kernfs_unbreak_active_protection(of->kn);
 	css_put(&cs->css);
+	flush_workqueue(cpuset_migrate_mm_wq);
 	return retval ?: nbytes;
 }
 
@@ -2359,6 +2383,9 @@ void __init cpuset_init_smp(void)
 	top_cpuset.effective_mems = node_states[N_MEMORY];
 
 	register_hotmemory_notifier(&cpuset_track_online_nodes_nb);
+
+	cpuset_migrate_mm_wq = alloc_ordered_workqueue("cpuset_migrate_mm", 0);
+	BUG_ON(!cpuset_migrate_mm_wq);
 }
 
 /**

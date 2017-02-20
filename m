From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 12/19] kernel: convert css_set.refcount from atomic_t to refcount_t
Date: Mon, 20 Feb 2017 12:19:01 +0200
Message-ID: <1487585948-6401-13-git-send-email-elena.reshetova@intel.com>
References: <1487585948-6401-1-git-send-email-elena.reshetova@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487585948-6401-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, tj@kernel.org, mingo@redhat.com, hannes@cmpxchg.org, lizefan@huawei.com, acme@kernel.org, alexander.shishkin@linux.intel.com, paul@paul-moore.com, eparis@redhat.com, akpm@linux-foundation.org, arnd@arndb.de, luto@kernel.org, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 include/linux/cgroup-defs.h     |  3 ++-
 kernel/cgroup/cgroup-internal.h | 10 +++++++---
 kernel/cgroup/cgroup-v1.c       |  4 ++--
 kernel/cgroup/cgroup.c          |  8 ++++----
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 3c02404..e2f4b31 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -13,6 +13,7 @@
 #include <linux/wait.h>
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
+#include <linux/refcount.h>
 #include <linux/percpu-refcount.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/workqueue.h>
@@ -156,7 +157,7 @@ struct css_set {
 	struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
 
 	/* reference count */
-	atomic_t refcount;
+	refcount_t refcount;
 
 	/* the default cgroup associated with this css_set */
 	struct cgroup *dfl_cgrp;
diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 9203bfb..22d87ca 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -5,6 +5,7 @@
 #include <linux/kernfs.h>
 #include <linux/workqueue.h>
 #include <linux/list.h>
+#include <linux/refcount.h>
 
 /*
  * A cgroup can be associated with multiple css_sets as different tasks may
@@ -134,10 +135,13 @@ static inline void put_css_set(struct css_set *cset)
 	 * can see it. Similar to atomic_dec_and_lock(), but for an
 	 * rwlock
 	 */
-	if (atomic_add_unless(&cset->refcount, -1, 1))
+	spin_lock_irqsave(&css_set_lock, flags);
+	if (refcount_read(&cset->refcount) != 1) {
+		WARN_ON(refcount_dec_and_test(&cset->refcount));
+		spin_unlock_irqrestore(&css_set_lock, flags);
 		return;
+	}
 
-	spin_lock_irqsave(&css_set_lock, flags);
 	put_css_set_locked(cset);
 	spin_unlock_irqrestore(&css_set_lock, flags);
 }
@@ -147,7 +151,7 @@ static inline void put_css_set(struct css_set *cset)
  */
 static inline void get_css_set(struct css_set *cset)
 {
-	atomic_inc(&cset->refcount);
+	refcount_inc(&cset->refcount);
 }
 
 bool cgroup_ssid_enabled(int ssid);
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index fc34bcf..9269179 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -343,7 +343,7 @@ static int cgroup_task_count(const struct cgroup *cgrp)
 
 	spin_lock_irq(&css_set_lock);
 	list_for_each_entry(link, &cgrp->cset_links, cset_link)
-		count += atomic_read(&link->cset->refcount);
+		count += refcount_read(&link->cset->refcount);
 	spin_unlock_irq(&css_set_lock);
 	return count;
 }
@@ -1283,7 +1283,7 @@ static u64 current_css_set_refcount_read(struct cgroup_subsys_state *css,
 	u64 count;
 
 	rcu_read_lock();
-	count = atomic_read(&task_css_set(current)->refcount);
+	count = refcount_read(&task_css_set(current)->refcount);
 	rcu_read_unlock();
 	return count;
 }
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 5b94c79..59aba84 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -553,7 +553,7 @@ EXPORT_SYMBOL_GPL(of_css);
  * haven't been created.
  */
 struct css_set init_css_set = {
-	.refcount		= ATOMIC_INIT(1),
+	.refcount		= REFCOUNT_INIT(1),
 	.tasks			= LIST_HEAD_INIT(init_css_set.tasks),
 	.mg_tasks		= LIST_HEAD_INIT(init_css_set.mg_tasks),
 	.task_iters		= LIST_HEAD_INIT(init_css_set.task_iters),
@@ -723,7 +723,7 @@ void put_css_set_locked(struct css_set *cset)
 
 	lockdep_assert_held(&css_set_lock);
 
-	if (!atomic_dec_and_test(&cset->refcount))
+	if (!refcount_dec_and_test(&cset->refcount))
 		return;
 
 	/* This css_set is dead. unlink it and release cgroup and css refs */
@@ -976,7 +976,7 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 		return NULL;
 	}
 
-	atomic_set(&cset->refcount, 1);
+	refcount_set(&cset->refcount, 1);
 	INIT_LIST_HEAD(&cset->tasks);
 	INIT_LIST_HEAD(&cset->mg_tasks);
 	INIT_LIST_HEAD(&cset->task_iters);
@@ -5064,4 +5064,4 @@ int cgroup_bpf_update(struct cgroup *cgrp, struct bpf_prog *prog,
 	mutex_unlock(&cgroup_mutex);
 	return ret;
 }
-#endif /* CONFIG_CGROUP_BPF */
+#endif /* CONFIG_CGROUP_BPF */
\ No newline at end of file
-- 
2.7.4


From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [RFC v2 1/5] cgroup: add cgroup v2 interfaces to migrate kernel threads
Date: Wed,  5 Jun 2019 09:36:46 -0400
Message-ID: <20190605133650.28545-2-daniel.m.jordan@oracle.com>
References: <20190605133650.28545-1-daniel.m.jordan@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=u+zLCba4ifvorqHECxdb8NWOVORyLACPhu1rUxGfaiU=;
 b=04/ccSPIDB9rw0yaqtcHi0KxfYmVhroln6GrxIIJzj+KGMwFDFX7hLTbB5o3fTLxBF89
 f6L2rcGShr+HLDMtx402CIThkjTlkqOfuo5U4Vd+MJrso7BezPsVTOmqkth7JJQ+RTEc
 kb14qh1piCluKWghlyGA2hLFa4230l30Vnc3+2m6xnNZIVg07MSAiWxocE7bA/4j0m0+
 TK9uMGn+1S+nIxB5mvY6N/WRTOKYBwl3FYzT/tWQhVUECUikgTVXITWKP/BEzEeEU74+
 6ZJYd4KTUVHwSCKtYk7FLDVi+4/BwJsFLksq3zUNl7MKDZf0qHnUIp/9vO+eJvVWqjYF RA== 
In-Reply-To: <20190605133650.28545-1-daniel.m.jordan@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org, jiangshanlai@gmail.com, lizefan@huawei.com, tj@kernel.org
Cc: bsd@redhat.com, dan.j.williams@intel.com, daniel.m.jordan@oracle.com, dave.hansen@intel.com, juri.lelli@redhat.com, mhocko@kernel.org, peterz@infradead.org, steven.sistare@oracle.com, tglx@linutronix.de, tom.hromatka@oracle.com, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

Prepare for cgroup aware workqueues by introducing cgroup_attach_kthread
and a helper cgroup_attach_kthread_to_dfl_root.

A workqueue worker will always migrate itself, so for now use @current
in the interfaces to avoid handling task references.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 include/linux/cgroup.h |  6 ++++++
 kernel/cgroup/cgroup.c | 48 +++++++++++++++++++++++++++++++++++++-----
 2 files changed, 49 insertions(+), 5 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 81f58b4a5418..ad78784e3692 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -103,6 +103,7 @@ struct cgroup_subsys_state *css_tryget_online_from_dir(struct dentry *dentry,
 struct cgroup *cgroup_get_from_path(const char *path);
 struct cgroup *cgroup_get_from_fd(int fd);
 
+int cgroup_attach_kthread(struct cgroup *dst_cgrp);
 int cgroup_attach_task_all(struct task_struct *from, struct task_struct *);
 int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from);
 
@@ -530,6 +531,11 @@ static inline struct cgroup *task_dfl_cgroup(struct task_struct *task)
 	return task_css_set(task)->dfl_cgrp;
 }
 
+static inline int cgroup_attach_kthread_to_dfl_root(void)
+{
+	return cgroup_attach_kthread(&cgrp_dfl_root.cgrp);
+}
+
 static inline struct cgroup *cgroup_parent(struct cgroup *cgrp)
 {
 	struct cgroup_subsys_state *parent_css = cgrp->self.parent;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 3f2b4bde0f9c..bc8d6a2e529f 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2771,21 +2771,59 @@ struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup)
 	return tsk;
 }
 
-void cgroup_procs_write_finish(struct task_struct *task)
-	__releases(&cgroup_threadgroup_rwsem)
+static void __cgroup_procs_write_finish(struct task_struct *task)
 {
 	struct cgroup_subsys *ss;
 	int ssid;
 
-	/* release reference from cgroup_procs_write_start() */
-	put_task_struct(task);
+	lockdep_assert_held(&cgroup_mutex);
 
-	percpu_up_write(&cgroup_threadgroup_rwsem);
 	for_each_subsys(ss, ssid)
 		if (ss->post_attach)
 			ss->post_attach();
 }
 
+void cgroup_procs_write_finish(struct task_struct *task)
+	__releases(&cgroup_threadgroup_rwsem)
+{
+	lockdep_assert_held(&cgroup_mutex);
+
+	/* release reference from cgroup_procs_write_start() */
+	put_task_struct(task);
+
+	percpu_up_write(&cgroup_threadgroup_rwsem);
+	__cgroup_procs_write_finish(task);
+}
+
+/**
+ * cgroup_attach_kthread - attach the current kernel thread to a cgroup
+ * @dst_cgrp: the cgroup to attach to
+ *
+ * The caller is responsible for ensuring @dst_cgrp is valid until this
+ * function returns.
+ *
+ * Return: 0 on success or negative error code.
+ */
+int cgroup_attach_kthread(struct cgroup *dst_cgrp)
+{
+	int ret;
+
+	if (WARN_ON_ONCE(!(current->flags & PF_KTHREAD)))
+		return -EINVAL;
+
+	mutex_lock(&cgroup_mutex);
+
+	percpu_down_write(&cgroup_threadgroup_rwsem);
+	ret = cgroup_attach_task(dst_cgrp, current, false);
+	percpu_up_write(&cgroup_threadgroup_rwsem);
+
+	__cgroup_procs_write_finish(current);
+
+	mutex_unlock(&cgroup_mutex);
+
+	return ret;
+}
+
 static void cgroup_print_ss_mask(struct seq_file *seq, u16 ss_mask)
 {
 	struct cgroup_subsys *ss;
-- 
2.21.0


From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 3/8] cgroup: implement cgroup_from_id()
Date: Wed, 31 Jul 2013 09:51:31 +0800
Message-ID: <51F86DA3.6050406@huawei.com>
References: <51F86D69.2030907@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51F86D69.2030907-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

This will be used as a replacement for css_lookup().

There's a difference with cgroup id and css id. cgroup id starts with 0,
while css id starts with 1.

v4:
- also check if cggroup_mutex is held.
- make it an inline function.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 include/linux/cgroup.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 8c107e9..4ef8452 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -720,6 +720,24 @@ static inline struct cgroup* task_cgroup(struct task_struct *task,
 	return task_subsys_state(task, subsys_id)->cgroup;
 }
 
+/**
+ * cgroup_from_id - lookup cgroup by id
+ * @ss: cgroup subsys to be looked into
+ * @id: the cgroup id
+ *
+ * Returns the cgroup if there's valid one with @id, otherwise returns NULL.
+ * Should be called under rcu_read_lock().
+ */
+static inline struct cgroup *cgroup_from_id(struct cgroup_subsys *ss, int id)
+{
+#ifdef CONFIG_PROVE_RCU
+	rcu_lockdep_assert(rcu_read_lock_held() ||
+			   lockdep_is_held(&cgroup_mutex),
+			   "cgroup_from_id() needs proper protection");
+#endif
+	return idr_find(&ss->root->cgroup_idr, id);
+}
+
 struct cgroup *cgroup_next_sibling(struct cgroup *pos);
 
 /**
-- 
1.8.0.2

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [RFC][PATCH 1/3] add cgroup_xxxx_disabled functions
Date: Wed, 23 Nov 2011 17:31:33 +0900
Message-ID: <20111123173133.e7ba96df.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111123172840.acd53c41.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111123172840.acd53c41.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org" <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From 1a9e228c2a28bb918ea8cb9aecc11fd80444acaa Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Date: Wed, 23 Nov 2011 15:36:22 +0900
Subject: [PATCH 1/3] add cgroup_xxxx_disabled() functions

Now, memory cgroup uses mem_cgroup_disabled() for checking
cgroup is disabled or not. This patch adds cgroup_xxxx_disabled()
functions for all subsys. After all works, mem_cgroup_disabled()
can be disappeared.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 include/linux/cgroup.h        |   18 ++++++++++++++++++
 include/linux/cgroup_subsys.h |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 1b7f9d5..9eaa6fe 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -526,6 +526,16 @@ struct cgroup_subsys {
 #include <linux/cgroup_subsys.h>
 #undef SUBSYS
 
+#define SUBSYS(_x)\
+	static inline bool cgroup_ ## _x ## _disabled(void){\
+		return _x ## _subsys.disabled;}
+#define SUBSYS_UNDEFINED(_x)\
+	static inline bool cgroup_ ## _x ## _disabled(void){\
+		return true;}
+#include <linux/cgroup_subsys.h>
+#undef SUBSYS
+#undef SUBSYS_UNDEFINED
+
 static inline struct cgroup_subsys_state *cgroup_subsys_state(
 	struct cgroup *cgrp, int subsys_id)
 {
@@ -655,6 +665,14 @@ static inline int cgroup_attach_task_current_cg(struct task_struct *t)
 	return 0;
 }
 
+#define SUBSYS(_x)
+#define SUBSYS_UNDEFINED(_x)\
+	static inline bool cgroup_ ## _x ## _disabled(void){\
+		return true;}
+#include <linux/cgroup_subsys.h>
+#undef SUBSYS
+#undef SUBSYS_UNDEFINED
+
 #endif /* !CONFIG_CGROUPS */
 
 #endif /* _LINUX_CGROUP_H */
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index ac663c1..f3eaee8 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -9,58 +9,98 @@
 
 #ifdef CONFIG_CPUSETS
 SUBSYS(cpuset)
+#else
+#ifdef SUBSYS_DEFINED
+SUBSYS_UNDEFINED(cpuset)
+#endif
 #endif
 
 /* */
 
 #ifdef CONFIG_CGROUP_DEBUG
 SUBSYS(debug)
+#else
+#ifdef SUBSYS_UNDEFINED
+SUBSYS_UNDEFINED(debug)
+#endif
 #endif
 
 /* */
 
 #ifdef CONFIG_CGROUP_SCHED
 SUBSYS(cpu_cgroup)
+#else
+#ifdef SUBSYS_UNDEFINED
+SUBSYS_UNDEFINED(cpu_cgroup)
+#endif
 #endif
 
 /* */
 
 #ifdef CONFIG_CGROUP_CPUACCT
 SUBSYS(cpuacct)
+#else
+#ifdef SUBSYS_UNDEFINED
+SUBSYS_UNDEFINED(cpuacct)
+#endif
 #endif
 
 /* */
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 SUBSYS(mem_cgroup)
+#else
+#ifdef SUBSYS_UNDEFINED
+SUBSYS_UNDEFINED(mem_cgroup)
+#endif
 #endif
 
 /* */
 
 #ifdef CONFIG_CGROUP_DEVICE
 SUBSYS(devices)
+#else
+#ifdef SUBSYS_UNDEFINED
+SUBSYS_UNDEFINED(devices)
+#endif
 #endif
 
 /* */
 
 #ifdef CONFIG_CGROUP_FREEZER
 SUBSYS(freezer)
+#else
+#ifdef SUBSYS_UNDEFINED
+SUBSYS_UNDEFINED(freezer)
+#endif
 #endif
 
 /* */
 
 #ifdef CONFIG_NET_CLS_CGROUP
 SUBSYS(net_cls)
+#else
+#ifdef SUBSYS_DEFINED
+SUBSYS_UNDEFINED(net_cls)
+#endif
 #endif
 
 /* */
 
 #ifdef CONFIG_BLK_CGROUP
 SUBSYS(blkio)
+#else
+#ifdef SUBSYS_UNDEFINED
+SUBSYS_UNDEFINED(blkio)
+#endif
 #endif
 
 #ifdef CONFIG_CGROUP_PERF
 SUBSYS(perf)
+#else
+#ifdef SUBSYS_UNDEFINED
+SUBSYS_UNDEFINED(perf)
+#endif
 #endif
 
 /* */
-- 
1.7.4.1


--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [RFC][PATCH 2/3] use static_branch for cgroup_xxxx_disabled
Date: Wed, 23 Nov 2011 17:32:50 +0900
Message-ID: <20111123173250.97880e5f.kamezawa.hiroyu@jp.fujitsu.com>
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

From 7eae9a2735bf8df8a7e12f10dd7c27e729760196 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Date: Wed, 23 Nov 2011 15:53:18 +0900
Subject: [PATCH 2/3] use static_branch for cgroup_xxx_disabled

The behavior of cgroup_xxx_disable is determined at boot.
Then, using static_brach() will allow us binary patching rather
than checking global variable.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 include/linux/cgroup.h |    8 ++++++++
 kernel/cgroup.c        |   22 +++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 9eaa6fe..511cb6a 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -16,6 +16,7 @@
 #include <linux/prio_heap.h>
 #include <linux/rwsem.h>
 #include <linux/idr.h>
+#include <linux/jump_label.h>
 
 #ifdef CONFIG_CGROUPS
 
@@ -526,9 +527,16 @@ struct cgroup_subsys {
 #include <linux/cgroup_subsys.h>
 #undef SUBSYS
 
+#ifdef CONFIG_JUMP_LABEL
+#define SUBSYS(_x)\
+	extern struct jump_label_key cgroup_ ## _x ## _disabled_key;\
+	static inline bool cgroup_ ## _x ## _disabled(void){\
+		return static_branch(&cgroup_ ## _x ## _disabled_key);}
+#else
 #define SUBSYS(_x)\
 	static inline bool cgroup_ ## _x ## _disabled(void){\
 		return _x ## _subsys.disabled;}
+#endif
 #define SUBSYS_UNDEFINED(_x)\
 	static inline bool cgroup_ ## _x ## _disabled(void){\
 		return true;}
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d9d5648..28d4430 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -75,7 +75,7 @@ static DEFINE_MUTEX(cgroup_mutex);
 static struct cgroup_subsys *subsys[CGROUP_SUBSYS_COUNT] = {
 #include <linux/cgroup_subsys.h>
 };
-
+#undef SUBSYS
 #define MAX_CGROUP_ROOT_NAMELEN 64
 
 /*
@@ -4776,6 +4776,25 @@ static void cgroup_release_agent(struct work_struct *work)
 	raw_spin_unlock(&release_list_lock);
 	mutex_unlock(&cgroup_mutex);
 }
+#ifdef CONFIG_JUMP_LABEL
+#define SUBSYS(_x)\
+	struct jump_label_key cgroup_ ## _x ## _disable_key;
+#include <linux/cgroup_subsys.h>
+#undef SUBSYS
+
+static void cgroup_subsys_disable(void)
+{
+#define SUBSYS(_x)\
+	if ( _x ## _subsys.disabled)\
+		jump_label_inc(&cgroup_ ## _x ## _disable_key);
+#include <linux/cgroup_subsys.h>
+#undef SUBSYS
+}
+#else
+static void cgroup_subsys_disable(void)
+{
+}
+#endif
 
 static int __init cgroup_disable(char *str)
 {
@@ -4800,6 +4819,7 @@ static int __init cgroup_disable(char *str)
 			}
 		}
 	}
+	cgroup_subsys_disable();
 	return 1;
 }
 __setup("cgroup_disable=", cgroup_disable);
-- 
1.7.4.1


--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

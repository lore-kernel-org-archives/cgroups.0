From: yongw.pur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH v1] mm: Add configuration to control whether vmpressure notifier is enabled
Date: Fri, 13 Aug 2021 04:57:50 -0700
Message-ID: <1628855870-5070-1-git-send-email-wang.yong12@zte.com.cn>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=HzU+YACWUeocMvFytTKfHrI9Kb6Qo/A9oD03PRz3Uos=;
        b=YG90DA/OTxozaS97az5Tx7aoGIBC36bIbAMwhl/dXRHCSRd4n4Z043vx4hSKb8weOf
         kUW9ge7rQsJ+b1H66WqDyCUUjchjo6lraPrULNJ1IVvTOszKlLAagwoBFxuoQFjnsTCU
         a+GSm17rCJGQhwbQztpGqbUuDyhe8iFQWAWCx1jNghwKmchZLiRvdJPu1f9dERSbjPP7
         Djk4w+trvmZZVwrRkLa5P4K7fbgoU4wMepZ3liPwJZuST89Xst7Cnx3/YCCWdz3kTmLO
         t4edgRsQ0PkABVOHDK1nGowD+xKEezgGNTmQWYWM+/BpZO7ylsQ6iHnus0nGtICSjZKS
         igcQ==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sh_def-9Onoh4P/yGk@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org

From: wangyong <wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

Inspired by PSI features, vmpressure inotifier function should also be
configured to decide whether it is used, because it is an independent
feature which notifies the user of memory pressure.

Since the vmpressure interface is used in kernel common code, for
users who do not use the vmpressure function, there will be
additional overhead.

So we add configuration to control whether vmpressure notifier is
enabled, and provide a boot parameter to use use vmpressure notifier
flexibly

Signed-off-by: wangyong <wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v1/memory.rst  |  3 ++-
 Documentation/admin-guide/kernel-parameters.txt |  3 +++
 include/linux/memcontrol.h                      |  2 ++
 include/linux/vmpressure.h                      |  7 +++++--
 init/Kconfig                                    | 20 +++++++++++++++++++
 mm/Makefile                                     |  3 ++-
 mm/memcontrol.c                                 |  7 ++++++-
 mm/vmpressure.c                                 | 26 +++++++++++++++++++++++++
 8 files changed, 66 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 41191b5..967418a 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -388,6 +388,7 @@ a. Enable CONFIG_CGROUPS
 b. Enable CONFIG_MEMCG
 c. Enable CONFIG_MEMCG_SWAP (to use swap extension)
 d. Enable CONFIG_MEMCG_KMEM (to use kmem extension)
+e. Enable CONFIG_MEMCG_VMPRESSURE (to use vmpressure extension)
 
 3.1. Prepare the cgroups (see cgroups.txt, Why are cgroups needed?)
 -------------------------------------------------------------------
@@ -855,7 +856,7 @@ At reading, current status of OOM is shown.
           The number of processes belonging to this cgroup killed by any
           kind of OOM killer.
 
-11. Memory Pressure
+11. Memory Pressure (CONFIG_MEMCG_VMPRESSURE)
 ===================
 
 The pressure level notifications can be used to monitor the memory
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 4042a82..d119fb8 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6158,6 +6158,9 @@
 	vmpoff=		[KNL,S390] Perform z/VM CP command after power off.
 			Format: <command>
 
+	vmpressure=	[KNL] Enable or disable vmpressure notifier.
+			Format: <bool>
+
 	vsyscall=	[X86-64]
 			Controls the behavior of vsyscalls (i.e. calls to
 			fixed addresses of 0xffffffffff600x00 from legacy
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0ff1464..b201d8e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -257,8 +257,10 @@ struct mem_cgroup {
 
 	unsigned long soft_limit;
 
+#ifdef CONFIG_MEMCG_VMPRESSURE
 	/* vmpressure notifications */
 	struct vmpressure vmpressure;
+#endif
 
 	/*
 	 * Should the OOM killer kill all belonging tasks, had it kill one?
diff --git a/include/linux/vmpressure.h b/include/linux/vmpressure.h
index 6a2f51e..dcae02e 100644
--- a/include/linux/vmpressure.h
+++ b/include/linux/vmpressure.h
@@ -29,7 +29,8 @@ struct vmpressure {
 
 struct mem_cgroup;
 
-#ifdef CONFIG_MEMCG
+#ifdef CONFIG_MEMCG_VMPRESSURE
+extern bool vmpressure_enable;
 extern void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
 		       unsigned long scanned, unsigned long reclaimed);
 extern void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int prio);
@@ -48,5 +49,7 @@ static inline void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
 			      unsigned long scanned, unsigned long reclaimed) {}
 static inline void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg,
 				   int prio) {}
-#endif /* CONFIG_MEMCG */
+static inline void vmpressure_init(struct vmpressure *vmpr) {}
+static inline void vmpressure_cleanup(struct vmpressure *vmpr) {}
+#endif /* CONFIG_MEMCG_PRESSURE */
 #endif /* __LINUX_VMPRESSURE_H */
diff --git a/init/Kconfig b/init/Kconfig
index 71a028d..d3afeb2 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -948,6 +948,26 @@ config MEMCG_KMEM
 	depends on MEMCG && !SLOB
 	default y
 
+config MEMCG_VMPRESSURE
+	bool "Memory pressure notifier"
+	depends on MEMCG
+	default y
+	help
+	  Vmpressure extension is used to monitor the memory allocation cost.
+	  The pressure level can be set according to the use scenario and
+	  application will be notified through eventfd when memory pressure is at
+	  the specific level (or higher).
+
+config VMPRESSURE_DEFAULT_DISABLED
+	bool "Require boot parameter to enable memory pressure notifier"
+	depends on MEMCG_VMPRESSURE
+	default n
+	help
+	  If set, memory pressure notifier will be disabled  but can be
+	  enabled through passing vmpressure=1 on the kernel commandline
+	  during boot.
+	  For those who want to use memory pressure notifier flexibly.
+
 config BLK_CGROUP
 	bool "IO controller"
 	depends on BLOCK
diff --git a/mm/Makefile b/mm/Makefile
index 970604e..e4f99c1 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -92,7 +92,8 @@ obj-$(CONFIG_MEMTEST)		+= memtest.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
-obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
+obj-$(CONFIG_MEMCG) += memcontrol.o
+obj-$(CONFIG_MEMCG_VMPRESSURE) += vmpressure.o
 obj-$(CONFIG_MEMCG_SWAP) += swap_cgroup.o
 obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
 obj-$(CONFIG_GUP_TEST) += gup_test.o
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3e7c205..ee060ae2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -248,6 +248,7 @@ static inline bool should_force_charge(void)
 		(current->flags & PF_EXITING);
 }
 
+#ifdef CONFIG_MEMCG_VMPRESSURE
 /* Some nice accessors for the vmpressure. */
 struct vmpressure *memcg_to_vmpressure(struct mem_cgroup *memcg)
 {
@@ -260,6 +261,7 @@ struct mem_cgroup *vmpressure_to_memcg(struct vmpressure *vmpr)
 {
 	return container_of(vmpr, struct mem_cgroup, vmpressure);
 }
+#endif
 
 #ifdef CONFIG_MEMCG_KMEM
 extern spinlock_t css_set_lock;
@@ -4794,9 +4796,12 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 	} else if (!strcmp(name, "memory.oom_control")) {
 		event->register_event = mem_cgroup_oom_register_event;
 		event->unregister_event = mem_cgroup_oom_unregister_event;
-	} else if (!strcmp(name, "memory.pressure_level")) {
+#ifdef CONFIG_MEMCG_VMPRESSURE
+	} else if (vmpressure_enable &&
+		   !strcmp(name, "memory.pressure_level")) {
 		event->register_event = vmpressure_register_event;
 		event->unregister_event = vmpressure_unregister_event;
+#endif
 	} else if (!strcmp(name, "memory.memsw.usage_in_bytes")) {
 		event->register_event = memsw_cgroup_usage_register_event;
 		event->unregister_event = memsw_cgroup_usage_unregister_event;
diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index 76518e4..b0d4358 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -67,6 +67,19 @@ static const unsigned int vmpressure_level_critical = 95;
  */
 static const unsigned int vmpressure_level_critical_prio = ilog2(100 / 10);
 
+DEFINE_STATIC_KEY_FALSE(vmpressure_disabled);
+#ifdef CONFIG_VMPRESSURE_DEFAULT_DISABLED
+bool vmpressure_enable;
+#else
+bool vmpressure_enable = true;
+#endif
+static int __init setup_vmpressure(char *str)
+{
+	return kstrtobool(str, &vmpressure_enable) == 0;
+}
+__setup("vmpressure=", setup_vmpressure);
+
+
 static struct vmpressure *work_to_vmpressure(struct work_struct *work)
 {
 	return container_of(work, struct vmpressure, work);
@@ -246,6 +259,9 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
 
 	vmpr = memcg_to_vmpressure(memcg);
 
+	if (static_branch_likely(&vmpressure_disabled))
+		return;
+
 	/*
 	 * Here we only want to account pressure that userland is able to
 	 * help us with. For example, suppose that DMA zone is under
@@ -326,6 +342,8 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
  */
 void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int prio)
 {
+	if (static_branch_likely(&vmpressure_disabled))
+		return;
 	/*
 	 * We only use prio for accounting critical level. For more info
 	 * see comment for vmpressure_level_critical_prio variable above.
@@ -450,6 +468,11 @@ void vmpressure_unregister_event(struct mem_cgroup *memcg,
  */
 void vmpressure_init(struct vmpressure *vmpr)
 {
+	if (!vmpressure_enable) {
+		static_branch_enable(&vmpressure_disabled);
+		return;
+	}
+
 	spin_lock_init(&vmpr->sr_lock);
 	mutex_init(&vmpr->events_lock);
 	INIT_LIST_HEAD(&vmpr->events);
@@ -465,6 +488,9 @@ void vmpressure_init(struct vmpressure *vmpr)
  */
 void vmpressure_cleanup(struct vmpressure *vmpr)
 {
+
+	if (static_branch_likely(&vmpressure_disabled))
+		return;
 	/*
 	 * Make sure there is no pending work before eventfd infrastructure
 	 * goes away.
-- 
2.7.4


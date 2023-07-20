From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 7/8] memcg: add sysctl and config option to control memory recharging
Date: Thu, 20 Jul 2023 07:08:24 +0000
Message-ID: <20230720070825.992023-8-yosryahmed@google.com>
References: <20230720070825.992023-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689836921; x=1692428921;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=n6O0Lt5KhyslMSHzCGrHaCXx7KAwNPu5E55KNetzzTM=;
        b=sV87N/HxxcZHHL1alJO5nBf8HzjYMdw6nkcR38Ddq2rUuAf28cTRr0rb709fkiRMW+
         qEy3FdhFn01ikwkfx7y9qLguXlaMHGLFmuRtJXH+L+mW9RyHbcOJWlAUGrGs6aAu/INw
         41Y2qTn8C7MjL6RvRw/y0YgIGxiJWL68zL7cWNRAYxyzZ5Cms/cFb5dUzlTJ6iCOM/ec
         43odK5EQY91sLY+01W8AhKo4cVLmfc3JuvWr3teNDoKfkk1Lyj7dpYXltbO4KTOFr6c4
         DheP8D0OnAwjx0EXPzUp5uV1Ui6HMxgha12C+iK56/iEaIj2+ON6C0S7v2ijUdptonk9
         M9ZQ==
In-Reply-To: <20230720070825.992023-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Add a sysctl to enable/disable memory recharging for offline memcgs. Add
a config option to control whether or not it is enabled by default.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/memcontrol.h |  2 ++
 kernel/sysctl.c            | 11 +++++++++++
 mm/Kconfig                 | 12 ++++++++++++
 mm/memcontrol.c            |  9 ++++++++-
 4 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 59b653d4a76e..ae9f09ee90cb 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -60,6 +60,8 @@ struct mem_cgroup_reclaim_cookie {
 
 #ifdef CONFIG_MEMCG
 
+extern int sysctl_recharge_offline_memcgs;
+
 #define MEM_CGROUP_ID_SHIFT	16
 #define MEM_CGROUP_ID_MAX	USHRT_MAX
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 354a2d294f52..1735d1d95652 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2249,6 +2249,17 @@ static struct ctl_table vm_table[] = {
 		.extra2		= (void *)&mmap_rnd_compat_bits_max,
 	},
 #endif
+#ifdef CONFIG_MEMCG
+	{
+		.procname	= "recharge_offline_memcgs",
+		.data		= &sysctl_recharge_offline_memcgs,
+		.maxlen		= sizeof(sysctl_recharge_offline_memcgs),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif /* CONFIG_MEMCG */
 	{ }
 };
 
diff --git a/mm/Kconfig b/mm/Kconfig
index 09130434e30d..9462c4b598d9 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1236,6 +1236,18 @@ config LOCK_MM_AND_FIND_VMA
 	bool
 	depends on !STACK_GROWSUP
 
+config MEMCG_RECHARGE_OFFLINE_ENABLED
+	bool "Recharge memory charged to offline memcgs"
+	depends on MEMCG
+	help
+	  When a memory cgroup is removed by userspace, try to recharge any
+	  memory still charged to it to avoid having it live on as an offline
+	  memcg. Offline memcgs potentially consume memory and limit scalability
+	  of some operations.
+
+	  This option enables the above behavior by default. It can be override
+	  at runtime through /proc/sys/vm/recharge_offline_memcgs.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2fe9c6f1be80..25cdb17eaaa3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -96,6 +96,9 @@ static bool cgroup_memory_nobpf __ro_after_init;
 static DECLARE_WAIT_QUEUE_HEAD(memcg_cgwb_frn_waitq);
 #endif
 
+int sysctl_recharge_offline_memcgs __read_mostly = IS_ENABLED(
+		CONFIG_MEMCG_RECHARGE_OFFLINE_ENABLED);
+
 static struct workqueue_struct *memcg_recharge_wq;
 
 /* Whether legacy memory+swap accounting is active */
@@ -6592,7 +6595,8 @@ static void memcg_recharge_mapped_folios(struct mem_cgroup *memcg)
 	INIT_DELAYED_WORK(&memcg->recharge_mapped_work.dwork,
 			  memcg_do_recharge_mapped_folios);
 
-	if (memcg_recharge_wq && memcg_nr_local_mapped_pages(memcg)) {
+	if (sysctl_recharge_offline_memcgs &&
+	    memcg_recharge_wq && memcg_nr_local_mapped_pages(memcg)) {
 		memcg->recharge_mapped_work.retries = 0;
 		queue_delayed_work(memcg_recharge_wq,
 				   &memcg->recharge_mapped_work.dwork, 0);
@@ -6605,6 +6609,9 @@ static bool should_do_deferred_recharge(struct folio *folio)
 	struct mem_cgroup *memcg;
 	bool ret;
 
+	if (!sysctl_recharge_offline_memcgs)
+		return false;
+
 	rcu_read_lock();
 	memcg = folio_memcg_rcu(folio);
 	ret = memcg && !!(memcg->css.flags & CSS_DYING);
-- 
2.41.0.255.g8b1d071c50-goog


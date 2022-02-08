From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 3/4] mm/page_owner: Print memcg information
Date: Mon,  7 Feb 2022 19:05:31 -0500
Message-ID: <20220208000532.1054311-4-longman@redhat.com>
References: <20220208000532.1054311-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644278801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PV5Mmr2VlS4HwOkDqkagpZEdfNnA+PNHZfxNlSNeOwY=;
        b=GC6E6xQHb4qhRiUBgAM/MTDp2yeJ1zGBTGApe1wdDvdlzv+gUYJ2LcPycAm/cgbsphhaZ6
        OVwKfzG5yxDX8bggYF0/Tm+V9uykFfirsYvGrZv6OeHgDISLfAn5OuVuIqVHPOn0E8ig86
        PYWpH2e1epIsvw5FLOJ4gzb6q0e2Rgg=
In-Reply-To: <20220208000532.1054311-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Rapoport <rppt-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>

It was found that a number of dying memcgs were not freed because
they were pinned by some charged pages that were present. Even "echo 1 >
/proc/sys/vm/drop_caches" wasn't able to free those pages. These dying
but not freed memcgs tend to increase in number over time with the side
effect that percpu memory consumption as shown in /proc/meminfo also
increases over time.

In order to find out more information about those pages that pin
dying memcgs, the page_owner feature is extended to print memory
cgroup information especially whether the cgroup is dying or not.
RCU read lock is taken when memcg is being accessed to make sure
that it won't be freed.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Acked-by: Mike Rapoport <rppt-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
---
 mm/page_owner.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 28dac73e0542..d4c311455753 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -10,6 +10,7 @@
 #include <linux/migrate.h>
 #include <linux/stackdepot.h>
 #include <linux/seq_file.h>
+#include <linux/memcontrol.h>
 #include <linux/sched/clock.h>
 
 #include "internal.h"
@@ -325,6 +326,47 @@ void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 	seq_putc(m, '\n');
 }
 
+/*
+ * Looking for memcg information and print it out
+ */
+static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
+					 struct page *page)
+{
+#ifdef CONFIG_MEMCG
+	unsigned long memcg_data;
+	struct mem_cgroup *memcg;
+	bool dying;
+
+	rcu_read_lock();
+	memcg_data = READ_ONCE(page->memcg_data);
+	if (!memcg_data)
+		goto out_unlock;
+
+	if (memcg_data & MEMCG_DATA_OBJCGS)
+		ret += scnprintf(kbuf + ret, count - ret,
+				"Slab cache page\n");
+
+	memcg = page_memcg_check(page);
+	if (!memcg)
+		goto out_unlock;
+
+	dying = (memcg->css.flags & CSS_DYING);
+	ret += scnprintf(kbuf + ret, count - ret,
+			"Charged %sto %smemcg ",
+			PageMemcgKmem(page) ? "(via objcg) " : "",
+			dying ? "dying " : "");
+
+	/* Write cgroup name directly into kbuf */
+	cgroup_name(memcg->css.cgroup, kbuf + ret, count - ret);
+	ret += strlen(kbuf + ret);
+	ret += scnprintf(kbuf + ret, count - ret, "\n");
+out_unlock:
+	rcu_read_unlock();
+#endif /* CONFIG_MEMCG */
+
+	return ret;
+}
+
 static ssize_t
 print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 		struct page *page, struct page_owner *page_owner,
@@ -365,6 +407,8 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 			migrate_reason_names[page_owner->last_migrate_reason]);
 	}
 
+	ret = print_page_owner_memcg(kbuf, count, ret, page);
+
 	ret += snprintf(kbuf + ret, count - ret, "\n");
 	if (ret >= count)
 		goto err;
-- 
2.27.0


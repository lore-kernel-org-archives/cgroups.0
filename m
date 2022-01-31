From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 3/4] mm/page_owner: Print memcg information
Date: Mon, 31 Jan 2022 14:23:07 -0500
Message-ID: <20220131192308.608837-4-longman@redhat.com>
References: <20220131192308.608837-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643657013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AqKO5lknN2+Nsr0yWLMZlCagaD5YFaBIvpU1YV0vjJ8=;
        b=D5HLeURrdhU7FmHdatBQz2nXIU/paVkcnKNrmYr7x6cyBCsqvRlnlzKJSZKENfKsV/8Hce
        4Sf/23xr9hAOFaK7MpItlMXai9OCwvRw5lQf3YW78dh3hsfqZgJJNDUwDsWqCHqinJ3B4U
        xzoQ+uyYhiysfdaNt4lkdenE7pR4bjE=
In-Reply-To: <20220131192308.608837-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

It was found that a number of offlined memcgs were not freed because
they were pinned by some charged pages that were present. Even "echo
1 > /proc/sys/vm/drop_caches" wasn't able to free those pages. These
offlined but not freed memcgs tend to increase in number over time with
the side effect that percpu memory consumption as shown in /proc/meminfo
also increases over time.

In order to find out more information about those pages that pin
offlined memcgs, the page_owner feature is extended to print memory
cgroup information especially whether the cgroup is offlined or not.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/page_owner.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 28dac73e0542..a471c74c7fe0 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -10,6 +10,7 @@
 #include <linux/migrate.h>
 #include <linux/stackdepot.h>
 #include <linux/seq_file.h>
+#include <linux/memcontrol.h>
 #include <linux/sched/clock.h>
 
 #include "internal.h"
@@ -325,6 +326,42 @@ void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 	seq_putc(m, '\n');
 }
 
+#ifdef CONFIG_MEMCG
+/*
+ * Looking for memcg information and print it out
+ */
+static inline void print_page_owner_memcg(char *kbuf, size_t count, int *pret,
+					  struct page *page)
+{
+	unsigned long memcg_data = READ_ONCE(page->memcg_data);
+	struct mem_cgroup *memcg;
+	bool onlined;
+	char name[80];
+
+	if (!memcg_data)
+		return;
+
+	if (memcg_data & MEMCG_DATA_OBJCGS)
+		*pret += scnprintf(kbuf + *pret, count - *pret,
+				"Slab cache page\n");
+
+	memcg = page_memcg_check(page);
+	if (!memcg)
+		return;
+
+	onlined = (memcg->css.flags & CSS_ONLINE);
+	cgroup_name(memcg->css.cgroup, name, sizeof(name));
+	*pret += scnprintf(kbuf + *pret, count - *pret,
+			"Charged %sto %smemcg %s\n",
+			PageMemcgKmem(page) ? "(via objcg) " : "",
+			onlined ? "" : "offlined ",
+			name);
+}
+#else /* CONFIG_MEMCG */
+static inline void print_page_owner_memcg(char *kbuf, size_t count, int *pret,
+					  struct page *page) { }
+#endif /* CONFIG_MEMCG */
+
 static ssize_t
 print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 		struct page *page, struct page_owner *page_owner,
@@ -365,6 +402,8 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 			migrate_reason_names[page_owner->last_migrate_reason]);
 	}
 
+	print_page_owner_memcg(kbuf, count, &ret, page);
+
 	ret += snprintf(kbuf + ret, count - ret, "\n");
 	if (ret >= count)
 		goto err;
-- 
2.27.0


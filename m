From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 3/3] mm/page_owner: Dump memcg information
Date: Sat, 29 Jan 2022 15:53:15 -0500
Message-ID: <20220129205315.478628-4-longman@redhat.com>
References: <20220129205315.478628-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643489634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=poPjjcFexMGp0K40SsFnRADO8VbhRo0jK19whIZnUJQ=;
        b=Zy/Z3ihjhNeS8iwaQHCQWt7LNXmR5CSO9Oigf0fs5yz5AA0AH8/HVoJZWrbXlCErFc7hO/
        A7PxOmpGpL4YDJKY4wqIAPOISXovKhZcQaLtGlYGmav55JLS6p1+bOtgYoL3p5SEIywVo0
        vslmjBbWCKBOoL0eQKdjzGElckzyulg=
In-Reply-To: <20220129205315.478628-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

It was found that a number of offlined memcgs were not freed because
they were pinned by some charged pages that were present. Even "echo
1 > /proc/sys/vm/drop_caches" wasn't able to free those pages. These
offlined but not freed memcgs tend to increase in number over time with
the side effect that percpu memory consumption as shown in /proc/meminfo
also increases over time.

In order to find out more information about those pages that pin
offlined memcgs, the page_owner feature is extended to dump memory
cgroup information especially whether the cgroup is offlined or not.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/page_owner.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 28dac73e0542..8dc5cd0fa227 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -10,6 +10,7 @@
 #include <linux/migrate.h>
 #include <linux/stackdepot.h>
 #include <linux/seq_file.h>
+#include <linux/memcontrol.h>
 #include <linux/sched/clock.h>
 
 #include "internal.h"
@@ -331,6 +332,7 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 		depot_stack_handle_t handle)
 {
 	int ret, pageblock_mt, page_mt;
+	unsigned long __maybe_unused memcg_data;
 	char *kbuf;
 
 	count = min_t(size_t, count, PAGE_SIZE);
@@ -365,6 +367,35 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 			migrate_reason_names[page_owner->last_migrate_reason]);
 	}
 
+#ifdef CONFIG_MEMCG
+	/*
+	 * Look for memcg information and print it out
+	 */
+	memcg_data = READ_ONCE(page->memcg_data);
+	if (memcg_data) {
+		struct mem_cgroup *memcg = page_memcg_check(page);
+		bool onlined;
+		char name[80];
+
+		if (memcg_data & MEMCG_DATA_OBJCGS)
+			ret += scnprintf(kbuf + ret, count - ret,
+					"Slab cache page\n");
+
+		if (!memcg)
+			goto copy_out;
+
+		onlined = (memcg->css.flags & CSS_ONLINE);
+		cgroup_name(memcg->css.cgroup, name, sizeof(name));
+		ret += scnprintf(kbuf + ret, count - ret,
+				"Charged %sto %smemcg %s\n",
+				PageMemcgKmem(page) ? "(via objcg) " : "",
+				onlined ? "" : "offlined ",
+				name);
+	}
+
+copy_out:
+#endif
+
 	ret += snprintf(kbuf + ret, count - ret, "\n");
 	if (ret >= count)
 		goto err;
-- 
2.27.0


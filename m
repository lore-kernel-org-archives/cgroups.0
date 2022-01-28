From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] mm/page_owner: Dump memcg information
Date: Fri, 28 Jan 2022 14:56:42 -0500
Message-ID: <20220128195642.416743-3-longman@redhat.com>
References: <20220128195642.416743-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643399850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gRdxpfrhDzN5J2ZCp0or9HoZYV0jMrufVKuIP+ZP2Uo=;
        b=NrSV1O1bMsCk0Xs3VBRP/14hM8Ca4UMEazRNGuVAMr35xBxJawatRqkKm3q0DJonQSC3Ul
        KvEEZiWVSDNTN8CFavKo8NWH01UQsXVfHMU98NMFeurptzwCs2nHWzFeZoQpOi8PZJk1zF
        QsavSGTdj5yMIyTHQ5eD5DjF4PzeH4g=
In-Reply-To: <20220128195642.416743-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

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
 mm/page_owner.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index c52ce9d6bc3b..e5d8c642296b 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -10,6 +10,7 @@
 #include <linux/migrate.h>
 #include <linux/stackdepot.h>
 #include <linux/seq_file.h>
+#include <linux/memcontrol.h>
 #include <linux/sched/clock.h>
 
 #include "internal.h"
@@ -339,6 +340,7 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 		depot_stack_handle_t handle)
 {
 	int ret = 0, pageblock_mt, page_mt;
+	unsigned long __maybe_unused memcg_data;
 	char *kbuf;
 
 	count = min_t(size_t, count, PAGE_SIZE);
@@ -371,6 +373,32 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 			"Page has been migrated, last migrate reason: %s\n",
 			migrate_reason_names[page_owner->last_migrate_reason]);
 
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
+			SNPRINTF(kbuf, count, ret, err, "Slab cache page\n");
+
+		if (!memcg)
+			goto copy_out;
+
+		onlined = (memcg->css.flags & CSS_ONLINE);
+		cgroup_name(memcg->css.cgroup, name, sizeof(name) - 1);
+		SNPRINTF(kbuf, count, ret, err, "Charged %sto %smemcg %s\n",
+			PageMemcgKmem(page) ? "(via objcg) " : "",
+			onlined ? "" : "offlined ", name);
+	}
+
+copy_out:
+#endif
+
 	SNPRINTF(kbuf, count, ret, err, "\n");
 
 	if (copy_to_user(buf, kbuf, ret))
-- 
2.27.0

